Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB09C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 15:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D695B20851
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 15:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbfAQPv6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 10:51:58 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51719 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727632AbfAQPv6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 10:51:58 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gk9xU-0008FN-6S; Thu, 17 Jan 2019 16:51:56 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>, kernel@pengutronix.de
Subject: [PATCH v4 2/3] media: imx: set compose rectangle to mbus format
Date:   Thu, 17 Jan 2019 16:51:53 +0100
Message-Id: <20190117155154.6964-2-p.zabel@pengutronix.de>
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

Prepare for mbus format being smaller than the written rectangle
due to burst size.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Steve Longerbeam <slongerbeam@gmail.com>
---
Changes since v3 [1]:
 - Rebased onto d969291d8479 ("media: imx: Fix field negotiation")
 - Comment on the horizontal padding due to DMA burst size in
   vidioc_g_selection.

[1] https://patchwork.linuxtv.org/patch/53860/
---
 drivers/staging/media/imx/imx-media-capture.c | 68 +++++++++++++------
 1 file changed, 47 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index 8b8ef4a11774..a93bd7f388ef 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -203,21 +203,13 @@ static int capture_g_fmt_vid_cap(struct file *file, void *fh,
 	return 0;
 }
 
-static int capture_try_fmt_vid_cap(struct file *file, void *fh,
-				   struct v4l2_format *f)
+static int __capture_try_fmt_vid_cap(struct capture_priv *priv,
+				     struct v4l2_subdev_format *fmt_src,
+				     struct v4l2_format *f)
 {
-	struct capture_priv *priv = video_drvdata(file);
-	struct v4l2_subdev_format fmt_src;
 	const struct imx_media_pixfmt *cc, *cc_src;
-	int ret;
 
-	fmt_src.pad = priv->src_sd_pad;
-	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	ret = v4l2_subdev_call(priv->src_sd, pad, get_fmt, NULL, &fmt_src);
-	if (ret)
-		return ret;
-
-	cc_src = imx_media_find_ipu_format(fmt_src.format.code, CS_SEL_ANY);
+	cc_src = imx_media_find_ipu_format(fmt_src->format.code, CS_SEL_ANY);
 	if (cc_src) {
 		u32 fourcc, cs_sel;
 
@@ -231,7 +223,7 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
 			cc = imx_media_find_format(fourcc, cs_sel, false);
 		}
 	} else {
-		cc_src = imx_media_find_mbus_format(fmt_src.format.code,
+		cc_src = imx_media_find_mbus_format(fmt_src->format.code,
 						    CS_SEL_ANY, true);
 		if (WARN_ON(!cc_src))
 			return -EINVAL;
@@ -241,27 +233,44 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
 
 	/* allow IDMAC interweave but enforce field order from source */
 	if (V4L2_FIELD_IS_INTERLACED(f->fmt.pix.field)) {
-		switch (fmt_src.format.field) {
+		switch (fmt_src->format.field) {
 		case V4L2_FIELD_SEQ_TB:
-			fmt_src.format.field = V4L2_FIELD_INTERLACED_TB;
+			fmt_src->format.field = V4L2_FIELD_INTERLACED_TB;
 			break;
 		case V4L2_FIELD_SEQ_BT:
-			fmt_src.format.field = V4L2_FIELD_INTERLACED_BT;
+			fmt_src->format.field = V4L2_FIELD_INTERLACED_BT;
 			break;
 		default:
 			break;
 		}
 	}
 
-	imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix, &fmt_src.format, cc);
+	imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix, &fmt_src->format, cc);
 
 	return 0;
 }
 
+static int capture_try_fmt_vid_cap(struct file *file, void *fh,
+				   struct v4l2_format *f)
+{
+	struct capture_priv *priv = video_drvdata(file);
+	struct v4l2_subdev_format fmt_src;
+	int ret;
+
+	fmt_src.pad = priv->src_sd_pad;
+	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(priv->src_sd, pad, get_fmt, NULL, &fmt_src);
+	if (ret)
+		return ret;
+
+	return __capture_try_fmt_vid_cap(priv, &fmt_src, f);
+}
+
 static int capture_s_fmt_vid_cap(struct file *file, void *fh,
 				 struct v4l2_format *f)
 {
 	struct capture_priv *priv = video_drvdata(file);
+	struct v4l2_subdev_format fmt_src;
 	int ret;
 
 	if (vb2_is_busy(&priv->q)) {
@@ -269,7 +278,13 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
 		return -EBUSY;
 	}
 
-	ret = capture_try_fmt_vid_cap(file, priv, f);
+	fmt_src.pad = priv->src_sd_pad;
+	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(priv->src_sd, pad, get_fmt, NULL, &fmt_src);
+	if (ret)
+		return ret;
+
+	ret = __capture_try_fmt_vid_cap(priv, &fmt_src, f);
 	if (ret)
 		return ret;
 
@@ -278,8 +293,8 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
 					      CS_SEL_ANY, true);
 	priv->vdev.compose.left = 0;
 	priv->vdev.compose.top = 0;
-	priv->vdev.compose.width = f->fmt.pix.width;
-	priv->vdev.compose.height = f->fmt.pix.height;
+	priv->vdev.compose.width = fmt_src.format.width;
+	priv->vdev.compose.height = fmt_src.format.height;
 
 	return 0;
 }
@@ -317,9 +332,20 @@ static int capture_g_selection(struct file *file, void *fh,
 	case V4L2_SEL_TGT_COMPOSE:
 	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
 	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
-	case V4L2_SEL_TGT_COMPOSE_PADDED:
+		/* The compose rectangle is fixed to the source format. */
 		s->r = priv->vdev.compose;
 		break;
+	case V4L2_SEL_TGT_COMPOSE_PADDED:
+		/*
+		 * The hardware writes with a configurable but fixed DMA burst
+		 * size. If the source format width is not burst size aligned,
+		 * the written frame contains padding to the right.
+		 */
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = priv->vdev.fmt.fmt.pix.width;
+		s->r.height = priv->vdev.fmt.fmt.pix.height;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.20.1

