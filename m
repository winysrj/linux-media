Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:38968 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbaCXTdR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:17 -0400
Received: by mail-ee0-f43.google.com with SMTP id e53so4831132eek.2
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:33:16 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 19/19] em28xx: move fields wq_trigger and streaming_started from struct em28xx to struct em28xx_audio
Date: Mon, 24 Mar 2014 20:33:25 +0100
Message-Id: <1395689605-2705-20-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 39 ++++++++++++++++++---------------
 drivers/media/usb/em28xx/em28xx.h       |  8 +++----
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index c1937ea..e5ed5b9 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -92,7 +92,7 @@ static void em28xx_audio_isocirq(struct urb *urb)
 
 	if (dev->disconnected) {
 		dprintk("device disconnected while streaming. URB status=%d.\n", urb->status);
-		atomic_set(&dev->stream_started, 0);
+		atomic_set(&dev->adev.stream_started, 0);
 		return;
 	}
 
@@ -109,7 +109,7 @@ static void em28xx_audio_isocirq(struct urb *urb)
 		break;
 	}
 
-	if (atomic_read(&dev->stream_started) == 0)
+	if (atomic_read(&dev->adev.stream_started) == 0)
 		return;
 
 	if (dev->adev.capture_pcm_substream) {
@@ -185,7 +185,7 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
 			em28xx_errdev("submit of audio urb failed (error=%i)\n",
 				      errCode);
 			em28xx_deinit_isoc_audio(dev);
-			atomic_set(&dev->stream_started, 0);
+			atomic_set(&dev->adev.stream_started, 0);
 			return errCode;
 		}
 
@@ -332,9 +332,9 @@ static int snd_em28xx_pcm_close(struct snd_pcm_substream *substream)
 	dev->mute = 1;
 	mutex_lock(&dev->lock);
 	dev->adev.users--;
-	if (atomic_read(&dev->stream_started) > 0) {
-		atomic_set(&dev->stream_started, 0);
-		schedule_work(&dev->wq_trigger);
+	if (atomic_read(&dev->adev.stream_started) > 0) {
+		atomic_set(&dev->adev.stream_started, 0);
+		schedule_work(&dev->adev.wq_trigger);
 	}
 
 	em28xx_audio_analog_set(dev);
@@ -381,12 +381,13 @@ static int snd_em28xx_hw_capture_params(struct snd_pcm_substream *substream,
 static int snd_em28xx_hw_capture_free(struct snd_pcm_substream *substream)
 {
 	struct em28xx *dev = snd_pcm_substream_chip(substream);
+	struct em28xx_audio *adev = &dev->adev;
 
 	dprintk("Stop capture, if needed\n");
 
-	if (atomic_read(&dev->stream_started) > 0) {
-		atomic_set(&dev->stream_started, 0);
-		schedule_work(&dev->wq_trigger);
+	if (atomic_read(&adev->stream_started) > 0) {
+		atomic_set(&adev->stream_started, 0);
+		schedule_work(&adev->wq_trigger);
 	}
 
 	return 0;
@@ -407,9 +408,11 @@ static int snd_em28xx_prepare(struct snd_pcm_substream *substream)
 
 static void audio_trigger(struct work_struct *work)
 {
-	struct em28xx *dev = container_of(work, struct em28xx, wq_trigger);
+	struct em28xx_audio *adev =
+			    container_of(work, struct em28xx_audio, wq_trigger);
+	struct em28xx *dev = container_of(adev, struct em28xx, adev);
 
-	if (atomic_read(&dev->stream_started)) {
+	if (atomic_read(&adev->stream_started)) {
 		dprintk("starting capture");
 		em28xx_init_audio_isoc(dev);
 	} else {
@@ -431,17 +434,17 @@ static int snd_em28xx_capture_trigger(struct snd_pcm_substream *substream,
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE: /* fall through */
 	case SNDRV_PCM_TRIGGER_RESUME: /* fall through */
 	case SNDRV_PCM_TRIGGER_START:
-		atomic_set(&dev->stream_started, 1);
+		atomic_set(&dev->adev.stream_started, 1);
 		break;
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH: /* fall through */
 	case SNDRV_PCM_TRIGGER_SUSPEND: /* fall through */
 	case SNDRV_PCM_TRIGGER_STOP:
-		atomic_set(&dev->stream_started, 0);
+		atomic_set(&dev->adev.stream_started, 0);
 		break;
 	default:
 		retval = -EINVAL;
 	}
-	schedule_work(&dev->wq_trigger);
+	schedule_work(&dev->adev.wq_trigger);
 	return retval;
 }
 
@@ -929,7 +932,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 	strcpy(card->shortname, "Em28xx Audio");
 	strcpy(card->longname, "Empia Em28xx Audio");
 
-	INIT_WORK(&dev->wq_trigger, audio_trigger);
+	INIT_WORK(&adev->wq_trigger, audio_trigger);
 
 	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
 		em28xx_cvol_new(card, dev, "Video", AC97_VIDEO);
@@ -984,7 +987,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
 
 	if (dev->adev.sndcard) {
 		snd_card_disconnect(dev->adev.sndcard);
-		flush_work(&dev->wq_trigger);
+		flush_work(&dev->adev.wq_trigger);
 
 		em28xx_audio_free_urb(dev);
 
@@ -1006,7 +1009,7 @@ static int em28xx_audio_suspend(struct em28xx *dev)
 
 	em28xx_info("Suspending audio extension");
 	em28xx_deinit_isoc_audio(dev);
-	atomic_set(&dev->stream_started, 0);
+	atomic_set(&dev->adev.stream_started, 0);
 	return 0;
 }
 
@@ -1020,7 +1023,7 @@ static int em28xx_audio_resume(struct em28xx *dev)
 
 	em28xx_info("Resuming audio extension");
 	/* Nothing to do other than schedule_work() ?? */
-	schedule_work(&dev->wq_trigger);
+	schedule_work(&dev->adev.wq_trigger);
 	return 0;
 }
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 3a3fe16..c1102ba 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -567,6 +567,10 @@ struct em28xx_audio {
 
 	int users;
 	spinlock_t slock;
+
+	/* Controls streaming */
+	struct work_struct wq_trigger;	/* trigger to start/stop audio */
+	atomic_t       stream_started;	/* stream should be running if true */
 };
 
 struct em28xx;
@@ -618,10 +622,6 @@ struct em28xx {
 
 	enum em28xx_sensor em28xx_sensor;	/* camera specific */
 
-	/* Controls audio streaming */
-	struct work_struct wq_trigger;	/* Trigger to start/stop audio for alsa module */
-	atomic_t       stream_started;	/* stream should be running if true */
-
 	/* Some older em28xx chips needs a waiting time after writing */
 	unsigned int wait_after_write;
 
-- 
1.8.4.5

