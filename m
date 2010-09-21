Return-path: <mchehab@pedra>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:57740 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795Ab0IUX1Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 19:27:24 -0400
Subject: Re: [linux-dvb] Asus MyCinema P7131 Dual support
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <AANLkTikf0hp8nXzovvdn0j_80Dcirr1a-EMH9sDDGEoX@mail.gmail.com>
References: <AANLkTikf0hp8nXzovvdn0j_80Dcirr1a-EMH9sDDGEoX@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 22 Sep 2010 01:13:00 +0200
Message-Id: <1285110780.5561.18.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Dejan,

Am Dienstag, den 21.09.2010, 10:07 +0200 schrieb Dejan Rodiger:
> Hi,
> 
> I am using Ubuntu linux 10.10 with the latest kernel 2.6.35-22-generic
> on x86_64. I have installed nonfree firmware which should support this
> card, but to be sure, can somebody confirm that my TV card is
> supported in Analog or DVB mode?
> 
> sudo lspci -vnn
> 01:06.0 Multimedia controller [0480]: Philips Semiconductors
> SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
>         Subsystem: ASUSTeK Computer Inc. My Cinema-P7131 Hybrid
> [1043:4876]
>         Flags: bus master, medium devsel, latency 32, IRQ 18
>         Memory at fdeff000 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: [40] Power Management version 2
>         Kernel driver in use: saa7134
>         Kernel modules: saa7134
> 
> It says Hybrid, but I put the following in
> the /etc/modprobe.d/saa7134.conf
> options saa7134 card=78 tuner=54
> 
> 
> Thanks
> -- 
> Dejan Rodiger
> S: callto://drodiger

don't have time to follow this closely anymore.

But forcing it to card=78 is plain wrong. It has an early additional LNA
in confirmed config = 2 status.

Your card should be auto detected and previously always was, based on
what we have in saa7134-cards.c and further for it. (saa7134-dvb and
related tuner/demod stuff)

	}, {
		.vendor       = PCI_VENDOR_ID_PHILIPS,
		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
		.subvendor    = 0x1043,
		.subdevice    = 0x4876,
		.driver_data  = SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA,
	},{

I remember for sure, that this card was fully functional for all use
cases and it was not easy to get it there. I don't have it.

Please provide the "dmesg" for failing auto detection without forcing
some card = number as a starting point.

I for sure want to see this board fully functional again.

Cheers,
Hermann








