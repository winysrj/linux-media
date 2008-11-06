Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1Ky0qk-00018k-Td
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 10:08:24 +0100
Received: by ey-out-2122.google.com with SMTP id 25so186983eya.17
	for <linux-dvb@linuxtv.org>; Thu, 06 Nov 2008 01:08:19 -0800 (PST)
Date: Thu, 6 Nov 2008 10:08:12 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <49124960.6070101@andrei.myip.org>
Message-ID: <alpine.DEB.2.00.0811060903100.22461@ybpnyubfg.ybpnyqbznva>
References: <491236F2.4050101@andrei.myip.org>
	<200811060153.37102.hftom@free.fr>
	<49124960.6070101@andrei.myip.org>
MIME-Version: 1.0
Subject: Re: [linux-dvb] HD over satellite? (h.264)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Mojn,

You have given no clue that I can see without research in your
message as to which particular services are of interest to you,
and a hint to your location, so I will have to generalise about
things here...

On Wed, 5 Nov 2008, Florin Andrei wrote:

> A quick search on the Eutelsat website revealed that they transmit using =
> DVB-S. So a DVB-S card like the Hauppauge WinTV-NOVA-S-Plus which I plan =
> to purchase should be able to receive it, is that right?
> 
> (I can't receive Eutelsat from my area, but if they start broadcasting =
> their HD channels on Galaxy 25, the way they do already with SD, then =
> I'll be able to receive them.)

In most cases I've seen, when DVB-S is used to trasmit H.264
HDTV, it's in order to share a transponder between conventional
MPEG-2 broadcasts.  Usually, when a transponder gets converted
to HDTV only, it uses DVB-S2.

I would not rely on a particular transponder remaining DVB-S
if you have interest in any HDTV -- particularly if you are
planning an initial investment in a card.  I would suggest
getting a DVB-S2 card, capable of DVB-S, and avoiding unpleasant
surprises later, future-proofing yourself for some time.


As a concrete example of what I mean, BBC-HD presently shares
a transponder with two SD BBC services which must be received
by existing non-S2-able Sky and FTA receivers.  The german
EinsFestival HD showcases shared a transponder with existing
SD services.  The present arte-HD and coming ARD and ZDF HD
services have their dedicated transponder, no SD services,
and use -S2.  The Hotbird Hungarian and Swiss HD services
share space with SD and use DVB-S.

There do exist transponders which use the more efficient
DVB-S2 yet carry a payload of MPEG-2 services, just as there
are H.264 services on DVB-S.  One does not require the other.
Generally, HD services do not need to be concerned with
consumer equipment that cannot receive DVB-S2, and are able
to use that without concern.  While nearly all SD-only
consumer equipment has no DVB-S2 ability and is stuck with
DVB-S2.



> Right. OTOH, I expect the satellite stuff to be transmitted at a pretty =
> low bitrate, also perhaps with the more complex encoding features turned =

The services which use lower bitrates (for HD, less than,
say, 10Mbit/sec where the broadcasts I know of start), if
what I see on SD is a guide, are likely to be budget-tight
commercial broadcasts or niche programming that is highly
unlikely to be contemplating HD, adverts that push to the
limits the frequency of keyframes or entropy of the content
in order to trickle ``moving'' pictures on a budget.  Or
pr0n that looks to be modelled by airbrushed Lego blocks.

Argh, speaking of which, the HD-pr0n that I wanted to see
bitrate (technical meaning thereof) has disappeared, so I
have no clue what they used while it existed, purely for
research purposes, you know...

If you wanted to name the service, we could tell you what
bitrate is used (and many of the auto-scanning DX websites
list this as well, if you want to look yourself)...  Else
my examples of well-funded quality-concerned Public Service
Broadcasters, or of subscriber-financed subscription
packages, might be inapplicable -- I pay attention to both
technical and content quality where interested, and have
no idea what you may have to suffer where you are.


thanks
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
