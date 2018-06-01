Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49097 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751501AbeFAN0m (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 09:26:42 -0400
Message-ID: <1527859598.5913.6.camel@pengutronix.de>
Subject: Re: [PATCH v2 02/10] gpu: ipu-csi: Check for field type alternate
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Fri, 01 Jun 2018 15:26:38 +0200
In-Reply-To: <1527813049-3231-3-git-send-email-steve_longerbeam@mentor.com>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
         <1527813049-3231-3-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Thu, 2018-05-31 at 17:30 -0700, Steve Longerbeam wrote:
> When the CSI is receiving from a bt.656 bus, include a check for
> field type 'alternate' when determining whether to set CSI clock
> mode to CCIR656_INTERLACED or CCIR656_PROGRESSIVE.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/gpu/ipu-v3/ipu-csi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
> index caa05b0..5450a2d 100644
> --- a/drivers/gpu/ipu-v3/ipu-csi.c
> +++ b/drivers/gpu/ipu-v3/ipu-csi.c
> @@ -339,7 +339,8 @@ static void fill_csi_bus_cfg(struct ipu_csi_bus_config *csicfg,
>  		break;
>  	case V4L2_MBUS_BT656:
>  		csicfg->ext_vsync = 0;
> -		if (V4L2_FIELD_HAS_BOTH(mbus_fmt->field))
> +		if (V4L2_FIELD_HAS_BOTH(mbus_fmt->field) ||
> +		    mbus_fmt->field == V4L2_FIELD_ALTERNATE)
>  			csicfg->clk_mode = IPU_CSI_CLK_MODE_CCIR656_INTERLACED;
>  		else
>  			csicfg->clk_mode = IPU_CSI_CLK_MODE_CCIR656_PROGRESSIVE;

Thank you, applied to imx-drm/next.

regards
Philipp
