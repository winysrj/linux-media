Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:34885 "EHLO arroyo.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757911AbcJXQjK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 12:39:10 -0400
Date: Mon, 24 Oct 2016 11:39:09 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 01/35] media: ti-vpe: vpdma: Make vpdma library into its
 own module
Message-ID: <20161024163909.GM31296@ti.com>
References: <20160928211643.26298-1-bparrot@ti.com>
 <20160928211643.26298-2-bparrot@ti.com>
 <30463f1c-4c12-b76c-81f4-d941668ecbd3@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <30463f1c-4c12-b76c-81f4-d941668ecbd3@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Thanks for the review.


Hans Verkuil <hverkuil@xs4all.nl> wrote on Mon [2016-Oct-17 16:08:55 +0200]:
> On 09/28/2016 11:16 PM, Benoit Parrot wrote:
> > The VPDMA (Video Port DMA) as found in devices such as DRA7xx is
> > used for both the Video Processing Engine (VPE) and the Video Input
> > Port (VIP).
> > 
> > In preparation for this we need to turn vpdma into its own
> > kernel module.
> > 
> > Signed-off-by: Benoit Parrot <bparrot@ti.com>
> > ---
> >  drivers/media/platform/Kconfig         |  6 ++++++
> >  drivers/media/platform/ti-vpe/Makefile |  4 +++-
> >  drivers/media/platform/ti-vpe/vpdma.c  | 28 +++++++++++++++++++++++++++-
> >  3 files changed, 36 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> > index f98ed3fd0efd..3c15c5a53bd5 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -334,6 +334,7 @@ config VIDEO_TI_VPE
> >  	depends on HAS_DMA
> >  	select VIDEOBUF2_DMA_CONTIG
> >  	select V4L2_MEM2MEM_DEV
> > +	select VIDEO_TI_VPDMA
> >  	default n
> >  	---help---
> >  	  Support for the TI VPE(Video Processing Engine) block
> > @@ -347,6 +348,11 @@ config VIDEO_TI_VPE_DEBUG
> >  
> >  endif # V4L_MEM2MEM_DRIVERS
> >  
> > +# TI VIDEO PORT Helper Modules
> > +# These will be selected by VPE and VIP
> > +config VIDEO_TI_VPDMA
> > +	tristate
> > +
> >  menuconfig V4L_TEST_DRIVERS
> >  	bool "Media test drivers"
> >  	depends on MEDIA_CAMERA_SUPPORT
> > diff --git a/drivers/media/platform/ti-vpe/Makefile b/drivers/media/platform/ti-vpe/Makefile
> > index e236059a60ad..faca5e115c1d 100644
> > --- a/drivers/media/platform/ti-vpe/Makefile
> > +++ b/drivers/media/platform/ti-vpe/Makefile
> > @@ -1,6 +1,8 @@
> >  obj-$(CONFIG_VIDEO_TI_VPE) += ti-vpe.o
> > +obj-$(CONFIG_VIDEO_TI_VPDMA) += ti-vpdma.o
> >  
> > -ti-vpe-y := vpe.o sc.o csc.o vpdma.o
> > +ti-vpe-y := vpe.o sc.o csc.o
> > +ti-vpdma-y := vpdma.o
> >  
> >  ccflags-$(CONFIG_VIDEO_TI_VPE_DEBUG) += -DDEBUG
> >  
> > diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
> > index 3e2e3a33e6ed..e55cb58213bf 100644
> > --- a/drivers/media/platform/ti-vpe/vpdma.c
> > +++ b/drivers/media/platform/ti-vpe/vpdma.c
> > @@ -75,6 +75,7 @@ const struct vpdma_data_format vpdma_yuv_fmts[] = {
> >  		.depth		= 16,
> >  	},
> >  };
> > +EXPORT_SYMBOL(vpdma_yuv_fmts);
> 
> EXPORT_SYMBOL_GPL?

I think for now I would rather go for consistency.
So I'll leave it as is.

Regards,
Benoit

> 
> (Up to you).
> 
> Regards,
> 
> 	Hans
