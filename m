Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab3CYLHB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 07:07:01 -0400
Date: Mon, 25 Mar 2013 08:06:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>
Subject: Re: [GIT PULL FOR v3.10] go7007 driver overhaul
Message-ID: <20130325080654.20e6c746@redhat.com>
In-Reply-To: <201303251002.29967.hverkuil@xs4all.nl>
References: <201303221536.35993.hverkuil@xs4all.nl>
	<20130324131340.720a59dd@redhat.com>
	<201303251002.29967.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Mar 2013 10:02:29 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Sun March 24 2013 17:13:40 Mauro Carvalho Chehab wrote:
> > Em Fri, 22 Mar 2013 15:36:35 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
...
> > >       saa7134-go7007: add support for this combination.
> > 
> > I won't apply this one yet. A non-staging driver should not try to load a
> > staging one without a notice. That change would be ok if you were also
> > moving go7007 out of staging.
> 
> Fair enough. I will prepare a patch that at least updates the saa7134-go7007.c
> source with my changes. That only leaves the patch to saa7134 itself that will
> need to be applied once this driver goes out of staging.

Ok.

> > 
> > >       s2250: add comment describing the hardware.
> > >       go7007-loader: renamed from s2250-loader
> > >       go7007-loader: add support for the other devices and move fw files
> > >       go7007: update the README
> > 
> > You need to add there:
> > 	- move cypress load firmware to drivers/media/common;
> > 
> > And some note about saa7134 integration.
> 
> Would it be OK if I add the saa7134 patch to the go7007 directory? Rather
> than keeping it around in my git tree?

What do you mean? Adding a diff file there? If so, that sounds weird. If you're
afraid of losing it, post it at the ML as RFC instead and add a pointer to the
patchwork number for such RFC patch at README.

> > >       MAINTAINERS: add the go7007 driver.
> > >       go7007: a small improvement to querystd handling.
> > >       go7007: add back 'repeat sequence header' control.
> > >       go7007: correct a header check: MPEG4 has a different GOP code.
> > >       go7007: drop firmware name in board config, make configs const.
> > >       go7007: don't continue if firmware can't be loaded.
> > 
> > This one didn't apply. Maybe due to the lack of saa7134-go7007.
> > 
> > Maybe it is just a trivial merging conflict, but better if you could
> > check it before forcing it.
> 
> Will do.

Thanks!
Mauro
