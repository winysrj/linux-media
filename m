Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48028 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaALRbM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 12:31:12 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] em28xx-audio: return -ENODEV when the device is disconnected
Date: Sun, 12 Jan 2014 11:52:35 -0200
Message-Id: <1389534755-19462-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389534755-19462-1-git-send-email-m.chehab@samsung.com>
References: <1389534755-19462-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If em28xx is disconnected, return -ENODEV to all PCM callbacks.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 43 +++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 13ba631130cd..f3e320098f79 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -90,6 +90,12 @@ static void em28xx_audio_isocirq(struct urb *urb)
 	struct snd_pcm_substream *substream;
 	struct snd_pcm_runtime   *runtime;
 
+	if (dev->disconnected) {
+		dprintk("device disconnected while streaming. URB status=%d.\n", urb->status);
+		atomic_set(&dev->stream_started, 0);
+		return;
+	}
+
 	switch (urb->status) {
 	case 0:             /* success */
 	case -ETIMEDOUT:    /* NAK */
@@ -248,14 +254,17 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	int ret = 0;
 
-	dprintk("opening device and trying to acquire exclusive lock\n");
-
 	if (!dev) {
 		em28xx_err("BUG: em28xx can't find device struct."
 				" Can't proceed with open\n");
 		return -ENODEV;
 	}
 
+	if (dev->disconnected)
+		return -ENODEV;
+
+	dprintk("opening device and trying to acquire exclusive lock\n");
+
 	runtime->hw = snd_em28xx_hw_capture;
 	if ((dev->alt == 0 || dev->audio_ifnum) && dev->adev.users == 0) {
 		int nonblock = !!(substream->f_flags & O_NONBLOCK);
@@ -324,6 +333,10 @@ static int snd_em28xx_hw_capture_params(struct snd_pcm_substream *substream,
 					struct snd_pcm_hw_params *hw_params)
 {
 	int ret;
+	struct em28xx *dev = snd_pcm_substream_chip(substream);
+
+	if (dev->disconnected)
+		return -ENODEV;
 
 	dprintk("Setting capture parameters\n");
 
@@ -363,6 +376,9 @@ static int snd_em28xx_prepare(struct snd_pcm_substream *substream)
 {
 	struct em28xx *dev = snd_pcm_substream_chip(substream);
 
+	if (dev->disconnected)
+		return -ENODEV;
+
 	dev->adev.hwptr_done_capture = 0;
 	dev->adev.capture_transfer_done = 0;
 
@@ -388,6 +404,9 @@ static int snd_em28xx_capture_trigger(struct snd_pcm_substream *substream,
 	struct em28xx *dev = snd_pcm_substream_chip(substream);
 	int retval = 0;
 
+	if (dev->disconnected)
+		return -ENODEV;
+
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE: /* fall through */
 	case SNDRV_PCM_TRIGGER_RESUME: /* fall through */
@@ -414,6 +433,9 @@ static snd_pcm_uframes_t snd_em28xx_capture_pointer(struct snd_pcm_substream
 	snd_pcm_uframes_t hwptr_done;
 
 	dev = snd_pcm_substream_chip(substream);
+	if (dev->disconnected)
+		return -ENODEV;
+
 	spin_lock_irqsave(&dev->adev.slock, flags);
 	hwptr_done = dev->adev.hwptr_done_capture;
 	spin_unlock_irqrestore(&dev->adev.slock, flags);
@@ -435,6 +457,11 @@ static struct page *snd_pcm_get_vmalloc_page(struct snd_pcm_substream *subs,
 static int em28xx_vol_info(struct snd_kcontrol *kcontrol,
 				struct snd_ctl_elem_info *info)
 {
+	struct em28xx *dev = snd_kcontrol_chip(kcontrol);
+
+	if (dev->disconnected)
+		return -ENODEV;
+
 	info->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
 	info->count = 2;
 	info->value.integer.min = 0;
@@ -453,6 +480,9 @@ static int em28xx_vol_put(struct snd_kcontrol *kcontrol,
 	int nonblock = 0;
 	int rc;
 
+	if (dev->disconnected)
+		return -ENODEV;
+
 	if (substream)
 		nonblock = !!(substream->f_flags & O_NONBLOCK);
 	if (nonblock) {
@@ -488,6 +518,9 @@ static int em28xx_vol_get(struct snd_kcontrol *kcontrol,
 	int nonblock = 0;
 	int val;
 
+	if (dev->disconnected)
+		return -ENODEV;
+
 	if (substream)
 		nonblock = !!(substream->f_flags & O_NONBLOCK);
 	if (nonblock) {
@@ -520,6 +553,9 @@ static int em28xx_vol_put_mute(struct snd_kcontrol *kcontrol,
 	int nonblock = 0;
 	int rc;
 
+	if (dev->disconnected)
+		return -ENODEV;
+
 	if (substream)
 		nonblock = !!(substream->f_flags & O_NONBLOCK);
 	if (nonblock) {
@@ -558,6 +594,9 @@ static int em28xx_vol_get_mute(struct snd_kcontrol *kcontrol,
 	int nonblock = 0;
 	int val;
 
+	if (dev->disconnected)
+		return -ENODEV;
+
 	if (substream)
 		nonblock = !!(substream->f_flags & O_NONBLOCK);
 	if (nonblock) {
-- 
1.8.3.1

