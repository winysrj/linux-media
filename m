Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49498 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752989AbeDKQ06 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 12:26:58 -0400
Date: Wed, 11 Apr 2018 19:26:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Suman Anna <s-anna@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pavel Machek <pavel@ucw.cz>, Tony Lindgren <tony@atomide.com>,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] media: omap3isp: fix unbalanced dma_iommu_mapping
Message-ID: <20180411162655.gigmuzna624xcxx2@valkosipuli.retiisi.org.uk>
References: <20180314154136.16468-1-s-anna@ti.com>
 <5767280.aLITpzbm0N@avalon>
 <e0151287-f294-3540-9b12-a96e05db61c0@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0151287-f294-3540-9b12-a96e05db61c0@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 26, 2018 at 11:40:58AM -0500, Suman Anna wrote:
> Hi Mauro,
> 
> On 03/21/2018 05:26 AM, Laurent Pinchart wrote:
> > Hi Suman,
> > 
> > Thank you for the patch.
> > 
> > On Wednesday, 14 March 2018 17:41:36 EET Suman Anna wrote:
> >> The OMAP3 ISP driver manages its MMU mappings through the IOMMU-aware
> >> ARM DMA backend. The current code creates a dma_iommu_mapping and
> >> attaches this to the ISP device, but never detaches the mapping in
> >> either the probe failure paths or the driver remove path resulting
> >> in an unbalanced mapping refcount and a memory leak. Fix this properly.
> >>
> >> Reported-by: Pavel Machek <pavel@ucw.cz>
> >> Signed-off-by: Suman Anna <s-anna@ti.com>
> >> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I don't see this patch in -next yet, can you pick up this patch at your
> earliest?

Here:

<URL:https://patchwork.linuxtv.org/patch/48599/>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
