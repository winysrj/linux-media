Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:45511 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab2JDHZJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 03:25:09 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBC00LFOXWSZVQ0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:56 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBC006I9XWMLU10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:55 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, joshi@samsung.com
Subject: [PATCH v1 12/14] drm: exynos: hdmi: replace is_v13 with version check
 in hdmi
Date: Thu, 04 Oct 2012 21:12:50 +0530
Message-id: <1349365372-21417-13-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
References: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removed the is_v13 variable from the hdmi driver context.
It is replaced with condition check for the hdmi version. This cleans
the way for handling further hdmi versions.

Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c |   40 +++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index e3ab840..89e798b 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -47,6 +47,11 @@
 #define MAX_HEIGHT		1080
 #define get_hdmi_context(dev)	platform_get_drvdata(to_platform_device(dev))
 
+enum hdmi_type {
+	HDMI_TYPE13,
+	HDMI_TYPE14,
+};
+
 struct hdmi_resources {
 	struct clk			*hdmi;
 	struct clk			*sclk_hdmi;
@@ -62,7 +67,6 @@ struct hdmi_context {
 	struct drm_device		*drm_dev;
 	bool				hpd;
 	bool				powered;
-	bool				is_v13;
 	bool				dvi_mode;
 	struct mutex			hdmi_mutex;
 
@@ -80,6 +84,8 @@ struct hdmi_context {
 	void				*parent_ctx;
 
 	int				hpd_gpio;
+
+	enum hdmi_type			type;
 };
 
 /* HDMI Version 1.3 */
@@ -1211,7 +1217,7 @@ static void hdmi_v14_regs_dump(struct hdmi_context *hdata, char *prefix)
 
 static void hdmi_regs_dump(struct hdmi_context *hdata, char *prefix)
 {
-	if (hdata->is_v13)
+	if (hdata->type == HDMI_TYPE13)
 		hdmi_v13_regs_dump(hdata, prefix);
 	else
 		hdmi_v14_regs_dump(hdata, prefix);
@@ -1252,7 +1258,7 @@ static int hdmi_v14_conf_index(struct drm_display_mode *mode)
 static int hdmi_conf_index(struct hdmi_context *hdata,
 			   struct drm_display_mode *mode)
 {
-	if (hdata->is_v13)
+	if (hdata->type == HDMI_TYPE13)
 		return hdmi_v13_conf_index(mode);
 
 	return hdmi_v14_conf_index(mode);
@@ -1348,7 +1354,7 @@ static int hdmi_check_timing(void *ctx, void *timing)
 			check_timing->yres, check_timing->refresh,
 			check_timing->vmode);
 
-	if (hdata->is_v13)
+	if (hdata->type == HDMI_TYPE13)
 		return hdmi_v13_check_timing(check_timing);
 	else
 		return hdmi_v14_check_timing(check_timing);
@@ -1414,7 +1420,7 @@ static void hdmi_reg_acr(struct hdmi_context *hdata, u8 *acr)
 	hdmi_reg_writeb(hdata, HDMI_ACR_CTS1, acr[2]);
 	hdmi_reg_writeb(hdata, HDMI_ACR_CTS2, acr[1]);
 
-	if (hdata->is_v13)
+	if (hdata->type == HDMI_TYPE13)
 		hdmi_reg_writeb(hdata, HDMI_V13_ACR_CON, 4);
 	else
 		hdmi_reg_writeb(hdata, HDMI_ACR_CON, 4);
@@ -1518,7 +1524,7 @@ static void hdmi_conf_reset(struct hdmi_context *hdata)
 {
 	u32 reg;
 
-	if (hdata->is_v13)
+	if (hdata->type == HDMI_TYPE13)
 		reg = HDMI_V13_CORE_RSTOUT;
 	else
 		reg = HDMI_CORE_RSTOUT;
@@ -1550,7 +1556,7 @@ static void hdmi_conf_init(struct hdmi_context *hdata)
 				HDMI_VID_PREAMBLE_DIS | HDMI_GUARD_BAND_DIS);
 	}
 
-	if (hdata->is_v13) {
+	if (hdata->type == HDMI_TYPE13) {
 		/* choose bluescreen (fecal) color */
 		hdmi_reg_writeb(hdata, HDMI_V13_BLUE_SCREEN_0, 0x12);
 		hdmi_reg_writeb(hdata, HDMI_V13_BLUE_SCREEN_1, 0x34);
@@ -1832,7 +1838,7 @@ static void hdmi_v14_timing_apply(struct hdmi_context *hdata)
 
 static void hdmi_timing_apply(struct hdmi_context *hdata)
 {
-	if (hdata->is_v13)
+	if (hdata->type == HDMI_TYPE13)
 		hdmi_v13_timing_apply(hdata);
 	else
 		hdmi_v14_timing_apply(hdata);
@@ -1854,7 +1860,7 @@ static void hdmiphy_conf_reset(struct hdmi_context *hdata)
 	if (hdata->hdmiphy_port)
 		i2c_master_send(hdata->hdmiphy_port, buffer, 2);
 
-	if (hdata->is_v13)
+	if (hdata->type == HDMI_TYPE13)
 		reg = HDMI_V13_PHY_RSTOUT;
 	else
 		reg = HDMI_PHY_RSTOUT;
@@ -1881,7 +1887,7 @@ static void hdmiphy_conf_apply(struct hdmi_context *hdata)
 	}
 
 	/* pixel clock */
-	if (hdata->is_v13)
+	if (hdata->type == HDMI_TYPE13)
 		hdmiphy_data = hdmi_v13_confs[hdata->cur_conf].hdmiphy_data;
 	else
 		hdmiphy_data = hdmi_confs[hdata->cur_conf].hdmiphy_data;
@@ -1949,7 +1955,7 @@ static void hdmi_mode_fixup(void *ctx, struct drm_connector *connector,
 
 	drm_mode_set_crtcinfo(adjusted_mode, 0);
 
-	if (hdata->is_v13)
+	if (hdata->type == HDMI_TYPE13)
 		index = hdmi_v13_conf_index(adjusted_mode);
 	else
 		index = hdmi_v14_conf_index(adjusted_mode);
@@ -1963,7 +1969,7 @@ static void hdmi_mode_fixup(void *ctx, struct drm_connector *connector,
 	 * to adjusted_mode.
 	 */
 	list_for_each_entry(m, &connector->modes, head) {
-		if (hdata->is_v13)
+		if (hdata->type == HDMI_TYPE13)
 			index = hdmi_v13_conf_index(m);
 		else
 			index = hdmi_v14_conf_index(m);
@@ -2244,11 +2250,6 @@ void hdmi_attach_hdmiphy_client(struct i2c_client *hdmiphy)
 		hdmi_hdmiphy = hdmiphy;
 }
 
-enum hdmi_type {
-	HDMI_TYPE13,
-	HDMI_TYPE14,
-};
-
 static struct platform_device_id hdmi_driver_types[] = {
 	{
 		.name		= "s5pv210-hdmi",
@@ -2272,7 +2273,6 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 	struct s5p_hdmi_platform_data *pdata;
 	struct resource *res;
 	int ret;
-	enum hdmi_type hdmi_type;
 
 	DRM_DEBUG_KMS("[%d]\n", __LINE__);
 
@@ -2303,8 +2303,8 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, drm_hdmi_ctx);
 
-	hdmi_type = platform_get_device_id(pdev)->driver_data;
-	hdata->is_v13 = (hdmi_type == HDMI_TYPE13);
+	hdata->type = (enum hdmi_type)platform_get_device_id
+					(pdev)->driver_data;
 	hdata->hpd_gpio = pdata->hpd_gpio;
 	hdata->dev = dev;
 
-- 
1.7.0.4

