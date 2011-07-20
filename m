Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48403 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1GTKcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2011 06:32:41 -0400
Message-ID: <4E26AEC0.5000405@infradead.org>
Date: Wed, 20 Jul 2011 07:32:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: Lennart Poettering <lpoetter@redhat.com>,
	linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru>
In-Reply-To: <4E266799.8030706@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-07-2011 02:28, Stas Sergeev escreveu:
> 20.07.2011 04:55, Mauro Carvalho Chehab wrote:
>>> The proposed solution is to have the mute
>>> control, that can be valid for all the cards/drivers.
>>> Presumably, it should have the similar name
>>> for all of them, even though for some it will be
>>> a "virtual" control that will control several items,
>>> and for others - it should map directly to their
>>> single mute control.
>>> If we have such a mute control, any app can use
>>> it,
>> Any app can do it right now via the V4L2 api.
> I am just following your logic, you said that
> ---
> Moving such logic to happen at userspace would be very complex, and will
> break existing applications.
> ---
> To solve that, I proposed adding such mixer control
> to where it is missing right now.
> But if this is no longer a problem and the app
> can just use v4l2 for that instead, then what still
> keeps us from removing the auto-unmute things?

I won't keep discussing something that won't be merged, as it will
cause regressions.

>>> and the auto-unmute logic can be removed
>>> from the alsa driver. v4l2 is left as it is now.
>> What is the sense of capturing data for a device that is not ready
>> for stream?
> This may be a PA's hack, or a user's mistake, or
> whatever, but whatever it is, it shouldn't lead to
> any sounds from speakers. Just starting the capture,
> willingly or by mistake, should never lead to any
> sound from speakers, IMO. So that's the bug too.
> And the simpler one to fix.

If the application is starting streaming, audio should be expected on devices 
where the audio output is internally wired with the capture input.
This seems to be the case of your device. There's nothing that can be
done to fix a bad hardware design or the lack of enough information
from the device manufacturer.

>> The enclosed patch probably does the trick (completely untested).
> I'll be able to test it on avertv 307 the next week-end.

The patch is not that simple. The driver needs to set the device inputs
accordingly, otherwise it will break support for digital audio. 

In the specific case of avertv 307, this patch alone may not work. I suspect
that there is a problem at the GPIO settings for mute on its board entry:

[SAA7134_BOARD_AVERMEDIA_STUDIO_307] = {
...
                .inputs         = {{
                        .name = name_tv,
                        .vmux = 1,
                        .amux = TV,
                        .tv   = 1,
                        .gpio = 0x00,
                },{
...
                .mute  = {
                        .name = name_mute,
                        .amux = LINE1,
                        .gpio = 0x00,
                },


See: mute GPIO's are equal for TV GPIO. That means that it will select the
TV gpio for "mute".

-

[PATCHv2 - BROKEN] saa7134: Don't touch at the analog mute at the alsa driver

Via the alsa driver, it is possible to start capturing from an audio input.
When capture is started, the driver will unmute the audio input associated
with the selected video input, if it were muted. 

However, if the device is using a wire for the audio output, it may produce 
audio at the speakers. This patch changes the mute logic to:
	1) on saa7134, don't touch at the ANALOG_MUTE at alsa unmute call;
	2) don't change the GPIO's.

I suspect, however, that not changing the GPIO's is a very bad idea, and
it will actually break audio for devices with external GPIO-based input
switches, but, as this version was already done, it might be useful for some
tests. A version 3 will follow shortly.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


diff --git a/drivers/media/video/saa7134/saa7134-alsa.c b/drivers/media/video/saa7134/saa7134-alsa.c
index 10460fd..cbc665a 100644
--- a/drivers/media/video/saa7134/saa7134-alsa.c
+++ b/drivers/media/video/saa7134/saa7134-alsa.c
@@ -77,7 +77,6 @@ typedef struct snd_card_saa7134 {
 
 	unsigned long iobase;
 	s16 irq;
-	u16 mute_was_on;
 
 	spinlock_t lock;
 } snd_card_saa7134_t;
@@ -718,9 +717,10 @@ static int snd_card_saa7134_capture_close(struct snd_pcm_substream * substream)
 	snd_card_saa7134_t *saa7134 = snd_pcm_substream_chip(substream);
 	struct saa7134_dev *dev = saa7134->dev;
 
-	if (saa7134->mute_was_on) {
+	if (dev->mute_was_on) {
 		dev->ctl_mute = 1;
 		saa7134_tvaudio_setmute(dev);
+		dev->mute_was_on = false;
 	}
 	return 0;
 }
@@ -775,7 +775,7 @@ static int snd_card_saa7134_capture_open(struct snd_pcm_substream * substream)
 	runtime->hw = snd_card_saa7134_capture;
 
 	if (dev->ctl_mute != 0) {
-		saa7134->mute_was_on = 1;
+		dev->mute_was_on = true;
 		dev->ctl_mute = 0;
 		saa7134_tvaudio_setmute(dev);
 	}
diff --git a/drivers/media/video/saa7134/saa7134-tvaudio.c b/drivers/media/video/saa7134/saa7134-tvaudio.c
index 57e646b..535aa75 100644
--- a/drivers/media/video/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/video/saa7134/saa7134-tvaudio.c
@@ -190,6 +190,9 @@ static void mute_input_7134(struct saa7134_dev *dev)
 	struct saa7134_input *in;
 	int ausel=0, ics=0, ocs=0;
 	int mask;
+	bool change_analog_mute;
+
+	change_analog_mute = dev->mute_was_on ? false : true;
 
 	/* look what is to do ... */
 	in   = dev->input;
@@ -204,7 +207,8 @@ static void mute_input_7134(struct saa7134_dev *dev)
 			in = &card(dev).mute;
 	}
 
