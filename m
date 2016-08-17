Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:8725 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbcHQNlp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 09:41:45 -0400
Subject: Re: [PATCH v10 3/3] MAINTAINERS: atmel-isc: add entry for Atmel ISC
To: Songjun Wu <songjun.wu@microchip.com>, <robh@kernel.org>
References: <1471413929-26008-1-git-send-email-songjun.wu@microchip.com>
 <1471413929-26008-4-git-send-email-songjun.wu@microchip.com>
CC: <linux-arm-kernel@lists.infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<linux-kernel@vger.kernel.org>,
	"Geert Uytterhoeven" <geert@linux-m68k.org>,
	<laurent.pinchart@ideasonboard.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Guenter Roeck <linux@roeck-us.net>,
	<linux-media@vger.kernel.org>
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Message-ID: <1400f664-09d5-98f6-e237-b5b1c5edae1d@atmel.com>
Date: Wed, 17 Aug 2016 06:41:12 -0700
MIME-Version: 1.0
In-Reply-To: <1471413929-26008-4-git-send-email-songjun.wu@microchip.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 16/08/2016 à 23:05, Songjun Wu a écrit :
> Add the MAINTAINERS' entry for Microchip / Atmel Image Sensor Controller.
> 
> Signed-off-by: Songjun Wu <songjun.wu@microchip.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> 
> Changes in v10: None
> Changes in v9: None
> Changes in v8: None
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 20bb1d0..21a6f6f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7733,6 +7733,14 @@ T:	git git://git.monstr.eu/linux-2.6-microblaze.git
>  S:	Supported
>  F:	arch/microblaze/
>  
> +MICROCHIP / ATMEL ISC DRIVER
> +M:	Songjun Wu <songjun.wu@microchip.com>
> +L:	linux-media@vger.kernel.org
> +S:	Supported
> +F:	drivers/media/platform/atmel/atmel-isc.c
> +F:	drivers/media/platform/atmel/atmel-isc-regs.h
> +F:	devicetree/bindings/media/atmel-isc.txt
> +
>  MICROSOFT SURFACE PRO 3 BUTTON DRIVER
>  M:	Chen Yu <yu.c.chen@intel.com>
>  L:	platform-driver-x86@vger.kernel.org
> 


-- 
Nicolas Ferre
