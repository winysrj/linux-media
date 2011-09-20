Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56491 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1ITXMe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 19:12:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3 1/2] v4l2: Add the polarity flags for parallel camera bus FIELD signal
Date: Wed, 21 Sep 2011 01:12:38 +0200
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, g.liakhovetski@gmx.de,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
References: <1316450497-6723-1-git-send-email-s.nawrocki@samsung.com> <1316452075-10700-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1316452075-10700-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109210112.39469.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the patch.

On Monday 19 September 2011 19:07:55 Sylwester Nawrocki wrote:
> FIELD is an Even/Odd field selection signal, as specified in ITU-R BT.601
> standard. Add corresponding flag for configuring the FIELD signal polarity.
> Also add a comment about usage of V4L2_MBUS_[HV]SYNC* flags for the
> hardware that uses [HV]REF signals.

I like this approach better.

> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Resending with proper bit assignment.
> 
> ---
>  include/media/v4l2-mediabus.h |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 6114007..f3a61ab 100644
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
> + * V4L2_MBUS_[HV]SYNC_* flags should be also used for specifying
> + * configuration of hardware that uses [HV]REF signals
> + */
>  #define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1 << 2)
>  #define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1 << 3)
>  #define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 4)
> @@ -32,6 +36,9 @@
>  #define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 7)
>  #define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 8)
>  #define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 9)
> +/* Field selection signal for interlaced scan mode */
> +#define V4L2_MBUS_FIELD_ACTIVE_HIGH		(1 << 10)
> +#define V4L2_MBUS_FIELD_ACTIVE_LOW		(1 << 11)

What does this mean ? The FIELD signal is used to select between odd and even 
fields. Does "active high" mean that the field is odd or even when the signal 
has a high level ? The comment should make it explicit, or we could even 
rename those two constants to FIELD_ODD_HIGH/FIELD_ODD_LOW (or 
FIELD_EVEN_HIGH/FIELD_EVEN_LOW).

>  /* Serial flags */
>  /* How many lanes the client can use */

-- 
Regards,

Laurent Pinchart
