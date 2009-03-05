Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:43901 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbZCEUTM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 15:19:12 -0500
Date: Thu, 5 Mar 2009 12:19:06 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
In-Reply-To: <Pine.LNX.4.64.0903051954460.4980@axis700.grange>
Message-ID: <Pine.LNX.4.58.0903051217070.24268@shell2.speakeasy.net>
References: <200903022218.24259.hverkuil@xs4all.nl> <20090304141715.0a1af14d@pedra.chehab.org>
 <Pine.LNX.4.64.0903051954460.4980@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009, Guennadi Liakhovetski wrote:
> On Wed, 4 Mar 2009, Mauro Carvalho Chehab wrote:
> > Beside the fact that we don't need to strip support for legacy kernels, the
> > advantage of using this method is that we can evolute to a new development
> > model. As several developers already required, we should really use the
> > standard -git tree as everybody's else. This will simplify a lot the way we
> > work, and give us more agility to send patches upstream.
> >
> > With this backport script, plus the current v4l-dvb building systems, and after
> > having all backport rules properly mapped, we can generate a "test tree"
> > based on -git drivers/media, for the users to test the drivers against their
> > kernels, and still use a clean tree for development.
>
> Sorry, switching to git is great, but just to make sure I understood you
> right: by "-git drivers/media" you don't mean it is going to be a git tree
> of only drivers/media, but it is going to be a normal complete Linux
> kernel tree, right?

So there will be no way we can test a driver without switching to a new
kernel hourly?  And there is no way we can test someone else's tree without
compiling an entirely new kernel and rebooting?  And every tree we want to
work on requires a complete copy of the entire kernel source?
