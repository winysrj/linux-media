Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54503 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaFLOvg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 10:51:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Arnd Bergmann <arnd@arndb.de>, gregkh@linuxfoundation.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, arm@kernel.org
Subject: Re: [PATCH] [media] staging: allow omap4iss to be modular
Date: Thu, 12 Jun 2014 16:52:10 +0200
Message-ID: <2207210.T6NoNSQSCo@avalon>
In-Reply-To: <20140611144754.GA17845@atomide.com>
References: <5192928.MkINji4uKU@wuerfel> <20140611144754.GA17845@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony,

On Wednesday 11 June 2014 07:47:54 Tony Lindgren wrote:
> * Arnd Bergmann <arnd@arndb.de> [140611 07:37]:
> > The OMAP4 camera support depends on I2C and VIDEO_V4L2, both
> > of which can be loadable modules. This causes build failures
> > if we want the camera driver to be built-in.
> 
> That's good news, but let's not fix it this way.
> 
> > This can be solved by turning the option into "tristate",
> > which unfortunately causes another problem, because the
> > driver incorrectly calls a platform-internal interface
> > for omap4_ctrl_pad_readl/omap4_ctrl_pad_writel.
> > To work around that, we can export those symbols, but
> > that isn't really the correct solution, as we should not
> > have dependencies on platform code this way.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > This is one of just two patches we currently need to get
> > 'make allmodconfig' to build again on ARM.
> > 
> > diff --git a/arch/arm/mach-omap2/control.c b/arch/arm/mach-omap2/control.c
> > index 751f354..05d2d98 100644
> > --- a/arch/arm/mach-omap2/control.c
> > +++ b/arch/arm/mach-omap2/control.c
> > @@ -190,11 +190,13 @@ u32 omap4_ctrl_pad_readl(u16 offset)
> >  {
> >  	return readl_relaxed(OMAP4_CTRL_PAD_REGADDR(offset));
> >  }
> > +EXPORT_SYMBOL_GPL(omap4_ctrl_pad_readl);
> > 
> >  void omap4_ctrl_pad_writel(u32 val, u16 offset)
> >  {
> >  	writel_relaxed(val, OMAP4_CTRL_PAD_REGADDR(offset));
> >  }
> > +EXPORT_SYMBOL_GPL(omap4_ctrl_pad_writel);
> > 
> >  #ifdef CONFIG_ARCH_OMAP3
> 
> Exporting these will likely cause immediate misuse in other
> drivers all over the place.
> 
> These should just use either pinctrl-single.c instead for muxing.
> Or if they are not mux registers, we do have the syscon mapping
> available in omap4.dtsi that pbias-regulator.c is already using.
> 
> Laurent, got any better ideas?

The ISS driver needs to write a single register, which contains several 
independent fields. They thus need to be controlled by a single driver. Some 
of them might be considered to be related to pinmuxing (although I disagree on 
that), others are certainly not about muxing (there are clock gate bits for 
instance).

Using the syscon mapping seems like the best option. I'll give it a try.

-- 
Regards,

Laurent Pinchart

