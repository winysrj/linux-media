Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:51435 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbZJWKtX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 06:49:23 -0400
Message-ID: <4AE18C9E.9090409@gmail.com>
Date: Fri, 23 Oct 2009 12:59:42 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] v4l: Cleanup redundant tests on unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The variables are unsigned so the test `>= 0' is always true,
the `< 0' test always fails. In these cases the other part of
the test catches wrapped values.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/common/tuners/tda9887.c b/drivers/media/common/tuners/tda9887.c
index 544cdbe..a71c100 100644
--- a/drivers/media/common/tuners/tda9887.c
+++ b/drivers/media/common/tuners/tda9887.c
@@ -463,7 +463,7 @@ static int tda9887_set_insmod(struct dvb_frontend *fe)
 			buf[1] &= ~cQSS;
 	}
 
-	if (adjust >= 0x00 && adjust < 0x20) {
+	if (adjust < 0x20) {
 		buf[2] &= ~cTopMask;
 		buf[2] |= adjust;
 	}
diff --git a/drivers/media/dvb/siano/smscoreapi.c b/drivers/media/dvb/siano/smscoreapi.c
index fa6a623..ca758bc 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -1373,7 +1373,7 @@ static int GetGpioPinParams(u32 PinNum, u32 *pTranslatedPinNum,
 
 	*pGroupCfg = 1;
 
-	if (PinNum >= 0 && PinNum <= 1)	{
+	if (PinNum <= 1)	{
 		*pTranslatedPinNum = 0;
 		*pGroupNum = 9;
 		*pGroupCfg = 2;
diff --git a/drivers/media/video/bt819.c b/drivers/media/video/bt819.c
index f9330e3..5bb0f9e 100644
--- a/drivers/media/video/bt819.c
+++ b/drivers/media/video/bt819.c
@@ -299,7 +299,7 @@ static int bt819_s_routing(struct v4l2_subdev *sd,
 
 	v4l2_dbg(1, debug, sd, "set input %x\n", input);
 
-	if (input < 0 || input > 7)
+	if (input > 7)
 		return -EINVAL;
 
 	if (sd->v4l2_dev == NULL || sd->v4l2_dev->notify == NULL)
diff --git a/drivers/media/video/hexium_gemini.c b/drivers/media/video/hexium_gemini.c
index 71c2114..60d992e 100644
--- a/drivers/media/video/hexium_gemini.c
+++ b/drivers/media/video/hexium_gemini.c
@@ -251,7 +251,7 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
 
 	DEB_EE(("VIDIOC_S_INPUT %d.\n", input));
 
-	if (input < 0 || input >= HEXIUM_INPUTS)
+	if (input >= HEXIUM_INPUTS)
 		return -EINVAL;
 
 	hexium->cur_input = input;
diff --git a/drivers/media/video/hexium_orion.c b/drivers/media/video/hexium_orion.c
index 39d65ca..938a1f8 100644
--- a/drivers/media/video/hexium_orion.c
+++ b/drivers/media/video/hexium_orion.c
@@ -350,7 +350,7 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct hexium *hexium = (struct hexium *) dev->ext_priv;
 
-	if (input < 0 || input >= HEXIUM_INPUTS)
+	if (input >= HEXIUM_INPUTS)
 		return -EINVAL;
 
 	hexium->cur_input = input;
diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
index 3454070..c1fc6dc 100644
--- a/drivers/media/video/mxb.c
+++ b/drivers/media/video/mxb.c
@@ -478,7 +478,7 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
 
 	DEB_EE(("VIDIOC_S_INPUT %d.\n", input));
 
-	if (input < 0 || input >= MXB_INPUTS)
+	if (input >= MXB_INPUTS)
 		return -EINVAL;
 
 	mxb->cur_input = input;
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 9e3262c..5f5d710 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -1963,7 +1963,7 @@ static int save_frame(struct s2255_dev *dev, struct s2255_pipeinfo *pipe_info)
 				if (pdword[1] >= MAX_CHANNELS)
 					break;
 				cc = G_chnmap[pdword[1]];
-				if (!(cc >= 0 && cc < MAX_CHANNELS))
+				if (cc >= MAX_CHANNELS)
 					break;
 				switch (pdword[2]) {
 				case S2255_RESPONSE_SETMODE:
diff --git a/drivers/media/video/saa7110.c b/drivers/media/video/saa7110.c
index 5c24c99..3bca744 100644
--- a/drivers/media/video/saa7110.c
+++ b/drivers/media/video/saa7110.c
@@ -304,7 +304,7 @@ static int saa7110_s_routing(struct v4l2_subdev *sd,
 {
 	struct saa7110 *decoder = to_saa7110(sd);
 
-	if (input < 0 || input >= SAA7110_MAX_INPUT) {
+	if (input >= SAA7110_MAX_INPUT) {
 		v4l2_dbg(1, debug, sd, "input=%d not available\n", input);
 		return -EINVAL;
 	}
diff --git a/drivers/media/video/saa717x.c b/drivers/media/video/saa717x.c
index b15c409..ad6cd37 100644
--- a/drivers/media/video/saa717x.c
+++ b/drivers/media/video/saa717x.c
@@ -1115,7 +1115,7 @@ static int saa717x_s_video_routing(struct v4l2_subdev *sd,
 	v4l2_dbg(1, debug, sd, "decoder set input (%d)\n", input);
 	/* inputs from 0-9 are available*/
 	/* saa717x have mode0-mode9 but mode5 is reserved. */
-	if (input < 0 || input > 9 || input == 5)
+	if (input > 9 || input == 5)
 		return -EINVAL;
 
 	if (decoder->input != input) {
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index aba92e2..00830ee 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -328,7 +328,7 @@ static void set_type(struct i2c_client *c, unsigned int type,
 
 	t->type = type;
 	/* prevent invalid config values */
-	t->config = ((new_config >= 0) && (new_config < 256)) ? new_config : 0;
+	t->config = new_config < 256 ? new_config : 0;
 	if (tuner_callback != NULL) {
 		tuner_dbg("defining GPIO callback\n");
 		t->fe.callback = tuner_callback;
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index a2a50d6..c07b0ac 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -601,7 +601,7 @@ static int vidioc_s_input (struct file *file, void *priv, unsigned int input)
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
 
-	if ((input >= usbvision->video_inputs) || (input < 0) )
+	if (input >= usbvision->video_inputs)
 		return -EINVAL;
 
 	mutex_lock(&usbvision->lock);
diff --git a/drivers/media/video/vpx3220.c b/drivers/media/video/vpx3220.c
index 97e0ce2..33205d7 100644
--- a/drivers/media/video/vpx3220.c
+++ b/drivers/media/video/vpx3220.c
@@ -391,7 +391,7 @@ static int vpx3220_s_routing(struct v4l2_subdev *sd,
 		{0x0e, 1}
 	};
 
-	if (input < 0 || input > 2)
+	if (input > 2)
 		return -EINVAL;
 
 	v4l2_dbg(1, debug, sd, "input switched to %s\n", inputs[input]);
diff --git a/drivers/media/video/zoran/zoran_driver.c b/drivers/media/video/zoran/zoran_driver.c
index 47137de..e9f72ca 100644
--- a/drivers/media/video/zoran/zoran_driver.c
+++ b/drivers/media/video/zoran/zoran_driver.c
@@ -2764,7 +2764,7 @@ static int zoran_enum_input(struct file *file, void *__fh,
 	struct zoran_fh *fh = __fh;
 	struct zoran *zr = fh->zr;
 
-	if (inp->index < 0 || inp->index >= zr->card.inputs)
+	if (inp->index >= zr->card.inputs)
 		return -EINVAL;
 	else {
 		int id = inp->index;
