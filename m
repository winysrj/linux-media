Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32810 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505Ab2HGCr7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:47:59 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432645vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:47:58 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 12/24] au0828: prevent i2c gate from being kept open while in analog mode
Date: Mon,  6 Aug 2012 22:47:02 -0400
Message-Id: <1344307634-11673-13-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The original implementation of the analog support would use an i2c_gate_ctrl
function when using the digital side of the au8522, but on the analog side
we would always just force the gate open and leave it open all the time.

This can have adverse effects on the xc5000 given the tuner is receiving all
the spurious i2c traffic (a problem which can be exaggerated due to bugs in
the au0828 i2c hardware implementation).

Rework the existing hack to only open/close the gate when actually talking
to the tuner.

This logic might need to be reworked a bit if anybody ever tries to add
support for a board that has the au0828/au8522 but doesn't have digital
support implemented (because the i2c_gate_ctrl callback is being set in
the DVB attach).  However given how few different models are in circulation,
this can be deferred until such a situation arises (if ever).

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/dvb/frontends/au8522_common.c  |   13 +++++++++++++
 drivers/media/dvb/frontends/au8522_decoder.c |    5 -----
 drivers/media/dvb/frontends/au8522_dig.c     |    2 ++
 drivers/media/dvb/frontends/au8522_priv.h    |    1 +
 drivers/media/video/au0828/au0828-video.c    |    6 ++++++
 5 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/frontends/au8522_common.c b/drivers/media/dvb/frontends/au8522_common.c
index 8b4da40..3559ff2 100644
--- a/drivers/media/dvb/frontends/au8522_common.c
+++ b/drivers/media/dvb/frontends/au8522_common.c
@@ -99,6 +99,19 @@ int au8522_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 }
 EXPORT_SYMBOL(au8522_i2c_gate_ctrl);
 
+int au8522_analog_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct au8522_state *state = fe->demodulator_priv;
+
+	dprintk("%s(%d)\n", __func__, enable);
+
+	if (enable)
+		return au8522_writereg(state, 0x106, 1);
+	else
+		return au8522_writereg(state, 0x106, 0);
+}
+EXPORT_SYMBOL(au8522_analog_i2c_gate_ctrl);
+
 /* Reset the demod hardware and reset all of the configuration registers
    to a default state. */
 int au8522_get_state(struct au8522_state **state, struct i2c_adapter *i2c,
diff --git a/drivers/media/dvb/frontends/au8522_decoder.c b/drivers/media/dvb/frontends/au8522_decoder.c
index f2e786b..5243ba6 100644
--- a/drivers/media/dvb/frontends/au8522_decoder.c
+++ b/drivers/media/dvb/frontends/au8522_decoder.c
@@ -659,11 +659,6 @@ static int au8522_s_video_routing(struct v4l2_subdev *sd,
 
 	au8522_reset(sd, 0);
 
-	/* Jam open the i2c gate to the tuner.  We do this here to handle the
-	   case where the user went into digital mode (causing the gate to be
-	   closed), and then came back to analog mode */
-	au8522_writereg(state, 0x106, 1);
-
 	if (input == AU8522_COMPOSITE_CH1) {
 		au8522_setup_cvbs_mode(state);
 	} else if (input == AU8522_SVIDEO_CH13) {
diff --git a/drivers/media/dvb/frontends/au8522_dig.c b/drivers/media/dvb/frontends/au8522_dig.c
index ee8cf81..a68974f 100644
--- a/drivers/media/dvb/frontends/au8522_dig.c
+++ b/drivers/media/dvb/frontends/au8522_dig.c
@@ -777,6 +777,8 @@ struct dvb_frontend *au8522_attach(const struct au8522_config *config,
 	       sizeof(struct dvb_frontend_ops));
 	state->frontend.demodulator_priv = state;
 
+	state->frontend.ops.analog_ops.i2c_gate_ctrl = au8522_analog_i2c_gate_ctrl;
+
 	if (au8522_init(&state->frontend) != 0) {
 		printk(KERN_ERR "%s: Failed to initialize correctly\n",
 			__func__);
diff --git a/drivers/media/dvb/frontends/au8522_priv.h b/drivers/media/dvb/frontends/au8522_priv.h
index 9f44a7b..0529699 100644
--- a/drivers/media/dvb/frontends/au8522_priv.h
+++ b/drivers/media/dvb/frontends/au8522_priv.h
@@ -82,6 +82,7 @@ int au8522_get_state(struct au8522_state **state, struct i2c_adapter *i2c,
 		     u8 client_address);
 void au8522_release_state(struct au8522_state *state);
 int au8522_i2c_gate_ctrl(struct dvb_frontend *fe, int enable);
+int au8522_analog_i2c_gate_ctrl(struct dvb_frontend *fe, int enable);
 int au8522_led_ctrl(struct au8522_state *state, int led);
 
 /* REGISTERS */
diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index f3e6e3f..df92322 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -1541,6 +1541,9 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 
 	dev->ctrl_freq = freq->frequency;
 
+	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
+		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 1);
+
 	if (dev->std_set_in_tuner_core == 0) {
 	  /* If we've never sent the standard in tuner core, do so now.  We
 	     don't do this at device probe because we don't want to incur
@@ -1552,6 +1555,9 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, freq);
 
+	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
+		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 0);
+
 	au0828_analog_stream_reset(dev);
 
 	return 0;
-- 
1.7.1

