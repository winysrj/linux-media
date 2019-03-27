Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90385C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67EDE2147C
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfC0PTC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 11:19:02 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48488 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbfC0PTC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 11:19:02 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id B6AC3281FF3
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com, lkcamp@lists.libreplanetbr.org
Subject: [PATCH v2 03/15] media: vimc: cap: Change vimc_cap_device.format type
Date:   Wed, 27 Mar 2019 12:17:31 -0300
Message-Id: <20190327151743.18528-4-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190327151743.18528-1-andrealmeid@collabora.com>
References: <20190327151743.18528-1-andrealmeid@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

vimc_cap_device.format field was defined as v4l2_pix_format,
a struct to handle single planar pixel formats. It turns out that
if v4l2_format is used, we can reuse functions for both
v4l2_pix_format and v4l2_pix_format_mplane. This change will
help at future commits implementing multiplanar pixel
format support.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
Change in v2: none

 drivers/media/platform/vimc/vimc-capture.c | 56 ++++++++++++----------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index e7d0fc2228a6..de52f20b5c85 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -58,7 +58,7 @@ struct vimc_cap_device {
 	struct vimc_ent_device ved;
 	struct video_device vdev;
 	struct device *dev;
-	struct v4l2_pix_format format;
+	struct v4l2_format format;
 	struct vb2_queue queue;
 	struct list_head buf_list;
 	/*
@@ -74,12 +74,13 @@ struct vimc_cap_device {
 	struct vimc_stream stream;
 };
 
-static const struct v4l2_pix_format fmt_default = {
-	.width = 640,
-	.height = 480,
-	.pixelformat = V4L2_PIX_FMT_RGB24,
-	.field = V4L2_FIELD_NONE,
-	.colorspace = V4L2_COLORSPACE_DEFAULT,
+static const struct v4l2_format fmt_default = {
+	.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+	.fmt.pix.width = 640,
+	.fmt.pix.height = 480,
+	.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB24,
+	.fmt.pix.field = V4L2_FIELD_NONE,
+	.fmt.pix.colorspace = V4L2_COLORSPACE_DEFAULT,
 };
 
 struct vimc_cap_buffer {
@@ -110,7 +111,7 @@ static void vimc_cap_get_format(struct vimc_ent_device *ved,
 	struct vimc_cap_device *vcap = container_of(ved, struct vimc_cap_device,
 						    ved);
 
-	*fmt = vcap->format;
+	*fmt = vcap->format.fmt.pix;
 }
 
 static int vimc_cap_g_fmt_vid_cap(struct file *file, void *priv,
@@ -118,7 +119,7 @@ static int vimc_cap_g_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct vimc_cap_device *vcap = video_drvdata(file);
 
-	f->fmt.pix = vcap->format;
+	*f = vcap->format;
 
 	return 0;
 }
@@ -136,13 +137,13 @@ static int vimc_cap_try_fmt_vid_cap(struct file *file, void *priv,
 	vimc_colorimetry_clamp(format);
 
 	if (format->field == V4L2_FIELD_ANY)
-		format->field = fmt_default.field;
+		format->field = fmt_default.fmt.pix.field;
 
 	/* TODO: Add support for custom bytesperline values */
 
 	/* Don't accept a pixelformat that is not on the table */
 	if (!v4l2_format_info(format->pixelformat))
-		format->pixelformat = fmt_default.pixelformat;
+		format->pixelformat = fmt_default.fmt.pix.pixelformat;
 
 	return v4l2_fill_pixfmt(format, format->pixelformat,
 				format->width, format->height);
@@ -163,17 +164,19 @@ static int vimc_cap_s_fmt_vid_cap(struct file *file, void *priv,
 		"old:%dx%d (0x%x, %d, %d, %d, %d) "
 		"new:%dx%d (0x%x, %d, %d, %d, %d)\n", vcap->vdev.name,
 		/* old */
-		vcap->format.width, vcap->format.height,
-		vcap->format.pixelformat, vcap->format.colorspace,
-		vcap->format.quantization, vcap->format.xfer_func,
-		vcap->format.ycbcr_enc,
+		vcap->format.fmt.pix.width, vcap->format.fmt.pix.height,
+		vcap->format.fmt.pix.pixelformat,
+		vcap->format.fmt.pix.colorspace,
+		vcap->format.fmt.pix.quantization,
+		vcap->format.fmt.pix.xfer_func,
+		vcap->format.fmt.pix.ycbcr_enc,
 		/* new */
 		f->fmt.pix.width, f->fmt.pix.height,
 		f->fmt.pix.pixelformat,	f->fmt.pix.colorspace,
 		f->fmt.pix.quantization, f->fmt.pix.xfer_func,
 		f->fmt.pix.ycbcr_enc);
 
-	vcap->format = f->fmt.pix;
+	vcap->format = *f;
 
 	return 0;
 }
