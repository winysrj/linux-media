Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:10690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab0I0Mdt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 08:33:49 -0400
Message-ID: <4CA08F20.1020905@redhat.com>
Date: Mon, 27 Sep 2010 09:33:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Felipe Sanches <juca@members.fsf.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>
Subject: Re: [PATCH v2] tm6000+audio
References: <20100622180521.614eb85d@glory.loctelecom.ru>	<4C20D91F.500@redhat.com>	<4C212A90.7070707@arcor.de>	<4C213257.6060101@redhat.com>	<4C222561.4040605@arcor.de>	<4C224753.2090109@redhat.com>	<4C225A5C.7050103@arcor.de>	<20100716161623.2f3314df@glory.loctelecom.ru>	<4C4C4DCA.1050505@redhat.com>	<20100728113158.0f1495c0@glory.loctelecom.ru>	<4C4FD659.9050309@arcor.de>	<20100729140936.5bddd275@glory.loctelecom.ru>	<4C51ADB5.7010906@redhat.com>	<20100731122428.4ee569b4@glory.loctelecom.ru>	<4C53A837.3070700@redhat.com>	<20100825043746.225a352a@glory.local>	<4C7543DA.1070307@redhat.com>	<AANLkTimr3=1QHzX3BzUVyo6uqLdCKt8SS9sDtHfZtHGZ@mail.gmail.com>	<4C767302.7070506@redhat.com>	<20100920160715.7594ee2e@glory.local>	<4C99177F.9060100@redhat.com>	<20100923124524.73a28b0c@glory.local>	<4C9ADEF6.4040809@redhat.com> <20100927134904.0ee9ca5b@glory.local>
In-Reply-To: <20100927134904.0ee9ca5b@glory.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 27-09-2010 14:49, Dmitri Belimov escreveu:
> Hi
> 
>> Em 23-09-2010 13:45, Dmitri Belimov escreveu:
>>> Hi
>>>
>>>> Em 20-09-2010 17:07, Dmitri Belimov escreveu:
>>>>> Hi 
>>>>>
>>>>> I rework my last patch for audio and now audio works well. This
>>>>> patch can be submited to GIT tree Quality of audio now is good for
>>>>> SECAM-DK. For other standard I set some value from datasheet need
>>>>> some tests.
>>>>>
>>>>> 1. Fix pcm buffer overflow
>>>>> 2. Rework pcm buffer fill method
>>>>> 3. Swap bytes in audio stream
>>>>> 4. Change some registers value for TM6010
>>>>> 5. Change pcm buffer size
>>>>> --- a/drivers/staging/tm6000/tm6000-stds.c
>>>>> +++ b/drivers/staging/tm6000/tm6000-stds.c
>>>>> @@ -96,6 +96,7 @@ static struct tm6000_std_tv_settings tv_stds[]
>>>>> = { 
>>>>>  			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL,
>>>>> 0xdc}, {TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
>>>>> +			{TM6010_REQ08_R05_A_STANDARD_MOD,
>>>>> 0x21}, /* FIXME */
>>>>
>>>> This didn't seem to work for PAL-M. Probably, the right value for
>>>> it is 0x22, to follow NTSC/M, since both uses the same audio
>>>> standard.
>>>>
>>>> On some tests, I was able to receive some audio there, at the
>>>> proper rate, with a tm6010-based device. It died when I tried to
>>>> change the channel, so I didn't rear yet the real audio, but I
>>>> suspect it will work on my next tests.
>>>>
>>>> Yet, is being hard to test, as the driver has a some spinlock logic
>>>> broken. I'm enclosing the logs.
>>>
>>> Yes. I have some as crash from mplayer and arecord.
>>>
>>>> I was able to test only when using a monitor on the same machine.
>>>> All trials of using vnc and X11 export ended by not receiving any
>>>> audio and hanging the machine.
>>>>
>>>> I suspect that we need to fix the spinlock issue, in order to
>>>> better test it.
>>>
>>> Who can fix it?
>>
>> Well, any of us ;)
>>
>> I did a BKL lock fix series of patches, and hverkuil is improving
>> them. They'll make easier to avoid problems inside tm6000. We just
>> need to make sure that we'll hold/release the proper locks at
>> tm6000-alsa, after applying it at the mainstream.
> 
> I found that mplayer crashed when call usb_control_msg and kfree functions.

Yeah, you can't call usb_control_msg at trigger callback. Some of those callbacks
seem to happen at IRQ time. With respect to kfree, that's weird.

The same troubles with alsa is also happening, at some extent, with em28xx and cx231xx.

I did a patch yesterday for cx231xx-audio to avoid using usb_control_msg (see enclosed).
This seems to solve part of the bugs, but I still got an OOPS when s_frequency call
happens while alsa is starting. So, I suspect that this patch, plus the ioctl locking
at the video part may solve the issue, but more tests are required.

Cheers,
Mauro.

commit 6ddc490d1b8ff01ddc1db8fc0a440d534fa13176
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Mon Sep 27 03:07:22 2010 -0300

    V4L/DVB: cx231xx-audio: fix some locking issues
    
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
index 2db8674..41e9eef 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -27,6 +27,7 @@
 #include <linux/ioctl.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
+#include <linux/workqueue.h>
 #include <linux/mutex.h>
 
 #include <media/cx2341x.h>
@@ -388,9 +389,6 @@ enum AUDIO_INPUT {
 #define CX231XX_AUDIO_BUFS              5
 #define CX231XX_NUM_AUDIO_PACKETS       16
 #define CX231XX_ISO_NUM_AUDIO_PACKETS	64
-#define CX231XX_CAPTURE_STREAM_EN       1
-#define CX231XX_STOP_AUDIO              0
-#define CX231XX_START_AUDIO             1
 
 /* cx231xx extensions */
 #define CX231XX_AUDIO                   0x10
@@ -408,7 +406,6 @@ struct cx231xx_audio {
 	struct snd_card *sndcard;
 
 	int users, shutdown;
-	enum cx231xx_stream_state capture_stream;
 	/* locks */
 	spinlock_t slock;
 
@@ -625,6 +622,9 @@ struct cx231xx {
 
 	struct cx231xx_IR *ir;
 
+	struct work_struct wq_trigger;		/* Trigger to start/stop audio for alsa module */
+	atomic_t	   stream_started;	/* stream should be running if true */
+
 	struct list_head devlist;
 
 	int tuner_type;		/* type of the tuner */

