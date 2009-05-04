Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:35080 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754838AbZEDTwx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2009 15:52:53 -0400
To: hermann pitton <hermann-pitton@arcor.de>
cc: linux-media@vger.kernel.org, video4linux-list@redhat.com,
	kraxel@bytesex.org
Subject: Re: saa7134/2.6.26 regression, noisy output
In-reply-to: <1241438755.3759.100.camel@pc07.localdom.local>
References: <20090503075609.0A73B2C4152@tippex.mynet.homeunix.org> <1241389925.4912.32.camel@pc07.localdom.local> <20090504091049.D931B2C4147@tippex.mynet.homeunix.org> <1241438755.3759.100.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 04 May 2009 21:52:01 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20090504195201.6ECF52C415B@tippex.mynet.homeunix.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hi hermann,

hermann-pitton@arcor.de said:
> There is no way to detect which sort of such a LNA circuitry is employed.
> Just try and error and pray. Also no further documentation for the changing
> code itself and only some comments by Hartmut on the lists.
>
> In case config = 1 gpio0 of the tda827x is involved, on others a gpio pin of
> the saa7134 and some registers.
>
> It was already broken when tuner callback stuff for XCeive tuners was
> introduced and firmware loading for those.
>
> Guess the problem is to get the gpio change to the tda827x through.
>
> Hartmut came up with this fix that time you get with "hg export 7393".
> (attached)
>
> I did not even have any such a LNA device at this time, but might be
> interesting if this snapshot really works for you. Still have only one type 2
> device now.
>
> If I look through hg log > hg.log, the only somehow related later change by
> Hartmut was this one. (link points to Hartmut's repo)
>
> http://linuxtv.org/hg/~hhackmann/v4l-dvb/rev/779169257208
>
> And last entry is that compile warning fix on top for int mask not removed at
> once. Should all be only saa7134 gpio related.


I had a look at the diff you attached, and it made me a bit confuse. Most 
(all?) of it seem to be already applied in later kernels (>2.6.26), and they 
all fail on me.

however, looking through the diff, I sumbled on the dprink's and I started to 
enable them on all modules I thought relevant. Here's a diff between the last
-good and first-bad commit. The salient differences I can see is the "AGC2 gain"
and the "setting GPIO22 to vsync 0". I have no clue what they mean, but my 
next step is to see if I can kill these differences.

Is thee anything else in there which you find note worthy?

Rgds,
/Anders
PS What is the tda829x doing? I see some differences there too.

$ diff -u dmesg_2.6.25-03{6,7}* 
--- dmesg_2.6.25-03622-g1fe87369        2009-05-04 21:32:37.000000000 +0200
+++ dmesg_2.6.25-03774-g99e09ea 2009-05-04 21:37:06.000000000 +0200
@@ -42,14 +42,13 @@
 tda829x 1-004b: tda827xa config is 0x01
 tda827x: setting tda827x to system xx
 tda827x: setting LNA to high gain
-saa7133[0]/core: setting GPIO22 to vsync 0
-tda827x: AGC2 gain is: 3
+tda827x: AGC2 gain is: 10
 tda829x 1-004b: tda8290 not locked, no signal?
 tda829x 1-004b: tda8290 not locked, no signal?
 tda829x 1-004b: tda8290 not locked, no signal?
-tda829x 1-004b: adjust gain, step 1. Agc: 0, ADC stat: 0, lock: 0
-tda829x 1-004b: adjust gain, step 2. Agc: 131, lock: 0
-tda829x 1-004b: adjust gain, step 3. Agc: 44
+tda829x 1-004b: adjust gain, step 1. Agc: 0, ADC stat: 1, lock: 0
+tda829x 1-004b: adjust gain, step 2. Agc: 255, lock: 0
+tda829x 1-004b: adjust gain, step 3. Agc: 235
 tuner' 1-004b: saa7133[0] tuner' I2C addr 0x96 with type 54 used for 0x0e
 saa7133[0]/core: hwinit2
 tuner' 1-004b: switching to v4l2
@@ -58,8 +57,7 @@
 tda829x 1-004b: tda827xa config is 0x01
 tda827x: setting tda827x to system B
 tda827x: setting LNA to high gain
-saa7133[0]/core: setting GPIO22 to vsync 0
-tda827x: AGC2 gain is: 3
+tda827x: AGC2 gain is: 10
 tda829x 1-004b: tda8290 not locked, no signal?
 tda829x 1-004b: tda8290 not locked, no signal?
 tda829x 1-004b: tda8290 not locked, no signal?
@@ -68,14 +66,13 @@
 tda829x 1-004b: tda827xa config is 0x01
 tda827x: setting tda827x to system B
 tda827x: setting LNA to high gain
-saa7133[0]/core: setting GPIO22 to vsync 0
-tda827x: AGC2 gain is: 3
+tda827x: AGC2 gain is: 10
 tda829x 1-004b: tda8290 not locked, no signal?
 tda829x 1-004b: tda8290 not locked, no signal?
 tda829x 1-004b: tda8290 not locked, no signal?
 tda829x 1-004b: adjust gain, step 1. Agc: 136, ADC stat: 40, lock: 0
-tda829x 1-004b: adjust gain, step 2. Agc: 0, lock: 0
-tda829x 1-004b: adjust gain, step 3. Agc: 248
+tda829x 1-004b: adjust gain, step 2. Agc: 126, lock: 0
+tda829x 1-004b: adjust gain, step 3. Agc: 35
 saa7133[0]: registered device video0 [v4l2]
 saa7133[0]: registered device vbi0
 saa7133[0]: registered device radio0
@@ -90,15 +87,19 @@
 DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
 tda827x: setting tda827x to system B
 tda827x: setting LNA to high gain
-saa7133[0]/core: setting GPIO22 to vsync 0
 tda1004x: setting up plls for 48MHz sampling clock
-tda827x: AGC2 gain is: 3
+tda827x: AGC2 gain is: 10
+tda1004x: found firmware revision 20 -- ok
+tda827x: tda827xa tuner found
+tda827x: tda827xa_sleep:
+saa7134 ALSA driver for DMA sound loaded
+saa7133[0]/alsa: saa7133[0] at 0xfdeff000 irq 21 registered as card -1
 tda829x 1-004b: tda8290 not locked, no signal?
 tda829x 1-004b: tda8290 not locked, no signal?
 tda829x 1-004b: tda8290 not locked, no signal?
 tda829x 1-004b: adjust gain, step 1. Agc: 0, ADC stat: 1, lock: 0
-tda829x 1-004b: adjust gain, step 2. Agc: 255, lock: 0
-tda829x 1-004b: adjust gain, step 3. Agc: 202
+tda829x 1-004b: adjust gain, step 2. Agc: 128, lock: 0
+tda829x 1-004b: adjust gain, step 3. Agc: 128
 tuner' 1-004b: Cmd TUNER_SET_STANDBY accepted for analog TV
 tuner' 1-004b: Cmd VIDIOC_S_STD accepted for analog TV
 tuner' 1-004b: tv freq set to 400.00
@@ -106,17 +107,13 @@
 tda829x 1-004b: tda827xa config is 0x01
 tda827x: setting tda827x to system B
 tda827x: setting LNA to high gain
-saa7133[0]/core: setting GPIO22 to vsync 0
-tda827x: AGC2 gain is: 3
+tda827x: AGC2 gain is: 10
 tda829x 1-004b: tda8290 not locked, no signal?
 tda829x 1-004b: tda8290 not locked, no signal?
 tda829x 1-004b: tda8290 not locked, no signal?
-tda829x 1-004b: adjust gain, step 1. Agc: 0, ADC stat: 0, lock: 0
-tda829x 1-004b: adjust gain, step 2. Agc: 135, lock: 0
-tda1004x: timeout waiting for DSP ready
-tda1004x: found firmware revision 0 -- invalid
-tda1004x: trying to boot from eeprom
-tda829x 1-004b: adjust gain, step 3. Agc: 22
+tda829x 1-004b: adjust gain, step 1. Agc: 0, ADC stat: 1, lock: 0
+tda829x 1-004b: adjust gain, step 2. Agc: 255, lock: 0
+tda829x 1-004b: adjust gain, step 3. Agc: 243
 tuner' 1-004b: Cmd TUNER_SET_STANDBY accepted for analog TV
 tuner' 1-004b: Cmd AUDC_SET_RADIO accepted for radio
 tuner' 1-004b: radio freq set to 87.50
@@ -124,18 +121,8 @@
 tda829x 1-004b: tda827xa config is 0x01
 tda827x: setting tda827x to system B
 tda827x: setting LNA to high gain
-saa7133[0]/core: setting GPIO22 to vsync 0
 tda827x: AGC2 gain is: 10
 tda829x 1-004b: tda8290 not locked, no signal?
 tda829x 1-004b: tda8290 not locked, no signal?
 tda829x 1-004b: tda8290 not locked, no signal?
 tuner' 1-004b: Cmd TUNER_SET_STANDBY accepted for radio
-tda1004x: timeout waiting for DSP ready
-tda1004x: found firmware revision 0 -- invalid
-tda1004x: waiting for firmware upload...
-tda1004x: found firmware revision 20 -- ok
-tda827x: tda827xa tuner found
-tda827x: tda827xa_sleep:
-saa7134 ALSA driver for DMA sound loaded
-saa7133[0]/alsa: saa7133[0] at 0xfdeff000 irq 21 registered as card -1
-


