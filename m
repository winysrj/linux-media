Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49554 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933712AbeCEJfu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 04:35:50 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Yong Deng <yong.deng@magewell.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>
Subject: [PATCH 3/7] media: sun6i: Pass the sun6i_csi_dev pointer to our helpers
Date: Mon,  5 Mar 2018 10:35:30 +0100
Message-Id: <20180305093535.11801-4-maxime.ripard@bootlin.com>
In-Reply-To: <20180305093535.11801-1-maxime.ripard@bootlin.com>
References: <1519697113-32202-1-git-send-email-yong.deng@magewell.com>
 <20180305093535.11801-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some helpers need to log some errors for example when we don't support the
format passed as an argument. However, we don't currently have a dev
pointer available in those functions, preventing us from using any dev_*
logging function.

Fix that by passing the sun6i_csi_dev structure as an argument, which
itself contains a pointer to our struct device.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index b0ac8a188f92..f10c3bc2a6c5 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -225,7 +225,8 @@ int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
 	return 0;
 }
 
-static enum csi_input_fmt get_csi_input_format(u32 mbus_code, u32 pixformat)
+static enum csi_input_fmt get_csi_input_format(struct sun6i_csi_dev *sdev,
+					       u32 mbus_code, u32 pixformat)
 {
 	/* bayer */
 	if ((mbus_code & 0xF000) == 0x3000)
@@ -242,11 +243,12 @@ static enum csi_input_fmt get_csi_input_format(u32 mbus_code, u32 pixformat)
 	}
 
 	/* not support YUV420 input format yet */
-	pr_debug("Select YUV422 as default input format of CSI.\n");
+	dev_dbg(sdev->dev, "Select YUV422 as default input format of CSI.\n");
 	return CSI_INPUT_FORMAT_YUV422;
 }
 
-static enum csi_output_fmt get_csi_output_format(u32 pixformat, u32 field)
+static enum csi_output_fmt get_csi_output_format(struct sun6i_csi_dev *sdev,
+						 u32 pixformat, u32 field)
 {
 	bool buf_interlaced = false;
 
@@ -304,7 +306,8 @@ static enum csi_output_fmt get_csi_output_format(u32 pixformat, u32 field)
 	return CSI_FIELD_RAW_8;
 }
 
-static enum csi_input_seq get_csi_input_seq(u32 mbus_code, u32 pixformat)
+static enum csi_input_seq get_csi_input_seq(struct sun6i_csi_dev *sdev,
+					    u32 mbus_code, u32 pixformat)
 {
 
 	switch (pixformat) {
@@ -449,13 +452,16 @@ static void sun6i_csi_set_format(struct sun6i_csi_dev *sdev)
 		 CSI_CH_CFG_HFLIP_EN | CSI_CH_CFG_FIELD_SEL_MASK |
 		 CSI_CH_CFG_INPUT_SEQ_MASK);
 
-	val = get_csi_input_format(csi->config.code, csi->config.pixelformat);
+	val = get_csi_input_format(sdev, csi->config.code,
+				   csi->config.pixelformat);
 	cfg |= CSI_CH_CFG_INPUT_FMT(val);
 
-	val = get_csi_output_format(csi->config.pixelformat, csi->config.field);
+	val = get_csi_output_format(sdev, csi->config.pixelformat,
+				    csi->config.field);
 	cfg |= CSI_CH_CFG_OUTPUT_FMT(val);
 
-	val = get_csi_input_seq(csi->config.code, csi->config.pixelformat);
+	val = get_csi_input_seq(sdev, csi->config.code,
+				csi->config.pixelformat);
 	cfg |= CSI_CH_CFG_INPUT_SEQ(val);
 
 	if (csi->config.field == V4L2_FIELD_TOP)
-- 
2.14.3
