Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36875 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417AbaAGE34 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 23:29:56 -0500
Received: by mail-pd0-f173.google.com with SMTP id p10so18972373pdj.4
        for <linux-media@vger.kernel.org>; Mon, 06 Jan 2014 20:29:56 -0800 (PST)
From: Tim Mester <ttmesterr@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Tim Mester <tmester@ieee.org>
Subject: [PATCH 3/3] au8522, au0828: Added demodulator reset
Date: Mon,  6 Jan 2014 21:29:26 -0700
Message-Id: <1389068966-14594-3-git-send-email-tmester@ieee.org>
In-Reply-To: <1389068966-14594-1-git-send-email-tmester@ieee.org>
References: <1389068966-14594-1-git-send-email-tmester@ieee.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The demodulator can get in a state in ATSC mode where just
restarting the feed alone does not correct the corrupted stream.  The
demodulator reset in addition to the feed restart seems to correct
the condition.

The au8522 driver has been modified so that when set_frontend() is
called with the same frequency and modulation mode, the demodulator
will be reset.  The au0282 drives uses this feature when it attempts
to restart the feed.

Signed-off-by: Tim Mester <tmester@ieee.org>
---
 linux/drivers/media/dvb-frontends/au8522_dig.c | 38 +++++++++++++++++++++++++-
 linux/drivers/media/usb/au0828/au0828-dvb.c    |  8 ++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/linux/drivers/media/dvb-frontends/au8522_dig.c b/linux/drivers/media/dvb-frontends/au8522_dig.c
index a68974f..821cc70 100644
--- a/linux/drivers/media/dvb-frontends/au8522_dig.c
+++ b/linux/drivers/media/dvb-frontends/au8522_dig.c
@@ -469,6 +469,38 @@ static struct {
 	{ 0x8526, 0x01 },
 };
 
+/*
+ * Reset the demodulator.  Currently this only does something if
+ * configured in ATSC mode.  This reset is needed in marginal signal
+ * levels when the feed (in MPEG-TS format) is correupted.
+ *
+ */
+
+static int au8522_reset_demodulator(struct dvb_frontend *fe)
+{
+	struct au8522_state *state = fe->demodulator_priv;
+
+	switch (state->current_modulation) {
+	case VSB_8:
+		dprintk("%s() VSB_8\n", __func__);
+		au8522_writereg(state, 0x80a4, 0);
+		au8522_writereg(state, 0x80a5, 0);
+		au8522_writereg(state, 0x80a4, 0xe8);
+		au8522_writereg(state, 0x80a5, 0x40);
+		break;
+	case QAM_64:
+	case QAM_256:
+		dprintk("%s() QAM 64/256\n", __func__);
+		break;
+	default:
+		dprintk("%s() Invalid modulation\n", __func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+
 static int au8522_enable_modulation(struct dvb_frontend *fe,
 				    fe_modulation_t m)
 {
@@ -522,8 +554,12 @@ static int au8522_set_frontend(struct dvb_frontend *fe)
 	dprintk("%s(frequency=%d)\n", __func__, c->frequency);
 
 	if ((state->current_frequency == c->frequency) &&
-	    (state->current_modulation == c->modulation))
+	    (state->current_modulation == c->modulation)) {
+
+		au8522_reset_demodulator(fe);
+		msleep(100);
 		return 0;
+	}
 
 	if (fe->ops.tuner_ops.set_params) {
 		if (fe->ops.i2c_gate_ctrl)
diff --git a/linux/drivers/media/usb/au0828/au0828-dvb.c b/linux/drivers/media/usb/au0828/au0828-dvb.c
index 1673c88..483c587 100644
--- a/linux/drivers/media/usb/au0828/au0828-dvb.c
+++ b/linux/drivers/media/usb/au0828/au0828-dvb.c
@@ -330,6 +330,14 @@ static void au0828_restart_dvb_streaming(struct work_struct *work)
 	stop_urb_transfer(dev);
 	au0828_stop_transport(dev, 1);
 
+	/*
+	 * In ATSC mode, we also need to reset the demodulator in lower signal
+	 * level cases to help realign the data stream.
+	 */
+
+	if (dvb->frontend->ops.set_frontend)
+		dvb->frontend->ops.set_frontend(dvb->frontend);
+
 	/* Start transport */
 	au0828_start_transport(dev);
 	start_urb_transfer(dev);
-- 
1.8.1.4

