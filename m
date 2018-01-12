Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:1667 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933994AbeALQfU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 11:35:20 -0500
Subject: Re: [PATCH 1/2] MAINTAINERS: linux-media: update Microchip ISI and
 ISC entries
To: <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Ludovic Desroches <ludovic.desroches@microchip.com>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-mtd@lists.infradead.org>, Josh Wu <rainyfeeling@outlook.com>
References: <eb6b3cbe8e48faee7e88eca0649e42cbde91ffa6.1515503733.git.nicolas.ferre@microchip.com>
From: Nicolas Ferre <nicolas.ferre@microchip.com>
Message-ID: <701274f4-8006-132b-37ee-22cb374c6f62@microchip.com>
Date: Fri, 12 Jan 2018 17:35:32 +0100
MIME-Version: 1.0
In-Reply-To: <eb6b3cbe8e48faee7e88eca0649e42cbde91ffa6.1515503733.git.nicolas.ferre@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/01/2018 at 14:46, Nicolas Ferre wrote:
> These two image capture interface drivers are now handled
> by Wenyou Yang.
> I benefit from this change to update the two entries by correcting the
> binding documentation link for ISC and moving the ISI to the new
> MICROCHIP / ATMEL location.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> ---
> Hi,
> 
> Patch against next-20180109.
> Note that I didn't find it useful to have several patches for these changes.
> Tell me if you feel differently.
> 
> I would like to have the Ack from Ludovic and Wenyou obviously. I don't know if
> Songjun can answer as he's not with Microchip anymore.

Update on this patch:

Boris took the second patch of the series through NAND/MTD tree so this
one can go alone upstream through the linux-media tree.
I also have the 2 required Ack.

So, do you want me to re-send this one independently or should we wait
for 4.16-rc1?

Best regards,
  Nicolas

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
> 


-- 
Nicolas Ferre
