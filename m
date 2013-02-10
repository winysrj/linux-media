Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4881 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab3BJMuX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 07:50:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 06/19] bttv: set initial tv/radio frequencies
Date: Sun, 10 Feb 2013 13:50:01 +0100
Message-Id: <eb9952985ed83b93f5a39c14452193ffef2c2c73.1360500224.git.hans.verkuil@cisco.com>
In-Reply-To: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
References: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
References: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Set an initial frequencies when the driver is loaded. That way G_FREQUENCY will
give a frequency that corresponds with reality.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |   34 +++++++++++++++++++++++++++------
 drivers/media/pci/bt8xx/bttvp.h       |    3 ++-
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 228b7c1..07c0919 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2007,10 +2007,27 @@ static int bttv_g_frequency(struct file *file, void *priv,
 	if (f->tuner)
 		return -EINVAL;
 
-	f->frequency = btv->freq;
+	f->frequency = f->type == V4L2_TUNER_RADIO ?
+				btv->radio_freq : btv->tv_freq;
+
 	return 0;
 }
 
+static void bttv_set_frequency(struct bttv *btv, struct v4l2_frequency *f)
+{
+	bttv_call_all(btv, tuner, s_frequency, f);
+	/* s_frequency may clamp the frequency, so get the actual
+	   frequency before assigning radio/tv_freq. */
+	bttv_call_all(btv, tuner, g_frequency, f);
+	if (f->type == V4L2_TUNER_RADIO) {
+		btv->radio_freq = f->frequency;
+		if (btv->has_matchbox)
+			tea5757_set_freq(btv, btv->radio_freq);
+	} else {
+		btv->tv_freq = f->frequency;
+	}
+}
+
 static int bttv_s_frequency(struct file *file, void *priv,
 					struct v4l2_frequency *f)
 {
@@ -2024,11 +2041,7 @@ static int bttv_s_frequency(struct file *file, void *priv,
 	err = v4l2_prio_check(&btv->prio, fh->prio);
 	if (err)
 		return err;
-
-	btv->freq = f->frequency;
-	bttv_call_all(btv, tuner, s_frequency, f);
-	if (btv->has_matchbox && btv->radio_user)
-		tea5757_set_freq(btv, btv->freq);
+	bttv_set_frequency(btv, f);
 	return 0;
 }
 
@@ -4216,6 +4229,11 @@ static void pci_set_command(struct pci_dev *dev)
 
 static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 {
+	struct v4l2_frequency init_freq = {
+		.tuner = 0,
+		.type = V4L2_TUNER_ANALOG_TV,
+		.frequency = 980,
+	};
 	int result;
 	unsigned char lat;
 	struct bttv *btv;
@@ -4356,6 +4374,10 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	/* some card-specific stuff (needs working i2c) */
 	bttv_init_card2(btv);
 	bttv_init_tuner(btv);
+	if (btv->tuner_type != TUNER_ABSENT) {
+		bttv_set_frequency(btv, &init_freq);
+		btv->radio_freq = 90500 * 16; /* 90.5Mhz default */
+	}
 	init_irqreg(btv);
 
 	/* register video4linux + input */
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index 9ec0adb..528e03e 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -418,7 +418,7 @@ struct bttv {
 	unsigned int input;
 	unsigned int audio;
 	unsigned int mute;
-	unsigned long freq;
+	unsigned long tv_freq;
 	unsigned int tvnorm;
 	int hue, contrast, bright, saturation;
 	struct v4l2_framebuffer fbuf;
@@ -442,6 +442,7 @@ struct bttv {
 	int has_radio;
 	int radio_user;
 	int radio_uses_msp_demodulator;
+	unsigned long radio_freq;
 
 	/* miro/pinnacle + Aimslab VHX
 	   philips matchbox (tea5757 radio tuner) support */
-- 
1.7.10.4

