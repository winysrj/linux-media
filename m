Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34902 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2BVLVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 06:21:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 29/33] omap3isp: Configure CSI-2 phy based on platform data
Date: Wed, 22 Feb 2012 12:21:50 +0100
Message-ID: <4450280.jxRHUOfzMq@avalon>
In-Reply-To: <1329703032-31314-29-git-send-email-sakari.ailus@iki.fi>
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-29-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Monday 20 February 2012 03:57:08 Sakari Ailus wrote:
> Configure CSI-2 phy based on platform data in the ISP driver. For that, the
> new V4L2_CID_IMAGE_SOURCE_PIXEL_RATE control is used. Previously the same
> was configured from the board code.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

[snip]

> diff --git a/drivers/media/video/omap3isp/ispcsiphy.c
> b/drivers/media/video/omap3isp/ispcsiphy.c index 5be37ce..902477d 100644
> --- a/drivers/media/video/omap3isp/ispcsiphy.c
> +++ b/drivers/media/video/omap3isp/ispcsiphy.c
> @@ -28,41 +28,13 @@
>  #include <linux/device.h>
>  #include <linux/regulator/consumer.h>
> 
> +#include "../../../../arch/arm/mach-omap2/control.h"

I expect you will have to fix that somehow, but as far as I'm concerned,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
