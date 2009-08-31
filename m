Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:41943 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZHaSch (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 14:32:37 -0400
Received: by ewy2 with SMTP id 2so590421ewy.17
        for <linux-media@vger.kernel.org>; Mon, 31 Aug 2009 11:32:38 -0700 (PDT)
Date: Mon, 31 Aug 2009 20:32:28 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: linux-media@vger.kernel.org, david may <david.may10@ntlworld.com>
cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] what is the current status of the DVB-T2 supply
 chain for the UK ?
In-Reply-To: <1952743797.20090831023304@ntlworld.com>
Message-ID: <alpine.DEB.2.01.0908311642150.28635@ybpnyubfg.ybpnyqbznva>
References: <1952743797.20090831023304@ntlworld.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 31 Aug 2009, david may wrote:

> its been a while since i had need to post anything but iv got a very
> serious problem as to the status of the current status of the DVB-T2 supply chain for the UK ?
> 
> there doesn't seem to be any, and if anyone knows what's happening, then
> its the linux DVB-T guys  ;)

That's correct, but how is it a serious problem for you?

It is a chicken-egg type of problem.  The first consumer equipment
is likely to appear around the end of the year in limited 
quantities, and perhaps cut to fit the UK market's parameters --
remember how many Freeview receivers were limited to 2k and are
now being obsoleted by the switchover to 8k DVB-T.

Next year, you may start to see more on the retail shelves, but
likely to be a trickle at first, plus more full-featured devices.
Also, over time the prices should slowly fall from the early-
adopter levels that should give first-time buyers pause.


>  there doesn't seem to be anything advertised here to buy, and no
>  PCI(-E)or USB2 sticks with DVB-T2 chipsets/SOC included that i can
>  find.

This is likely to be some time into 2010 before the first such
devices appear on the market -- and it will be more time before
such devices could possibly be used with Linux -- there is not 
yet proper support for all the additional possibilities of DVB-T2
over DVB-T in the DVB API.


>  if the worlds OEMs are to be ready for that UK market and date,
>  then it seems they Must be in full manufacture by now or
> already available on the shelf some were.

This is not the case -- the Beeb (and ITV and Channel 4) will 
start their broadcasting before the wide availability of consumer
equipment.  Like I said, chicken and egg.

I know of one chipset which was being prototyped some months back.
I know neither its current production status, nor whether there
are additional chipsets capable of DVB-T2 in some state of 
development or production.


> has anyone here got any information regarding the potential
> availability of such USB2 DVB-T2 sticks for PC use and whats the
> status of any drivers and support code for that? if any.

Your best bet to keep up-to-date, as well as with experts better
tuned to the UK market, would be Digital Spy, if you can avoid the
showbiz and soap opera tripe and get down to the technical gems
of details hidden within.

I can't speak for Linux support, but that will depend on how fast
the DVB-T2 enhancements get incorporated into the Linux DVB API,
and more importantly, how cooperative any chipset manufacturers
will be to work with developers in making programming information
available.

For starters, you'll be stuck with one or two set-top boxes for
some time.  Maybe a Windows-only PC device will be introduced
sometime in mid-or-so 2010, but my crystal ball is currently out 
of service to be fit with one of those new prototype chips, so I
can't tune in any better predictions.


>  but i really do hope someone here is already working with something
>  we can put in and directly use in the UK with these BBC HD AVC DVB-T2
>  finally going mainstream with the winterhill NW transmitter switch

And expect to pay an arm and a leg.  I suggest that if you have
access to a Freesat, BSkyB, or conventional satellite dish, you 
invest in a DVB-S2 device that you can use today.  Even though
the BBC has reduced the bitrate of its HD channel recently, maybe
to the level required for DVB-T2 terrestrial broadcast, you can
now tune in that programming.  How ITV-HD will fit into the 
picture and what changes will happen to Freesat to accommodate
that, as well as whether Channel 4 HD will be available as well,
or only via Sky for some time or DVB-T2, I cannot say.

Otherwise be patient.  Expect months to pass, but also expect a
quick uptake as other countries will be jumping on the DVB-T2
bandwagon very soon.


Hope this helps to answer your concern.  Sorry, I'm not an insider
so I don't know any more than the above.

cheers,
barry bouwsma
