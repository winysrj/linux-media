Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:43742 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3KCKvd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 05:51:33 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVO0031QOTWVN20@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 03 Nov 2013 05:51:32 -0500 (EST)
Date: Sun, 03 Nov 2013 08:51:28 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Maik Broemme <mbroemme@parallels.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 12/12] ddbridge: Kconfig and Makefile fixes to build latest
 ddbridge
Message-id: <20131103085128.3416b2d0@samsung.com>
In-reply-to: <20131103004611.GP7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
 <20131103004611.GP7956@parallels.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 3 Nov 2013 01:46:12 +0100
Maik Broemme <mbroemme@parallels.com> escreveu:

> Fixed Kconfig and Makefile to build latest version off ddbridge. It
> adds support for the following devices:
> 
>   - Octopus DVB adapter
>   - Octopus V3 DVB adapter
>   - Octopus LE DVB adapter
>   - Octopus OEM
>   - Octopus Mini
>   - Cine S2 V6 DVB adapter
>   - Cine S2 V6.5 DVB adapter
>   - Octopus CI
>   - Octopus CI single
>   - DVBCT V6.1 DVB adapter
>   - DVB-C modulator
>   - SaTiX-S2 V3 DVB adapter

Again, this won't work, as it would break compilation.

> 
> Signed-off-by: Maik Broemme <mbroemme@parallels.com>
> ---
>  drivers/media/pci/ddbridge/Kconfig  | 21 +++++++++++++++------
>  drivers/media/pci/ddbridge/Makefile |  2 +-
>  2 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/pci/ddbridge/Kconfig b/drivers/media/pci/ddbridge/Kconfig
> index 44e5dc1..a30848f 100644
> --- a/drivers/media/pci/ddbridge/Kconfig
> +++ b/drivers/media/pci/ddbridge/Kconfig
> @@ -6,13 +6,22 @@ config DVB_DDBRIDGE
>  	select DVB_STV090x if MEDIA_SUBDRV_AUTOSELECT
>  	select DVB_DRXK if MEDIA_SUBDRV_AUTOSELECT
>  	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
> +	select DVB_STV0367DD if MEDIA_SUBDRV_AUTOSELECT
> +	select DVB_TDA18212DD if MEDIA_SUBDRV_AUTOSELECT
> +	select DVB_CXD2843 if MEDIA_SUBDRV_AUTOSELECT
>  	---help---
>  	  Support for cards with the Digital Devices PCI express bridge:
> -	  - Octopus PCIe Bridge
> -	  - Octopus mini PCIe Bridge
> -	  - Octopus LE
> -	  - DuoFlex S2 Octopus
> -	  - DuoFlex CT Octopus
> -	  - cineS2(v6)
> +	  - Octopus DVB adapter
> +	  - Octopus V3 DVB adapter
> +	  - Octopus LE DVB adapter
> +	  - Octopus OEM
> +	  - Octopus Mini
> +	  - Cine S2 V6 DVB adapter
> +	  - Cine S2 V6.5 DVB adapter
> +	  - Octopus CI
> +	  - Octopus CI single
> +	  - DVBCT V6.1 DVB adapter
> +	  - DVB-C modulator
> +	  - SaTiX-S2 V3 DVB adapter
>  
>  	  Say Y if you own such a card and want to use it.
> diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
> index 7446c8b..c274b81 100644
> --- a/drivers/media/pci/ddbridge/Makefile
> +++ b/drivers/media/pci/ddbridge/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for the ddbridge device driver
>  #
>  
> -ddbridge-objs := ddbridge-core.o
> +ddbridge-objs := ddbridge-core.o ddbridge-i2c.o ddbridge-mod.o
>  
>  obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
>  


-- 

Cheers,
Mauro
