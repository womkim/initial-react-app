### React 安装整理

#### 环境配置

##### 使用 `create-react-app` 初始化应用

```sh
create-react-app react-demo
```

等待初始化完成。

##### 添加 `react` 开发基本需要的依赖包
- 路由使用 `react-router`
- 状态管理使用 `react-redux` ，中间件使用 `react-thunk`
- 另外使用 `antd` 库做为 UI 组件

```sh
yarn add react-router-dom redux react-redux redux-thunk antd
```

##### 使用 `react-app-rewired` 修改全局配置
我们希望在不进行 `eject` 的情况下修改 `react` 的配置，选择使用 `react-app-rewired` 库来实现，下载相关依赖包：

```sh
yarn add --dev react-app-rewired
```

修改 `package.json` 中的运行脚本

```diff
"scripts": {
-  "start": "react-scripts start",
+  "start": "react-app-rewired start",
-  "build": "react-scripts build",
+  "build": "react-app-rewired build",
-  "test": "react-scripts test --env=jsdom"
+  "test": "react-app-rewired test --env=jsdom"
},
```

在项目根目录下添加 `config-overrides.js` 文件，该文件为配置修改文件。文件中添加相关配置：如 `babel` `eslint` `webpack` 等全局配置，有些配置需要引入 `react-app-rewired` 相关库。

```
yarn add --dev react-app-rewire-less react-app-rewire-eslint
```

```js
const path = require('path')
const { injectBabelPlugin } = require('react-app-rewired')
const rewireLess = require('react-app-rewire-less')
const rewireEslint = require('react-app-rewire-eslint')

module.exports = function override (config, env) {
  // 修改 `babel` 相关配置，如：配置使用 `antd` 库
  config = injectBabelPlugin([
    'import',
    {
      libraryName: 'antd',
      style: true
    }
  ], config)

  // 修改 `antd` 主题（或其他样式）配置
  config = rewireLess.withLoaderOptions({
    modifyVars: {
      '@primary-color': '#ff9800',
      // 'link-color': '#1DA57A',
      // 'border-radius-base': '2px',
    }
  })(config, env)

  // 使用 `.eslintrc.js` 配置文件对代码进行格式检查
  config = rewireEslint(config, env)

  // 修改全局依赖，添加 `@` 为全局引用
  config.resolve = {
    ...config.resolve,
    alias: {
      ...config.resolve.alias,
      '@': path.join(__dirname, 'src')
    }
  }

  return config
}
```

上面的配置完成后添加 `babel-plugin-import` 库可以使antd组件按需加载

```sh
yarn add --dev babel-plugin-import
```

同时可以在配置里面修改自己需要的主题等样式配置。

##### 使用 `eslint` 的 `standard` 模式进行编码规范
（ps: 个人比较喜欢使用 `standard` 库） `standard` 库在当前（20180226） 11+ 版本会有点问题，这里使用 10+ 版本

下载 `eslint` 相关库

```sh
yarn add --dev eslint eslint-loader eslint-config-standard@10.2.1 eslint-plugin-standard eslint-plugin-promise eslint-plugin-import eslint-plugin-node eslint-plugin-react
```

在项目根目录下添加 `.eslintrc.js` 的配置文件，在里面添加相关配置：

```js
// http://eslint.org/docs/user-guide/configuring
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
}
```


下一篇：[项目结构说明](./project.md)
