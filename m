Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758747Ab2J2LdJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 07:33:09 -0400
Date: Mon, 29 Oct 2012 09:32:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 0/2] Fix a few more warnings
Message-ID: <20121029093251.1bb2acfa@redhat.com>
In-Reply-To: <508E6644.4040104@samsung.com>
References: <1351506118-2385-1-git-send-email-mchehab@redhat.com>
	<508E6644.4040104@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 29 Oct 2012 12:19:32 +0100
Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:

> On 10/29/2012 11:21 AM, Mauro Carvalho Chehab wrote:
> > Hans Verkuil yesterday's build still got two warnings at the
> > generic drivers:
> >         http://hverkuil.home.xs4all.nl/logs/Sunday.log
> > 
> > They didn't appear at i386 build probably because of some
> > optimization done there.
> > 
> > Anyway, fixing them are trivial, so let's do it.
> > 
> > After applying those patches, the only drivers left producing
> > warnings are the following platform drivers:
> > 
> > drivers/media/platform/davinci/dm355_ccdc.c
> > drivers/media/platform/davinci/dm644x_ccdc.c
> > drivers/media/platform/davinci/vpbe_osd.c
> > drivers/media/platform/omap3isp/ispccdc.c
> > drivers/media/platform/omap3isp/isph3a_aewb.c
> > drivers/media/platform/omap3isp/isph3a_af.c
> > drivers/media/platform/omap3isp/isphist.c
> > drivers/media/platform/omap3isp/ispqueue.c
> > drivers/media/platform/omap3isp/ispvideo.c
> > drivers/media/platform/omap/omap_vout.c
> > drivers/media/platform/s5p-fimc/fimc-capture.c
> > drivers/media/platform/s5p-fimc/fimc-lite.c
> 
> For these two files I've sent already a pull request [1], which
> includes a fixup patch
> s5p-fimc: Don't ignore return value of vb2_queue_init()
> 
> BTW, shouldn't things like these be taken care when someone does
> a change at the core code ? 

Sure. I remember I saw one patch with s5p on that series[1].
Can't remember anymore if it were acked and merged directly, if
it was opted to send it via your tree (or maybe that patch was just
incomplete, and got unnoticed on that time).

[1] https://patchwork.kernel.org/patch/1372871/

It is not easy to enforce those kind of things for platform drivers,
as there's not yet a single .config file that could be used to test
all arm drivers. Hans automatic builds might be useful, if there weren't
any warns at the -git tree build at the tested archs, but there are
so many warnings that I think I never saw any such report saying that
there's no warning.

Btw, are there anyone really consistently using his reports to fix things?

> I'm not having issues in this case at all,
> but if there is many people doing constantly changes at the core it
> might imply for driver authors/maintainers wasting much of their time
> for fixing issues resulting from constant changes at the base code.

Regards,
Mauro
