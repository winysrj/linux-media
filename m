Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D14E2C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A25E20883
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:17:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ry9YYp2Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbfAIAQG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:16:06 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36465 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbfAIAQF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 19:16:05 -0500
Received: by mail-pf1-f194.google.com with SMTP id b85so2733908pfc.3;
        Tue, 08 Jan 2019 16:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MBi5JXMF6IAoyZuiQMt08z0S53KWX73DIBDJGZRLFh4=;
        b=ry9YYp2YWHrxucrdzBHO8CgeYDKRjHS/3IWTbwsvrhKUXsZGanzVWjHETyk8MgilJX
         45p1b9W2dRgW6u5Mw2rZG9VbXExqhQYnVa5pv1g59E/oRLLmM0zS7tFQqhusTfo7jSKD
         QvnZBuI8mfq7xzAG7s3LD5hWGpAf6wfzQhIQyNGwed07yBTFLxJXmVhRc5Ku9D3h7unj
         I0xmQ75lRwZ9n1eAf0oiZz8S7609FwfiN/RFkTU9xb2FSDjfUPlwQyFmcaas98qogJAB
         grgBI2tHVVY8M/4k2pDXR87fMSYqn6nkaHOTAWkPD5lS2mMmXzoiaFp0DTt7arpNAnvJ
         5Kgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MBi5JXMF6IAoyZuiQMt08z0S53KWX73DIBDJGZRLFh4=;
        b=PrCSrpffLGv0EZ/h/O7Px90g6ohja76u5Q5tACf3XxUeTE//PWT8co+mPJq9KacJcs
         hhnSLOTxb2mLoz52ir0V/PM2i4uMyjIved2IdZac3YuyNYahwy36K/Vidv926sDh/W0m
         JbLRbOECrTmWoSSIX5tF3i8wtDPx2JWVKtGsNZ2ZidX0LxhEeY/DBkSh9mMP/nXTAnKd
         9Scbx3/H25TUlepKXljZrsZh5H3Lf6eZsdwelGZXZo06cjBaF/w395JqTco3jmvlr+bb
         18GAC/gk2NvMTTEDxkqpKr8XDVofwOTK0de4jseIwyEG30prg/28TLYs5RW8QyDCiOxz
         KO3w==
X-Gm-Message-State: AJcUukeqdiWtDEDTOJqvlK3bXJ2dAa/JLXBfmPH87EmERpNU13kKX0TX
        HPrpBwLDYce/SG50p+eEG8UMkoc2
X-Google-Smtp-Source: ALg8bN6UcmFnysHEVfh2NWnX8zBpEuRef1X6ZgLJ/nCiF7BS6lb8Kh8Tt6sRx8BdHhEW0oUSJ6fUaw==
X-Received: by 2002:a63:ae01:: with SMTP id q1mr3339133pgf.402.1546992962442;
        Tue, 08 Jan 2019 16:16:02 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id 134sm83978490pgb.78.2019.01.08.16.16.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 16:16:01 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
Subject: [PATCH v6 02/12] gpu: ipu-csi: Swap fields according to input/output field types
Date:   Tue,  8 Jan 2019 16:15:41 -0800
Message-Id: <20190109001551.16113-3-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109001551.16113-1-slongerbeam@gmail.com>
References: <20190109001551.16113-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The function ipu_csi_init_interface() was inverting the F-bit for
NTSC case, in the CCIR_CODE_1/2 registers. The result being that
for NTSC bottom-top field order, the CSI would swap fields and
capture in top-bottom order.

Instead, base field swap on the field order of the input to the CSI,
and the field order of the requested output. If the input/output
fields are sequential but different, swap fields, otherwise do
not swap. This requires passing both the input and output mbus
frame formats to ipu_csi_init_interface().

Move this code to a new private function ipu_csi_set_bt_interlaced_codes()
that programs the CCIR_CODE_1/2 registers for interlaced BT.656 (and
possibly interlaced BT.1120 in the future).

When detecting input video standard from the input frame width/height,
make sure to double height if input field type is alternate, since
in that case input height only includes lines for one field.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v5:
- Convert to const the infmt, outfmt, and mbus_cfg pointer args to
  ipu_csi_init_interface(), suggested by Philipp Zabel.
- Bring back if_fmt local var and don't copy outfmt to local stack in
  csi_setup(), suggested by Philipp.

Changes since v4:
- Cleaned up some convoluted code in ipu_csi_init_interface(), suggested
  by Philipp.
- Fixed a regression in csi_setup(), caught by Philipp.
---
 drivers/gpu/ipu-v3/ipu-csi.c              | 126 +++++++++++++++-------
 drivers/staging/media/imx/imx-media-csi.c |   7 +-
 include/video/imx-ipu-v3.h                |   5 +-
 3 files changed, 89 insertions(+), 49 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
