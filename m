Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2127 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab3A2Qdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 11:33:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 06/20] cx231xx: fix a bunch of TRY/S_FMT bugs.
Date: Tue, 29 Jan 2013 17:32:59 +0100
Message-Id: <8ea4d0e56e5d7f702130009329643deee1ed7150.1359476777.git.hans.verkuil@cisco.com>
In-Reply-To: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
References: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
References: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fixed a number of incorrect size and bytesperline calculations, remove an
invalid busy check in try_fmt_vid_cap (try_fmt can never return EBUSY) and
zero the priv field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index b7dcfc1..05bafdaf 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -781,7 +781,7 @@ buffer_setup(struct videobuf_queue *vq, unsigned int *count, unsigned int *size)
 	struct cx231xx_fh *fh = vq->priv_data;
 	struct cx231xx *dev = fh->dev;
 
-	*size = (fh->dev->width * fh->dev->height * dev->format->depth + 7)>>3;
+	*size = fh->dev->width * fh->dev->height * ((dev->format->depth + 7) >> 3);
 	if (0 == *count)
 		*count = CX231XX_DEF_BUF;
 
@@ -835,8 +835,8 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 	int rc = 0, urb_init = 0;
 
 	/* The only currently supported format is 16 bits/pixel */
-	buf->vb.size = (fh->dev->width * fh->dev->height * dev->format->depth
-			+ 7) >> 3;
+	buf->vb.size = fh->dev->width * fh->dev->height *
+				((dev->format->depth + 7) >> 3);
 	if (0 != buf->vb.baddr && buf->vb.bsize < buf->vb.size)
 		return -EINVAL;
 
@@ -1000,11 +1000,12 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.width = dev->width;
 	f->fmt.pix.height = dev->height;
 	f->fmt.pix.pixelformat = dev->format->fourcc;
-	f->fmt.pix.bytesperline = (dev->width * dev->format->depth + 7) >> 3;
+	f->fmt.pix.bytesperline = dev->width * ((dev->format->depth + 7) >> 3);
 	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * dev->height;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.priv = 0;
 
 	return 0;
 }
@@ -1045,10 +1046,11 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.width = width;
 	f->fmt.pix.height = height;
 	f->fmt.pix.pixelformat = fmt->fourcc;
-	f->fmt.pix.bytesperline = (dev->width * fmt->depth + 7) >> 3;
+	f->fmt.pix.bytesperline = dev->width * ((fmt->depth + 7) >> 3);
 	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * height;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.priv = 0;
 
 	return 0;
 }
-- 
1.7.10.4

