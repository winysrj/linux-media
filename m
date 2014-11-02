Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaKCJSb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Nov 2014 04:18:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCHv2 09/14] [media] cx231xx: get rid of audio debug parameter
Date: Sun,  2 Nov 2014 10:32:32 -0200
Message-Id: <2776595e7e906bd873a79aee61d9b80efeaef86a.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's just one debug level on cx231xx-audio. So, converting it
to dev_dbg() is easy.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index 1c3f68179fc9..a05ae02e5245 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -42,19 +42,13 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "activates debug info");
 
-#define dprintk(fmt, arg...) do {					\
-		if (debug)						\
-			printk(KERN_INFO "cx231xx-audio %s: " fmt,	\
-				__func__, ##arg); 			\
-	} while (0)
-
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 
 static int cx231xx_isoc_audio_deinit(struct cx231xx *dev)
 {
 	int i;
 
-	dprintk("Stopping isoc\n");
+	dev_dbg(&dev->udev->dev, "Stopping isoc\n");
 
 	for (i = 0; i < CX231XX_AUDIO_BUFS; i++) {
 		if (dev->adev.urb[i]) {
@@ -78,7 +72,7 @@ static int cx231xx_bulk_audio_deinit(struct cx231xx *dev)
 {
 	int i;
 
-	dprintk("Stopping bulk\n");
+	dev_dbg(&dev->udev->dev, "Stopping bulk\n");
 
 	for (i = 0; i < CX231XX_AUDIO_BUFS; i++) {
 		if (dev->adev.urb[i]) {
@@ -122,7 +116,8 @@ static void cx231xx_audio_isocirq(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:		/* error */
-		dprintk("urb completition error %d.\n", urb->status);
+		dev_dbg(&dev->udev->dev, "urb completition error %d.\n",
+			urb->status);
 		break;
 	}
 
@@ -211,7 +206,8 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:		/* error */
-		dprintk("urb completition error %d.\n", urb->status);
+		dev_dbg(&dev->udev->dev, "urb completition error %d.\n",
+			urb->status);
 		break;
 	}
 
@@ -395,8 +391,9 @@ static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs,
 					size_t size)
 {
 	struct snd_pcm_runtime *runtime = subs->runtime;
+	struct cx231xx *dev = snd_pcm_substream_chip(subs);
 
-	dprintk("Allocating vbuffer\n");
+	dev_dbg(&dev->udev->dev, "Allocating vbuffer\n");
 	if (runtime->dma_area) {
 		if (runtime->dma_bytes > size)
 			return 0;
@@ -439,7 +436,8 @@ static int snd_cx231xx_capture_open(struct snd_pcm_substream *substream)
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	int ret = 0;
 
-	dprintk("opening device and trying to acquire exclusive lock\n");
+	dev_dbg(&dev->udev->dev,
+		"opening device and trying to acquire exclusive lock\n");
 
 	if (!dev) {
 		dev_err(&dev->udev->dev,
@@ -489,7 +487,7 @@ static int snd_cx231xx_pcm_close(struct snd_pcm_substream *substream)
 	int ret;
 	struct cx231xx *dev = snd_pcm_substream_chip(substream);
 
-	dprintk("closing device\n");
+	dev_dbg(&dev->udev->dev, "closing device\n");
 
 	/* inform hardware to stop streaming */
 	mutex_lock(&dev->lock);
@@ -510,10 +508,10 @@ static int snd_cx231xx_pcm_close(struct snd_pcm_substream *substream)
 	mutex_unlock(&dev->lock);
 
 	if (dev->adev.users == 0 && dev->adev.shutdown == 1) {
-		dprintk("audio users: %d\n", dev->adev.users);
-		dprintk("disabling audio stream!\n");
+		dev_dbg(&dev->udev->dev, "audio users: %d\n", dev->adev.users);
+		dev_dbg(&dev->udev->dev, "disabling audio stream!\n");
 		dev->adev.shutdown = 0;
-		dprintk("released lock\n");
+		dev_dbg(&dev->udev->dev, "released lock\n");
 		if (atomic_read(&dev->stream_started) > 0) {
 			atomic_set(&dev->stream_started, 0);
 			schedule_work(&dev->wq_trigger);
@@ -525,9 +523,10 @@ static int snd_cx231xx_pcm_close(struct snd_pcm_substream *substream)
 static int snd_cx231xx_hw_capture_params(struct snd_pcm_substream *substream,
 					 struct snd_pcm_hw_params *hw_params)
 {
+	struct cx231xx *dev = snd_pcm_substream_chip(substream);
 	int ret;
 
-	dprintk("Setting capture parameters\n");
+	dev_dbg(&dev->udev->dev, "Setting capture parameters\n");
 
 	ret = snd_pcm_alloc_vmalloc_buffer(substream,
 					   params_buffer_bytes(hw_params));
@@ -549,7 +548,7 @@ static int snd_cx231xx_hw_capture_free(struct snd_pcm_substream *substream)
 {
 	struct cx231xx *dev = snd_pcm_substream_chip(substream);
 
-	dprintk("Stop capture, if needed\n");
+	dev_dbg(&dev->udev->dev, "Stop capture, if needed\n");
 
 	if (atomic_read(&dev->stream_started) > 0) {
 		atomic_set(&dev->stream_started, 0);
@@ -574,7 +573,7 @@ static void audio_trigger(struct work_struct *work)
 	struct cx231xx *dev = container_of(work, struct cx231xx, wq_trigger);
 
 	if (atomic_read(&dev->stream_started)) {
-		dprintk("starting capture");
+		dev_dbg(&dev->udev->dev, "starting capture");
 		if (is_fw_load(dev) == 0)
 			cx25840_call(dev, core, load_fw);
 		if (dev->USE_ISO)
@@ -582,7 +581,7 @@ static void audio_trigger(struct work_struct *work)
 		else
 			cx231xx_init_audio_bulk(dev);
 	} else {
-		dprintk("stopping capture");
+		dev_dbg(&dev->udev->dev, "stopping capture");
 		cx231xx_isoc_audio_deinit(dev);
 	}
 }
-- 
1.9.3

