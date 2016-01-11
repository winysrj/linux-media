Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:32779 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933885AbcAKSfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 13:35:21 -0500
Received: by mail-lb0-f180.google.com with SMTP id x4so2269734lbm.0
        for <linux-media@vger.kernel.org>; Mon, 11 Jan 2016 10:35:20 -0800 (PST)
Subject: Re: [PATCH 3/3] media: soc_camera: rcar_vin: Add ARGB8888 caputre
 format support
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org
References: <1452535211-4869-1-git-send-email-ykaneko0929@gmail.com>
 <1452535211-4869-4-git-send-email-ykaneko0929@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <5693F5E5.3060109@cogentembedded.com>
Date: Mon, 11 Jan 2016 21:35:17 +0300
MIME-Version: 1.0
In-Reply-To: <1452535211-4869-4-git-send-email-ykaneko0929@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 01/11/2016 09:00 PM, Yoshihiro Kaneko wrote:

> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>
> This patch adds ARGB8888 capture format support for R-Car Gen3.
>
> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---
>   drivers/media/platform/soc_camera/rcar_vin.c | 21 +++++++++++++++++++--
>   1 file changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index cccd859..afe27bb 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
[...]
> @@ -654,6 +654,14 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>   			dmr = VNDMR_EXRGB;
>   			break;
>   		}
> +	case V4L2_PIX_FMT_ARGB32:
> +		if (priv->chip == RCAR_GEN3)
> +			dmr = VNDMR_EXRGB | VNDMR_DTMD_ARGB;
> +		else {

    Kernel coding style dictates using {} in all *if* branches if at least one 
branch has them.

> +			dev_err(icd->parent, "Not support format\n");
> +			return -EINVAL;
> +		}
> +		break;
>   	default:
>   		dev_warn(icd->parent, "Invalid fourcc format (0x%x)\n",
>   			 icd->current_fmt->host_fmt->fourcc);
[...]

MBR, Sergei

