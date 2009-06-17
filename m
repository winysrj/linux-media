Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:58006 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbZFQPnr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 11:43:47 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n5HFhjGE002659
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 10:43:50 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Murali Karicheri <m-karicheri2@ti.com>
Subject: [RFC PATCH] adding support for setting bus parameters in sub device
Date: Wed, 17 Jun 2009 11:43:42 -0400
Message-Id: <1245253422-22774-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>

This patch adds support for setting bus parameters such as bus type
(Raw Bayer or Raw YUV image data bus), bus width (example 10 bit raw
image data bus, 10 bit BT.656 etc.), and polarities (vsync, hsync, field
etc) in sub device. This allows bridge driver to configure the sub device
bus for a specific set of bus parameters through s_bus() function call.
This also can be used to define platform specific bus parameters for
host and sub-devices.

Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository

 include/media/v4l2-subdev.h |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 1785608..2f5ec98 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -37,6 +37,43 @@ struct v4l2_decode_vbi_line {
 	u32 type;		/* VBI service type (V4L2_SLICED_*). 0 if no service found */
 };
 
+/*
+ * Some sub-devices are connected to the host/bridge device through a bus that
+ * carries the clock, vsync, hsync and data. Some interfaces such as BT.656
+ * carries the sync embedded in the data where as others have separate line
+ * carrying the sync signals. The structure below is used to define bus 
+ * configuration parameters for host as well as sub-device
+ */
+enum v4l2_subdev_bus_type {
+	/* Raw YUV image data bus */
+	V4L2_SUBDEV_BUS_RAW_YUV,
+	/* Raw Bayer image data bus */
+	V4L2_SUBDEV_BUS_RAW_BAYER
+};
+
+struct v4l2_bus_settings {
+	/* yuv or bayer image data bus */
+	enum v4l2_subdev_bus_type type;
+	/* subdev bus width */
+	u8 subdev_width;
+	/* host bus width */
+	u8 host_width;
+	/* embedded sync, set this when sync is embedded in the data stream */
+	unsigned embedded_sync:1;
+	/* master or slave */
+	unsigned host_is_master:1;
+	/* 0 - active low, 1 - active high */
+	unsigned pol_vsync:1;
+	/* 0 - active low, 1 - active high */
+	unsigned pol_hsync:1;
+	/* 0 - low to high , 1 - high to low */
+	unsigned pol_field:1;
+	/* 0 - sample at falling edge , 1 - sample at rising edge */
+	unsigned pol_pclock:1;
+	/* 0 - active low , 1 - active high */
+	unsigned pol_data:1;
+};
+
 /* Sub-devices are devices that are connected somehow to the main bridge
    device. These devices are usually audio/video muxers/encoders/decoders or
    sensors and webcam controllers.
@@ -199,6 +236,8 @@ struct v4l2_subdev_audio_ops {
 
    s_routing: see s_routing in audio_ops, except this version is for video
 	devices.
+
+   s_bus: set bus parameters in sub device to configure the bus 
  */
 struct v4l2_subdev_video_ops {
 	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
@@ -219,6 +258,7 @@ struct v4l2_subdev_video_ops {
 	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*enum_framesizes)(struct v4l2_subdev *sd, struct v4l2_frmsizeenum *fsize);
 	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct v4l2_frmivalenum *fival);
+	int (*s_bus)(struct v4l2_subdev *sd, const struct v4l2_bus_settings *bus);
 };
 
 struct v4l2_subdev_ops {
-- 
1.6.0.4

