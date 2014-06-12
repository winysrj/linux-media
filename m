Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54560 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaFLPAF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 11:00:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	linux-arm-kernel@lists.infradead.org, Nishanth Menon <nm@ti.com>,
	Tony Lindgren <tony@atomide.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>, arm@kernel.org,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] staging: allow omap4iss to be modular
Date: Thu, 12 Jun 2014 17:00:40 +0200
Message-ID: <2967185.eJLTMz7aAr@avalon>
In-Reply-To: <4327970.JdCWevprmq@wuerfel>
References: <5192928.MkINji4uKU@wuerfel> <20140612142515.GA7653@kroah.com> <4327970.JdCWevprmq@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Thursday 12 June 2014 16:28:39 Arnd Bergmann wrote:
> On Thursday 12 June 2014 07:25:15 Greg KH wrote:
> > On Thu, Jun 12, 2014 at 04:15:32PM +0200, Arnd Bergmann wrote:
> > > On Thursday 12 June 2014 16:12:17 Laurent Pinchart wrote:
> > > > > From 3a965f4fd5a6b3ef4a66aa4e7c916cfd34fd5706 Mon Sep 17 00:00:00
> > > > > 2001
> > > > > From: Arnd Bergmann <arnd@arndb.de>
> > > > > Date: Tue, 21 Jan 2014 09:32:43 +0100
> > > > > Subject: [PATCH] [media] staging: tighten omap4iss dependencies
> > > > > 
> > > > > The OMAP4 camera support depends on I2C and VIDEO_V4L2, both
> > > > > of which can be loadable modules. This causes build failures
> > > > > if we want the camera driver to be built-in.
> > > > > 
> > > > > This can be solved by turning the option into "tristate",
> > > > > which unfortunately causes another problem, because the
> > > > > driver incorrectly calls a platform-internal interface
> > > > > for omap4_ctrl_pad_readl/omap4_ctrl_pad_writel.
> > > > > 
> > > > > Instead, this patch just forbids the invalid configurations
> > > > > and ensures that the driver can only be built if all its
> > > > > dependencies are built-in.
> > > > > 
> > > > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > > 
> > > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > 
> > > > Should I take this in my tree for v3.17 or would you like to
> > > > fast-track it ?> > 
> > > I'd actually like to see it in 3.15 as a stable backport if possible,
> > 
> > It's not stable material, sorry.
> 
> To clarify, I was talking about second version of the patch,
> not the original one. It just does this:
>
> >  config VIDEO_OMAP4
> >       bool "OMAP 4 Camera support"
> > -     depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && I2C && ARCH_OMAP4
> > +     depends on VIDEO_V4L2=y && VIDEO_V4L2_SUBDEV_API && I2C=y &&
> > ARCH_OMAP4
> >       select VIDEOBUF2_DMA_CONTIG
> >       ---help---
> >         Driver for an OMAP 4 ISS controller.
> 
> which enforces that configurations that cannot be compiled
> will not be selectable in Kconfig, so we can have allmodconfig
> working. I thought that was ok for -stable.
> 
> > > but definitely in 3.16. What is the normal path for staging/media
> > > but fix patches?
> > 
> > Through Mauro's tree.
> 
> Ok.

I've applied the patch to my tree and will send a pull request to Mauro for 
v3.16 as soon as you reach an agreement with Greg on whether I should add CC: 
stable or not.

-- 
Regards,

Laurent Pinchart

