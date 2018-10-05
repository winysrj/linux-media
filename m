Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58795 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbeJERlz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 13:41:55 -0400
Message-ID: <1538736221.3545.17.camel@pengutronix.de>
Subject: Re: [PATCH v4 10/11] media: imx: Allow interweave with top/bottom
 lines swapped
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Fri, 05 Oct 2018 12:43:41 +0200
In-Reply-To: <20181004185401.15751-11-slongerbeam@gmail.com>
References: <20181004185401.15751-1-slongerbeam@gmail.com>
         <20181004185401.15751-11-slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Thu, 2018-10-04 at 11:54 -0700, Steve Longerbeam wrote:
> Allow sequential->interlaced interweaving but with top/bottom
> lines swapped to the output buffer.
> 
> This can be accomplished by adding one line length to IDMAC output
> channel address, with a negative line length for the interlace offset.
> 
> This is to allow the seq-bt -> interlaced-bt transformation, where
> bottom lines are still dominant (older in time) but with top lines
> first in the interweaved output buffer.
> 
> With this support, the CSI can now allow seq-bt at its source pads,
> e.g. the following transformations are allowed in CSI from sink to
> source:
> 
> seq-tb -> seq-bt
> seq-bt -> seq-bt
> alternate -> seq-bt
> 
> Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
>  drivers/staging/media/imx/imx-ic-prpencvf.c | 17 +++++++-
>  drivers/staging/media/imx/imx-media-csi.c   | 46 +++++++++++++++++----
>  2 files changed, 53 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
> index cf76b0432371..1499b0c62d74 100644
> --- a/drivers/staging/media/imx/imx-ic-prpencvf.c
> +++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
> @@ -106,6 +106,8 @@ struct prp_priv {
>  	u32 frame_sequence; /* frame sequence counter */
>  	bool last_eof;  /* waiting for last EOF at stream off */
>  	bool nfb4eof;    /* NFB4EOF encountered during streaming */
> +	u32 interweave_offset; /* interweave line offset to swap
> +				  top/bottom lines */

We have to store this instead of using vdev->fmt.fmt.bytesperline
because this potentially is the pre-rotation stride instead?

>  	struct completion last_eof_comp;
>  };
>  
> @@ -235,6 +237,9 @@ static void prp_vb2_buf_done(struct prp_priv *priv, struct ipuv3_channel *ch)
>  	if (ipu_idmac_buffer_is_ready(ch, priv->ipu_buf_num))
>  		ipu_idmac_clear_buffer(ch, priv->ipu_buf_num);
>  
> +	if (ch == priv->out_ch)
> +		phys += priv->interweave_offset;
> +
>  	ipu_cpmem_set_buffer(ch, priv->ipu_buf_num, phys);
>  }
>  
> @@ -388,6 +393,13 @@ static int prp_setup_channel(struct prp_priv *priv,
>  			(image.pix.width * outcc->bpp) >> 3;
>  	}
>  
> +	priv->interweave_offset = 0;
> +
> +	if (interweave && image.pix.field == V4L2_FIELD_INTERLACED_BT) {
> +		image.rect.top = 1;
> +		priv->interweave_offset = image.pix.bytesperline;
> +	}
> +
>  	image.phys0 = addr0;
>  	image.phys1 = addr1;
>  
> @@ -425,7 +437,10 @@ static int prp_setup_channel(struct prp_priv *priv,
>  		ipu_cpmem_set_rotation(channel, rot_mode);
>  
>  	if (interweave)
> -		ipu_cpmem_interlaced_scan(channel, image.pix.bytesperline,
> +		ipu_cpmem_interlaced_scan(channel,
> +					  priv->interweave_offset ?
> +					  -image.pix.bytesperline :
> +					  image.pix.bytesperline,
>  					  image.pix.pixelformat);
>  
>  	ret = ipu_ic_task_idma_init(priv->ic, channel,
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 679295da5dde..592f7d6edec1 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -114,6 +114,8 @@ struct csi_priv {
>  	u32 frame_sequence; /* frame sequence counter */
>  	bool last_eof;   /* waiting for last EOF at stream off */
>  	bool nfb4eof;    /* NFB4EOF encountered during streaming */
> +	u32 interweave_offset; /* interweave line offset to swap
> +				  top/bottom lines */

This doesn't seem necessary. Since there is no rotation here, the offset
is just vdev->fmt.fmt.pix.bytesperline if interweave_swap is enabled.
Maybe turn this into a bool interweave_swap?

>  	struct completion last_eof_comp;
>  };
>  
> @@ -286,7 +288,8 @@ static void csi_vb2_buf_done(struct csi_priv *priv)
>  	if (ipu_idmac_buffer_is_ready(priv->idmac_ch, priv->ipu_buf_num))
>  		ipu_idmac_clear_buffer(priv->idmac_ch, priv->ipu_buf_num);
>  
> -	ipu_cpmem_set_buffer(priv->idmac_ch, priv->ipu_buf_num, phys);
> +	ipu_cpmem_set_buffer(priv->idmac_ch, priv->ipu_buf_num,
> +			     phys + priv->interweave_offset);
>  }
>  
>  static irqreturn_t csi_idmac_eof_interrupt(int irq, void *dev_id)
> @@ -396,10 +399,10 @@ static void csi_idmac_unsetup_vb2_buf(struct csi_priv *priv,
>  static int csi_idmac_setup_channel(struct csi_priv *priv)
>  {
>  	struct imx_media_video_dev *vdev = priv->vdev;
> +	bool passthrough, interweave, interweave_swap;
>  	const struct imx_media_pixfmt *incc;
>  	struct v4l2_mbus_framefmt *infmt;
>  	struct v4l2_mbus_framefmt *outfmt;
> -	bool passthrough, interweave;
>  	struct ipu_image image;
>  	u32 passthrough_bits;
>  	u32 passthrough_cycles;
> @@ -433,6 +436,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>  	 */
>  	interweave = V4L2_FIELD_IS_INTERLACED(image.pix.field) &&
>  		V4L2_FIELD_IS_SEQUENTIAL(outfmt->field);
> +	interweave_swap = interweave &&
> +		image.pix.field == V4L2_FIELD_INTERLACED_BT;

Although this could just as well be recalculated in csi_vb2_buf_done.
Apart from that,

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
