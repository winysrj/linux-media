Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49557 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab1KWNNC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 08:13:02 -0500
Date: Wed, 23 Nov 2011 14:12:50 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, r.schwebel@pengutronix.de
Subject: Re: [PATCH v2 2/2] MEM2MEM: Add support for eMMa-PrP mem2mem
 operations.
Message-ID: <20111123131250.GT27267@pengutronix.de>
References: <1321963316-9058-1-git-send-email-javier.martin@vista-silicon.com>
 <1321963316-9058-3-git-send-email-javier.martin@vista-silicon.com>
 <20111122205552.GO27267@pengutronix.de>
 <CACKLOr0-GzO0r0ERCQvqCn2oDkDE816+MHsu=bLbA5BkEBAqYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACKLOr0-GzO0r0ERCQvqCn2oDkDE816+MHsu=bLbA5BkEBAqYA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 23, 2011 at 01:32:29PM +0100, javier Martin wrote:
> Hi Sascha,
> I was just trying to fix the issues you pointed previously and I have
> a question for you.
> 
> On 22 November 2011 21:55, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > Hi Javier,
> >> +
> >> +static int emmaprp_probe(struct platform_device *pdev)
> >> +{
> >> +     struct emmaprp_dev *pcdev;
> >> +     struct video_device *vfd;
> >> +     struct resource *res_emma;
> >> +     int irq_emma;
> >> +     int ret;
> >> +
> >> +     pcdev = kzalloc(sizeof *pcdev, GFP_KERNEL);
> >> +     if (!pcdev)
> >> +             return -ENOMEM;
> >> +
> >> +     spin_lock_init(&pcdev->irqlock);
> >> +
> >> +     pcdev->clk_emma = clk_get(NULL, "emma");
> >
> > You should change the entry for the emma in
> > arch/arm/mach-imx/clock-imx27.c to the following:
> >
> > _REGISTER_CLOCK("m2m-emmaprp", NULL, emma_clk)
> >
> > and use clk_get(&pdev->dev, NULL) here.
> >
> 
> Is this what you are asking for?
> 
> --- a/arch/arm/mach-imx/clock-imx27.c
> +++ b/arch/arm/mach-imx/clock-imx27.c
> @@ -661,7 +661,7 @@ static struct clk_lookup lookups[] = {
>         _REGISTER_CLOCK(NULL, "dma", dma_clk)
>         _REGISTER_CLOCK(NULL, "rtic", rtic_clk)
>         _REGISTER_CLOCK(NULL, "brom", brom_clk)
> -       _REGISTER_CLOCK(NULL, "emma", emma_clk)
> +       _REGISTER_CLOCK("m2m-emmaprp", NULL, emma_clk)
>         _REGISTER_CLOCK(NULL, "slcdc", slcdc_clk)
>         _REGISTER_CLOCK("imx27-fec.0", NULL, fec_clk)
>         _REGISTER_CLOCK(NULL, "emi", emi_clk)
> 
> If I do that, mx2_camera.c will stop working.

This depends on the platform device id. If you use with -1
you have to use "m2m-emmaprp", if you use 0 (as you did I think)
you have to use "m2m-emmaprp.0". Basically the string has to
match the device name as found in /sys/devices/platform/

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
