Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3767 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab3BJMud (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 07:50:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 19/19] bttv: do not switch to the radio tuner unless it is accessed.
Date: Sun, 10 Feb 2013 13:50:14 +0100
Message-Id: <cbbacac9fcfbed4615a832f5c11ae2f11d645878.1360500224.git.hans.verkuil@cisco.com>
In-Reply-To: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
References: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
References: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Just opening the radio tuner should not cause a switch to the radio tuner.
Only after calling g/s_tuner or g/s_frequency should this happen.

This prevents audio being unmuted as soon as the driver is loaded because
some process opens /dev/radioX just to see what sort of node it is, which
switches on the radio tuner and unmutes audio.

This code can be improved further by actually keeping track of who owns the
tuner and returning -EBUSY if switching tuner modes will cause problems.

But for now just fix the annoying case where on boot the radio turns on
automatically.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |   23 ++++++++++++++++++++---
 drivers/media/pci/bt8xx/bttvp.h       |    1 +
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 6518a61..8610b6a 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1004,7 +1004,7 @@ audio_mux(struct bttv *btv, int input, int mute)
 
 	/* automute */
 	mute = mute || (btv->opt_automute && (!signal || !btv->users)
-				&& !btv->radio_user);
+				&& !btv->has_radio_tuner);
 
 	if (mute)
 		gpio_val = bttv_tvcards[btv->c.type].gpiomute;
@@ -1701,6 +1701,16 @@ static struct videobuf_queue_ops bttv_video_qops = {
 	.buf_release  = buffer_release,
 };
 
+static void radio_enable(struct bttv *btv)
+{
+	/* Switch to the radio tuner */
+	if (!btv->has_radio_tuner) {
+		btv->has_radio_tuner = 1;
+		bttv_call_all(btv, tuner, s_radio);
+		audio_input(btv, TVAUDIO_INPUT_RADIO);
+	}
+}
+
 static int bttv_s_std(struct file *file, void *priv, v4l2_std_id *id)
 {
 	struct bttv_fh *fh  = priv;
@@ -1832,6 +1842,8 @@ static int bttv_g_frequency(struct file *file, void *priv,
 	if (f->tuner)
 		return -EINVAL;
 
+	if (f->type == V4L2_TUNER_RADIO)
+		radio_enable(btv);
 	f->frequency = f->type == V4L2_TUNER_RADIO ?
 				btv->radio_freq : btv->tv_freq;
 
@@ -1845,6 +1857,7 @@ static void bttv_set_frequency(struct bttv *btv, struct v4l2_frequency *f)
 	   frequency before assigning radio/tv_freq. */
 	bttv_call_all(btv, tuner, g_frequency, f);
 	if (f->type == V4L2_TUNER_RADIO) {
+		radio_enable(btv);
 		btv->radio_freq = f->frequency;
 		if (btv->has_matchbox)
 			tea5757_set_freq(btv, btv->radio_freq);
@@ -3216,8 +3229,6 @@ static int radio_open(struct file *file)
 
 	btv->radio_user++;
 
-	bttv_call_all(btv, tuner, s_radio);
-	audio_input(btv,TVAUDIO_INPUT_RADIO);
 	v4l2_fh_add(&fh->fh);
 
 	return 0;
@@ -3238,6 +3249,8 @@ static int radio_release(struct file *file)
 
 	bttv_call_all(btv, core, ioctl, SAA6588_CMD_CLOSE, &cmd);
 
+	if (btv->radio_user == 0)
+		btv->has_radio_tuner = 0;
 	return 0;
 }
 
@@ -3250,6 +3263,7 @@ static int radio_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 		return -EINVAL;
 	strcpy(t->name, "Radio");
 	t->type = V4L2_TUNER_RADIO;
+	radio_enable(btv);
 
 	bttv_call_all(btv, tuner, g_tuner, t);
 
@@ -3268,6 +3282,7 @@ static int radio_s_tuner(struct file *file, void *priv,
 	if (0 != t->index)
 		return -EINVAL;
 
+	radio_enable(btv);
 	bttv_call_all(btv, tuner, s_tuner, t);
 	return 0;
 }
@@ -3282,6 +3297,7 @@ static ssize_t radio_read(struct file *file, char __user *data,
 	cmd.buffer = data;
 	cmd.instance = file;
 	cmd.result = -ENODEV;
+	radio_enable(btv);
 
 	bttv_call_all(btv, core, ioctl, SAA6588_CMD_READ, &cmd);
 
@@ -3300,6 +3316,7 @@ static unsigned int radio_poll(struct file *file, poll_table *wait)
 		res = POLLPRI;
 	else if (req_events & POLLPRI)
 		poll_wait(file, &fh->fh.wait, wait);
+	radio_enable(btv);
 	cmd.instance = file;
 	cmd.event_list = wait;
 	cmd.result = res;
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index 86d67bb..eb13be7 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -437,6 +437,7 @@ struct bttv {
 
 	/* radio data/state */
 	int has_radio;
+	int has_radio_tuner;
 	int radio_user;
 	int radio_uses_msp_demodulator;
 	unsigned long radio_freq;
-- 
1.7.10.4