index aa0e30a2ba18..d1e575571a8d 100644
--- a/drivers/gpu/ipu-v3/ipu-csi.c
+++ b/drivers/gpu/ipu-v3/ipu-csi.c
@@ -325,12 +325,21 @@ static int mbus_code_to_bus_cfg(struct ipu_csi_bus_config *cfg, u32 mbus_code,
 	return 0;
 }
 
+/* translate alternate field mode based on given standard */
+static inline enum v4l2_field
+ipu_csi_translate_field(enum v4l2_field field, v4l2_std_id std)
+{
+	return (field != V4L2_FIELD_ALTERNATE) ? field :
+		((std & V4L2_STD_525_60) ?
+		 V4L2_FIELD_SEQ_BT : V4L2_FIELD_SEQ_TB);
+}
+
 /*
  * Fill a CSI bus config struct from mbus_config and mbus_framefmt.
  */
 static int fill_csi_bus_cfg(struct ipu_csi_bus_config *csicfg,
-				 struct v4l2_mbus_config *mbus_cfg,
-				 struct v4l2_mbus_framefmt *mbus_fmt)
+			    const struct v4l2_mbus_config *mbus_cfg,
+			    const struct v4l2_mbus_framefmt *mbus_fmt)
 {
 	int ret;
 
@@ -374,22 +383,76 @@ static int fill_csi_bus_cfg(struct ipu_csi_bus_config *csicfg,
 	return 0;
 }
 
+static int
+ipu_csi_set_bt_interlaced_codes(struct ipu_csi *csi,
+				const struct v4l2_mbus_framefmt *infmt,
+				const struct v4l2_mbus_framefmt *outfmt,
+				v4l2_std_id std)
+{
+	enum v4l2_field infield, outfield;
+	bool swap_fields;
+
+	/* get translated field type of input and output */
+	infield = ipu_csi_translate_field(infmt->field, std);
+	outfield = ipu_csi_translate_field(outfmt->field, std);
+
+	/*
+	 * Write the H-V-F codes the CSI will match against the
+	 * incoming data for start/end of active and blanking
+	 * field intervals. If input and output field types are
+	 * sequential but not the same (one is SEQ_BT and the other
+	 * is SEQ_TB), swap the F-bit so that the CSI will capture
+	 * field 1 lines before field 0 lines.
+	 */
+	swap_fields = (V4L2_FIELD_IS_SEQUENTIAL(infield) &&
+		       V4L2_FIELD_IS_SEQUENTIAL(outfield) &&
+		       infield != outfield);
+
+	if (!swap_fields) {
+		/*
+		 * Field0BlankEnd  = 110, Field0BlankStart  = 010
+		 * Field0ActiveEnd = 100, Field0ActiveStart = 000
+		 * Field1BlankEnd  = 111, Field1BlankStart  = 011
+		 * Field1ActiveEnd = 101, Field1ActiveStart = 001
+		 */
+		ipu_csi_write(csi, 0x40596 | CSI_CCIR_ERR_DET_EN,
+			      CSI_CCIR_CODE_1);
+		ipu_csi_write(csi, 0xD07DF, CSI_CCIR_CODE_2);
+	} else {
+		dev_dbg(csi->ipu->dev, "capture field swap\n");
+
+		/* same as above but with F-bit inverted */
+		ipu_csi_write(csi, 0xD07DF | CSI_CCIR_ERR_DET_EN,
+			      CSI_CCIR_CODE_1);
+		ipu_csi_write(csi, 0x40596, CSI_CCIR_CODE_2);
+	}
+
+	ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
+
+	return 0;
+}
+
+
 int ipu_csi_init_interface(struct ipu_csi *csi,
-			   struct v4l2_mbus_config *mbus_cfg,
-			   struct v4l2_mbus_framefmt *mbus_fmt)
+			   const struct v4l2_mbus_config *mbus_cfg,
+			   const struct v4l2_mbus_framefmt *infmt,
+			   const struct v4l2_mbus_framefmt *outfmt)
 {
 	struct ipu_csi_bus_config cfg;
 	unsigned long flags;
 	u32 width, height, data = 0;
+	v4l2_std_id std;
 	int ret;
 
-	ret = fill_csi_bus_cfg(&cfg, mbus_cfg, mbus_fmt);
+	ret = fill_csi_bus_cfg(&cfg, mbus_cfg, infmt);
 	if (ret < 0)
 		return ret;
 
 	/* set default sensor frame width and height */
-	width = mbus_fmt->width;
-	height = mbus_fmt->height;
+	width = infmt->width;
+	height = infmt->height;
+	if (infmt->field == V4L2_FIELD_ALTERNATE)
+		height *= 2;
 
 	/* Set the CSI_SENS_CONF register remaining fields */
 	data |= cfg.data_width << CSI_SENS_CONF_DATA_WIDTH_SHIFT |
@@ -416,42 +479,22 @@ int ipu_csi_init_interface(struct ipu_csi *csi,
 		ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
 		break;
 	case IPU_CSI_CLK_MODE_CCIR656_INTERLACED:
-		if (mbus_fmt->width == 720 && mbus_fmt->height == 576) {
-			/*
-			 * PAL case
-			 *
-			 * Field0BlankEnd = 0x6, Field0BlankStart = 0x2,
-			 * Field0ActiveEnd = 0x4, Field0ActiveStart = 0
-			 * Field1BlankEnd = 0x7, Field1BlankStart = 0x3,
-			 * Field1ActiveEnd = 0x5, Field1ActiveStart = 0x1
-			 */
-			height = 625; /* framelines for PAL */
-
-			ipu_csi_write(csi, 0x40596 | CSI_CCIR_ERR_DET_EN,
-					  CSI_CCIR_CODE_1);
-			ipu_csi_write(csi, 0xD07DF, CSI_CCIR_CODE_2);
-			ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
-		} else if (mbus_fmt->width == 720 && mbus_fmt->height == 480) {
-			/*
-			 * NTSC case
-			 *
-			 * Field0BlankEnd = 0x7, Field0BlankStart = 0x3,
-			 * Field0ActiveEnd = 0x5, Field0ActiveStart = 0x1
-			 * Field1BlankEnd = 0x6, Field1BlankStart = 0x2,
-			 * Field1ActiveEnd = 0x4, Field1ActiveStart = 0
-			 */
-			height = 525; /* framelines for NTSC */
-
-			ipu_csi_write(csi, 0xD07DF | CSI_CCIR_ERR_DET_EN,
-					  CSI_CCIR_CODE_1);
-			ipu_csi_write(csi, 0x40596, CSI_CCIR_CODE_2);
-			ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
+		if (width == 720 && height == 480) {
+			std = V4L2_STD_NTSC;
+			height = 525;
+		} else if (width == 720 && height == 576) {
+			std = V4L2_STD_PAL;
+			height = 625;
 		} else {
 			dev_err(csi->ipu->dev,
-				"Unsupported CCIR656 interlaced video mode\n");
-			spin_unlock_irqrestore(&csi->lock, flags);
-			return -EINVAL;
+				"Unsupported interlaced video mode\n");
+			ret = -EINVAL;
+			goto out_unlock;
 		}
+
+		ret = ipu_csi_set_bt_interlaced_codes(csi, infmt, outfmt, std);
+		if (ret)
+			goto out_unlock;
 		break;
 	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_DDR:
 	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_SDR:
@@ -476,9 +519,10 @@ int ipu_csi_init_interface(struct ipu_csi *csi,
 	dev_dbg(csi->ipu->dev, "CSI_ACT_FRM_SIZE = 0x%08X\n",
 		ipu_csi_read(csi, CSI_ACT_FRM_SIZE));
 
+out_unlock:
 	spin_unlock_irqrestore(&csi->lock, flags);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(ipu_csi_init_interface);
 
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 4223f8d418ae..c2a8d9cd31b7 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -679,12 +679,7 @@ static int csi_setup(struct csi_priv *priv)
 		priv->upstream_ep.bus.parallel.flags :
 		priv->upstream_ep.bus.mipi_csi2.flags;
 
-	/*
-	 * we need to pass input frame to CSI interface, but
-	 * with translated field type from output format
-	 */
 	if_fmt = *infmt;
-	if_fmt.field = outfmt->field;
 	crop = priv->crop;
 
 	/*
@@ -702,7 +697,7 @@ static int csi_setup(struct csi_priv *priv)
 			     priv->crop.width == 2 * priv->compose.width,
 			     priv->crop.height == 2 * priv->compose.height);
 
-	ipu_csi_init_interface(priv->csi, &mbus_cfg, &if_fmt);
+	ipu_csi_init_interface(priv->csi, &mbus_cfg, &if_fmt, outfmt);
 
 	ipu_csi_set_dest(priv->csi, priv->dest);
 
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index e582e8e7527a..bbc8481f567d 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -354,8 +354,9 @@ int ipu_prg_channel_configure(struct ipuv3_channel *ipu_chan,
  */
 struct ipu_csi;
 int ipu_csi_init_interface(struct ipu_csi *csi,
-			   struct v4l2_mbus_config *mbus_cfg,
-			   struct v4l2_mbus_framefmt *mbus_fmt);
+			   const struct v4l2_mbus_config *mbus_cfg,
+			   const struct v4l2_mbus_framefmt *infmt,
+			   const struct v4l2_mbus_framefmt *outfmt);
 bool ipu_csi_is_interlaced(struct ipu_csi *csi);
 void ipu_csi_get_window(struct ipu_csi *csi, struct v4l2_rect *w);
 void ipu_csi_set_window(struct ipu_csi *csi, struct v4l2_rect *w);
-- 
2.17.1

