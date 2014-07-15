Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33545 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938AbaGOBJo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 21:09:44 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 13/18] msi2500: change supported formats
Date: Tue, 15 Jul 2014 04:09:16 +0300
Message-Id: <1405386561-30450-13-git-send-email-crope@iki.fi>
In-Reply-To: <1405386561-30450-1-git-send-email-crope@iki.fi>
References: <1405386561-30450-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable two native formats, V4L2_SDR_FMT_CS8 and V4L2_SDR_FMT_CS14LE.
Move emulated formats behind module parameter.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/msi2500/msi2500.c | 44 +++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 08d0d09..6ed121b 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -34,6 +34,10 @@
 #include <media/videobuf2-vmalloc.h>
 #include <linux/spi/spi.h>
 
+static bool msi3101_emulated_fmt;
+module_param_named(emulated_formats, msi3101_emulated_fmt, bool, 0644);
+MODULE_PARM_DESC(emulated_formats, "enable emulated formats (disappears in future)");
+
 /*
  *   iConfiguration          0
  *     bInterfaceNumber        0
@@ -52,9 +56,7 @@
 #define MAX_ISOC_ERRORS         20
 
 /* TODO: These should be moved to V4L2 API */
-#define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
 #define V4L2_PIX_FMT_SDR_S12    v4l2_fourcc('D', 'S', '1', '2') /* signed 12-bit */
-#define V4L2_PIX_FMT_SDR_S14    v4l2_fourcc('D', 'S', '1', '4') /* signed 14-bit */
 #define V4L2_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4') /* Mirics MSi2500 format 384 */
 
 static const struct v4l2_frequency_band bands[] = {
@@ -77,25 +79,25 @@ struct msi3101_format {
 /* format descriptions for capture and preview */
 static struct msi3101_format formats[] = {
 	{
-		.name		= "IQ U8",
-		.pixelformat	= V4L2_SDR_FMT_CU8,
-	}, {
-		.name		= "IQ U16LE",
-		.pixelformat	=  V4L2_SDR_FMT_CU16LE,
+		.name		= "Complex S8",
+		.pixelformat	= V4L2_SDR_FMT_CS8,
 #if 0
 	}, {
-		.name		= "8-bit signed",
-		.pixelformat	= V4L2_PIX_FMT_SDR_S8,
-	}, {
 		.name		= "10+2-bit signed",
 		.pixelformat	= V4L2_PIX_FMT_SDR_MSI2500_384,
 	}, {
 		.name		= "12-bit signed",
 		.pixelformat	= V4L2_PIX_FMT_SDR_S12,
-	}, {
-		.name		= "14-bit signed",
-		.pixelformat	= V4L2_PIX_FMT_SDR_S14,
 #endif
+	}, {
+		.name		= "Complex S14LE",
+		.pixelformat	= V4L2_SDR_FMT_CS14LE,
+	}, {
+		.name		= "Complex U8 (emulated)",
+		.pixelformat	= V4L2_SDR_FMT_CU8,
+	}, {
+		.name		= "Complex U16LE (emulated)",
+		.pixelformat	=  V4L2_SDR_FMT_CU16LE,
 	},
 };
 
@@ -127,6 +129,7 @@ struct msi3101_state {
 
 	unsigned int f_adc;
 	u32 pixelformat;
+	unsigned int num_formats;
 
 	unsigned int isoc_errors; /* number of contiguous ISOC errors */
 	unsigned int vb_full; /* vb is full and packets dropped */
@@ -928,7 +931,7 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 		s->convert_stream = msi3101_convert_stream_252_u16;
 		reg7 = 0x00009407;
 		break;
-	case V4L2_PIX_FMT_SDR_S8:
+	case V4L2_SDR_FMT_CS8:
 		s->convert_stream = msi3101_convert_stream_504;
 		reg7 = 0x000c9407;
 		break;
@@ -940,7 +943,7 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 		s->convert_stream = msi3101_convert_stream_336;
 		reg7 = 0x00008507;
 		break;
-	case V4L2_PIX_FMT_SDR_S14:
+	case V4L2_SDR_FMT_CS14LE:
 		s->convert_stream = msi3101_convert_stream_252;
 		reg7 = 0x00009407;
 		break;
@@ -1115,7 +1118,7 @@ static int msi3101_enum_fmt_sdr_cap(struct file *file, void *priv,
 	struct msi3101_state *s = video_drvdata(file);
 	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, f->index);
 
-	if (f->index >= NUM_FORMATS)
+	if (f->index >= s->num_formats)
 		return -EINVAL;
 
 	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
@@ -1150,7 +1153,7 @@ static int msi3101_s_fmt_sdr_cap(struct file *file, void *priv,
 		return -EBUSY;
 
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
-	for (i = 0; i < NUM_FORMATS; i++) {
+	for (i = 0; i < s->num_formats; i++) {
 		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
 			s->pixelformat = f->fmt.sdr.pixelformat;
 			return 0;
@@ -1172,7 +1175,7 @@ static int msi3101_try_fmt_sdr_cap(struct file *file, void *priv,
 			(char *)&f->fmt.sdr.pixelformat);
 
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
-	for (i = 0; i < NUM_FORMATS; i++) {
+	for (i = 0; i < s->num_formats; i++) {
 		if (formats[i].pixelformat == f->fmt.sdr.pixelformat)
 			return 0;
 	}
@@ -1398,7 +1401,10 @@ static int msi3101_probe(struct usb_interface *intf,
 	INIT_LIST_HEAD(&s->queued_bufs);
 	s->udev = udev;
 	s->f_adc = bands[0].rangelow;
-	s->pixelformat = V4L2_SDR_FMT_CU8;
+	s->pixelformat = formats[0].pixelformat;
+	s->num_formats = NUM_FORMATS;
+	if (msi3101_emulated_fmt == false)
+		s->num_formats -= 2;
 
 	/* Init videobuf2 queue structure */
 	s->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
-- 
1.9.3

