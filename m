Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37897 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab1IVR3h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 13:29:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v4 1/2] v4l2: Add polarity flag definitons for parallel bus FIELD signal
Date: Thu, 22 Sep 2011 19:29:32 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, g.liakhovetski@gmx.de,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
References: <1316709751-29922-1-git-send-email-s.nawrocki@samsung.com> <1316709751-29922-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1316709751-29922-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109221929.33535.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the patch.

On Thursday 22 September 2011 18:42:30 Sylwester Nawrocki wrote:
> FIELD signal is used for indicating frame field type to the frame grabber
> in interlaced scan mode, as specified in ITU-R BT.601 standard.
> In normal operation mode FIELD = 0 selects Field1 (odd) and FIELD = 1
> selects Field2 (even). When the FIELD signal is inverted it's the other
> way around.
> 
> Add corresponding flags for configuring the FIELD signal polarity,
> V4L2_MBUS_FIELD_EVEN_HIGH for the standard (non-inverted) case and
> V4L2_MBUS_FIELD_EVEN_LOW for inverted case.
> 
> Also add a comment about usage of V4L2_MBUS_[HV]SYNC* flags for
> the hardware that uses [HV]REF signals.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  include/media/v4l2-mediabus.h |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 6114007..83ae07e 100644
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -22,8 +22,12 @@
>   */
>  #define V4L2_MBUS_MASTER			(1 << 0)
>  #define V4L2_MBUS_SLAVE				(1 << 1)
> -/* Which signal polarities it supports */
> -/* Note: in BT.656 mode HSYNC and VSYNC are unused */
> +/*
> + * Signal polarity flags
> + * Note: in BT.656 mode HSYNC, FIELD, and VSYNC are unused
> + * V4L2_MBUS_[HV]SYNC* flags should be also used for specifying
> + * configuration of hardware that uses [HV]REF signals
> + */
>  #define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1 << 2)
>  #define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1 << 3)
>  #define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 4)
> @@ -32,6 +36,10 @@
>  #define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 7)
>  #define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 8)
>  #define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 9)
> +/* FIELD = 0/1 - Field1 (odd)/Field2 (even) */
> +#define V4L2_MBUS_FIELD_EVEN_HIGH		(1 << 10)
> +/* FIELD = 1/0 - Field1 (odd)/Field2 (even) */
> +#define V4L2_MBUS_FIELD_EVEN_LOW		(1 << 11)
> 
>  /* Serial flags */
>  /* How many lanes the client can use */

-- 
Regards,

Laurent Pinchart
