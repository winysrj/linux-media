Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:45206 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659Ab3ANVaR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 16:30:17 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] saa7134: Add AverMedia Satelllite Hybrid+FM A706 (and FM radio problems)
Date: Mon, 14 Jan 2013 22:29:58 +0100
References: <201301122124.51767.linux@rainbow-software.org>
In-Reply-To: <201301122124.51767.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201301142229.58923.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 12 January 2013 21:24:50 Ondrej Zary wrote:
> Partially working: FM radio
> Radio seems to be a long-standing problem with saa7134 cards using silicon
> tuners (according to various mailing lists).
>
> On this card, GPIO11 controls 74HC4052 MUX. It switches two things:
> something at TDA18271 V_IFAGC pin and something that goes to SAA7131E.
> GPIO11 is enabled for radio and disabled for TV in Windows. I did the same
> thing in this patch.
>
> Windows INF file says:
> ; Setting FM radio of the Silicon tuner via SIF (GPIO 21 in use/ 5.5MHz)
> HKR, "Audio", "FM Radio IF", 0x00010001, 0xDEEAAB
>
> But that seems not to be true. GPIO21 does nothing and RegSpy (from
> DScaler, modified to include 0x42c register) says that the register is
> 0x80729555. That matches the value present in saa7134-tvaudio.c (except the
> first 0x80).
>
> With this value, the radio stations are off by about 4.2-4.3 MHz, e.g.:
> station at 97.90 MHz is tuned as 102.20 MHz
> station at 101.80 MHz is tuned as 106.0 MHz
>
> I also tried 0xDEEAAB. With this, the offset is different, about 0.4 MHz:
> station at 101.80 MHz is tuned as 102.2 MHz

The offset seems bogus, maybe affected by my TV antenna (cable).

For debugging, tried another card with similar chips: Pinnacle PCTV 
40i/50i/110i. It has SAA7131E chip too, but different tuner - TDA8275A. And 
the radio problem is the same as found first on the A706 - the tuned station 
sound starts but then turns into noise. So it seems that the problem is not 
in tda18271 but in tda8290 or saa7134.

With tda8290.debug=1, I see this:
tda829x 2-004b: tda8290 not locked, no signal?
tda829x 2-004b: tda8290 not locked, no signal?
tda829x 2-004b: tda8290 not locked, no signal?
tda829x 2-004b: adjust gain, step 1. Agc: 193, ADC stat: 255, lock: 0
tda829x 2-004b: adjust gain, step 2. Agc: 255, lock: 0
tda829x 2-004b: adjust gain, step 3. Agc: 173

During that, the sound is good. Then it turns into noise.
When I increased the number of lock detections in tda8290_set_params() from 3 
to (e.g.) 10, it works longer. And when I'm quick enough to stop the console 
output using scroll lock, the radio remains working.

> And what's worst, connecting analog TV antenna (cable TV) affects the radio
> tuner! E.g. the radio is tuned to 106.0 MHz (real 101.80 MHz) with nice
> clean sound. Connecting TV antenna adds strong noise to the sound, tuning
> does not help. This problem is not present in Windows.

I've found a tiny chip marked S79 near the analog tuner. It's Skyworks 
AS179-92LF antenna switch that switches either the TV or FM antenna to the 
TDA18271 FM_IN pin! That's why TV antenna affected the radio. The switch is 
probably controlled by some other GPIO pin (haven't tested this yet). What's 
the best way to expose this switch to userspace?

-- 
Ondrej Zary
