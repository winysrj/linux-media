Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:60966 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZKDFoS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 00:44:18 -0500
Received: by ewy3 with SMTP id 3so2766397ewy.37
        for <linux-media@vger.kernel.org>; Tue, 03 Nov 2009 21:44:22 -0800 (PST)
Date: Wed, 4 Nov 2009 06:44:14 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: TD <topper.doggle@googlemail.com>
cc: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Struggling with Astra 2D (Freesat) / Happauage
 Nova-HD-S2
In-Reply-To: <hcqi4n$ghe$1@ger.gmane.org>
Message-ID: <alpine.DEB.2.01.0911040518120.29421@ybpnyubfg.ybpnyqbznva>
References: <hcnd9s$c1f$1@ger.gmane.org> <20091102231735.63fd30c4@bk.ru> <hcnsfa$v70$1@ger.gmane.org> <alpine.DEB.2.01.0911030516050.29421@ybpnyubfg.ybpnyqbznva> <hcqi4n$ghe$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 Nov 2009, TD wrote:

> <removed linux-dvb x-post>

Oooh, that's a mistake (from my view) -- it means your reply
doesn't appear in my inbox, and it's only through luck that I
find it amongst the uninteresting (to me) posts that I check
infrequently on linux-media via gmane -- I thought there was
to be a separation between developer mail, and dvb-user mail,
and this clearly falls into the latter.  And is more my bag.
But that's a rant I don't want to get into, as I'm in the
minority here.



> > Therefore the failure to tune DVB-S2 transponders has nothing
> > to do with reception of Freesat.
> 
> I wasn't aware - I thought the Freesat HD channels were DVB-S2, that's why I
> got that card.  Now upon further research, it appears that talk of DVB-S2 with
> Freesat has died down, so looks like I've wasted some money (for now).

Happy to offer the background.  I wouldn't say you've wasted
money -- rather, you've future-proofed yourself.  Sadly the
Freesat specs don't appear to have mandated the more efficient
H.264 AVC video codec for SD resolution services, so there is
no possibility of that for a Freesat-only (no BSkyB) service
that wants to save transmission costs, yet still be received
by the handful of non-HD-able receivers out there.  I'd liken
it to my decision not to buy any DAB-only receiver without the
DAB+ (and DMB) capability that is presently in use (if not in
the UK or other countries), or any further DVB-S cards without
-S2.  And DVB-T2.  What seems like a waste of money today will
guarantee you don't have to spend as much later -- with your
DVB-S2 card and a suitably positioned dish, you could be
receiving the french-german `arte' where occasional programmes
capture my interest, as well as other FTA services that have
not yet interested me in a pure -S2 form.

Also, while the Beeb may not presently be transmitting -S2 for
their HD service, I wouldn't rule it out.  There's a long and
sordid history behind Freesat and the Continent that limits
what is available via Freesat and its quality to what the 2D
satellite can deliver, and any future services (such as the
recent Freesat `Five') will need to be shoehorned into that
already overfilled space.



> My channels.conf contains both horizontal and vertical channels, but nothing
> below 11700.  So it looks like I'm not getting anything via low band?

Thanks for confirming this.  This points to a potential, but
unlikely, problem with your device, that it can't switch into
the low band (I had a problem where one of my devices could
not receive anything in the high band without hackery, or a
multiswitch which spoke to it differently).

If you are not aware of it, in case it helps, the switching
between low (below 11700-ish) and high band is normally
accomplished with a 22kHz tone signal, absent for low band.
It can also be accomplished by a particular DiSEqC signal
which my one device speaks to the multiswitch I got which
solved that problem, that being the opposite to what you are
experiencing.

The other possibility, given that two of the four inputs to
your multiswitch work, is that the two low-band inputs have
been crossed.



