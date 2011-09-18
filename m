Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44589 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573Ab1IRLwX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 07:52:23 -0400
References: <E1R5FCa-0003k7-2N@www.linuxtv.org>
In-Reply-To: <E1R5FCa-0003k7-2N@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [git:v4l-dvb/for_v3.2] [media] cx18: Fix videobuf capture
From: Andy Walls <awalls@md.metrocast.net>
Date: Sun, 18 Sep 2011 07:52:28 -0400
To: linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org
CC: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Message-ID: <f0028eee-48f3-4605-b907-6d0f73f7d1ad@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

>This is an automatic generated email to let you know that the following
>patch were queued at the 
>http://git.linuxtv.org/media_tree.git tree:
>
>Subject: [media] cx18: Fix videobuf capture
>Author:  Simon Farnsworth <simon.farnsworth@onelan.co.uk>
>Date:    Mon Sep 5 12:23:12 2011 -0300
>
>When we moved to 3.0, we found that the cx18 driver was oopsing on
>close with:
>
>NULL pointer deref at:
>
>[ 2290.461009] Call Trace:
>[ 2290.461009]  [<c046007b>] ? pm_qos_add_request+0xc/0x6e
>[ 2290.461009]  [<c082631c>] __mutex_lock_common+0x87/0x125
>[ 2290.461009]  [<f8970e92>] ? cx18_queue_flush+0x31/0x87 [cx18]
>[ 2290.461009]  [<c0436b85>] ? __might_sleep+0x29/0xe4
>[ 2290.461009]  [<c0826515>] __mutex_lock_slowpath+0x25/0x27
>[ 2290.461009]  [<c08264b2>] ? mutex_lock+0x2e/0x3b
>[ 2290.461009]  [<c08264b2>] mutex_lock+0x2e/0x3b
>[ 2290.461009]  [<f88d3137>] videobuf_queue_lock+0x13/0x15
>[videobuf_core]
>[ 2290.461009]  [<f88d3f86>] __videobuf_free+0xfc/0x112 [videobuf_core]
>[ 2290.461009]  [<f89741e6>] cx18_v4l2_close+0x158/0x172 [cx18]
>[ 2290.461009]  [<c0507522>] ? cpumask_next+0x1a/0x1d
>[ 2290.461009]  [<f88a319d>] v4l2_release+0x35/0x52 [videodev]
>[ 2290.461009]  [<c04f5717>] fput+0x100/0x1a5
>[ 2290.461009]  [<c04f2e09>] filp_close+0x5c/0x64
>[ 2290.461009]  [<c04f2e70>] sys_close+0x5f/0x93
>[ 2290.461009]  [<c082cd5f>] sysenter_do_call+0x12/0x28
>
>Some digging showed that a merge at some previous point partially
>added broken mmap() support, causing this trace. Remove the broken
>code completely.
>
>On top of that, the calculation in place for "buffer full" depended on
>UYUV instead of HM12, while our GStreamer code was picking HM12 in
>some circumstances.
>
>Finally, the V4L2_CAP_STREAMING capability was never exposed. Patch it
>into the YUV encoder node only.
>
>Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
>Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> drivers/media/video/cx18/cx18-driver.h  |    5 +----
> drivers/media/video/cx18/cx18-fileops.c |    2 --
> drivers/media/video/cx18/cx18-ioctl.c   |   18 +++++++++++-------
> drivers/media/video/cx18/cx18-mailbox.c |    2 +-
> drivers/media/video/cx18/cx18-streams.c |   13 +++++++++++++
> 5 files changed, 26 insertions(+), 14 deletions(-)
>
>---
>
>http://git.linuxtv.org/media_tree.git?a=commitdiff;h=09fc9802c31a9358a4e34642aa5f569111752879
>
>diff --git a/drivers/media/video/cx18/cx18-driver.h
>b/drivers/media/video/cx18/cx18-driver.h
>index 1834207..b9a94fc 100644
>--- a/drivers/media/video/cx18/cx18-driver.h
>+++ b/drivers/media/video/cx18/cx18-driver.h
>@@ -409,6 +409,7 @@ struct cx18_stream {
> 
> 	/* Videobuf for YUV video */
> 	u32 pixelformat;
>+	u32 vb_bytes_per_frame;
> 	struct list_head vb_capture;    /* video capture queue */
> 	spinlock_t vb_lock;
> 	struct timer_list vb_timeout;
>@@ -430,10 +431,6 @@ struct cx18_open_id {
> 	u32 open_id;
> 	int type;
> 	struct cx18 *cx;
>-
>-	struct videobuf_queue vbuf_q;
>-	spinlock_t s_lock; /* Protect vbuf_q */
>-	enum v4l2_buf_type vb_type;
> };
> 
> static inline struct cx18_open_id *fh2id(struct v4l2_fh *fh)
>diff --git a/drivers/media/video/cx18/cx18-fileops.c
>b/drivers/media/video/cx18/cx18-fileops.c
>index 07411f3..14cb961 100644
>--- a/drivers/media/video/cx18/cx18-fileops.c
>+++ b/drivers/media/video/cx18/cx18-fileops.c
>@@ -784,8 +784,6 @@ int cx18_v4l2_close(struct file *filp)
> 		cx18_release_stream(s);
> 	} else {
> 		cx18_stop_capture(id, 0);
>-		if (id->type == CX18_ENC_STREAM_TYPE_YUV)
>-			videobuf_mmap_free(&id->vbuf_q);
> 	}
> 	kfree(id);
> 	mutex_unlock(&cx->serialize_lock);
>diff --git a/drivers/media/video/cx18/cx18-ioctl.c
>b/drivers/media/video/cx18/cx18-ioctl.c
>index afe0a29..66b1c15 100644
>--- a/drivers/media/video/cx18/cx18-ioctl.c
>+++ b/drivers/media/video/cx18/cx18-ioctl.c
>@@ -160,12 +160,7 @@ static int cx18_g_fmt_vid_cap(struct file *file,
>void *fh,
> 	pixfmt->priv = 0;
> 	if (id->type == CX18_ENC_STREAM_TYPE_YUV) {
> 		pixfmt->pixelformat = s->pixelformat;
>-		/* HM12 YUV size is (Y=(h*720) + UV=(h*(720/2)))
>-		   UYUV YUV size is (Y=(h*720) + UV=(h*(720))) */
>-		if (s->pixelformat == V4L2_PIX_FMT_HM12)
>-			pixfmt->sizeimage = pixfmt->height * 720 * 3 / 2;
>-		else
>-			pixfmt->sizeimage = pixfmt->height * 720 * 2;
>+		pixfmt->sizeimage = s->vb_bytes_per_frame;
> 		pixfmt->bytesperline = 720;
> 	} else {
> 		pixfmt->pixelformat = V4L2_PIX_FMT_MPEG;
>@@ -296,6 +291,12 @@ static int cx18_s_fmt_vid_cap(struct file *file,
>void *fh,
> 		return -EBUSY;
> 
> 	s->pixelformat = fmt->fmt.pix.pixelformat;
>+	/* HM12 YUV size is (Y=(h*720) + UV=(h*(720/2)))
>+	   UYUV YUV size is (Y=(h*720) + UV=(h*(720))) */
>+	if (s->pixelformat == V4L2_PIX_FMT_HM12)
>+		s->vb_bytes_per_frame = h * 720 * 3 / 2;
>+	else
>+		s->vb_bytes_per_frame = h * 720 * 2;
> 
> 	mbus_fmt.width = cx->cxhdl.width = w;
> 	mbus_fmt.height = cx->cxhdl.height = h;
>@@ -463,13 +464,16 @@ static int cx18_s_register(struct file *file,
>void *fh,
> static int cx18_querycap(struct file *file, void *fh,
> 				struct v4l2_capability *vcap)
> {
>-	struct cx18 *cx = fh2id(fh)->cx;
>+	struct cx18_open_id *id = fh2id(fh);
>+	struct cx18 *cx = id->cx;
> 
> 	strlcpy(vcap->driver, CX18_DRIVER_NAME, sizeof(vcap->driver));
> 	strlcpy(vcap->card, cx->card_name, sizeof(vcap->card));
> 	snprintf(vcap->bus_info, sizeof(vcap->bus_info),
> 		 "PCI:%s", pci_name(cx->pci_dev));
> 	vcap->capabilities = cx->v4l2_cap; 	    /* capabilities */
>+	if (id->type == CX18_ENC_STREAM_TYPE_YUV)
>+		vcap->capabilities |= V4L2_CAP_STREAMING;
> 	return 0;
> }
> 
>diff --git a/drivers/media/video/cx18/cx18-mailbox.c
>b/drivers/media/video/cx18/cx18-mailbox.c
>index c07191e..0c7796e 100644
>--- a/drivers/media/video/cx18/cx18-mailbox.c
>+++ b/drivers/media/video/cx18/cx18-mailbox.c
>@@ -196,7 +196,7 @@ static void cx18_mdl_send_to_videobuf(struct
>cx18_stream *s,
> 	}
> 
>	/* If we've filled the buffer as per the callers res then dispatch it
>*/
>-	if (vb_buf->bytes_used >= (vb_buf->vb.width * vb_buf->vb.height * 2))
>{
>+	if (vb_buf->bytes_used >= s->vb_bytes_per_frame) {
> 		dispatch = 1;
> 		vb_buf->bytes_used = 0;
> 	}
>diff --git a/drivers/media/video/cx18/cx18-streams.c
>b/drivers/media/video/cx18/cx18-streams.c
>index 852f420..638cca1 100644
>--- a/drivers/media/video/cx18/cx18-streams.c
>+++ b/drivers/media/video/cx18/cx18-streams.c
>@@ -138,6 +138,12 @@ static int cx18_prepare_buffer(struct
>videobuf_queue *q,
> 		buf->tvnorm    = cx->std;
> 		s->pixelformat = pixelformat;
> 
>+		/* HM12 YUV size is (Y=(h*720) + UV=(h*(720/2)))
>+		   UYUV YUV size is (Y=(h*720) + UV=(h*(720))) */
>+		if (s->pixelformat == V4L2_PIX_FMT_HM12)
>+			s->vb_bytes_per_frame = height * 720 * 3 / 2;
>+		else
>+			s->vb_bytes_per_frame = height * 720 * 2;
> 		cx18_dma_free(q, s, buf);
> 	}
> 
>@@ -154,6 +160,12 @@ static int cx18_prepare_buffer(struct
>videobuf_queue *q,
> 		buf->tvnorm    = cx->std;
> 		s->pixelformat = pixelformat;
> 
>+		/* HM12 YUV size is (Y=(h*720) + UV=(h*(720/2)))
>+		   UYUV YUV size is (Y=(h*720) + UV=(h*(720))) */
>+		if (s->pixelformat == V4L2_PIX_FMT_HM12)
>+			s->vb_bytes_per_frame = height * 720 * 3 / 2;
>+		else
>+			s->vb_bytes_per_frame = height * 720 * 2;
> 		rc = videobuf_iolock(q, &buf->vb, NULL);
> 		if (rc != 0)
> 			goto fail;
>@@ -287,6 +299,7 @@ static void cx18_stream_init(struct cx18 *cx, int
>type)
> 
> 		/* Assume the previous pixel default */
> 		s->pixelformat = V4L2_PIX_FMT_HM12;
>+		s->vb_bytes_per_frame = cx->cxhdl.height * 720 * 3 / 2;
> 	}
> }
> 
>
>_______________________________________________
>linuxtv-commits mailing list
>linuxtv-commits@linuxtv.org
>http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits

Mauro,

I haven't reviewed this one.  I'm assuming it is Ok.

There is another patch floating on the list for the cx25840 driver for analog support for some hybrid device.  DO NOT merge that one as it will break ivtv cards.  I haven't had any time to write proper comments on it.

Regards,
Andy
