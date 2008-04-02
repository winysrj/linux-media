Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JgrEF-0005pE-Eo
	for linux-dvb@linuxtv.org; Wed, 02 Apr 2008 02:54:27 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Aidan Thornton <makosoft@googlemail.com>
In-Reply-To: <c8b4dbe10804011406i6923397fw84de9393335dfee9@mail.gmail.com>
References: <a413d4880803301640u20b77b9cya5a812efec8ee25c@mail.gmail.com>
	<c8b4dbe10803311302n6edc8d0dtb1f816099e020946@mail.gmail.com>
	<d9def9db0803311559p3b4fe2a7gfb20477a2ac47144@mail.gmail.com>
	<c8b4dbe10804011406i6923397fw84de9393335dfee9@mail.gmail.com>
Date: Wed, 02 Apr 2008 02:53:19 +0200
Message-Id: <1207097599.7980.40.camel@pc08.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Lifeview DVB-T from v4l-dvb and Pinnacle Hybrid	USb
	from v4l-dvb-kernel......help
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

Am Dienstag, den 01.04.2008, 22:06 +0100 schrieb Aidan Thornton:
> On 3/31/08, Markus Rechberger <mrechberger@gmail.com> wrote:
> > On 3/31/08, Aidan Thornton <makosoft@googlemail.com> wrote:
> > > On Mon, Mar 31, 2008 at 12:40 AM, Another Sillyname
> > > <anothersname@googlemail.com> wrote:
> > > > I have a machine that has an internal card that's a Lifeview DVB and
> > > > works fine using the v4l-dvb mercurial sources.
> > > >
> > > > I want to add a Pinnacle USB Hybrid stick (em28xx) that does not work
> > > > using the v4l-dvb sources but does work using the v4l-dvb-kernel
> > > > version.
> > > >
> > > > 1. Will the number of em28xx cards supported by v4l-dvb be increased
> > > > shortly? (My card id was 94 IIRC ).
> > >
> > > If it's supported by v4l-dvb-kernel, it's entirely possible, yes.
> > >
> > > > 2. Can I mix and match from the sources...i.e. can I graft the em28xx
> > > > stuff from v4l-dvb-kernel into the v4l-dvb source and compile
> > > > successfully or has the underlying code changed at a more strategic
> > > > level?
> > >
> > > Not trivially, since v4l-dvb-kernel contains changes to the core code
> > > that the em28xx driver relies on and that are incompatible with
> > > changes in the main v4l-dvb repository since. You can try
> > > http://www.makomk.com/hg/v4l-dvb-makomk - it's the em28xx and xc3028
> > > drivers grafted onto a version of v4l-dvb that's about 5 months old at
> > > this point - though it's really not a great starting point for porting
> > > them onto newer versions, since you'd want to drop the xc3028 driver
> > > in favour of the newer one
> > >
> >
> > Makomk,
> > spreading around your even more broken tree won't help anyone.
> 
> My tree is not substantially more broken, thank you very much. I think
> it has at least one issue that v4l-dvb-kernel/v4l-dvb-experimental did
> not (HVR-950 support is rumoured to be broken - probably an issue with
> ATSC support in xc3028, which I couldn't test), but it also fixes one
> annoying bug (DVB-T only xc3028 based devices didn't work). I hear
> rumours that v4l-dvb-kernel also has issues with core changes breaking
> the other drivers in the tree, something this shouldn't have.
> 
> Also, in case you haven't guesses, the reason I spread my tree around
> so much is because I think that it might be helpful to people, either
> because they need something that isn't possible with
> v4l-dvb-experimental or (in one memorable past case) because you'd
> decided to erase all trace of -experimental from your site and I would
> actually be able to maintain the -makomk branch (unlike -experimental,
> which was hell to work with in places).
> 
> > This device already had some issues with the v4l-dvb-kernel tree, this
> > is what I'll do in April.
> >
> > > > 3. Why did the sources branch? Was there a good technical reason for
> > > this?
> > >
> > > Supporting the xc3028 silicon tuner needed some changes to support
> > > hybrid analog/digital tuners better. Unfortunately, Markus couldn't
> > > come to an agreement with the rest of the developers on how to do it.
> > > (I think the main concern were that the changes he were proposing were
> > > rather more invasive than they needed to be and risked breaking
> > > existing drivers). In the end, someone else coded the equivalent
> > > functionality in a more backwards-compatible way and merged it in
> > > stages.
> > >
> > > (It's actually relatively easy to port code from Markus' hybrid tuner
> > > framework to the v4l-dvb one, though he will never admit so.)
> > >
> >
> > The reason is my trust is gone I asked in September if it's possible
> > to get those devices work with what's available and I got the answer
> > it's not.
> 
> That's odd; early September was when I started on the v4l-dvb-makomk
> branch, which does exactly that. (Admittedly, it does rely on a
> slightly evil hack to share info between the analog and digital
> support in the xc3028 code, though one of the other devs figured out a
> better way of doing it. The xc3028 driver in now v4l-dvb is
> suprisingly good; far better than the previous drivers, and rewritten
> from scratch.)
> 
> Looking at the mailing lists, September was when you were pushing your
> userspace drivers idea, which stood a whelk's chance in a supernova of
> getting merged. (It (a) didn't do anything that couldn't be done
> in-kernel, (b) would make it much easier to release binary
> closed-source tuner drivers that only work on specific hardware and
> (c) was intentionally created to fork bits of v4l-dvb. Of course, you
> PMing me and threating to take your code closed source if anyone
> released changed versions - something this would make far, far easier
> - probably didn't exactly help, but it was obviously doomed before
> then.)
> 
> > This stupid fight lasts for more than 2 years already, but I'm the one
> > who spent weeks on writing code for getting those things supported and
> > even rewrote code although there was no serious participation in the
> > discussions I tried to trigger...
> 
> The mailing list developed some really nasty atmosphere, and you were
> part of the reason. (You probably haven't realised this, but when
> professional trolls decide it'd be fun to take your side, you ought to
> take a really close look at your behaviour.) I can't remember much of
> the details - I think I tried to stay out of it as much as possible.
> 
> > If I tell a company that I will add support for something till a given
> > date I'll do so to keep up the good contacts. Unfortunately this is
> > not how some people at linuxtv behave and it slows down everything
> > even for other manufacturers where I'm not involved.
> >
> > It's me who mostly spent his time on writing any code on mcentral.de,
> > the code didn't write itself especially Aidan has no respect about
> > that, neither do some other people. Maybe it's really better to
> > provide binary only blobs to remember especially such people that it
> > requires alot work to get those things work.
> 
> Yeah, you did some good coding work (and some not so good, but let's
> leave that aside). Unfortunately, IMO you exhausted any residual
> goodwill left over from that ages ago, for far too many reasons to go
> into. Also, you're forgetting all the other people who contributed
> time to testing and debugging your code - including me - as well as
> all the pre-existing code that you built on (including the initial
> version of em28xx itself).
> 
> Still, you did write some good code and do some good RE work, and I'll
> fully admit to that - it's why I'm reusing some of it for my modified
> drivers. After all, it'd be silly to let your hard work go to waste.
> (Admittedly, it's currently mostly down to some trivial code in
> em2880-dvb that's probably in "Writing Linux Drivers for USB DVB-T
> Devices For Dummies" and some init/modeswitching code that I
> practically know by heart, at least in the driver I'm using now, but
> I'm sure there's more useful code in there.)
> 
> > > > 4. If I can't use the v4l-dvb sources to get my em28xx working what's
> > > > the chances of getting the v4l-dvb-kernel stuff working for the
> > > > lifeview flydvb card?
> > >
> > > Not good. Its support for other hardware is, if anything, going to be
> > > slowly getting worse over time as other drivers have to be modified or
> > > disabled to make it compile on newer kernels.
> > >
> >
> > that for the other repository (em28xx-userspace2/userspace-drivers on
> > mcentral.de/hg) is available, although it needs some work with that
> > device.
> 
> Yeah, that... works, though it's still slightly lacking in both
> well-testedness and hardware support, and some of the code makes me
> wince.
> 
> Anyway, this is starting to get tiresome, so I think I'll leave it
> here. This is basically all I have to say on the matter.
> 
> Aidan


Hi Aidan,

nice story, but we might have it all slightly different.

Better stop to believe in that "professional troll" myth, on my list I
still count up to only one ;)

It was about exclusive contacts to manufacturers and data sheets
_previously_, before Markus, and who is allowed and who not.

The "who rules by the sword, must die by the sword" was only a not so
nice side effect, if you even noticed.

Nobody can come with crocodile tears in the eyes later on, if _by will_
are no sufficient rules in the jungle.

Major stuff is taken into the kernel, for which often only one single
developer has the NDA with the details and manufacturer contacts for,
stressing generations of users and testers.

Since Markus and all who helped did really hack this from bare bones
with lot of work, maybe now slightly coming into a better position, and
after even offering to take v4l-dvb all over if needed ;), if his
patches don't go in finally, unfortunately with a much to narrow time
frame, 24 hours, which was a impossible to resolve ultimatum, it went
like it did and I don't wonder ... 

Cheers,
Hermann







_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
