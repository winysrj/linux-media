Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49971 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbeHBLgp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 07:36:45 -0400
Message-ID: <1533203182.3516.12.camel@pengutronix.de>
Subject: Re: [PATCH v3 05/14] gpu: ipu-v3: Allow negative offsets for
 interlaced scanning
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX"
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Thu, 02 Aug 2018 11:46:22 +0200
In-Reply-To: <1533150747-30677-6-git-send-email-steve_longerbeam@mentor.com>
References: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
         <1533150747-30677-6-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-08-01 at 12:12 -0700, Steve Longerbeam wrote:
> From: Philipp Zabel <p.zabel@pengutronix.de>
> 
> The IPU also supports interlaced buffers that start with the bottom field.
> To achieve this, the the base address EBA has to be increased by a stride
> length and the interlace offset ILO has to be set to the negative stride.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/gpu/ipu-v3/ipu-cpmem.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
> index e68e473..8cd9e37 100644
> --- a/drivers/gpu/ipu-v3/ipu-cpmem.c
> +++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
> @@ -269,9 +269,20 @@ EXPORT_SYMBOL_GPL(ipu_cpmem_set_uv_offset);
>  
>  void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride)
>  {
> +	u32 ilo, sly;
> +
> +	if (stride < 0) {
> +		stride = -stride;
> +		ilo = 0x100000 - (stride / 8);
> +	} else {
> +		ilo = stride / 8;
> +	}
> +
> +	sly = (stride * 2) - 1;
> +
>  	ipu_ch_param_write_field(ch, IPU_FIELD_SO, 1);
> -	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, stride / 8);
> -	ipu_ch_param_write_field(ch, IPU_FIELD_SLY, (stride * 2) - 1);
> +	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, ilo);
> +	ipu_ch_param_write_field(ch, IPU_FIELD_SLY, sly);
>  };
>  EXPORT_SYMBOL_GPL(ipu_cpmem_interlaced_scan);

This patch is merged in drm-next: 4e3c5d7e05be ("gpu: ipu-v3: Allow
negative offsets for interlaced scanning")

regards
Philipp
