Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:54592 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbZEEX3C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2009 19:29:02 -0400
Subject: Re: saa7134/2.6.26 regression, noisy output
From: hermann pitton <hermann-pitton@arcor.de>
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: linux-media@vger.kernel.org, video4linux-list@redhat.com,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <20090504195201.6ECF52C415B@tippex.mynet.homeunix.org>
References: <20090503075609.0A73B2C4152@tippex.mynet.homeunix.org>
	 <1241389925.4912.32.camel@pc07.localdom.local>
	 <20090504091049.D931B2C4147@tippex.mynet.homeunix.org>
	 <1241438755.3759.100.camel@pc07.localdom.local>
	 <20090504195201.6ECF52C415B@tippex.mynet.homeunix.org>
Content-Type: text/plain
Date: Wed, 06 May 2009 01:26:28 +0200
Message-Id: <1241565988.16938.15.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 04.05.2009, 21:52 +0200 schrieb Anders Eriksson: 
> 
> Hi hermann,
> 
> hermann-pitton@arcor.de said:
> > There is no way to detect which sort of such a LNA circuitry is employed.
> > Just try and error and pray. Also no further documentation for the changing
> > code itself and only some comments by Hartmut on the lists.
> >
> > In case config = 1 gpio0 of the tda827x is involved, on others a gpio pin of
> > the saa7134 and some registers.
> >
> > It was already broken when tuner callback stuff for XCeive tuners was
> > introduced and firmware loading for those.
> >
> > Guess the problem is to get the gpio change to the tda827x through.
> >
> > Hartmut came up with this fix that time you get with "hg export 7393".
> > (attached)
> >
> > I did not even have any such a LNA device at this time, but might be
> > interesting if this snapshot really works for you. Still have only one type 2
> > device now.
> >
> > If I look through hg log > hg.log, the only somehow related later change by
> > Hartmut was this one. (link points to Hartmut's repo)
> >
> > http://linuxtv.org/hg/~hhackmann/v4l-dvb/rev/779169257208
> >
> > And last entry is that compile warning fix on top for int mask not removed at
> > once. Should all be only saa7134 gpio related.
>
> I had a look at the diff you attached, and it made me a bit confuse. Most 
> (all?) of it seem to be already applied in later kernels (>2.6.26), and they 
> all fail on me.

hmm, the idea eventually was, to download these two snapshots, or make
the last few changes manually on the first and try on 2.6.25.

Then we might know, if the problem is already visible within Hartmut's
latest fix attempts or even more and other stuff is involved.

"make rmmod" and save the original modules media folder.
Then "make" and "make install" and you get a new one.

The same way you can restore your old working media folder by putting it
back in place and "depmod -a".

You can click on top of the site on bz2 or gz to get such a snapshot. 
http://linuxtv.org/hg/v4l-dvb/rev/49ba58715fe0

> however, looking through the diff, I sumbled on the dprink's and I started to 
> enable them on all modules I thought relevant. Here's a diff between the last
> -good and first-bad commit. The salient differences I can see is the "AGC2 gain"
> and the "setting GPIO22 to vsync 0". I have no clue what they mean, but my 
> next step is to see if I can kill these differences.
> 
> Is thee anything else in there which you find note worthy?

-saa7133[0]/core: setting GPIO22 to vsync 0

This saa7133 GPIO22 setting is related to LNA configuration.

The code has changed, doesn't print the above anymore and became a tuner
callback. Maybe related.

> Rgds,
> /Anders
> PS What is the tda829x doing? I see some differences there too.

It is the analog demodulator within the saa7131e, controls the i2c gate
to the tda8275a silicon tuner and gpio0 on it is involved in type 1 LNA
control, according the comments. (details under NDA i don't have)

> 
> $ diff -u dmesg_2.6.25-03{6,7}* 
> --- dmesg_2.6.25-03622-g1fe87369        2009-05-04 21:32:37.000000000 +0200
> +++ dmesg_2.6.25-03774-g99e09ea 2009-05-04 21:37:06.000000000 +0200
> @@ -42,14 +42,13 @@
>  tda829x 1-004b: tda827xa config is 0x01
>  tda827x: setting tda827x to system xx
>  tda827x: setting LNA to high gain
> -saa7133[0]/core: setting GPIO22 to vsync 0
> -tda827x: AGC2 gain is: 3
> +tda827x: AGC2 gain is: 10
>  tda829x 1-004b: tda8290 not locked, no signal?
>  tda829x 1-004b: tda8290 not locked, no signal?
>  tda829x 1-004b: tda8290 not locked, no signal?
> -tda829x 1-004b: adjust gain, step 1. Agc: 0, ADC stat: 0, lock: 0
> -tda829x 1-004b: adjust gain, step 2. Agc: 131, lock: 0
> -tda829x 1-004b: adjust gain, step 3. Agc: 44
> +tda829x 1-004b: adjust gain, step 1. Agc: 0, ADC stat: 1, lock: 0
> +tda829x 1-004b: adjust gain, step 2. Agc: 255, lock: 0
> +tda829x 1-004b: adjust gain, step 3. Agc: 235
>  tuner' 1-004b: saa7133[0] tuner' I2C addr 0x96 with type 54 used for 0x0e
>  saa7133[0]/core: hwinit2
>  tuner' 1-004b: switching to v4l2
> @@ -58,8 +57,7 @@
>  tda829x 1-004b: tda827xa config is 0x01
>  tda827x: setting tda827x to system B
>  tda827x: setting LNA to high gain
> -saa7133[0]/core: setting GPIO22 to vsync 0
> -tda827x: AGC2 gain is: 3
> +tda827x: AGC2 gain is: 10
>  tda829x 1-004b: tda8290 not locked, no signal?
[snip]

Cheers,
Hermann


