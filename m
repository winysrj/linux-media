Return-path: <mchehab@pedra>
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:36874 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755902Ab0KJMvm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 07:51:42 -0500
From: Jimmy Rubin <jimmy.rubin@stericsson.com>
To: <linux-fbdev@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
	Dan Johansson <dan.johansson@stericsson.com>,
	Jimmy Rubin <jimmy.rubin@stericsson.com>
Subject: [PATCH 07/10] MCDE: Add display subsystem framework
Date: Wed, 10 Nov 2010 13:04:10 +0100
Message-ID: <1289390653-6111-8-git-send-email-jimmy.rubin@stericsson.com>
In-Reply-To: <1289390653-6111-7-git-send-email-jimmy.rubin@stericsson.com>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-2-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-3-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-4-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-5-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-6-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-7-git-send-email-jimmy.rubin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds support for the MCDE, Memory-to-display controller,
found in the ST-Ericsson ux500 products.

This patch adds a display subsystem framework that can be used
by a frame buffer device driver to control a display and MCDE.

Signed-off-by: Jimmy Rubin <jimmy.rubin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij.stericsson.com>
---
 drivers/video/mcde/mcde_dss.c |  353 +++++++++++++++++++++++++++++++++++++++++
 include/video/mcde/mcde_dss.h |   78 +++++++++
 2 files changed, 431 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/mcde/mcde_dss.c
 create mode 100644 include/video/mcde/mcde_dss.h

