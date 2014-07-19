Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51164 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759581AbaGSAwc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 20:52:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/3] msi2500: fill FMT buffer size
Date: Sat, 19 Jul 2014 03:52:12 +0300
Message-Id: <1405731133-12187-2-git-send-email-crope@iki.fi>
In-Reply-To: <1405731133-12187-1-git-send-email-crope@iki.fi>
References: <1405731133-12187-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fill FMT buffer size field in order to inform app which will be
used streaming buffer size. Currently driver doesn't allow buffer
size value proposed by application.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/msi2500/msi2500.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index a66a07f..666348c 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -74,6 +74,7 @@ static const struct v4l2_frequency_band bands[] = {
 struct msi3101_format {
 	char	*name;
 	u32	pixelformat;
+	u32	buffersize;
 };
 
 /* format descriptions for capture and preview */
@@ -81,6 +82,7 @@ static struct msi3101_format formats[] = {
 	{
 		.name		= "Complex S8",
 		.pixelformat	= V4L2_SDR_FMT_CS8,
+		.buffersize	= 3 * 1008,
 #if 0
 	}, {
 		.name		= "10+2-bit signed",
@@ -92,12 +94,15 @@ static struct msi3101_format formats[] = {
 	}, {
 		.name		= "Complex S14LE",
 		.pixelformat	= V4L2_SDR_FMT_CS14LE,
+		.buffersize	= 3 * 1008,
 	}, {
 		.name		= "Complex U8 (emulated)",
 		.pixelformat	= V4L2_SDR_FMT_CU8,
+		.buffersize	= 3 * 1008,
 	}, {
 		.name		= "Complex U16LE (emulated)",
 		.pixelformat	=  V4L2_SDR_FMT_CU16LE,
+		.buffersize	= 3 * 1008,
 	},
 };
 
@@ -129,6 +134,7 @@ struct msi3101_state {
 
 	unsigned int f_adc;
 	u32 pixelformat;
+	u32 buffersize;
 	unsigned int num_formats;
 
 	unsigned int isoc_errors; /* number of contiguous ISOC errors */
@@ -836,13 +842,7 @@ static int msi3101_queue_setup(struct vb2_queue *vq,
 	/* Absolute min and max number of buffers available for mmap() */
 	*nbuffers = clamp_t(unsigned int, *nbuffers, 8, 32);
 	*nplanes = 1;
-	/*
-	 *   3, wMaxPacketSize 3x 1024 bytes
-	 * 504, max IQ sample pairs per 1024 frame
-	 *   2, two samples, I and Q
-	 *   2, 16-bit is enough for single sample
-	 */
-	sizes[0] = PAGE_ALIGN(3 * 504 * 2 * 2);
+	sizes[0] = PAGE_ALIGN(s->buffersize);
 	dev_dbg(&s->udev->dev, "%s: nbuffers=%d sizes[0]=%d\n",
 			__func__, *nbuffers, sizes[0]);
 	return 0;
@@ -1134,8 +1134,9 @@ static int msi3101_g_fmt_sdr_cap(struct file *file, void *priv,
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
 			(char *)&s->pixelformat);
 
-	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	f->fmt.sdr.pixelformat = s->pixelformat;
+	f->fmt.sdr.buffersize = s->buffersize;
+	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 
 	return 0;
 }
@@ -1155,13 +1156,17 @@ static int msi3101_s_fmt_sdr_cap(struct file *file, void *priv,
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	for (i = 0; i < s->num_formats; i++) {
 		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
-			s->pixelformat = f->fmt.sdr.pixelformat;
+			s->pixelformat = formats[i].pixelformat;
+			s->buffersize = formats[i].buffersize;
+			f->fmt.sdr.buffersize = formats[i].buffersize;
 			return 0;
 		}
 	}
 
-	f->fmt.sdr.pixelformat = formats[0].pixelformat;
 	s->pixelformat = formats[0].pixelformat;
+	s->buffersize = formats[0].buffersize;
+	f->fmt.sdr.pixelformat = formats[0].pixelformat;
+	f->fmt.sdr.buffersize = formats[0].buffersize;
 
 	return 0;
 }
@@ -1176,11 +1181,14 @@ static int msi3101_try_fmt_sdr_cap(struct file *file, void *priv,
 
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	for (i = 0; i < s->num_formats; i++) {
-		if (formats[i].pixelformat == f->fmt.sdr.pixelformat)
+		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
+			f->fmt.sdr.buffersize = formats[i].buffersize;
 			return 0;
+		}
 	}
 
 	f->fmt.sdr.pixelformat = formats[0].pixelformat;
+	f->fmt.sdr.buffersize = formats[0].buffersize;
 
 	return 0;
 }
@@ -1402,6 +1410,7 @@ static int msi3101_probe(struct usb_interface *intf,
 	s->udev = udev;
 	s->f_adc = bands[0].rangelow;
 	s->pixelformat = formats[0].pixelformat;
+	s->buffersize = formats[0].buffersize;
 	s->num_formats = NUM_FORMATS;
 	if (msi3101_emulated_fmt == false)
 		s->num_formats -= 2;
-- 
1.9.3

