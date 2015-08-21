Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55380 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbHUWcO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 18:32:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi
Subject: Re: [PATCH] v4l: omap3isp: Enable driver compilation with COMPILE_TEST
Date: Sat, 22 Aug 2015 01:32:10 +0300
Message-ID: <14726163.UmoqPsfLVT@avalon>
In-Reply-To: <20150821174515.360b87e9@recife.lan>
References: <1440180557-28180-1-git-send-email-laurent.pinchart@ideasonboard.com> <20150821174515.360b87e9@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Friday 21 August 2015 17:45:15 Mauro Carvalho Chehab wrote:
> Em Fri, 21 Aug 2015 21:09:17 +0300 Laurent Pinchart escreveu:
> > The omap3isp driver can't be compiled on non-ARM platforms but has no
> > compile-time dependency on OMAP. Drop the OMAP dependency when
> > COMPILE_TEST is set.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/platform/Kconfig | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/platform/Kconfig
> > b/drivers/media/platform/Kconfig index 484038185ae3..95f0f6e6bbc8 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -85,7 +85,9 @@ config VIDEO_M32R_AR_M64278
> > 
> >  config VIDEO_OMAP3
> >  	tristate "OMAP 3 Camera support"
> > -	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
> > +	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> > +	depends on ARCH_OMAP3 || COMPILE_TEST
> > +	depends on ARM
> >  	depends on HAS_DMA && OF
> >  	depends on OMAP_IOMMU
> >  	select ARM_DMA_USE_IOMMU
> 
> Sorry, but this doesn't make sense.
> 
> We can only add COMPILE_TEST after getting rid of those
> 	depends on OMAP_IOMMU
>   	select ARM_DMA_USE_IOMMU
> 
> The COMPILE_TEST flag was added to support building drivers with
> allyesconfig/allmodconfig for all archs. Selecting a sub-arch
> specific configuration doesn't help at all (or make any difference,
> as if such subarch is already selected, a make allmodconfig/allyesconfig
> will build the driver anyway).

As explained in the commit message, the driver currently explicitly depends on 
the OMAP IOMMU API (as well as the ARM DMA mapping API). That's something that 
will be removed at some point in the future (it "only" requires finding time 
to clean the code). COMPILE_TEST will then be useful and will need to be 
enabled by a patch similar to this one. I thus don't see a big reason not to 
enable COMPILE_TEST support now.

> One of the main reasons why this is interesting is to support the
> Coverity Scan community license, used by the Kernel janitors. This
> tool runs only on x86.

Not all drivers can be compiled on x86, some dependencies on ARM APIs can be 
valid. COMPILE_TEST with a dependency on ARM is already useful as it gives a 
much wider compile coverage than depending on a particular ARM platform. I 
would even not be surprised if the Linux kernel was compiled for ARM more 
often that x86 nowadays.

As for coverity, how does running on x86 doesn't preclude analyzing source 
code written for ARM platforms ?

-- 
Regards,

Laurent Pinchart

