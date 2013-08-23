Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40060 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab3HWMwq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 08:52:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] s5k6aa: off by one in s5k6aa_enum_frame_interval()
Date: Fri, 23 Aug 2013 14:54:01 +0200
Message-ID: <4319865.UMEVfJshWy@avalon>
In-Reply-To: <20130823093306.GH31293@elgon.mountain>
References: <20130823093306.GH31293@elgon.mountain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

Thank you for the patch.

On Friday 23 August 2013 12:33:06 Dan Carpenter wrote:
> The check is off by one so we could read one space past the end of the
> array.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Mauro, I have no other pending sensor patches, can you pick this one up from 
the list, or should I send you a pull request ?

> diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
> index 789c02a..629a5cd 100644
> --- a/drivers/media/i2c/s5k6aa.c
> +++ b/drivers/media/i2c/s5k6aa.c
> @@ -1003,7 +1003,7 @@ static int s5k6aa_enum_frame_interval(struct
> v4l2_subdev *sd, const struct s5k6aa_interval *fi;
>  	int ret = 0;
> 
> -	if (fie->index > ARRAY_SIZE(s5k6aa_intervals))
> +	if (fie->index >= ARRAY_SIZE(s5k6aa_intervals))
>  		return -EINVAL;
> 
>  	v4l_bound_align_image(&fie->width, S5K6AA_WIN_WIDTH_MIN,

-- 
Regards,

Laurent Pinchart

