Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47728 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaALP2p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 10:28:45 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC] em28xx-audio: don't wait for lock in non-block mode
Date: Sun, 12 Jan 2014 10:25:05 -0200
Message-Id: <1389529505-32508-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pulseaudio has the bad habit of stopping a streaming audio if
a device, opened in non-block mode, waits.

It is impossible to avoid em28xx to wait, as it will send commands
via I2C, and other I2C operations may be happening (firmware
transfers, Remote Controller polling, etc). Yet, as each em28xx
subdriver locks em28xx-dev to protect the access to the hardware,
it is possible to minimize the audio glitches by returning -EAGAIN
to pulseaudio, if the lock is already taken by another subdriver.

Reported-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 48 +++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index f6fcee3d4fb9..f004680219e7 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -258,6 +258,13 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 
 	runtime->hw = snd_em28xx_hw_capture;
 	if ((dev->alt == 0 || dev->audio_ifnum) && dev->adev.users == 0) {
+		int nonblock = !!(substream->f_flags & O_NONBLOCK);
+
+		if (nonblock) {
+			if (!mutex_trylock(&dev->lock))
+				return -EAGAIN;
+		} else
+			mutex_lock(&dev->lock);
 		if (dev->audio_ifnum)
 			dev->alt = 1;
 		else
@@ -269,7 +276,6 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 
 		/* Sets volume, mute, etc */
 		dev->mute = 0;
-		mutex_lock(&dev->lock);
 		ret = em28xx_audio_analog_set(dev);
 		if (ret < 0)
 			goto err;
@@ -441,11 +447,19 @@ static int em28xx_vol_put(struct snd_kcontrol *kcontrol,
 			       struct snd_ctl_elem_value *value)
 {
 	struct em28xx *dev = snd_kcontrol_chip(kcontrol);
+	struct snd_pcm_substream *substream = dev->adev.capture_pcm_substream;
 	u16 val = (0x1f - (value->value.integer.value[0] & 0x1f)) |
 		  (0x1f - (value->value.integer.value[1] & 0x1f)) << 8;
+	int nonblock = 0;
 	int rc;
 
-	mutex_lock(&dev->lock);
+	if (substream)
+		nonblock = !!(substream->f_flags & O_NONBLOCK);
+	if (nonblock) {
+		if (!mutex_trylock(&dev->lock))
+			return -EAGAIN;
+	} else
+		mutex_lock(&dev->lock);
 	rc = em28xx_read_ac97(dev, kcontrol->private_value);
 	if (rc < 0)
 		goto err;
@@ -470,9 +484,17 @@ static int em28xx_vol_get(struct snd_kcontrol *kcontrol,
 			       struct snd_ctl_elem_value *value)
 {
 	struct em28xx *dev = snd_kcontrol_chip(kcontrol);
+	struct snd_pcm_substream *substream = dev->adev.capture_pcm_substream;
+	int nonblock = 0;
 	int val;
 
-	mutex_lock(&dev->lock);
+	if (substream)
+		nonblock = !!(substream->f_flags & O_NONBLOCK);
+	if (nonblock) {
+		if (!mutex_trylock(&dev->lock))
+			return -EAGAIN;
+	} else
+		mutex_lock(&dev->lock);
 	val = em28xx_read_ac97(dev, kcontrol->private_value);
 	mutex_unlock(&dev->lock);
 	if (val < 0)
@@ -494,9 +516,17 @@ static int em28xx_vol_put_mute(struct snd_kcontrol *kcontrol,
 {
 	struct em28xx *dev = snd_kcontrol_chip(kcontrol);
 	u16 val = value->value.integer.value[0];
+	struct snd_pcm_substream *substream = dev->adev.capture_pcm_substream;
+	int nonblock = 0;
 	int rc;
 
-	mutex_lock(&dev->lock);
+	if (substream)
+		nonblock = !!(substream->f_flags & O_NONBLOCK);
+	if (nonblock) {
+		if (!mutex_trylock(&dev->lock))
+			return -EAGAIN;
+	} else
+		mutex_lock(&dev->lock);
 	rc = em28xx_read_ac97(dev, kcontrol->private_value);
 	if (rc < 0)
 		goto err;
@@ -524,9 +554,17 @@ static int em28xx_vol_get_mute(struct snd_kcontrol *kcontrol,
 			       struct snd_ctl_elem_value *value)
 {
 	struct em28xx *dev = snd_kcontrol_chip(kcontrol);
+	struct snd_pcm_substream *substream = dev->adev.capture_pcm_substream;
+	int nonblock = 0;
 	int val;
 
-	mutex_lock(&dev->lock);
+	if (substream)
+		nonblock = !!(substream->f_flags & O_NONBLOCK);
+	if (nonblock) {
+		if (!mutex_trylock(&dev->lock))
+			return -EAGAIN;
+	} else
+		mutex_lock(&dev->lock);
 	val = em28xx_read_ac97(dev, kcontrol->private_value);
 	mutex_unlock(&dev->lock);
 	if (val < 0)
-- 
1.8.3.1

