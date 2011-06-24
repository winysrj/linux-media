Return-path: <mchehab@pedra>
Received: from einhorn.in-berlin.de ([192.109.42.8]:38997 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1FXWjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 18:39:46 -0400
Date: Sat, 25 Jun 2011 00:39:11 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Jesper Juhl <jj@chaosbits.net>,
	LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
	linux-media@vger.kernel.org, ceph-devel@vger.kernel.org,
	Sage Weil <sage@newdream.net>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a
 per-driver version - Was: Re: [PATCH 03/37] Remove unneeded version.h
 includes from include/
Message-ID: <20110625003911.5c14a95e@stein>
In-Reply-To: <BANLkTinZoax2fcSxvyQgfsT-bmsF+BofyQ@mail.gmail.com>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
	<4E04912A.4090305@infradead.org>
	<BANLkTim9cBiiK_GsZaspxpPJQDBvAcKCWg@mail.gmail.com>
	<201106241554.10751.hverkuil@xs4all.nl>
	<4E04A122.2080002@infradead.org>
	<20110624203404.7a3f6f6a@stein>
	<BANLkTimj-oEDvWxMao6zJ_sudUntEVjO1w@mail.gmail.com>
	<1308949448.2093.20.camel@morgan.silverblock.net>
	<20110624232048.66f1f98c@stein>
	<BANLkTinZoax2fcSxvyQgfsT-bmsF+BofyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jun 24 Devin Heitmueller wrote:
> On Fri, Jun 24, 2011 at 5:20 PM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
> > Easier:
> >  "I run Ubuntu 10.4".
> >  "I run kernel 2.6.32."
> > One of these is usually already included in the first post or IRC message
> > from the user.
> >
> > Separate driver versions are only needed on platforms where drivers are
> > not distributed by the operating system distributor, or driver source code
> > is not released within kernel source code.
> 
> Unfortunately, this doesn't work as all too often the user has "Ubuntu
> 10.1 but I installed the latest media_build tree a few months ago".
> Hence they are not necessarily on a particular binary release from a
> distro but rather have a mix of a distro's binary release and a
> v4l-dvb tree compiled from source.

If you release out-of-kernel-source driver sources for compilation against
binary kernels, and you have got users who go through this procedure, then
the user can for sure tell you the SCM version of the driver.

Besides, isn't this outdated practice in times where Joe Enduser can get
the very latest -rc kernel prepackaged on many distributions, including
ones like Ubuntu?

[Sorry, I'm getting perhaps a bit off-topic.]
-- 
Stefan Richter
-=====-==-== -==- ==--=
http://arcgraph.de/sr/
