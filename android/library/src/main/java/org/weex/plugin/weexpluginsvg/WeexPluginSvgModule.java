package org.weex.plugin.weexpluginsvg;

import android.util.Log;
import android.widget.Toast;

import com.alibaba.weex.plugin.annotation.WeexModule;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXModule;

@WeexModule(name = "weexPluginSvg")
public class WeexPluginSvgModule extends WXModule {

    private static final String TAG = "WeexPluginSvgModule";

    //sync ret example
    //TODO: Auto-generated method example
    @JSMethod (uiThread = true)
    public String syncRet(String param) {
        return param;
    }

    //async ret example
    //TODO: Auto-generated method example
    @JSMethod (uiThread = true)
    public void asyncRet(String param, JSCallback callback) {
        callback.invoke(param);
    }

    @JSMethod (uiThread = true)
    public void show() {
        Log.d(TAG, "Showing!!!");
        Toast.makeText(mWXSDKInstance.getContext(),"Module weexPluginSvg is created sucessfully ",Toast.LENGTH_SHORT).show();
    }
}