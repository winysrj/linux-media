Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:52206 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbZKCEkg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 23:40:36 -0500
Received: by ewy3 with SMTP id 3so1631134ewy.37
        for <linux-media@vger.kernel.org>; Mon, 02 Nov 2009 20:40:40 -0800 (PST)
Date: Tue, 3 Nov 2009 05:40:35 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: TD <topper.doggle@googlemail.com>
cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Struggling with Astra 2D (Freesat) / Happauage
 Nova-HD-S2
In-Reply-To: <hcnsfa$v70$1@ger.gmane.org>
Message-ID: <alpine.DEB.2.01.0911030516050.29421@ybpnyubfg.ybpnyqbznva>
References: <hcnd9s$c1f$1@ger.gmane.org> <20091102231735.63fd30c4@bk.ru> <hcnsfa$v70$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Nov 2009, TD wrote:

> On 2009-11-02, Goga777 <goga777@bk.ru> wrote:
> > Приветствую, TD
> >
> > you have to use scan-s2
> > http://mercurial.intuxication.org/hg/scan-s2
> 
> Hi, and thanks for your quick reply.
> 
> I tried it but no better:
> <snip>
> initial transponder DVB-S  12692000 V 19532000 1/2 AUTO AUTO
> initial transponder DVB-S2 12692000 V 19532000 1/2 AUTO AUTO
> ----------------------------------> Using DVB-S
> >>> tune to: 11720:hC34S0:S0.0W:29500:

First of all, some background info, in case you aren't aware:

All Freesat services are presently DVB-S.  There are currently
no DVB-S2 transponders carrying any FTA services, although
there is always the possibility that the existing FTA HD services
which are on DVB-S transponders may move to DVB-S2 in the not-
too-distant future, particularly when the terrestrial UK
DVB-T2 services start before the end of the year, and Channel 4
and Five join the existing ITV and BBC HD services.

Therefore the failure to tune DVB-S2 transponders has nothing
to do with reception of Freesat.


Enough background, what I see from the above is that the
frequency of 11720 has a symbol rate of 29500 which I know
is what is used by the BSkyB encrypted programmes.  So your
ability to tune isn't going to help you see any additional
services, just as those in your original post are also
scrambled Sky programmes.

If it concerns you that you can't tune this DVB-S2 transponder,
then you'll need the advice of others with DVB-S2 familiarity.



> and the channels.conf was no better than before - it didn't include *one* BBC
> channel, for example.

The BBC channels, as well as most ITV, Channel 4, and similar
``interesting'' Freesat services, are on the Astra 2D satellite,
as per your subject.  This bird covers the frequencies from
10714250 h 22000 through 10935500 v 22000.  Its footprint is
a narrow beam focussed on the UK, and can only be received
with some difficulty elsewhere that the remaining signals
from the other Astra and Eurobird satellites deliver useable
signals.  That is, were you to be somewhere outside the UK,
you might need to more accurately position your dish.  But
that shouldn't be your problem as per your original message.


> Once I got it working, same:
> Astra 2A/2B/2D/Eurobird 1 (28.2E) 10714 H DVB-S QPSK 22000 5/6 ONID:0 TID:0
> AGC:0% SNR:0% 
>     Can't tune

> Where do I go from here?

I note that your first listed frequency is 11720, just above
the transition from low to high band, in your first message.
Do you get any results with success at any frequencies below 
11700, and do your successes above 11700 include both horizontal
and vertically polarised services?

If you have a complete lack of any results with one particular
polarisation/band combination, then suspect possibly your
cabling, unless a regular FTA/Freesat/Sky receiver connected
to the same is able to successfully find all services.

You should be able to receive services from 11200 to 11700
in both bands with DVB-S, as well as above 11700, as the
former are not on a particular spotbeam.

Hope this info helps.  Feel free to send me off-list your
`scan' output (DVB-S) if you can't spot any patterns.


thanks,
barry bouwsma
