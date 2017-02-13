Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48891 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbdBMXaG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 18:30:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 8/8] v4l: vsp1: Implement left edge partition algorithm overlap
Date: Tue, 14 Feb 2017 01:30:32 +0200
Message-ID: <2338978.1bsPvtQNTy@avalon>
In-Reply-To: <19c6a7d542809dc814b5dfb11ba8ab737eab56f9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com> <19c6a7d542809dc814b5dfb11ba8ab737eab56f9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday 10 Feb 2017 20:27:36 Kieran Bingham wrote:
> Increase the overlap on the left edge to allow a margin to provide
> better image scaling

-EIMPOSSIBLE_TO_REVIEW I'm afraid, we need more detailed documentation.

> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_rpf.c |  7 +++++-
>  drivers/media/platform/vsp1/vsp1_uds.c | 39 ++++++++++++++++++++++++---
>  2 files changed, 42 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c
> b/drivers/media/platform/vsp1/vsp1_rpf.c index 94541ab4ca36..d08cfd944b7b
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_rpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rpf.c
> @@ -247,6 +247,13 @@ struct vsp1_partition_rect *rpf_partition(struct
> vsp1_entity *entity, /* Duplicate the target configuration to the RPF */
>  	partition->rpf = *dest;
> 
> +	/*
> +	 * A partition offset, is a request for more input pixels, and a
> +	 * declaration that the consumer will clip excess.
> +	 */
> +	partition->rpf.width += dest->offset;
> +	partition->rpf.left -= dest->offset;
> +
>  	return &partition->rpf;
>  }
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_uds.c
> b/drivers/media/platform/vsp1/vsp1_uds.c index 9c1fb7ef3c46..9ee476c8db59
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_uds.c
> +++ b/drivers/media/platform/vsp1/vsp1_uds.c
> @@ -81,6 +81,20 @@ static struct uds_phase uds_phase_calculation(int
> position, int start_phase, return phase;
>  }
> 
> +static int uds_left_src_pixel(int pos, int start_phase, int ratio)
> +{
> +	struct uds_phase phase;
> +
> +	phase = uds_phase_calculation(pos, start_phase, ratio);
> +
> +	/* Renesas guard against odd values in these scale ratios here ? */
> +	if ((phase.mp == 2 && (phase.residual & 0x01)) ||
> +	    (phase.mp == 4 && (phase.residual & 0x03)))
> +		WARN_ON(1);

That's harsh. Can it happen, or can we prove it can't happen ?

> +	return phase.mp * (phase.prefilt_outpos + (phase.residual ? 1 : 0));
> +}
> +
>  static int uds_start_phase(int pos, int start_phase, int ratio)
>  {
>  	struct uds_phase phase;
> @@ -420,6 +434,8 @@ struct vsp1_partition_rect *uds_partition(struct
> vsp1_entity *entity, const struct v4l2_mbus_framefmt *input;
>  	unsigned int hscale;
>  	unsigned int image_start_phase = 0;
> +	unsigned int right_sink;
> +	unsigned int margin;
> 
>  	/* Initialise the partition state */
>  	partition->uds_sink = *dest;
> @@ -432,10 +448,25 @@ struct vsp1_partition_rect *uds_partition(struct
> vsp1_entity *entity,
> 
>  	hscale = uds_compute_ratio(input->width, output->width);
> 
> -	partition->uds_sink.width = dest->width * input->width
> -				  / output->width;
> -	partition->uds_sink.left = dest->left * input->width
> -				 / output->width;
> +	/* Handle 'left' edge of the partitions */
> +	if (partition_idx == 0) {
> +		margin = 0;
> +	} else {
> +		margin = hscale < 0x200 ? 32 : /* 8 <  scale */
> +			 hscale < 0x400 ? 16 : /* 4 <  scale <= 8 */
> +			 hscale < 0x800 ?  8 : /* 2 <  scale <= 4 */
> +					   4;  /* 1 <  scale <= 2, scale <= 1 
*/
> +	}
> +
> +	partition->uds_sink.left = uds_left_src_pixel(dest->left,
> +					image_start_phase, hscale);
> +
> +	partition->uds_sink.offset = margin;
> +
> +	right_sink = uds_left_src_pixel(dest->left + dest->width - 1,
> +					image_start_phase, hscale);
> +
> +	partition->uds_sink.width = right_sink - partition->uds_sink.left + 1;
> 
>  	partition->start_phase = uds_start_phase(partition->uds_source.left,
>  						 image_start_phase, hscale);

-- 
Regards,

Laurent Pinchart
