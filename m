Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48272 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaFKLjA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 07:39:00 -0400
Message-ID: <1402486738.4107.129.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 04/43] imx-drm: ipu-v3: Add solo/dual-lite IPU device
 type
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Jiada Wang <jiada_wang@mentor.com>
Date: Wed, 11 Jun 2014 13:38:58 +0200
In-Reply-To: <1402178205-22697-5-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402178205-22697-5-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
> Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
> ---
>  drivers/staging/imx-drm/ipu-v3/ipu-common.c |   18 ++++++++++++++++++
>  include/linux/platform_data/imx-ipu-v3.h    |    1 +
>  2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
> index f8e8c56..2d95a7c 100644
> --- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
> +++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
> @@ -829,10 +829,28 @@ static struct ipu_devtype ipu_type_imx6q = {
>  	.type = IPUV3H,
>  };
>  
> +static struct ipu_devtype ipu_type_imx6dl = {
> +	.name = "IPUv3HDL",
> +	.cm_ofs = 0x00200000,
> +	.cpmem_ofs = 0x00300000,
> +	.srm_ofs = 0x00340000,
> +	.tpm_ofs = 0x00360000,
> +	.csi0_ofs = 0x00230000,
> +	.csi1_ofs = 0x00238000,
> +	.disp0_ofs = 0x00240000,
> +	.disp1_ofs = 0x00248000,
> +	.smfc_ofs =  0x00250000,
> +	.ic_ofs = 0x00220000,
> +	.vdi_ofs = 0x00268000,
> +	.dc_tmpl_ofs = 0x00380000,
> +	.type = IPUV3HDL,
> +};

This just duplicates ipu_type_imx6. Do I understand correctly that this
new type was added just to account for the different input multiplexer
setup between i.MX6Q and i.MX6DL outside of the IPU?

This would not be necessary if we describe the multiplexers as separate
v4l2_subdev entities. The same applies to the following patch 05/43.

regards
Philipp

