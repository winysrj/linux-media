Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4330 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3BIKBW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 17/26] cx231xx-417: fix g/try_fmt compliance problems
Date: Sat,  9 Feb 2013 11:00:47 +0100
Message-Id: <2a330dc65cf904221683d1aa2727fc6693190dc8.1360403310.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Colorspace, field and priv were not set, and sizeimage was calculated
using the wrong values (dev->ts1.ts_packet_size and dev->ts1.ts_packet_count
can be 0 at module load).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c |   34 +++++++++++++++++--------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index be8f7481..cbdc141 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1223,6 +1223,7 @@ static int bb_buf_setup(struct videobuf_queue *q,
 
 	return 0;
 }
+
 static void free_buffer(struct videobuf_queue *vq, struct cx231xx_buffer *buf)
 {
 	struct cx231xx_fh *fh = vq->priv_data;
@@ -1645,17 +1646,18 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct cx231xx_fh  *fh  = file->private_data;
 	struct cx231xx *dev = fh->dev;
+
 	dprintk(3, "enter vidioc_g_fmt_vid_cap()\n");
-	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
+	f->fmt.pix.pixelformat = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    =
-		dev->ts1.ts_packet_size * dev->ts1.ts_packet_count;
-	f->fmt.pix.colorspace   = 0;
-	f->fmt.pix.width        = dev->ts1.width;
-	f->fmt.pix.height       = dev->ts1.height;
-	f->fmt.pix.field        = fh->vidq.field;
-	dprintk(1, "VIDIOC_G_FMT: w: %d, h: %d, f: %d\n",
-		dev->ts1.width, dev->ts1.height, fh->vidq.field);
+	f->fmt.pix.sizeimage = mpeglines * mpeglinesize;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.width = dev->ts1.width;
+	f->fmt.pix.height = dev->ts1.height;
+	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.priv = 0;
+	dprintk(1, "VIDIOC_G_FMT: w: %d, h: %d\n",
+		dev->ts1.width, dev->ts1.height);
 	dprintk(3, "exit vidioc_g_fmt_vid_cap()\n");
 	return 0;
 }
@@ -1665,14 +1667,16 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct cx231xx_fh  *fh  = file->private_data;
 	struct cx231xx *dev = fh->dev;
+
 	dprintk(3, "enter vidioc_try_fmt_vid_cap()\n");
-	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
+	f->fmt.pix.pixelformat = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    =
-		dev->ts1.ts_packet_size * dev->ts1.ts_packet_count;
-	f->fmt.pix.colorspace   = 0;
-	dprintk(1, "VIDIOC_TRY_FMT: w: %d, h: %d, f: %d\n",
-		dev->ts1.width, dev->ts1.height, fh->vidq.field);
+	f->fmt.pix.sizeimage = mpeglines * mpeglinesize;
+	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
+	dprintk(1, "VIDIOC_TRY_FMT: w: %d, h: %d\n",
+		dev->ts1.width, dev->ts1.height);
 	dprintk(3, "exit vidioc_try_fmt_vid_cap()\n");
 	return 0;
 }
-- 
1.7.10.4

