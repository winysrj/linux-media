Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:48635 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab3AQXQe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 18:16:34 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] saa7134: Add AverMedia Satelllite Hybrid+FM A706 (and FM radio problems)
Date: Fri, 18 Jan 2013 00:16:12 +0100
References: <201301122124.51767.linux@rainbow-software.org> <201301152257.06658.linux@rainbow-software.org> <201301152337.58701.linux@rainbow-software.org>
In-Reply-To: <201301152337.58701.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201301180016.13097.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 15 January 2013 23:37:58 Ondrej Zary wrote:
> On Tuesday 15 January 2013 22:57:06 Ondrej Zary wrote:
> > On Monday 14 January 2013 22:29:58 Ondrej Zary wrote:
> > > On Saturday 12 January 2013 21:24:50 Ondrej Zary wrote:
> > > > Partially working: FM radio
> > > > Radio seems to be a long-standing problem with saa7134 cards using
> > > > silicon tuners (according to various mailing lists).
> > > >
> > > > On this card, GPIO11 controls 74HC4052 MUX. It switches two things:
> > > > something at TDA18271 V_IFAGC pin and something that goes to
> > > > SAA7131E. GPIO11 is enabled for radio and disabled for TV in Windows.
> > > > I did the same thing in this patch.
> > > >
> > > > Windows INF file says:
> > > > ; Setting FM radio of the Silicon tuner via SIF (GPIO 21 in use/
> > > > 5.5MHz) HKR, "Audio", "FM Radio IF", 0x00010001, 0xDEEAAB
> > > >
> > > > But that seems not to be true. GPIO21 does nothing and RegSpy (from
> > > > DScaler, modified to include 0x42c register) says that the register
> > > > is 0x80729555. That matches the value present in saa7134-tvaudio.c
> > > > (except the first 0x80).
> > > >
> > > > With this value, the radio stations are off by about 4.2-4.3 MHz,
> > > > e.g.: station at 97.90 MHz is tuned as 102.20 MHz
> > > > station at 101.80 MHz is tuned as 106.0 MHz
> > > >
> > > > I also tried 0xDEEAAB. With this, the offset is different, about 0.4
> > > > MHz: station at 101.80 MHz is tuned as 102.2 MHz
> > >
> > > The offset seems bogus, maybe affected by my TV antenna (cable).
> > >
> > > For debugging, tried another card with similar chips: Pinnacle PCTV
> > > 40i/50i/110i. It has SAA7131E chip too, but different tuner - TDA8275A.
> > > And the radio problem is the same as found first on the A706 - the
> > > tuned station sound starts but then turns into noise. So it seems that
> > > the problem is not in tda18271 but in tda8290 or saa7134.
> > >
> > > With tda8290.debug=1, I see this:
> > > tda829x 2-004b: tda8290 not locked, no signal?
> > > tda829x 2-004b: tda8290 not locked, no signal?
> > > tda829x 2-004b: tda8290 not locked, no signal?
> > > tda829x 2-004b: adjust gain, step 1. Agc: 193, ADC stat: 255, lock: 0
> > > tda829x 2-004b: adjust gain, step 2. Agc: 255, lock: 0
> > > tda829x 2-004b: adjust gain, step 3. Agc: 173
> > >
> > > During that, the sound is good. Then it turns into noise.
> > > When I increased the number of lock detections in tda8290_set_params()
> > > from 3 to (e.g.) 10, it works longer. And when I'm quick enough to stop
> > > the console output using scroll lock, the radio remains working.
> >
> > Pinnacle radio problems turned out to be a different bug - the driver
> > turns off tuners when the radio device is closed - and I was testing
> > using v4l2-ctl. Fixing that allows Pinnacle to work fine.
> >
> > But it's not enough for A706 to work. When I disable gain adjust in
> > tda8290 (by putting a return before), strong stations work somehow (with
> > noise).
>
> Changing IF frequency from 1.25MHz (1250) to 5.5MHz (5500) in
> tda18271-maps.c allows the radio to work without disabling gain adjust.
> Seems that IF mismatch between tda18271 and saa7134 is causing problems.
> However, only strong stations work.

Got it finally! With .if_freq=5500 and .fm_rfn=0, the radio works perfectly. 
Now only to find a way how to set a custom std_map...

-- 
Ondrej Zary
