Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44910 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbbKPKVX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:23 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 10/16] [media] tda665x: split set_frequency from set_state
Date: Mon, 16 Nov 2015 08:21:07 -0200
Message-Id: <8de2276acf5032454ef4e49abf1953bc987ccc13.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On tda665x, set_state only sets frequency. As the kABI for set_state
is meant to be used only on special cases, split the function
into two, in order to allow it to be latter used by a DVBv5
cache params logic.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/tda665x.c | 161 ++++++++++++++++++----------------
 1 file changed, 85 insertions(+), 76 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda665x.c b/drivers/media/dvb-frontends/tda665x.c
index 63cc12378d9a..9c892533e6a7 100644
--- a/drivers/media/dvb-frontends/tda665x.c
+++ b/drivers/media/dvb-frontends/tda665x.c
@@ -111,9 +111,8 @@ exit:
 	return err;
 }
 
-static int tda665x_set_state(struct dvb_frontend *fe,
-			     enum tuner_param param,
-			     struct tuner_state *tstate)
+static int tda665x_set_frequency(struct dvb_frontend *fe,
+				 u32 new_frequency)
 {
 	struct tda665x_state *state = fe->tuner_priv;
 	const struct tda665x_config *config = state->config;
@@ -121,88 +120,98 @@ static int tda665x_set_state(struct dvb_frontend *fe,
 	u8 buf[4];
 	int err = 0;
 
-	if (param & DVBFE_TUNER_FREQUENCY) {
-
-		frequency = tstate->frequency;
-		if ((frequency < config->frequency_max) || (frequency > config->frequency_min)) {
-			printk(KERN_ERR "%s: Frequency beyond limits, frequency=%d\n", __func__, frequency);
-			return -EINVAL;
-		}
-
-		frequency += config->frequency_offst;
-		frequency *= config->ref_multiplier;
-		frequency += config->ref_divider >> 1;
-		frequency /= config->ref_divider;
-
-		buf[0] = (u8) ((frequency & 0x7f00) >> 8);
-		buf[1] = (u8) (frequency & 0x00ff) >> 0;
-		buf[2] = 0x80 | 0x40 | 0x02;
-		buf[3] = 0x00;
-
-		/* restore frequency */
-		frequency = tstate->frequency;
-
-		if (frequency < 153000000) {
-			/* VHF-L */
-			buf[3] |= 0x01; /* fc, Low Band, 47 - 153 MHz */
-			if (frequency < 68000000)
-				buf[3] |= 0x40; /* 83uA */
-			if (frequency < 1040000000)
-				buf[3] |= 0x60; /* 122uA */
-			if (frequency < 1250000000)
-				buf[3] |= 0x80; /* 163uA */
-			else
-				buf[3] |= 0xa0; /* 254uA */
-		} else if (frequency < 438000000) {
-			/* VHF-H */
-			buf[3] |= 0x02; /* fc, Mid Band, 153 - 438 MHz */
-			if (frequency < 230000000)
-				buf[3] |= 0x40;
-			if (frequency < 300000000)
-				buf[3] |= 0x60;
-			else
-				buf[3] |= 0x80;
-		} else {
-			/* UHF */
-			buf[3] |= 0x04; /* fc, High Band, 438 - 862 MHz */
-			if (frequency < 470000000)
-				buf[3] |= 0x60;
-			if (frequency < 526000000)
-				buf[3] |= 0x80;
-			else
-				buf[3] |= 0xa0;
-		}
-
-		/* Set params */
-		err = tda665x_write(state, buf, 5);
-		if (err < 0)
-			goto exit;
-
-		/* sleep for some time */
-		printk(KERN_DEBUG "%s: Waiting to Phase LOCK\n", __func__);
-		msleep(20);
-		/* check status */
-		err = tda665x_get_status(fe, &status);
-		if (err < 0)
-			goto exit;
-
-		if (status == 1) {
-			printk(KERN_DEBUG "%s: Tuner Phase locked: status=%d\n", __func__, status);
-			state->frequency = frequency; /* cache successful state */
-		} else {
-			printk(KERN_ERR "%s: No Phase lock: status=%d\n", __func__, status);
-		}
-	} else {
-		printk(KERN_ERR "%s: Unknown parameter (param=%d)\n", __func__, param);
+	if ((new_frequency < config->frequency_max)
+	    || (new_frequency > config->frequency_min)) {
+		printk(KERN_ERR "%s: Frequency beyond limits, frequency=%d\n",
+		       __func__, new_frequency);
 		return -EINVAL;
 	}
 
+	frequency = new_frequency;
+
+	frequency += config->frequency_offst;
+	frequency *= config->ref_multiplier;
+	frequency += config->ref_divider >> 1;
+	frequency /= config->ref_divider;
+
+	buf[0] = (u8) ((frequency & 0x7f00) >> 8);
+	buf[1] = (u8) (frequency & 0x00ff) >> 0;
+	buf[2] = 0x80 | 0x40 | 0x02;
+	buf[3] = 0x00;
+
+	/* restore frequency */
+	frequency = new_frequency;
+
+	if (frequency < 153000000) {
+		/* VHF-L */
+		buf[3] |= 0x01; /* fc, Low Band, 47 - 153 MHz */
+		if (frequency < 68000000)
+			buf[3] |= 0x40; /* 83uA */
+		if (frequency < 1040000000)
+			buf[3] |= 0x60; /* 122uA */
+		if (frequency < 1250000000)
+			buf[3] |= 0x80; /* 163uA */
+		else
+			buf[3] |= 0xa0; /* 254uA */
+	} else if (frequency < 438000000) {
+		/* VHF-H */
+		buf[3] |= 0x02; /* fc, Mid Band, 153 - 438 MHz */
+		if (frequency < 230000000)
+			buf[3] |= 0x40;
+		if (frequency < 300000000)
+			buf[3] |= 0x60;
+		else
+			buf[3] |= 0x80;
+	} else {
+		/* UHF */
+		buf[3] |= 0x04; /* fc, High Band, 438 - 862 MHz */
+		if (frequency < 470000000)
+			buf[3] |= 0x60;
+		if (frequency < 526000000)
+			buf[3] |= 0x80;
+		else
+			buf[3] |= 0xa0;
+	}
+
+	/* Set params */
+	err = tda665x_write(state, buf, 5);
+	if (err < 0)
+		goto exit;
+
+	/* sleep for some time */
+	printk(KERN_DEBUG "%s: Waiting to Phase LOCK\n", __func__);
+	msleep(20);
+	/* check status */
+	err = tda665x_get_status(fe, &status);
+	if (err < 0)
+		goto exit;
+
+	if (status == 1) {
+		printk(KERN_DEBUG "%s: Tuner Phase locked: status=%d\n",
+		       __func__, status);
+		state->frequency = frequency; /* cache successful state */
+	} else {
+		printk(KERN_ERR "%s: No Phase lock: status=%d\n",
+		       __func__, status);
+	}
+
 	return 0;
 exit:
 	printk(KERN_ERR "%s: I/O Error\n", __func__);
 	return err;
 }
 
+static int tda665x_set_state(struct dvb_frontend *fe,
+			     enum tuner_param param,
+			     struct tuner_state *tstate)
+{
+	if (param & DVBFE_TUNER_FREQUENCY)
+		return  tda665x_set_frequency(fe, tstate->frequency);
+
+	printk(KERN_ERR "%s: Unknown parameter (param=%d)\n", __func__, param);
+	return -EINVAL;
+}
+
 static int tda665x_release(struct dvb_frontend *fe)
 {
 	struct tda665x_state *state = fe->tuner_priv;
-- 
2.5.0

