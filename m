Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B30CC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 23:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5384321907
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 23:43:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ga1IsA3f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfBGXnD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 18:43:03 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40824 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfBGXnD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 18:43:03 -0500
Received: by mail-pg1-f195.google.com with SMTP id z10so703408pgp.7;
        Thu, 07 Feb 2019 15:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ey/x5vrn4CizUUmXBv4+fgMvrzWraMv0zuIa3QCSm84=;
        b=ga1IsA3fHg8/0gR7tlFT8D7e/A5Phoy3Z5g+k/w3M2S4OpuzUswpnyP3bGmmG3aCF+
         j+ukUU2ufzZMKfzmvkr75hVlEe8F6Qbx+vm6oL/+Km0ULeHBwpIYn/OilmUpnwxcDI8H
         MsDtf5fdhVqk64MaPP+KeEtdDeB1FtJIh9j/pqQni5ODXxTk5ZlXs6rfWmukvAfyfugO
         ed8/ubmDjrKPCv0sMiqfOU3XqXIEcnBBbnZwXFUYsb4r+mJOwG3QwlH5SIp2+dCglymh
         jYkethbxI06IdX5jVG4dXQmnv7QjnOvnONp22ScVkpYZEfEPuIC646f8Df+FgA78J/2G
         Pn5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ey/x5vrn4CizUUmXBv4+fgMvrzWraMv0zuIa3QCSm84=;
        b=AIkMXcUPDNU6O0Rhiz4+cY8A28a3Bpgh59IBPRR6k7lTdbQGxDOiO5fWnXRBRQsUar
         rDKd+yQ2YP9nTvxWosFisGRQxgGIOr5djfZAB+GdhIvHmiz6ZKtIAUEk9hRi6+gKf+YQ
         /kohC+ATPYY7sNsRkuGGvYatjyPdWP7RIht3/iCw0QiaxbK167UrvBfaVbtr4M6VmjHt
         1NvKnR8w8TUONCS20FBiHBLYIRr5OaDaBVOoFFw014gmWTziOh5oW+p2ixXpC4HfcaOM
         vg0ADKwXk9OR8UyCwQBd6GJ8KX1uJuTP8ggj2P2XgmnzRiC1OMWUqxBVD0BPGU08vm3J
         ZFxg==
X-Gm-Message-State: AHQUAuYC0uj/OgWy+o6/OWENSD95BNca3O3f0fm6MoQtrDDKWM8Svbyf
        mapqSyWLfM6LLf/+MgrrXZZkBliMDck=
X-Google-Smtp-Source: AHgI3Iav8GpcknzfRRoCkuqusVJaH5EYitky9oQeyv7iBHOw3oMJCr45Ebj7aX8Tx8Hu7KzfcbmdgQ==
X-Received: by 2002:a63:2d46:: with SMTP id t67mr17721261pgt.140.1549582981766;
        Thu, 07 Feb 2019 15:43:01 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id y16sm291488pgk.22.2019.02.07.15.43.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Feb 2019 15:43:00 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
X-Google-Original-From: Steve Longerbeam <steve_longerbeam@mentor.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] media: imx: Set capture compose rectangle in capture_device_set_format
Date:   Thu,  7 Feb 2019 15:42:55 -0800
Message-Id: <20190207234255.25994-1-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Steve Longerbeam <slongerbeam@gmail.com>

The capture compose rectangle was not getting updated when setting
the source subdevice's source pad format. This causes the compose window
to be zero (or not updated) at stream start unless the capture device
format was set explicitly at the capture device node.

Fix by moving the calculation of the capture compose rectangle to
imx_media_mbus_fmt_to_pix_fmt(), and pass the rectangle to
imx_media_capture_device_set_format().

Fixes: 439d8186fb23 ("media: imx: add capture compose rectangle")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/imx-ic-prpencvf.c   |  5 ++--
 drivers/staging/media/imx/imx-media-capture.c | 24 +++++++++----------
 drivers/staging/media/imx/imx-media-csi.c     |  5 ++--
 drivers/staging/media/imx/imx-media-utils.c   | 20 ++++++++++++----
 drivers/staging/media/imx/imx-media.h         |  6 +++--
 5 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 376b504e8a42..5c8e6ad8c025 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -912,6 +912,7 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 	const struct imx_media_pixfmt *cc;
 	struct v4l2_pix_format vdev_fmt;
 	struct v4l2_mbus_framefmt *fmt;
