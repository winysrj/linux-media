Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34525 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbbLMRn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2015 12:43:57 -0500
Received: by lfcy184 with SMTP id y184so33552321lfc.1
        for <linux-media@vger.kernel.org>; Sun, 13 Dec 2015 09:43:55 -0800 (PST)
Subject: Re: [PATCH] media: soc_camera: rcar_vin: Add R-Car Gen3 support
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org
References: <1450020436-809-1-git-send-email-ykaneko0929@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <566DAE57.6030000@cogentembedded.com>
Date: Sun, 13 Dec 2015 20:43:51 +0300
MIME-Version: 1.0
In-Reply-To: <1450020436-809-1-git-send-email-ykaneko0929@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2015 06:27 PM, Yoshihiro Kaneko wrote:

> From: Yoshihiko Mori <yoshihiko.mori.nx@renesas.com>
>
> Add chip identification for R-Car Gen3.
>
> Signed-off-by: Yoshihiko Mori <yoshihiko.mori.nx@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
[...]
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 5d90f39..29e7ca4 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -143,6 +143,7 @@
>   #define RCAR_VIN_BT656			(1 << 3)
>
>   enum chip_id {
> +	RCAR_GEN3,
>   	RCAR_GEN2,
>   	RCAR_H1,
>   	RCAR_M1,
> @@ -1846,6 +1847,7 @@ static struct soc_camera_host_ops rcar_vin_host_ops = {
>
>   #ifdef CONFIG_OF
>   static const struct of_device_id rcar_vin_of_table[] = {
> +	{ .compatible = "renesas,vin-r8a7795", .data = (void *)RCAR_GEN3 },

    I don't see where this is checked in the driver. Shouldn't we just use gen2?

MBR, Sergei

