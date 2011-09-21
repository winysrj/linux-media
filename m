Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab1IUPXA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 11:23:00 -0400
Message-ID: <4E7A014F.5040602@redhat.com>
Date: Wed, 21 Sep 2011 12:22:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, Kyungmin Park <kyungin.park@samsung.com>
Subject: Re: [PATCH 1/3] sr030pc30: Remove empty s_stream op
References: <1295487842-23410-1-git-send-email-s.nawrocki@samsung.com> <1295487842-23410-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1295487842-23410-2-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-01-2011 23:44, Sylwester Nawrocki escreveu:
> s_stream does nothing in current form so remove it.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungin.park@samsung.com>
> ---
>  drivers/media/video/sr030pc30.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc30.c
> index c901721..e1eced1 100644
> --- a/drivers/media/video/sr030pc30.c
> +++ b/drivers/media/video/sr030pc30.c
> @@ -714,11 +714,6 @@ static int sr030pc30_base_config(struct v4l2_subdev *sd)
>  	return ret;
>  }
>  
> -static int sr030pc30_s_stream(struct v4l2_subdev *sd, int enable)
> -{
> -	return 0;
> -}
> -
>  static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> @@ -761,7 +756,6 @@ static const struct v4l2_subdev_core_ops sr030pc30_core_ops = {
>  };
>  
>  static const struct v4l2_subdev_video_ops sr030pc30_video_ops = {
> -	.s_stream	= sr030pc30_s_stream,
>  	.g_mbus_fmt	= sr030pc30_g_fmt,
>  	.s_mbus_fmt	= sr030pc30_s_fmt,
>  	.try_mbus_fmt	= sr030pc30_try_fmt,

Hmm...
this patch[1] were never merged. It seems a cleanup, though.

Care to review it?

Thanks!
Mauro

[1] http://patchwork.linuxtv.org/patch/5631/

