Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:50329 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbZCSWRU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 18:17:20 -0400
Date: Thu, 19 Mar 2009 15:17:18 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
Subject: Re: The right way to interpret the content of SNR, signal strength
 	and BER from HVR 4000 Lite
In-Reply-To: <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>
Message-ID: <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>
References: <49B9BC93.8060906@nav6.org> <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
 <49B9DECC.5090102@nav6.org> <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
 <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>
 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
 <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>
 <20090319101601.2eba0397@pedra.chehab.org> <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Mar 2009, Trent Piepho wrote:
> Since the driver often needs to use a logarithm from dvb-math to find SNR,
> you have code like this in the driver (from lgdt3305.c):
>         /* report SNR in dB * 10 */
>         *snr = (state->snr / ((1 << 24) / 10));
>
> > The SNR(dB) will be given by:
> > 	SNR(dB) = driver_SNR_measure / 256;
>
> For the driver side, also from lgdt3305 which has both formats with an
> ifdef:
>         /* convert from 8.24 fixed-point to 8.8 */
>         *snr = (state->snr) >> 16;
>
> FWIW, converting to decimal to print using only integer math:
>
> 	/* decimal fixed point */
> 	printf("%d.%d dB\n", snr / 10, snr % 10);
>
> 	/* binary fixed point */
> 	printf("%d.%02d dB\n", snr >> 8, (snr & 0xff) * 100 >> 8);

One more example, converting SNR into a 32-bit floating point number using
only integer operations.  These don't do negative numbers but if the SNR
format used a sign bit it would be very easy to add, as IEEE 754 floating
point uses a sign bit too.  I would need to think about it more to do 2's
complement.

For binary fixed point the conversion to a float is exact.  For decimal
fixed point it's not.  For example 334 (33.4 dB) will become 33.400002 dB
when converted to floating point.

/* For 8.8 binary fixed point, this is the no-float version of:
 * float snr_to_float(u16 snr) { return snr / 256.0 } */
u32 snr_to_float(u16 snr)
{
        unsigned int e = 23 - __fls(snr);
        return snr ? ((snr << e) & 0x7fffff) | ((142 - e) << 23) : 0;
}

/* For .1 decimal fixed point.  NOTE:  This will overflow the 32-bit
 * intermediate value if SNR is above 1638.3 dB!  This is the no-float
 * version of:
 * float snr_to_float(u16 snr) { return snr / 10.0 } */
u32 snr10_to_float(u16 snr)
{
        unsigned int e = 23 - __fls(snr / 10);
        return snr ? ((((snr << e) + 5) / 10) & 0x7fffff) | (150 - e) << 23 : 0;
}

You'd use the function like this:

	float f;
	*(u32 *)&f = snr_to_float(snr);
