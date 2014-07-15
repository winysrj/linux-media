Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35519 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbaGOBJp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 21:09:45 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 16/18] rtl2832_sdr: put complex U16 format behind module parameter
Date: Tue, 15 Jul 2014 04:09:19 +0300
Message-Id: <1405386561-30450-16-git-send-email-crope@iki.fi>
In-Reply-To: <1405386561-30450-1-git-send-email-crope@iki.fi>
References: <1405386561-30450-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move emulated format behind module parameter as those are not
supported. Format conversions will be on library eventually.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 093df6b..06a66eb 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -35,6 +35,10 @@
 #include <linux/jiffies.h>
 #include <linux/math64.h>
 
+static bool rtl2832_sdr_emulated_fmt;
+module_param_named(emulated_formats, rtl2832_sdr_emulated_fmt, bool, 0644);
+MODULE_PARM_DESC(emulated_formats, "enable emulated formats (disappears in future)");
+
 #define MAX_BULK_BUFS            (10)
 #define BULK_BUFFER_SIZE         (128 * 512)
 
@@ -84,10 +88,10 @@ struct rtl2832_sdr_format {
 
 static struct rtl2832_sdr_format formats[] = {
 	{
-		.name		= "IQ U8",
+		.name		= "Complex U8",
 		.pixelformat	=  V4L2_SDR_FMT_CU8,
 	}, {
-		.name		= "IQ U16LE (emulated)",
+		.name		= "Complex U16LE (emulated)",
 		.pixelformat	= V4L2_SDR_FMT_CU16LE,
 	},
 };
@@ -139,6 +143,7 @@ struct rtl2832_sdr_state {
 
 	unsigned int f_adc, f_tuner;
 	u32 pixelformat;
+	unsigned int num_formats;
 
 	/* Controls */
 	struct v4l2_ctrl_handler hdl;
@@ -1195,7 +1200,7 @@ static int rtl2832_sdr_enum_fmt_sdr_cap(struct file *file, void *priv,
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
-	if (f->index >= NUM_FORMATS)
+	if (f->index >= s->num_formats)
 		return -EINVAL;
 
 	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
@@ -1229,7 +1234,7 @@ static int rtl2832_sdr_s_fmt_sdr_cap(struct file *file, void *priv,
 		return -EBUSY;
 
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
-	for (i = 0; i < NUM_FORMATS; i++) {
+	for (i = 0; i < s->num_formats; i++) {
 		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
 			s->pixelformat = f->fmt.sdr.pixelformat;
 			return 0;
@@ -1251,7 +1256,7 @@ static int rtl2832_sdr_try_fmt_sdr_cap(struct file *file, void *priv,
 			(char *)&f->fmt.sdr.pixelformat);
 
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
-	for (i = 0; i < NUM_FORMATS; i++) {
+	for (i = 0; i < s->num_formats; i++) {
 		if (formats[i].pixelformat == f->fmt.sdr.pixelformat)
 			return 0;
 	}
@@ -1391,6 +1396,9 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	s->f_adc = bands_adc[0].rangelow;
 	s->f_tuner = bands_fm[0].rangelow;
 	s->pixelformat =  V4L2_SDR_FMT_CU8;
+	s->num_formats = NUM_FORMATS;
+	if (rtl2832_sdr_emulated_fmt == false)
+		s->num_formats -= 1;
 
 	mutex_init(&s->v4l2_lock);
 	mutex_init(&s->vb_queue_lock);
-- 
1.9.3

