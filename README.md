## initial-react-app

为了简便操作，我们将自动初始化一个使用 `antd` 的 `react` 项目。

只需下载本项目中的 [`initial-react-app.sh`](https://github.com/womkim/initial-react-app/archive/master.zip) 脚本保存到需要新建项目的目录下，命令运行该脚本，等待项目初始化完成便可运行项目。

**使用前注意：**
- 请确保电脑上有 `node` 环境，并已安装 `yarn`
- 请确保全局 `npm` 写权限，当前目录写文件权限
- 请确保网络畅通

使用命令：（记得输入项目名称，这里 `project-name` 只是示例）

```sh
./initial-react-app.sh project-name
```

项目初始化完成后，进入到项目目录，可以直接运行项目：

```
cd ./project-name && yarn start
```


#### 项目配置包括：
- 使用 `react-router-dom`
- 使用 `redux`
- 使用 `redux-thunk` 中间件
- 使用 `antd` 库，并已经配置好**按需加载**和**自定义主题**
- 使用 `eslint` 的 [`standard`](https://github.com/feross/standard/blob/master/RULES.md#javascript-standard-style) 库规范代码
- 使用 `less` 预编译语言

#### 更多说明：
- [React 安装整理](./install.md)
- [项目结构说明](./project.md)
