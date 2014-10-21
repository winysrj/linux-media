Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:43832 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327AbaJUKWQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 06:22:16 -0400
Received: by mail-la0-f46.google.com with SMTP id gi9so743686lab.33
        for <linux-media@vger.kernel.org>; Tue, 21 Oct 2014 03:22:14 -0700 (PDT)
Message-ID: <544633D3.5010805@cogentembedded.com>
Date: Tue, 21 Oct 2014 14:22:11 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888
 input support
References: <1413868129-22121-1-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1413868129-22121-1-git-send-email-ykaneko0929@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 10/21/2014 9:08 AM, Yoshihiro Kaneko wrote:

> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---

> This patch is against master branch of linuxtv.org/media_tree.git.

> v2 [Yoshihiro Kaneko]
> * remove unused/useless definition as suggested by Sergei Shtylyov

    I didn't say it's useless, I just suspected that you missed the necessary 
test somewhere...

>   drivers/media/platform/soc_camera/rcar_vin.c | 9 +++++++++
>   1 file changed, 9 insertions(+)

> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 20defcb..cb5e682 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -74,6 +74,7 @@
>   #define VNMC_INF_YUV10_BT656	(2 << 16)
>   #define VNMC_INF_YUV10_BT601	(3 << 16)
>   #define VNMC_INF_YUV16		(5 << 16)
> +#define VNMC_INF_RGB888		(6 << 16)
>   #define VNMC_VUP		(1 << 10)
>   #define VNMC_IM_ODD		(0 << 3)
>   #define VNMC_IM_ODD_EVEN	(1 << 3)
[...]
> @@ -331,6 +336,9 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>   	if (output_is_yuv)
>   		vnmc |= VNMC_BPS;
>
> +	if (vnmc & VNMC_INF_RGB888)
> +		vnmc ^= VNMC_BPS;
> +

    Hm, this also changes the behavior for VNMC_INF_YUV16 and 
VNMC_INF_YUV10_BT{601|656}. Is this actually intended?

[...]

WBR, Sergei

