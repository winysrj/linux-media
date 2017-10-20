Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:44908 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdJTTTS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 15:19:18 -0400
From: Pierre-Hugues Husson <phh@phh.me>
To: linux-rockchip@lists.infradead.org
Cc: heiko@sntech.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux@armlinux.org.uk, Pierre-Hugues Husson <phh@phh.me>
Subject: [PATCH v2] drm: bridge: synopsys/dw-hdmi: Enable cec clock
Date: Fri, 20 Oct 2017 21:18:38 +0200
Message-Id: <20171020191838.392-1-phh@phh.me>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation already mentions "cec" optional clock, but
currently the driver doesn't enable it.

Changes:
v2:
- Separate ENOENT errors from others
- Propagate other errors (especially -EPROBE_DEFER)

Signed-off-by: Pierre-Hugues Husson <phh@phh.me>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index bf14214fa464..b31fc95d5fef 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -138,6 +138,7 @@ struct dw_hdmi {
 	struct device *dev;
 	struct clk *isfr_clk;
 	struct clk *iahb_clk;
+	struct clk *cec_clk;
 	struct dw_hdmi_i2c *i2c;
 
 	struct hdmi_data_info hdmi_data;
@@ -2382,6 +2383,27 @@ __dw_hdmi_probe(struct platform_device *pdev,
 		goto err_isfr;
 	}
 
+	hdmi->cec_clk = devm_clk_get(hdmi->dev, "cec");
+	if (PTR_ERR(hdmi->cec_clk) == -ENOENT) {
+		hdmi->cec_clk = NULL;
+	} else if (IS_ERR(hdmi->cec_clk)) {
+		ret = PTR_ERR(hdmi->cec_clk);
+		if (ret != -EPROBE_DEFER) {
+			dev_err(hdmi->dev, "Cannot get HDMI cec clock: %d\n",
+					ret);
+		}
+
+		hdmi->cec_clk = NULL;
+		goto err_iahb;
+	} else {
+		ret = clk_prepare_enable(hdmi->cec_clk);
+		if (ret) {
+			dev_err(hdmi->dev, "Cannot enable HDMI cec clock: %d\n",
+					ret);
+			goto err_iahb;
+		}
+	}
+
 	/* Product and revision IDs */
 	hdmi->version = (hdmi_readb(hdmi, HDMI_DESIGN_ID) << 8)
 		      | (hdmi_readb(hdmi, HDMI_REVISION_ID) << 0);
@@ -2518,6 +2540,8 @@ __dw_hdmi_probe(struct platform_device *pdev,
 		cec_notifier_put(hdmi->cec_notifier);
 
 	clk_disable_unprepare(hdmi->iahb_clk);
+	if (hdmi->cec_clk)
+		clk_disable_unprepare(hdmi->cec_clk);
 err_isfr:
 	clk_disable_unprepare(hdmi->isfr_clk);
 err_res:
@@ -2541,6 +2565,8 @@ static void __dw_hdmi_remove(struct dw_hdmi *hdmi)
 
 	clk_disable_unprepare(hdmi->iahb_clk);
 	clk_disable_unprepare(hdmi->isfr_clk);
+	if (hdmi->cec_clk)
+		clk_disable_unprepare(hdmi->cec_clk);
 
 	if (hdmi->i2c)
 		i2c_del_adapter(&hdmi->i2c->adap);
-- 
2.14.1
