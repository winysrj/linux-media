Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:49501 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932559AbZKNAwy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 19:52:54 -0500
Subject: Re: Tuner drivers
From: hermann pitton <hermann-pitton@arcor.de>
To: rulet1@meta.ua, Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1258143870.3242.31.camel@pc07.localdom.local>
References: <1258058273.8348.14.camel@pc07.localdom.local>
	 <49907.95.132.6.235.1258066094.metamail@webmail.meta.ua>
	 <1258073462.8348.35.camel@pc07.localdom.local>
	 <36685.95.133.109.178.1258107794.metamail@webmail.meta.ua>
	 <1258143870.3242.31.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Sat, 14 Nov 2009 01:52:35 +0100
Message-Id: <1258159955.3234.9.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

[snip]
> 
> That one came in over Mauro and he added the NEC gpio remote support.
> 
> http://linuxtv.org/hg/v4l-dvb/rev/fa0de4f2637a
> 
> If you are in Russia, you likely have to use "options saa7134 secam=DK"
> or modprobe the driver with that. Please read the output of "modinfo
> saa7134".
> 
> Enable audio_debug=1 for saa7134.
> 
> echo 1 > /sys/module/saa7134/parameters/audio_debug
> 
> If you switch the TV app to SECAM it should start to detect the DK audio
> carriers. Please report if this should still fail, since I can't test it
> myself. You see it in dmesg.
> 
> Also I can see in the Avermedia user manual that it has only analog
> audio in but no out.
> 
> You are forced to use saa7134-alsa dma sound.
> 
> Hope this helps.

since we are on such ;)


3.1 --- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Jun 26 17:03:00 2008 -0300
     3.2 +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Jun 26 17:03:00 2008 -0300
     3.3 @@ -3710,6 +3710,40 @@
     3.4  			.tv     = 1,
     3.5  		}},
     3.6  	},
     3.7 +	[SAA7134_BOARD_AVERMEDIA_M135A] = {
     3.8 +		.name           = "Avermedia PCI pure analog (M135A)",
     3.9 +		.audio_clock    = 0x00187de7,
    3.10 +		.tuner_type     = TUNER_PHILIPS_TDA8290,
    3.11 +		.radio_type     = UNSET,
    3.12 +		.tuner_addr     = ADDR_UNSET,
    3.13 +		.radio_addr     = ADDR_UNSET,
    3.14 +		.tuner_config   = 2,
    3.15 +		.gpiomask       = 0x020200000,
    3.16 +		.inputs         = {{

I guess the tuner_config = 2 might be bogus on that one?

Any tests previously ?

Cheers,
Hermann




