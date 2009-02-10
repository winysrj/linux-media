Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41871 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbZBJMLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 07:11:33 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Shah, Hardik" <hardik.shah@ti.com>
Date: Tue, 10 Feb 2009 17:41:23 +0530
Subject: RE: [PATCH 1/2] Pad configuration for OMAP3EVM Multi-Media Daughter
 Card Support
Message-ID: <19F8576C6E063C45BE387C64729E739403FA81B81F@dbde02.ent.ti.com>
In-Reply-To: <1233256950-26704-1-git-send-email-hvaibhav@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Hiremath, Vaibhav
> Sent: Friday, January 30, 2009 12:52 AM
> To: linux-omap@vger.kernel.org
> Cc: linux-media@vger.kernel.org; Hiremath, Vaibhav; Jadav, Brijesh
> R; Shah, Hardik
> Subject: [PATCH 1/2] Pad configuration for OMAP3EVM Multi-Media
> Daughter Card Support
> 
> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> On OMAP3EVM Mass Market Daugher Card following GPIO pins are being
> used -
> 
> GPIO134 --> Enable/Disable TVP5146 interface
> GPIO54 --> Enable/Disable Expansion Camera interface
> GPIO136 --> Enable/Disable Camera (Sensor) interface
> 
> Added entry for the above GPIO's in mux.c and mux.h file
> 
> Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> Signed-off-by: Hardik Shah <hardik.shah@ti.com>
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  arch/arm/mach-omap2/mux.c             |    6 ++++++
>  arch/arm/plat-omap/include/mach/mux.h |    5 ++++-
>  2 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
> index 1556688..d226d81 100644
> --- a/arch/arm/mach-omap2/mux.c
> +++ b/arch/arm/mach-omap2/mux.c
> @@ -471,6 +471,12 @@ MUX_CFG_34XX("AF5_34XX_GPIO142", 0x170,
>  		OMAP34XX_MUX_MODE4 | OMAP34XX_PIN_OUTPUT)
>  MUX_CFG_34XX("AE5_34XX_GPIO143", 0x172,
>  		OMAP34XX_MUX_MODE4 | OMAP34XX_PIN_OUTPUT)
> +MUX_CFG_34XX("AG4_34XX_GPIO134", 0x160,
> +		OMAP34XX_MUX_MODE4 | OMAP34XX_PIN_OUTPUT)
> +MUX_CFG_34XX("U8_34XX_GPIO54", 0x0b4,
> +		OMAP34XX_MUX_MODE4 | OMAP34XX_PIN_OUTPUT)
> +MUX_CFG_34XX("AE4_34XX_GPIO136", 0x164,
> +		OMAP34XX_MUX_MODE4 | OMAP34XX_PIN_OUTPUT)
> 
>  };
> 
> diff --git a/arch/arm/plat-omap/include/mach/mux.h b/arch/arm/plat-
> omap/include/mach/mux.h
> index 67fddec..ace037f 100644
> --- a/arch/arm/plat-omap/include/mach/mux.h
> +++ b/arch/arm/plat-omap/include/mach/mux.h
> @@ -795,7 +795,10 @@ enum omap34xx_index {
>  	AF6_34XX_GPIO140_UP,
>  	AE6_34XX_GPIO141,
>  	AF5_34XX_GPIO142,
> -	AE5_34XX_GPIO143
> +	AE5_34XX_GPIO143,
> +	AG4_34XX_GPIO134,
> +	U8_34XX_GPIO54,
> +	AE4_34XX_GPIO136,
>  };
> 
[Hiremath, Vaibhav] If there are no review comments on this then probably this patch should go through, since this is independent and being used with Multi-Media Daughter card support.

>  struct omap_mux_cfg {
> --
> 1.5.6

