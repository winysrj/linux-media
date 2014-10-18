Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:58379 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaJRPCP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Oct 2014 11:02:15 -0400
Received: by mail-la0-f47.google.com with SMTP id pv20so2051995lab.34
        for <linux-media@vger.kernel.org>; Sat, 18 Oct 2014 08:02:13 -0700 (PDT)
Message-ID: <544280E4.20101@cogentembedded.com>
Date: Sat, 18 Oct 2014 19:01:56 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH] media: soc_camera: rcar_vin: Enable VSYNC field toggle
 mode
References: <1413267956-8342-1-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1413267956-8342-1-git-send-email-ykaneko0929@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 10/14/2014 10:25 AM, Yoshihiro Kaneko wrote:

> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

> By applying this patch, it sets to VSYNC field toggle mode not only
> at the time of progressive mode but at the time of an interlace mode.

> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---

> This patch is against master branch of linuxtv.org/media_tree.git.

>   drivers/media/platform/soc_camera/rcar_vin.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 5196c81..bf97ed6 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -108,6 +108,7 @@
>   #define VNDMR2_VPS		(1 << 30)
>   #define VNDMR2_HPS		(1 << 29)
>   #define VNDMR2_FTEV		(1 << 17)
> +#define VNDMR2_VLV_1		(1 << 12)

    Please instead do:

#define VNDMR2_VLV(n)	((n & 0xf) << 12)

WBR, Sergei

