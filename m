Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60829 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1IQKyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 06:54:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC 1/2] v4l2: Add the parallel bus HREF signal polarity flags
Date: Sat, 17 Sep 2011 12:54:47 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, g.liakhovetski@gmx.de,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
References: <1316194123-21185-1-git-send-email-s.nawrocki@samsung.com> <1316194123-21185-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1316194123-21185-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109171254.49003.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Friday 16 September 2011 19:28:42 Sylwester Nawrocki wrote:
> HREF is a signal indicating valid data during single line transmission.
> Add corresponding flags for this signal to the set of mediabus signal
> polarity flags.

So that's a data valid signal that gates the pixel data ? The OMAP3 ISP has a 
similar signal called WEN, and I've seen other chips using DVAL. Your patch 
looks good to me, except maybe for the signal name that could be made a bit 
more explicit (I'm not sure what most chips use though).

> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  include/media/v4l2-mediabus.h |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 6114007..41d8771 100644
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -26,12 +26,14 @@
>  /* Note: in BT.656 mode HSYNC and VSYNC are unused */
>  #define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1 << 2)
>  #define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1 << 3)
> -#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 4)
> -#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1 << 5)
> -#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1 << 6)
> -#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 7)
> -#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 8)
> -#define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 9)
> +#define V4L2_MBUS_HREF_ACTIVE_HIGH		(1 << 4)
> +#define V4L2_MBUS_HREF_ACTIVE_LOW		(1 << 5)
> +#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 6)
> +#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1 << 7)
> +#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1 << 8)
> +#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 9)
> +#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 10)
> +#define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 11)
> 
>  /* Serial flags */
>  /* How many lanes the client can use */

-- 
Regards,

Laurent Pinchart
