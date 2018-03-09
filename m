Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:47959 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751173AbeCIPlV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:41:21 -0500
Subject: Re: [PATCH v12 23/33] rcar-vin: force default colorspace for media
 centric mode
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
 <20180307220511.9826-24-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <421d4a38-32d2-25f1-918c-fd9adbf6d633@xs4all.nl>
Date: Fri, 9 Mar 2018 16:41:19 +0100
MIME-Version: 1.0
In-Reply-To: <20180307220511.9826-24-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/18 23:05, Niklas Söderlund wrote:
> The V4L2 specification clearly documents the colorspace fields as being
> set by drivers for capture devices. Using the values supplied by
> userspace thus wouldn't comply with the API. Until the API is updated to
> allow for userspace to set these Hans wants the fields to be set by the
> driver to fixed values.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 2280535ca981993f..ea0759a645e49490 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -664,12 +664,29 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
>   * V4L2 Media Controller
>   */
>  
> +static int rvin_mc_try_format(struct rvin_dev *vin, struct v4l2_pix_format *pix)
> +{
> +	/*
> +	 * The V4L2 specification clearly documents the colorspace fields
> +	 * as being set by drivers for capture devices. Using the values
> +	 * supplied by userspace thus wouldn't comply with the API. Until
> +	 * the API is updated force fixed vaules.
> +	 */
> +	pix->colorspace = RVIN_DEFAULT_COLORSPACE;
> +	pix->xfer_func = V4L2_MAP_XFER_FUNC_DEFAULT(pix->colorspace);
> +	pix->ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(pix->colorspace);
> +	pix->quantization = V4L2_MAP_QUANTIZATION_DEFAULT(true, pix->colorspace,
> +							  pix->ycbcr_enc);
> +
> +	return rvin_format_align(vin, pix);
> +}
> +
>  static int rvin_mc_try_fmt_vid_cap(struct file *file, void *priv,
>  				   struct v4l2_format *f)
>  {
>  	struct rvin_dev *vin = video_drvdata(file);
>  
> -	return rvin_format_align(vin, &f->fmt.pix);
> +	return rvin_mc_try_format(vin, &f->fmt.pix);
>  }
>  
>  static int rvin_mc_s_fmt_vid_cap(struct file *file, void *priv,
> @@ -681,7 +698,7 @@ static int rvin_mc_s_fmt_vid_cap(struct file *file, void *priv,
>  	if (vb2_is_busy(&vin->queue))
>  		return -EBUSY;
>  
> -	ret = rvin_format_align(vin, &f->fmt.pix);
> +	ret = rvin_mc_try_format(vin, &f->fmt.pix);
>  	if (ret)
>  		return ret;
>  
> 
