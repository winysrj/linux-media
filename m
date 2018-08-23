Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:12484 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730908AbeHWQ6C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 12:58:02 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 24/30] adv748x: csi2: add translation from pixelcode to CSI-2 datatype
Date: Thu, 23 Aug 2018 15:25:38 +0200
Message-Id: <20180823132544.521-25-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
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
index 469be87a3761feb5..b759a7e22fbc98df 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -18,6 +18,28 @@
 
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
 static bool is_txa(struct adv748x_csi2 *tx)
 {
 	return tx == &tx->state->txa;
-- 
2.18.0
