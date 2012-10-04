Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39644 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab2JDWZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 18:25:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Timo Kokkonen <timo.t.kokkonen@iki.fi>,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 16/16] ARM: OMAP: Make plat/omap-pm.h local to mach-omap2
Date: Fri, 05 Oct 2012 00:26:32 +0200
Message-ID: <1444123.SLhQ8KkDRS@avalon>
In-Reply-To: <20121004220510.26676.36302.stgit@muffinssi.local>
References: <20121004213950.26676.21898.stgit@muffinssi.local> <20121004220510.26676.36302.stgit@muffinssi.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony,

Thanks for the patch.

On Thursday 04 October 2012 15:05:10 Tony Lindgren wrote:
> We must move this for ARM common zImage support.
> 
> Note that neither drivers/media/rc/ir-rx51.c or
> drivers/media/platform/omap3isp/ispvideo.c need
> to include omap-pm.h, so this patch removes the
> include for those files.

drivers/media/platform/omap3isp/ispvideo.c used omap-pm.h APIs in the past, we 
forgot to remove the #include when we changed that.

For the OMAP3 ISP driver,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Tony Lindgren <tony@atomide.com>

-- 
Regards,

Laurent Pinchart

