package com.ednovas.donguatv.tv;

import android.os.Bundle;
import android.util.Log;
import com.getcapacitor.BridgeActivity;

/**
 * MainActivity for E视界TV
 * 
 * 注意：当前使用系统 WebView 或 GeckoView（取决于构建配置）。
 * GeckoView 库通过 @web-media/capacitor-geckoview 插件引入。
 */
public class MainActivity extends BridgeActivity {

    private static final String TAG = "E视界TV";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        try {
            Log.d(TAG, "🚀 onCreate 开始");
            Log.d(TAG, "📱 设备信息: " + android.os.Build.MANUFACTURER + " " + android.os.Build.MODEL);
            Log.d(TAG, "📱 Android 版本: " + android.os.Build.VERSION.RELEASE + " (API " + android.os.Build.VERSION.SDK_INT + ")");
            
            super.onCreate(savedInstanceState);
            
            Log.d(TAG, "✅ BridgeActivity onCreate 完成");
            
            // 检测 WebView 类型（通过检查 Bridge 的 WebView 类名）
            try {
                Object webView = getBridge().getWebView();
                if (webView != null) {
                    String webViewClassName = webView.getClass().getName();
                    boolean isGeckoView = webViewClassName.contains("Gecko") || webViewClassName.contains("gecko");
                    Log.d(TAG, "🌐 WebView 类型: " + webViewClassName);
                    Log.d(TAG, "🌐 是否 GeckoView: " + (isGeckoView ? "是 🦎" : "否 (System WebView)"));
                }
            } catch (Exception e) {
                Log.w(TAG, "⚠️ 无法获取 WebView 信息: " + e.getMessage());
            }
            
        } catch (Exception e) {
            Log.e(TAG, "❌ onCreate 发生致命错误", e);
            e.printStackTrace();
            throw e; // 重新抛出以显示崩溃对话框
        }
    }
    
    @Override
    public void onStart() {
        try {
            Log.d(TAG, "🚀 onStart 开始");
            super.onStart();
            Log.d(TAG, "✅ onStart 完成");
        } catch (Exception e) {
            Log.e(TAG, "❌ onStart 发生错误", e);
            e.printStackTrace();
        }
    }
    
    @Override
    public void onResume() {
        try {
            Log.d(TAG, "🚀 onResume 开始");
            super.onResume();
            Log.d(TAG, "✅ onResume 完成");
        } catch (Exception e) {
            Log.e(TAG, "❌ onResume 发生错误", e);
            e.printStackTrace();
        }
    }
}

