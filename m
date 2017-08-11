Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39372 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752967AbdHKJ52 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:57:28 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 16/20] adv748x: add translation from pixelcode to CSI-2 datatype
Date: Fri, 11 Aug 2017 11:56:59 +0200
Message-Id: <20170811095703.6170-17-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This will be needed to fill out the frame descriptor information
correctly.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index b76c2be8da4271fb..a77069fc1adc1eca 100644
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
2.13.3
