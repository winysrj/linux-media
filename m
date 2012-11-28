Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36470 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab2K1PMh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 10:12:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: hvaibhav@ti.com, linux-media@vger.kernel.org,
	Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	Archit Taneja <archit@ti.com>
Subject: Re: [PATCH 0/2] omap_vout: remove cpu_is_* uses
Date: Wed, 28 Nov 2012 16:13:41 +0100
Message-ID: <1421983.jJNXU7RvjW@avalon>
In-Reply-To: <1352727220-22540-1-git-send-email-tomi.valkeinen@ti.com>
References: <1352727220-22540-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

On Monday 12 November 2012 15:33:38 Tomi Valkeinen wrote:
> Hi,
> 
> This patch removes use of cpu_is_* funcs from omap_vout, and uses omapdss's
> version instead. The other patch removes an unneeded plat/dma.h include.
> 
> These are based on current omapdss master branch, which has the omapdss
> version code. The omapdss version code is queued for v3.8. I'm not sure
> which is the best way to handle these patches due to the dependency to
> omapdss. The easiest option is to merge these for 3.9.
> 
> There's still the OMAP DMA use in omap_vout_vrfb.c, which is the last OMAP
> dependency in the omap_vout driver. I'm not going to touch that, as it
> doesn't look as trivial as this cpu_is_* removal, and I don't have much
> knowledge of the omap_vout driver.
> 
> Compiled, but not tested.

Tested on a Beagleboard-xM.

Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

The patches depend on unmerged OMAP DSS patches. Would you like to push this 
series through linuxtv or through your DSS tree ? The later might be easier, 
depending on when the required DSS patches will hit mainline.

> Tomi Valkeinen (2):
>   [media] omap_vout: use omapdss's version instead of cpu_is_*
>   [media] omap_vout: remove extra include
> 
>  drivers/media/platform/omap/omap_vout.c    |    4 +--
>  drivers/media/platform/omap/omap_voutlib.c |   38 ++++++++++++++++++-------
>  drivers/media/platform/omap/omap_voutlib.h |    3 +++
>  3 files changed, 32 insertions(+), 13 deletions(-)

-- 
Regards,

Laurent Pinchart

