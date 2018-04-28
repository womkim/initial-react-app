#!/usr/bin/env bash

if [ $# -lt 1 ]; then
    echo "error.. need args, please input your project name."
    exit 1
fi

yarn_version=`yarn -v`
if [ $? -ne 0 ];then
  npm install yarn -g &>> initial.log
  # exit 1
fi
cra_version=`create-react-app -V` 
if [ $? -ne 0 ];then
  npm install create-react-app -g &>> initial.log
  # exit 1
fi

echo -e '\n----------------------------------------------' &>> initial.log
echo "yarn version" &>> initial.log
yarn -v &>> initial.log
echo "create-react-app version" &>> initial.log
create-react-app -V &>> initial.log
echo -e '\nstart create react app...'
echo -e '\nstart create react app...' &>> initial.log

create-react-app $1 &>> initial.log
if [ $? -ne 0 ];then
  echo -e '\n failed! view more details in initial.log'
  exit 2
fi

echo -e '\ninitializing environment ...\n\n' &>> initial.log
cd ./$1/ &>> initial.log

yarn add react-router-dom redux react-redux redux-thunk antd &>> ../initial.log
if [ $? -ne 0 ];then
  echo -e '\n failed! view more details in initial.log'
  exit 3
fi

yarn add --dev react-app-rewired react-app-rewire-less react-app-rewire-eslint babel-plugin-import eslint-config-standard@10.2.1 eslint-plugin-standard eslint-plugin-promise eslint-plugin-import eslint-plugin-node eslint-plugin-react &>> ../initial.log
if [ $? -ne 0 ];then
  echo -e '\n failed! view more details in initial.log'
  exit 4
fi

echo -e '  -> configuring...\n'
echo -e '  -> configuring...\n' &>> ../initial.log

echo "const path = require('path')
const { injectBabelPlugin } = require('react-app-rewired')
const rewireLess = require('react-app-rewire-less')
const rewireEslint = require('react-app-rewire-eslint')

module.exports = function override (config, env) {
  // 修改 babel 相关配置，如：配置使用 antd 库
  config = injectBabelPlugin([
    'import',
    {
      libraryName: 'antd',
      style: true
    }
  ], config)

  // 修改 antd 主题（或其他样式）配置
  // https://github.com/ant-design/ant-design/blob/master/components/style/themes/default.less
  config = rewireLess.withLoaderOptions({
    modifyVars: {
      '@primary-color': '#ff9800',
      // 'link-color': '#1DA57A',
      // 'border-radius-base': '2px',
    }
  })(config, env)

  // 使用 .eslintrc.js 配置文件对代码进行格式检查
  config = rewireEslint(config, env)

  // 修改全局依赖，添加 @ 为全局引用
  config.resolve = {
    ...config.resolve,
    alias: {
      ...config.resolve.alias,
      '@': path.join(__dirname, 'src')
    }
  }

  return config
}" > config-overrides.js

echo -e '  -> configuring eslint...\n' &>> ../initial.log

echo "// http://eslint.org/docs/user-guide/configuring
module.exports = {
  root: true,
  parser: 'babel-eslint',
  parserOptions: {
    sourceType: 'module'
  },
  env: {
    browser: true,
  },
  // https://github.com/feross/standard/blob/master/RULES.md#javascript-standard-style
  extends: [
    'standard', // 使用 standard 标准库
  ],
  // add your custom rules here
  rules: {
    // allow paren-less arrow functions
    'arrow-parens': 'off',
    // allow async-await
    'generator-star-spacing': 'off',
    // allow debugger during development
    'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    'jsx-a11y/href-no-hash': 'off'
  }
}" > .eslintrc.js

sed -i "s/react-scripts start/react-app-rewired start/g" package.json &>> ../initial.log
sed -i "s/react-scripts build/react-app-rewired build/g" package.json &>> ../initial.log
sed -i "s/react-scripts test/react-app-rewired test/g" package.json &>> ../initial.log
rm -rf ./src &>> ../initial.log

echo -e '\n\ninitializing source filesystem...\n\n' &>> ../initial.log

echo -e '  -> create source folder...\n'
mkdir src
cd src/

echo -e '  -> create [assets|pages|router|store|utils] folders in  => src/ ...\n'
mkdir assets components pages router store utils

echo -e '  -> create [entry file -> index.js] in  => src/ ...\n'
# touch index.js
echo "import React from 'react'
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
)" > index.js

echo -e '  -> create [fonts|images|styles] folders in  => src/assets/ ...\n'
cd assets/
mkdir fonts images styles

echo -e '  -> create ["index.less"] file in  => src/assets/styles/ ...\n'
cd styles/
touch index.less

