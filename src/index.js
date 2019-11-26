/* globals alert */
const weexSvg = {
  show () {
    alert('Module weexSvg is created sucessfully ');
  }
};

const meta = {
  weexSvg: [{
    lowerCamelCaseName: 'show',
    args: []
  }]
};

function init (weex) {
  weex.registerModule('weexSvg', weexSvg, meta);
}

export default {
  init: init
};
