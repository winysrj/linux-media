Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41147 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab3K2RAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 12:00:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.12] VSP1 fixes
Date: Fri, 29 Nov 2013 18:00:54 +0100
Message-ID: <2938318.K2ZSSmoLDr@avalon>
In-Reply-To: <20131129145345.566ca131@samsung.com>
References: <2655285.sM6opACD3k@avalon> <20131129145345.566ca131@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Friday 29 November 2013 14:53:45 Mauro Carvalho Chehab wrote:
> Laurent Pinchart escreveu:
> > Hi Mauro,
> > 
> > Sorry for sending this so late in the -rc cycle. These three patches fix
> > issues with the VSP1 driver, including two compile issues that would break
> > allyesconfig and other compilation tests on v3.12.
> > 
> > The following changes since commit 
9c9cff55bf4f13dc2fffb5abe466f13e4ac155f9:
> >   [media] saa7134: Fix crash when device is closed before streamoff
> > 
> > (2013-10-14 06:37:00 -0300)
> > 
> > are available in the git repository at:
> >   git://linuxtv.org/pinchartl/media.git v4l2/fixes
> > 
> > for you to fetch changes up to b3e6a3ad4914d575a4026314c9fece0e47d4499e:
> >   v4l: VIDEO_RENESAS_VSP1 should depend on HAS_DMA (2013-10-15 17:37:46
> >   +0200)> 
> > ----------------------------------------------------------------
> > 
> > Geert Uytterhoeven (1):
> >       v4l: VIDEO_RENESAS_VSP1 should depend on HAS_DMA
> 
> This patch was already applied. I likely applied it directly, when I saw
> your acked-by for this one at patchwork.
> 
> > Laurent Pinchart (1):
> >       v4l: vsp1: Replace ioread32/iowrite32 I/O accessors with
> >       readl/writel
> 
> IMHO, this is not needed anymore. At least on my ktests, it is compiling
> fine on all archs that support allyesconfig/allmodconfig.

Agreed.

> On the other hand, readl/writel is not implemented on several archs.
> 
> > Wei Yongjun (1):
> >       v4l: vsp1: Fix error return code in vsp1_video_init()
> 
> Applied, thanks!

Thank you.

> >  drivers/media/platform/Kconfig           | 2 +-
> >  drivers/media/platform/vsp1/vsp1.h       | 4 ++--
> >  drivers/media/platform/vsp1/vsp1_video.c | 4 +++-
> >  3 files changed, 6 insertions(+), 4 deletions(-)
-- 
Regards,

Laurent Pinchart

