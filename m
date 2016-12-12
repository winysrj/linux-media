Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58561 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751995AbcLLInd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 03:43:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: media: i2c: constify v4l2_subdev_* structures
Date: Mon, 12 Dec 2016 10:44:02 +0200
Message-ID: <5415962.NnTQRlbICJ@avalon>
In-Reply-To: <1481528732-15565-1-git-send-email-bhumirks@gmail.com>
References: <1481528732-15565-1-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bhumika,

Thank you for the patch.

On Monday 12 Dec 2016 13:15:32 Bhumika Goyal wrote:
> v4l2_subdev_{core/pad/video}_ops structures are stored in the
> fields of the v4l2_subdev_ops structure which are of type const.
> Also, v4l2_subdev_ops structure is passed to a function
> having its argument of type const. As these structures are never
> modified, so declare them as const.
> Done using Coccinelle: (One of the scripts used)
> 
> @r1 disable optional_qualifier @
> identifier i;
> position p;
> @@
> static struct v4l2_subdev_video_ops i@p = {...};
> 
> @ok1@
> identifier r1.i;
> position p;
> struct v4l2_subdev_ops obj;
> @@
> obj.video=&i@p;
> 
> @bad@
> position p!={r1.p,ok1.p};
> identifier r1.i;
> @@
> i@p
> 
> @depends on !bad disable optional_qualifier@
> identifier r1.i;
> @@
> +const
> struct v4l2_subdev_video_ops i;
> 
> File sizes before:
>   text	   data	    bss	    dec	    hex	filename
>    7810	    736	     16	   8562	   2172	drivers/media/i2c/mt9p031.o
>    9652	    736	     24	  10412	   28ac	drivers/media/i2c/mt9v032.o
>    4613	    552	     20	   5185	   1441	
drivers/media/i2c/noon010pc30.o
>    2615	    552	      8	   3175	    c67	drivers/media/i2c/s5k6a3.o
> 
> File sizes after:
>   text	   data	    bss	    dec	    hex	filename
>    8322	    232	     16	   8570	   217a	drivers/media/i2c/mt9p031.o
>   10164	    232	     24	  10420	   28b4	drivers/media/i2c/mt9v032.o
>    4933	    232	     20	   5185	   1441	
drivers/media/i2c/noon010pc30.o
>    2935	    232	      8	   3175	    c67	drivers/media/i2c/s5k6a3.o
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/mt9p031.c     | 8 ++++----
>  drivers/media/i2c/mt9v032.c     | 8 ++++----
>  drivers/media/i2c/noon010pc30.c | 4 ++--
>  drivers/media/i2c/s5k6a3.c      | 6 +++---
>  4 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index 237737f..91d822f 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -972,15 +972,15 @@ static int mt9p031_close(struct v4l2_subdev *subdev,
> struct v4l2_subdev_fh *fh) return mt9p031_set_power(subdev, 0);
>  }
> 
> -static struct v4l2_subdev_core_ops mt9p031_subdev_core_ops = {
> +static const struct v4l2_subdev_core_ops mt9p031_subdev_core_ops = {
>  	.s_power        = mt9p031_set_power,
>  };
> 
> -static struct v4l2_subdev_video_ops mt9p031_subdev_video_ops = {
> +static const struct v4l2_subdev_video_ops mt9p031_subdev_video_ops = {
>  	.s_stream       = mt9p031_s_stream,
>  };
> 
> -static struct v4l2_subdev_pad_ops mt9p031_subdev_pad_ops = {
> +static const struct v4l2_subdev_pad_ops mt9p031_subdev_pad_ops = {
>  	.enum_mbus_code = mt9p031_enum_mbus_code,
>  	.enum_frame_size = mt9p031_enum_frame_size,
>  	.get_fmt = mt9p031_get_format,
> @@ -989,7 +989,7 @@ static int mt9p031_close(struct v4l2_subdev *subdev,
> struct v4l2_subdev_fh *fh) .set_selection = mt9p031_set_selection,
>  };
> 
> -static struct v4l2_subdev_ops mt9p031_subdev_ops = {
> +static const struct v4l2_subdev_ops mt9p031_subdev_ops = {
>  	.core   = &mt9p031_subdev_core_ops,
>  	.video  = &mt9p031_subdev_video_ops,
>  	.pad    = &mt9p031_subdev_pad_ops,
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 58eb62f..88b7890 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -936,15 +936,15 @@ static int mt9v032_close(struct v4l2_subdev *subdev,
> struct v4l2_subdev_fh *fh) return mt9v032_set_power(subdev, 0);
>  }
> 
> -static struct v4l2_subdev_core_ops mt9v032_subdev_core_ops = {
> +static const struct v4l2_subdev_core_ops mt9v032_subdev_core_ops = {
>  	.s_power	= mt9v032_set_power,
>  };
> 
> -static struct v4l2_subdev_video_ops mt9v032_subdev_video_ops = {
> +static const struct v4l2_subdev_video_ops mt9v032_subdev_video_ops = {
>  	.s_stream	= mt9v032_s_stream,
>  };
> 
> -static struct v4l2_subdev_pad_ops mt9v032_subdev_pad_ops = {
> +static const struct v4l2_subdev_pad_ops mt9v032_subdev_pad_ops = {
>  	.enum_mbus_code = mt9v032_enum_mbus_code,
>  	.enum_frame_size = mt9v032_enum_frame_size,
>  	.get_fmt = mt9v032_get_format,
> @@ -953,7 +953,7 @@ static int mt9v032_close(struct v4l2_subdev *subdev,
> struct v4l2_subdev_fh *fh) .set_selection = mt9v032_set_selection,
>  };
> 
> -static struct v4l2_subdev_ops mt9v032_subdev_ops = {
> +static const struct v4l2_subdev_ops mt9v032_subdev_ops = {
>  	.core	= &mt9v032_subdev_core_ops,
>  	.video	= &mt9v032_subdev_video_ops,
>  	.pad	= &mt9v032_subdev_pad_ops,
> diff --git a/drivers/media/i2c/noon010pc30.c
> b/drivers/media/i2c/noon010pc30.c index 30cb90b..88c498a 100644
> --- a/drivers/media/i2c/noon010pc30.c
> +++ b/drivers/media/i2c/noon010pc30.c
> @@ -664,13 +664,13 @@ static int noon010_open(struct v4l2_subdev *sd, struct
> v4l2_subdev_fh *fh) .log_status	= noon010_log_status,
>  };
> 
> -static struct v4l2_subdev_pad_ops noon010_pad_ops = {
> +static const struct v4l2_subdev_pad_ops noon010_pad_ops = {
>  	.enum_mbus_code	= noon010_enum_mbus_code,
>  	.get_fmt	= noon010_get_fmt,
>  	.set_fmt	= noon010_set_fmt,
>  };
> 
> -static struct v4l2_subdev_video_ops noon010_video_ops = {
> +static const struct v4l2_subdev_video_ops noon010_video_ops = {
>  	.s_stream	= noon010_s_stream,
>  };
> 
> diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
> index 7699640..67dcca7 100644
> --- a/drivers/media/i2c/s5k6a3.c
> +++ b/drivers/media/i2c/s5k6a3.c
> @@ -165,7 +165,7 @@ static int s5k6a3_get_fmt(struct v4l2_subdev *sd,
>  	return 0;
>  }
> 
> -static struct v4l2_subdev_pad_ops s5k6a3_pad_ops = {
> +static const struct v4l2_subdev_pad_ops s5k6a3_pad_ops = {
>  	.enum_mbus_code	= s5k6a3_enum_mbus_code,
>  	.get_fmt	= s5k6a3_get_fmt,
>  	.set_fmt	= s5k6a3_set_fmt,
> @@ -266,11 +266,11 @@ static int s5k6a3_s_power(struct v4l2_subdev *sd, int
> on) return ret;
>  }
> 
> -static struct v4l2_subdev_core_ops s5k6a3_core_ops = {
> +static const struct v4l2_subdev_core_ops s5k6a3_core_ops = {
>  	.s_power = s5k6a3_s_power,
>  };
> 
> -static struct v4l2_subdev_ops s5k6a3_subdev_ops = {
> +static const struct v4l2_subdev_ops s5k6a3_subdev_ops = {
>  	.core = &s5k6a3_core_ops,
>  	.pad = &s5k6a3_pad_ops,
>  };

-- 
Regards,

Laurent Pinchart

