Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50575 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbdHHWHR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 18:07:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] [media] v4l: mt9t001: constify video_subdev structures
Date: Wed, 09 Aug 2017 01:07:30 +0300
Message-ID: <5944526.BaCzTLmd28@avalon>
In-Reply-To: <1502189912-28794-2-git-send-email-Julia.Lawall@lip6.fr>
References: <1502189912-28794-1-git-send-email-Julia.Lawall@lip6.fr> <1502189912-28794-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julia,

Thank you for the patch.

On Tuesday 08 Aug 2017 12:58:27 Julia Lawall wrote:
> The v4l2_subdev_ops structure is only passed as the third argument of
> v4l2_i2c_subdev_init, which is const, so the v4l2_subdev_ops structure
> can be const as well.  The other structures are only stored in the
> v4l2_subdev_ops structure, all the fields of which are const, so these
> structures can also be const.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/mt9t001.c |    8 ++++----
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
