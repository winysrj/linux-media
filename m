Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41468 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbZFBRIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2009 13:08:05 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n52H82t1030442
	for <linux-media@vger.kernel.org>; Tue, 2 Jun 2009 12:08:07 -0500
Received: from dlep20.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id n52H828F008750
	for <linux-media@vger.kernel.org>; Tue, 2 Jun 2009 12:08:02 -0500 (CDT)
Received: from dsbe71.ent.ti.com (localhost [127.0.0.1])
	by dlep20.itg.ti.com (8.12.11/8.12.11) with ESMTP id n52H82Cq000547
	for <linux-media@vger.kernel.org>; Tue, 2 Jun 2009 12:08:02 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 2 Jun 2009 12:08:01 -0500
Subject: [RFC] passing bus/interface parameters from bridge driver to sub
 device
Message-ID: <A69FA2915331DC488A831521EAE36FE4013557A8AF@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

1) I want to use v4l2_i2c_new_probed_subdev_addr() to load and probe the
the v4l2 sub-device from my vpfe capture driver. Currently the api's available doesn't allow setting platform data in the client before the sub-device's probe is called. I see that there is discussion about adding i2c_board_info as an argument to the api. I would need this to allow loading of sub-device from vpfe capture. I have seen patches sent by Eduardo Valentin & Guennadi Liakhovetski addressing the issue. Do you have any suggestions for use in my vpfe capture driver?

2) I need a common structure (preferably in i2c-subdev.h for defining and using bus (interface) parameters in the bridge (vpfe capture) and sub device (tvp514x or mt9t031) drivers. This will allow bridge driver to read these values from platform data and set the same in the vpfe capture driver and sub device drivers. Since bus parameters such as interface type (BT.656, BT.1120, Raw Bayer image data etc), polarity of various signals etc are used across bridge and sub-devices, it make sense to add it to i2c-subdev.h. Here is what I have come up with. If this support is not already planned, I would
like to sent a patch for the same.

+/*
+ * Some Sub-devices are connected to the bridge device through a bus
+ * that carries the clock, vsync, hsync and data. Some interfaces
+ * such as BT.656 carries the sync embedded in the data where as others
+ * have seperate line carrying the sync signals. This structure is
+ * used by bridge driver to set the desired bus parameters in the sub
+ * device to work with it.
+ */
+enum v4l2_subdev_bus_type {
+	/* BT.656 interface. Embedded syncs */
+	V4L2_SUBDEV_BUS_BT_656,
+	/* BT.1120 interface. Embedded syncs */
+	V4L2_SUBDEV_BUS_BT_1120,
+	/* 8 bit YCbCr muxed bus, separate sync and field id signals */
+	V4L2_SUBDEV_BUS_YCBCR_8,
+	/* 16 bit YCbCr bus, separate sync and field id signals */
+	V4L2_SUBDEV_BUS_YCBCR_16,
+	/* Raw Bayer data bus, 8 - 16 bit wide, sync signals  */
+	V4L2_SUBDEV_BUS_RAW_BAYER
+};
+
+/* Raw bayer data bus width */
+enum v4l2_subdev_raw_bayer_data_width {
+	V4L2_SUBDEV_RAW_BAYER_DATA_8BIT,	
+	V4L2_SUBDEV_RAW_BAYER_DATA_9BIT,	
+	V4L2_SUBDEV_RAW_BAYER_DATA_10BIT,	
+	V4L2_SUBDEV_RAW_BAYER_DATA_11BIT,	
+	V4L2_SUBDEV_RAW_BAYER_DATA_12BIT,	
+	V4L2_SUBDEV_RAW_BAYER_DATA_13BIT,	
+	V4L2_SUBDEV_RAW_BAYER_DATA_14BIT,	
+	V4L2_SUBDEV_RAW_BAYER_DATA_15BIT,	
+	V4L2_SUBDEV_RAW_BAYER_DATA_16BIT
+};
+
+struct v4l2_subdev_bus_params {
+	/* bus type */
+	enum v4l2_subdev_bus_type type;
+	/* data size for raw bayer data bus */
+	enum v4l2_subdev_raw_bayer_data_width width;	
+	/* polarity of vsync. 0 - active low, 1 - active high */
+	u8 vsync_pol;
+	/* polarity of hsync. 0 - active low, 1 - active low */
+	u8 hsync_pol;
+	/* polarity of field id, 0 - low to high, 1 - high to low */
+	u8 fid_pol;
+	/* polarity of data. 0 - active low, 1 - active high */
+	u8 data_pol;
+	/* pclk polarity. 0 - sample at falling edge, 1 - sample at rising edge */
+	u8 pclk_pol;
+};
+
Murali Karicheri
email: m-karicheri2@ti.com

