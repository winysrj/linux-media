Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:32934 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab1GTAzZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 20:55:25 -0400
Message-ID: <4E262772.9060509@infradead.org>
Date: Tue, 19 Jul 2011 21:55:14 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: Lennart Poettering <lpoetter@redhat.com>,
	linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru>
In-Reply-To: <4E25FDE4.7040805@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-07-2011 18:57, Stas Sergeev escreveu:
> 19.07.2011 23:29, Mauro Carvalho Chehab wrote:
>>> the additional element, they are fine already.
>>> We can rename it to "Master Capture Switch",
>>> or may not.
>> Adding a new volume control that changes the mute values for the other controls
>> or renaming it don't solve anything.
> The proposed solution is to have the mute
> control, that can be valid for all the cards/drivers.
> Presumably, it should have the similar name
> for all of them, even though for some it will be
> a "virtual" control that will control several items,
> and for others - it should map directly to their
> single mute control.
> If we have such a mute control, any app can use
> it,

Any app can do it right now via the V4L2 api.

> and the auto-unmute logic can be removed
> from the alsa driver. v4l2 is left as it is now.

What is the sense of capturing data for a device that is not ready
for stream? PA is doing the wrong thing here, due to the lack of a
better API support: it is starting stream on a device as a hacky way
of probing it. As Lennart pointed, even considering a pure audio device,
this is ugly and takes time.

IMO, the right long term fix is to provide alsa some ioctl that allows
PA to get the needed info without needing to start streaming, and, for
the short term, to prevent it to start capture on tuner/grabber devices.

> So that's the proposal, what problems can you see
> with it?

Userspace application breakage is not allowed. A change like
that will break the existing applications like mplayer.

>>> So, am I right that the only problem is that it is not
>>> exported to the user by some _alsa_ drivers right now?
>> I fail to see why this would be a problem.
> But that was the problem _you_ named.
> That is, that right now the app will have difficulties
> unmuting the complex boards via the alsa interface,
> because it will have to unmute several items instead
> of one.
> I propose to add the single item for that, except for
> the drivers that already have only one mute switch.
> With this, the problem you named, seems to be solved.
> And then, perhaps, the auto-unmute logic can go away.
> What am I missing?
> 
>> It is doable, although it is probably not trivial.
>> Devices with saa7130 (PCI_DEVICE_ID_PHILIPS_SAA7130) doesn't enable the
>> alsa module, as they don't support I2S transfers, required for PCM audio.
>> So, we need to take care only on saa7133/4/5 devices.
>>
>> The mute code is at saa7134-tvaudio.c, mute_input_7134() function. For
>> saa7134, it does:
>>
>>          if (PCI_DEVICE_ID_PHILIPS_SAA7134 == dev->pci->device)
>>                  /* 7134 mute */
>>                  saa_writeb(SAA7134_AUDIO_MUTE_CTRL, mute ?
>>                                                      SAA7134_MUTE_MASK |
>>                                                      SAA7134_MUTE_ANALOG |
>>                                                      SAA7134_MUTE_I2S :
>>                                                      SAA7134_MUTE_MASK);
>>
>> Clearly, there are two mute flags: SAA7134_MUTE_ANALOG and SAA7134_MUTE_I2S.
> I was actually already playing with that piece of
> code, and got no results. Will retry the next week-end
> to see exactly why...

Maybe your device is not a saa7134. For saa7133/saa7135, the
mute/unmute seems to be done via GPIO, and via amux.

> IIRC the problem was that this does not mute the
> sound input from the back panel of the board, which
> would then still go to the pass-through wire in case
> you are capturing. The only way do mute it, was to
> configure muxes the way you can't capture at the
> same time. But I may be wrong with the recollections.

Well, the change seems to be simple, as we don't actually need to
split the mute. We just need to control the I2S input/output at
the alsa driver.

The enclosed patch probably does the trick (completely untested).

As I said before, before adding this patch upstream, we need to double
check if it will work with saa7134, saa7133 and saa7135, preserving
the old behavior on those devices.

-

saa7134: Don't touch at the analog mute at the alsa driver

Instead of setting both analog and digital parts of the driver, alsa
just needs to enable/disable the I2S capture.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


diff --git a/drivers/media/video/saa7134/saa7134-alsa.c b/drivers/media/video/saa7134/saa7134-alsa.c
index 10460fd..2edcdd2 100644
--- a/drivers/media/video/saa7134/saa7134-alsa.c
+++ b/drivers/media/video/saa7134/saa7134-alsa.c
@@ -720,7 +720,7 @@ static int snd_card_saa7134_capture_close(struct snd_pcm_substream * substream)
 
 	if (saa7134->mute_was_on) {
 		dev->ctl_mute = 1;
-		saa7134_tvaudio_setmute(dev);
+		saa7134_i2s_mute(dev, dev->ctl_mute);
 	}
 	return 0;
 }
@@ -777,7 +777,7 @@ static int snd_card_saa7134_capture_open(struct snd_pcm_substream * substream)
 	if (dev->ctl_mute != 0) {
 		saa7134->mute_was_on = 1;
 		dev->ctl_mute = 0;
-		saa7134_tvaudio_setmute(dev);
+		saa7134_i2s_mute(dev, dev->ctl_mute);
 	}
 
 	err = snd_pcm_hw_constraint_integer(runtime,
diff --git a/drivers/media/video/saa7134/saa7134-tvaudio.c b/drivers/media/video/saa7134/saa7134-tvaudio.c
index 57e646b..9cc81ed 100644
--- a/drivers/media/video/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/video/saa7134/saa7134-tvaudio.c
@@ -184,6 +184,15 @@ static void tvaudio_setcarrier(struct saa7134_dev *dev,
 #define SAA7134_MUTE_ANALOG 0x04
 #define SAA7134_MUTE_I2S 0x40
 
+void saa7134_i2s_mute(struct saa7134_dev *dev, unsigned int mute)
+{
+	if (PCI_DEVICE_ID_PHILIPS_SAA7134 == dev->pci->device)
+		saa_andorb(SAA7134_AUDIO_FORMAT_CTRL, SAA7134_MUTE_I2S,
+			   mute ? SAA7134_MUTE_I2S : 0);
+	else
+	    saa_writeb(SAA7134_I2S_AUDIO_OUTPUT, mute ? 0x11 : 0);
+}
+
 static void mute_input_7134(struct saa7134_dev *dev)
 {
 	unsigned int mute;
@@ -220,10 +229,11 @@ static void mute_input_7134(struct saa7134_dev *dev)
 		/* 7134 mute */
 		saa_writeb(SAA7134_AUDIO_MUTE_CTRL, mute ?
 						    SAA7134_MUTE_MASK |
-						    SAA7134_MUTE_ANALOG |
-						    SAA7134_MUTE_I2S :
+						    SAA7134_MUTE_ANALOG :
 						    SAA7134_MUTE_MASK);
 
+	saa7134_i2s_mute(dev, mute);
+
 	/* switch internal audio mux */
 	switch (in->amux) {
 	case TV:         ausel=0xc0; ics=0x00; ocs=0x02; break;
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index bc8d6bb..7b104cc 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -821,6 +821,7 @@ int saa7134_tvaudio_do_scan(struct saa7134_dev *dev);
 int saa_dsp_writel(struct saa7134_dev *dev, int reg, u32 value);
 
 void saa7134_enable_i2s(struct saa7134_dev *dev);
+void saa7134_i2s_mute(struct saa7134_dev *dev, unsigned int mute);
 
 /* ----------------------------------------------------------- */
 /* saa7134-oss.c                                               */


