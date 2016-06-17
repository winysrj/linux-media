Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50850 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbcFQOfI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 10:35:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 05/13] v4l: vsp1: Add FCP support
Date: Fri, 17 Jun 2016 17:35:18 +0300
Message-ID: <56417424.XBTKaMAJKY@avalon>
In-Reply-To: <20160617080723.7a760bf1@recife.lan>
References: <1461620198-13428-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1461620198-13428-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20160617080723.7a760bf1@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the review.

On Friday 17 Jun 2016 08:07:23 Mauro Carvalho Chehab wrote:
> Em Tue, 26 Apr 2016 00:36:30 +0300
> 
> Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:
> > On some platforms the VSP performs memory accesses through an FCP. When
> > that's the case get a reference to the FCP from the VSP DT node and
> > enable/disable it at runtime as needed.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  .../devicetree/bindings/media/renesas,vsp1.txt      |  5 +++++
> >  drivers/media/platform/Kconfig                      |  1 +
> >  drivers/media/platform/vsp1/vsp1.h                  |  2 ++
> >  drivers/media/platform/vsp1/vsp1_drv.c              | 21 +++++++++++++++-
> >  4 files changed, 28 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> > b/Documentation/devicetree/bindings/media/renesas,vsp1.txt index
> > 627405abd144..9b695bcbf219 100644
> > --- a/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> > +++ b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> > 
> > @@ -14,6 +14,11 @@ Required properties:
> >    - interrupts: VSP interrupt specifier.
> >    - clocks: A phandle + clock-specifier pair for the VSP functional
> >    clock.
> > 
> > +Optional properties:
> > +
> > +  - renesas,fcp: A phandle referencing the FCP that handles memory
> > accesses
> > +                 for the VSP. Not needed on Gen2, mandatory on Gen3.
> > +
> > 
> >  Example: R8A7790 (R-Car H2) VSP1-S node
> > 
> > diff --git a/drivers/media/platform/Kconfig
> > b/drivers/media/platform/Kconfig index f453910050be..a3304466e628 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -264,6 +264,7 @@ config VIDEO_RENESAS_VSP1
> >  	tristate "Renesas VSP1 Video Processing Engine"
> >  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
> >  	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
> > +	depends on !ARM64 || VIDEO_RENESAS_FCP
> 
> It sounds that this will break compile-test on ARM64 for no good reason.

On ARM64 the VSP driver requires FCP support, you can still compile-test it 
without any problem as long as you enable VIDEO_RENESAS_FCP.

-- 
Regards,

Laurent Pinchart

