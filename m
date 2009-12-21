Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:47774 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbZLUQke (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2009 11:40:34 -0500
Received: by ewy1 with SMTP id 1so6554685ewy.28
        for <linux-media@vger.kernel.org>; Mon, 21 Dec 2009 08:40:33 -0800 (PST)
Date: Mon, 21 Dec 2009 17:40:26 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Michael Akey <akeym@onid.orst.edu>
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: scan/scan-s2 doesn't tune, but dvbtune does?
In-Reply-To: <4B2BD6C2.50307@onid.orst.edu>
Message-ID: <alpine.DEB.2.01.0912211720530.31371@ybpnyubfg.ybpnyqbznva>
References: <4B269F1A.30107@onid.orst.edu>  <4B275CA2.406@tripleplay-services.com> <83bcf6340912180525h1bbaf229j9b2c81ffacb8fe76@mail.gmail.com> <4B2BD6C2.50307@onid.orst.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 18 Dec 2009, Michael Akey wrote:

> > > > I can't get the scan/scan-s2 utilities to lock any transponders (DVB-S).
> > > >  My test satellite is AMC1 103W, the Pentagon Channel tp. This is
> > > > probably
> > > > some simple user error on my part, but I can't figure it out.  I have a
> > > > Corotor II with polarity changed via serial command to an external IRD.
> > > >  C/Ku is switched by 22KHz tone, voltage is always 18V.  Ku is with tone
> > > > off, C with tone on.  Speaking of which, is there a way to manually set
> > > > the
> > > > tone from the arguments on the scan utilities?

>   I think
> it's a tone issue, but then again, why does attempting to scan something on
> both bands C and Ku (tone on, and tone off respectively) not work?  I figured
> if it's a tone issue that only one band would work.
> 
> I tried setting the FEC and even the delivery system (S1 rather than S) and it
> makes no difference.  I could try the DVB-S2 NBC mux on that satellite too..
> but I'm not sure why that would make a difference.
> 
> If you folks have any other ideas, let me know.  Thanks for your responses so
> far!

Hi Mike,

I overlooked your description of your Corotor and IRD earlier, and
now, with poor connectivity, I can't really look up the details 
and match them with my experiences.

I have a switch that is activated by the 22kHz signal and which
used to be used for old analogue setups to select between two
positions.  I'm not sure if there is a discrete component like
this in your setup, but if there is, is it possible for you to
bypass it and get directly to the C- or Ku-band LNB?  Or am I
failing to do research to show me this is not possible...

In any case, I'd do what I can to get directly to the LNB.  Also,
your mention of polarity switching is, well, alien to me.  I
suspect the card is expecting to use 13V or 18V to get vertical
or horizontal polarisation; for circular polarisation I wouldn't
know what handedness corresponds to what switching.

Anyway, the 18V you say is constant, would be supplied by the
horizontal polarisation.  If you're able to get that 22kHz switch
out of the way, and scan the Ku-band LNB directly, you ought to be
able to see the same results with giving the directly-used 
frequency values, or subtracting 1 000 000kHz to convert your
10750MHz to the 9750MHz expected by the low-band Universal LNB
local oscillator frequency -- the latter normally not generating
the 22kHz signal.

I don't know if this will help at all, or if it's possible, and I
apologise for my ignorance about your specific dish(es?).


barry bouwsma
