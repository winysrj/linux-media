Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62194 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab3AIJoU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 04:44:20 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so834295pbc.19
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2013 01:44:19 -0800 (PST)
From: Vikas C Sajjan <vikas.sajjan@linaro.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: inki.dae@samsung.com, laurent.pinchart@ideasonboard.com,
	tomi.valkeinen@ti.com, jesse.barker@linaro.org,
	aditya.ps@samsung.com, t.figa@samsung.com
Subject: [PATCH]  [RFC]: video: exynos: Making s6e8ax0 panel driver compliant with CDF
Date: Wed,  9 Jan 2013 15:14:04 +0530
Message-Id: <1357724644-26194-2-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1357724644-26194-1-git-send-email-vikas.sajjan@linaro.org>
References: <1357724644-26194-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vikas Sajjan <vikas.sajjan@linaro.org>

 Made necessary changes in s6e8ax0 panel driver as per the CDF-T.
 it also removes the dependency on backlight and lcd framework.

Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/video/exynos/s6e8ax0.c |  602 ++++++++++++++++++++++------------------
 1 file changed, 328 insertions(+), 274 deletions(-)

diff --git a/drivers/video/exynos/s6e8ax0.c b/drivers/video/exynos/s6e8ax0.c
index 05d080b..5d9be51 100644
--- a/drivers/video/exynos/s6e8ax0.c
+++ b/drivers/video/exynos/s6e8ax0.c
@@ -38,8 +38,7 @@
 #define POWER_IS_OFF(pwr)	((pwr) == FB_BLANK_POWERDOWN)
 #define POWER_IS_NRM(pwr)	((pwr) == FB_BLANK_NORMAL)
 
