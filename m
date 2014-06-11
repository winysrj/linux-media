Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55100 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaFKFhf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 01:37:35 -0400
Date: Wed, 11 Jun 2014 07:37:32 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Jiada Wang <jiada_wang@mentor.com>
Subject: Re: [PATCH 04/43] imx-drm: ipu-v3: Add solo/dual-lite IPU device type
Message-ID: <20140611053732.GA664@pengutronix.de>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
 <1402178205-22697-5-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402178205-22697-5-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Sat, Jun 07, 2014 at 02:56:06PM -0700, Steve Longerbeam wrote:
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

This breaks bisectibility. This patch must come after

[PATCH 08/43] imx-drm: ipu-v3: Add units required for video capture

Besides, is there any difference between IPUv3HDL and IPUv3H? Can't you
reuse it?

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
