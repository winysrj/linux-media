Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:11746 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753023AbeFDNc4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 09:32:56 -0400
Date: Mon, 4 Jun 2018 15:31:58 +0200
From: Ludovic Desroches <ludovic.desroches@microchip.com>
To: Nicholas Mc Guire <hofrat@opentech.at>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Nicholas Mc Guire <hofrat@osadl.org>
Subject: Re: [PATCH] media: atmel-isi: move of_node_put() to cover success
 branch as well
Message-ID: <20180604133158.jnys4jliy4d7rwpi@rfolt0960.corp.atmel.com>
References: <1527859814-30410-1-git-send-email-hofrat@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1527859814-30410-1-git-send-email-hofrat@opentech.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 01, 2018 at 01:30:14PM +0000, Nicholas Mc Guire wrote:
> From: Nicholas Mc Guire <hofrat@osadl.org>
> 
> The of_node_put() was only covering the error branch but missed the 
> success branch so the refcount for ep which 
> of_graph_get_remote_port_parent() incremented on success would was
> not being decremented.
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>

Thanks

> ---
> 
> This patch is on top of: "media: atmel-isi: drop unnecessary while loop"
> 
> Patch was compile tested with: x86_64_defconfig + CONFIG_MEDIA_SUPPORT=y
> MEDIA_CAMERA_SUPPORT=y, CONFIG_MEDIA_CONTROLLER=y, V4L_PLATFORM_DRIVERS=y
> OF=y, CONFIG_COMPILE_TEST=y, CONFIG_VIDEO_ATMEL_ISI=y
> 
> Compile testing atmel-isi.c shows some sparse warnings. Seems to be due to
> sizeof operator being applied to a union (not related to the function being
> changed though).
> 
> Patch is against 4.17-rc7 (localversion-next is next-20180531)
> 
>  drivers/media/platform/atmel/atmel-isi.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
> index 85fc7b9..e8db4df 100644
> --- a/drivers/media/platform/atmel/atmel-isi.c
> +++ b/drivers/media/platform/atmel/atmel-isi.c
> @@ -1111,10 +1111,9 @@ static int isi_graph_parse(struct atmel_isi *isi, struct device_node *node)
>  		return -EINVAL;
>  
>  	remote = of_graph_get_remote_port_parent(ep);
> -	if (!remote) {
> -		of_node_put(ep);
> +	of_node_put(ep);
> +	if (!remote)
>  		return -EINVAL;
> -	}
>  
>  	/* Remote node to connect */
>  	isi->entity.node = remote;
> -- 
> 2.1.4
> 
