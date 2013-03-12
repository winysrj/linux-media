Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:40501 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab3CLHwk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 03:52:40 -0400
Received: by mail-wg0-f54.google.com with SMTP id fm10so5669333wgb.33
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2013 00:52:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2890206.GE3SX5DoKH@avalon>
References: <CACKLOr0DGrULZmrzRuEqdm_Ec0hroCAXrnqLUFrc37YKpQ-Vpw@mail.gmail.com>
	<2233212.n9eBIia8fu@avalon>
	<CACKLOr3VojUn2CyVUxyA-6ESkGdx3h-ShmCXLEsD3czeYeQ=bg@mail.gmail.com>
	<2890206.GE3SX5DoKH@avalon>
Date: Tue, 12 Mar 2013 08:52:39 +0100
Message-ID: <CACKLOr3aLMvdyQb7_=rd0vn4=LsVi+agq82qrYno31DUWxYfbw@mail.gmail.com>
Subject: Re: omap3isp: iommu register problem.
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, Guennadi,

On 11 March 2013 21:51, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Javier,
>> [    2.706939] omap3isp omap3isp: Revision 15.0 found
>> [    2.712402] omap_iommu_attach: 1
>> [    2.715942] omap_iommu_attach: 2
>> [    2.719329] omap_iommu_attach: 3
>> [    2.722778] omap_iommu_attach: 4
>> [    2.726135] omap_iommu_attach: 5
>> [    2.729553] iommu_enable: 1
>> [    2.732482] iommu_enable: 2, arch_iommu = c0599adc
>> [    2.737548] iommu_enable: 3
>> [    2.740478] iommu_enable: 5
>> [    2.743652] omap-iommu omap-iommu.0: mmu_isp: version 1.1
>> [    2.749389] omap_iommu_attach: 6
>> [    2.752807] omap_iommu_attach: 7
>> [    2.756195] omap_iommu_attach: 8
>> [    2.759613] omap_iommu_attach: 9
>> [    2.763977] omap3isp omap3isp: hist: DMA channel = 2
>> [    2.770904] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
>> [    2.778839] ALSA device list:
>> [    2.781982]   No soundcards found.
>> [    2.799285] mt9m111 2-0048: mt9m111: driver needs platform data
>> [    2.805603] mt9m111: probe of 2-0048 failed with error -22
>> [    2.814849] omap3isp omap3isp: isp_register_subdev_group: Unable to
>> register subdev mt9m111
>>
>> The error I get now seems more related to the fact that I am trying to
>> use a soc-camera sensor (mt9m111) with a non-soc-camera host
>> (omap3isp) and I probably need some extra platform code.
>>
>> Do you know any board in mainline in a similar situation?
>
> There's none yet I'm afraid.
>
> We don't have the necessary infrastructure in place yet to allow this.
> Guennadi might be able to give you a bit more information about the current
> status.

So what kind of changes are required to make this work? Are we talking
about migrating each soc-camera sensor separately, soc-camera
framework changes, both of them?


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
