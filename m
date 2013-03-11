Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38842 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3CKUvE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 16:51:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: omap3isp: iommu register problem.
Date: Mon, 11 Mar 2013 21:51:38 +0100
Message-ID: <2890206.GE3SX5DoKH@avalon>
In-Reply-To: <CACKLOr3VojUn2CyVUxyA-6ESkGdx3h-ShmCXLEsD3czeYeQ=bg@mail.gmail.com>
References: <CACKLOr0DGrULZmrzRuEqdm_Ec0hroCAXrnqLUFrc37YKpQ-Vpw@mail.gmail.com> <2233212.n9eBIia8fu@avalon> <CACKLOr3VojUn2CyVUxyA-6ESkGdx3h-ShmCXLEsD3czeYeQ=bg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Monday 11 March 2013 16:28:58 javier Martin wrote:
> On 11 March 2013 16:01, Laurent Pinchart wrote:
> > On Monday 11 March 2013 13:18:12 javier Martin wrote:
> >> I've just found the following thread where te problem is explained:
> >> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-February/08636
> >> 4.h tml
> >> 
> >> The problem is related with the order iommu and omap3isp are probed
> >> when both are built-in. If I load omap3isp as a module the problem is
> >> gone.
> >> 
> >> However, according to the previous thread, omap3isp register should
> >> return error but an oops should not be generated. So I think there is
> >> a bug here anyway.
> > 
> > Does the following patch (compile-tested only) fix the issue ?
> > 
> > diff --git a/drivers/media/platform/omap3isp/isp.c
> > b/drivers/media/platform/omap3isp/isp.c index 6e5ad8e..4d889be 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -2123,6 +2123,7 @@ static int isp_probe(struct platform_device *pdev)
> >         ret = iommu_attach_device(isp->domain, &pdev->dev);
> >         if (ret) {
> >                 dev_err(&pdev->dev, "can't attach iommu device: %d\n",
> >                 ret);
> > +               ret = -EPROBE_DEFER;
> >                 goto free_domain;
> >         }
> > 
> > @@ -2161,6 +2162,7 @@ detach_dev:
> >         iommu_detach_device(isp->domain, &pdev->dev);
> >  free_domain:
> >         iommu_domain_free(isp->domain);
> > +       isp->domain = NULL;
> >  error_isp:
> >         omap3isp_put(isp);
> >  error:
>
> Yes, that solves the problems.

Great. I'll push the patch to v3.10 then.

> [    2.706939] omap3isp omap3isp: Revision 15.0 found
> [    2.712402] omap_iommu_attach: 1
> [    2.715942] omap_iommu_attach: 2
> [    2.719329] omap_iommu_attach: 3
> [    2.722778] omap_iommu_attach: 4
> [    2.726135] omap_iommu_attach: 5
> [    2.729553] iommu_enable: 1
> [    2.732482] iommu_enable: 2, arch_iommu = c0599adc
> [    2.737548] iommu_enable: 3
> [    2.740478] iommu_enable: 5
> [    2.743652] omap-iommu omap-iommu.0: mmu_isp: version 1.1
> [    2.749389] omap_iommu_attach: 6
> [    2.752807] omap_iommu_attach: 7
> [    2.756195] omap_iommu_attach: 8
> [    2.759613] omap_iommu_attach: 9
> [    2.763977] omap3isp omap3isp: hist: DMA channel = 2
> [    2.770904] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
> [    2.778839] ALSA device list:
> [    2.781982]   No soundcards found.
> [    2.799285] mt9m111 2-0048: mt9m111: driver needs platform data
> [    2.805603] mt9m111: probe of 2-0048 failed with error -22
> [    2.814849] omap3isp omap3isp: isp_register_subdev_group: Unable to
> register subdev mt9m111
> 
> The error I get now seems more related to the fact that I am trying to
> use a soc-camera sensor (mt9m111) with a non-soc-camera host
> (omap3isp) and I probably need some extra platform code.
> 
> Do you know any board in mainline in a similar situation?

There's none yet I'm afraid.

We don't have the necessary infrastructure in place yet to allow this. 
Guennadi might be able to give you a bit more information about the current 
status.

-- 
Regards,

Laurent Pinchart

