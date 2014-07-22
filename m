Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:32941 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754033AbaGVMXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 08:23:54 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 3/5] drm: add bus_formats and nbus_formats fields to drm_display_info
Date: Tue, 22 Jul 2014 14:23:45 +0200
Message-Id: <1406031827-12432-4-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add bus_formats and nbus_formats fields and
drm_display_info_set_bus_formats helper function to specify the bus
formats supported by a given display.

This information can be used by display controller drivers to configure
the output interface appropriately (i.e. RGB565, RGB666 or RGB888 on raw
RGB or LVDS busses).

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/gpu/drm/drm_crtc.c | 28 ++++++++++++++++++++++++++++
 include/drm/drm_crtc.h     |  8 ++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index c808a09..50c8395 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -825,6 +825,34 @@ static void drm_mode_remove(struct drm_connector *connector,
 	drm_mode_destroy(connector->dev, mode);
 }
 
+/*
+ * drm_display_info_set_bus_formats - set the supported bus formats
+ * @info: display info to store bus formats in
+ * @fmts: array containing the supported bus formats
+ * @nfmts: the number of entries in the fmts array
+ *
+ * Store the suppported bus formats in display info structure.
+ */
+int drm_display_info_set_bus_formats(struct drm_display_info *info,
+				     const enum video_bus_format *fmts,
+				     int nfmts)
+{
+	enum video_bus_format *formats = NULL;
+
+	if (fmts && nfmts) {
+		formats = kmemdup(fmts, sizeof(*fmts) * nfmts, GFP_KERNEL);
+		if (!formats)
+			return -ENOMEM;
+	}
+
+	kfree(info->bus_formats);
+	info->bus_formats = formats;
+	info->nbus_formats = formats ? nfmts : 0;
+
+	return 0;
+}
+EXPORT_SYMBOL(drm_display_info_set_bus_formats);
+
 /**
  * drm_connector_init - Init a preallocated connector
  * @dev: DRM device
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index e529b68..957729b 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -31,6 +31,7 @@
 #include <linux/idr.h>
 #include <linux/fb.h>
 #include <linux/hdmi.h>
+#include <linux/video-bus-format.h>
 #include <drm/drm_mode.h>
 #include <drm/drm_fourcc.h>
 #include <drm/drm_modeset_lock.h>
@@ -121,6 +122,9 @@ struct drm_display_info {
 	enum subpixel_order subpixel_order;
 	u32 color_formats;
 
+	const enum video_bus_format *bus_formats;
+	int nbus_formats;
+
 	/* Mask of supported hdmi deep color modes */
 	u8 edid_hdmi_dc_modes;
 
@@ -964,6 +968,10 @@ extern int drm_mode_connector_set_path_property(struct drm_connector *connector,
 extern int drm_mode_connector_update_edid_property(struct drm_connector *connector,
 						struct edid *edid);
 
+extern int drm_display_info_set_bus_formats(struct drm_display_info *info,
+					    const enum video_bus_format *fmts,
+					    int nfmts);
+
 static inline bool drm_property_type_is(struct drm_property *property,
 		uint32_t type)
 {
-- 
1.8.3.2

