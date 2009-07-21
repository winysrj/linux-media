Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:50522 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756408AbZGUWVj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 18:21:39 -0400
Subject: Re: [Bugme-new] [Bug 13709] New: b2c2-flexcop: no frontend driver
	found for this B2C2/FlexCop adapter w/ kernel-2.6.31-rc2
From: hermann pitton <hermann-pitton@arcor.de>
To: "cyber.bogh" <cyber.bogh@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Trent Piepho <xyzzy@speakeasy.org>,
	linux-media@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, bugzilla.kernel.org@boris64.net
In-Reply-To: <200907211120.02036.cyber.bogh@gmx.de>
References: <bug-13709-10286@http.bugzilla.kernel.org/>
	 <20090720134024.274fbb6c.akpm@linux-foundation.org>
	 <1248146821.3239.13.camel@pc07.localdom.local>
	 <200907211120.02036.cyber.bogh@gmx.de>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 00:16:54 +0200
Message-Id: <1248214614.16720.13.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Dienstag, den 21.07.2009, 11:20 +0200 schrieb cyber.bogh:
> Am Dienstag 21 Juli 2009 05:27:01 schrieben Sie:
> > Am Montag, den 20.07.2009, 13:40 -0700 schrieb Andrew Morton:
> > > On Mon, 20 Jul 2009 13:21:33 -0700 (PDT)
> > >
> > > Trent Piepho <xyzzy@speakeasy.org> wrote:
> > > > On Mon, 20 Jul 2009, Andrew Morton wrote:
> > > > > (switched to email.  Please respond via emailed reply-to-all, not via
> > > > > the bugzilla web interface).
> > > > >
> > > > >
> > > > > Guys, this is reportedly a post-2.6.30 regression - I'll ask Rafael
> > > > > to add it to the regression tracking list.
> > > > >
> > > > > btw, does the flexcop driver have a regular maintainer?  Or someone
> > > > > who wants to volunteer?  MAINTAINERS is silent about it..
> > > >
> > > > I produced a patch that fixed this problem over a month ago,
> > > > http://www.linuxtv.org/hg/~tap/v4l-dvb/rev/748c762fcf3e
> > >
> > > Where is that patch now?  It isn't present in linux-next.
> > >
> > > If it needs to be resent, please cc me on it?
> > >
> > >
> > > Also, is there any way of avoiding this?
> > >
> > > +#define FE_SUPPORTED(fe) (defined(CONFIG_DVB_##fe) || \
> > > + (defined(CONFIG_DVB_##fe##_MODULE) && defined(MODULE)))
> > >
> > > That's just way too tricky.  It expects all versions of the
> > > preprocessor to be correctly implemented (unlikely) and there are other
> > > tools like unifdef which want to parse kernel #defines.
> > >
> > > otoh the trick does produce a nice result and doing it any other way
> > > (which I can think of) would make a mess.
> > >
> > > > Maybe it should go into 2.6.31?
> > >
> > > It depends on the seriousness of the regression (number of people
> > > affected, whether there's a workaround, etc) and upon the riskiness of
> > > the patch.
> > >
> > > But sure, we don't want regressions and letting one be released when we
> > > already know about it and have a fix would be bad!
> > >
> > > If the patch is judged too risky at this time, there might be a simpler
> > > one, perhaps.
> > >
> > > Or just revert whichever patch broke things.  Your changelog describes
> > > this as simply "A recent patch" (bad changelog!) so I am unable to judge
> > > this.
> >
> > Just revert it and let's wait for the next better attempt.
> >
> > We might get a lot of noise, but the patch was wrong.
> 
> Absolutely nothing was wrong.
> Your pure existance here is wrong if there is something wrong here!
> As long as you do not have any clue about the subject I advise you to simply 
> shut up, Pitton!
> Is that clear, Pitton???
> 
> cyber.bogh
> 

As always and as expected ;)

Uwe, use at least your real name, if you say you are not trolling this
time and serious about it. Bad enough, that you always have to come with
new names and addresses.

The way you dealt with Boris reporting his trouble was disgusting.

Started here.
http://www.spinics.net/lists/linux-media/msg07746.html

Likely Matthias giving the hint with the #ifdef MODULE stuff has no clue
either ???

Trent's patches converting the tuners to dvb-pll later are not yet in
rc3 and the above fix attempt also not, but are all in mercurial
v4l-dvb. All not needed?

Why you don't provide Andrew with the information he is asking for?

Cheers,
Hermann




