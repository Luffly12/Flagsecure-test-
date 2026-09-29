package fun.test.flagsecure;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

public class MainActivity extends Activity {
    private boolean secure = true;
    private TextView tv;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(60, 160, 60, 60);
        root.setBackgroundColor(Color.parseColor("#0E1116"));

        tv = new TextView(this);
        tv.setTextColor(Color.WHITE);
        tv.setTextSize(18);
        root.addView(tv);

        Button btn = new Button(this);
        btn.setText("切换 安全 / 非安全");
        btn.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                secure = !secure;
                applySecure();
            }
        });
        root.addView(btn);

        applySecure();
        setContentView(root);
    }

    private void applySecure() {
        if (secure) {
            getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE,
                    WindowManager.LayoutParams.FLAG_SECURE);
        } else {
            getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
        }
        if (tv != null) {
            tv.setText("FLAG_SECURE 测试\n\n当前模式："
                    + (secure ? "安全窗口（SECURE）" : "普通窗口（NON-SECURE）")
                    + "\n\n用系统截图（电源键 + 音量下）截本页：\n"
                    + (secure
                        ? "· 截图全黑 → FLAG_SECURE 正在生效\n· 能拍到这段文字 → 保护已被解除"
                        : "· 能拍到这段文字 → 正常（非安全对照）"));
        }
    }
}
