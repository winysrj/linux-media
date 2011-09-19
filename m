Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54184 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1ISIBK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 04:01:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: martin@neutronstar.dyndns.org
Subject: Re: [PATCH v2] arm: omap3evm: Add support for an MT9M032 based camera board.
Date: Mon, 19 Sep 2011 10:01:12 +0200
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1316252097-4213-1-git-send-email-martin@neutronstar.dyndns.org> <201109182358.55816.laurent.pinchart@ideasonboard.com> <20110919061019.GD9244@neutronstar.dyndns.org>
In-Reply-To: <20110919061019.GD9244@neutronstar.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109191001.12364.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Monday 19 September 2011 08:10:19 martin@neutronstar.dyndns.org wrote:
> On Sun, Sep 18, 2011 at 11:58:55PM +0200, Laurent Pinchart wrote:
> > On Saturday 17 September 2011 11:34:57 Martin Hostettler wrote:
> > > Adds board support for an MT9M032 based camera to omap3evm.
> > > 
> > > Sigend-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> > > ---
> > > 
> > >  arch/arm/mach-omap2/Makefile                |    1 +
> > >  arch/arm/mach-omap2/board-omap3evm-camera.c |  183
> > > 
> > > +++++++++++++++++++++++++++ 2 files changed, 184 insertions(+), 0
> > > deletions(-)
> > > 
> > >  create mode 100644 arch/arm/mach-omap2/board-omap3evm-camera.c
> > > 
> > > Changes in V2:
> > >  * ported to current mainline
> > >  * Style fixes
> > >  * Fix error handling
> > > 
> > > diff --git a/arch/arm/mach-omap2/Makefile
> > > b/arch/arm/mach-omap2/Makefile index f343365..8ae3d25 100644
> > > --- a/arch/arm/mach-omap2/Makefile
> > > +++ b/arch/arm/mach-omap2/Makefile
> > > +	return 0;
> > > +
> > > +err_8:
> > > +	gpio_free(EVM_TWL_GPIO_BASE + 8);
> > > +err_2:
> > > +	gpio_free(EVM_TWL_GPIO_BASE + 2);
> > > +err_vdsel:
> > > +	gpio_free(nCAM_VD_SEL);
> > > +err:
> > > +	return ret;
> > > +}
> > > +
> > > +device_initcall(camera_init);
> > 
> > Please don't use device_initcall(), but call the function directly from
> > the OMAP3 EVM init handler. Otherwise camera_init() will be called if
> > OMAP3 EVM support is compiled in the kernel, regardless of the board the
> > kernel runs on.
> 
> Ok, will do.
> In which header should the prototyp of that function go? Or can i just
> add a prototyp to board-omap3evm.c directly?
> I couldn't find anything that looked right, this is rather board specific
> after all.

You can either create arch/arm/mach-omap2/board-omap3evm.h or add the 
prototype to board-omap3evm.c.

-- 
Regards,

Laurent Pinchart