diff --git a/drivers/video/mcde/mcde_dss.c b/drivers/video/mcde/mcde_dss.c
new file mode 100644
index 0000000..c5b3a96
--- /dev/null
+++ b/drivers/video/mcde/mcde_dss.c
@@ -0,0 +1,353 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * ST-Ericsson MCDE display sub system driver
+ *
+ * Author: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
+ * for ST-Ericsson.
+ *
+ * License terms: GNU General Public License (GPL), version 2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+
+#include <video/mcde/mcde_dss.h>
+
+#define to_overlay(x) container_of(x, struct mcde_overlay, kobj)
+
+void overlay_release(struct kobject *kobj)
+{
+	struct mcde_overlay *ovly = to_overlay(kobj);
+
+	kfree(ovly);
+}
+
+struct kobj_type ovly_type = {
+	.release = overlay_release,
+};
+
+static int apply_overlay(struct mcde_overlay *ovly,
+				struct mcde_overlay_info *info, bool force)
+{
+	int ret = 0;
+	if (ovly->ddev->invalidate_area) {
+		/* TODO: transform ovly coord to screen coords (vmode):
+		 * add offset
+		 */
+		struct mcde_rectangle dirty = info->dirty;
+		ret = ovly->ddev->invalidate_area(ovly->ddev, &dirty);
+	}
+
+	if (ovly->info.paddr != info->paddr || force)
+		mcde_ovly_set_source_buf(ovly->state, info->paddr);
+
+	if (ovly->info.stride != info->stride || ovly->info.fmt != info->fmt ||
+									force)
+		mcde_ovly_set_source_info(ovly->state, info->stride, info->fmt);
+	if (ovly->info.src_x != info->src_x ||
+					ovly->info.src_y != info->src_y ||
+					ovly->info.w != info->w ||
+					ovly->info.h != info->h || force)
+		mcde_ovly_set_source_area(ovly->state,
+				info->src_x, info->src_y, info->w, info->h);
+	if (ovly->info.dst_x != info->dst_x || ovly->info.dst_y != info->dst_y
+					|| ovly->info.dst_z != info->dst_z ||
+					force)
+		mcde_ovly_set_dest_pos(ovly->state,
+					info->dst_x, info->dst_y, info->dst_z);
+
+	mcde_ovly_apply(ovly->state);
+	ovly->info = *info;
+
+	return ret;
+}
+
+/* MCDE DSS operations */
+
+int mcde_dss_enable_display(struct mcde_display_device *ddev)
+{
+	int ret;
+	struct mcde_chnl_state *chnl;
+
+	if (ddev->enabled)
+		return 0;
+
+	/* Acquire MCDE resources */
+	chnl = mcde_chnl_get(ddev->chnl_id, ddev->fifo, ddev->port);
+	if (IS_ERR(chnl)) {
+		ret = PTR_ERR(chnl);
+		dev_warn(&ddev->dev, "Failed to acquire MCDE channel\n");
+		return ret;
+	}
+	ddev->chnl_state = chnl;
+	/* Initiate display communication */
+	ret = ddev->set_power_mode(ddev, MCDE_DISPLAY_PM_STANDBY);
+	if (ret < 0) {
+		dev_warn(&ddev->dev, "Failed to initialize display\n");
+		goto display_failed;
+	}
+
+	ret = ddev->set_synchronized_update(ddev, ddev->synchronized_update);
+	if (ret < 0)
+		dev_warn(&ddev->dev, "Failed to set sync\n");
+
+	/* TODO: call driver for all defaults like sync_update above */
+
+	dev_dbg(&ddev->dev, "Display enabled, chnl=%d\n",
+					ddev->chnl_id);
+	ddev->enabled = true;
+	return 0;
+
+display_failed:
+	mcde_chnl_put(ddev->chnl_state);
+	ddev->chnl_state = NULL;
+	return ret;
+}
+EXPORT_SYMBOL(mcde_dss_enable_display);
+
+void mcde_dss_disable_display(struct mcde_display_device *ddev)
+{
+	if (!ddev->enabled)
+		return;
+
+	/* TODO: Disable overlays */
+
+	(void)ddev->set_power_mode(ddev, MCDE_DISPLAY_PM_OFF);
+	mcde_chnl_put(ddev->chnl_state);
+	ddev->chnl_state = NULL;
+
+	ddev->enabled = false;
+
+	dev_dbg(&ddev->dev, "Display disabled, chnl=%d\n", ddev->chnl_id);
+}
+EXPORT_SYMBOL(mcde_dss_disable_display);
+
+int mcde_dss_apply_channel(struct mcde_display_device *ddev)
+{
+	if (!ddev->apply_config)
+		return -EINVAL;
+
+	return ddev->apply_config(ddev);
+}
+EXPORT_SYMBOL(mcde_dss_apply_channel);
+
+struct mcde_overlay *mcde_dss_create_overlay(struct mcde_display_device *ddev,
+	struct mcde_overlay_info *info)
+{
+	struct mcde_overlay *ovly;
+
+	ovly = kzalloc(sizeof(struct mcde_overlay), GFP_KERNEL);
+	if (!ovly)
+		return NULL;
+
+	kobject_init(&ovly->kobj, &ovly_type); /* Local ref */
+	kobject_get(&ovly->kobj); /* Creator ref */
+	INIT_LIST_HEAD(&ovly->list);
+	list_add(&ddev->ovlys, &ovly->list);
+	ovly->info = *info;
+	ovly->ddev = ddev;
+
+	return ovly;
+}
+EXPORT_SYMBOL(mcde_dss_create_overlay);
+
+void mcde_dss_destroy_overlay(struct mcde_overlay *ovly)
+{
+	list_del(&ovly->list);
+	if (ovly->state)
+		mcde_dss_disable_overlay(ovly);
+	kobject_put(&ovly->kobj);
+}
+EXPORT_SYMBOL(mcde_dss_destroy_overlay);
+
+int mcde_dss_enable_overlay(struct mcde_overlay *ovly)
+{
+	int ret;
+
+	if (!ovly->ddev->chnl_state)
+		return -EINVAL;
+
+	if (!ovly->state) {
+		struct mcde_ovly_state *state;
+		state = mcde_ovly_get(ovly->ddev->chnl_state);
+		if (IS_ERR(state)) {
+			ret = PTR_ERR(state);
+			dev_warn(&ovly->ddev->dev,
+				"Failed to acquire overlay\n");
+			return ret;
+		}
+		ovly->state = state;
+	}
+
+	apply_overlay(ovly, &ovly->info, true);
+
+	dev_vdbg(&ovly->ddev->dev, "Overlay enabled, chnl=%d\n",
+							ovly->ddev->chnl_id);
+	return 0;
+}
+EXPORT_SYMBOL(mcde_dss_enable_overlay);
+
+int mcde_dss_apply_overlay(struct mcde_overlay *ovly,
+						struct mcde_overlay_info *info)
+{
+	if (info == NULL)
+		info = &ovly->info;
+	return apply_overlay(ovly, info, false);
+}
+EXPORT_SYMBOL(mcde_dss_apply_overlay);
+
+void mcde_dss_disable_overlay(struct mcde_overlay *ovly)
+{
+	if (!ovly->state)
+		return;
+
+	mcde_ovly_put(ovly->state);
+
+	dev_dbg(&ovly->ddev->dev, "Overlay disabled, chnl=%d\n",
+							ovly->ddev->chnl_id);
+
+	ovly->state = NULL;
+}
+EXPORT_SYMBOL(mcde_dss_disable_overlay);
+
+int mcde_dss_update_overlay(struct mcde_overlay *ovly)
+{
+	int ret;
+
+	dev_vdbg(&ovly->ddev->dev, "Overlay update, chnl=%d\n",
+							ovly->ddev->chnl_id);
+
+	if (!ovly->state || !ovly->ddev->update || !ovly->ddev->invalidate_area)
+		return -EINVAL;
+
+	ret = ovly->ddev->update(ovly->ddev);
+	if (ret)
+		return ret;
+
+	return ovly->ddev->invalidate_area(ovly->ddev, NULL);
+}
+EXPORT_SYMBOL(mcde_dss_update_overlay);
+
+void mcde_dss_get_native_resolution(struct mcde_display_device *ddev,
+	u16 *x_res, u16 *y_res)
+{
+	ddev->get_native_resolution(ddev, x_res, y_res);
+}
+EXPORT_SYMBOL(mcde_dss_get_native_resolution);
+
+enum mcde_ovly_pix_fmt mcde_dss_get_default_pixel_format(
+	struct mcde_display_device *ddev)
+{
+	return ddev->get_default_pixel_format(ddev);
+}
+EXPORT_SYMBOL(mcde_dss_get_default_pixel_format);
+
+void mcde_dss_get_physical_size(struct mcde_display_device *ddev,
+	u16 *physical_width, u16 *physical_height)
+{
+	ddev->get_physical_size(ddev, physical_width, physical_height);
+}
+EXPORT_SYMBOL(mcde_dss_get_physical_size);
+
+int mcde_dss_try_video_mode(struct mcde_display_device *ddev,
+	struct mcde_video_mode *video_mode)
+{
+	return ddev->try_video_mode(ddev, video_mode);
+}
+EXPORT_SYMBOL(mcde_dss_try_video_mode);
+
+int mcde_dss_set_video_mode(struct mcde_display_device *ddev,
+	struct mcde_video_mode *vmode)
+{
+	int ret;
+	struct mcde_video_mode old_vmode;
+
+	ddev->get_video_mode(ddev, &old_vmode);
+	if (memcmp(vmode, &old_vmode, sizeof(old_vmode)) == 0)
+		return 0;
+
+	ret = ddev->set_video_mode(ddev, vmode);
+	if (ret)
+		return ret;
+
+	return ddev->invalidate_area(ddev, NULL);
+}
+EXPORT_SYMBOL(mcde_dss_set_video_mode);
+
+void mcde_dss_get_video_mode(struct mcde_display_device *ddev,
+	struct mcde_video_mode *video_mode)
+{
+	ddev->get_video_mode(ddev, video_mode);
+}
+EXPORT_SYMBOL(mcde_dss_get_video_mode);
+
+int mcde_dss_set_pixel_format(struct mcde_display_device *ddev,
+	enum mcde_ovly_pix_fmt pix_fmt)
+{
+	enum mcde_ovly_pix_fmt old_pix_fmt;
+
+	old_pix_fmt = ddev->get_pixel_format(ddev);
+	if (old_pix_fmt == pix_fmt)
+		return 0;
+
+	return ddev->set_pixel_format(ddev, pix_fmt);
+}
+EXPORT_SYMBOL(mcde_dss_set_pixel_format);
+
+int mcde_dss_get_pixel_format(struct mcde_display_device *ddev)
+{
+	return ddev->get_pixel_format(ddev);
+}
+EXPORT_SYMBOL(mcde_dss_get_pixel_format);
+
+int mcde_dss_set_rotation(struct mcde_display_device *ddev,
+	enum mcde_display_rotation rotation)
+{
+	enum mcde_display_rotation old_rotation;
+
+	old_rotation = ddev->get_rotation(ddev);
+	if (old_rotation == rotation)
+		return 0;
+
+	return ddev->set_rotation(ddev, rotation);
+}
+EXPORT_SYMBOL(mcde_dss_set_rotation);
+
+enum mcde_display_rotation mcde_dss_get_rotation(
+	struct mcde_display_device *ddev)
+{
+	return ddev->get_rotation(ddev);
+}
+EXPORT_SYMBOL(mcde_dss_get_rotation);
+
+int mcde_dss_set_synchronized_update(struct mcde_display_device *ddev,
+	bool enable)
+{
+	int ret;
+	ret = ddev->set_synchronized_update(ddev, enable);
+	if (ret)
+		return ret;
+	if (ddev->chnl_state)
+		mcde_chnl_enable_synchronized_update(ddev->chnl_state, enable);
+	return 0;
+}
+EXPORT_SYMBOL(mcde_dss_set_synchronized_update);
+
+bool mcde_dss_get_synchronized_update(struct mcde_display_device *ddev)
+{
+	return ddev->get_synchronized_update(ddev);
+}
+EXPORT_SYMBOL(mcde_dss_get_synchronized_update);
+
+int __init mcde_dss_init(void)
+{
+	return 0;
+}
+
+void mcde_dss_exit(void)
+{
+}
+
diff --git a/include/video/mcde/mcde_dss.h b/include/video/mcde/mcde_dss.h
new file mode 100644
index 0000000..a32b2df
--- /dev/null
+++ b/include/video/mcde/mcde_dss.h
@@ -0,0 +1,78 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2010
+ *
+ * ST-Ericsson MCDE display sub system driver
+ *
+ * Author: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
+ * for ST-Ericsson.
+ *
+ * License terms: GNU General Public License (GPL), version 2.
+ */
+#ifndef __MCDE_DSS__H__
+#define __MCDE_DSS__H__
+
+#include <linux/kobject.h>
+#include <linux/notifier.h>
+
+#include "mcde.h"
+#include "mcde_display.h"
+
+/* Public MCDE dss (Used by MCDE fb ioctl & MCDE display sysfs) */
+
+int mcde_dss_enable_display(struct mcde_display_device *ddev);
+void mcde_dss_disable_display(struct mcde_display_device *ddev);
+int mcde_dss_apply_channel(struct mcde_display_device *ddev);
+struct mcde_overlay *mcde_dss_create_overlay(struct mcde_display_device *ddev,
+	struct mcde_overlay_info *info);
+void mcde_dss_destroy_overlay(struct mcde_overlay *ovl);
+int mcde_dss_enable_overlay(struct mcde_overlay *ovl);
+void mcde_dss_disable_overlay(struct mcde_overlay *ovl);
+int mcde_dss_apply_overlay(struct mcde_overlay *ovl,
+						struct mcde_overlay_info *info);
+int mcde_dss_update_overlay(struct mcde_overlay *ovl);
+
+void mcde_dss_get_native_resolution(struct mcde_display_device *ddev,
+	u16 *x_res, u16 *y_res);
+enum mcde_ovl_pix_fmt mcde_dss_get_default_color_format(
+	struct mcde_display_device *ddev);
+void mcde_dss_get_physical_size(struct mcde_display_device *ddev,
+	u16 *x_size, u16 *y_size); /* mm */
+
+int mcde_dss_try_video_mode(struct mcde_display_device *ddev,
+	struct mcde_video_mode *video_mode);
+int mcde_dss_set_video_mode(struct mcde_display_device *ddev,
+	struct mcde_video_mode *video_mode);
+void mcde_dss_get_video_mode(struct mcde_display_device *ddev,
+	struct mcde_video_mode *video_mode);
+
+int mcde_dss_set_pixel_format(struct mcde_display_device *ddev,
+	enum mcde_ovly_pix_fmt pix_fmt);
+int mcde_dss_get_pixel_format(struct mcde_display_device *ddev);
+
+int mcde_dss_set_rotation(struct mcde_display_device *ddev,
+	enum mcde_display_rotation rotation);
+enum mcde_display_rotation mcde_dss_get_rotation(
+	struct mcde_display_device *ddev);
+
+int mcde_dss_set_synchronized_update(struct mcde_display_device *ddev,
+	bool enable);
+bool mcde_dss_get_synchronized_update(struct mcde_display_device *ddev);
+
+/* MCDE dss events */
+
+/*      A display device and driver has been loaded, probed and bound */
+#define MCDE_DSS_EVENT_DISPLAY_REGISTERED    1
+/*      A display device has been removed */
+#define MCDE_DSS_EVENT_DISPLAY_UNREGISTERED  2
+
+/*      Note! Notifier callback will be called holding the dev sem */
+int mcde_dss_register_notifier(struct notifier_block *nb);
+int mcde_dss_unregister_notifier(struct notifier_block *nb);
+
+/* MCDE dss driver */
+
+int mcde_dss_init(void);
+void mcde_dss_exit(void);
+
+#endif /* __MCDE_DSS__H__ */
+
-- 
1.6.3.3