-	if (dev->hw_mute  == mute &&
+
+	if (dev->hw_mute  == mute && !dev->mute_was_on &&
 		dev->hw_input == in && !dev->insuspend) {
 		dprintk("mute/input: nothing to do [mute=%d,input=%s]\n",
 			mute,in->name);
@@ -216,13 +220,18 @@ static void mute_input_7134(struct saa7134_dev *dev)
 	dev->hw_mute  = mute;
 	dev->hw_input = in;
 
-	if (PCI_DEVICE_ID_PHILIPS_SAA7134 == dev->pci->device)
+	if (PCI_DEVICE_ID_PHILIPS_SAA7134 == dev->pci->device) {
+		u32 mask = ~0;
+		u32 mute_val = SAA7134_MUTE_MASK;
+
+		if (!change_analog_mute)
+			mask ^= SAA7134_MUTE_ANALOG;
+		if (mute)
+			mute_val |= SAA7134_MUTE_I2S | SAA7134_MUTE_ANALOG;
+
 		/* 7134 mute */
-		saa_writeb(SAA7134_AUDIO_MUTE_CTRL, mute ?
-						    SAA7134_MUTE_MASK |
-						    SAA7134_MUTE_ANALOG |
-						    SAA7134_MUTE_I2S :
-						    SAA7134_MUTE_MASK);
+		saa_andorb(SAA7134_AUDIO_MUTE_CTRL, mask, mute_val);
+	}
 
 	/* switch internal audio mux */
 	switch (in->amux) {
@@ -241,7 +250,7 @@ static void mute_input_7134(struct saa7134_dev *dev)
 		saa_andorb(SAA7134_SIF_SAMPLE_FREQ,   0x03, 0x01);
 
 	/* switch gpio-connected external audio mux */
-	if (0 == card(dev).gpiomask)
+	if (0 == card(dev).gpiomask || !change_analog_mute)
 		return;
 
 	mask = card(dev).gpiomask;
@@ -725,6 +734,9 @@ static int mute_input_7133(struct saa7134_dev *dev)
 	u32 xbarin, xbarout;
 	int mask;
 	struct saa7134_input *in;
+	bool change_analog_mute;
+
+	change_analog_mute = dev->mute_was_on ? false : true;
 
 	xbarin = 0x03;
 	switch (dev->input->amux) {
@@ -750,9 +762,8 @@ static int mute_input_7133(struct saa7134_dev *dev)
 
 	saa_writel(0x594 >> 2, reg);
 
-
 	/* switch gpio-connected external audio mux */
-	if (0 != card(dev).gpiomask) {
+	if (0 != card(dev).gpiomask && change_analog_mute) {
 		mask = card(dev).gpiomask;
 
 		if (card(dev).mute.name && dev->ctl_mute)
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index bc8d6bb..ae34f68 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -602,6 +602,7 @@ struct saa7134_dev {
 	int                        ctl_saturation;
 	int                        ctl_freq;
 	int                        ctl_mute;             /* audio */
+	bool			   mute_was_on;
 	int                        ctl_volume;
 	int                        ctl_invert;           /* private */
 	int                        ctl_mirror;
