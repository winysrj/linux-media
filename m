Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:49445 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbaCXTdF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:05 -0400
Received: by mail-ee0-f44.google.com with SMTP id e49so4812297eek.17
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:33:04 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 11/19] em28xx: move struct em28xx_fmt *format from struct em28xx to struct v4l2
Date: Mon, 24 Mar 2014 20:33:17 +0100
Message-Id: <1395689605-2705-12-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 14 +++++++-------
 drivers/media/usb/em28xx/em28xx.h       |  3 +--
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 821d182..c316147 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -222,7 +222,7 @@ static int em28xx_set_outfmt(struct em28xx *dev)
 	u8 fmt, vinctrl;
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 
-	fmt = dev->format->reg;
+	fmt = v4l2->format->reg;
 	if (!dev->is_em25xx)
 		fmt |= 0x20;
 	/*
@@ -877,7 +877,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 		size = fmt->fmt.pix.sizeimage;
 	else
 		size =
-		     (v4l2->width * v4l2->height * dev->format->depth + 7) >> 3;
+		    (v4l2->width * v4l2->height * v4l2->format->depth + 7) >> 3;
 
 	if (size == 0)
 		return -EINVAL;
@@ -901,7 +901,7 @@ buffer_prepare(struct vb2_buffer *vb)
 
 	em28xx_videodbg("%s, field=%d\n", __func__, vb->v4l2_buf.field);
 
-	size = (v4l2->width * v4l2->height * dev->format->depth + 7) >> 3;
+	size = (v4l2->width * v4l2->height * v4l2->format->depth + 7) >> 3;
 
 	if (vb2_plane_size(vb, 0) < size) {
 		em28xx_videodbg("%s data will not fit into plane (%lu < %lu)\n",
@@ -1228,8 +1228,8 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 
 	f->fmt.pix.width = v4l2->width;
 	f->fmt.pix.height = v4l2->height;
-	f->fmt.pix.pixelformat = dev->format->fourcc;
-	f->fmt.pix.bytesperline = (v4l2->width * dev->format->depth + 7) >> 3;
+	f->fmt.pix.pixelformat = v4l2->format->fourcc;
+	f->fmt.pix.bytesperline = (v4l2->width * v4l2->format->depth + 7) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * v4l2->height;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
@@ -1319,7 +1319,7 @@ static int em28xx_set_video_format(struct em28xx *dev, unsigned int fourcc,
 	if (!fmt)
 		return -EINVAL;
 
-	dev->format = fmt;
+	v4l2->format = fmt;
 	v4l2->width  = width;
 	v4l2->height = height;
 
@@ -2433,7 +2433,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	dev->interlaced = EM28XX_INTERLACED_DEFAULT;
 
 	/* Analog specific initialization */
-	dev->format = &format[0];
+	v4l2->format = &format[0];
 
 	maxw = norm_maxw(dev);
 	/* MaxPacketSize for em2800 is too small to capture at full resolution
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index f0b3b8c..dd93a37 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -518,6 +518,7 @@ struct em28xx_v4l2 {
 	u8 vinmode;
 	u8 vinctl;
 
+	struct em28xx_fmt *format;
 	v4l2_std_id norm;	/* selected tv norm */
 
 	/* Frame properties */
@@ -606,8 +607,6 @@ struct em28xx {
 	struct work_struct wq_trigger;	/* Trigger to start/stop audio for alsa module */
 	atomic_t       stream_started;	/* stream should be running if true */
 
-	struct em28xx_fmt *format;
-
 	/* Some older em28xx chips needs a waiting time after writing */
 	unsigned int wait_after_write;
 
-- 
1.8.4.5

