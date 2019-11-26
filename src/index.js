/* globals alert */
const weexPluginSvg = {
  show () {
    alert('Module weexPluginSvg is created sucessfully ');
  }
};

const meta = {
  weexPluginSvg: [{
    lowerCamelCaseName: 'show',
    args: []
  }]
};

function init (weex) {
  weex.registerModule('weexPluginSvg', weexPluginSvg, meta);
}

export default {
  init: init
};
