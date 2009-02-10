Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:56803 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbZBJAgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 19:36:19 -0500
Subject: Re: KWorld ATSC 115 all static
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: CityK <cityk@rogers.com>, V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Borke <joshborke@gmail.com>, David Lonie <loniedavid@gmail.com>,
	David Engel <david@istwok.net>, linux-media@vger.kernel.org
In-Reply-To: <20090209004343.5533e7c4@caramujo.chehab.org>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	 <496FE555.7090405@rogers.com> <496FFCE2.8010902@rogers.com>
	 <200901171720.03890.hverkuil@xs4all.nl> <49737088.7060800@rogers.com>
	 <20090202235820.GA9781@opus.istwok.net> <4987DE4E.2090902@rogers.com>
	 <20090209004343.5533e7c4@caramujo.chehab.org>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 01:37:15 +0100
Message-Id: <1234226235.2790.27.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 09.02.2009, 00:43 -0200 schrieb Mauro Carvalho Chehab:
> On Tue, 03 Feb 2009 01:03:58 -0500
> CityK <cityk@rogers.com> wrote:
> 
> > David Engel wrote:
> > > As far as I can tell, this thread petered out without a resolution.  
> > > CityK later posted on avsforum, however, that analog on his card was
> > > after more changes by Hans.  I'm confused.  Is analog on the KWorld
> > > 115 supposed to be working again or not?  I saw that some changes by
> > > Hans made it into the main Hg repository, but as of yesterday, analog
> > > still didn't work for me.
> > >   
> > 
> > Nope, this thread is still alive and well -- I posted to it last Thurs
> > (?), and Mauro replied, but I haven't had time to follow up with this
> > since then. Anyway, here's a synopsis of the situation:
> > 
> > - Hans had a first go at the saa7134 (and related modules) in this work
> > was in his v4l-dvb-saa7134 test repo .... these initial changes,
> > unfortunately, were NOT sufficient on their own to get analog TV
> > working. These changes did, however, get pulled into the mainline of v4l-dvb
> > 
> > - Hans' second attempt at this is found in his v4l-dvb-kworld test repo
> > ... testing this code revealed that analog tv did indeed work again with
> > tvtime ... I also noted that there seems to be a bit of redundancy now
> > in terms of the tuner being initialized twice
> > 
> > - Mauro created a patch intended to be applied against mainline ... I
> > tested and analog tv did NOT work
> > 
> > - On Sunday Jan 25th I sent a lengthy message to the list, outlining
> > some debug results etc. and also informing Mauro that his patch did NOT
> > work ... I know that, at the very least, Trent and Hermann received that
> > message, because they quoted from it in further discussion about the i2c
> > gate (the inherent underlying problem at the heart of the issue).
> > 
> > - A few days later, scanning through the #irc logs, I caught a
> > discussion, regarding Mauro's patch getting pulled into mainline, and
> > the discussion seemed to indicate that there was some confusion as to
> > what I had said worked and what doesn't. This surprised me for I had
> > been pretty explicit in my Jan 25th mail list message. The other
> > alternative was perhaps they simply had missed that message...so, in
> > order to clear the situation up, I went to the mailing list archive to
> > find a link for my message...only to discover it was NEVER
> > achieved/recorded....grrrrr. So I'm at a complete loss as to who
> > actually saw the Jan 25th message and who didn't.
> > 
> > - Further, somewhat concurrently, I discovered that (with Hans' kworld
> > test repo) analog TV was ONLY working with tvtime ... xawtv/motv and
> > kdetv were borked (I don't use Myth, so I have no idea what its status
> > would be ... though, I'd suspect that it works like tvtime). I quickly
> > traced this problem to be related to dga and Xv. A very similar
> > situation with these apps existed several years ago when the proprietary
> > X drivers from nvidia and ati removed dga functionality from their
> > respective drivers (for some background read:
> > http://www.nvnews.net/vbulletin/showthread.php?t=68232, and also the
> > relevant portion of the FAQ from the nvidia readme:
> > ftp://download.nvidia.com/XFree86/Linux-x86_64/180.27/README/chapter-07.html),
> > however, the basic nv driver would still function. Nvidia would later
> > provide a workaround to this issue in their driver.
> > So, in this modern day occurrence of this similar error/bug, the obvious
> > first test is to eliminate the proprietary driver from the equation.
> > However, the test result with the nv driver was the same -- borked
> > motv/xawtv and kdetv. I reported this, saying that I suspected that a
> > something may have been introduced somewhere resulting in this issue
> > with these apps resurfacing. This is why I asked that Hans' kworld repo
> > NOT be pulled into mainline (if there had been any thought to that --
> > though I don't think there was, because I now realize that I don't think
> > many had even seen my prior Jan 25th message !) until further testing
> > was performed.
> > 
> > - Mauro replied believing that this was unrelated to anything v4l-dvb,
> > but rather an artefact of the X drivers. I suspected that that was NOT
> > the case (the nv driver failing in my previous test was my cue). The
> > next obvious test was to revert back to an older v4l-dvb snapshot that
> > was patched with Mike Krufky's hack/workaround.
> 
> It took me some time today to bisect and trying to see what's going wrong with
> some userspace apps. 
> 
> At the end, I discovered that changeset 10240 fixed a bug that affected some
> userspace bad behaviour of setting defaults to zero, if a control is not found.
> 
> Due to that userspace bad behaviour, both tvtime and xawtv were using 0 for all
> video controls (brightness, contrast, color, hue). The practical effect is that
> a black image were displayed.
> 
> The fix were as simple as putting all controls at 50%.
> 
> Could this be your case also?
> 
> Cheers,
> Mauro
> 

Mauro, I know you are waiting for CityK, but I can report so far that I
never did see that black screen going away by adjusting the controls and
never had that black screen.

Tvtime and xawtv were always working under my conditions so far.

The very old troubles, like tda9887 not present after boot on my md7134
devices with FMD1216ME MK3 hybrid, and the even unrelated issue with the
tda10046 not properly controlled anymore after suspend/resume,
are unchanged on your current saa7134 attempt, but also no new issues
visible so far.

Cheers,
Hermann






