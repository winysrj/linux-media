Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55703 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbeFANe6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 09:34:58 -0400
Message-ID: <1527860095.5913.10.camel@pengutronix.de>
Subject: Re: [PATCH v2 06/10] media: imx: Fix field setting logic in try_fmt
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Fri, 01 Jun 2018 15:34:55 +0200
In-Reply-To: <1527813049-3231-7-git-send-email-steve_longerbeam@mentor.com>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
         <1527813049-3231-7-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-05-31 at 17:30 -0700, Steve Longerbeam wrote:
> The logic for setting field type in try_fmt at CSI and PRPENCVF
> entities wasn't quite right. The behavior should be:
> 
> - No restrictions on field type at sink pads (except ANY, which is filled
>   with current sink pad field by imx_media_fill_default_mbus_fields()).
> 
> - At IDMAC output pads, if the caller asks for an interlaced output, and
>   the input is sequential fields, the IDMAC output channel can accommodate
>   by interweaving. The CSI can also interweave if input is alternate
>   fields.
> 
> - If final source pad field type is alternate, translate to seq_bt or
>   seq_tb. But the field order translation was backwards, SD NTSC is BT
>   order, SD PAL is TB.
> 
> Move this logic to new functions csi_try_field() and prp_try_field().
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/media/imx/imx-ic-prpencvf.c | 22 +++++++++++--
>  drivers/staging/media/imx/imx-media-csi.c   | 50 +++++++++++++++++++++--------
>  2 files changed, 56 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
> index 7e1e0c3..1002eb1 100644
> --- a/drivers/staging/media/imx/imx-ic-prpencvf.c
> +++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
> @@ -833,6 +833,21 @@ static int prp_get_fmt(struct v4l2_subdev *sd,
>  	return ret;
>  }
>  
> +static void prp_try_field(struct prp_priv *priv,
> +			  struct v4l2_subdev_pad_config *cfg,
> +			  struct v4l2_subdev_format *sdformat)
> +{
> +	struct v4l2_mbus_framefmt *infmt =
> +		__prp_get_fmt(priv, cfg, PRPENCVF_SINK_PAD, sdformat->which);
> +
> +	/* no restrictions on sink pad field type */
> +	if (sdformat->pad == PRPENCVF_SINK_PAD)
> +		return;
> +
> +	if (!idmac_interweave(sdformat->format.field, infmt->field))
> +		sdformat->format.field = infmt->field;

This is not strict enough. As I wrote in reply to patch 4, we can only
do SEQ_TB -> INTERLACED_TB and SEQ_BT -> INTERLACED_BT interweaving.

regards
Philipp
