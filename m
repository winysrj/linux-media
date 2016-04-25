Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36958 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbcDYNdU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 09:33:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 03/13] v4l: vsp1: Implement runtime PM support
Date: Mon, 25 Apr 2016 16:33:42 +0300
Message-ID: <3495523.9cqiUnevx8@avalon>
In-Reply-To: <CAMuHMdV9WKVCm_9Yj3FhkGQyvKaz2QorjZd=X1wFcb80bJhsoA@mail.gmail.com>
References: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1461455400-28767-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CAMuHMdV9WKVCm_9Yj3FhkGQyvKaz2QorjZd=X1wFcb80bJhsoA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

Thank you for the review.

On Monday 25 Apr 2016 10:24:22 Geert Uytterhoeven wrote:
> On Sun, Apr 24, 2016 at 1:49 AM, Laurent Pinchart
> 
> <laurent.pinchart+renesas@ideasonboard.com> wrote:
> > Replace the manual refcount and clock management code by runtime PM.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/media/platform/Kconfig          |   1 +
> >  drivers/media/platform/vsp1/vsp1.h      |   3 -
> >  drivers/media/platform/vsp1/vsp1_drv.c  | 101 ++++++++++++---------------
> >  drivers/media/platform/vsp1/vsp1_pipe.c |   2 +-
> >  4 files changed, 54 insertions(+), 53 deletions(-)
> > 
> > diff --git a/drivers/media/platform/Kconfig
> > b/drivers/media/platform/Kconfig index f453910050be..28d0db102c0b 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -264,6 +264,7 @@ config VIDEO_RENESAS_VSP1
> >         tristate "Renesas VSP1 Video Processing Engine"
> >         depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
> >         depends on (ARCH_RENESAS && OF) || COMPILE_TEST
> > +       depends on PM
> 
> PM is always enabled since commits 2ee98234b88174f2 ("arm64: renesas: Enable
> PM and PM_GENERIC_DOMAINS for SoCs with PM Domains") and 71d076ceb245f0d9
> ("ARM: shmobile: Enable PM and PM_GENERIC_DOMAINS for SoCs with PM
> Domains").
> 
> Even before that, drivers/sh/pm_runtime.c would have taken care of
> enabling the clocks for you.

OK, I'll fix that. COMPILE_TEST should be handled by the pm_runtime.h stub 
functions.

-- 
Regards,

Laurent Pinchart