-#define lcd_to_master(a)	(a->dsim_dev->master)
-#define lcd_to_master_ops(a)	((lcd_to_master(a))->master_ops)
+#define to_panel(p) container_of(p, struct s6e8ax0, entity)
 
 enum {
 	DSIM_NONE_STATE = 0,
@@ -47,20 +46,34 @@ enum {
 	DSIM_FRAME_DONE = 2,
 };
 
+/* This structure defines all the properties of a backlight */
+struct backlight_prop {
+	/* Current User requested brightness (0 - max_brightness) */
+	int brightness;
+	/* Maximal value for brightness (read-only) */
+	int max_brightness;
+};
+
+struct panel_platform_data {
+	unsigned int	reset_delay;
+	unsigned int	power_on_delay;
+	unsigned int	power_off_delay;
+	const char	*video_source_name;
+};
+
 struct s6e8ax0 {
-	struct device	*dev;
-	unsigned int			power;
-	unsigned int			id;
-	unsigned int			gamma;
-	unsigned int			acl_enable;
-	unsigned int			cur_acl;
-
-	struct lcd_device	*ld;
-	struct backlight_device	*bd;
-
-	struct mipi_dsim_lcd_device	*dsim_dev;
-	struct lcd_platform_data	*ddi_pd;
+	struct platform_device	*pdev;
+	struct video_source	*src;
+	struct display_entity	entity;
+	unsigned int		power;
+	unsigned int		id;
+	unsigned int		gamma;
+	unsigned int		acl_enable;
+	unsigned int		cur_acl;
+	bool			panel_reverse;
+	struct panel_platform_data	*plat_data;
 	struct mutex			lock;
+	struct backlight_prop		bl_prop;
 	bool  enabled;
 };
 
@@ -70,39 +83,42 @@ static struct regulator_bulk_data supplies[] = {
 	{ .supply = "vci", },
 };
 
-static void s6e8ax0_regulator_enable(struct s6e8ax0 *lcd)
+static void s6e8ax0_regulator_enable(struct s6e8ax0 *panel)
 {
 	int ret = 0;
-	struct lcd_platform_data *pd = NULL;
+	struct panel_platform_data *plat_data = NULL;
+
+	plat_data = panel->plat_data;
 
-	pd = lcd->ddi_pd;
-	mutex_lock(&lcd->lock);
-	if (!lcd->enabled) {
+	mutex_lock(&panel->lock);
+
+	if (!panel->enabled) {
 		ret = regulator_bulk_enable(ARRAY_SIZE(supplies), supplies);
 		if (ret)
 			goto out;
 
-		lcd->enabled = true;
+		panel->enabled = true;
 	}
-	msleep(pd->power_on_delay);
+	msleep(plat_data->power_on_delay);
 out:
-	mutex_unlock(&lcd->lock);
+	mutex_unlock(&panel->lock);
 }
 
-static void s6e8ax0_regulator_disable(struct s6e8ax0 *lcd)
+static void s6e8ax0_regulator_disable(struct s6e8ax0 *panel)
 {
 	int ret = 0;
 
-	mutex_lock(&lcd->lock);
-	if (lcd->enabled) {
+	mutex_lock(&panel->lock);
+
+	if (panel->enabled) {
 		ret = regulator_bulk_disable(ARRAY_SIZE(supplies), supplies);
 		if (ret)
 			goto out;
 
-		lcd->enabled = false;
+		panel->enabled = false;
 	}
 out:
-	mutex_unlock(&lcd->lock);
+	mutex_unlock(&panel->lock);
 }
 
 static const unsigned char s6e8ax0_22_gamma_30[] = {
@@ -283,10 +299,8 @@ static const unsigned char *s6e8ax0_22_gamma_table[] = {
 	s6e8ax0_22_gamma_300,
 };
 
-static void s6e8ax0_panel_cond(struct s6e8ax0 *lcd)
+static void s6e8ax0_panel_cond(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-
 	static const unsigned char data_to_send[] = {
 		0xf8, 0x3d, 0x35, 0x00, 0x00, 0x00, 0x93, 0x00, 0x3c, 0x7d,
 		0x08, 0x27, 0x7d, 0x3f, 0x00, 0x00, 0x00, 0x20, 0x04, 0x08,
@@ -300,239 +314,218 @@ static void s6e8ax0_panel_cond(struct s6e8ax0 *lcd)
 		0xc1, 0x01, 0x41, 0xc1, 0x00, 0xc1, 0xf6, 0xf6, 0xc1
 	};
 
-	if (lcd->dsim_dev->panel_reverse)
-		ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+	if (panel->panel_reverse)
+		panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE,
 				data_to_send_panel_reverse,
 				ARRAY_SIZE(data_to_send_panel_reverse));
 	else
-		ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+		panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE,
 				data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_display_cond(struct s6e8ax0 *lcd)
+static void s6e8ax0_display_cond(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0xf2, 0x80, 0x03, 0x0d
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
-
 /* Gamma 2.2 Setting (200cd, 7500K, 10MPCD) */
-static void s6e8ax0_gamma_cond(struct s6e8ax0 *lcd)
+static void s6e8ax0_gamma_cond(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-	unsigned int gamma = lcd->bd->props.brightness;
+	unsigned int gamma = panel->bl_prop.brightness;
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE,
 			s6e8ax0_22_gamma_table[gamma],
 			GAMMA_TABLE_COUNT);
 }
 
-static void s6e8ax0_gamma_update(struct s6e8ax0 *lcd)
+static void s6e8ax0_gamma_update(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0xf7, 0x03
 	};
 
-	ops->cmd_write(lcd_to_master(lcd),
+	panel->src->ops.dsi->dcs_write(panel->src,
 		MIPI_DSI_DCS_SHORT_WRITE_PARAM, data_to_send,
 		ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_etc_cond1(struct s6e8ax0 *lcd)
+static void s6e8ax0_etc_cond1(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0xd1, 0xfe, 0x80, 0x00, 0x01, 0x0b, 0x00, 0x00, 0x40,
 		0x0d, 0x00, 0x00
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_etc_cond2(struct s6e8ax0 *lcd)
+static void s6e8ax0_etc_cond2(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0xb6, 0x0c, 0x02, 0x03, 0x32, 0xff, 0x44, 0x44, 0xc0,
 		0x00
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_etc_cond3(struct s6e8ax0 *lcd)
+static void s6e8ax0_etc_cond3(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0xe1, 0x10, 0x1c, 0x17, 0x08, 0x1d
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_etc_cond4(struct s6e8ax0 *lcd)
+static void s6e8ax0_etc_cond4(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0xe2, 0xed, 0x07, 0xc3, 0x13, 0x0d, 0x03
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_etc_cond5(struct s6e8ax0 *lcd)
+static void s6e8ax0_etc_cond5(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0xf4, 0xcf, 0x0a, 0x12, 0x10, 0x19, 0x33, 0x02
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
-static void s6e8ax0_etc_cond6(struct s6e8ax0 *lcd)
+static void s6e8ax0_etc_cond6(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0xe3, 0x40
 	};
 
-	ops->cmd_write(lcd_to_master(lcd),
+	panel->src->ops.dsi->dcs_write(panel->src,
 		MIPI_DSI_DCS_SHORT_WRITE_PARAM,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_etc_cond7(struct s6e8ax0 *lcd)
+static void s6e8ax0_etc_cond7(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0xe4, 0x00, 0x00, 0x14, 0x80, 0x00, 0x00, 0x00
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_elvss_set(struct s6e8ax0 *lcd)
+static void s6e8ax0_elvss_set(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0xb1, 0x04, 0x00
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_elvss_nvm_set(struct s6e8ax0 *lcd)
+static void s6e8ax0_elvss_nvm_set(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0xd9, 0x5c, 0x20, 0x0c, 0x0f, 0x41, 0x00, 0x10, 0x11,
 		0x12, 0xd1, 0x00, 0x00, 0x00, 0x00, 0x80, 0xcb, 0xed,
 		0x64, 0xaf
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_sleep_in(struct s6e8ax0 *lcd)
+static void s6e8ax0_sleep_in(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0x10, 0x00
 	};
 
-	ops->cmd_write(lcd_to_master(lcd),
+	panel->src->ops.dsi->dcs_write(panel->src,
 		MIPI_DSI_DCS_SHORT_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_sleep_out(struct s6e8ax0 *lcd)
+static void s6e8ax0_sleep_out(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0x11, 0x00
 	};
 
-	ops->cmd_write(lcd_to_master(lcd),
+	panel->src->ops.dsi->dcs_write(panel->src,
 		MIPI_DSI_DCS_SHORT_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_display_on(struct s6e8ax0 *lcd)
+static void s6e8ax0_display_on(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0x29, 0x00
 	};
 
-	ops->cmd_write(lcd_to_master(lcd),
+	panel->src->ops.dsi->dcs_write(panel->src,
 		MIPI_DSI_DCS_SHORT_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_display_off(struct s6e8ax0 *lcd)
+static void s6e8ax0_display_off(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0x28, 0x00
 	};
 
-	ops->cmd_write(lcd_to_master(lcd),
+	panel->src->ops.dsi->dcs_write(panel->src,
 		MIPI_DSI_DCS_SHORT_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_apply_level2_key(struct s6e8ax0 *lcd)
+static void s6e8ax0_apply_level2_key(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0xf0, 0x5a, 0x5a
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_acl_on(struct s6e8ax0 *lcd)
+static void s6e8ax0_acl_on(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0xc0, 0x01
 	};
 
-	ops->cmd_write(lcd_to_master(lcd),
+	panel->src->ops.dsi->dcs_write(panel->src,
 		MIPI_DSI_DCS_SHORT_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_acl_off(struct s6e8ax0 *lcd)
+static void s6e8ax0_acl_off(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	static const unsigned char data_to_send[] = {
 		0xc0, 0x00
 	};
 
-	ops->cmd_write(lcd_to_master(lcd),
+	panel->src->ops.dsi->dcs_write(panel->src,
 		MIPI_DSI_DCS_SHORT_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
 /* Full white 50% reducing setting */
-static void s6e8ax0_acl_ctrl_set(struct s6e8ax0 *lcd)
+static void s6e8ax0_acl_ctrl_set(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	/* Full white 50% reducing setting */
 	static const unsigned char cutoff_50[] = {
 		0xc1, 0x47, 0x53, 0x13, 0x53, 0x00, 0x00, 0x02, 0xcf,
@@ -555,353 +548,414 @@ static void s6e8ax0_acl_ctrl_set(struct s6e8ax0 *lcd)
 		0x31, 0x36
 	};
 
-	if (lcd->acl_enable) {
-		if (lcd->cur_acl == 0) {
-			if (lcd->gamma == 0 || lcd->gamma == 1) {
-				s6e8ax0_acl_off(lcd);
-				dev_dbg(&lcd->ld->dev,
-					"cur_acl=%d\n", lcd->cur_acl);
+	if (panel->acl_enable) {
+		if (panel->cur_acl == 0) {
+			if (panel->gamma == 0 || panel->gamma == 1) {
+				s6e8ax0_acl_off(panel);
+				dev_dbg(&panel->pdev->dev,
+					"cur_acl=%d\n", panel->cur_acl);
 			} else
-				s6e8ax0_acl_on(lcd);
+				s6e8ax0_acl_on(panel);
 		}
-		switch (lcd->gamma) {
+		switch (panel->gamma) {
 		case 0: /* 30cd */
-			s6e8ax0_acl_off(lcd);
-			lcd->cur_acl = 0;
+			s6e8ax0_acl_off(panel);
+			panel->cur_acl = 0;
 			break;
 		case 1 ... 3: /* 50cd ~ 90cd */
-			ops->cmd_write(lcd_to_master(lcd),
+			panel->src->ops.dsi->dcs_write(panel->src,
 				MIPI_DSI_DCS_LONG_WRITE,
 				cutoff_40,
 				ARRAY_SIZE(cutoff_40));
-			lcd->cur_acl = 40;
+			panel->cur_acl = 40;
 			break;
 		case 4 ... 7: /* 120cd ~ 210cd */
-			ops->cmd_write(lcd_to_master(lcd),
+			panel->src->ops.dsi->dcs_write(panel->src,
 				MIPI_DSI_DCS_LONG_WRITE,
 				cutoff_45,
 				ARRAY_SIZE(cutoff_45));
-			lcd->cur_acl = 45;
+			panel->cur_acl = 45;
 			break;
 		case 8 ... 10: /* 220cd ~ 300cd */
-			ops->cmd_write(lcd_to_master(lcd),
+			panel->src->ops.dsi->dcs_write(panel->src,
 				MIPI_DSI_DCS_LONG_WRITE,
 				cutoff_50,
 				ARRAY_SIZE(cutoff_50));
-			lcd->cur_acl = 50;
+			panel->cur_acl = 50;
 			break;
 		default:
 			break;
 		}
 	} else {
-		s6e8ax0_acl_off(lcd);
-		lcd->cur_acl = 0;
-		dev_dbg(&lcd->ld->dev, "cur_acl = %d\n", lcd->cur_acl);
+		s6e8ax0_acl_off(panel);
+		panel->cur_acl = 0;
+		dev_dbg(&panel->pdev->dev, "cur_acl = %d\n", panel->cur_acl);
 	}
 }
 
-static void s6e8ax0_read_id(struct s6e8ax0 *lcd, u8 *mtp_id)
+static void s6e8ax0_read_id(struct s6e8ax0 *panel, u8 *mtp_id)
 {
 	unsigned int ret;
 	unsigned int addr = 0xd1;	/* MTP ID */
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 
-	ret = ops->cmd_read(lcd_to_master(lcd),
+	ret = panel->src->ops.dsi->dcs_read(panel->src,
 			MIPI_DSI_GENERIC_READ_REQUEST_1_PARAM,
-			addr, 3, mtp_id);
+			addr, mtp_id, 3);
 }
 
-static int s6e8ax0_panel_init(struct s6e8ax0 *lcd)
+static int s6e8ax0_panel_init(struct s6e8ax0 *panel)
 {
-	s6e8ax0_apply_level2_key(lcd);
-	s6e8ax0_sleep_out(lcd);
+	s6e8ax0_apply_level2_key(panel);
+	s6e8ax0_sleep_out(panel);
 	msleep(1);
-	s6e8ax0_panel_cond(lcd);
-	s6e8ax0_display_cond(lcd);
-	s6e8ax0_gamma_cond(lcd);
-	s6e8ax0_gamma_update(lcd);
+	s6e8ax0_panel_cond(panel);
+	s6e8ax0_display_cond(panel);
+	s6e8ax0_gamma_cond(panel);
+	s6e8ax0_gamma_update(panel);
 
-	s6e8ax0_etc_cond1(lcd);
-	s6e8ax0_etc_cond2(lcd);
-	s6e8ax0_etc_cond3(lcd);
-	s6e8ax0_etc_cond4(lcd);
-	s6e8ax0_etc_cond5(lcd);
-	s6e8ax0_etc_cond6(lcd);
-	s6e8ax0_etc_cond7(lcd);
+	s6e8ax0_etc_cond1(panel);
+	s6e8ax0_etc_cond2(panel);
+	s6e8ax0_etc_cond3(panel);
+	s6e8ax0_etc_cond4(panel);
+	s6e8ax0_etc_cond5(panel);
+	s6e8ax0_etc_cond6(panel);
+	s6e8ax0_etc_cond7(panel);
 
-	s6e8ax0_elvss_nvm_set(lcd);
-	s6e8ax0_elvss_set(lcd);
+	s6e8ax0_elvss_nvm_set(panel);
+	s6e8ax0_elvss_set(panel);
 
-	s6e8ax0_acl_ctrl_set(lcd);
-	s6e8ax0_acl_on(lcd);
+	s6e8ax0_acl_ctrl_set(panel);
+	s6e8ax0_acl_on(panel);
 
 	/* if ID3 value is not 33h, branch private elvss mode */
-	msleep(lcd->ddi_pd->power_on_delay);
+	msleep(panel->plat_data->power_on_delay);
 
 	return 0;
 }
 
-static int s6e8ax0_update_gamma_ctrl(struct s6e8ax0 *lcd, int brightness)
+static int s6e8ax0_update_gamma_ctrl(struct s6e8ax0 *panel, int brightness)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE,
 			s6e8ax0_22_gamma_table[brightness],
 			ARRAY_SIZE(s6e8ax0_22_gamma_table));
 
 	/* update gamma table. */
-	s6e8ax0_gamma_update(lcd);
-	lcd->gamma = brightness;
+	s6e8ax0_gamma_update(panel);
+	panel->gamma = brightness;
 
 	return 0;
 }
 
-static int s6e8ax0_gamma_ctrl(struct s6e8ax0 *lcd, int gamma)
+static int s6e8ax0_gamma_ctrl(struct s6e8ax0 *panel, int gamma)
 {
-	s6e8ax0_update_gamma_ctrl(lcd, gamma);
+	s6e8ax0_update_gamma_ctrl(panel, gamma);
 
 	return 0;
 }
 
-static int s6e8ax0_set_power(struct lcd_device *ld, int power)
+static int s6e8ax0_set_power(struct s6e8ax0 *panel, int power)
 {
-	struct s6e8ax0 *lcd = lcd_get_data(ld);
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 	int ret = 0;
 
 	if (power != FB_BLANK_UNBLANK && power != FB_BLANK_POWERDOWN &&
 			power != FB_BLANK_NORMAL) {
-		dev_err(lcd->dev, "power value should be 0, 1 or 4.\n");
+		dev_err(&panel->pdev->dev, "power value should be 0, 1 or 4.\n");
 		return -EINVAL;
 	}
 
-	if ((power == FB_BLANK_UNBLANK) && ops->set_blank_mode) {
+	if ((power == FB_BLANK_UNBLANK) && panel->src->ops.dsi->set_blank_mode) {
 		/* LCD power on */
-		if ((POWER_IS_ON(power) && POWER_IS_OFF(lcd->power))
-			|| (POWER_IS_ON(power) && POWER_IS_NRM(lcd->power))) {
-			ret = ops->set_blank_mode(lcd_to_master(lcd), power);
-			if (!ret && lcd->power != power)
-				lcd->power = power;
+		if ((POWER_IS_ON(power) && POWER_IS_OFF(panel->power))
+			|| (POWER_IS_ON(power) && POWER_IS_NRM(panel->power))) {
+			ret = panel->src->ops.dsi->set_blank_mode(panel->src,
+									power);
+			if (!ret && panel->power != power)
+				panel->power = power;
 		}
-	} else if ((power == FB_BLANK_POWERDOWN) && ops->set_early_blank_mode) {
+	} else if ((power == FB_BLANK_POWERDOWN) &&
+			panel->src->ops.dsi->set_early_blank_mode) {
 		/* LCD power off */
-		if ((POWER_IS_OFF(power) && POWER_IS_ON(lcd->power)) ||
-		(POWER_IS_ON(lcd->power) && POWER_IS_NRM(power))) {
-			ret = ops->set_early_blank_mode(lcd_to_master(lcd),
+		if ((POWER_IS_OFF(power) && POWER_IS_ON(panel->power)) ||
+		(POWER_IS_ON(panel->power) && POWER_IS_NRM(power))) {
+			ret = panel->src->ops.dsi->set_early_blank_mode(panel->src,
 							power);
-			if (!ret && lcd->power != power)
-				lcd->power = power;
+			if (!ret && panel->power != power)
+				panel->power = power;
 		}
 	}
 
 	return ret;
 }
 
-static int s6e8ax0_get_power(struct lcd_device *ld)
-{
-	struct s6e8ax0 *lcd = lcd_get_data(ld);
-
-	return lcd->power;
-}
-
-static int s6e8ax0_get_brightness(struct backlight_device *bd)
+static int s6e8ax0_get_brightness(struct s6e8ax0 *panel)
 {
-	return bd->props.brightness;
+	return panel->bl_prop.brightness;
 }
 
-static int s6e8ax0_set_brightness(struct backlight_device *bd)
+static int s6e8ax0_set_brightness(struct s6e8ax0 *panel)
 {
-	int ret = 0, brightness = bd->props.brightness;
-	struct s6e8ax0 *lcd = bl_get_data(bd);
+	int ret = 0, brightness = panel->bl_prop.brightness;
 
 	if (brightness < MIN_BRIGHTNESS ||
-		brightness > bd->props.max_brightness) {
-		dev_err(lcd->dev, "lcd brightness should be %d to %d.\n",
+		brightness > panel->bl_prop.max_brightness) {
+		dev_err(&panel->pdev->dev, "lcd brightness should be %d to %d.\n",
 			MIN_BRIGHTNESS, MAX_BRIGHTNESS);
 		return -EINVAL;
 	}
 
-	ret = s6e8ax0_gamma_ctrl(lcd, brightness);
+	ret = s6e8ax0_gamma_ctrl(panel, brightness);
 	if (ret) {
-		dev_err(&bd->dev, "lcd brightness setting failed.\n");
+		dev_err(&panel->pdev->dev, "lcd brightness setting failed.\n");
 		return -EIO;
 	}
 
 	return ret;
 }
 
-static struct lcd_ops s6e8ax0_lcd_ops = {
-	.set_power = s6e8ax0_set_power,
-	.get_power = s6e8ax0_get_power,
-};
+static int panel_get_modes(struct display_entity *entity,
+			       const struct videomode **modes)
+{
+	/* FIXME */
+	return 1;
+}
+
+static int panel_get_size(struct display_entity *entity,
+			      unsigned int *width, unsigned int *height)
+{
+	/* FIXME */
+	*width = 10;
+	*height = 10;
+	return 0;
+}
+
+static int panel_update(struct display_entity *entity,
+		void (*callback)(int, void *), void *data)
+{
+	struct s6e8ax0 *panel = to_panel(entity);
+	struct video_source *src = panel->src;
+
+	return src->ops.dsi->update(src, 0, callback, data);
+}
+
+static int panel_dcs_write(struct s6e8ax0 *panel, u8 dcs_cmd)
+{
+	struct video_source *src = panel->src;
+
+	return src->ops.dsi->dcs_write(src, 0, &dcs_cmd, 1);
+}
+static int panel_set_state(struct display_entity *entity,
+			       enum display_entity_state state)
+{
+	struct s6e8ax0 *panel = to_panel(entity);
+	int ret;
+
+	switch (state) {
+	case DISPLAY_ENTITY_STATE_OFF:
+	case DISPLAY_ENTITY_STATE_STANDBY:
+		ret = panel_dcs_write(panel, MIPI_DCS_SET_DISPLAY_OFF);
+		if (ret)
+			pr_err("display off failed\n");
+
+		s6e8ax0_set_power(panel, FB_BLANK_POWERDOWN);
+
+		break;
 
-static const struct backlight_ops s6e8ax0_backlight_ops = {
-	.get_brightness = s6e8ax0_get_brightness,
-	.update_status = s6e8ax0_set_brightness,
+	case DISPLAY_ENTITY_STATE_ON:
+		ret = s6e8ax0_set_power(panel, FB_BLANK_UNBLANK);
+		if (ret)
+			pr_err("failed to enable bus\n");
+
+		ret = panel_dcs_write(panel, MIPI_DCS_SET_DISPLAY_ON);
+		if (ret)
+			pr_err("display on failed\n");
+		break;
+	}
+
+	return 0;
+}
+static const struct display_entity_control_ops panel_control_ops = {
+	.set_state = panel_set_state,
+	.get_modes = panel_get_modes,
+	.get_size = panel_get_size,
+	.update = panel_update,
 };
 
-static void s6e8ax0_power_on(struct mipi_dsim_lcd_device *dsim_dev, int power)
+static void panel_release(struct display_entity *entity)
 {
-	struct s6e8ax0 *lcd = dev_get_drvdata(&dsim_dev->dev);
+	pr_info("panel release\n");
+}
 
-	msleep(lcd->ddi_pd->power_on_delay);
+static void s6e8ax0_power_on(struct s6e8ax0 *panel, int power)
+{
+	msleep(panel->plat_data->power_on_delay);
 
 	/* lcd power on */
 	if (power)
-		s6e8ax0_regulator_enable(lcd);
+		s6e8ax0_regulator_enable(panel);
 	else
-		s6e8ax0_regulator_disable(lcd);
+		s6e8ax0_regulator_disable(panel);
 
-	msleep(lcd->ddi_pd->reset_delay);
+	msleep(panel->plat_data->reset_delay);
 
+/* FIXME */
+#if 0
 	/* lcd reset */
-	if (lcd->ddi_pd->reset)
-		lcd->ddi_pd->reset(lcd->ld);
+	if (panel->plat_data->reset)
+		panel->plat_data->reset();
+#endif
 	msleep(5);
 }
 
-static void s6e8ax0_set_sequence(struct mipi_dsim_lcd_device *dsim_dev)
+static void s6e8ax0_set_sequence(struct s6e8ax0 *panel)
 {
-	struct s6e8ax0 *lcd = dev_get_drvdata(&dsim_dev->dev);
-
-	s6e8ax0_panel_init(lcd);
-	s6e8ax0_display_on(lcd);
+	s6e8ax0_panel_init(panel);
+	s6e8ax0_display_on(panel);
 
-	lcd->power = FB_BLANK_UNBLANK;
+	panel->power = FB_BLANK_UNBLANK;
 }
 
-static int s6e8ax0_probe(struct mipi_dsim_lcd_device *dsim_dev)
+static int s6e8ax0_probe(struct platform_device *pdev)
 {
-	struct s6e8ax0 *lcd;
+	struct s6e8ax0 *panel;
 	int ret;
 	u8 mtp_id[3] = {0, };
 
-	lcd = kzalloc(sizeof(struct s6e8ax0), GFP_KERNEL);
-	if (!lcd) {
-		dev_err(&dsim_dev->dev, "failed to allocate s6e8ax0 structure.\n");
+	panel = devm_kzalloc(&pdev->dev, sizeof(struct s6e8ax0), GFP_KERNEL);
+	if (!panel) {
+		dev_err(&pdev->dev, "failed to allocate s6e8ax0 structure.\n");
 		return -ENOMEM;
 	}
 
-	lcd->dsim_dev = dsim_dev;
-	lcd->ddi_pd = (struct lcd_platform_data *)dsim_dev->platform_data;
-	lcd->dev = &dsim_dev->dev;
+	panel->plat_data =
+			(struct panel_platform_data *)pdev->dev.platform_data;
 
-	mutex_init(&lcd->lock);
+	mutex_init(&panel->lock);
 
-	ret = regulator_bulk_get(lcd->dev, ARRAY_SIZE(supplies), supplies);
+	ret = regulator_bulk_get(&panel->pdev->dev, ARRAY_SIZE(supplies),
+					supplies);
 	if (ret) {
-		dev_err(lcd->dev, "Failed to get regulators: %d\n", ret);
-		goto err_lcd_register;
+		dev_err(&pdev->dev, "Failed to get regulators: %d\n", ret);
+		goto err_panel_register;
 	}
 
-	lcd->ld = lcd_device_register("s6e8ax0", lcd->dev, lcd,
-			&s6e8ax0_lcd_ops);
-	if (IS_ERR(lcd->ld)) {
-		dev_err(lcd->dev, "failed to register lcd ops.\n");
-		ret = PTR_ERR(lcd->ld);
-		goto err_lcd_register;
-	}
-
-	lcd->bd = backlight_device_register("s6e8ax0-bl", lcd->dev, lcd,
-			&s6e8ax0_backlight_ops, NULL);
-	if (IS_ERR(lcd->bd)) {
-		dev_err(lcd->dev, "failed to register backlight ops.\n");
-		ret = PTR_ERR(lcd->bd);
-		goto err_backlight_register;
-	}
+	panel->bl_prop.max_brightness = MAX_BRIGHTNESS;
+	panel->bl_prop.brightness = MAX_BRIGHTNESS;
 
-	lcd->bd->props.max_brightness = MAX_BRIGHTNESS;
-	lcd->bd->props.brightness = MAX_BRIGHTNESS;
+	s6e8ax0_read_id(panel, mtp_id);
 
-	s6e8ax0_read_id(lcd, mtp_id);
 	if (mtp_id[0] == 0x00)
-		dev_err(lcd->dev, "read id failed\n");
+		dev_err(&pdev->dev, "read id failed\n");
 
-	dev_info(lcd->dev, "Read ID : %x, %x, %x\n",
+	dev_info(&pdev->dev, "Read ID : %x, %x, %x\n",
 			mtp_id[0], mtp_id[1], mtp_id[2]);
 
 	if (mtp_id[2] == 0x33)
-		dev_info(lcd->dev,
+		dev_info(&pdev->dev,
 			"ID-3 is 0xff does not support dynamic elvss\n");
 	else
-		dev_info(lcd->dev,
+		dev_info(&pdev->dev,
 			"ID-3 is 0x%x support dynamic elvss\n", mtp_id[2]);
 
-	lcd->acl_enable = 1;
-	lcd->cur_acl = 0;
+	panel->acl_enable = 1;
+	panel->cur_acl = 0;
 
-	dev_set_drvdata(&dsim_dev->dev, lcd);
+	platform_set_drvdata(pdev, panel);
 
-	dev_dbg(lcd->dev, "probed s6e8ax0 panel driver.\n");
+	/* setup input */
+	panel->src = video_source_find(panel->plat_data->video_source_name);
+	if (panel->src == NULL) {
+		pr_err("failed to get video source\n");
+		goto err_panel_register;
+	}
 
-	return 0;
+	s6e8ax0_power_on(panel, 1);
+
+	s6e8ax0_set_sequence(panel);
+
+	/* setup panel entity */
+	panel->entity.dev = &pdev->dev;
+	panel->entity.release = panel_release;
+	panel->entity.ops = &panel_control_ops;
 
-err_backlight_register:
-	lcd_device_unregister(lcd->ld);
+	ret = display_entity_register(&panel->entity);
 
-err_lcd_register:
+	if (ret < 0) {
+		pr_err("failed to register display entity\n");
+		goto err_panel_register;
+	}
+
+	/* NOT SURE of this */
+	panel->panel_reverse = 0;
+
+	dev_dbg(&pdev->dev, "probed s6e8ax0 panel driver.\n");
+
+	return 0;
+
+err_panel_register:
 	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
-	kfree(lcd);
+	kfree(panel);
 
 	return ret;
 }
 
-#ifdef CONFIG_PM
-static int s6e8ax0_suspend(struct mipi_dsim_lcd_device *dsim_dev)
+#ifdef CONFIG_PM_SLEEP
+static int s6e8ax0_suspend(struct device *dev)
 {
-	struct s6e8ax0 *lcd = dev_get_drvdata(&dsim_dev->dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct s6e8ax0 *panel = platform_get_drvdata(pdev);
 
-	s6e8ax0_sleep_in(lcd);
-	msleep(lcd->ddi_pd->power_off_delay);
-	s6e8ax0_display_off(lcd);
+	s6e8ax0_sleep_in(panel);
+	msleep(panel->plat_data->power_off_delay);
+	s6e8ax0_display_off(panel);
 
-	s6e8ax0_regulator_disable(lcd);
+	s6e8ax0_regulator_disable(panel);
 
 	return 0;
 }
 
-static int s6e8ax0_resume(struct mipi_dsim_lcd_device *dsim_dev)
+static int s6e8ax0_resume(struct device *dev)
 {
-	struct s6e8ax0 *lcd = dev_get_drvdata(&dsim_dev->dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct s6e8ax0 *panel = platform_get_drvdata(pdev);
 
-	s6e8ax0_sleep_out(lcd);
-	msleep(lcd->ddi_pd->power_on_delay);
+	s6e8ax0_sleep_out(panel);
+	msleep(panel->plat_data->power_on_delay);
 
-	s6e8ax0_regulator_enable(lcd);
-	s6e8ax0_set_sequence(dsim_dev);
+	s6e8ax0_regulator_enable(panel);
+	s6e8ax0_set_sequence(panel);
 
 	return 0;
 }
-#else
-#define s6e8ax0_suspend		NULL
-#define s6e8ax0_resume		NULL
 #endif
 
-static struct mipi_dsim_lcd_driver s6e8ax0_dsim_ddi_driver = {
-	.name = "s6e8ax0",
-	.id = -1,
+static int panel_remove(struct platform_device *pdev)
+{
+	struct s6e8ax0 *panel = platform_get_drvdata(pdev);
 
-	.power_on = s6e8ax0_power_on,
-	.set_sequence = s6e8ax0_set_sequence,
-	.probe = s6e8ax0_probe,
-	.suspend = s6e8ax0_suspend,
-	.resume = s6e8ax0_resume,
-};
+	dev_dbg(&pdev->dev, "remove\n");
 
-static int s6e8ax0_init(void)
-{
-	exynos_mipi_dsi_register_lcd_driver(&s6e8ax0_dsim_ddi_driver);
+	display_entity_unregister(&panel->entity);
+
+	video_source_put(panel->src);
 
 	return 0;
 }
 
-static void s6e8ax0_exit(void)
-{
-	return;
-}
+static const struct dev_pm_ops s6e8ax0_panel_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(s6e8ax0_suspend, s6e8ax0_resume)
+};
+
+static struct platform_driver s6e8ax0_driver = {
+	.probe = s6e8ax0_probe,
+	.remove = __devexit_p(panel_remove),
+	.driver = {
+		   .name = "s6e8ax0",
+		   .owner = THIS_MODULE,
+		   .pm = &s6e8ax0_panel_pm_ops,
+	},
+};
 
-module_init(s6e8ax0_init);
-module_exit(s6e8ax0_exit);
+module_platform_driver(s6e8ax0_driver);
 
 MODULE_AUTHOR("Donghwa Lee <dh09.lee@samsung.com>");
 MODULE_AUTHOR("Inki Dae <inki.dae@samsung.com>");
-- 
1.7.9.5

