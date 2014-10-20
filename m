Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:50341 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaJTQUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Oct 2014 12:20:21 -0400
Date: Mon, 20 Oct 2014 18:20:16 +0200
From: Simon Horman <horms@verge.net.au>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH] media: soc_camera: rcar_vin: Add DT support for r8a7793
 and r8a7794 SoCs
Message-ID: <20141020162015.GB1362@verge.net.au>
References: <1413773489-18170-1-git-send-email-ykaneko0929@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413773489-18170-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 20, 2014 at 11:51:29AM +0900, Yoshihiro Kaneko wrote:
> Based on platform device work by Matsuoka-san.
> 
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>

Acked-by: Simon Horman <horms+renesas@verge.net.au>

> ---
> 
> Compile tested only.
> 
> This patch is against master branch of linuxtv.org/media_tree.git.
> 
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 2 ++
>  drivers/media/platform/soc_camera/rcar_vin.c         | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index ba61782..9dafe6b 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -6,6 +6,8 @@ family of devices. The current blocks are always slaves and suppot one input
>  channel which can be either RGB, YUYV or BT656.
>  
>   - compatible: Must be one of the following
> +   - "renesas,vin-r8a7794" for the R8A7794 device
> +   - "renesas,vin-r8a7793" for the R8A7793 device
>     - "renesas,vin-r8a7791" for the R8A7791 device
>     - "renesas,vin-r8a7790" for the R8A7790 device
>     - "renesas,vin-r8a7779" for the R8A7779 device
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 234cf86..c023aab 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -1871,6 +1871,8 @@ static struct soc_camera_host_ops rcar_vin_host_ops = {
>  
>  #ifdef CONFIG_OF
>  static struct of_device_id rcar_vin_of_table[] = {
> +	{ .compatible = "renesas,vin-r8a7794", .data = (void *)RCAR_GEN2 },
> +	{ .compatible = "renesas,vin-r8a7793", .data = (void *)RCAR_GEN2 },
>  	{ .compatible = "renesas,vin-r8a7791", .data = (void *)RCAR_GEN2 },
>  	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
>  	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
