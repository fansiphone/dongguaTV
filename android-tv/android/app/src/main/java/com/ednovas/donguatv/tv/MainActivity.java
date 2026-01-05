package com.ednovas.donguatv.tv;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;

/**
 * MainActivity for E视界TV
 * 
 * 注意：当前使用系统 WebView。
 * GeckoView 库已包含在 APK 中，但 @web-media/capacitor-geckoview 插件
 * 不提供可用的 GeckoBridgeActivity 类。
 * 
 * 如果需要真正使用 GeckoView，需要：
 * 1. 找到或编写自定义的 GeckoView Bridge 集成
 * 2. 或使用其他 GeckoView Capacitor 插件
 */
public class MainActivity extends BridgeActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }
}

