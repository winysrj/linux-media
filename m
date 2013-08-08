Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47608 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966823Ab3HHW53 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 18:57:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] V4L: s5c73m3: Add format propagation for TRY formats
Date: Fri, 09 Aug 2013 00:58:34 +0200
Message-ID: <3766107.LzC3gBYZDo@avalon>
In-Reply-To: <1374677852-2006-1-git-send-email-s.nawrocki@samsung.com>
References: <1374677852-2006-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday 24 July 2013 16:57:32 Sylwester Nawrocki wrote:
> From: Andrzej Hajda <a.hajda@samsung.com>
> 
> Resolution set on ISP pad of S5C73M3-OIF subdev should be
> propagated to source pad for TRY and ACTIVE formats.
> The patch adds missing propagation for TRY format.

I might be missing something, but where's the propagation for the ACTIVE 
format ?

> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> b/drivers/media/i2c/s5c73m3/s5c73m3-core.c index 825ea86..b76ec0e 100644
> --- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> @@ -1111,6 +1111,11 @@ static int s5c73m3_oif_set_fmt(struct v4l2_subdev
> *sd, if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
>  		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
>  		*mf = fmt->format;
> +		if (fmt->pad == OIF_ISP_PAD) {
> +			mf = v4l2_subdev_get_try_format(fh, OIF_SOURCE_PAD);
> +			mf->width = fmt->format.width;
> +			mf->height = fmt->format.height;
> +		}
>  	} else {
>  		switch (fmt->pad) {
>  		case OIF_ISP_PAD:
-- 
Regards,

Laurent Pinchart

