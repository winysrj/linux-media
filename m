Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:38813 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753856Ab3ACWzo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 17:55:44 -0500
Date: Thu, 3 Jan 2013 14:55:41 -0800
From: Tony Lindgren <tony@atomide.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH] omap3isp: Don't include <plat/cpu.h>
Message-ID: <20130103225541.GK25633@atomide.com>
References: <1357248204-9863-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357248204-9863-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [130103 13:24]:
> The plat/*.h headers are not available to drivers in multiplatform
> kernels. As the header isn't needed, just remove it.

Please consider merging this for the -rc cycle, so I can make
plat/cpu.h produce an error for omap2+ to prevent new drivers
including it.

Acked-by: Tony Lindgren <tony@atomide.com>
 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/omap3isp/isp.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 50cea08..07eea5b 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -71,8 +71,6 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-device.h>
>  
> -#include <plat/cpu.h>
> -
>  #include "isp.h"
>  #include "ispreg.h"
>  #include "ispccdc.h"
> -- 
> Regards,
> 
> Laurent Pinchart
> 
