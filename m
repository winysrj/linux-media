Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C25C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 16:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6655E2087E
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 16:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551459139;
	bh=sI+D2yADRDyG021QODsO375SGHKtpb0VXym6v6WgcI8=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=HavfWo9WTxiQgVlRrqhwxcXg7pNukeIfIOb6g4PxKNq5O0dqNDJymKz8fCkYapbzS
	 kkqFDjT/SWX2Ga8ihi7KwmpCEmaYFn5h96WkP+P3c9iunzlW+LqqAwnf12DuYuZoFY
	 U2eOuELNXu1gFBiWSx3Ny+vHW21aPEOzLNiCpmus=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388984AbfCAQwS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 11:52:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46614 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388692AbfCAQwS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 11:52:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KKsMst+4qRWVHf6zWojJwJgps/gEd9MvH5NSzubJ7a0=; b=LZbSZQDHwuBAULXma4G711ON/X
        t89CjuRT2NeRROT8j0+kb92AhyJbxskl/VBOs8KR5oGUkfXbKCiBPwP8WsPNNqtHO7+5QiFzz0nQP
        MGBWFltFe18CYVngf838H8y25B7lN9/b6XRXUwS3TsFTkzxsBanYJPY5OLsnAvSgyHEsB/Y+biJfJ
        DyuZ2wOKTywdg8gjR/VtOGbNdWRN2sEMK2TdPVuYrf9+/iF1QGgS069Xqeid4GuCXPDq+vYjGqcMd
        GmDyh1og4L0AcPFTV8J10/6l5RmoyXNR5BgWHe6x76ZVXkNr+3q7LtScddF5hhXU5gEcrwQ7f/1UU
        12RKMMBA==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzlOT-00029Q-VJ; Fri, 01 Mar 2019 16:52:17 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gzlOP-0002l3-K0; Fri, 01 Mar 2019 11:52:13 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 2/2] media: vim2m: Address some coding style issues
Date:   Fri,  1 Mar 2019 11:52:13 -0500
Message-Id: <c310d1f97c94f68eb4b3860933b2e977c6b0cf5b.1551459127.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <971d62ddd23eb07b6cbad858f9b004342efa6ee1.1551459127.git.mchehab+samsung@kernel.org>
References: <971d62ddd23eb07b6cbad858f9b004342efa6ee1.1551459127.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

As we did lots of change at vim2m driver, let's take the
opportunity and make checkpatch happier, addressing the
errors/warnings that makes sense.

While here, increment driver's version.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 52 ++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index eff4eff858fe..34dcaca45d8b 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -35,10 +35,10 @@
 MODULE_DESCRIPTION("Virtual device for mem2mem framework testing");
 MODULE_AUTHOR("Pawel Osciak, <pawel@osciak.com>");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0.1.1");
+MODULE_VERSION("0.2");
 MODULE_ALIAS("mem2mem_testdev");
 
-static unsigned debug;
+static unsigned int debug;
 module_param(debug, uint, 0644);
 MODULE_PARM_DESC(debug, "debug level");
 
@@ -61,8 +61,8 @@ MODULE_PARM_DESC(default_transtime, "default transaction time in ms");
 #define BAYER_HEIGHT_ALIGN 2
 
 /* Flags that indicate a format can be used for capture/output */
-#define MEM2MEM_CAPTURE	(1 << 0)
-#define MEM2MEM_OUTPUT	(1 << 1)
+#define MEM2MEM_CAPTURE	BIT(0)
+#define MEM2MEM_OUTPUT	BIT(1)
 
 #define MEM2MEM_NAME		"vim2m"
 
@@ -72,13 +72,12 @@ MODULE_PARM_DESC(default_transtime, "default transaction time in ms");
 #define MEM2MEM_VID_MEM_LIMIT	(16 * 1024 * 1024)
 
 /* Flags that indicate processing mode */
