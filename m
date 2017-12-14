Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57351 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754125AbdLNXMo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 18:12:44 -0500
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH/RFC v2 12/15] adv748x: csi2: switch to pad and stream
 aware s_stream
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
 <20171214190835.7672-13-niklas.soderlund+renesas@ragnatech.se>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <bf2f7b88-e3d0-b318-5b49-3dae9ad096ba@ideasonboard.com>
Date: Thu, 14 Dec 2017 23:12:39 +0000
MIME-Version: 1.0
In-Reply-To: <20171214190835.7672-13-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 14/12/17 19:08, Niklas Söderlund wrote:
> Switch the driver to implement the pad and stream aware s_stream
> operation. This is needed to enable to support to start and stop
> individual streams on a multiplexed pad

"This is needed to enable support for starting and stopping individual streams
on a multiplexed pad."

> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Otherwise,

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> index a43b251d0bc67a43..39f993282dd3bb5c 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -128,22 +128,26 @@ static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops = {
>   * v4l2_subdev_video_ops
>   */
>  
> -static int adv748x_csi2_s_stream(struct v4l2_subdev *sd, int enable)
> +static int adv748x_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
> +				 unsigned int stream, int enable)
>  {
>  	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> +	struct adv748x_state *state = tx->state;
>  	struct v4l2_subdev *src;
>  
> +	if (pad != ADV748X_CSI2_SOURCE || stream != 0)
> +		return -EINVAL;
> +
>  	src = adv748x_get_remote_sd(&tx->pads[ADV748X_CSI2_SINK]);
>  	if (!src)
>  		return -EPIPE;
>  
> +	adv_dbg(state, "%s: pad: %u stream: %u enable: %d\n", sd->name,
> +		pad, stream, enable);
> +
>  	return v4l2_subdev_call(src, video, s_stream, enable);
>  }
>  
> -static const struct v4l2_subdev_video_ops adv748x_csi2_video_ops = {
> -	.s_stream = adv748x_csi2_s_stream,
> -};
> -
>  /* -----------------------------------------------------------------------------
>   * v4l2_subdev_pad_ops
>   *
> @@ -256,6 +260,7 @@ static const struct v4l2_subdev_pad_ops adv748x_csi2_pad_ops = {
>  	.get_fmt = adv748x_csi2_get_format,
>  	.set_fmt = adv748x_csi2_set_format,
>  	.get_frame_desc = adv748x_csi2_get_frame_desc,
> +	.s_stream = adv748x_csi2_s_stream,
>  };
>  
>  /* -----------------------------------------------------------------------------
> @@ -263,7 +268,6 @@ static const struct v4l2_subdev_pad_ops adv748x_csi2_pad_ops = {
>   */
>  
>  static const struct v4l2_subdev_ops adv748x_csi2_ops = {
> -	.video = &adv748x_csi2_video_ops,
>  	.pad = &adv748x_csi2_pad_ops,
>  };
>  
> 
