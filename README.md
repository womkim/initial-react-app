## initial-react-app （[点我查看中文文档](README.ZH.md)）

For the sake of simplicity, we will automatically initialize a `react` project that uses `antd`.

Just download the [`initial-react-app.sh`](https://github.com/womkim/initial-react-app/archive/master.zip) script from this project and save it to the directory where you need to create a new project. , the command runs the script and waits for the project to be initialized to run the project.

**Pay attention before use：**
- Please make sure there is a `node` environment on your computer.
- Please ensure global `npm` write permission, current directory write file permissions
- Please ensure that the network is unblocked
- Running in `shell` environment

Use the command: (remember to enter the project name, here `project-name` is just an example)

```sh
./initial-react-app.sh project-name
```

After the project is initialized, enter the project directory and run the project directly:

```
cd ./project-name && yarn start
```


#### Project configuration includes：
- use `react-router-dom`
- use `redux`
- use `redux-thunk` middleware
- use `antd` library，And already configured **Load on demand** and **Custom theme**
- use `eslint` [`standard`](https://github.com/feross/standard/blob/master/RULES.md#javascript-standard-style) Library specification code
- use `less` Precompiled language

#### More instructions：
- [React Installation and finishing](./install.md)
- [Project structure description](./project.md)