-#define MEM2MEM_HFLIP	(1 << 0)
-#define MEM2MEM_VFLIP	(1 << 1)
+#define MEM2MEM_HFLIP	BIT(0)
+#define MEM2MEM_VFLIP	BIT(1)
 
 #define dprintk(dev, lvl, fmt, arg...) \
 	v4l2_dbg(lvl, debug, &(dev)->v4l2_dev, "%s: " fmt, __func__, ## arg)
 
-
 static void vim2m_dev_release(struct device *dev)
 {}
 
@@ -240,7 +239,7 @@ static inline struct vim2m_ctx *file2ctx(struct file *file)
 }
 
 static struct vim2m_q_data *get_q_data(struct vim2m_ctx *ctx,
-					 enum v4l2_buf_type type)
+				       enum v4l2_buf_type type)
 {
 	switch (type) {
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
@@ -487,7 +486,10 @@ static int device_process(struct vim2m_ctx *ctx,
 	}
 	y_out = 0;
 
-	/* When format and resolution are identical, we can use a faster copy logic */
+	/*
+	 * When format and resolution are identical,
+	 * we can use a faster copy logic
+	 */
 	if (q_data_in->fmt->fourcc == q_data_out->fmt->fourcc &&
 	    q_data_in->width == q_data_out->width &&
 	    q_data_in->height == q_data_out->height) {
@@ -550,7 +552,6 @@ static int device_process(struct vim2m_ctx *ctx,
 			else
 				p_in_x[0] = p_line + x_offset * bytes_per_pixel;
 		}
-
 	}
 
 	return 0;
@@ -621,7 +622,7 @@ static void device_work(struct work_struct *w)
 
 	curr_ctx = container_of(w, struct vim2m_ctx, work_run.work);
 
-	if (NULL == curr_ctx) {
+	if (!curr_ctx) {
 		pr_err("Instance released before the end of transaction\n");
 		return;
 	}
@@ -657,7 +658,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
 	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
-			"platform:%s", MEM2MEM_NAME);
+		 "platform:%s", MEM2MEM_NAME);
 	return 0;
 }
 
@@ -767,8 +768,10 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_try_fmt(struct v4l2_format *f, struct vim2m_fmt *fmt)
 {
 	int walign, halign;
-	/* V4L2 specification suggests the driver corrects the format struct
-	 * if any of the dimensions is unsupported */
+	/*
+	 * V4L2 specification specifies the driver corrects the
+	 * format struct if any of the dimensions is unsupported
+	 */
 	if (f->fmt.pix.height < MIN_H)
 		f->fmt.pix.height = MIN_H;
 	else if (f->fmt.pix.height > MAX_H)
@@ -947,7 +950,6 @@ static const struct v4l2_ctrl_ops vim2m_ctrl_ops = {
 	.s_ctrl = vim2m_s_ctrl,
 };
 
-
 static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
 	.vidioc_querycap	= vidioc_querycap,
 
@@ -977,14 +979,15 @@ static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-
 /*
  * Queue operations
  */
 
 static int vim2m_queue_setup(struct vb2_queue *vq,
-				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], struct device *alloc_devs[])
+			     unsigned int *nbuffers,
+			     unsigned int *nplanes,
+			     unsigned int sizes[],
+			     struct device *alloc_devs[])
 {
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(vq);
 	struct vim2m_q_data *q_data;
@@ -1058,7 +1061,7 @@ static void vim2m_buf_queue(struct vb2_buffer *vb)
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
-static int vim2m_start_streaming(struct vb2_queue *q, unsigned count)
+static int vim2m_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(q);
 	struct vim2m_q_data *q_data = get_q_data(ctx, q->type);
@@ -1083,7 +1086,7 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
 			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 		else
 			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
-		if (vbuf == NULL)
+		if (!vbuf)
 			return;
 		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
 					   &ctx->hdl);
@@ -1112,7 +1115,8 @@ static const struct vb2_ops vim2m_qops = {
 	.buf_request_complete = vim2m_buf_request_complete,
 };
 
-static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
+static int queue_init(void *priv, struct vb2_queue *src_vq,
+		      struct vb2_queue *dst_vq)
 {
 	struct vim2m_ctx *ctx = priv;
 	int ret;
@@ -1318,7 +1322,7 @@ static int vim2m_probe(struct platform_device *pdev)
 
 	video_set_drvdata(vfd, dev);
 	v4l2_info(&dev->v4l2_dev,
-			"Device registered as /dev/video%d\n", vfd->num);
+		  "Device registered as /dev/video%d\n", vfd->num);
 
 	platform_set_drvdata(pdev, dev);
 
@@ -1338,8 +1342,8 @@ static int vim2m_probe(struct platform_device *pdev)
 	dev->mdev.ops = &m2m_media_ops;
 	dev->v4l2_dev.mdev = &dev->mdev;
 
-	ret = v4l2_m2m_register_media_controller(dev->m2m_dev,
-			vfd, MEDIA_ENT_F_PROC_VIDEO_SCALER);
+	ret = v4l2_m2m_register_media_controller(dev->m2m_dev, vfd,
+						 MEDIA_ENT_F_PROC_VIDEO_SCALER);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller\n");
 		goto unreg_m2m;
-- 
2.20.1

