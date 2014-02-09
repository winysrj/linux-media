Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56504 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaBIJ2S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 04:28:18 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 70/86] msi3101: use formats defined in V4L2 API
Date: Sun,  9 Feb 2014 10:49:15 +0200
Message-Id: <1391935771-18670-71-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch new formats V4L2_SDR_FMT_CU8 and V4L2_SDR_FMT_CU16LE as those
are now defined in API.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 6159d88..f996220 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -52,8 +52,6 @@
 #define MAX_ISOC_ERRORS         20
 
 /* TODO: These should be moved to V4L2 API */
-#define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
-#define V4L2_PIX_FMT_SDR_U16LE  v4l2_fourcc('D', 'U', '1', '6') /* unsigned 16-bit LE */
 #define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
 #define V4L2_PIX_FMT_SDR_S12    v4l2_fourcc('D', 'S', '1', '2') /* signed 12-bit */
 #define V4L2_PIX_FMT_SDR_S14    v4l2_fourcc('D', 'S', '1', '4') /* signed 14-bit */
@@ -97,11 +95,11 @@ struct msi3101_format {
 /* format descriptions for capture and preview */
 static struct msi3101_format formats[] = {
 	{
-		.name		= "8-bit unsigned",
-		.pixelformat	= V4L2_PIX_FMT_SDR_U8,
+		.name		= "IQ U8",
+		.pixelformat	= V4L2_SDR_FMT_CU8,
 	}, {
-		.name		= "16-bit unsigned little endian",
-		.pixelformat	= V4L2_PIX_FMT_SDR_U16LE,
+		.name		= "IQ U16LE",
+		.pixelformat	=  V4L2_SDR_FMT_CU16LE,
 #if 0
 	}, {
 		.name		= "8-bit signed",
@@ -941,11 +939,11 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 
 	/* select stream format */
 	switch (s->pixelformat) {
-	case V4L2_PIX_FMT_SDR_U8:
+	case V4L2_SDR_FMT_CU8:
 		s->convert_stream = msi3101_convert_stream_504_u8;
 		reg7 = 0x000c9407;
 		break;
-	case V4L2_PIX_FMT_SDR_U16LE:
+	case  V4L2_SDR_FMT_CU16LE:
 		s->convert_stream = msi3101_convert_stream_252_u16;
 		reg7 = 0x00009407;
 		break;
@@ -1417,7 +1415,7 @@ static int msi3101_probe(struct usb_interface *intf,
 	INIT_LIST_HEAD(&s->queued_bufs);
 	s->udev = udev;
 	s->f_adc = bands_adc[0].rangelow;
-	s->pixelformat = V4L2_PIX_FMT_SDR_U8;
+	s->pixelformat = V4L2_SDR_FMT_CU8;
 
 	/* Init videobuf2 queue structure */
 	s->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
-- 
1.8.5.3