+	struct v4l2_rect vdev_compose;
 	int ret = 0;
 
 	if (sdformat->pad >= PRPENCVF_NUM_PADS)
@@ -953,11 +954,11 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 	priv->cc[sdformat->pad] = cc;
 
 	/* propagate output pad format to capture device */
-	imx_media_mbus_fmt_to_pix_fmt(&vdev_fmt,
+	imx_media_mbus_fmt_to_pix_fmt(&vdev_fmt, &vdev_compose,
 				      &priv->format_mbus[PRPENCVF_SRC_PAD],
 				      priv->cc[PRPENCVF_SRC_PAD]);
 	mutex_unlock(&priv->lock);
-	imx_media_capture_device_set_format(vdev, &vdev_fmt);
+	imx_media_capture_device_set_format(vdev, &vdev_fmt, &vdev_compose);
 
 	return 0;
 out:
diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index f92edee63aa6..9703c85b19c4 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -205,7 +205,8 @@ static int capture_g_fmt_vid_cap(struct file *file, void *fh,
 
 static int __capture_try_fmt_vid_cap(struct capture_priv *priv,
 				     struct v4l2_subdev_format *fmt_src,
-				     struct v4l2_format *f)
+				     struct v4l2_format *f,
+				     struct v4l2_rect *compose)
 {
 	const struct imx_media_pixfmt *cc, *cc_src;
 
@@ -245,7 +246,8 @@ static int __capture_try_fmt_vid_cap(struct capture_priv *priv,
 		}
 	}
 
-	imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix, &fmt_src->format, cc);
+	imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix, compose,
+				      &fmt_src->format, cc);
 
 	return 0;
 }
@@ -263,7 +265,7 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
 	if (ret)
 		return ret;
 
