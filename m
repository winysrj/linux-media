Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:55248 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751969AbeAIOBJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 09:01:09 -0500
Date: Tue, 9 Jan 2018 15:01:02 +0100
From: Ludovic Desroches <ludovic.desroches@microchip.com>
To: Nicolas Ferre <nicolas.ferre@microchip.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <linux-media@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-mtd@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Josh Wu <rainyfeeling@outlook.com>
Subject: Re: [PATCH 1/2] MAINTAINERS: linux-media: update Microchip ISI and
 ISC entries
Message-ID: <20180109140102.GH2425@rfolt0960.corp.atmel.com>
References: <eb6b3cbe8e48faee7e88eca0649e42cbde91ffa6.1515503733.git.nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <eb6b3cbe8e48faee7e88eca0649e42cbde91ffa6.1515503733.git.nicolas.ferre@microchip.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 09, 2018 at 02:46:39PM +0100, Nicolas Ferre wrote:
> These two image capture interface drivers are now handled
> by Wenyou Yang.
> I benefit from this change to update the two entries by correcting the
> binding documentation link for ISC and moving the ISI to the new
> MICROCHIP / ATMEL location.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>

> ---
> Hi,
> 
> Patch against next-20180109.
> Note that I didn't find it useful to have several patches for these changes.
> Tell me if you feel differently.
> 
> I would like to have the Ack from Ludovic and Wenyou obviously. I don't know if
> Songjun can answer as he's not with Microchip anymore.
> 
> Best regards,
>   Nicolas
> 
>  MAINTAINERS | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a7d10a2bb980..65c4b59b582f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2353,13 +2353,6 @@ L:	linux-i2c@vger.kernel.org
>  S:	Supported
>  F:	drivers/i2c/busses/i2c-at91.c
>  
> -ATMEL ISI DRIVER
> -M:	Ludovic Desroches <ludovic.desroches@microchip.com>
> -L:	linux-media@vger.kernel.org
> -S:	Supported
> -F:	drivers/media/platform/atmel/atmel-isi.c
> -F:	include/media/atmel-isi.h
> -
>  ATMEL LCDFB DRIVER
>  M:	Nicolas Ferre <nicolas.ferre@microchip.com>
>  L:	linux-fbdev@vger.kernel.org
> @@ -9102,12 +9095,20 @@ S:	Maintained
>  F:	drivers/crypto/atmel-ecc.*
>  
>  MICROCHIP / ATMEL ISC DRIVER
> -M:	Songjun Wu <songjun.wu@microchip.com>
> +M:	Wenyou Yang <wenyou.yang@microchip.com>
>  L:	linux-media@vger.kernel.org
>  S:	Supported
>  F:	drivers/media/platform/atmel/atmel-isc.c
>  F:	drivers/media/platform/atmel/atmel-isc-regs.h
> -F:	devicetree/bindings/media/atmel-isc.txt
> +F:	Documentation/devicetree/bindings/media/atmel-isc.txt
> +
> +MICROCHIP / ATMEL ISI DRIVER
> +M:	Wenyou Yang <wenyou.yang@microchip.com>
> +L:	linux-media@vger.kernel.org
> +S:	Supported
> +F:	drivers/media/platform/atmel/atmel-isi.c
> +F:	include/media/atmel-isi.h
> +F:	Documentation/devicetree/bindings/media/atmel-isi.txt
>  
>  MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER
>  M:	Woojung Huh <Woojung.Huh@microchip.com>
> -- 
> 2.9.0
> 
