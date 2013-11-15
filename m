Return-path: <linux-media-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:44235 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3KOQRK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 11:17:10 -0500
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-media@vger.kernel.org> from <clg@fr.ibm.com>;
	Fri, 15 Nov 2013 16:17:08 -0000
Message-ID: <528648F7.20900@fr.ibm.com>
Date: Fri, 15 Nov 2013 17:16:55 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
MIME-Version: 1.0
To: Russell King <rmk+kernel@arm.linux.org.uk>
CC: alsa-devel@alsa-project.org, b43-dev@lists.infradead.org,
	devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org, e1000-devel@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-omap@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-tegra@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
	uclinux-dist-devel@blackfin.uclinux.org,
	Paul Mackerras <paulus@samba.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 16/51] DMA-API: ppc: vio.c: replace dma_set_mask()+dma_set_coherent_mask()
 with new helper
References: <20130919212235.GD12758@n2100.arm.linux.org.uk> <E1VMly8-0007gy-Ru@rmk-PC.arm.linux.org.uk>
In-Reply-To: <E1VMly8-0007gy-Ru@rmk-PC.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

On 09/19/2013 11:41 PM, Russell King wrote:
> Replace the following sequence:
> 
> 	dma_set_mask(dev, mask);
> 	dma_set_coherent_mask(dev, mask);
> 
> with a call to the new helper dma_set_mask_and_coherent().
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  arch/powerpc/kernel/vio.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
> index 78a3506..96b6c97 100644
> --- a/arch/powerpc/kernel/vio.c
> +++ b/arch/powerpc/kernel/vio.c
> @@ -1413,8 +1413,7 @@ struct vio_dev *vio_register_device_node(struct device_node *of_node)
> 
>  		/* needed to ensure proper operation of coherent allocations
>  		 * later, in case driver doesn't set it explicitly */
> -		dma_set_mask(&viodev->dev, DMA_BIT_MASK(64));
> -		dma_set_coherent_mask(&viodev->dev, DMA_BIT_MASK(64));
> +		dma_set_mask_and_coherent(&viodev->dev, DMA_BIT_MASK(64));
>  	}
> 
>  	/* register with generic device framework */
> 

The new helper routine dma_set_mask_and_coherent() breaks the 
initialization of the pseries vio devices which do not have an 
initial dev->dma_mask. I think we need to use dma_coerce_mask_and_coherent()
instead.

Signed-off-by: Cédric Le Goater <clg@fr.ibm.com>
---
 arch/powerpc/kernel/vio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index e7d0c88f..76a6482 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1419,7 +1419,7 @@ struct vio_dev *vio_register_device_node(struct device_node *of_node)
 
 		/* needed to ensure proper operation of coherent allocations
 		 * later, in case driver doesn't set it explicitly */
-		dma_set_mask_and_coherent(&viodev->dev, DMA_BIT_MASK(64));
+		dma_coerce_mask_and_coherent(&viodev->dev, DMA_BIT_MASK(64));
 	}
 
 	/* register with generic device framework */
-- 
1.7.10.4


