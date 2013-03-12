Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43826 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab3CLNTa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 09:19:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: omap3isp: iommu register problem.
Date: Tue, 12 Mar 2013 14:20:04 +0100
Message-ID: <1574649.Ib7kFY8lEY@avalon>
In-Reply-To: <CACKLOr3aLMvdyQb7_=rd0vn4=LsVi+agq82qrYno31DUWxYfbw@mail.gmail.com>
References: <CACKLOr0DGrULZmrzRuEqdm_Ec0hroCAXrnqLUFrc37YKpQ-Vpw@mail.gmail.com> <2890206.GE3SX5DoKH@avalon> <CACKLOr3aLMvdyQb7_=rd0vn4=LsVi+agq82qrYno31DUWxYfbw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Tuesday 12 March 2013 08:52:39 javier Martin wrote:
> On 11 March 2013 21:51, Laurent Pinchart wrote:
> > Hi Javier,
> > 
> >> [    2.706939] omap3isp omap3isp: Revision 15.0 found
> >> [    2.712402] omap_iommu_attach: 1
> >> [    2.715942] omap_iommu_attach: 2
> >> [    2.719329] omap_iommu_attach: 3
> >> [    2.722778] omap_iommu_attach: 4
> >> [    2.726135] omap_iommu_attach: 5
> >> [    2.729553] iommu_enable: 1
> >> [    2.732482] iommu_enable: 2, arch_iommu = c0599adc
> >> [    2.737548] iommu_enable: 3
> >> [    2.740478] iommu_enable: 5
> >> [    2.743652] omap-iommu omap-iommu.0: mmu_isp: version 1.1
> >> [    2.749389] omap_iommu_attach: 6
> >> [    2.752807] omap_iommu_attach: 7
> >> [    2.756195] omap_iommu_attach: 8
> >> [    2.759613] omap_iommu_attach: 9
> >> [    2.763977] omap3isp omap3isp: hist: DMA channel = 2
> >> [    2.770904] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
> >> [    2.778839] ALSA device list:
> >> [    2.781982]   No soundcards found.
> >> [    2.799285] mt9m111 2-0048: mt9m111: driver needs platform data
> >> [    2.805603] mt9m111: probe of 2-0048 failed with error -22
> >> [    2.814849] omap3isp omap3isp: isp_register_subdev_group: Unable to
> >> register subdev mt9m111
> >> 
> >> The error I get now seems more related to the fact that I am trying to
> >> use a soc-camera sensor (mt9m111) with a non-soc-camera host
> >> (omap3isp) and I probably need some extra platform code.
> >> 
> >> Do you know any board in mainline in a similar situation?
> > 
> > There's none yet I'm afraid.
> > 
> > We don't have the necessary infrastructure in place yet to allow this.
> > Guennadi might be able to give you a bit more information about the
> > current status.
> 
> So what kind of changes are required to make this work? Are we talking
> about migrating each soc-camera sensor separately, soc-camera
> framework changes, both of them?

Both actually. The soc-camera core and soc-camera hosts first need to be 
extended to support both pad-aware and non pad-aware subdevs. Guennadi gave 
that a thought some time ago, I'm not sure what the status is.

Then the soc-camera platform data need to be split in a sensor part and a host 
part. This is required for DT support as well, so work is ongoing there. 
Finally your sensor driver will need to implement pad operations.

-- 
Regards,

Laurent Pinchart

