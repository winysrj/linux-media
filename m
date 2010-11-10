Return-path: <mchehab@pedra>
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:59376 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755587Ab0KJM0n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 07:26:43 -0500
From: Jimmy Rubin <jimmy.rubin@stericsson.com>
To: <linux-fbdev@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
	Dan Johansson <dan.johansson@stericsson.com>,
	Jimmy Rubin <jimmy.rubin@stericsson.com>
Subject: [PATCH 06/10] MCDE: Add generic display
Date: Wed, 10 Nov 2010 13:04:09 +0100
Message-ID: <1289390653-6111-7-git-send-email-jimmy.rubin@stericsson.com>
In-Reply-To: <1289390653-6111-6-git-send-email-jimmy.rubin@stericsson.com>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-2-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-3-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-4-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-5-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-6-git-send-email-jimmy.rubin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds support for MCDE, Memory-to-display controller
found in the ST-Ericsson ux500 products.

This patchs adds a generic DSI command display and a display framework
that can be used to add support for new types of displays.

Signed-off-by: Jimmy Rubin <jimmy.rubin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij.stericsson.com>
---
 drivers/video/mcde/display-generic_dsi.c      |  152 +++++++++
 drivers/video/mcde/mcde_display.c             |  427 +++++++++++++++++++++++++
 include/video/mcde/mcde_display-generic_dsi.h |   34 ++
 include/video/mcde/mcde_display.h             |  139 ++++++++
 4 files changed, 752 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/mcde/display-generic_dsi.c
 create mode 100644 drivers/video/mcde/mcde_display.c
 create mode 100644 include/video/mcde/mcde_display-generic_dsi.h
 create mode 100644 include/video/mcde/mcde_display.h

