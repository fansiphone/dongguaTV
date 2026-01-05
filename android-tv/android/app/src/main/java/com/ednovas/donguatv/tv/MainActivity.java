package com.ednovas.donguatv.tv;

import android.os.Bundle;
// 使用 GeckoView 版本的 BridgeActivity
import com.nicepkg.nicepkg.capacitor_geckoview.GeckoBridgeActivity;

/**
 * MainActivity for E视界TV (GeckoView 版本)
 * 
 * 这个版本使用 GeckoView 替代系统 WebView，
 * 解决老旧电视盒子上的 WebView 兼容性问题。
 * 
 * 继承自 GeckoBridgeActivity 而不是 BridgeActivity，
 * 这样 Capacitor 会使用 GeckoView 来渲染网页。
 */
public class MainActivity extends GeckoBridgeActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // GeckoView 自动处理大部分兼容性问题
        // 不需要额外的 WebView 配置
    }
}
