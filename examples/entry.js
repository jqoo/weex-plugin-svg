import Vue from 'vue';

import weex from 'weex-vue-render';

import WeexPluginSvg from '../src/index';

weex.init(Vue);

weex.install(WeexPluginSvg)

const App = require('./index.vue');
App.el = '#root';
new Vue(App);
