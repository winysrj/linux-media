Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35643 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932335AbdGSQfM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 12:35:12 -0400
Received: by mail-pg0-f65.google.com with SMTP id d193so453182pgc.2
        for <linux-media@vger.kernel.org>; Wed, 19 Jul 2017 09:35:12 -0700 (PDT)
Subject: Re: [PATCH v2] [media] imx: csi: enable double write reduction
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20170719163420.27608-1-p.zabel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <63f48880-4640-2b97-58a9-5594bb39fd2a@gmail.com>
Date: Wed, 19 Jul 2017 09:35:10 -0700
MIME-Version: 1.0
In-Reply-To: <20170719163420.27608-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>

On 07/19/2017 09:34 AM, Philipp Zabel wrote:
> For 4:2:0 subsampled YUV formats, avoid chroma overdraw by only writing
> chroma for even lines. Reduces necessary write memory bandwidth by 25%.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v1:
>   - Move odd row skipping setup into existing switch statement.
> ---
>   drivers/staging/media/imx/imx-media-csi.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index a2d26693912ec..f2d64d1eeff80 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -357,6 +357,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>   		passthrough = (sensor_ep->bus_type != V4L2_MBUS_CSI2 &&
>   			       sensor_ep->bus.parallel.bus_width >= 16);
>   		passthrough_bits = 16;
> +		/* Skip writing U and V components to odd rows */
> +		ipu_cpmem_skip_odd_chroma_rows(priv->idmac_ch);
>   		break;
>   	case V4L2_PIX_FMT_YUYV:
>   	case V4L2_PIX_FMT_UYVY:
> 
