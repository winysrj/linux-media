Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.175])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1L7rQg-0001Un-I2
	for linux-dvb@linuxtv.org; Wed, 03 Dec 2008 14:06:12 +0100
Received: by ug-out-1314.google.com with SMTP id x30so3311349ugc.16
	for <linux-dvb@linuxtv.org>; Wed, 03 Dec 2008 05:06:07 -0800 (PST)
Date: Wed, 3 Dec 2008 14:00:10 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <500D461448%linux@youmustbejoking.demon.co.uk>
Message-ID: <alpine.DEB.2.00.0812031223490.9198@ybpnyubfg.ybpnyqbznva>
References: <412bdbff0812021455n221ee909nba6c7e546f1a0650@mail.gmail.com>
	<alpine.DEB.2.00.0812030110260.9198@ybpnyubfg.ybpnyqbznva>
	<500D461448%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Pinnacle 80e support: not going to happen...
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

On Wed, 3 Dec 2008, Darren Salt wrote:

> > (tubes for you wrong-pondians) and chokes and real transformers leaking
> > oily PCBs down to the parking lot below.
> 
> ITYM "down to the car park below". ;-)

I say guv', I do believe my true roots (routes for all youse'all 
deep southerners and Aussies) are showing...

Damn you Clarkson; if you were a fan of pushbikes, I'd be
watching your show and picking up the right terms rather than
being the poseur I've been outed as, waiting for the latest
repeats of Family Guy on BBC3, instead of a Beeching doku on
BBC4 that's more depressing than uplifting these days...


Anyway, my cunning ploy to keep quiet rather than blurting
out `12AX7 !!!' as a counterpoint to the claim of smashed tubes
has been thwarted.  `Nuvistor' would have revealed me not to
be the old bearded apple that I make myself out to be, while
I suppose I could redeem myself by claiming that senility keeps
me from reciting the tube/valve lineup of the bakelite radio
receiver, only one tube of which actually delivered a soothing
orange glow, that hummed menacingly at me as I tuned in the
Grand Ole Opry on WSM by gaslight.  Ah, the days of dried-up
electrolytic and paper condensers (capacitors for those who
grew up near me and regret it).

Once again I fell asleep reliving my past, thanks to Wackypedia.

It is either a sign of recovery, or senility, or alcohol abuse,
that not only can I not recall the markings on all the metal
tubes in said radio, but that upon seeing designations such as
0A2, 0B3, and friends, I cannot for the life of me remember
either which one(s) I was using, nor in what particular device,
or where, or how, or anything.

Sadly `6L6' and `6550' and too many other 6-foo and 12-foo
numbers not only brought back memories but also reminded me
that today I can't even draw a schematic of the home-built
devices using those, which I had to repair.  With enough beer,
I hope I can kill off those brane cells, as I seem to have been
unable to recycle them into something useful.

Worst of all, the dream I just had took me back to those days,
in a surreal reliving of my radio experience mixed with a modern-day
rave.


> (OTOH, at least we know to avoid these devices. And who to avoid when the
> pointy-haired ones interfere, as I presume has happened here...)

To get back on-topic from my perilous detour down memory lane^W
trodden mudpath, the sad thing is that, at least for me, it
seems the Micronas products of interest have somewhat of a
monopoly position.

In my case, lacking a DVB-C receiver which I'd like to try, four
products with USB2 ability returned by a price comparison site
are known or I suspect contain Micronas products.  The one which
probably does not has the added expense of including a (for me)
unnecessary CI slot.  But could have been a better choice, in
hindsight.

If I am to believe what I've read about ATSC, there's a problem
with multipath interference (for which DVB-T uses the guard
interval, also used to build single-frequency-networks which I
expect them Merkins see no need for), and Micronas' press
releases proclaim their ability to cope with this multipath.

I look at this somewhat like I did the ATI/nVidia video card
debate some years back, when I decided I wanted a card capable
of XvMC MPEG-2 hardware decoding to allow my 200MHz-ish Pentium
machines to be able to display smoothly videos recorded from
DVB.  As a PCI card (no AGP slot in the machines I had recovered
from the dumpster/skip).

At that time, the only choice was to use the closed nVidia
drivers, which I did, and quite happily for my limited usage.
Yes, I've read that others have complained about the stability
and such, but I never experienced problems, and I was able to
watch smooth (modulo generally interlaced 576i source) video, 
without dropping frames.


Would I use the same today in the case of Micronas, should
they release binary blobs that could be interfaced at a low
level using standard demodulator calls?  Probably -- I have
no other choice as a foolish early-adopter, than to watch my
USB stick be intercepted by a raven while demonstrating 9,8m/s
which will then repeat the process in an attempt to get at
the juicy walnut meat that has to be hidden inside.

But as far as a higher-level application that, as a Unix
beardy-weirdie, I'd probably never use, limiting myself to
`scan' and `dvbstream' for my purposes?  Hmmm...


If I could get the equivalent of the drx3973d.ko or related
foo.o files that I've built, except for the particular demods
in my device, I'd be happier than today.  I'm assuming I'd
need the foo.o files to get the .ko file, else I'd be tied
to a particular kernel version, which already causes me
headaches.


I'd say that the proper course of action would be for me to
grab a pitchfork and head to Zuerich, but I'd probably be
arrested for having flushed a toilet after 22h, and that's
not their operative headquarters anyway.

So off it is instead to Freiburg im Breisgau, but I'm highly
likely to be distracted by the lure of the Kaiserstuhl and
take my pitchfork instead into the wine fields and spend my
lynchin'-an'-tarrin'-an'-featherin' time preparing the
fields for next year, harvesting Eiswein or Trockenbeerenauslese,
and drinking to try to kill off those brane cells that still
are imprinted with painful memories of obsolete hardware and
incorrect usage of the Queen's mother tongue, or, as them 
europeans says it, livin' life like it's meant ta be lived.

And if tonight (or tomorrow, or whenever I pass out) I dream
about that ENIAC in my workshop, it's time to break out the
slivovice, damn brane cells.  Time to stop living.  In the past.


chin chin,
barry bouwsma
sorry, what's that?  oh yes, I will in fact shut up and beggar
off now, you're very welcome

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
