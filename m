Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:55753 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaAQRRq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 12:17:46 -0500
Received: by mail-ee0-f47.google.com with SMTP id d49so1480321eek.6
        for <linux-media@vger.kernel.org>; Fri, 17 Jan 2014 09:17:45 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/2] em28xx-audio: fix user counting in snd_em28xx_capture_open()
Date: Fri, 17 Jan 2014 18:18:42 +0100
Message-Id: <1389979123-6919-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dev->adev.users always needs to be increased when snd_em28xx_capture_open() is
called and succeeds.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c |   22 +++++++++++-----------
 1 Datei geändert, 11 Zeilen hinzugefügt(+), 11 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 05e9bd1..dfdfa77 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -252,7 +252,7 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 {
 	struct em28xx *dev = snd_pcm_substream_chip(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	int ret = 0;
+	int nonblock, ret = 0;
 
 	if (!dev) {
 		em28xx_err("BUG: em28xx can't find device struct."
@@ -265,15 +265,15 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 
 	dprintk("opening device and trying to acquire exclusive lock\n");
 
+	nonblock = !!(substream->f_flags & O_NONBLOCK);
+	if (nonblock) {
+		if (!mutex_trylock(&dev->lock))
+		return -EAGAIN;
+	} else
+		mutex_lock(&dev->lock);
+
 	runtime->hw = snd_em28xx_hw_capture;
 	if ((dev->alt == 0 || dev->is_audio_only) && dev->adev.users == 0) {
-		int nonblock = !!(substream->f_flags & O_NONBLOCK);
-
-		if (nonblock) {
-			if (!mutex_trylock(&dev->lock))
-				return -EAGAIN;
-		} else
-			mutex_lock(&dev->lock);
 		if (dev->is_audio_only)
 			/* vendor audio is on a separate interface */
 			dev->alt = 1;
@@ -299,11 +299,11 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 		ret = em28xx_audio_analog_set(dev);
 		if (ret < 0)
 			goto err;
-
-		dev->adev.users++;
-		mutex_unlock(&dev->lock);
 	}
 
+	dev->adev.users++;
+	mutex_unlock(&dev->lock);
+
 	/* Dynamically adjust the period size */
 	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
 	snd_pcm_hw_constraint_minmax(runtime, SNDRV_PCM_HW_PARAM_PERIOD_BYTES,
-- 
1.7.10.4

