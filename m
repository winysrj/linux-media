Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:37866 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751575AbeDYJDI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 05:03:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 5/7] omapfb: omapfb_dss.h: add stubs to build with COMPILE_TEST && DRM_OMAP
Date: Wed, 25 Apr 2018 12:03:22 +0300
Message-ID: <1818588.4EAHIaV2gL@avalon>
In-Reply-To: <70b5e60f-346e-4b34-8235-ce62de720a99@ti.com>
References: <cover.1524245455.git.mchehab@s-opensource.com> <20180423170955.13421017@vento.lan> <70b5e60f-346e-4b34-8235-ce62de720a99@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

On Wednesday, 25 April 2018 09:24:14 EEST Tomi Valkeinen wrote:
> On 23/04/18 23:09, Mauro Carvalho Chehab wrote:
> >> I don't think it's worth it renaming the common symbols. They will change
> >> over time as omapdrm is under heavy rework, and it's painful enough
> >> without having to handle cross-tree changes.
> > 
> > It could just rename the namespace-conflicting FB_OMAP2 functions,
> > keeping the DRM ones as-is.
> 
> Yes, I'm fine with renaming omapfb functions if that helps. But still,
> if omapdrm is enabled in the kernel as module or built-in, omapfb will
> not work. So even if we get them to compile and link, it'll break at
> runtime one way or another.
> 
> >> Let's just live with the fact that both drivers
> >> can't be compiled at the same time, given that omapfb is deprecated.
> > 
> > IMO, a driver that it is deprecated, being in a state where it
> > conflicts with a non-deprecated driver that is under heavy rework
> > is a very good candidate to go to drivers/staging or even to /dev/null.
> 
> The problem is that it supports old devices which are not supported by
> omapdrm. But both omapfb and omapdrm support many of the same devices.

Could we trim down omapfb to remove support for the devices supported by 
omapdrm ?

-- 
Regards,

Laurent Pinchart
