Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:54674 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622Ab1LBWpk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Dec 2011 17:45:40 -0500
From: Kevin Hilman <khilman@ti.com>
To: Sergio Aguirre <saaguirre@ti.com>
Cc: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<laurent.pinchart@ideasonboard.com>, <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 05/11] OMAP4: Add base addresses for ISS
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
	<1322698500-29924-6-git-send-email-saaguirre@ti.com>
Date: Fri, 02 Dec 2011 14:45:38 -0800
In-Reply-To: <1322698500-29924-6-git-send-email-saaguirre@ti.com> (Sergio
	Aguirre's message of "Wed, 30 Nov 2011 18:14:54 -0600")
Message-ID: <87wraelhil.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sergio Aguirre <saaguirre@ti.com> writes:

> NOTE: This isn't the whole list of features that the
> ISS supports, but the only ones supported at the moment.
>
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>

[...]

> diff --git a/arch/arm/plat-omap/include/plat/omap44xx.h b/arch/arm/plat-omap/include/plat/omap44xx.h
> index ea2b8a6..31432aa 100644
> --- a/arch/arm/plat-omap/include/plat/omap44xx.h
> +++ b/arch/arm/plat-omap/include/plat/omap44xx.h
> @@ -49,6 +49,15 @@
>  #define OMAP44XX_MAILBOX_BASE		(L4_44XX_BASE + 0xF4000)
>  #define OMAP44XX_HSUSB_OTG_BASE		(L4_44XX_BASE + 0xAB000)
>  
> +#define OMAP44XX_ISS_BASE			0x52000000
> +#define OMAP44XX_ISS_TOP_BASE			(OMAP44XX_ISS_BASE + 0x0)
> +#define OMAP44XX_ISS_CSI2_A_REGS1_BASE		(OMAP44XX_ISS_BASE + 0x1000)
> +#define OMAP44XX_ISS_CAMERARX_CORE1_BASE	(OMAP44XX_ISS_BASE + 0x1170)
> +
> +#define OMAP44XX_ISS_TOP_END			(OMAP44XX_ISS_TOP_BASE + 256 - 1)
> +#define OMAP44XX_ISS_CSI2_A_REGS1_END		(OMAP44XX_ISS_CSI2_A_REGS1_BASE + 368 - 1)
> +#define OMAP44XX_ISS_CAMERARX_CORE1_END		(OMAP44XX_ISS_CAMERARX_CORE1_BASE + 32 - 1)
> +
>  #define OMAP4_MMU1_BASE			0x55082000
>  #define OMAP4_MMU2_BASE			0x4A066000

Who are the users of thes address ranges?

IMO, we shouldn't ned to add anymore based address definitions.  These
should be done in the hwmod data, and drivers get base addresses using
the standard ways of getting resources (DT or platform_get_resource())

Kevin
