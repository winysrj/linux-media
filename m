Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9270EC43444
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 15:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E0A920855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 15:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbfAQPv6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 10:51:58 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58451 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbfAQPv6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 10:51:58 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gk9xV-0008FN-1h; Thu, 17 Jan 2019 16:51:57 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>, kernel@pengutronix.de
Subject: [PATCH v4 3/3] media: imx: lift CSI and PRP ENC/VF width alignment restriction
Date:   Thu, 17 Jan 2019 16:51:54 +0100
Message-Id: <20190117155154.6964-3-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190117155154.6964-1-p.zabel@pengutronix.de>
References: <20190117155154.6964-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The CSI, PRP ENC, and PRP VF subdevices shouldn't have to care about
IDMAC line start address alignment. With compose rectangle support in
the capture driver, they don't have to anymore.
If the direct CSI -> IC path is enabled, the CSI output width must
still be aligned to 8 pixels (IC burst length).

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Steve Longerbeam <slongerbeam@gmail.com>
---
No changes since v3 [1].

[1] https://patchwork.linuxtv.org/patch/53862/
---
 drivers/staging/media/imx/imx-ic-prpencvf.c |  2 +-
 drivers/staging/media/imx/imx-media-csi.c   | 11 +++++++++--
 drivers/staging/media/imx/imx-media-utils.c | 15 ++++++++++++---
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index c7855fbc449d..053a911d477a 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -48,7 +48,7 @@
 
 #define MAX_W_SRC  1024
 #define MAX_H_SRC  1024
-#define W_ALIGN_SRC   4 /* multiple of 16 pixels */
+#define W_ALIGN_SRC   1 /* multiple of 2 pixels */
 #define H_ALIGN_SRC   1 /* multiple of 2 lines */
 
 #define S_ALIGN       1 /* multiple of 2 */
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 39fad3bfa6ca..8857994b2a16 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -41,7 +41,7 @@
 #define MIN_H       144
 #define MAX_W      4096
 #define MAX_H      4096
-#define W_ALIGN    4 /* multiple of 16 pixels */
+#define W_ALIGN    1 /* multiple of 2 pixels */
 #define H_ALIGN    1 /* multiple of 2 lines */
 #define S_ALIGN    1 /* multiple of 2 */
 
@@ -1029,6 +1029,8 @@ static int csi_link_setup(struct media_entity *entity,
 		v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
 		v4l2_ctrl_handler_init(&priv->ctrl_hdlr, 0);
 		priv->sink = NULL;
+		/* do not apply IC burst alignment in csi_try_crop */
+		priv->active_output_pad = CSI_SRC_PAD_IDMAC;
 		goto out;
 	}
 
@@ -1172,7 +1174,10 @@ static void csi_try_crop(struct csi_priv *priv,
 		crop->left = infmt->width - crop->width;
 	/* adjust crop left/width to h/w alignment restrictions */
 	crop->left &= ~0x3;
-	crop->width &= ~0x7;
+	if (priv->active_output_pad == CSI_SRC_PAD_DIRECT)
+		crop->width &= ~0x7; /* multiple of 8 pixels (IC burst) */
+	else
+		crop->width &= ~0x1; /* multiple of 2 pixels */
 
 	in_height = infmt->height;
 	if (infmt->field == V4L2_FIELD_ALTERNATE)
@@ -1937,6 +1942,8 @@ static int imx_csi_probe(struct platform_device *pdev)
 	priv->csi_id = pdata->csi;
 	priv->smfc_id = (priv->csi_id == 0) ? 0 : 2;
 
+	priv->active_output_pad = CSI_SRC_PAD_IDMAC;
+
 	timer_setup(&priv->eof_timeout_timer, csi_idmac_eof_timeout, 0);
 	spin_lock_init(&priv->irqlock);
 
diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 0eaa353d5cb3..5f110d90a4ef 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -580,6 +580,7 @@ int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
 				  struct v4l2_mbus_framefmt *mbus,
 				  const struct imx_media_pixfmt *cc)
 {
+	u32 width;
 	u32 stride;
 
 	if (!cc) {
@@ -602,9 +603,16 @@ int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
 		cc = imx_media_find_mbus_format(code, CS_SEL_YUV, false);
 	}
 
-	stride = cc->planar ? mbus->width : (mbus->width * cc->bpp) >> 3;
+	/* Round up width for minimum burst size */
+	width = round_up(mbus->width, 8);
 
-	pix->width = mbus->width;
+	/* Round up stride for IDMAC line start address alignment */
+	if (cc->planar)
+		stride = round_up(width, 16);
+	else
+		stride = round_up((width * cc->bpp) >> 3, 8);
+
+	pix->width = width;
 	pix->height = mbus->height;
 	pix->pixelformat = cc->fourcc;
 	pix->colorspace = mbus->colorspace;
@@ -613,7 +621,8 @@ int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
 	pix->quantization = mbus->quantization;
 	pix->field = mbus->field;
 	pix->bytesperline = stride;
-	pix->sizeimage = (pix->width * pix->height * cc->bpp) >> 3;
+	pix->sizeimage = cc->planar ? ((stride * pix->height * cc->bpp) >> 3) :
+			 stride * pix->height;
 
 	return 0;
 }
-- 
2.20.1

