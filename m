Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:57464 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573AbZECWiP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2009 18:38:15 -0400
Subject: Re: saa7134/2.6.26 regression, noisy output
From: hermann pitton <hermann-pitton@arcor.de>
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: linux-media@vger.kernel.org, video4linux-list@redhat.com,
	kraxel@bytesex.org
In-Reply-To: <20090503075609.0A73B2C4152@tippex.mynet.homeunix.org>
References: <20090503075609.0A73B2C4152@tippex.mynet.homeunix.org>
Content-Type: text/plain
Date: Mon, 04 May 2009 00:32:05 +0200
Message-Id: <1241389925.4912.32.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Anders,

Am Sonntag, den 03.05.2009, 09:56 +0200 schrieb Anders Eriksson:
> Hi all,
> 
> I've got a
> saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV 310i [card=101,autodetected]
> 
> In all kernels later than 2.6.25 there is a significant layer of noise added to
> the video output. I've tried to bisect the problem, and it was introduced
> somewhere between  1fe8736955515f5075bef05c366b2d145d29cd44 (good) and
> 99e09eac25f752b25f65392da7bd747b77040fea (bad). Unfortunately, all commits
> between those two either don't compile, or oops in the v4l subsystem.
> 
> I've tried the latest 30-rc and the problem is still there. Any idea how to 
> proceed for here? I can provide screenshots on request.
> 
> Here's the relevant chunk from demsg on 2.6.25:
> Linux video capture interface: v2.00
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7133[0]: found at 0000:03:06.0, rev: 209, irq: 21, latency: 64, mmio: 0xfdeff000
> saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV 310i [card=101,autodetected]
> saa7133[0]: board init: gpio is 600c000
> saa7133[0]: i2c eeprom 00: bd 11 2f 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7133[0]: i2c eeprom 10: ff e0 60 06 ff 20 ff ff 00 30 8d 36 5b e2 ff ff
> saa7133[0]: i2c eeprom 20: 01 2c 01 23 23 01 04 30 98 ff 00 e7 ff 21 00 c2
> saa7133[0]: i2c eeprom 30: 96 10 03 32 15 20 ff 15 0e 6c a3 eb 04 50 de 7d
> saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tuner' 1-004b: chip found @ 0x96 (saa7133[0])
> tda8290 1-004b: setting tuner address to 61
> tda8290 1-004b: type set to tda8290+75a
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: registered device radio0
> saa7134 ALSA driver for DMA sound loaded
> saa7133[0]/alsa: saa7133[0] at 0xfdeff000 irq 21 registered as card -1
> DVB: registering new adapter (saa7133[0])
> DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision 20 -- ok
> 

can confirm that such a regression on this card was already reported.

Hartmut, who added also support for this board, mentioned that it might
be caused be a failing configuration of the extra LowNoiseAmplifier it
has.

We know three types of LNAs so far which have different requirements to
be configured. Your card uses type one, for the others are no problems
reported and I saw Mike added recently some new cards with type three.

However, there is just one more card sharing that type_one configuration
with yours, the first version of the HVR-1110, and still no reports from
that one in that direction.

You should try to set the LNA config to type 0, no LNA, also on 2.6.25 I
guess, to see if it might be related.

In saa7134-cards.c for analog it is tuner_config.

	[SAA7134_BOARD_PINNACLE_PCTV_310i] = {
		.name           = "Pinnacle PCTV 310i",
		.audio_clock    = 0x00187de7,
		.tuner_type     = TUNER_PHILIPS_TDA8290,
		.radio_type     = UNSET,
		.tuner_addr     = ADDR_UNSET,
		.radio_addr     = ADDR_UNSET,
		.tuner_config   = 1,
		.mpeg           = SAA7134_MPEG_DVB,
		.gpiomask       = 0x000200000,
		.inputs         = {{

In current saa7134-dvb.c you change tda827x_cfg_1 to tda827x_cfg_0.

	case SAA7134_BOARD_PINNACLE_PCTV_310i:
		if (configure_tda827x_fe(dev, &pinnacle_pctv_310i_config,
					 &tda827x_cfg_1) < 0)
			goto dettach_frontend;
		break;

On older kernels it is also tuner_config there within
pinnacle_pctv_310i_config.

Unfortunately Gerd is not active anymore since several years on v4l-dvb
and we should not molest him with later added stuff.

Cheers,
Hermann







