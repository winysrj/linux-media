Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33999 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbcAMS1N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 13:27:13 -0500
Received: by mail-lf0-f43.google.com with SMTP id 17so58852063lfz.1
        for <linux-media@vger.kernel.org>; Wed, 13 Jan 2016 10:27:12 -0800 (PST)
Subject: Re: [PATCH v3] media: soc_camera: rcar_vin: Add ARGB8888 caputre
 format support
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org
References: <1452707964-4379-1-git-send-email-ykaneko0929@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <569696FC.1080804@cogentembedded.com>
Date: Wed, 13 Jan 2016 21:27:08 +0300
MIME-Version: 1.0
In-Reply-To: <1452707964-4379-1-git-send-email-ykaneko0929@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 01/13/2016 08:59 PM, Yoshihiro Kaneko wrote:

> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>
> This patch adds ARGB8888 capture format support for R-Car Gen3.
>
> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---
>
> This patch is based on the for-4.6-1 branch of Guennadi's v4l-dvb tree.
>
> v3 [Yoshihiro Kaneko]
> * rebased to for-4.6-1 branch of Guennadi's tree.
>
> v2 [Yoshihiro Kaneko]
> * As suggested by Sergei Shtylyov
>    - fix the coding style of the braces.
>
>   drivers/media/platform/soc_camera/rcar_vin.c | 21 +++++++++++++++++++--
>   1 file changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index dc75a80..466c63a 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
[...]
> @@ -654,6 +654,14 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>   			dmr = VNDMR_EXRGB;
>   			break;
>   		}
> +	case V4L2_PIX_FMT_ARGB32:
> +		if (priv->chip == RCAR_GEN3) {
> +			dmr = VNDMR_EXRGB | VNDMR_DTMD_ARGB;
> +		} else {
> +			dev_err(icd->parent, "Not support format\n");

    "Unsupported format" please.

[...]

MBR, Sergei

