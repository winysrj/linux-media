Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab1GTKmK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2011 06:42:10 -0400
Message-ID: <4E26B0F5.8080300@redhat.com>
Date: Wed, 20 Jul 2011 07:41:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: Lennart Poettering <lpoetter@redhat.com>,
	linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org>
In-Reply-To: <4E26AEC0.5000405@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-07-2011 07:32, Mauro Carvalho Chehab escreveu:
> Em 20-07-2011 02:28, Stas Sergeev escreveu:
>> 20.07.2011 04:55, Mauro Carvalho Chehab wrote:

> [PATCHv2 - BROKEN] saa7134: Don't touch at the analog mute at the alsa driver
> 
> Via the alsa driver, it is possible to start capturing from an audio input.
> When capture is started, the driver will unmute the audio input associated
> with the selected video input, if it were muted. 
> 
> However, if the device is using a wire for the audio output, it may produce 
> audio at the speakers. This patch changes the mute logic to:
> 	1) on saa7134, don't touch at the ANALOG_MUTE at alsa unmute call;
> 	2) don't change the GPIO's.
> 
> I suspect, however, that not changing the GPIO's is a very bad idea, and
> it will actually break audio for devices with external GPIO-based input
> switches, but, as this version was already done, it might be useful for some
> tests. A version 3 will follow shortly.

[PATCHv3] saa7134: Don't touch at the analog mute at the alsa driver

Via the alsa driver, it is possible to start capturing from an audio input.
When capture is started, the driver will unmute the audio input associated
with the selected video input, if it were muted. 

However, if the device is using a wire for the audio output, it may produce 
audio at the speakers. This patch changes the mute logic to don't touch 
at the ANALOG_MUTE at alsa unmute call, for saa7134. Not sure if this will
produce any effect, as it will depend on how the board is wired, but it is 
a worth trial.

Patch is untested.

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
index 57e646b..11631f4 100644
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




