Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47693 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbeFANdg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 09:33:36 -0400
Message-ID: <1527860010.5913.8.camel@pengutronix.de>
Subject: Re: [PATCH v2 04/10] media: imx: interweave only for sequential
 input/interlaced output fields
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Fri, 01 Jun 2018 15:33:30 +0200
In-Reply-To: <1527813049-3231-5-git-send-email-steve_longerbeam@mentor.com>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
         <1527813049-3231-5-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Thu, 2018-05-31 at 17:30 -0700, Steve Longerbeam wrote:
> IDMAC interlaced scan, a.k.a. interweave, should be enabled at the
> IDMAC output pads only if the input field type is 'seq-bt' or 'seq-tb',
> and the IDMAC output pad field type is 'interlaced*'. Move this
> determination to a new macro idmac_interweave().
> 
> V4L2_FIELD_HAS_BOTH() macro should not be used on the input to determine
> enabling interlaced/interweave scan. That macro includes the 'interlaced'
> field types, and in those cases the data is already interweaved with
> top/bottom field lines.
> 
> The CSI will capture whole frames when the source specifies alternate
> field mode. So the CSI also enables interweave at the IDMAC output pad
> for alternate input field type.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/media/imx/imx-ic-prpencvf.c | 22 ++++++++++++++++++----
>  drivers/staging/media/imx/imx-media-csi.c   | 22 ++++++++++++++++++----
>  2 files changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
> index ae453fd..894db21 100644
> --- a/drivers/staging/media/imx/imx-ic-prpencvf.c
> +++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
> @@ -132,6 +132,18 @@ static inline struct prp_priv *sd_to_priv(struct v4l2_subdev *sd)
>  	return ic_priv->task_priv;
>  }
>  
> +/*
> + * If the field type at IDMAC output pad is interlaced, and
> + * the input is sequential fields, the IDMAC output channel
> + * can accommodate by interweaving.
> + */
> +static inline bool idmac_interweave(enum v4l2_field outfield,
> +				    enum v4l2_field infield)
> +{
> +	return V4L2_FIELD_IS_INTERLACED(outfield) &&
> +		V4L2_FIELD_IS_SEQUENTIAL(infield);
> +}

This is ok in this patch, but we can't use this check in the following
TRY_FMT patch as there is no way to interweave
SEQ_TB -> INTERLACED_BT (because in SEQ_TB the B field is newer than T,
but in INTERLACED_BT it has to be older) or SEQ_BT -> INTERLACED_TB (the
other way around).

> +
>  static void prp_put_ipu_resources(struct prp_priv *priv)
>  {
>  	if (priv->ic)
> @@ -353,6 +365,7 @@ static int prp_setup_channel(struct prp_priv *priv,
>  	struct v4l2_mbus_framefmt *infmt;
>  	unsigned int burst_size;
>  	struct ipu_image image;
> +	bool interweave;
>  	int ret;
>  
>  	infmt = &priv->format_mbus[PRPENCVF_SINK_PAD];
> @@ -365,6 +378,9 @@ static int prp_setup_channel(struct prp_priv *priv,
>  	image.rect.width = image.pix.width;
>  	image.rect.height = image.pix.height;
>  
> +	interweave = (idmac_interweave(image.pix.field, infmt->field) &&
> +		      channel == priv->out_ch);
> +
>  	if (rot_swap_width_height) {
>  		swap(image.pix.width, image.pix.height);
>  		swap(image.rect.width, image.rect.height);
> @@ -405,9 +421,7 @@ static int prp_setup_channel(struct prp_priv *priv,
>  	if (rot_mode)
>  		ipu_cpmem_set_rotation(channel, rot_mode);
>  
> -	if (image.pix.field == V4L2_FIELD_NONE &&
> -	    V4L2_FIELD_HAS_BOTH(infmt->field) &&
> -	    channel == priv->out_ch)
> +	if (interweave)
>  		ipu_cpmem_interlaced_scan(channel, image.pix.bytesperline);

This only works for SEQ_TB -> INTERLACED_TB interweave.
For SEQ_BT -> INTERLACED_BT we have to start at +1 line offset and set
ipu_cpmem_interlaced_scan to -image.pix.bytesperline.

regards
Philipp
