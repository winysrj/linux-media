Return-path: <linux-media-owner@vger.kernel.org>
Received: from [194.250.18.140] ([194.250.18.140]:33580 "EHLO tv-numeric.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752412AbZETOxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 10:53:20 -0400
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: "'Patrick Boettcher'" <patrick.boettcher@desy.de>
Cc: <linux-media@vger.kernel.org>
Subject: RE : RE : Hauppauge Nova-TD-500 vs. T-500
Date: Wed, 20 May 2009 16:53:04 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAALN4GP6siTEuuMjrEDdv4uQEAAAAA@tv-numeric.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.1.10.0905201609240.15868@pub4.ifh.de>
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> De : Patrick Boettcher [mailto:patrick.boettcher@desy.de] 
> Envoyé : mercredi 20 mai 2009 16:17
> À : Thierry Lelegard
> Cc : linux-media@vger.kernel.org
> Objet : Re: RE : Hauppauge Nova-TD-500 vs. T-500
> 
> 
> On Wed, 20 May 2009, Thierry Lelegard wrote:
> > 2) Since the TD-500 contains two aerial inputs instead of one for
> > the T-500, I plugged in two antenna cables. Then, after some tests,
> > I realized that this was a source of trouble:
> > - Two antenna cables => lots of errors (mostly garbage sometimes,
> >  depending on the frequency).
> > - Top input only => still many errors but much better on 
> both tuners.
> > - Bottom input only => got nothing on both tuners.
> 
> Normally there is a RF switch + loop through to be controlled when 
> switching between diversity (not supported in Linux) and dual-input - so 
> that you can connect only one antenna but still doing the dual reception.

OK, that's my fault. At first, I thought that two tuners + two inputs
meant one input per tuner. When I realized it was wrong, I used only
one input on each TD-500.


> If this switch is not handled correctly, I could imagine that the second 
> input connected is "receiving" spurious signals and disturbing the first 
> input, but there can be a lot of other reason as well.
> 
> If I understand the code correctly, this switch (if it is really there :) 
> ) is not handled correctly. I don't know the TD 500 card, so maybe the 
> Hauppauge guys can help on that. (Basically the question is, which GPIO is 
> to be toggled)

The weird point is that one input works (with some errors though) and the
second input does not work at all (no input TS packets at all).


> > 3) There are still many uncorrectable errors (TS packets with "transport
> > error indicator" set) in the input. The amount of uncorrectable errors is
> > approximately 0.1% (depending on the frequency), while I do not have any
> > with the T-500 using the same antenna.
> 
> When you tune both frontends at the same time, please try to not tune the 
> same frequency.

I don't. In my tests, I use only one frontend.

In production, it could be possible that two frontends on the same TD-500
tune the same frequency for some period of time. What is the problem with that ?

I have two TD-500 on the same PCI bus. The four tuners are used independently.


Thanks for your time.
Regards,
-Thierry

