Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:44299 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbbAOULA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2015 15:11:00 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 3/3] bttv: Improve TEA575x support
Date: Thu, 15 Jan 2015 21:10:47 +0100
Message-Id: <1421352647-10383-3-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1421352647-10383-1-git-send-email-linux@rainbow-software.org>
References: <1421352647-10383-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve g_tuner and add s_hw_freq_seek and enum_freq_bands support for cards
with TEA575x radio.

This allows signal/stereo detection and HW seek to work on these cards.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/pci/bt8xx/bttv-driver.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index e7f8ade..5476a7d 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2515,6 +2515,8 @@ static int bttv_querycap(struct file *file, void  *priv,
 		if (btv->has_saa6588)
 			cap->device_caps |= V4L2_CAP_READWRITE |
 						V4L2_CAP_RDS_CAPTURE;
+		if (btv->has_tea575x)
+			cap->device_caps |= V4L2_CAP_HW_FREQ_SEEK;
 	}
 	return 0;
 }
@@ -3244,6 +3246,9 @@ static int radio_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	if (btv->audio_mode_gpio)
 		btv->audio_mode_gpio(btv, t, 0);
 
+	if (btv->has_tea575x)
+		return snd_tea575x_g_tuner(&btv->tea, t);
+
 	return 0;
 }
 
@@ -3261,6 +3266,30 @@ static int radio_s_tuner(struct file *file, void *priv,
 	return 0;
 }
 
+static int radio_s_hw_freq_seek(struct file *file, void *priv,
+					const struct v4l2_hw_freq_seek *a)
+{
+	struct bttv_fh *fh = priv;
+	struct bttv *btv = fh->btv;
+
+	if (btv->has_tea575x)
+		return snd_tea575x_s_hw_freq_seek(file, &btv->tea, a);
+	else
+		return -ENOTTY;
+}
+
+static int radio_enum_freq_bands(struct file *file, void *priv,
+					 struct v4l2_frequency_band *band)
+{
+	struct bttv_fh *fh = priv;
+	struct bttv *btv = fh->btv;
+
+	if (btv->has_tea575x)
+		return snd_tea575x_enum_freq_bands(&btv->tea, band);
+	else
+		return -ENOTTY;
+}
+
 static ssize_t radio_read(struct file *file, char __user *data,
 			 size_t count, loff_t *ppos)
 {
@@ -3318,6 +3347,8 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_tuner         = radio_s_tuner,
 	.vidioc_g_frequency     = bttv_g_frequency,
 	.vidioc_s_frequency     = bttv_s_frequency,
+	.vidioc_s_hw_freq_seek	= radio_s_hw_freq_seek,
+	.vidioc_enum_freq_bands	= radio_enum_freq_bands,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
-- 
Ondrej Zary

