Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52012 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753337AbZGUJVW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 05:21:22 -0400
From: "cyber.bogh" <cyber.bogh@gmx.de>
To: hermann pitton <hermann-pitton@arcor.de>
Subject: Re: [Bugme-new] [Bug 13709] New: b2c2-flexcop: no frontend driver found for this B2C2/FlexCop adapter w/ kernel-2.6.31-rc2
Date: Tue, 21 Jul 2009 11:20:01 +0200
References: <bug-13709-10286@http.bugzilla.kernel.org/> <20090720134024.274fbb6c.akpm@linux-foundation.org> <1248146821.3239.13.camel@pc07.localdom.local>
In-Reply-To: <1248146821.3239.13.camel@pc07.localdom.local>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Trent Piepho <xyzzy@speakeasy.org>,
	linux-media@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, bugzilla.kernel.org@boris64.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907211120.02036.cyber.bogh@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag 21 Juli 2009 05:27:01 schrieben Sie:
> Am Montag, den 20.07.2009, 13:40 -0700 schrieb Andrew Morton:
> > On Mon, 20 Jul 2009 13:21:33 -0700 (PDT)
> >
> > Trent Piepho <xyzzy@speakeasy.org> wrote:
> > > On Mon, 20 Jul 2009, Andrew Morton wrote:
> > > > (switched to email.  Please respond via emailed reply-to-all, not via
> > > > the bugzilla web interface).
> > > >
> > > >
> > > > Guys, this is reportedly a post-2.6.30 regression - I'll ask Rafael
> > > > to add it to the regression tracking list.
> > > >
> > > > btw, does the flexcop driver have a regular maintainer?  Or someone
> > > > who wants to volunteer?  MAINTAINERS is silent about it..
> > >
> > > I produced a patch that fixed this problem over a month ago,
> > > http://www.linuxtv.org/hg/~tap/v4l-dvb/rev/748c762fcf3e
> >
> > Where is that patch now?  It isn't present in linux-next.
> >
> > If it needs to be resent, please cc me on it?
> >
> >
> > Also, is there any way of avoiding this?
> >
> > +#define FE_SUPPORTED(fe) (defined(CONFIG_DVB_##fe) || \
> > + (defined(CONFIG_DVB_##fe##_MODULE) && defined(MODULE)))
> >
> > That's just way too tricky.  It expects all versions of the
> > preprocessor to be correctly implemented (unlikely) and there are other
> > tools like unifdef which want to parse kernel #defines.
> >
> > otoh the trick does produce a nice result and doing it any other way
> > (which I can think of) would make a mess.
> >
> > > Maybe it should go into 2.6.31?
> >
> > It depends on the seriousness of the regression (number of people
> > affected, whether there's a workaround, etc) and upon the riskiness of
> > the patch.
> >
> > But sure, we don't want regressions and letting one be released when we
> > already know about it and have a fix would be bad!
> >
> > If the patch is judged too risky at this time, there might be a simpler
> > one, perhaps.
> >
> > Or just revert whichever patch broke things.  Your changelog describes
> > this as simply "A recent patch" (bad changelog!) so I am unable to judge
> > this.
>
> Just revert it and let's wait for the next better attempt.
>
> We might get a lot of noise, but the patch was wrong.

Absolutely nothing was wrong.
Your pure existance here is wrong if there is something wrong here!
As long as you do not have any clue about the subject I advise you to simply 
shut up, Pitton!
Is that clear, Pitton???

cyber.bogh

> Cheers,
> Hermann
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

