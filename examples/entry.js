import Vue from 'vue';

import weex from 'weex-vue-render';

import WeexSvg from '../src/index';

weex.init(Vue);

weex.install(WeexSvg)

const App = require('./index.vue');
App.el = '#root';
new Vue(App);
