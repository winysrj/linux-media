Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:47880 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbZBDCa3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2009 21:30:29 -0500
Subject: Re: KWorld ATSC 115 all static
From: hermann pitton <hermann-pitton@arcor.de>
To: CityK <cityk@rogers.com>
Cc: David Engel <david@istwok.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <4987DE4E.2090902@rogers.com>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	 <496FE555.7090405@rogers.com> <496FFCE2.8010902@rogers.com>
	 <200901171720.03890.hverkuil@xs4all.nl> <49737088.7060800@rogers.com>
	 <20090202235820.GA9781@opus.istwok.net>  <4987DE4E.2090902@rogers.com>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 03:31:02 +0100
Message-Id: <1233714662.3728.45.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Dienstag, den 03.02.2009, 01:03 -0500 schrieb CityK:
> David Engel wrote:
> > As far as I can tell, this thread petered out without a resolution.  
> > CityK later posted on avsforum, however, that analog on his card was
> > after more changes by Hans.  I'm confused.  Is analog on the KWorld
> > 115 supposed to be working again or not?  I saw that some changes by
> > Hans made it into the main Hg repository, but as of yesterday, analog
> > still didn't work for me.
> >   
> 
> Nope, this thread is still alive and well -- I posted to it last Thurs
> (?), and Mauro replied, but I haven't had time to follow up with this
> since then. Anyway, here's a synopsis of the situation:
> 
> - Hans had a first go at the saa7134 (and related modules) in this work
> was in his v4l-dvb-saa7134 test repo .... these initial changes,
> unfortunately, were NOT sufficient on their own to get analog TV
> working. These changes did, however, get pulled into the mainline of v4l-dvb
> 
> - Hans' second attempt at this is found in his v4l-dvb-kworld test repo
> ... testing this code revealed that analog tv did indeed work again with
> tvtime ... I also noted that there seems to be a bit of redundancy now
> in terms of the tuner being initialized twice
> 
> - Mauro created a patch intended to be applied against mainline ... I
> tested and analog tv did NOT work

strange, that we don't see at least some error messages.

> - On Sunday Jan 25th I sent a lengthy message to the list, outlining
> some debug results etc. and also informing Mauro that his patch did NOT
> work ... I know that, at the very least, Trent and Hermann received that
> message, because they quoted from it in further discussion about the i2c
> gate (the inherent underlying problem at the heart of the issue).
> 
> - A few days later, scanning through the #irc logs, I caught a
> discussion, regarding Mauro's patch getting pulled into mainline, and
> the discussion seemed to indicate that there was some confusion as to
> what I had said worked and what doesn't. This surprised me for I had
> been pretty explicit in my Jan 25th mail list message. The other
> alternative was perhaps they simply had missed that message...so, in
> order to clear the situation up, I went to the mailing list archive to
> find a link for my message...only to discover it was NEVER
> achieved/recorded....grrrrr. So I'm at a complete loss as to who
> actually saw the Jan 25th message and who didn't.

On Jan. 18 the copy to the video4linux-list was dropped.
Some mailers by default have a limit there and the number of recipients
must be increased manually, i don't think it was intentionally.

However, all on linux-media should have received your postings and they
are in the archives.
http://www.spinics.net/lists/linux-media/msg00817.html

