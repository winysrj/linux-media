Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:61491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757420Ab0I1S4m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 14:56:42 -0400
Date: Tue, 28 Sep 2010 15:47:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/10] V4L/DVB: cx231xx-audio: fix some locking issues
Message-ID: <20100928154701.7c8e2874@pedra>
In-Reply-To: <cover.1285699057.git.mchehab@redhat.com>
References: <cover.1285699057.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-audio.c b/drivers/media/video/cx231xx/cx231xx-audio.c
index 6ac418c..30d13c1 100644
--- a/drivers/media/video/cx231xx/cx231xx-audio.c
+++ b/drivers/media/video/cx231xx/cx231xx-audio.c
@@ -124,6 +124,9 @@ static void cx231xx_audio_isocirq(struct urb *urb)
 		break;
 	}
 
+	if (atomic_read(&dev->stream_started) == 0)
+		return;
+
 	if (dev->adev.capture_pcm_substream) {
 		substream = dev->adev.capture_pcm_substream;
 		runtime = substream->runtime;
@@ -206,6 +209,9 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
 		break;
 	}
 
+	if (atomic_read(&dev->stream_started) == 0)
+		return;
+
 	if (dev->adev.capture_pcm_substream) {
 		substream = dev->adev.capture_pcm_substream;
 		runtime = substream->runtime;
@@ -370,35 +376,6 @@ static int cx231xx_init_audio_bulk(struct cx231xx *dev)
 	return errCode;
 }
 
-
-static int cx231xx_cmd(struct cx231xx *dev, int cmd, int arg)
-{
-	dprintk("%s transfer\n", (dev->adev.capture_stream == STREAM_ON) ?
-		"stop" : "start");
-
-	switch (cmd) {
-	case CX231XX_CAPTURE_STREAM_EN:
-		if (dev->adev.capture_stream == STREAM_OFF && arg == 1) {
-			dev->adev.capture_stream = STREAM_ON;
-			if (is_fw_load(dev) == 0)
-				cx25840_call(dev, core, load_fw);
-			if (dev->USE_ISO)
-				cx231xx_init_audio_isoc(dev);
-			else
-				cx231xx_init_audio_bulk(dev);
-		} else if (dev->adev.capture_stream == STREAM_ON && arg == 0) {
-			dev->adev.capture_stream = STREAM_OFF;
-			cx231xx_isoc_audio_deinit(dev);
-		} else {
-			cx231xx_errdev("An underrun very likely occurred. "
-				       "Ignoring it.\n");
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
@@ -460,22 +437,24 @@ static int snd_cx231xx_capture_open(struct snd_pcm_substream *substream)
 
 	/* set alternate setting for audio interface */
 	/* 1 - 48000 samples per sec */
+	mutex_lock(&dev->lock);
 	if (dev->USE_ISO)
 		ret = cx231xx_set_alt_setting(dev, INDEX_AUDIO, 1);
 	else
 		ret = cx231xx_set_alt_setting(dev, INDEX_AUDIO, 0);
+	mutex_unlock(&dev->lock);
 	if (ret < 0) {
 		cx231xx_errdev("failed to set alternate setting !\n");
 
 		return ret;
 	}
 
-	/* inform hardware to start streaming */
-	ret = cx231xx_capture_start(dev, 1, Audio);
-
 	runtime->hw = snd_cx231xx_hw_capture;
 
 	mutex_lock(&dev->lock);
+	/* inform hardware to start streaming */
+	ret = cx231xx_capture_start(dev, 1, Audio);
+
 	dev->adev.users++;
 	mutex_unlock(&dev->lock);
 
@@ -493,7 +472,8 @@ static int snd_cx231xx_pcm_close(struct snd_pcm_substream *substream)
 
 	dprintk("closing device\n");
 
-	/* inform hardware to start streaming */
+	/* inform hardware to stop streaming */
+	mutex_lock(&dev->lock);
 	ret = cx231xx_capture_start(dev, 0, Audio);
 
 	/* set alternate setting for audio interface */
@@ -502,11 +482,11 @@ static int snd_cx231xx_pcm_close(struct snd_pcm_substream *substream)
 	if (ret < 0) {
 		cx231xx_errdev("failed to set alternate setting !\n");
 
+		mutex_unlock(&dev->lock);
 		return ret;
 	}
 
 	dev->mute = 1;
-	mutex_lock(&dev->lock);
 	dev->adev.users--;
 	mutex_unlock(&dev->lock);
 
@@ -515,7 +495,10 @@ static int snd_cx231xx_pcm_close(struct snd_pcm_substream *substream)
 		dprintk("disabling audio stream!\n");
 		dev->adev.shutdown = 0;
 		dprintk("released lock\n");
-		cx231xx_cmd(dev, CX231XX_CAPTURE_STREAM_EN, 0);
+		if (atomic_read(&dev->stream_started) > 0) {
+			atomic_set(&dev->stream_started, 0);
+			schedule_work(&dev->wq_trigger);
+		}
 	}
 	return 0;
 }
@@ -546,8 +529,10 @@ static int snd_cx231xx_hw_capture_free(struct snd_pcm_substream *substream)
 
 	dprintk("Stop capture, if needed\n");
 
-	if (dev->adev.capture_stream == STREAM_ON)
-		cx231xx_cmd(dev, CX231XX_CAPTURE_STREAM_EN, CX231XX_STOP_AUDIO);
+	if (atomic_read(&dev->stream_started) > 0) {
+		atomic_set(&dev->stream_started, 0);
+		schedule_work(&dev->wq_trigger);
+	}
 
 	return 0;
 }
