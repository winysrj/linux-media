Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34623 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753686AbeE1HAn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 03:00:43 -0400
Message-ID: <1527490835.6846.1.camel@pengutronix.de>
Subject: Re: [PATCH 4/6] media: imx-csi: Enable interlaced scan for field
 type alternate
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Mon, 28 May 2018 09:00:35 +0200
In-Reply-To: <1527292416-26187-5-git-send-email-steve_longerbeam@mentor.com>
References: <1527292416-26187-1-git-send-email-steve_longerbeam@mentor.com>
         <1527292416-26187-5-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-05-25 at 16:53 -0700, Steve Longerbeam wrote:
> Interlaced scan, a.k.a. interweave, should be enabled at the CSI IDMAC
> output pad if the input field type is 'alternate' (in addition to field
> types 'seq-tb' and 'seq-bt').
> 
> Which brings up whether V4L2_FIELD_HAS_BOTH() macro should be used
> to determine enabling interlaced/interweave scan. That macro
> includes the 'interlaced' field types, and in those cases the data
> is already interweaved with top/bottom field lines. A heads-up for
> now that this if statement may need to call V4L2_FIELD_IS_SEQUENTIAL()
> instead, I have no sensor hardware that sends 'interlaced' data, so can't
> test.

I agree, the check here should be IS_SEQUENTIAL || ALTERNATE, and
interlaced_scan should also be enabled if image.pix.field is
INTERLACED_TB/BT.
And for INTERLACED_TB/BT input, the logic should be inverted: then we'd
have to enable interlaced_scan whenever image.pix.field is SEQ_BT/TB.

regards
Philipp

> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/media/imx/imx-media-csi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 9bc555c..eef3483 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -477,7 +477,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>  	ipu_smfc_set_burstsize(priv->smfc, burst_size);
>  
>  	if (image.pix.field == V4L2_FIELD_NONE &&
> -	    V4L2_FIELD_HAS_BOTH(infmt->field))
> +	    (V4L2_FIELD_HAS_BOTH(infmt->field) ||
> +	     infmt->field == V4L2_FIELD_ALTERNATE))
>  		ipu_cpmem_interlaced_scan(priv->idmac_ch,
>  					  image.pix.bytesperline);
>  
