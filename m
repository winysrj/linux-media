Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56561 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbeJERSg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 13:18:36 -0400
Message-ID: <1538734827.3545.14.camel@pengutronix.de>
Subject: Re: [PATCH v4 07/11] media: imx-csi: Allow skipping odd chroma rows
 for YVU420
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Fri, 05 Oct 2018 12:20:27 +0200
In-Reply-To: <20181004185401.15751-8-slongerbeam@gmail.com>
References: <20181004185401.15751-1-slongerbeam@gmail.com>
         <20181004185401.15751-8-slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-10-04 at 11:53 -0700, Steve Longerbeam wrote:
> Skip writing U/V components to odd rows for YVU420 in addition to
> YUV420 and NV12.
> 
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/staging/media/imx/imx-media-csi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 4b075bc949de..6dd53a8e35d2 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -452,6 +452,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
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
