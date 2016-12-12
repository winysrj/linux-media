Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58574 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751375AbcLLIuT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 03:50:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, hyun.kwon@xilinx.com, mchehab@kernel.org,
        michal.simek@xilinx.com, soren.brinkmann@xilinx.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: platform: xilinx: xilinx-tpg: constify v4l2_subdev_* structures
Date: Mon, 12 Dec 2016 10:50:49 +0200
Message-ID: <2425766.trygpAiYzB@avalon>
In-Reply-To: <1481449952-26119-1-git-send-email-bhumirks@gmail.com>
References: <1481449952-26119-1-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bhumika,

Thank you for the patch.

On Sunday 11 Dec 2016 15:22:32 Bhumika Goyal wrote:
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
> File size before:
>    text	   data	    bss	    dec	    hex	filename
>    6170	   2752	    144	   9066	   236a media/platform/xilinx/xilinx-
tpg.o
> 
> File size after:
>    text	   data	    bss	    dec	    hex	filename
>    6666	   2384	      8	   9058	   2362 media/platform/xilinx/xilinx-
tpg.o
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/xilinx/xilinx-tpg.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-tpg.c
> b/drivers/media/platform/xilinx/xilinx-tpg.c index 2ec1f6c..9c49d1d 100644
> --- a/drivers/media/platform/xilinx/xilinx-tpg.c
> +++ b/drivers/media/platform/xilinx/xilinx-tpg.c
> @@ -460,21 +460,21 @@ static int xtpg_s_ctrl(struct v4l2_ctrl *ctrl)
>  	.s_ctrl	= xtpg_s_ctrl,
>  };
> 
> -static struct v4l2_subdev_core_ops xtpg_core_ops = {
> +static const struct v4l2_subdev_core_ops xtpg_core_ops = {
>  };
> 
> -static struct v4l2_subdev_video_ops xtpg_video_ops = {
> +static const struct v4l2_subdev_video_ops xtpg_video_ops = {
>  	.s_stream = xtpg_s_stream,
>  };
> 
> -static struct v4l2_subdev_pad_ops xtpg_pad_ops = {
> +static const struct v4l2_subdev_pad_ops xtpg_pad_ops = {
>  	.enum_mbus_code		= xvip_enum_mbus_code,
>  	.enum_frame_size	= xtpg_enum_frame_size,
>  	.get_fmt		= xtpg_get_format,
>  	.set_fmt		= xtpg_set_format,
>  };
> 
> -static struct v4l2_subdev_ops xtpg_ops = {
> +static const struct v4l2_subdev_ops xtpg_ops = {
>  	.core   = &xtpg_core_ops,
>  	.video  = &xtpg_video_ops,
>  	.pad    = &xtpg_pad_ops,

-- 
Regards,

Laurent Pinchart

