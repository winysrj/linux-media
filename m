Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:60782 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271AbaEENHA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 May 2014 09:07:00 -0400
Date: Mon, 5 May 2014 15:06:57 +0200 (CEST)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	stable@vger.kernel.org
Subject: Re: [PATCH] omap3isp: Fix iommu domain use-after-free in isp_probe()
 error path
In-Reply-To: <2047675.m2gtpURIVn@avalon>
Message-ID: <alpine.DEB.2.01.1405051504180.30493@pmeerw.net>
References: <1398845610-12954-1-git-send-email-pmeerw@pmeerw.net> <2047675.m2gtpURIVn@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

> > isp_save_ctx() is called from omap3isp_put() after iommu_domain_free() in
> > the isp_probe() error path
> > 
> > [    3.205047] Unable to handle kernel NULL pointer dereference at virtual
> > address 0000003c [    3.213470] pgd = c0004000
> > [    3.216308] [0000003c] *pgd=00000000
> > [    3.220031] Internal error: Oops: 5 [#1] PREEMPT ARM
> > [    3.225189] Modules linked in:
> > [    3.228363] CPU: 0    Not tainted  (3.7.10 #3)
> > [    3.232971] PC is at omap2_iommu_save_ctx+0x0/0x34
> > [    3.237945] LR is at omap_iommu_save_ctx+0x1c/0x24
> > [    3.242919] pc : [<c0026a24>]    lr : [<c02b5878>]    psr: 60000113
> > ...
> > [    3.425109] [<c0026a24>] (omap2_iommu_save_ctx+0x0/0x34) from
> > [<c02b5878>] (omap_iommu_save_ctx+0x1c/0x24)
> > [    3.435150] [<c02b5878>] (omap_iommu_save_ctx+0x1c/0x24) from
> > [<c027f39c>] (omap3isp_put+0x84/0xfc)
> > [    3.444519] [<c027f39c>] (omap3isp_put+0x84/0xfc) from [<c0392b64>]
> > (isp_probe+0x8d8/0xa60)
> > [    3.453186] [<c0392b64>] (isp_probe+0x8d8/0xa60) from [<c01fa72c>]
> > (platform_drv_probe+0x14/0x18)
> > [    3.462402] [<c01fa72c>] (platform_drv_probe+0x14/0x18) from [<c01f982c>]
> > (driver_probe_device+0xb0/0x1dc)
> > 
> > compare isp_remove(): isp->domain is set to NULL after iommu_domain_free()
> > 
> > above crash is observed with 3.7
> > the issue is fixed in 3.11 (7c0f812a5d65e712618af880dda4a5cc7ed79463),
> > but present in 3.10 longterm
> 
> Would cherry-picking commit 7c0f812a5d65e712618af880dda4a5cc7ed79463 for the 
> 3.10 stable series make sense instead ? Otherwise,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

7c0f812a5d65e712618af880dda4a5cc7ed79463 looks good as well for 3.10 
longterm

thanks, p.
 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
> > ---
> >  drivers/media/platform/omap3isp/isp.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/media/platform/omap3isp/isp.c
> > b/drivers/media/platform/omap3isp/isp.c index 1d7dbd5..a73d9d9 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -2287,6 +2287,7 @@ detach_dev:
> >  	iommu_detach_device(isp->domain, &pdev->dev);
> >  free_domain:
> >  	iommu_domain_free(isp->domain);
> > +	isp->domain = NULL;
> >  error_isp:
> >  	isp_xclk_cleanup(isp);
> >  	omap3isp_put(isp);
> 
> 

-- 

Peter Meerwald
+43-664-2444418 (mobile)
