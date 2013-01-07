Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54132 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752733Ab3AGIGI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jan 2013 03:06:08 -0500
Date: Mon, 7 Jan 2013 10:06:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH FOR v3.8] omap3isp: Don't include deleted OMAP plat/
 header files
Message-ID: <20130107080603.GF13641@valkosipuli.retiisi.org.uk>
References: <1356956793-7984-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356956793-7984-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Dec 31, 2012 at 01:26:33PM +0100, Laurent Pinchart wrote:
> The plat/iommu.h, plat/iovmm.h and plat/omap-pm.h have been deleted.
> Don't include them.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I think I first confused this with the other patch with a similar subject...

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

> ---
>  drivers/media/platform/omap3isp/ispvideo.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
> index e0d73a6..8dac175 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -35,9 +35,6 @@
>  #include <linux/vmalloc.h>
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-ioctl.h>
> -#include <plat/iommu.h>
> -#include <plat/iovmm.h>
> -#include <plat/omap-pm.h>
>  
>  #include "ispvideo.h"
>  #include "isp.h"

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
