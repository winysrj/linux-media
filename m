Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:55747 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933767AbeALOI6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 09:08:58 -0500
Date: Fri, 12 Jan 2018 15:08:46 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        <linux-media@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-mtd@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Josh Wu <rainyfeeling@outlook.com>
Subject: Re: [PATCH v2] MAINTAINERS: mtd/nand: update Microchip nand entry
Message-ID: <20180112150846.3b74ad67@bbrezillon>
In-Reply-To: <20180111162659.740-1-nicolas.ferre@microchip.com>
References: <20180111162659.740-1-nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 11 Jan 2018 17:26:59 +0100
Nicolas Ferre <nicolas.ferre@microchip.com> wrote:

> Update Wenyou Yang email address.
> Take advantage of this update to move this entry to the MICROCHIP / ATMEL
> location and add the DT binding documentation link.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> Acked-by: Wenyou Yang <wenyou.yang@microchip.com>

Applied.

Thanks,

Boris

> ---
> v2: - patch agains 09ec417b0ea8 ("mtd: nand: samsung: Disable subpage
>       writes on E-die NAND") of 
>       http://git.infradead.org/linux-mtd.git/shortlog/refs/heads/nand/next
>     - Ack by Wenyou added
> 
> 
> Hi,
> 
> v1 patch was part of a series because it was conflicting with the previous one
> named:
> "[PATCH 1/2] MAINTAINERS: linux-media: update Microchip ISI and ISC entries"
> Boris asked me to rebase it so that they are independent.
> So, if this first one goes upstream through another tree, conflicts will have
> to be resolved at one point.
> 
> Best regards,
>   Nicolas
> 
> 
>  MAINTAINERS | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index aa71ab52fd76..37ee5ae4bae2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2382,13 +2382,6 @@ F:	Documentation/devicetree/bindings/input/atmel,maxtouch.txt
>  F:	drivers/input/touchscreen/atmel_mxt_ts.c
>  F:	include/linux/platform_data/atmel_mxt_ts.h
>  
> -ATMEL NAND DRIVER
> -M:	Wenyou Yang <wenyou.yang@atmel.com>
> -M:	Josh Wu <rainyfeeling@outlook.com>
> -L:	linux-mtd@lists.infradead.org
> -S:	Supported
> -F:	drivers/mtd/nand/atmel/*
> -
>  ATMEL SAMA5D2 ADC DRIVER
>  M:	Ludovic Desroches <ludovic.desroches@microchip.com>
>  L:	linux-iio@vger.kernel.org
> @@ -9045,6 +9038,14 @@ F:	drivers/media/platform/atmel/atmel-isc.c
>  F:	drivers/media/platform/atmel/atmel-isc-regs.h
>  F:	devicetree/bindings/media/atmel-isc.txt
>  
> +MICROCHIP / ATMEL NAND DRIVER
> +M:	Wenyou Yang <wenyou.yang@microchip.com>
> +M:	Josh Wu <rainyfeeling@outlook.com>
> +L:	linux-mtd@lists.infradead.org
> +S:	Supported
> +F:	drivers/mtd/nand/atmel/*
> +F:	Documentation/devicetree/bindings/mtd/atmel-nand.txt
> +
>  MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER
>  M:	Woojung Huh <Woojung.Huh@microchip.com>
>  M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
