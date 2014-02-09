Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57790 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaBIJYL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 04:24:11 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 71/86] rtl2832_sdr: use formats defined in V4L2 API
Date: Sun,  9 Feb 2014 10:49:16 +0200
Message-Id: <1391935771-18670-72-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch new formats V4L2_SDR_FMT_CU8 and V4L2_SDR_FMT_CU16LE as those
are now defined in API.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index c26c084..e89abd8 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -37,10 +37,6 @@
 #include <linux/jiffies.h>
 #include <linux/math64.h>
 
-/* TODO: These should be moved to V4L2 API */
-#define V4L2_PIX_FMT_SDR_U8    v4l2_fourcc('D', 'U', '0', '8')
-#define V4L2_PIX_FMT_SDR_U16LE v4l2_fourcc('D', 'U', '1', '6')
-
 #define MAX_BULK_BUFS            (10)
 #define BULK_BUFFER_SIZE         (128 * 512)
 
@@ -90,11 +86,11 @@ struct rtl2832_sdr_format {
 
 static struct rtl2832_sdr_format formats[] = {
 	{
-		.name		= "8-bit unsigned",
-		.pixelformat	= V4L2_PIX_FMT_SDR_U8,
+		.name		= "IQ U8",
+		.pixelformat	=  V4L2_SDR_FMT_CU8,
 	}, {
-		.name		= "16-bit unsigned little endian",
-		.pixelformat	= V4L2_PIX_FMT_SDR_U16LE,
+		.name		= "IQ U16LE (emulated)",
+		.pixelformat	= V4L2_SDR_FMT_CU16LE,
 	},
 };
 
@@ -346,11 +342,11 @@ static unsigned int rtl2832_sdr_convert_stream(struct rtl2832_sdr_state *s,
 {
 	unsigned int dst_len;
 
-	if (s->pixelformat == V4L2_PIX_FMT_SDR_U8) {
+	if (s->pixelformat ==  V4L2_SDR_FMT_CU8) {
 		/* native stream, no need to convert */
 		memcpy(dst, src, src_len);
 		dst_len = src_len;
-	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_U16LE) {
+	} else if (s->pixelformat == V4L2_SDR_FMT_CU16LE) {
 		/* convert u8 to u16 */
 		unsigned int i;
 		u16 *u16dst = dst;
@@ -1410,7 +1406,7 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	s->i2c = i2c;
 	s->cfg = cfg;
 	s->f_adc = bands_adc[0].rangelow;
-	s->pixelformat = V4L2_PIX_FMT_SDR_U8;
+	s->pixelformat =  V4L2_SDR_FMT_CU8;
 
 	mutex_init(&s->v4l2_lock);
 	mutex_init(&s->vb_queue_lock);
-- 
1.8.5.3

