### React Install（[点我查看中文文档](install.ZH.md)）

#### Environmental configuration

##### use `create-react-app` Initialize the application

```sh
create-react-app react-demo
```

Waiting for initialization to complete。

##### add `react` Develop basic dependencies
- Route use `react-router`
- State management use `react-redux` ，中间件使用 `react-thunk`
- Also use the `antd` library as a UI component

```sh
yarn add react-router-dom redux react-redux redux-thunk antd
```

##### use `react-app-rewired` Modify global configuration
We want to modify the `react` configuration without `eject`, choose to use the `react-app-rewired` library, and download the relevant dependencies:

```sh
yarn add --dev react-app-rewired
```

edit `package.json` running script

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

Add the `config-overrides.js` file to the project root directory, which is the configuration modification file. Add related configuration to the file: global configuration such as `babel` `eslint` `webpack`, some configurations need to introduce `react-app-rewired` related library.

```
yarn add --dev react-app-rewire-less react-app-rewire-eslint
```

```js
const path = require('path')
const { injectBabelPlugin } = require('react-app-rewired')
const rewireLess = require('react-app-rewire-less')
const rewireEslint = require('react-app-rewire-eslint')

module.exports = function override (config, env) {
  // Modify `babel` related configuration, such as: configuration using `antd` library
  config = injectBabelPlugin([
    'import',
    {
      libraryName: 'antd',
      style: true
    }
  ], config)

  // Modify the `antd` theme (or other style) configuration
  config = rewireLess.withLoaderOptions({
    modifyVars: {
      '@primary-color': '#ff9800',
      // 'link-color': '#1DA57A',
      // 'border-radius-base': '2px',
    }
  })(config, env)

  // Format the code using the `.eslintrc.js` configuration file
  config = rewireEslint(config, env)

  // Modify global dependencies, add `@` as a global reference
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

Adding the `babel-plugin-import` library after the above configuration is complete can make the antd component load on demand.

```sh
yarn add --dev babel-plugin-import
```

At the same time, you can modify the style configuration of the theme you need in the configuration.

##### Encoding specification using `eslint` `standard` mode
（ps: Personally prefer to use the `standard` library) `standard` library in the current (20180226) 11+ version will be a bit problem, here use the 10+ version

Download `eslint` related library

```sh
yarn add --dev eslint eslint-loader eslint-config-standard@10.2.1 eslint-plugin-standard eslint-plugin-promise eslint-plugin-import eslint-plugin-node eslint-plugin-react
```

Add the configuration file `.eslintrc.js` in the project root directory and add the relevant configuration in it:

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
    'standard', // Use standard standard library
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


Next: [Project Structure Description] (./project.md)
