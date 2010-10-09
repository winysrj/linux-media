Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:29534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760396Ab0JITEe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Oct 2010 15:04:34 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o99J4YL8009355
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 9 Oct 2010 15:04:34 -0400
Received: from [10.3.225.91] (vpn-225-91.phx2.redhat.com [10.3.225.91])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o99J4WEa010403
	for <linux-media@vger.kernel.org>; Sat, 9 Oct 2010 15:04:32 -0400
Message-ID: <4CB0BCBE.6040400@redhat.com>
Date: Sat, 09 Oct 2010 16:04:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L/DVB: em28xx-audio: fix some locking issues
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Those locking issues affect tvtime, causing a kernel oops/panic, due to
a race condition.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index e182abf..3c48a72 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -102,6 +102,9 @@ static void em28xx_audio_isocirq(struct urb *urb)
 		break;
 	}
 
+	if (atomic_read(&dev->stream_started) == 0)
+		return;
+
 	if (dev->adev.capture_pcm_substream) {
 		substream = dev->adev.capture_pcm_substream;
 		runtime = substream->runtime;
@@ -217,31 +220,6 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
 	return 0;
 }
 
-static int em28xx_cmd(struct em28xx *dev, int cmd, int arg)
-{
-	dprintk("%s transfer\n", (dev->adev.capture_stream == STREAM_ON) ?
-				 "stop" : "start");
-
-	switch (cmd) {
-	case EM28XX_CAPTURE_STREAM_EN:
-		if (dev->adev.capture_stream == STREAM_OFF &&
-		    arg == EM28XX_START_AUDIO) {
-			dev->adev.capture_stream = STREAM_ON;
-			em28xx_init_audio_isoc(dev);
-		} else if (dev->adev.capture_stream == STREAM_ON &&
-			   arg == EM28XX_STOP_AUDIO) {
-			dev->adev.capture_stream = STREAM_OFF;
-			em28xx_deinit_isoc_audio(dev);
-		} else {
-			em28xx_errdev("An underrun very likely occurred. "
-					"Ignoring it.\n");
-		}
-		return 0;
-	default:
-		return -EINVAL;
-	}
-}
-
 static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs,
 					size_t size)
 {
@@ -303,7 +281,6 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 	dev->mute = 0;
 	mutex_lock(&dev->lock);
 	ret = em28xx_audio_analog_set(dev);
-	mutex_unlock(&dev->lock);
 	if (ret < 0)
 		goto err;
 
@@ -311,11 +288,10 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 	if (dev->alt == 0 && dev->adev.users == 0) {
 		int errCode;
 		dev->alt = 7;
-		errCode = usb_set_interface(dev->udev, 0, 7);
 		dprintk("changing alternate number to 7\n");
+		errCode = usb_set_interface(dev->udev, 0, 7);
 	}
 
-	mutex_lock(&dev->lock);
 	dev->adev.users++;
 	mutex_unlock(&dev->lock);
 
@@ -325,6 +301,8 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 
 	return 0;
 err:
+	mutex_unlock(&dev->lock);
+
 	em28xx_err("Error while configuring em28xx mixer\n");
 	return ret;
 }
@@ -338,6 +316,11 @@ static int snd_em28xx_pcm_close(struct snd_pcm_substream *substream)
 	dev->mute = 1;
 	mutex_lock(&dev->lock);
 	dev->adev.users--;
+	if (atomic_read(&dev->stream_started) > 0) {
+		atomic_set(&dev->stream_started, 0);
+		schedule_work(&dev->wq_trigger);
+	}
+
 	em28xx_audio_analog_set(dev);
 	if (substream->runtime->dma_area) {
 		dprintk("freeing\n");
@@ -375,8 +358,10 @@ static int snd_em28xx_hw_capture_free(struct snd_pcm_substream *substream)
 
 	dprintk("Stop capture, if needed\n");
 
-	if (dev->adev.capture_stream == STREAM_ON)
-		em28xx_cmd(dev, EM28XX_CAPTURE_STREAM_EN, EM28XX_STOP_AUDIO);
+	if (atomic_read(&dev->stream_started) > 0) {
+		atomic_set(&dev->stream_started, 0);
+		schedule_work(&dev->wq_trigger);
+	}
 
 	return 0;
 }