> > If you have a complete lack of any results with one particular
> > polarisation/band combination, then suspect possibly your
> > cabling, unless a regular FTA/Freesat/Sky receiver connected
> > to the same is able to successfully find all services.
> 
> As per my OP:
> 
> = The setup is that this is a newly-built flat, with a double F-socket on the
> = wall.  I followed it down to the distribution panel in the basement, and it's
> = connected to a Delta MS 5024 N multiswitch.  From what I could make out, said
> = switch has four cables going in (vertical 0khz, horiz 0khz, vertical 22khz,
> = horiz 0khz), and lots of cables going to the flats.
> 
> Surely it must be the switch, I don't see what else it can be, especially if
> there is no special signal that a Sky box sends down the wire to the switch,
> that my setup would need to replicate.

Yeah, a third possibility could be the switch.  I glossed over the
details in your original post about the switch, and completely
forgot it was newly-built.

While I would normally expect everything to work in a new
installation, I've read enough to convince me otherwise.
As a confession, when I have to replace the cabling into my
multiswitch, these days I determine the proper wiring by a
process of elimination as to which of the four cables goes
where.  I recently had to do this with my dish pointed at
28,2/28,5°E and I'm always wary when I have the mathematically
improbable result of the randomly selected cables being
connected to the right inputs.  But enough of my confessions
why you wouldn't hire me to install anything you care about.



> There is a caveat above, which is that we are the first people in the block,
> so who knows what reception others are getting.  I've already had the cables
> from the switch to our flat moved to a different switch, as when I mentioned

Different switch, or different output of the same switch?
Not that it's important.


> the situation to the builder (still on-site) he told me that people in another
> block had had a problem on that switch.

Here is where my unfamiliarity with building practices in the
different countries rears its ugly head.  (Not to mention the
differences between the same language wielded in different
regions, but I'm going to try to hide that by not mentioning
it...)



> However, it's always possible that the cables aren't labelled properly, we
> have found that with other services.  *sigh*  So perhaps the cables that were
> moved, weren't the ones that lead to our flat!

If it makes you feel better, I've noted that my cheap^H^H^H^H^H
affordable multiswitch has a couple outputs where what I do on
them affects what the remaining outputs see.  Technically, there
is leakage so that if I'm watching a high-band channel on the
aforementioned output, the other outputs are unable to receive
any low-band signals.  Or else they're blocked from receiving
any other of the four satellite positions.  I've simply capped
those outputs so as not to use them, and so far things have
been fine.

What I mean to say is, these days, not everything works perfectly.
I've worked around this by future-proofing my purchase with more
outputs than normally needed.  An unlikely possibility could be
that someone else is tuned into a high-band signal and the 22kHz
switching signal (constant) is leaking into your input, causing
it to switch to high bands when tuning.

Although, normally, for the above, there is some overlap, so
that you may see some results for low-band transponders but
they are actually services sent in high-band.

Note that I'm blathering in the above, but I just want you to
know there are plenty of possibilities for causing problems
that have nothing to do with your kernel or DVB stack.  Also,
it's either early or late pub o'clock from which I'm posting.



> Thanks for your very informative assistance.  I will borrow a Sky box and plug
> it in before I continue the thread.  :)

You're welcome.  With the results you have (no low-band at all)
I'd include a possible cable mismatch between the two low-band
inputs from the LNB.  That is, two of the four cables may be
wrong, those feeding Auntie's services amongst others, but
from this distance I don't want to commit myself to that.


Just for your information, the four cables from the single LNB
going into the multiswitch and ideally appearing as one
universal LNB are switched by the following, apart from a
particular DiSEqC sequence:

Vertical or horizontal polarisation, regardless of lo/hi band,
is selected by a voltage from the receiver:  13 or 14V for
vertical, and nominally 18V for horizontal.  You have no problems
in the high band with this switching, it seems.

Low- or high-band is selected by the absence (low-band) or
presence (high-band) of a 22kHz tone superimposed on the
voltage.  This is where you appear to be having problems, as
your high-band works.  But in your case, a multiswitch also
comes into play.

I hope my remote diagnosis is useful.  If your borrowed Sky
box works, then you may have an obscure hardware/linux
problem.  If it doesn't, than slap the installer about
the head for a spell.


thanks,
barry bouwsma