echo -e '  -> create [demo pages] in  => src/pages/ ...\n'
cd ../../pages/
# touch App.js Hello.js
mkdir App Hello
# touch index.js

# echo "import React from 'react'

# import App from './App/App'
# import Hello from './Hello/Hello'

# export default {
#   App,
#   Hello
# }
# " > index.js

cd App
echo "import React from 'react'
import { connect } from 'react-redux'
import { Link } from 'react-router-dom'
import { Button, Input, List } from 'antd'

import { INCREASE, DECREASE, LOADREDDIT } from '@/utils/constants'
import './App.less'

class App extends React.Component {
  state = {
    site: ''
  }

  componentDidMount () {

  }

  fetchData = (site) => {
    const { dispatch } = this.props
    if (!site) {
      return
    }
    const url = \`https://www.reddit.com/r/\${site}.json\`
    fetch(url)
      .then(res => res.json())
      .then(data => {
        console.log(data)
        dispatch({ type: LOADREDDIT, data: data.data.children })
      })
      .catch(e => {
        console.log(e)
        dispatch({ type: LOADREDDIT, data: [] })
      })
  }

  render () {
    const { dispatch, app } = this.props
    return (
      <div className=\"m-container\">
        <Link to={'/hello'}>link to hello</Link>
        <div className=\"m-container--item\">
          <Button type={'primary'} onClick={() => { dispatch({ type: DECREASE }) }}>-</Button>
          {app.value}
          <Button type={'default'} onClick={() => { dispatch({ type: INCREASE }) }}>+</Button>
        </div>
        <div className=\"m-container--item\">
          <Input
            style={{marginRight: '16px', width: '200px'}}
            value={this.state.site}
            onChange={e => { this.setState({ site: e.target.value }) }}
            onPressEnter={() => { this.fetchData(this.state.site) }}
          />
          <Button type={'primary'} onClick={() => { this.fetchData(this.state.site) }}>click</Button>
        </div>
        <div className=\"m-container--item\">
          <List
            header={<h3>news: </h3>}
            bordered
            dataSource={app.reddit}
            renderItem={item => (<List.Item>{item.data.title}</List.Item>)}
          />
        </div>
      </div>
    )
  }
}

const mapStateToProps = ({ app }) => ({ app })

export default connect(mapStateToProps)(App)" > App.js

echo "body{
  background-color: #f8f8f8;
}
.m-container{
  margin: 20px auto;
  width: 960px;
  .m-container--item{
    margin-top: 20px;
  }
}" > App.less

cd ../Hello

echo "import React from 'react'
import { Link } from 'react-router-dom'

const PageNotFound = () => <div><h3>Hello World, welcome to react page. </h3><Link to={'/'}>back home</Link></div>

export default PageNotFound" > Hello.js

echo -e '  -> create ["AsyncComponent.js", "index.js"] in  => src/router/ ...\n'
cd ../../router/
# touch AsyncComponent.js index.js
echo "// https://segmentfault.com/a/1190000009539836
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
}" > AsyncComponent.js

echo "import React from 'react'
import { Router, Route, Switch } from 'react-router-dom'

import createBrowserHistory from 'history/createBrowserHistory'
import AsyncComponent from './AsyncComponent'

const history = createBrowserHistory()
const supportsHistory = 'pushState' in window.history

const router = () => (
  <Router history={history} forceRefresh={!supportsHistory}>
    <Switch>
      <Route exact path={'/'} component={AsyncComponent(() => import('@/pages/App/App'))} />
      <Route exact path={'/hello'} component={AsyncComponent(() => import('@/pages/Hello/Hello'))} />
    </Switch>
  </Router>
)

export default router" > index.js

echo -e '  -> create ["app.js", "index.js"] in  => src/store/ ...\n'
cd ../store/
# touch app.js index.js
echo "import { combineReducers } from 'redux'
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
})" > app.js

echo "import { createStore, applyMiddleware, compose, combineReducers } from 'redux'
import thunk from 'redux-thunk'

import app from '@/store/app'

const reducer = combineReducers({
  app
})

const middleware = [ thunk ]

const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose

const store = createStore(reducer, composeEnhancers(applyMiddleware(...middleware)))

export default store" > index.js

echo -e '  -> create ["constants.js", "config.js", "util.js"] in  => src/utils/ ...\n'
cd ../utils/
touch constants.js config.js util.js
echo "export const INCREASE = 'increase'
export const DECREASE = 'decrease'

export const CHANGENAME = 'change-name'

export const LOADREDDIT = 'load-reddit'" > constants.js
cd ../../../

echo -e '\nsimple file system have initialized...\n' &>> initial.log
echo -e '\nsimple file system have initialized...\n'
echo -e 'done.\n' &>> initial.log
echo -e 'done.\n'

