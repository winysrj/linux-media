Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:26838
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751337AbdILORL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 10:17:11 -0400
Date: Tue, 12 Sep 2017 16:16:37 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Srishti Sharma <srishtishar@gmail.com>
cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Subject: Re: [Outreachy kernel] [PATCH] Staging: media: atomisp: Merge
 assignment with return
In-Reply-To: <1505225549-4432-1-git-send-email-srishtishar@gmail.com>
Message-ID: <alpine.DEB.2.20.1709121616240.3149@hadrien>
References: <1505225549-4432-1-git-send-email-srishtishar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 12 Sep 2017, Srishti Sharma wrote:

> Merge the assignment and the return statements to return the value
> directly. Done using the following semantic patch by coccinelle.
>
> @@
> local idexpression ret;
> expression e;
> @@
>
> -ret =
> +return
>      e;
> -return ret;
>
> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

> ---
>  drivers/staging/media/atomisp/i2c/ov5693/ov5693.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
> index 1236425..2195011 100644
> --- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
> +++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
> @@ -945,12 +945,8 @@ static int ad5823_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
>
>  int ad5823_t_focus_abs(struct v4l2_subdev *sd, s32 value)
>  {
> -	int ret;
> -
>  	value = min(value, AD5823_MAX_FOCUS_POS);
> -	ret = ad5823_t_focus_vcm(sd, value);
> -
> -	return ret;
> +	return ad5823_t_focus_vcm(sd, value);
>  }
>
>  static int ov5693_t_focus_abs(struct v4l2_subdev *sd, s32 value)
> @@ -1332,7 +1328,6 @@ static int power_ctrl(struct v4l2_subdev *sd, bool flag)
>
>  static int gpio_ctrl(struct v4l2_subdev *sd, bool flag)
>  {
> -	int ret;
>  	struct ov5693_device *dev = to_ov5693_sensor(sd);
>
>  	if (!dev || !dev->platform_data)
> @@ -1342,9 +1337,7 @@ static int gpio_ctrl(struct v4l2_subdev *sd, bool flag)
>  	if (dev->platform_data->gpio_ctrl)
>  		return dev->platform_data->gpio_ctrl(sd, flag);
>
> -	ret = dev->platform_data->gpio0_ctrl(sd, flag);
> -
> -	return ret;
> +	return dev->platform_data->gpio0_ctrl(sd, flag);
>  }
>
>  static int __power_up(struct v4l2_subdev *sd)
> --
> 2.7.4
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1505225549-4432-1-git-send-email-srishtishar%40gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