diff --git a/drivers/video/mcde/display-generic_dsi.c b/drivers/video/mcde/display-generic_dsi.c
new file mode 100644
index 0000000..1c1d266
--- /dev/null
+++ b/drivers/video/mcde/display-generic_dsi.c
@@ -0,0 +1,152 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * ST-Ericsson MCDE generic DCS display driver
+ *
+ * Author: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
+ * for ST-Ericsson.
+ *
+ * License terms: GNU General Public License (GPL), version 2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/err.h>
+
+#include <video/mcde/mcde_display.h>
+#include <video/mcde/mcde_display-generic_dsi.h>
+
+static int __devinit generic_probe(struct mcde_display_device *dev)
+{
+	int ret = 0;
+	struct mcde_display_generic_platform_data *pdata =
+		dev->dev.platform_data;
+
+	if (pdata == NULL) {
+		dev_err(&dev->dev, "%s:Platform data missing\n", __func__);
+		return -EINVAL;
+	}
+
+	if (dev->port->type != MCDE_PORTTYPE_DSI) {
+		dev_err(&dev->dev,
+			"%s:Invalid port type %d\n",
+			__func__, dev->port->type);
+		return -EINVAL;
+	}
+
+	if (!dev->platform_enable && !dev->platform_disable) {
+		pdata->generic_platform_enable = true;
+		if (pdata->reset_gpio) {
+			ret = gpio_request(pdata->reset_gpio, NULL);
+			if (ret) {
+				dev_warn(&dev->dev,
+					"%s:Failed to request gpio %d\n",
+					__func__, pdata->reset_gpio);
+				return ret;
+			}
+		}
+		if (pdata->regulator_id) {
+			pdata->regulator = regulator_get(NULL,
+				pdata->regulator_id);
+			if (IS_ERR(pdata->regulator)) {
+				ret = PTR_ERR(pdata->regulator);
+				dev_warn(&dev->dev,
+					"%s:Failed to get regulator '%s'\n",
+					__func__, pdata->regulator_id);
+				pdata->regulator = NULL;
+				goto regulator_get_failed;
+			}
+			regulator_set_voltage(pdata->regulator,
+					pdata->min_supply_voltage,
+					pdata->max_supply_voltage);
+		}
+	}
+
+	/* TODO: Remove when DSI send command uses interrupts */
+	dev->prepare_for_update = NULL;
+	dev_info(&dev->dev, "Generic display probed\n");
+
+	return 0;
+
+regulator_get_failed:
+	if (pdata->generic_platform_enable && pdata->reset_gpio)
+		gpio_free(pdata->reset_gpio);
+	return ret;
+}
+
+static int __devexit generic_remove(struct mcde_display_device *dev)
+{
+	struct mcde_display_generic_platform_data *pdata =
+		dev->dev.platform_data;
+
+	dev->set_power_mode(dev, MCDE_DISPLAY_PM_OFF);
+
+	if (!pdata->generic_platform_enable)
+		return 0;
+
+	if (pdata->regulator)
+		regulator_put(pdata->regulator);
+	if (pdata->reset_gpio) {
+		gpio_direction_input(pdata->reset_gpio);
+		gpio_free(pdata->reset_gpio);
+	}
+
+	return 0;
+}
+
+static int generic_resume(struct mcde_display_device *ddev)
+{
+	int ret;
+
+	/* set_power_mode will handle call platform_enable */
+	ret = ddev->set_power_mode(ddev, MCDE_DISPLAY_PM_STANDBY);
+	if (ret < 0)
+		dev_warn(&ddev->dev, "%s:Failed to resume display\n"
+			, __func__);
+	return ret;
+}
+
+static int generic_suspend(struct mcde_display_device *ddev, pm_message_t state)
+{
+	int ret;
+
+	/* set_power_mode will handle call platform_disable */
+	ret = ddev->set_power_mode(ddev, MCDE_DISPLAY_PM_OFF);
+	if (ret < 0)
+		dev_warn(&ddev->dev, "%s:Failed to suspend display\n"
+			, __func__);
+	return ret;
+}
+
+static struct mcde_display_driver generic_driver = {
+	.probe	= generic_probe,
+	.remove = generic_remove,
+	.suspend = generic_suspend,
+	.resume = generic_resume,
+	.driver = {
+		.name	= "mcde_disp_generic",
+	},
+};
+
+/* Module init */
+static int __init mcde_display_generic_init(void)
+{
+	pr_info("%s\n", __func__);
+
+	return mcde_display_driver_register(&generic_driver);
+}
+module_init(mcde_display_generic_init);
+
+static void __exit mcde_display_generic_exit(void)
+{
+	pr_info("%s\n", __func__);
+
+	mcde_display_driver_unregister(&generic_driver);
+}
+module_exit(mcde_display_generic_exit);
+
+MODULE_AUTHOR("Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ST-Ericsson MCDE generic DCS display driver");
diff --git a/drivers/video/mcde/mcde_display.c b/drivers/video/mcde/mcde_display.c
new file mode 100644
index 0000000..25f5ff3
--- /dev/null
+++ b/drivers/video/mcde/mcde_display.c
@@ -0,0 +1,427 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * ST-Ericsson MCDE display driver
+ *
+ * Author: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
+ * for ST-Ericsson.
+ *
+ * License terms: GNU General Public License (GPL), version 2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+
+#include <video/mcde/mcde_display.h>
+
+/*temp*/
+#include <linux/delay.h>
+
+static void mcde_display_get_native_resolution_default(
+	struct mcde_display_device *ddev, u16 *x_res, u16 *y_res)
+{
+	if (x_res)
+		*x_res = ddev->native_x_res;
+	if (y_res)
+		*y_res = ddev->native_y_res;
+}
+
+static enum mcde_ovly_pix_fmt mcde_display_get_default_pixel_format_default(
+	struct mcde_display_device *ddev)
+{
+	return ddev->default_pixel_format;
+}
+
+static void mcde_display_get_physical_size_default(
+	struct mcde_display_device *ddev, u16 *width, u16 *height)
+{
+	if (width)
+		*width = ddev->physical_width;
+	if (height)
+		*height = ddev->physical_height;
+}
+
+static int mcde_display_set_power_mode_default(struct mcde_display_device *ddev,
+	enum mcde_display_power_mode power_mode)
+{
+	int ret = 0;
+
+	/* OFF -> STANDBY */
+	if (ddev->power_mode == MCDE_DISPLAY_PM_OFF &&
+		power_mode != MCDE_DISPLAY_PM_OFF) {
+		if (ddev->platform_enable) {
+			ret = ddev->platform_enable(ddev);
+			if (ret)
+				return ret;
+		}
+		ddev->power_mode = MCDE_DISPLAY_PM_STANDBY;
+	}
+
+	if (ddev->port->type == MCDE_PORTTYPE_DSI) {
+		/* STANDBY -> ON */
+		if (ddev->power_mode == MCDE_DISPLAY_PM_STANDBY &&
+			power_mode == MCDE_DISPLAY_PM_ON) {
+			ret = mcde_dsi_dcs_write(ddev->chnl_state,
+				DCS_CMD_EXIT_SLEEP_MODE, NULL, 0);
+			if (ret)
+				return ret;
+
+			ret = mcde_dsi_dcs_write(ddev->chnl_state,
+				DCS_CMD_SET_DISPLAY_ON, NULL, 0);
+			if (ret)
+				return ret;
+
+			ddev->power_mode = MCDE_DISPLAY_PM_ON;
+			goto set_power_and_exit;
+		}
+		/* ON -> STANDBY */
+		else if (ddev->power_mode == MCDE_DISPLAY_PM_ON &&
+			power_mode <= MCDE_DISPLAY_PM_STANDBY) {
+			ret = mcde_dsi_dcs_write(ddev->chnl_state,
+				DCS_CMD_SET_DISPLAY_OFF, NULL, 0);
+			if (ret)
+				return ret;
+
+			ret = mcde_dsi_dcs_write(ddev->chnl_state,
+				DCS_CMD_ENTER_SLEEP_MODE, NULL, 0);
+			if (ret)
+				return ret;
+
+			ddev->power_mode = MCDE_DISPLAY_PM_STANDBY;
+			goto set_power_and_exit;
+		}
+	} else if (ddev->port->type == MCDE_PORTTYPE_DPI)
+		ddev->power_mode = power_mode;
+	else if (ddev->power_mode != power_mode)
+		return -EINVAL;
+
+	/* SLEEP -> OFF */
+	if (ddev->power_mode == MCDE_DISPLAY_PM_STANDBY &&
+		power_mode == MCDE_DISPLAY_PM_OFF) {
+		if (ddev->platform_disable) {
+			ret = ddev->platform_disable(ddev);
+			if (ret)
+				return ret;
+		}
+		ddev->power_mode = MCDE_DISPLAY_PM_OFF;
+	}
+
+set_power_and_exit:
+	mcde_chnl_set_power_mode(ddev->chnl_state, ddev->power_mode);
+
+	return ret;
+}
+
+static inline enum mcde_display_power_mode mcde_display_get_power_mode_default(
+	struct mcde_display_device *ddev)
+{
+	return ddev->power_mode;
+}
+
+static inline int mcde_display_try_video_mode_default(
+	struct mcde_display_device *ddev,
+	struct mcde_video_mode *video_mode)
+{
+	/* TODO Check if inside native_xres and native_yres */
+	return 0;
+}
+
+static int mcde_display_set_video_mode_default(struct mcde_display_device *ddev,
+	struct mcde_video_mode *video_mode)
+{
+	int ret;
+	struct mcde_video_mode channel_video_mode;
+
+	if (!video_mode)
+		return -EINVAL;
+
+	ddev->video_mode = *video_mode;
+	channel_video_mode = ddev->video_mode;
+	/* Dependant on if display should rotate or MCDE should rotate */
+	if (ddev->rotation == MCDE_DISPLAY_ROT_90_CCW ||
+				ddev->rotation == MCDE_DISPLAY_ROT_90_CW) {
+		channel_video_mode.xres = ddev->native_x_res;
+		channel_video_mode.yres = ddev->native_y_res;
+	}
+	ret = mcde_chnl_set_video_mode(ddev->chnl_state, &channel_video_mode);
+	if (ret < 0) {
+		dev_warn(&ddev->dev, "%s:Failed to set video mode\n", __func__);
+		return ret;
+	}
+
+	ddev->update_flags |= UPDATE_FLAG_VIDEO_MODE;
+
+	return 0;
+}
+
+static inline void mcde_display_get_video_mode_default(
+	struct mcde_display_device *ddev, struct mcde_video_mode *video_mode)
+{
+	if (video_mode)
+		*video_mode = ddev->video_mode;
+}
+
+static int mcde_display_set_pixel_format_default(
+	struct mcde_display_device *ddev, enum mcde_ovly_pix_fmt format)
+{
+	int ret;
+
+	ddev->pixel_format = format;
+	ret = mcde_chnl_set_pixel_format(ddev->chnl_state,
+						ddev->port->pixel_format);
+	if (ret < 0) {
+		dev_warn(&ddev->dev, "%s:Failed to set pixel format = %d\n",
+							__func__, format);
+		return ret;
+	}
+
+	ddev->update_flags |= UPDATE_FLAG_PIXEL_FORMAT;
+
+	return 0;
+}
+
+static inline enum mcde_ovly_pix_fmt mcde_display_get_pixel_format_default(
+	struct mcde_display_device *ddev)
+{
+	return ddev->pixel_format;
+}
+
+static inline enum mcde_port_pix_fmt mcde_display_get_port_pixel_format_default(
+	struct mcde_display_device *ddev)
+{
+	return ddev->port->pixel_format;
+}
+
+static int mcde_display_set_rotation_default(struct mcde_display_device *ddev,
+	enum mcde_display_rotation rotation)
+{
+	int ret;
+
+	ret = mcde_chnl_set_rotation(ddev->chnl_state, rotation,
+		ddev->rotbuf1, ddev->rotbuf2);
+	if (ret < 0) {
+		dev_warn(&ddev->dev, "%s:Failed to set rotation = %d\n",
+							__func__, rotation);
+		return ret;
+	}
+
+	ddev->rotation = rotation;
+	ddev->update_flags |= UPDATE_FLAG_ROTATION;
+
+	return 0;
+}
+
+static inline enum mcde_display_rotation mcde_display_get_rotation_default(
+	struct mcde_display_device *ddev)
+{
+	return ddev->rotation;
+}
+
+static int mcde_display_set_synchronized_update_default(
+	struct mcde_display_device *ddev, bool enable)
+{
+	if (ddev->port->type == MCDE_PORTTYPE_DSI && enable) {
+		int ret;
+		u8 m = 0;
+
+		if (ddev->port->sync_src == MCDE_SYNCSRC_OFF)
+			return -EINVAL;
+
+		ret = mcde_dsi_dcs_write(ddev->chnl_state,
+						DCS_CMD_SET_TEAR_ON, &m, 1);
+		if (ret < 0) {
+			dev_warn(&ddev->dev,
+				"%s:Failed to set synchornized update = %d\n",
+				__func__, enable);
+			return ret;
+		}
+	}
+	ddev->synchronized_update = enable;
+	return 0;
+}
+
+static inline bool mcde_display_get_synchronized_update_default(
+	struct mcde_display_device *ddev)
+{
+	return ddev->synchronized_update;
+}
+
+static int mcde_display_apply_config_default(struct mcde_display_device *ddev)
+{
+	int ret;
+
+	ret = mcde_chnl_enable_synchronized_update(ddev->chnl_state,
+		ddev->synchronized_update);
+
+	if (ret < 0) {
+		dev_warn(&ddev->dev,
+			"%s:Failed to enable synchronized update\n",
+			__func__);
+		return ret;
+	}
+
+	if (!ddev->update_flags)
+		return 0;
+
+	if ((ddev->update_flags & UPDATE_FLAG_VIDEO_MODE) ||
+		(ddev->update_flags & UPDATE_FLAG_PIXEL_FORMAT))
+		mcde_chnl_stop_flow(ddev->chnl_state);
+
+	ret = mcde_chnl_apply(ddev->chnl_state);
+	if (ret < 0) {
+		dev_warn(&ddev->dev, "%s:Failed to apply to channel\n",
+							__func__);
+		return ret;
+	}
+	ddev->update_flags = 0;
+	ddev->first_update = true;
+
+	return 0;
+}
+
+static int mcde_display_invalidate_area_default(
+					struct mcde_display_device *ddev,
+					struct mcde_rectangle *area)
+{
+	dev_vdbg(&ddev->dev, "%s\n", __func__);
+	if (area) {
+		/* take union of rects */
+		u16 t;
+		t = min(ddev->update_area.x, area->x);
+		/* note should be > 0 */
+		ddev->update_area.w = max(ddev->update_area.x +
+							ddev->update_area.w,
+							area->x + area->w) - t;
+		ddev->update_area.x = t;
+		t = min(ddev->update_area.y, area->y);
+		ddev->update_area.h = max(ddev->update_area.y +
+							ddev->update_area.h,
+							area->y + area->h) - t;
+		ddev->update_area.y = t;
+		/* TODO: Implement real clipping when partial refresh is
+		activated.*/
+		ddev->update_area.w = min((u16) ddev->video_mode.xres,
+					(u16) ddev->update_area.w);
+		ddev->update_area.h = min((u16) ddev->video_mode.yres,
+					(u16) ddev->update_area.h);
+	} else {
+		ddev->update_area.x = 0;
+		ddev->update_area.y = 0;
+		ddev->update_area.w = ddev->video_mode.xres;
+		ddev->update_area.h = ddev->video_mode.yres;
+		/* Invalidate_area(ddev, NULL) means reset area to empty
+		 * rectangle really. After that the rectangle should grow by
+		 * taking an union (above). This means that the code should
+		 * really look like below, however the code above is a temp fix
+		 * for rotation.
+		 * TODO: fix
+		 * ddev->update_area.x = ddev->video_mode.xres;
+		 * ddev->update_area.y = ddev->video_mode.yres;
+		 * ddev->update_area.w = 0;
+		 * ddev->update_area.h = 0;
+		 */
+	}
+
+	return 0;
+}
+
+static int mcde_display_update_default(struct mcde_display_device *ddev)
+{
+	int ret;
+
+	/* TODO: Dirty */
+	if (ddev->prepare_for_update) {
+		/* TODO: Send dirty rectangle */
+		ret = ddev->prepare_for_update(ddev, 0, 0,
+			ddev->native_x_res, ddev->native_y_res);
+		if (ret < 0) {
+			dev_warn(&ddev->dev,
+				"%s:Failed to prepare for update\n", __func__);
+			return ret;
+		}
+	}
+	/* TODO: Calculate & set update rect */
+	ret = mcde_chnl_update(ddev->chnl_state, &ddev->update_area);
+	if (ret < 0) {
+		dev_warn(&ddev->dev, "%s:Failed to update channel\n", __func__);
+		return ret;
+	}
+	if (ddev->first_update && ddev->on_first_update)
+		ddev->on_first_update(ddev);
+
+	if (ddev->power_mode != MCDE_DISPLAY_PM_ON && ddev->set_power_mode) {
+		ret = ddev->set_power_mode(ddev, MCDE_DISPLAY_PM_ON);
+		if (ret < 0) {
+			dev_warn(&ddev->dev,
+				"%s:Failed to set power mode to on\n",
+				__func__);
+			return ret;
+		}
+	}
+
+	dev_vdbg(&ddev->dev, "Overlay updated, chnl=%d\n", ddev->chnl_id);
+
+	return 0;
+}
+
+static int mcde_display_prepare_for_update_default(
+					struct mcde_display_device *ddev,
+					u16 x, u16 y, u16 w, u16 h)
+{
+	int ret;
+	u8 params[8] = { x >> 8, x & 0xff,
+			(x + w - 1) >> 8, (x + w - 1) & 0xff,
+			 y >> 8, y & 0xff,
+			(y + h - 1) >> 8, (y + h - 1) & 0xff };
+
+	if (ddev->port->type != MCDE_PORTTYPE_DSI)
+		return -EINVAL;
+
+	ret = mcde_dsi_dcs_write(ddev->chnl_state,
+		DCS_CMD_SET_COLUMN_ADDRESS, &params[0], 4);
+	if (ret)
+		return ret;
+
+	ret = mcde_dsi_dcs_write(ddev->chnl_state,
+		DCS_CMD_SET_PAGE_ADDRESS, &params[4], 4);
+
+	return ret;
+}
+
+static inline int mcde_display_on_first_update_default(
+					struct mcde_display_device *ddev)
+{
+	ddev->first_update = false;
+	return 0;
+}
+
+void mcde_display_init_device(struct mcde_display_device *ddev)
+{
+	/* Setup default callbacks */
+	ddev->get_native_resolution =
+				mcde_display_get_native_resolution_default;
+	ddev->get_default_pixel_format =
+				mcde_display_get_default_pixel_format_default;
+	ddev->get_physical_size = mcde_display_get_physical_size_default;
+	ddev->set_power_mode = mcde_display_set_power_mode_default;
+	ddev->get_power_mode = mcde_display_get_power_mode_default;
+	ddev->try_video_mode = mcde_display_try_video_mode_default;
+	ddev->set_video_mode = mcde_display_set_video_mode_default;
+	ddev->get_video_mode = mcde_display_get_video_mode_default;
+	ddev->set_pixel_format = mcde_display_set_pixel_format_default;
+	ddev->get_pixel_format = mcde_display_get_pixel_format_default;
+	ddev->get_port_pixel_format =
+				mcde_display_get_port_pixel_format_default;
+	ddev->set_rotation = mcde_display_set_rotation_default;
+	ddev->get_rotation = mcde_display_get_rotation_default;
+	ddev->set_synchronized_update =
+				mcde_display_set_synchronized_update_default;
+	ddev->get_synchronized_update =
+				mcde_display_get_synchronized_update_default;
+	ddev->apply_config = mcde_display_apply_config_default;
+	ddev->invalidate_area = mcde_display_invalidate_area_default;
+	ddev->update = mcde_display_update_default;
+	ddev->prepare_for_update = mcde_display_prepare_for_update_default;
+	ddev->on_first_update = mcde_display_on_first_update_default;
+}
+
diff --git a/include/video/mcde/mcde_display-generic_dsi.h b/include/video/mcde/mcde_display-generic_dsi.h
new file mode 100644
index 0000000..4879061
--- /dev/null
+++ b/include/video/mcde/mcde_display-generic_dsi.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * ST-Ericsson MCDE generic DCS display driver
+ *
+ * Author: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
+ * for ST-Ericsson.
+ *
+ * License terms: GNU General Public License (GPL), version 2.
+ */
+#ifndef __MCDE_DISPLAY_GENERIC__H__
+#define __MCDE_DISPLAY_GENERIC__H__
+
+#include <linux/regulator/consumer.h>
+
+#include "mcde_display.h"
+
+struct mcde_display_generic_platform_data {
+	/* Platform info */
+	int reset_gpio;
+	bool reset_high;
+	const char *regulator_id;
+	int reset_delay; /* ms */
+	u32 ddb_id;
+
+	/* Driver data */
+	bool generic_platform_enable;
+	struct regulator *regulator;
+	int max_supply_voltage;
+	int min_supply_voltage;
+};
+
+#endif /* __MCDE_DISPLAY_GENERIC__H__ */
+
diff --git a/include/video/mcde/mcde_display.h b/include/video/mcde/mcde_display.h
new file mode 100644
index 0000000..8dfdbb5
--- /dev/null
+++ b/include/video/mcde/mcde_display.h
@@ -0,0 +1,139 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * ST-Ericsson MCDE display driver
+ *
+ * Author: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
+ * for ST-Ericsson.
+ *
+ * License terms: GNU General Public License (GPL), version 2.
+ */
+#ifndef __MCDE_DISPLAY__H__
+#define __MCDE_DISPLAY__H__
+
+#include <linux/device.h>
+#include <linux/pm.h>
+
+#include <video/mcde/mcde.h>
+
+#define UPDATE_FLAG_PIXEL_FORMAT	0x1
+#define UPDATE_FLAG_VIDEO_MODE		0x2
+#define UPDATE_FLAG_ROTATION		0x4
+
+#define to_mcde_display_device(__dev) \
+	container_of((__dev), struct mcde_display_device, dev)
+
+struct mcde_display_device {
+	/* MCDE driver static */
+	struct device     dev;
+	const char       *name;
+	int               id;
+	struct mcde_port *port;
+
+	/* MCDE dss driver internal */
+	bool initialized;
+	enum mcde_chnl chnl_id;
+	enum mcde_fifo fifo;
+	bool first_update;
+
+	bool enabled;
+	struct mcde_chnl_state *chnl_state;
+	struct list_head ovlys;
+	struct mcde_rectangle update_area;
+	/* TODO: Remove once ESRAM allocator is done */
+	u32 rotbuf1;
+	u32 rotbuf2;
+
+	/* Display driver internal */
+	u16 native_x_res;
+	u16 native_y_res;
+	u16 physical_width;
+	u16 physical_height;
+	enum mcde_display_power_mode power_mode;
+	enum mcde_ovly_pix_fmt default_pixel_format;
+	enum mcde_ovly_pix_fmt pixel_format;
+	enum mcde_display_rotation rotation;
+	bool synchronized_update;
+	struct mcde_video_mode video_mode;
+	int update_flags;
+
+	/* Driver API */
+	void (*get_native_resolution)(struct mcde_display_device *dev,
+		u16 *x_res, u16 *y_res);
+	enum mcde_ovly_pix_fmt (*get_default_pixel_format)(
+		struct mcde_display_device *dev);
+	void (*get_physical_size)(struct mcde_display_device *dev,
+		u16 *x_size, u16 *y_size);
+
+	int (*set_power_mode)(struct mcde_display_device *dev,
+		enum mcde_display_power_mode power_mode);
+	enum mcde_display_power_mode (*get_power_mode)(
+		struct mcde_display_device *dev);
+
+	int (*try_video_mode)(struct mcde_display_device *dev,
+		struct mcde_video_mode *video_mode);
+	int (*set_video_mode)(struct mcde_display_device *dev,
+		struct mcde_video_mode *video_mode);
+	void (*get_video_mode)(struct mcde_display_device *dev,
+		struct mcde_video_mode *video_mode);
+
+	int (*set_pixel_format)(struct mcde_display_device *dev,
+		enum mcde_ovly_pix_fmt pix_fmt);
+	enum mcde_ovly_pix_fmt (*get_pixel_format)(
+		struct mcde_display_device *dev);
+	enum mcde_port_pix_fmt (*get_port_pixel_format)(
+		struct mcde_display_device *dev);
+
+	int (*set_rotation)(struct mcde_display_device *dev,
+		enum mcde_display_rotation rotation);
+	enum mcde_display_rotation (*get_rotation)(
+		struct mcde_display_device *dev);
+
+	int (*set_synchronized_update)(struct mcde_display_device *dev,
+		bool enable);
+	bool (*get_synchronized_update)(struct mcde_display_device *dev);
+
+	int (*apply_config)(struct mcde_display_device *dev);
+	int (*invalidate_area)(struct mcde_display_device *dev,
+						struct mcde_rectangle *area);
+	int (*update)(struct mcde_display_device *dev);
+	int (*prepare_for_update)(struct mcde_display_device *dev,
+		u16 x, u16 y, u16 w, u16 h);
+	int (*on_first_update)(struct mcde_display_device *dev);
+	int (*platform_enable)(struct mcde_display_device *dev);
+	int (*platform_disable)(struct mcde_display_device *dev);
+};
+
+struct mcde_display_driver {
+	int (*probe)(struct mcde_display_device *dev);
+	int (*remove)(struct mcde_display_device *dev);
+	void (*shutdown)(struct mcde_display_device *dev);
+	int (*suspend)(struct mcde_display_device *dev,
+		pm_message_t state);
+	int (*resume)(struct mcde_display_device *dev);
+
+	struct device_driver driver;
+};
+
+/* MCDE dsi (Used by MCDE display drivers) */
+
+int mcde_display_dsi_dcs_write(struct mcde_display_device *dev,
+	u8 cmd, u8 *data, int len);
+int mcde_display_dsi_dcs_read(struct mcde_display_device *dev,
+	u8 cmd, u8 *data, int *len);
+int mcde_display_dsi_bta_sync(struct mcde_display_device *dev);
+
+/* MCDE display bus */
+
+int mcde_display_driver_register(struct mcde_display_driver *drv);
+void mcde_display_driver_unregister(struct mcde_display_driver *drv);
+int mcde_display_device_register(struct mcde_display_device *dev);
+void mcde_display_device_unregister(struct mcde_display_device *dev);
+
+void mcde_display_init_device(struct mcde_display_device *dev);
+
+int mcde_display_init(void);
+void mcde_display_exit(void);
+
+#endif /* __MCDE_DISPLAY__H__ */
+
-- 
1.6.3.3