@@ -562,32 +547,46 @@ static int snd_cx231xx_prepare(struct snd_pcm_substream *substream)
 	return 0;
 }
 
+static void audio_trigger(struct work_struct *work)
+{
+	struct cx231xx *dev = container_of(work, struct cx231xx, wq_trigger);
+
+	if (atomic_read(&dev->stream_started)) {
+		dprintk("starting capture");
+		if (is_fw_load(dev) == 0)
+			cx25840_call(dev, core, load_fw);
+		if (dev->USE_ISO)
+			cx231xx_init_audio_isoc(dev);
+		else
+			cx231xx_init_audio_bulk(dev);
+	} else {
+		dprintk("stopping capture");
+		cx231xx_isoc_audio_deinit(dev);
+	}
+}
+
 static int snd_cx231xx_capture_trigger(struct snd_pcm_substream *substream,
 				       int cmd)
 {
 	struct cx231xx *dev = snd_pcm_substream_chip(substream);
 	int retval;
 
-	dprintk("Should %s capture\n", (cmd == SNDRV_PCM_TRIGGER_START) ?
-		"start" : "stop");
-
 	spin_lock(&dev->adev.slock);
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
-		cx231xx_cmd(dev, CX231XX_CAPTURE_STREAM_EN,
-			    CX231XX_START_AUDIO);
-		retval = 0;
+		atomic_set(&dev->stream_started, 1);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
-		cx231xx_cmd(dev, CX231XX_CAPTURE_STREAM_EN, CX231XX_STOP_AUDIO);
-		retval = 0;
+		atomic_set(&dev->stream_started, 0);
 		break;
 	default:
 		retval = -EINVAL;
 	}
-
 	spin_unlock(&dev->adev.slock);
-	return retval;
+
+	schedule_work(&dev->wq_trigger);
+
+	return 0;
 }
 
 static snd_pcm_uframes_t snd_cx231xx_capture_pointer(struct snd_pcm_substream
@@ -668,6 +667,8 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 	strcpy(card->shortname, "Cx231xx Audio");
 	strcpy(card->longname, "Conexant cx231xx Audio");
 
+	INIT_WORK(&dev->wq_trigger, audio_trigger);
+
 	err = snd_card_register(card);
 	if (err < 0) {
 		snd_card_free(card);
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index d079433..f9cdc01 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -27,6 +27,7 @@
 #include <linux/ioctl.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
+#include <linux/workqueue.h>
 #include <linux/mutex.h>
 
 #include <media/cx2341x.h>
@@ -387,9 +388,6 @@ enum AUDIO_INPUT {
 #define CX231XX_AUDIO_BUFS              5
 #define CX231XX_NUM_AUDIO_PACKETS       16
 #define CX231XX_ISO_NUM_AUDIO_PACKETS	64
-#define CX231XX_CAPTURE_STREAM_EN       1
-#define CX231XX_STOP_AUDIO              0
-#define CX231XX_START_AUDIO             1
 
 /* cx231xx extensions */
 #define CX231XX_AUDIO                   0x10
@@ -407,7 +405,6 @@ struct cx231xx_audio {
 	struct snd_card *sndcard;
 
 	int users, shutdown;
-	enum cx231xx_stream_state capture_stream;
 	/* locks */
 	spinlock_t slock;
 
@@ -624,6 +621,9 @@ struct cx231xx {
 
 	struct cx231xx_IR *ir;
 
+	struct work_struct wq_trigger;		/* Trigger to start/stop audio for alsa module */
+	atomic_t	   stream_started;	/* stream should be running if true */
+
 	struct list_head devlist;
 
 	int tuner_type;		/* type of the tuner */
-- 
1.7.1

