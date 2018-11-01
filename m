Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:40306 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728360AbeKBIiS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 04:38:18 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 24/30] adv748x: csi2: add translation from pixelcode to CSI-2 datatype
Date: Fri,  2 Nov 2018 00:31:38 +0100
Message-Id: <20181101233144.31507-25-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prepare to implement frame descriptors to support multiplexed streams by
adding a function to map pixelcode to CSI-2 datatype. This is needed to
properly be able to fill out the struct v4l2_mbus_frame_desc.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 6ce21542ed485811..8a7cc713c7adfcc1 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -14,6 +14,28 @@
 
 #include "adv748x.h"
 
+struct adv748x_csi2_format {
+	unsigned int code;
+	unsigned int datatype;
+};
+
+static const struct adv748x_csi2_format adv748x_csi2_formats[] = {
+	{ .code = MEDIA_BUS_FMT_RGB888_1X24,    .datatype = 0x24, },
+	{ .code = MEDIA_BUS_FMT_UYVY8_1X16,     .datatype = 0x1e, },
+	{ .code = MEDIA_BUS_FMT_UYVY8_2X8,      .datatype = 0x1e, },
+	{ .code = MEDIA_BUS_FMT_YUYV10_2X10,    .datatype = 0x1e, },
+};
+
+static unsigned int adv748x_csi2_code_to_datatype(unsigned int code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(adv748x_csi2_formats); i++)
+		if (adv748x_csi2_formats[i].code == code)
+			return adv748x_csi2_formats[i].datatype;
+	return 0;
+}
+
 static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
 					    unsigned int vc)
 {
-- 
2.19.1