@@ -279,7 +282,8 @@ static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned int count)
 		return ret;
 	}
 
-	vcap->stream.producer_pixfmt = vcap->format.pixelformat;
+	vcap->stream.producer_pixfmt = vcap->format.fmt.pix.pixelformat;
+
 	ret = vimc_streamer_s_stream(&vcap->stream, &vcap->ved, 1);
 	if (ret) {
 		media_pipeline_stop(entity);
@@ -326,10 +330,10 @@ static int vimc_cap_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
 
 	if (*nplanes)
-		return sizes[0] < vcap->format.sizeimage ? -EINVAL : 0;
+		return sizes[0] < vcap->format.fmt.pix.sizeimage ? -EINVAL : 0;
 	/* We don't support multiplanes for now */
 	*nplanes = 1;
-	sizes[0] = vcap->format.sizeimage;
+	sizes[0] = vcap->format.fmt.pix.sizeimage;
 
 	return 0;
 }
@@ -337,7 +341,7 @@ static int vimc_cap_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 static int vimc_cap_buffer_prepare(struct vb2_buffer *vb)
 {
 	struct vimc_cap_device *vcap = vb2_get_drv_priv(vb->vb2_queue);
-	unsigned long size = vcap->format.sizeimage;
+	unsigned long size = vcap->format.fmt.pix.sizeimage;
 
 	if (vb2_plane_size(vb, 0) < size) {
 		dev_err(vcap->dev, "%s: buffer too small (%lu < %lu)\n",
@@ -412,15 +416,15 @@ static void *vimc_cap_process_frame(struct vimc_ent_device *ved,
 	/* Fill the buffer */
 	vimc_buf->vb2.vb2_buf.timestamp = ktime_get_ns();
 	vimc_buf->vb2.sequence = vcap->sequence++;
-	vimc_buf->vb2.field = vcap->format.field;
+	vimc_buf->vb2.field = vcap->format.fmt.pix.field;
 
 	vbuf = vb2_plane_vaddr(&vimc_buf->vb2.vb2_buf, 0);
 
-	memcpy(vbuf, frame, vcap->format.sizeimage);
+	memcpy(vbuf, frame, vcap->format.fmt.pix.sizeimage);
 
 	/* Set it as ready */
 	vb2_set_plane_payload(&vimc_buf->vb2.vb2_buf, 0,
-			      vcap->format.sizeimage);
+			      vcap->format.fmt.pix.sizeimage);
 	vb2_buffer_done(&vimc_buf->vb2.vb2_buf, VB2_BUF_STATE_DONE);
 	return NULL;
 }
@@ -484,8 +488,10 @@ static int vimc_cap_comp_bind(struct device *comp, struct device *master,
 
 	/* Set default frame format */
 	vcap->format = fmt_default;
-	v4l2_fill_pixfmt(&vcap->format, vcap->format.pixelformat,
-			 vcap->format.width, vcap->format.height);
+	v4l2_fill_pixfmt(&vcap->format.fmt.pix,
+			 vcap->format.fmt.pix.pixelformat,
+			 vcap->format.fmt.pix.width,
+			 vcap->format.fmt.pix.height);
 
 	/* Fill the vimc_ent_device struct */
 	vcap->ved.ent = &vcap->vdev.entity;
-- 
2.21.0