-	return __capture_try_fmt_vid_cap(priv, &fmt_src, f);
+	return __capture_try_fmt_vid_cap(priv, &fmt_src, f, NULL);
 }
 
 static int capture_s_fmt_vid_cap(struct file *file, void *fh,
@@ -271,6 +273,7 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
 {
 	struct capture_priv *priv = video_drvdata(file);
 	struct v4l2_subdev_format fmt_src;
+	struct v4l2_rect compose;
 	int ret;
 
 	if (vb2_is_busy(&priv->q)) {
@@ -284,17 +287,14 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
 	if (ret)
 		return ret;
 
-	ret = __capture_try_fmt_vid_cap(priv, &fmt_src, f);
+	ret = __capture_try_fmt_vid_cap(priv, &fmt_src, f, &compose);
 	if (ret)
 		return ret;
 
 	priv->vdev.fmt.fmt.pix = f->fmt.pix;
 	priv->vdev.cc = imx_media_find_format(f->fmt.pix.pixelformat,
 					      CS_SEL_ANY, true);
-	priv->vdev.compose.left = 0;
-	priv->vdev.compose.top = 0;
-	priv->vdev.compose.width = fmt_src.format.width;
-	priv->vdev.compose.height = fmt_src.format.height;
+	priv->vdev.compose = compose;
 
 	return 0;
 }
@@ -655,7 +655,8 @@ static struct video_device capture_videodev = {
 };
 
 void imx_media_capture_device_set_format(struct imx_media_video_dev *vdev,
-					 struct v4l2_pix_format *pix)
+					 const struct v4l2_pix_format *pix,
+					 const struct v4l2_rect *compose)
 {
 	struct capture_priv *priv = to_capture_priv(vdev);
 
@@ -663,6 +664,7 @@ void imx_media_capture_device_set_format(struct imx_media_video_dev *vdev,
 	priv->vdev.fmt.fmt.pix = *pix;
 	priv->vdev.cc = imx_media_find_format(pix->pixelformat, CS_SEL_ANY,
 					      true);
+	priv->vdev.compose = *compose;
 	mutex_unlock(&priv->mutex);
 }
 EXPORT_SYMBOL_GPL(imx_media_capture_device_set_format);
@@ -768,10 +770,8 @@ int imx_media_capture_device_register(struct imx_media_video_dev *vdev)
 	}
 
 	vdev->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	imx_media_mbus_fmt_to_pix_fmt(&vdev->fmt.fmt.pix,
+	imx_media_mbus_fmt_to_pix_fmt(&vdev->fmt.fmt.pix, &vdev->compose,
 				      &fmt_src.format, NULL);
-	vdev->compose.width = fmt_src.format.width;
-	vdev->compose.height = fmt_src.format.height;
 	vdev->cc = imx_media_find_format(vdev->fmt.fmt.pix.pixelformat,
 					 CS_SEL_ANY, false);
 
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index fb5307e2ca43..5265a2cc93bc 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1502,6 +1502,7 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 	struct v4l2_pix_format vdev_fmt;
 	struct v4l2_mbus_framefmt *fmt;
 	struct v4l2_rect *crop, *compose;
+	struct v4l2_rect vdev_compose;
 	int ret;
 
 	if (sdformat->pad >= CSI_NUM_PADS)
@@ -1557,11 +1558,11 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 	priv->cc[sdformat->pad] = cc;
 
 	/* propagate IDMAC output pad format to capture device */
-	imx_media_mbus_fmt_to_pix_fmt(&vdev_fmt,
+	imx_media_mbus_fmt_to_pix_fmt(&vdev_fmt, &vdev_compose,
 				      &priv->format_mbus[CSI_SRC_PAD_IDMAC],
 				      priv->cc[CSI_SRC_PAD_IDMAC]);
 	mutex_unlock(&priv->lock);
-	imx_media_capture_device_set_format(vdev, &vdev_fmt);
+	imx_media_capture_device_set_format(vdev, &vdev_fmt, &vdev_compose);
 
 	return 0;
 out:
diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 5f110d90a4ef..e6f544528d31 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -577,7 +577,8 @@ void imx_media_fill_default_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
 EXPORT_SYMBOL_GPL(imx_media_fill_default_mbus_fields);
 
 int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
-				  struct v4l2_mbus_framefmt *mbus,
+				  struct v4l2_rect *compose,
+				  const struct v4l2_mbus_framefmt *mbus,
 				  const struct imx_media_pixfmt *cc)
 {
 	u32 width;
@@ -624,6 +625,17 @@ int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
 	pix->sizeimage = cc->planar ? ((stride * pix->height * cc->bpp) >> 3) :
 			 stride * pix->height;
 
+	/*
+	 * set capture compose rectangle, which is fixed to the
+	 * source subdevice mbus format.
+	 */
+	if (compose) {
+		compose->left = 0;
+		compose->top = 0;
+		compose->width = mbus->width;
+		compose->height = mbus->height;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(imx_media_mbus_fmt_to_pix_fmt);
@@ -635,13 +647,11 @@ int imx_media_mbus_fmt_to_ipu_image(struct ipu_image *image,
 
 	memset(image, 0, sizeof(*image));
 
-	ret = imx_media_mbus_fmt_to_pix_fmt(&image->pix, mbus, NULL);
+	ret = imx_media_mbus_fmt_to_pix_fmt(&image->pix, &image->rect,
+					    mbus, NULL);
 	if (ret)
 		return ret;
 
-	image->rect.width = mbus->width;
-	image->rect.height = mbus->height;
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(imx_media_mbus_fmt_to_ipu_image);
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index 7a0e658753f0..195e858913a3 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -180,7 +180,8 @@ void imx_media_fill_default_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
 					struct v4l2_mbus_framefmt *fmt,
 					bool ic_route);
 int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
-				  struct v4l2_mbus_framefmt *mbus,
+				  struct v4l2_rect *compose,
+				  const struct v4l2_mbus_framefmt *mbus,
 				  const struct imx_media_pixfmt *cc);
 int imx_media_mbus_fmt_to_ipu_image(struct ipu_image *image,
 				    struct v4l2_mbus_framefmt *mbus);
@@ -261,7 +262,8 @@ void imx_media_capture_device_unregister(struct imx_media_video_dev *vdev);
 struct imx_media_buffer *
 imx_media_capture_device_next_buf(struct imx_media_video_dev *vdev);
 void imx_media_capture_device_set_format(struct imx_media_video_dev *vdev,
-					 struct v4l2_pix_format *pix);
+					 const struct v4l2_pix_format *pix,
+					 const struct v4l2_rect *compose);
 void imx_media_capture_device_error(struct imx_media_video_dev *vdev);
 
 /* subdev group ids */
-- 
2.17.1

