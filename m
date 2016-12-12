Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58588 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932115AbcLLIu4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 03:50:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: media: i2c: mt9t001: constify v4l2_subdev_* structures
Date: Mon, 12 Dec 2016 10:51:26 +0200
Message-ID: <2013691.WNnvVohL0L@avalon>
In-Reply-To: <1481445326-19864-1-git-send-email-bhumirks@gmail.com>
References: <1481445326-19864-1-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bhumika,

Thank you for the patch

On Sunday 11 Dec 2016 14:05:26 Bhumika Goyal wrote:
> v4l2_subdev_{core/pad/video}_ops structures are stored in the
> fields of the v4l2_subdev_ops structure which are of
> type const. Also, v4l2_subdev_ops structure is passed to a function
> having its argument of type const. As these structures are never
> modified, so declare them as const.
> Done using Coccinelle: (One of the scripts used)
> 
> @r1 disable optional_qualifier @
> identifier i;
> position p;
> @@
> static struct v4l2_subdev_ops i@p = {...};
> 
> @ok1@
> identifier r1.i;
> position p;
> expression e1,e2;
> @@
> v4l2_i2c_subdev_init(e1,e2,&i@p)
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
> struct v4l2_subdev_ops i;
> 
> File size before:
>    text	   data	    bss	    dec	    hex	filename
>    6119	    736	     16	   6871	   1ad7	drivers/media/i2c/mt9t001.o
> 
> File size after:
>    text	   data	    bss	    dec	    hex	filename
>    6631	    232	     16	   6879	   1adf	drivers/media/i2c/mt9t001.o
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/mt9t001.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
> index 842017f..9d981d9 100644
> --- a/drivers/media/i2c/mt9t001.c
> +++ b/drivers/media/i2c/mt9t001.c
> @@ -822,15 +822,15 @@ static int mt9t001_close(struct v4l2_subdev *subdev,
> struct v4l2_subdev_fh *fh) return mt9t001_set_power(subdev, 0);
>  }
> 
> -static struct v4l2_subdev_core_ops mt9t001_subdev_core_ops = {
> +static const struct v4l2_subdev_core_ops mt9t001_subdev_core_ops = {
>  	.s_power = mt9t001_set_power,
>  };
> 
> -static struct v4l2_subdev_video_ops mt9t001_subdev_video_ops = {
> +static const struct v4l2_subdev_video_ops mt9t001_subdev_video_ops = {
>  	.s_stream = mt9t001_s_stream,
>  };
> 
> -static struct v4l2_subdev_pad_ops mt9t001_subdev_pad_ops = {
> +static const struct v4l2_subdev_pad_ops mt9t001_subdev_pad_ops = {
>  	.enum_mbus_code = mt9t001_enum_mbus_code,
>  	.enum_frame_size = mt9t001_enum_frame_size,
>  	.get_fmt = mt9t001_get_format,
> @@ -839,7 +839,7 @@ static int mt9t001_close(struct v4l2_subdev *subdev,
> struct v4l2_subdev_fh *fh) .set_selection = mt9t001_set_selection,
>  };
> 
> -static struct v4l2_subdev_ops mt9t001_subdev_ops = {
> +static const struct v4l2_subdev_ops mt9t001_subdev_ops = {
>  	.core = &mt9t001_subdev_core_ops,
>  	.video = &mt9t001_subdev_video_ops,
>  	.pad = &mt9t001_subdev_pad_ops,

-- 
Regards,

Laurent Pinchart

