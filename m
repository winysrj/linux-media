Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:42965 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZBMKrk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 05:47:40 -0500
Date: Fri, 13 Feb 2009 02:47:32 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Eduard Huguet <eduardhc@gmail.com>, linux-media@vger.kernel.org
Subject: Re: cx8802.ko module not being built with current HG tree
In-Reply-To: <20090211055338.393fa187@pedra.chehab.org>
Message-ID: <Pine.LNX.4.58.0902130225230.24268@shell2.speakeasy.net>
References: <617be8890902050754p4b8828c9o14b43b6879633cd7@mail.gmail.com>
 <200902102132.00114.hverkuil@xs4all.nl> <20090210184147.61d4655e@pedra.chehab.org>
 <200902102221.40067.hverkuil@xs4all.nl> <20090210221710.389c264e@pedra.chehab.org>
 <Pine.LNX.4.58.0902101633090.24268@shell2.speakeasy.net>
 <20090211055338.393fa187@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Feb 2009, Mauro Carvalho Chehab wrote:
> On Tue, 10 Feb 2009 17:20:52 -0800 (PST)
> Trent Piepho <xyzzy@speakeasy.org> wrote:
> > I still think using select is better.  What Roman Zippel was talking about
> > was the mess with select and the tuner drivers.  I agree that's a mess and
> > there are better ways to do it without using select.  But the MPEG module
> > is like a library used by just DVB and BLACKBIRD.  It seems like the ideal
> > case for using select.
>
> I can't foresee any case where this logic would fail in the future.
>
> Let's suppose that some newer dependencies would be needed. If those
> dependencies will be properly added at DVB and/or at BLACKBIRD, this logic will
> still work. There's no possible case where CX88_MPEG would need a dependency
> that aren't needed by either DVB and/or BLACKBIRD. Also, by using depends on,

I think this is the reason select is the better choice here.  The only
reason select might have a problem is if CX88_MPEG had a dependency that
that DVB and BLACKBIRD do not have.  But like you said, that isn't going to
happen, so there is no problem with select.

> instead of select, will warrant that CX88_MPEG will have the proper 'y' or 'm'
> value, depending on the dependencies of CX88_DVB and CX88_BLACKBIRD.

Using select like I did will result in CX88_MPEG having the proper 'y' or
'm' as well.

> It seems that this is exactly what Roman expected to be fixed by changing from
> "select" to "depends on" with tuners.

The problem with the tuners is that the many tuners each have many
different dependencies and are used by multiple drivers.  select requires
that the drivers using the tuners consider those depedencies and if the
tuners change the drivers must also be updated.  But with CX88_MPEG we
don't have this problem.

We also want to be able to manually override tuner selection, which makes
things even more complicated for the tuners.
