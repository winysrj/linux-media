Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:45609 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbZKDAdp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Nov 2009 19:33:45 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1N5Tor-0001iV-Nj
	for linux-media@vger.kernel.org; Wed, 04 Nov 2009 01:33:49 +0100
Received: from 78-105-205-147.zone3.bethere.co.uk ([78.105.205.147])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 04 Nov 2009 01:33:49 +0100
Received: from topper.doggle by 78-105-205-147.zone3.bethere.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 04 Nov 2009 01:33:49 +0100
To: linux-media@vger.kernel.org
From: TD <topper.doggle@googlemail.com>
Subject: Re: [linux-dvb] Struggling with Astra 2D (Freesat) / Happauage
 Nova-HD-S2
Date: Wed, 4 Nov 2009 00:33:27 +0000 (UTC)
Message-ID: <hcqi4n$ghe$1@ger.gmane.org>
References: <hcnd9s$c1f$1@ger.gmane.org> <20091102231735.63fd30c4@bk.ru>
 <hcnsfa$v70$1@ger.gmane.org>
 <alpine.DEB.2.01.0911030516050.29421@ybpnyubfg.ybpnyqbznva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<removed linux-dvb x-post>

On 2009-11-03, BOUWSMA Barry <freebeer.bouwsma@gmail.com> wrote:
> On Tue, 3 Nov 2009, TD wrote:
>
> First of all, some background info, in case you aren't aware:
>
> All Freesat services are presently DVB-S.  There are currently
> no DVB-S2 transponders carrying any FTA services, although
> there is always the possibility that the existing FTA HD services
> which are on DVB-S transponders may move to DVB-S2 in the not-
> too-distant future, particularly when the terrestrial UK
> DVB-T2 services start before the end of the year, and Channel 4
> and Five join the existing ITV and BBC HD services.
>
> Therefore the failure to tune DVB-S2 transponders has nothing
> to do with reception of Freesat.

I wasn't aware - I thought the Freesat HD channels were DVB-S2, that's why I
got that card.  Now upon further research, it appears that talk of DVB-S2 with
Freesat has died down, so looks like I've wasted some money (for now).

> Enough background, what I see from the above is that the
> frequency of 11720 has a symbol rate of 29500 which I know
> is what is used by the BSkyB encrypted programmes.  So your
> ability to tune isn't going to help you see any additional
> services, just as those in your original post are also
> scrambled Sky programmes.
>
> If it concerns you that you can't tune this DVB-S2 transponder,
> then you'll need the advice of others with DVB-S2 familiarity.

No, it just concerns me that I can't get Freesat from Astra 2D.

>> Once I got it working, same:
>> Astra 2A/2B/2D/Eurobird 1 (28.2E) 10714 H DVB-S QPSK 22000 5/6 ONID:0 TID:0
>> AGC:0% SNR:0% 
>>     Can't tune
>
>> Where do I go from here?
>
> I note that your first listed frequency is 11720, just above
> the transition from low to high band, in your first message.
> Do you get any results with success at any frequencies below 
> 11700, and do your successes above 11700 include both horizontal
> and vertically polarised services?

My channels.conf contains both horizontal and vertical channels, but nothing
below 11700.  So it looks like I'm not getting anything via low band?

> If you have a complete lack of any results with one particular
> polarisation/band combination, then suspect possibly your
> cabling, unless a regular FTA/Freesat/Sky receiver connected
> to the same is able to successfully find all services.

As per my OP:

= The setup is that this is a newly-built flat, with a double F-socket on the
= wall.  I followed it down to the distribution panel in the basement, and it's
= connected to a Delta MS 5024 N multiswitch.  From what I could make out, said
= switch has four cables going in (vertical 0khz, horiz 0khz, vertical 22khz,
= horiz 0khz), and lots of cables going to the flats.

Surely it must be the switch, I don't see what else it can be, especially if
there is no special signal that a Sky box sends down the wire to the switch,
that my setup would need to replicate.

There is a caveat above, which is that we are the first people in the block,
so who knows what reception others are getting.  I've already had the cables
from the switch to our flat moved to a different switch, as when I mentioned
the situation to the builder (still on-site) he told me that people in another
block had had a problem on that switch.

However, it's always possible that the cables aren't labelled properly, we
have found that with other services.  *sigh*  So perhaps the cables that were
moved, weren't the ones that lead to our flat!

>
> You should be able to receive services from 11200 to 11700
> in both bands with DVB-S, as well as above 11700, as the
> former are not on a particular spotbeam.
>
> Hope this info helps.  Feel free to send me off-list your
> `scan' output (DVB-S) if you can't spot any patterns.
>

Thanks for your very informative assistance.  I will borrow a Sky box and plug
it in before I continue the thread.  :)

-- 
TD

