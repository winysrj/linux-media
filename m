Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43083 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759500AbaGSAwb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 20:52:31 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 3/3] airspy: fill FMT buffer size
Date: Sat, 19 Jul 2014 03:52:13 +0300
Message-Id: <1405731133-12187-3-git-send-email-crope@iki.fi>
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
 drivers/media/usb/airspy/airspy.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 6cf09ef..b3d5d1a 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -81,13 +81,15 @@ static const struct v4l2_frequency_band bands_rf[] = {
 struct airspy_format {
 	char	*name;
 	u32	pixelformat;
+	u32	buffersize;
 };
 
 /* format descriptions for capture and preview */
 static struct airspy_format formats[] = {
 	{
 		.name		= "Real U12LE",
-		.pixelformat	=  V4L2_SDR_FMT_RU12LE,
+		.pixelformat	= V4L2_SDR_FMT_RU12LE,
+		.buffersize	= BULK_BUFFER_SIZE,
 	},
 };
 
@@ -136,6 +138,7 @@ struct airspy {
 	unsigned int f_adc;
 	unsigned int f_rf;
 	u32 pixelformat;
+	u32 buffersize;
 
 	/* Controls */
 	struct v4l2_ctrl_handler hdl;
@@ -500,7 +503,7 @@ static int airspy_queue_setup(struct vb2_queue *vq,
 	if (vq->num_buffers + *nbuffers < 8)
 		*nbuffers = 8 - vq->num_buffers;
 	*nplanes = 1;
-	sizes[0] = PAGE_ALIGN(BULK_BUFFER_SIZE);
+	sizes[0] = PAGE_ALIGN(s->buffersize);
 
 	dev_dbg(&s->udev->dev, "%s: nbuffers=%d sizes[0]=%d\n",
 			__func__, *nbuffers, sizes[0]);
@@ -636,8 +639,9 @@ static int airspy_g_fmt_sdr_cap(struct file *file, void *priv,
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
 			(char *)&s->pixelformat);
 
-	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	f->fmt.sdr.pixelformat = s->pixelformat;
+	f->fmt.sdr.buffersize = s->buffersize;
+	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 
 	return 0;
 }
@@ -658,13 +662,17 @@ static int airspy_s_fmt_sdr_cap(struct file *file, void *priv,
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	for (i = 0; i < NUM_FORMATS; i++) {
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
@@ -680,11 +688,14 @@ static int airspy_try_fmt_sdr_cap(struct file *file, void *priv,
 
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	for (i = 0; i < NUM_FORMATS; i++) {
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
@@ -1004,7 +1015,8 @@ static int airspy_probe(struct usb_interface *intf,
 	s->udev = udev;
 	s->f_adc = bands[0].rangelow;
 	s->f_rf = bands_rf[0].rangelow;
-	s->pixelformat = V4L2_SDR_FMT_RU12LE;
+	s->pixelformat = formats[0].pixelformat;
+	s->buffersize = formats[0].buffersize;
 
 	/* Detect device */
 	ret = airspy_ctrl_msg(s, CMD_BOARD_ID_READ, 0, 0, &u8tmp, 1);
-- 
1.9.3

