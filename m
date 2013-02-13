Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f45.google.com ([209.85.210.45]:33976 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933513Ab3BMKBj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Feb 2013 05:01:39 -0500
Received: by mail-da0-f45.google.com with SMTP id w4so489578dam.32
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2013 02:01:38 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, l.krishna@samsung.com, joshi@samsung.com,
	aditya.ps@samsung.com, tom.gall@linaro.org, patches@linaro.org,
	linux-samsung-soc@vger.kernel.org, ragesh.r@linaro.org,
	jesse.barker@linaro.org, robdclark@gmail.com,
	sumit.semwal@linaro.org
Subject: [RFC v2 3/3] video: exynos: Making s6e8ax0 panel driver compliant with CDF
Date: Wed, 13 Feb 2013 15:31:07 +0530
Message-Id: <1360749667-12028-4-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1360749667-12028-1-git-send-email-vikas.sajjan@linaro.org>
References: <1360749667-12028-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Made necessary changes in s6e8ax0 panel driver as per the  CDF-T.
It also removes the dependency on backlight and lcd framework

Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/video/exynos/s6e8ax0.c |  848 +++++++++++++++++++++-------------------
 1 file changed, 444 insertions(+), 404 deletions(-)

diff --git a/drivers/video/exynos/s6e8ax0.c b/drivers/video/exynos/s6e8ax0.c
index 7f7b25f..5a17e3c 100644
--- a/drivers/video/exynos/s6e8ax0.c
+++ b/drivers/video/exynos/s6e8ax0.c
@@ -25,6 +25,7 @@
 #include <linux/backlight.h>
 #include <linux/regulator/consumer.h>
 
+#include <video/display.h>
 #include <video/mipi_display.h>
 #include <video/exynos_mipi_dsim.h>
 
@@ -38,8 +39,7 @@
 #define POWER_IS_OFF(pwr)	((pwr) == FB_BLANK_POWERDOWN)
 #define POWER_IS_NRM(pwr)	((pwr) == FB_BLANK_NORMAL)
 
-#define lcd_to_master(a)	(a->dsim_dev->master)
-#define lcd_to_master_ops(a)	((lcd_to_master(a))->master_ops)
+#define to_panel(p) container_of(p, struct s6e8ax0, entity)
 
 enum {
 	DSIM_NONE_STATE = 0,
@@ -47,20 +47,34 @@ enum {
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
+	struct lcd_platform_data	*plat_data;
 	struct mutex			lock;
+	struct backlight_prop		bl_prop;
 	bool  enabled;
 };
 
@@ -70,192 +84,194 @@ static struct regulator_bulk_data supplies[] = {
 	{ .supply = "vci", },
 };
 
-static void s6e8ax0_regulator_enable(struct s6e8ax0 *lcd)
+static void s6e8ax0_regulator_enable(struct s6e8ax0 *panel)
 {
 	int ret = 0;
-	struct lcd_platform_data *pd = NULL;
+	struct lcd_platform_data *plat_data = NULL;
 
-	pd = lcd->ddi_pd;
-	mutex_lock(&lcd->lock);
-	if (!lcd->enabled) {
+	plat_data = panel->plat_data;
+
+	mutex_lock(&panel->lock);
+
+	if (!panel->enabled) {
 		ret = regulator_bulk_enable(ARRAY_SIZE(supplies), supplies);
 		if (ret)
 			goto out;
-
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
 
-static const unsigned char s6e8ax0_22_gamma_30[] = {
+static unsigned char s6e8ax0_22_gamma_30[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xf5, 0x00, 0xff, 0xad, 0xaf,
 	0xbA, 0xc3, 0xd8, 0xc5, 0x9f, 0xc6, 0x9e, 0xc1, 0xdc, 0xc0,
 	0x00, 0x61, 0x00, 0x5a, 0x00, 0x74,
 };
 
-static const unsigned char s6e8ax0_22_gamma_50[] = {
+static unsigned char s6e8ax0_22_gamma_50[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xe8, 0x1f, 0xf7, 0xad, 0xc0,
 	0xb5, 0xc4, 0xdc, 0xc4, 0x9e, 0xc6, 0x9c, 0xbb, 0xd8, 0xbb,
 	0x00, 0x70, 0x00, 0x68, 0x00, 0x86,
 };
 
-static const unsigned char s6e8ax0_22_gamma_60[] = {
+static unsigned char s6e8ax0_22_gamma_60[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xde, 0x1f, 0xef, 0xad, 0xc4,
 	0xb3, 0xc3, 0xdd, 0xc4, 0x9e, 0xc6, 0x9c, 0xbc, 0xd6, 0xba,
 	0x00, 0x75, 0x00, 0x6e, 0x00, 0x8d,
 };
 
-static const unsigned char s6e8ax0_22_gamma_70[] = {
+static unsigned char s6e8ax0_22_gamma_70[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xd8, 0x1f, 0xe7, 0xaf, 0xc8,
 	0xb4, 0xc4, 0xdd, 0xc3, 0x9d, 0xc6, 0x9c, 0xbb, 0xd6, 0xb9,
 	0x00, 0x7a, 0x00, 0x72, 0x00, 0x93,
 };
 
-static const unsigned char s6e8ax0_22_gamma_80[] = {
+static unsigned char s6e8ax0_22_gamma_80[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xc9, 0x1f, 0xde, 0xae, 0xc9,
 	0xb1, 0xc3, 0xdd, 0xc2, 0x9d, 0xc5, 0x9b, 0xbc, 0xd6, 0xbb,
 	0x00, 0x7f, 0x00, 0x77, 0x00, 0x99,
 };
 
-static const unsigned char s6e8ax0_22_gamma_90[] = {
+static unsigned char s6e8ax0_22_gamma_90[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xc7, 0x1f, 0xd9, 0xb0, 0xcc,
 	0xb2, 0xc3, 0xdc, 0xc1, 0x9c, 0xc6, 0x9c, 0xbc, 0xd4, 0xb9,
 	0x00, 0x83, 0x00, 0x7b, 0x00, 0x9e,
 };
 
-static const unsigned char s6e8ax0_22_gamma_100[] = {
+static unsigned char s6e8ax0_22_gamma_100[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xbd, 0x80, 0xcd, 0xba, 0xce,
 	0xb3, 0xc4, 0xde, 0xc3, 0x9c, 0xc4, 0x9, 0xb8, 0xd3, 0xb6,
 	0x00, 0x88, 0x00, 0x80, 0x00, 0xa5,
 };
 
-static const unsigned char s6e8ax0_22_gamma_120[] = {
+static unsigned char s6e8ax0_22_gamma_120[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xb9, 0x95, 0xc8, 0xb1, 0xcf,
 	0xb2, 0xc6, 0xdf, 0xc5, 0x9b, 0xc3, 0x99, 0xb6, 0xd2, 0xb6,
 	0x00, 0x8f, 0x00, 0x86, 0x00, 0xac,
 };
 
-static const unsigned char s6e8ax0_22_gamma_130[] = {
+static unsigned char s6e8ax0_22_gamma_130[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xb7, 0xa0, 0xc7, 0xb1, 0xd0,
 	0xb2, 0xc4, 0xdd, 0xc3, 0x9a, 0xc3, 0x98, 0xb6, 0xd0, 0xb4,
 	0x00, 0x92, 0x00, 0x8a, 0x00, 0xb1,
 };
 
-static const unsigned char s6e8ax0_22_gamma_140[] = {
+static unsigned char s6e8ax0_22_gamma_140[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xb7, 0xa0, 0xc5, 0xb2, 0xd0,
 	0xb3, 0xc3, 0xde, 0xc3, 0x9b, 0xc2, 0x98, 0xb6, 0xd0, 0xb4,
 	0x00, 0x95, 0x00, 0x8d, 0x00, 0xb5,
 };
 
-static const unsigned char s6e8ax0_22_gamma_150[] = {
+static unsigned char s6e8ax0_22_gamma_150[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xb3, 0xa0, 0xc2, 0xb2, 0xd0,
 	0xb2, 0xc1, 0xdd, 0xc2, 0x9b, 0xc2, 0x98, 0xb4, 0xcf, 0xb1,
 	0x00, 0x99, 0x00, 0x90, 0x00, 0xba,
 };
 
-static const unsigned char s6e8ax0_22_gamma_160[] = {
+static unsigned char s6e8ax0_22_gamma_160[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xaf, 0xa5, 0xbf, 0xb0, 0xd0,
 	0xb1, 0xc3, 0xde, 0xc2, 0x99, 0xc1, 0x97, 0xb4, 0xce, 0xb1,
 	0x00, 0x9c, 0x00, 0x93, 0x00, 0xbe,
 };
 
-static const unsigned char s6e8ax0_22_gamma_170[] = {
+static unsigned char s6e8ax0_22_gamma_170[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xaf, 0xb5, 0xbf, 0xb1, 0xd1,
 	0xb1, 0xc3, 0xde, 0xc3, 0x99, 0xc0, 0x96, 0xb4, 0xce, 0xb1,
 	0x00, 0x9f, 0x00, 0x96, 0x00, 0xc2,
 };
 
-static const unsigned char s6e8ax0_22_gamma_180[] = {
+static unsigned char s6e8ax0_22_gamma_180[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xaf, 0xb7, 0xbe, 0xb3, 0xd2,
 	0xb3, 0xc3, 0xde, 0xc2, 0x97, 0xbf, 0x95, 0xb4, 0xcd, 0xb1,
 	0x00, 0xa2, 0x00, 0x99, 0x00, 0xc5,
 };
 
-static const unsigned char s6e8ax0_22_gamma_190[] = {
+static unsigned char s6e8ax0_22_gamma_190[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xaf, 0xb9, 0xbe, 0xb2, 0xd2,
 	0xb2, 0xc3, 0xdd, 0xc3, 0x98, 0xbf, 0x95, 0xb2, 0xcc, 0xaf,
 	0x00, 0xa5, 0x00, 0x9c, 0x00, 0xc9,
 };
 
-static const unsigned char s6e8ax0_22_gamma_200[] = {
+static unsigned char s6e8ax0_22_gamma_200[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xaf, 0xb9, 0xbc, 0xb2, 0xd2,
 	0xb1, 0xc4, 0xdd, 0xc3, 0x97, 0xbe, 0x95, 0xb1, 0xcb, 0xae,
 	0x00, 0xa8, 0x00, 0x9f, 0x00, 0xcd,
 };
 
-static const unsigned char s6e8ax0_22_gamma_210[] = {
+static unsigned char s6e8ax0_22_gamma_210[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xb1, 0xc1, 0xbd, 0xb1, 0xd1,
 	0xb1, 0xc2, 0xde, 0xc2, 0x97, 0xbe, 0x94, 0xB0, 0xc9, 0xad,
 	0x00, 0xae, 0x00, 0xa4, 0x00, 0xd4,
 };
 
-static const unsigned char s6e8ax0_22_gamma_220[] = {
+static unsigned char s6e8ax0_22_gamma_220[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xb1, 0xc7, 0xbd, 0xb1, 0xd1,
 	0xb1, 0xc2, 0xdd, 0xc2, 0x97, 0xbd, 0x94, 0xb0, 0xc9, 0xad,
 	0x00, 0xad, 0x00, 0xa2, 0x00, 0xd3,
 };
 
-static const unsigned char s6e8ax0_22_gamma_230[] = {
+static unsigned char s6e8ax0_22_gamma_230[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xb1, 0xc3, 0xbd, 0xb2, 0xd1,
 	0xb1, 0xc3, 0xdd, 0xc1, 0x96, 0xbd, 0x94, 0xb0, 0xc9, 0xad,
 	0x00, 0xb0, 0x00, 0xa7, 0x00, 0xd7,
 };
 
-static const unsigned char s6e8ax0_22_gamma_240[] = {
+static unsigned char s6e8ax0_22_gamma_240[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xb1, 0xcb, 0xbd, 0xb1, 0xd2,
 	0xb1, 0xc3, 0xdD, 0xc2, 0x95, 0xbd, 0x93, 0xaf, 0xc8, 0xab,
 	0x00, 0xb3, 0x00, 0xa9, 0x00, 0xdb,
 };
 
-static const unsigned char s6e8ax0_22_gamma_250[] = {
+static unsigned char s6e8ax0_22_gamma_250[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xb3, 0xcc, 0xbe, 0xb0, 0xd2,
 	0xb0, 0xc3, 0xdD, 0xc2, 0x94, 0xbc, 0x92, 0xae, 0xc8, 0xab,
 	0x00, 0xb6, 0x00, 0xab, 0x00, 0xde,
 };
 
-static const unsigned char s6e8ax0_22_gamma_260[] = {
+static unsigned char s6e8ax0_22_gamma_260[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xb3, 0xd0, 0xbe, 0xaf, 0xd1,
 	0xaf, 0xc2, 0xdd, 0xc1, 0x96, 0xbc, 0x93, 0xaf, 0xc8, 0xac,
 	0x00, 0xb7, 0x00, 0xad, 0x00, 0xe0,
 };
 
-static const unsigned char s6e8ax0_22_gamma_270[] = {
+static unsigned char s6e8ax0_22_gamma_270[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xb2, 0xcF, 0xbd, 0xb0, 0xd2,
 	0xaf, 0xc2, 0xdc, 0xc1, 0x95, 0xbd, 0x93, 0xae, 0xc6, 0xaa,
 	0x00, 0xba, 0x00, 0xb0, 0x00, 0xe4,
 };
 
-static const unsigned char s6e8ax0_22_gamma_280[] = {
+static unsigned char s6e8ax0_22_gamma_280[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xb2, 0xd0, 0xbd, 0xaf, 0xd0,
 	0xad, 0xc4, 0xdd, 0xc3, 0x95, 0xbd, 0x93, 0xac, 0xc5, 0xa9,
 	0x00, 0xbd, 0x00, 0xb2, 0x00, 0xe7,
 };
 
-static const unsigned char s6e8ax0_22_gamma_300[] = {
+static unsigned char s6e8ax0_22_gamma_300[] = {
 	0xfa, 0x01, 0x60, 0x10, 0x60, 0xb5, 0xd3, 0xbd, 0xb1, 0xd2,
 	0xb0, 0xc0, 0xdc, 0xc0, 0x94, 0xba, 0x91, 0xac, 0xc5, 0xa9,
 	0x00, 0xc2, 0x00, 0xb7, 0x00, 0xed,
 };
 
-static const unsigned char *s6e8ax0_22_gamma_table[] = {
+static unsigned char *s6e8ax0_22_gamma_table[] = {
 	s6e8ax0_22_gamma_30,
 	s6e8ax0_22_gamma_50,
 	s6e8ax0_22_gamma_60,
@@ -283,650 +299,674 @@ static const unsigned char *s6e8ax0_22_gamma_table[] = {
 	s6e8ax0_22_gamma_300,
 };
 
-static void s6e8ax0_panel_cond(struct s6e8ax0 *lcd)
+static void s6e8ax0_panel_cond(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
 		0xf8, 0x3d, 0x35, 0x00, 0x00, 0x00, 0x93, 0x00, 0x3c, 0x7d,
 		0x08, 0x27, 0x7d, 0x3f, 0x00, 0x00, 0x00, 0x20, 0x04, 0x08,
 		0x6e, 0x00, 0x00, 0x00, 0x02, 0x08, 0x08, 0x23, 0x23, 0xc0,
 		0xc8, 0x08, 0x48, 0xc1, 0x00, 0xc1, 0xff, 0xff, 0xc8
 	};
-	static const unsigned char data_to_send_panel_reverse[] = {
+	static unsigned char data_to_send_panel_reverse[] = {
 		0xf8, 0x19, 0x35, 0x00, 0x00, 0x00, 0x93, 0x00, 0x3c, 0x7d,
 		0x08, 0x27, 0x7d, 0x3f, 0x00, 0x00, 0x00, 0x20, 0x04, 0x08,
 		0x6e, 0x00, 0x00, 0x00, 0x02, 0x08, 0x08, 0x23, 0x23, 0xc0,
 		0xc1, 0x01, 0x41, 0xc1, 0x00, 0xc1, 0xf6, 0xf6, 0xc1
 	};
-
-	if (lcd->dsim_dev->panel_reverse)
-		ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
-				data_to_send_panel_reverse,
+	if (panel->panel_reverse)
+		panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE, data_to_send_panel_reverse,
 				ARRAY_SIZE(data_to_send_panel_reverse));
 	else
-		ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
-				data_to_send, ARRAY_SIZE(data_to_send));
+		panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE, data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_display_cond(struct s6e8ax0 *lcd)
+static void s6e8ax0_display_cond(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
 		0xf2, 0x80, 0x03, 0x0d
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
-		data_to_send, ARRAY_SIZE(data_to_send));
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE, data_to_send, ARRAY_SIZE(data_to_send));
 }
 
 /* Gamma 2.2 Setting (200cd, 7500K, 10MPCD) */
-static void s6e8ax0_gamma_cond(struct s6e8ax0 *lcd)
+static void s6e8ax0_gamma_cond(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-	unsigned int gamma = lcd->bd->props.brightness;
+	unsigned int gamma = panel->bl_prop.brightness;
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
-			s6e8ax0_22_gamma_table[gamma],
-			GAMMA_TABLE_COUNT);
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE, s6e8ax0_22_gamma_table[gamma], GAMMA_TABLE_COUNT);
 }
 
-static void s6e8ax0_gamma_update(struct s6e8ax0 *lcd)
+static void s6e8ax0_gamma_update(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
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
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
 		0xd1, 0xfe, 0x80, 0x00, 0x01, 0x0b, 0x00, 0x00, 0x40,
 		0x0d, 0x00, 0x00
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
-		data_to_send, ARRAY_SIZE(data_to_send));
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE, data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_etc_cond2(struct s6e8ax0 *lcd)
+static void s6e8ax0_etc_cond2(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-	static const unsigned char data_to_send[] = {
-		0xb6, 0x0c, 0x02, 0x03, 0x32, 0xff, 0x44, 0x44, 0xc0,
-		0x00
+	static unsigned char data_to_send[] = {
+		0xb6, 0x0c, 0x02, 0x03, 0x32, 0xff, 0x44, 0x44, 0xc0, 0x00
 	};
-
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
-		data_to_send, ARRAY_SIZE(data_to_send));
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE, data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_etc_cond3(struct s6e8ax0 *lcd)
+static void s6e8ax0_etc_cond3(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
 		0xe1, 0x10, 0x1c, 0x17, 0x08, 0x1d
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
-		data_to_send, ARRAY_SIZE(data_to_send));
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE, data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_etc_cond4(struct s6e8ax0 *lcd)
+static void s6e8ax0_etc_cond4(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
 		0xe2, 0xed, 0x07, 0xc3, 0x13, 0x0d, 0x03
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
-		data_to_send, ARRAY_SIZE(data_to_send));
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE, data_to_send, ARRAY_SIZE(data_to_send));
+
 }
 
-static void s6e8ax0_etc_cond5(struct s6e8ax0 *lcd)
+static void s6e8ax0_etc_cond5(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
 		0xf4, 0xcf, 0x0a, 0x12, 0x10, 0x19, 0x33, 0x02
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
-		data_to_send, ARRAY_SIZE(data_to_send));
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE, data_to_send, ARRAY_SIZE(data_to_send));
+
 }
-static void s6e8ax0_etc_cond6(struct s6e8ax0 *lcd)
+static void s6e8ax0_etc_cond6(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
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
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
 		0xe4, 0x00, 0x00, 0x14, 0x80, 0x00, 0x00, 0x00
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
-		data_to_send, ARRAY_SIZE(data_to_send));
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE, data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_elvss_set(struct s6e8ax0 *lcd)
+static void s6e8ax0_elvss_set(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
 		0xb1, 0x04, 0x00
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
-		data_to_send, ARRAY_SIZE(data_to_send));
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE, data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_elvss_nvm_set(struct s6e8ax0 *lcd)
+static void s6e8ax0_elvss_nvm_set(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
 		0xd9, 0x5c, 0x20, 0x0c, 0x0f, 0x41, 0x00, 0x10, 0x11,
 		0x12, 0xd1, 0x00, 0x00, 0x00, 0x00, 0x80, 0xcb, 0xed,
 		0x64, 0xaf
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
-		data_to_send, ARRAY_SIZE(data_to_send));
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE, data_to_send, ARRAY_SIZE(data_to_send));
+
 }
 
-static void s6e8ax0_sleep_in(struct s6e8ax0 *lcd)
+static void s6e8ax0_sleep_in(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
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
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
 		0x11, 0x00
 	};
 
-	ops->cmd_write(lcd_to_master(lcd),
+	panel->src->ops.dsi->dcs_write(panel->src,
 		MIPI_DSI_DCS_SHORT_WRITE,
 		data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-void init_lcd(struct s6e8ax0 *lcd)
-{
-	static const unsigned char data_to_send1[] = {
-		0x0, 0x0
-	};
-	static const unsigned char data_to_send2[] = {
-		0x11, 0x00
-	};
-	static const unsigned char data_to_send3[] = {
-		0x0, 0x0
-	};
-
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_SHORT_WRITE,
-		data_to_send1, ARRAY_SIZE(data_to_send1));
-	msleep(60);
-
-	/* Exit sleep */
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_SHORT_WRITE,
-		data_to_send2, ARRAY_SIZE(data_to_send2));
-
-	msleep(600);
-
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_TURN_ON_PERIPHERAL,
-		data_to_send3, ARRAY_SIZE(data_to_send3));
-}
-
-static void s6e8ax0_display_on(struct s6e8ax0 *lcd)
+static void s6e8ax0_display_on(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
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
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
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
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
 		0xf0, 0x5a, 0x5a
 	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
-		data_to_send, ARRAY_SIZE(data_to_send));
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE, data_to_send, ARRAY_SIZE(data_to_send));
 }
 
-static void s6e8ax0_acl_on(struct s6e8ax0 *lcd)
+static void s6e8ax0_acl_on(struct s6e8ax0 *panel)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
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
-	static const unsigned char data_to_send[] = {
+	static unsigned char data_to_send[] = {
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
-	static const unsigned char cutoff_50[] = {
+	static unsigned char cutoff_50[] = {
 		0xc1, 0x47, 0x53, 0x13, 0x53, 0x00, 0x00, 0x02, 0xcf,
 		0x00, 0x00, 0x04, 0xff,	0x00, 0x00, 0x00, 0x00, 0x00,
 		0x01, 0x08, 0x0f, 0x16, 0x1d, 0x24, 0x2a, 0x31, 0x38,
 		0x3f, 0x46
 	};
 	/* Full white 45% reducing setting */
-	static const unsigned char cutoff_45[] = {
+	static unsigned char cutoff_45[] = {
 		0xc1, 0x47, 0x53, 0x13, 0x53, 0x00, 0x00, 0x02, 0xcf,
 		0x00, 0x00, 0x04, 0xff,	0x00, 0x00, 0x00, 0x00, 0x00,
 		0x01, 0x07, 0x0d, 0x13, 0x19, 0x1f, 0x25, 0x2b, 0x31,
 		0x37, 0x3d
 	};
 	/* Full white 40% reducing setting */
-	static const unsigned char cutoff_40[] = {
+	static unsigned char cutoff_40[] = {
 		0xc1, 0x47, 0x53, 0x13, 0x53, 0x00, 0x00, 0x02, 0xcf,
 		0x00, 0x00, 0x04, 0xff,	0x00, 0x00, 0x00, 0x00, 0x00,
 		0x01, 0x06, 0x0c, 0x11, 0x16, 0x1c, 0x21, 0x26, 0x2b,
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
-			MIPI_DSI_GENERIC_READ_REQUEST_1_PARAM,
-			addr, 3, mtp_id);
+	ret = panel->src->ops.dsi->dcs_read(panel->src,
+			MIPI_DSI_GENERIC_READ_REQUEST_1_PARAM, addr,
+			mtp_id, 3);
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
-
+	msleep(panel->plat_data->power_on_delay);
 	return 0;
 }
 
-static int s6e8ax0_update_gamma_ctrl(struct s6e8ax0 *lcd, int brightness)
+static int s6e8ax0_update_gamma_ctrl(struct s6e8ax0 *panel, int brightness)
 {
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
-			s6e8ax0_22_gamma_table[brightness],
-			ARRAY_SIZE(s6e8ax0_22_gamma_table));
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_LONG_WRITE, s6e8ax0_22_gamma_table[brightness], ARRAY_SIZE(s6e8ax0_22_gamma_table));
 
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
+ {
+ 	int ret = 0;
+ 
+ 	if (power != FB_BLANK_UNBLANK && power != FB_BLANK_POWERDOWN &&
+ 			power != FB_BLANK_NORMAL) {
+		dev_err(&panel->pdev->dev, "power value should be 0, 1 or 4.\n");
+ 		return -EINVAL;
+ 	}
+ 
+	if ((power == FB_BLANK_UNBLANK) && panel->src->ops.dsi->set_blank_mode) {
+ 		/* LCD power on */
+		if ((POWER_IS_ON(power) && POWER_IS_OFF(panel->power))
+			|| (POWER_IS_ON(power) && POWER_IS_NRM(panel->power))) {
+			ret = panel->src->ops.dsi->set_blank_mode(panel->src,
+									power);
+			if (!ret && panel->power != power)
+				panel->power = power;
+ 		}
+	} else if ((power == FB_BLANK_POWERDOWN) &&
+			panel->src->ops.dsi->set_early_blank_mode) {
+ 		/* LCD power off */
+		if ((POWER_IS_OFF(power) && POWER_IS_ON(panel->power)) ||
+		(POWER_IS_ON(panel->power) && POWER_IS_NRM(power))) {
+			ret = panel->src->ops.dsi->set_early_blank_mode(panel->src, power);
+			if (!ret && panel->power != power)
+				panel->power = power;
+ 		}
+ 	}
+ 
+ 	return ret;
+ }
+
+static int s6e8ax0_get_brightness(struct s6e8ax0 *panel)
+ {
+	return panel->bl_prop.brightness;
+ }
+ 
+static int s6e8ax0_set_brightness(struct s6e8ax0 *panel)
+{
+	int ret = 0, brightness = panel->bl_prop.brightness;
+ 
+ 	if (brightness < MIN_BRIGHTNESS ||
+		brightness > panel->bl_prop.max_brightness) {
+		dev_err(&panel->pdev->dev, "lcd brightness should be %d to %d.\n", MIN_BRIGHTNESS, MAX_BRIGHTNESS);
+ 		return -EINVAL;
+ 	}
+ 
+	ret = s6e8ax0_gamma_ctrl(panel, brightness);
+ 	if (ret) {
+		dev_err(&panel->pdev->dev, "lcd brightness setting failed.\n");
+ 		return -EIO;
+ 	}
+ 
+ 	return ret;
+ }
+ 
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
 {
-	struct s6e8ax0 *lcd = lcd_get_data(ld);
-	struct mipi_dsim_master_ops *ops = lcd_to_master_ops(lcd);
-	int ret = 0;
+	struct s6e8ax0 *panel = to_panel(entity);
+	struct video_source *src = panel->src;
 
-	if (power != FB_BLANK_UNBLANK && power != FB_BLANK_POWERDOWN &&
-			power != FB_BLANK_NORMAL) {
-		dev_err(lcd->dev, "power value should be 0, 1 or 4.\n");
-		return -EINVAL;
-	}
+	return src->ops.dsi->update(src, 0, callback, data);
+}
 
-	if ((power == FB_BLANK_UNBLANK) && ops->set_blank_mode) {
-		/* LCD power on */
-		if ((POWER_IS_ON(power) && POWER_IS_OFF(lcd->power))
-			|| (POWER_IS_ON(power) && POWER_IS_NRM(lcd->power))) {
-			ret = ops->set_blank_mode(lcd_to_master(lcd), power);
-			if (!ret && lcd->power != power)
-				lcd->power = power;
-		}
-	} else if ((power == FB_BLANK_POWERDOWN) && ops->set_early_blank_mode) {
-		/* LCD power off */
-		if ((POWER_IS_OFF(power) && POWER_IS_ON(lcd->power)) ||
-		(POWER_IS_ON(lcd->power) && POWER_IS_NRM(power))) {
-			ret = ops->set_early_blank_mode(lcd_to_master(lcd),
-							power);
-			if (!ret && lcd->power != power)
-				lcd->power = power;
-		}
-	}
+static int panel_dcs_write(struct s6e8ax0 *panel, u8 dcs_cmd)
+{
+	struct video_source *src = panel->src;
 
-	return ret;
+	return src->ops.dsi->dcs_write(src, 0, &dcs_cmd, 1);
 }
 
-static int s6e8ax0_get_power(struct lcd_device *ld)
+static int panel_set_state(struct display_entity *entity,
+			       enum display_entity_state state)
 {
-	struct s6e8ax0 *lcd = lcd_get_data(ld);
+	struct s6e8ax0 *panel = to_panel(entity);
+	int ret;
+
+	switch (state) {
+	case DISPLAY_ENTITY_STATE_OFF:
+	case DISPLAY_ENTITY_STATE_STANDBY:
+		ret = panel_dcs_write(panel, MIPI_DCS_SET_DISPLAY_OFF);
+		if (ret)
+			pr_err("display off failed\n");
 
-	return lcd->power;
+		s6e8ax0_set_power(panel, FB_BLANK_POWERDOWN);
+
+		break;
+ 
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
 }
 
-static int s6e8ax0_get_brightness(struct backlight_device *bd)
+static const struct display_entity_control_ops panel_control_ops = {
+	.set_state = panel_set_state,
+	.get_modes = panel_get_modes,
+	.get_size = panel_get_size,
+	.update = panel_update,
+  };
+
+static void panel_release(struct display_entity *entity)
 {
-	return bd->props.brightness;
+	pr_info("panel release\n");
 }
-
-static int s6e8ax0_set_brightness(struct backlight_device *bd)
+ 
+static void s6e8ax0_power_on(struct s6e8ax0 *panel, int power)
 {
-	int ret = 0, brightness = bd->props.brightness;
-	struct s6e8ax0 *lcd = bl_get_data(bd);
+	msleep(panel->plat_data->power_on_delay);
+ 
+ 	/* lcd power on */
+ 	if (power)
+		s6e8ax0_regulator_enable(panel);
+ 	else
+		s6e8ax0_regulator_disable(panel);
 
-	if (brightness < MIN_BRIGHTNESS ||
-		brightness > bd->props.max_brightness) {
-		dev_err(lcd->dev, "lcd brightness should be %d to %d.\n",
-			MIN_BRIGHTNESS, MAX_BRIGHTNESS);
-		return -EINVAL;
-	}
+	msleep(panel->plat_data->reset_delay);
 
-	ret = s6e8ax0_gamma_ctrl(lcd, brightness);
-	if (ret) {
-		dev_err(&bd->dev, "lcd brightness setting failed.\n");
-		return -EIO;
-	}
+	panel->plat_data->power_on(NULL, 1);
 
-	return ret;
+ 	msleep(5);
 }
 
-static struct lcd_ops s6e8ax0_lcd_ops = {
-	.set_power = s6e8ax0_set_power,
-	.get_power = s6e8ax0_get_power,
-};
+void init_lcd(struct s6e8ax0 *panel)
+{
+	static unsigned char data_to_send1[] = {
+               0x0, 0x0
+	};
 
-static const struct backlight_ops s6e8ax0_backlight_ops = {
-	.get_brightness = s6e8ax0_get_brightness,
-	.update_status = s6e8ax0_set_brightness,
-};
+	static unsigned char data_to_send2[] = {
+	      0x11, 0x00
+	};
 
-static void s6e8ax0_power_on(struct mipi_dsim_lcd_device *dsim_dev, int power)
-{
-	struct s6e8ax0 *lcd = dev_get_drvdata(&dsim_dev->dev);
+       static unsigned char data_to_send3[] = {
+               0x0, 0x0
+       };
 
-	msleep(lcd->ddi_pd->power_on_delay);
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_SHORT_WRITE,
+			data_to_send1, ARRAY_SIZE(data_to_send1));
 
-	/* lcd power on */
-	if (power)
-		s6e8ax0_regulator_enable(lcd);
-	else
-		s6e8ax0_regulator_disable(lcd);
+	msleep(60);
 
-	msleep(lcd->ddi_pd->reset_delay);
+	/* Exit sleep */
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_DCS_SHORT_WRITE,
+	               data_to_send2, ARRAY_SIZE(data_to_send2));
+
+	msleep(600);
 
-	lcd->ddi_pd->power_on(NULL, 1);
+	panel->src->ops.dsi->dcs_write(panel->src, MIPI_DSI_TURN_ON_PERIPHERAL,
+			          data_to_send3, ARRAY_SIZE(data_to_send3));
 }
 
-static void s6e8ax0_set_sequence(struct mipi_dsim_lcd_device *dsim_dev)
+static void s6e8ax0_set_sequence(struct s6e8ax0 *panel)
 {
-	struct s6e8ax0 *lcd = dev_get_drvdata(&dsim_dev->dev);
+	s6e8ax0_panel_init(panel);
+	s6e8ax0_display_on(panel);
+	init_lcd(panel);
 
-	s6e8ax0_panel_init(lcd);
-	s6e8ax0_display_on(lcd);
-	init_lcd(lcd);
-	lcd->power = FB_BLANK_UNBLANK;
+	panel->power = FB_BLANK_UNBLANK;
+
+	return;
 }
 
-static int s6e8ax0_probe(struct mipi_dsim_lcd_device *dsim_dev)
+static int s6e8ax0_probe(struct platform_device *pdev)
 {
-	struct s6e8ax0 *lcd;
 	int ret;
+	struct s6e8ax0 *panel;
 	u8 mtp_id[3] = {0, };
 
-	lcd = kzalloc(sizeof(struct s6e8ax0), GFP_KERNEL);
-	if (!lcd) {
-		dev_err(&dsim_dev->dev, "failed to allocate s6e8ax0 structure.\n");
+	panel = devm_kzalloc(&pdev->dev, sizeof(struct s6e8ax0), GFP_KERNEL);
+	if (!panel) {
+		dev_err(&pdev->dev, "failed to allocate s6e8ax0 structure.\n");
 		return -ENOMEM;
 	}
+	panel->plat_data =
+                       (struct lcd_platform_data *)pdev->dev.platform_data;
 
-	lcd->dsim_dev = dsim_dev;
-	lcd->ddi_pd = (struct lcd_platform_data *)dsim_dev->platform_data;
-	lcd->dev = &dsim_dev->dev;
+	mutex_init(&panel->lock);
 
-	mutex_init(&lcd->lock);
+	ret = regulator_bulk_get(&panel->pdev->dev, ARRAY_SIZE(supplies), supplies);
 
-	ret = regulator_bulk_get(lcd->dev, ARRAY_SIZE(supplies), supplies);
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
+	panel->bl_prop.max_brightness = MAX_BRIGHTNESS;
+	panel->bl_prop.brightness = MAX_BRIGHTNESS;
 
-	lcd->bd = backlight_device_register("s6e8ax0-bl", lcd->dev, lcd,
-			&s6e8ax0_backlight_ops, NULL);
-	if (IS_ERR(lcd->bd)) {
-		dev_err(lcd->dev, "failed to register backlight ops.\n");
-		ret = PTR_ERR(lcd->bd);
-		goto err_backlight_register;
-	}
-
-	lcd->bd->props.max_brightness = MAX_BRIGHTNESS;
-	lcd->bd->props.brightness = MAX_BRIGHTNESS;
-
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
+ 
+	platform_set_drvdata(pdev, panel);
+ 
+	/* setup input */
+	panel->src = video_source_find("exynos-mipi-dsim");
+	if (panel->src == NULL) {
+		pr_err("failed to get video source\n");
+		goto err_panel_register;
+	}
+ 
+	s6e8ax0_read_id(panel, mtp_id);
 
-	dev_set_drvdata(&dsim_dev->dev, lcd);
+	s6e8ax0_power_on(panel, 1);
 
-	dev_dbg(lcd->dev, "probed s6e8ax0 panel driver.\n");
+	panel->src->ops.dsi->enable_hs(panel->src,1);
 
-	return 0;
+	s6e8ax0_set_sequence(panel);
 
-err_backlight_register:
-	lcd_device_unregister(lcd->ld);
+	/* setup panel entity */
+	panel->entity.dev = &pdev->dev;
+	panel->entity.release = panel_release;
+	panel->entity.ops = &panel_control_ops;
+ 
+	ret = display_entity_register(&panel->entity);
+ 
+	if (ret < 0) {
+		pr_err("failed to register display entity\n");
+		goto err_panel_register;
+	}
 
-err_lcd_register:
-	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
-	kfree(lcd);
+	panel->panel_reverse = 0;
 
-	return ret;
-}
-
-#ifdef CONFIG_PM
-static int s6e8ax0_suspend(struct mipi_dsim_lcd_device *dsim_dev)
-{
-	struct s6e8ax0 *lcd = dev_get_drvdata(&dsim_dev->dev);
+	dev_dbg(&pdev->dev, "probed s6e8ax0 panel driver.\n");
 
-	s6e8ax0_sleep_in(lcd);
-	msleep(lcd->ddi_pd->power_off_delay);
-	s6e8ax0_display_off(lcd);
+	return 0;
 
-	s6e8ax0_regulator_disable(lcd);
+err_panel_register:
+ 	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
+	kfree(panel); 
+	return ret;
+}
 
-	return 0;
+#ifdef CONFIG_PM_SLEEP
+static int s6e8ax0_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct s6e8ax0 *panel = platform_get_drvdata(pdev);
+ 
+	s6e8ax0_sleep_in(panel);
+	msleep(panel->plat_data->power_off_delay);
+	s6e8ax0_display_off(panel);
+ 
+	s6e8ax0_regulator_disable(panel);
+ 
+ 	return 0;
+}
+ 
+static int s6e8ax0_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct s6e8ax0 *panel = platform_get_drvdata(pdev);
+ 
+	s6e8ax0_sleep_out(panel);
+	msleep(panel->plat_data->power_on_delay);
+ 
+	s6e8ax0_regulator_enable(panel);
+	s6e8ax0_set_sequence(panel);
+ 
+ 	return 0;
 }
+#endif
 
-static int s6e8ax0_resume(struct mipi_dsim_lcd_device *dsim_dev)
+static int panel_remove(struct platform_device *pdev)
 {
-	struct s6e8ax0 *lcd = dev_get_drvdata(&dsim_dev->dev);
+	struct s6e8ax0 *panel = platform_get_drvdata(pdev);
 
-	s6e8ax0_sleep_out(lcd);
-	msleep(lcd->ddi_pd->power_on_delay);
+	dev_dbg(&pdev->dev, "remove\n");
 
-	s6e8ax0_regulator_enable(lcd);
-	s6e8ax0_set_sequence(dsim_dev);
+	display_entity_unregister(&panel->entity);
+	video_source_put(panel->src);
 
 	return 0;
 }
-#else
-#define s6e8ax0_suspend		NULL
-#define s6e8ax0_resume		NULL
-#endif
 
-static struct mipi_dsim_lcd_driver s6e8ax0_dsim_ddi_driver = {
-	.name = "s6e8ax0",
-	.id = -1,
+static const struct dev_pm_ops s6e8ax0_panel_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(s6e8ax0_suspend, s6e8ax0_resume)
+};
 
-	.power_on = s6e8ax0_power_on,
-	.set_sequence = s6e8ax0_set_sequence,
+static struct platform_driver s6e8ax0_driver = {
 	.probe = s6e8ax0_probe,
-	.suspend = s6e8ax0_suspend,
-	.resume = s6e8ax0_resume,
+	.remove = __devexit_p(panel_remove),
+	.driver = {
+		   .name = "s6e8ax0",
+		   .owner = THIS_MODULE,
+		   .pm = &s6e8ax0_panel_pm_ops,
+	},
 };
 
-static int s6e8ax0_init(void)
-{
-	exynos_mipi_dsi_register_lcd_driver(&s6e8ax0_dsim_ddi_driver);
-
-	return 0;
-}
-
-static void s6e8ax0_exit(void)
-{
-	return;
-}
-
-module_init(s6e8ax0_init);
-module_exit(s6e8ax0_exit);
+module_platform_driver(s6e8ax0_driver);
 
 MODULE_AUTHOR("Donghwa Lee <dh09.lee@samsung.com>");
 MODULE_AUTHOR("Inki Dae <inki.dae@samsung.com>");
-- 
1.7.9.5

