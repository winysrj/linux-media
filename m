Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:51972 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbZFIUyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 16:54:55 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n59Ksr0Z027764
	for <linux-media@vger.kernel.org>; Tue, 9 Jun 2009 15:54:58 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH] adding support for setting bus parameters in sub device
Date: Tue,  9 Jun 2009 16:54:51 -0400
Message-Id: <1244580891-24153-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>

This patch adds support for setting bus parameters such as bus type
(BT.656, BT.1120 etc), width (example 10 bit raw image data bus)
and polarities (vsync, hsync, field etc) in sub device. This allows
bridge driver to configure the sub device for a specific set of bus
parameters through s_bus() function call.

Reviewed By "Hans Verkuil".
Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository

 include/media/v4l2-subdev.h |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 1785608..c1cfb3b 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -37,6 +37,41 @@ struct v4l2_decode_vbi_line {
 	u32 type;		/* VBI service type (V4L2_SLICED_*). 0 if no service found */
 };
 
+/*
+ * Some sub-devices are connected to the bridge device through a bus that
+ * carries * the clock, vsync, hsync and data. Some interfaces such as BT.656
+ * carries the sync embedded in the data where as others have separate line
+ * carrying the sync signals. The structure below is used by bridge driver to
+ * set the desired bus parameters in the sub device to work with it.
+ */
+enum v4l2_subdev_bus_type {
+	/* BT.656 interface. Embedded sync */
+	V4L2_SUBDEV_BUS_BT_656,
+	/* BT.1120 interface. Embedded sync */
+	V4L2_SUBDEV_BUS_BT_1120,
+	/* 8 bit muxed YCbCr bus, separate sync and field signals */
+	V4L2_SUBDEV_BUS_YCBCR_8,
+	/* 16 bit YCbCr bus, separate sync and field signals */
+	V4L2_SUBDEV_BUS_YCBCR_16,
+	/* Raw Bayer image data bus , 8 - 16 bit wide, sync signals */
+	V4L2_SUBDEV_BUS_RAW_BAYER
+};
+
+struct v4l2_subdev_bus	{
+	enum v4l2_subdev_bus_type type;
+	u8 width;
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
@@ -109,6 +144,7 @@ struct v4l2_subdev_core_ops {
 	int (*querymenu)(struct v4l2_subdev *sd, struct v4l2_querymenu *qm);
 	int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);
 	long (*ioctl)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
+	int (*s_bus)(struct v4l2_subdev *sd, struct v4l2_subdev_bus *bus);
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	int (*g_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg);
 	int (*s_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg);
-- 
1.6.0.4