@@ -391,31 +376,37 @@ static int snd_em28xx_prepare(struct snd_pcm_substream *substream)
 	return 0;
 }
 
+static void audio_trigger(struct work_struct *work)
+{
+	struct em28xx *dev = container_of(work, struct em28xx, wq_trigger);
+
+	if (atomic_read(&dev->stream_started)) {
+		dprintk("starting capture");
+		em28xx_init_audio_isoc(dev);
+	} else {
+		dprintk("stopping capture");
+		em28xx_deinit_isoc_audio(dev);
+	}
+}
+
 static int snd_em28xx_capture_trigger(struct snd_pcm_substream *substream,
 				      int cmd)
 {
 	struct em28xx *dev = snd_pcm_substream_chip(substream);
 	int retval;
 
-	dprintk("Should %s capture\n", (cmd == SNDRV_PCM_TRIGGER_START) ?
-				       "start" : "stop");
-
-	spin_lock(&dev->adev.slock);
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
-		em28xx_cmd(dev, EM28XX_CAPTURE_STREAM_EN, EM28XX_START_AUDIO);
-		retval = 0;
+		atomic_set(&dev->stream_started, 1);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
-		em28xx_cmd(dev, EM28XX_CAPTURE_STREAM_EN, EM28XX_STOP_AUDIO);
-		retval = 0;
+		atomic_set(&dev->stream_started, 1);
 		break;
 	default:
 		retval = -EINVAL;
 	}
-
-	spin_unlock(&dev->adev.slock);
-	return retval;
+	schedule_work(&dev->wq_trigger);
+	return 0;
 }
 
 static snd_pcm_uframes_t snd_em28xx_capture_pointer(struct snd_pcm_substream
@@ -495,6 +486,8 @@ static int em28xx_audio_init(struct em28xx *dev)
 	strcpy(card->shortname, "Em28xx Audio");
 	strcpy(card->longname, "Empia Em28xx Audio");
 
+	INIT_WORK(&dev->wq_trigger, audio_trigger);
+
 	err = snd_card_register(card);
 	if (err < 0) {
 		snd_card_free(card);
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 1c61a6b..adb20eb 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -25,12 +25,13 @@
 #ifndef _EM28XX_H
 #define _EM28XX_H
 
+#include <linux/workqueue.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
 #include <linux/videodev2.h>
+
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-device.h>
-
-#include <linux/i2c.h>
-#include <linux/mutex.h>
 #include <media/ir-kbd-i2c.h>
 #include <media/ir-core.h>
 #if defined(CONFIG_VIDEO_EM28XX_DVB) || defined(CONFIG_VIDEO_EM28XX_DVB_MODULE)
@@ -184,11 +185,6 @@ enum em28xx_mode {
 	EM28XX_DIGITAL_MODE,
 };
 
-enum em28xx_stream_state {
-	STREAM_OFF,
-	STREAM_INTERRUPT,
-	STREAM_ON,
-};
 
 struct em28xx;
 
@@ -463,7 +459,6 @@ struct em28xx_audio {
 	struct snd_card            *sndcard;
 
 	int users;
-	enum em28xx_stream_state capture_stream;
 	spinlock_t slock;
 };
 
@@ -505,6 +500,10 @@ struct em28xx {
 	unsigned int has_audio_class:1;
 	unsigned int has_alsa_audio:1;
 
+	/* Controls audio streaming */
+	struct work_struct wq_trigger;              /* Trigger to start/stop audio for alsa module */
+	 atomic_t       stream_started;      /* stream should be running if true */
+
 	struct em28xx_fmt *format;
 
 	struct em28xx_IR *ir;
-- 
1.7.1

