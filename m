Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:59592 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaJRO4N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Oct 2014 10:56:13 -0400
Received: by mail-la0-f50.google.com with SMTP id s18so2059826lam.9
        for <linux-media@vger.kernel.org>; Sat, 18 Oct 2014 07:56:11 -0700 (PDT)
Message-ID: <54427F7A.5030009@cogentembedded.com>
Date: Sat, 18 Oct 2014 18:55:54 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888
 input support
References: <1413267730-8172-1-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1413267730-8172-1-git-send-email-ykaneko0929@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 10/14/2014 10:22 AM, Yoshihiro Kaneko wrote:

> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---

> This patch is against master branch of linuxtv.org/media_tree.git.

>   drivers/media/platform/soc_camera/rcar_vin.c | 10 ++++++++++
>   include/linux/platform_data/camera-rcar.h    |  1 +
>   2 files changed, 11 insertions(+)

> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 20defcb..7eb4f1e 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -74,6 +74,8 @@
>   #define VNMC_INF_YUV10_BT656	(2 << 16)
>   #define VNMC_INF_YUV10_BT601	(3 << 16)
>   #define VNMC_INF_YUV16		(5 << 16)
> +#define VNMC_INF_RGB888		(6 << 16)
> +#define VNMC_INF_RGB_MASK	(6 << 16)

    I don't see why you direly need this mask; you could use VNMC_INF_RGB888.

[...]
> diff --git a/include/linux/platform_data/camera-rcar.h b/include/linux/platform_data/camera-rcar.h
> index dfc83c5..03a9df6 100644
> --- a/include/linux/platform_data/camera-rcar.h
> +++ b/include/linux/platform_data/camera-rcar.h
> @@ -17,6 +17,7 @@
>   #define RCAR_VIN_VSYNC_ACTIVE_LOW	(1 << 1)
>   #define RCAR_VIN_BT601			(1 << 2)
>   #define RCAR_VIN_BT656			(1 << 3)
> +#define RCAR_VIN_BT709			(1 << 4)

    I don't see where it's used...

WBR, Sergei

