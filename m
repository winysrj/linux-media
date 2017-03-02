Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:32996 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754477AbdCBJH4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 04:07:56 -0500
Subject: Re: [PATCH] v4l: vsp1: Disable HSV formats on Gen3 hardware
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <20170228230813.21848-1-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
From: Kieran Bingham <kieranbingham@gmail.com>
Message-ID: <9f66d574-6aa8-d58b-2dc1-1c3f2dbfafbb@gmail.com>
Date: Thu, 2 Mar 2017 09:06:10 +0000
MIME-Version: 1.0
In-Reply-To: <20170228230813.21848-1-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

LGTM! :-)

On 28/02/17 23:08, Laurent Pinchart wrote:
> While all VSP instances can process HSV internally, on Gen3 hardware
> reading or writing HSV24 or HSV32 from/to memory causes the device to
> hang. Disable those pixel formats on Gen3 hardware.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_pipe.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
> index 3f1acf68dc6e..35364f594e19 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.c
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.c
> @@ -157,9 +157,15 @@ const struct vsp1_format_info *vsp1_get_format_info(struct vsp1_device *vsp1,
>  {
>  	unsigned int i;
>  
> -	/* Special case, the VYUY format is supported on Gen2 only. */
> -	if (vsp1->info->gen != 2 && fourcc == V4L2_PIX_FMT_VYUY)
> -		return NULL;
> +	/* Special case, the VYUY and HSV formats are supported on Gen2 only. */
> +	if (vsp1->info->gen != 2) {
> +		switch (fourcc) {
> +		case V4L2_PIX_FMT_VYUY:
> +		case V4L2_PIX_FMT_HSV24:
> +		case V4L2_PIX_FMT_HSV32:
> +			return NULL;
> +		}
> +	}
>  
>  	for (i = 0; i < ARRAY_SIZE(vsp1_video_formats); ++i) {
>  		const struct vsp1_format_info *info = &vsp1_video_formats[i];
> 
