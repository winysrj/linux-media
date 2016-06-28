Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45342
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbcF1Lcq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 07:32:46 -0400
Date: Tue, 28 Jun 2016 08:32:38 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk
Subject: Re: [PATCH v4 3/8] media: rcar_vin: Use correct pad number in
 try_fmt
Message-ID: <20160628083238.5fe7e32b@recife.lan>
In-Reply-To: <1462975376-491-4-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1462975376-491-1-git-send-email-ulrich.hecht+renesas@gmail.com>
	<1462975376-491-4-git-send-email-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 11 May 2016 16:02:51 +0200
Ulrich Hecht <ulrich.hecht+renesas@gmail.com> escreveu:

> Fix rcar_vin_try_fmt's use of an inappropriate pad number when calling
> the subdev set_fmt function - for the ADV7612, IDs should be non-zero.
> 
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> [uli: adapted to rcar-vin rewrite]

Please use [email@domain: some revierwer note], as stated at Documentation/SubmittingPatches.

> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>

This patch breaks compilation:

drivers/media/platform/rcar-vin/rcar-v4l2.c: In function '__rvin_try_format_source':
drivers/media/platform/rcar-vin/rcar-v4l2.c:115:18: error: 'struct rvin_dev' has no member named 'src_pad_idx'
  format.pad = vin->src_pad_idx;
                  ^~



> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 0bc4487..42dbd35 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -98,7 +98,7 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
>  					struct rvin_source_fmt *source)
>  {
>  	struct v4l2_subdev *sd;
> -	struct v4l2_subdev_pad_config pad_cfg;
> +	struct v4l2_subdev_pad_config *pad_cfg;
>  	struct v4l2_subdev_format format = {
>  		.which = which,
>  	};
> @@ -108,10 +108,16 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
>  
>  	v4l2_fill_mbus_format(&format.format, pix, vin->source.code);
>  
> +	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
> +	if (pad_cfg == NULL)
> +		return -ENOMEM;
> +
> +	format.pad = vin->src_pad_idx;
> +
>  	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, pad, set_fmt,
> -					 &pad_cfg, &format);
> +					 pad_cfg, &format);
>  	if (ret < 0)
> -		return ret;
> +		goto cleanup;
>  
>  	v4l2_fill_pix_format(pix, &format.format);
>  
> @@ -121,6 +127,8 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
>  	vin_dbg(vin, "Source resolution: %ux%u\n", source->width,
>  		source->height);
>  
> +cleanup:
> +	v4l2_subdev_free_pad_config(pad_cfg);
>  	return 0;
>  }
>  



Thanks,
Mauro
