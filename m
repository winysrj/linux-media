Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:54860 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3FNVCH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 17:02:07 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/2] radio-sf16fmi: Set frequency during init
Date: Fri, 14 Jun 2013 23:01:39 +0200
Message-Id: <1371243699-28946-3-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1371243699-28946-1-git-send-email-linux@rainbow-software.org>
References: <1371243699-28946-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set freqency during initialization to fix v4l2-compliance error.
This also fixes VIDIOC_G_FREQUENCY always returning zero (broken by me during LM7000 conversion).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/radio/radio-sf16fmi.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index ed7299d..6f4318f 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -50,7 +50,7 @@ struct fmi
 	struct video_device vdev;
 	int io;
 	bool mute;
-	unsigned long curfreq; /* freq in kHz */
+	u32 curfreq; /* freq in kHz */
 	struct mutex lock;
 };
 
@@ -118,6 +118,14 @@ static inline int fmi_getsigstr(struct fmi *fmi)
 	return (res & 2) ? 0 : 0xFFFF;
 }
 
+static void fmi_set_freq(struct fmi *fmi)
+{
+	fmi->curfreq = clamp(fmi->curfreq, RSF16_MINFREQ, RSF16_MAXFREQ);
+	/* rounding in steps of 800 to match the freq
+	   that will be used */
+	lm7000_set_freq((fmi->curfreq / 800) * 800, fmi, fmi_set_pins);
+}
+
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *v)
 {
@@ -158,14 +166,13 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 					const struct v4l2_frequency *f)
 {
 	struct fmi *fmi = video_drvdata(file);
-	unsigned freq = f->frequency;
 
 	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
 		return -EINVAL;
-	clamp(freq, RSF16_MINFREQ, RSF16_MAXFREQ);
-	/* rounding in steps of 800 to match the freq
-	   that will be used */
-	lm7000_set_freq((freq / 800) * 800, fmi, fmi_set_pins);
+
+	fmi->curfreq = f->frequency;
+	fmi_set_freq(fmi);
+
 	return 0;
 }
 
@@ -342,8 +349,10 @@ static int __init fmi_init(void)
 
 	mutex_init(&fmi->lock);
 
-	/* mute card - prevents noisy bootups */
-	fmi_mute(fmi);
+	/* mute card and set default frequency */
+	fmi->mute = 1;
+	fmi->curfreq = RSF16_MINFREQ;
+	fmi_set_freq(fmi);
 
 	if (video_register_device(&fmi->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
 		v4l2_ctrl_handler_free(hdl);
-- 
Ondrej Zary