> - Further, somewhat concurrently, I discovered that (with Hans' kworld
> test repo) analog TV was ONLY working with tvtime ... xawtv/motv and
> kdetv were borked (I don't use Myth, so I have no idea what its status
> would be ... though, I'd suspect that it works like tvtime). I quickly
> traced this problem to be related to dga and Xv. A very similar
> situation with these apps existed several years ago when the proprietary
> X drivers from nvidia and ati removed dga functionality from their
> respective drivers (for some background read:
> http://www.nvnews.net/vbulletin/showthread.php?t=68232, and also the
> relevant portion of the FAQ from the nvidia readme:
> ftp://download.nvidia.com/XFree86/Linux-x86_64/180.27/README/chapter-07.html),
> however, the basic nv driver would still function. Nvidia would later
> provide a workaround to this issue in their driver.
> So, in this modern day occurrence of this similar error/bug, the obvious
> first test is to eliminate the proprietary driver from the equation.
> However, the test result with the nv driver was the same -- borked
> motv/xawtv and kdetv. I reported this, saying that I suspected that a
> something may have been introduced somewhere resulting in this issue
> with these apps resurfacing. This is why I asked that Hans' kworld repo
> NOT be pulled into mainline (if there had been any thought to that --
> though I don't think there was, because I now realize that I don't think
> many had even seen my prior Jan 25th message !) until further testing
> was performed.
> 
> - Mauro replied believing that this was unrelated to anything v4l-dvb,
> but rather an artefact of the X drivers. I suspected that that was NOT
> the case (the nv driver failing in my previous test was my cue). The
> next obvious test was to revert back to an older v4l-dvb snapshot that
> was patched with Mike Krufky's hack/workaround.
> 
> [reverting back should have been an easy task, but unfortunately I
> managed to turn it into a frustrating ordeal --- in the case of Hans'
> kworld source, the rminstall process did not blow away all the modules;
> further, while I had been testing channel scans with xawtv/motv/kdetv, I
> also tried with YAST, and unbeknownst to me, it must have saved an
> attempt at configing the ir remote --- so that, later, when no v4l-dvb
> modules were any longer present on the system, a config script somewhere
> must have been calling for the related remote control i2c-blah-blah-blah
> modules and the system would freeze, all too coincidently just when the
> nvidia x driver was starting up X ... and booting to failsafe and
> console mode was not working either (or at least not very well) ... so
> my initial belief that the very recent nvidia driver I installed had
> mucked up X, and that incorrect belief/assumption led to a masking of
> the real underlying problem for a while ... plus the fact that I really
> went off on a tangent messing around with xorg.conf and trying out some
> of the recent xinput modules etc etc ) .. anyway, as they say, all roads
> lead to Rome, and I eventually sorted everything out]
> 
> The older snapshot and Mike's patch worked as I expected it to. Removing
> that and installing Hans' kworld repo again --> xawtv/motv/kdetv = fail
> with Overlay. I can positively state, WITHOUT DOUBT, that there is
> something in Hans code that is sourcing this issue. I have not looked at
> it closely, nor do I know if I would recognise it when I do, though I
> suspect that it would be from initial batch of changes (inserted into
> the v4l-dvb-saa7134 repo).

I had a quick test on the in kernel radeon driver on Fedora 10 and
recent 2.6.27 with xawtv-3.95.

True is, that overlay-preview yields dga is not supported, but with
current v4l-dvb master and Hans' conversions mmap/grabdisplay works with
the old "xawtv -v 1 -nodga -remote -c /dev/video2" something.

Like you, I can't imagine that the earlier Kworld ATSC 110/15
initialization in Hans' kworld repo could be related to it.

> --------------------------------------------------------------------
> So the grand conclusion (aka state of the nation):
> --------------------------------------------------------------------
> 
> - how to provide a proper solution that will resolve the underlying i2c
> gate issue remains a point in discussion. In the meantime:
> 
> - Hans kworld repo:
> Pros: does provide analog tv functionality for, at a minimum, tvtime.
> Cons: The changes introduced result in, as testing to date has shown, a
> harmless bit of duplication in the way of the tuner being loaded twice.
> kdetv/motv/xawtv, at a minimum, do not work in overlay mode.

I can test on nv drivers as well next, they might have dropped support
for it too and just the x capabilies should be reported. For the second
attach of hybrid tuners in digital mode we maybe should print something
pointing to it.

> - Mainline v4l-dvb:
> Pros: none ... you will achieve this thread's namesake -- all static.
> Cons: since the code from Hans' v4l-dvb-saa7134 repo was merged, Mike's
> hack/workaround patch has been rendered ineffective for good. Mauro's
> later patch was also pulled into mainline, but it does not change the
> situation analog tv (and I do not mean in relation to Mike's patch, I
> mean precisely upon its own).
> 
> - Mike's hack/workaround patch
> Pros: it will apply and work with snapshots of v4l-dvb up to probably ~
> Jan 15th or so. All the apps that I tested with work as expected.
> Cons: in order to use analog tv, upon each boot, one must do what I
> termed being a dance with unloading and reloading the tuner module via
> modprobe.

I'm not sure if we even have the status of all devices potentially
seeing impacts, but reloading modules becomes more difficult, since we
load now saa7134-alsa by default. This will cause that apps like mixers
on runlevel 5 need to be closed before you can unload/reload
saa7134-alsa and saa7134 and then further any tuner modules.

This is fine for all the cards without such problems, but else one must
be aware off. With "options saa7134 alsa=0" the old behaviour is
restored.

Mauro also disabled saa7134-alsa support on saa7130 devices, which
simply do not support it and the deprecated saa7134-oss. Thanks! 

> - And finally, as an end note, DVB does, and always has, continue to
> work. As I eluded to earlier (somewhere within this growing thread), the
> assignment of RF input spigots has changed several times for these cards
> throughout the course of their Linux driver(s)'s lifetime. Currently, by
> default:
> DVB - digital cable is now accessed through the lower input. OTA/ATSC
> off the top input. ... this configuration is opposite to that which
> users of 2.6.24 era kernels are familiar with.
> Analog TV - regardless of whether ota or through cable is also off the
> top input.

Cheers,
Hermann


