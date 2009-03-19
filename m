Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:55963 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbZCSULc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 16:11:32 -0400
Date: Thu, 19 Mar 2009 13:11:29 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
Subject: Re: The right way to interpret the content of SNR, signal strength
 	and BER from HVR 4000 Lite
In-Reply-To: <20090319101601.2eba0397@pedra.chehab.org>
Message-ID: <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>
References: <49B9BC93.8060906@nav6.org> <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
 <49B9DECC.5090102@nav6.org> <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
 <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>
 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
 <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>
 <20090319101601.2eba0397@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Mar 2009, Mauro Carvalho Chehab wrote:
> that we should discuss about it for some time, comparing each alternatives we
> have, focused on SNR only. Later, use can use the same approach for the
> other quality measurements on DVB.
>
> In order to start such discussions, I'm summarizing both proposals under the
> same perspective.
>
> I'm also presenting some criteria that are important on this scope
>
> People are welcome to contribute and to argue in favor/against each one.
>

> So, on both proposals, we have 1 bit for signal and 15 bits to be used for
> storing the absolute numbering representation.

One could always use a normal 2's complement signed number to indicate
negative SNR.  The only problem was the structure uses a u16 instead of an
s16.

> The SNR(dB) will be given by:
> 	SNR(dB) = driver_SNR_measure / 10;

Since the driver often needs to use a logarithm from dvb-math to find SNR,
you have code like this in the driver (from lgdt3305.c):
        /* report SNR in dB * 10 */
        *snr = (state->snr / ((1 << 24) / 10));

> The SNR(dB) will be given by:
> 	SNR(dB) = driver_SNR_measure / 256;

For the driver side, also from lgdt3305 which has both formats with an
ifdef:
        /* convert from 8.24 fixed-point to 8.8 */
        *snr = (state->snr) >> 16;

FWIW, converting to decimal to print using only integer math:

	/* decimal fixed point */
	printf("%d.%d dB\n", snr / 10, snr % 10);

	/* binary fixed point */
	printf("%d.%02d dB\n", snr >> 8, (snr & 0xff) * 100 >> 8);

On modern CPUs, integer division and modulus are by far the most
expensive operations, so the latter is probably faster since it replaces
two div/mod operations by a single integer multiply (cheaper than
division) and three much cheaper shifts or masks.

> Also, due to historical reasons, the frequency is represented as a 62.5 Hz step
> (or 62.5 kHz step, depending on a capability field), and this works fine: all

One could say the v4l1/2 use frequency in MHz in 28.4 binary fixed point.
