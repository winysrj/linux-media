Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758564Ab2J2Lig (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 07:38:36 -0400
Date: Mon, 29 Oct 2012 09:38:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 0/2] Fix a few more warnings
Message-ID: <20121029093809.0e61d769@redhat.com>
In-Reply-To: <6407737.rOrJiiUORE@avalon>
References: <1351506118-2385-1-git-send-email-mchehab@redhat.com>
	<6407737.rOrJiiUORE@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 29 Oct 2012 11:38:39 +0100
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Monday 29 October 2012 08:21:56 Mauro Carvalho Chehab wrote:
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
> > drivers/media/platform/sh_vou.c
> > drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> > 
> > Platform driver maintainers: please fix, as those warnings could be
> > hiding real bugs.
> 
> I've sent you a pull request for v3.7 on Thu, 25 Oct 2012 with two patches 
> that fix most of the warnings:
> 
>       omap3isp: video: Fix warning caused by bad vidioc_s_crop prototype
>       omap3isp: Fix warning caused by bad subdev events operations prototypes

Ok. I'll review it today.

> The other two OMAP3 ISP warnings are false positive. They will go away when 
> we'll switch to videobuf2 (which is on my to-do list).

While you're not ready to submit the omap3 vb2 patches, would you mind fixing
them? Failing to do that will prevent us to improve the process of detecting
warnings at day zero. For example, I suspect that  Hans automatic compilation
tool will keep saying that WARNINGS are present at -git, while we don't fix
all those platform warnings.

Regards,
Mauro
