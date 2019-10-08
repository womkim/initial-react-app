### 项目结构说明

#### 项目目录配置

```sh
  |~
  |-- node_modules // 依赖库
  |-- doc // 说明文档
  |-- public // 打包发布目录
  |-- src // 项目源文件
      |
      |-- assets // 开发过程中的资源文件
          |-- fonts // 字体资源
          |-- images // 图片资源
          |-- styles // 引入的样式资源
      |
      |-- components // 组件模块
      |
      |-- pages // 项目相关页面
      |
      |-- router // 路由定义
          |-- AsyncComponent.js // 实现模块异步加载
          |-- index.js // 定义路由（作为统一导出配置）
      |
      |-- store // 状态管理（使用 `redux`）
          |-- app.js // 全局状态
          |-- index.js // 加载所有reducer，应用中间件等，状态管理统一配置文件（作为统一导出配置）
      |
      |-- utils // 项目工具文件，包括自定义方法模块，项目配置等
          |-- config.js // 项目全局配置文件，包括全局颜色、应用名称、API等应用信息
          |-- constants // 全局常量配置（避免字符串拼写不一致问题）
          |-- util.js // 自定义方法模块
      |
      |-- index.js // 项目总入口
      |
  |-- .eslintrc.js // eslint配置文件
  |-- .gitignore // git仓库忽略配置
  |-- config-override.js // 自定义全局配置文件
  |-- package.json // 项目npm包配置
  |-- README.md // readme项目说明文件
  |
  |~
```


#### 项目入口配置
在项目中配置 `redux` 、 `router` 相关信息，并可以引入全局自定义样式文件，以下是初始化时主要文件代码

- 总入口文件： `src/index.js`

```jsx

import React from 'react'
import { render } from 'react-dom'
import { Provider } from 'react-redux'

import Router from '@/router'
import store from '@/store'

import '@/assets/styles/index.less'

render(
  <Provider store={store}>
    <Router />
  </Provider>,
  document.getElementById('root')
)

```


- 在 `router` 中设置组件异步加载： `src/router/AsyncComponent.js`

```js

import React from 'react'

export default function asyncComponent (importComponent) {
  class AsyncComponent extends React.Component {
    state = {
      component: null
    }
    hasState = true

    async componentDidMount () {
      const { default: component } = await importComponent()
      this.hasState && this.setState({ component })
    }

    render () {
      const C = this.state.component
      return C ? <C {...this.props} /> : null
    }

    componentWillUnmount () {
      this.hasState = false
    }
  }

  return AsyncComponent
}

```

- 路由配置入口：`src/router/index.js`

```js

import React from 'react'
import { Router, Route, Switch } from 'react-router-dom'

import createBrowserHistory from 'history/createBrowserHistory'
import AsyncComponent from './AsyncComponent'

const history = createBrowserHistory()
const supportsHistory = 'pushState' in window.history

const router = () => (
  <Router history={history} forceRefresh={!supportsHistory}>
    <Switch>
      <Route exact path={'/'} component={AsyncComponent(() => import('@/pages/App'))} />
      <Route exact path={'/hello'} component={AsyncComponent(() => import('@/pages/Hello'))} />
    </Switch>
  </Router>
)

export default router

```

- 全局状态管理，当前应用状态：`src/store/app.js` （示例）

```js

import { combineReducers } from 'redux'
import {
  INCREASE,
  DECREASE,
  LOADREDDIT
} from '@/utils/constants'

/**
 * initial state
 */
const app = {
  value: 0,
  reddit: []
}

/**
 * reduce values
 */

const value = (state = app.value, action) => {
  switch (action.type) {
    case INCREASE:
      return state + 1
    case DECREASE:
      return state - 1
    default:
      return state
  }
}

const reddit = (state = app.reddit, action) => {
  if (action.type === LOADREDDIT) {
    return action.data
  }
  return state
}

export default combineReducers({
  value,
  reddit
})

```

- `redux` 相关配置，导出所有全局状态： `src/store/index.js`

```js

import { createStore, applyMiddleware, compose, combineReducers } from 'redux'
import thunk from 'redux-thunk'

import app from '@/store/app'

// 导出所有状态内容
const reducer = combineReducers({
  app
})

const middleware = [ thunk ]

const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose

const store = createStore(reducer, composeEnhancers(applyMiddleware(...middleware)))

export default store

```

- 全局常量设置：`src/utils/constants.js` （示例）

```js

export const INCREASE = 'increase'
export const DECREASE = 'decrease'

export const CHANGENAME = 'change-name'

export const LOADREDDIT = 'load-reddit'

```


上一篇：[React安装整理](./install.md)
