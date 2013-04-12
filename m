Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3449 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab3DLLcr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 07:32:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: [PATCH 1/2] [media] blackfin: add display support in ppi driver
Date: Fri, 12 Apr 2013 13:32:12 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
References: <1365810779-24335-1-git-send-email-scott.jiang.linux@gmail.com>
In-Reply-To: <1365810779-24335-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304121332.13025.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat April 13 2013 01:52:57 Scott Jiang wrote:
> Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>

Is it OK if I postpone these two patches for 3.11? They don't make sense
AFAICT without the new display driver, and that will definitely not make it
for 3.10.

Regards,

	Hans

> ---
>  drivers/media/platform/blackfin/ppi.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/platform/blackfin/ppi.c b/drivers/media/platform/blackfin/ppi.c
> index 01b5b50..15e9c2b 100644
> --- a/drivers/media/platform/blackfin/ppi.c
> +++ b/drivers/media/platform/blackfin/ppi.c
> @@ -266,6 +266,18 @@ static int ppi_set_params(struct ppi_if *ppi, struct ppi_params *params)
>  		bfin_write32(&reg->vcnt, params->height);
>  		if (params->int_mask)
>  			bfin_write32(&reg->imsk, params->int_mask & 0xFF);
> +		if (ppi->ppi_control & PORT_DIR) {
> +			u32 hsync_width, vsync_width, vsync_period;
> +
> +			hsync_width = params->hsync
> +					* params->bpp / params->dlen;
> +			vsync_width = params->vsync * samples_per_line;
> +			vsync_period = samples_per_line * params->frame;
> +			bfin_write32(&reg->fs1_wlhb, hsync_width);
> +			bfin_write32(&reg->fs1_paspl, samples_per_line);
> +			bfin_write32(&reg->fs2_wlvb, vsync_width);
> +			bfin_write32(&reg->fs2_palpf, vsync_period);
> +		}
>  		break;
>  	}
>  	default:
> 
