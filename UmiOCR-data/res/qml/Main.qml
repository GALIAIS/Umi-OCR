// =====================================
// =============== 主窗口 ===============
// =====================================

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import Qt.labs.settings 1.1

import "Themes"
import "TabView_"
import "Configs"
import "Popup_"
import "TabPages/GlobalConfigsPage"

Window {
// ApplicationWindow {
    // id: rootWindow
    visible: true
    // flags: Qt.Window | Qt.FramelessWindowHint // 无边框窗口，保留任务栏图标

    width: 800
    height: 500
    minimumWidth: 600
    minimumHeight: 400

    color: "#00000000"

    // ========================= 【控制】 =========================

    // 全局样式，通过 theme 来访问
    property Theme theme: ThemeLight{}

    // 全局单例，通过 app. 来访问
    Item {
        id: app

        Item { // 全局延迟加载 初始化函数列表
            // qml中，组件初始化顺序是从上到下，而onCompleted调用顺序相反。
            // 故这个组件的onCompleted将是全局最后一个调用的。
            // 将各个组件的初始化函数放在这里，可以保证其他组件都已经构建完毕。
            id: initFuncs
            property var list: []
            property bool isComplete: false
            function push(f) { // 添加一个要延迟加载的函数。若当前全局已初始化，则直接执行
                if(isComplete) f()
                else list.push(f)
            }
            Component.onCompleted: { // 全局初始化完毕，执行延迟加载的函数
                isComplete = true
                console.log("% 开始执行 延迟加载初始化函数！")
                for(let i in list) list[i]()
            }
        }
        
        GlobalConfigs { id: globalConfigs }  // 全局设置 app.globalConfigs
        ThemeManager { id: themeManager } // 主题管理器 app.themeManager
        TabViewManager { id: tab }  // 标签页逻辑管理器 app.tab
        PopupManager { id: popupManager }  // 弹窗管理器 app.popupManager

        property alias initFuncs: initFuncs
        property alias globalConfigs: globalConfigs
        property alias themeManager: themeManager
        property alias tab: tab
        property alias popupManager: popupManager
    }

    // ========================= 【布局】 =========================

    // 主窗口的容器，兼做边框
    Rectangle {
        id: mainContainer
        anchors.fill: parent
        color: "#00000000"
        radius: theme.windowRadius // 窗口圆角

        // 主窗口的内容
        Rectangle {
            id: mainUI
            anchors.fill: parent
            anchors.margins: 0 // 透明边框宽度

            color: theme.bgColor // 整个窗口的背景颜色
            radius: theme.windowRadius // 窗口圆角

            // 标签视图
            TabView_ { }

            // 裁切子元素，并应用圆角
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: mainUI.width
                    height: mainUI.height
                    radius: theme.windowRadius
                }
            }
        }
    }
}