Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932770Ab2JYNqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 09:46:44 -0400
Date: Thu, 25 Oct 2012 11:46:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
	<kernel@pengutronix.de>, <g.liakhovetski@gmx.de>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <javier.martin@vista-silicon.com>
Subject: Re: [PATCH 1/2] ARM: clk-imx27: Add missing clock for mx2-camera
Message-ID: <20121025114624.7896b5d9@redhat.com>
In-Reply-To: <20121025113841.4e06cc3b@redhat.com>
References: <1349473981-15084-1-git-send-email-fabio.estevam@freescale.com>
	<1349473981-15084-2-git-send-email-fabio.estevam@freescale.com>
	<20121025113841.4e06cc3b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 25 Oct 2012 11:38:41 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Hi Fábio,
> 
> Em Fri, 5 Oct 2012 18:53:01 -0300
> Fabio Estevam <fabio.estevam@freescale.com> escreveu:
> 
> > During the clock conversion for mx27 the "per4_gate" clock was missed to get
> > registered as a dependency of mx2-camera driver.
> > 
> > In the old mx27 clock driver we used to have:
> > 
> > DEFINE_CLOCK1(csi_clk, 0, NULL, 0, parent, &csi_clk1, &per4_clk);
> > 
> > ,so does the same in the new clock driver.
> > 
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> > ---
> >  arch/arm/mach-imx/clk-imx27.c |    1 +
> 
> As this patch is for arch/arm, I'm understanding that it will be merged
> via arm tree. So,
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Forgot to comment: as patch 2 relies on this change, the better, IMHO, is
to send both via the same tree. If you decide to do so, please get arm
maintainer's ack, instead, and we can merge both via my tree.

> 
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
> > index 3b6b640..5ef0f08 100644
> > --- a/arch/arm/mach-imx/clk-imx27.c
> > +++ b/arch/arm/mach-imx/clk-imx27.c
> > @@ -224,6 +224,7 @@ int __init mx27_clocks_init(unsigned long fref)
> >  	clk_register_clkdev(clk[lcdc_ipg_gate], "ipg", "imx-fb.0");
> >  	clk_register_clkdev(clk[lcdc_ahb_gate], "ahb", "imx-fb.0");
> >  	clk_register_clkdev(clk[csi_ahb_gate], "ahb", "mx2-camera.0");
> > +	clk_register_clkdev(clk[per4_gate], "per", "mx2-camera.0");
> >  	clk_register_clkdev(clk[usb_div], "per", "fsl-usb2-udc");
> >  	clk_register_clkdev(clk[usb_ipg_gate], "ipg", "fsl-usb2-udc");
> >  	clk_register_clkdev(clk[usb_ahb_gate], "ahb", "fsl-usb2-udc");
> 
> 


-- 
Regards,
Mauro
