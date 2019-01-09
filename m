Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F159C43612
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 342DC21738
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbfAILIm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 06:08:42 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51227 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730569AbfAILIl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 06:08:41 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ghBiy-0002Wv-F3; Wed, 09 Jan 2019 12:08:40 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, kernel@pengutronix.de
Subject: [PATCH v2 2/3] media: imx: set compose rectangle to mbus format
Date:   Wed,  9 Jan 2019 12:08:30 +0100
Message-Id: <20190109110831.23395-2-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190109110831.23395-1-p.zabel@pengutronix.de>
References: <20190109110831.23395-1-p.zabel@pengutronix.de>
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
---
Changes since v1:
 - Typo fixups, this time applied to the correct patch.
---
 drivers/staging/media/imx/imx-media-capture.c | 56 +++++++++++++------
 1 file changed, 38 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index fb985e68f9ab..614e335fb61c 100644
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
@@ -239,15 +231,32 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
 		cc = cc_src;
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
@@ -255,7 +264,13 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
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
 
@@ -264,8 +279,8 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
 					      CS_SEL_ANY, true);
 	priv->vdev.compose.left = 0;
 	priv->vdev.compose.top = 0;
-	priv->vdev.compose.width = f->fmt.pix.width;
-	priv->vdev.compose.height = f->fmt.pix.height;
+	priv->vdev.compose.width = fmt_src.format.width;
+	priv->vdev.compose.height = fmt_src.format.height;
 
 	return 0;
 }
@@ -306,9 +321,14 @@ static int capture_g_selection(struct file *file, void *fh,
 	case V4L2_SEL_TGT_COMPOSE:
 	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
 	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
-	case V4L2_SEL_TGT_COMPOSE_PADDED:
 		s->r = priv->vdev.compose;
 		break;
+	case V4L2_SEL_TGT_COMPOSE_PADDED:
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

