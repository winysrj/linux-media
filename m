Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57877 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbeFANfc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 09:35:32 -0400
Message-ID: <1527860129.5913.11.camel@pengutronix.de>
Subject: Re: [PATCH v2 07/10] media: imx-csi: Allow skipping odd chroma rows
 for YVU420
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Fri, 01 Jun 2018 15:35:29 +0200
In-Reply-To: <1527813049-3231-8-git-send-email-steve_longerbeam@mentor.com>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
         <1527813049-3231-8-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-05-31 at 17:30 -0700, Steve Longerbeam wrote:
> Skip writing U/V components to odd rows for YVU420 in addition to
> YUV420 and NV12.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/media/imx/imx-media-csi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 6101e2ed..c878a00 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -430,6 +430,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>  		passthrough_bits = 16;
>  		break;
>  	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
>  	case V4L2_PIX_FMT_NV12:
>  		burst_size = (image.pix.width & 0x3f) ?
>  			     ((image.pix.width & 0x1f) ?

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
