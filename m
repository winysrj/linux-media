Return-path: <mchehab@pedra>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:40329 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753831Ab1BNMgE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:36:04 -0500
Date: Mon, 14 Feb 2011 14:35:59 +0200
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH v6 04/10] omap2: Fix camera resources for multiomap
Message-ID: <20110214123559.GY2549@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1297686097-9804-5-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297686097-9804-5-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Mon, Feb 14, 2011 at 01:21:31PM +0100, Laurent Pinchart wrote:
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index 4cf48ea..5d844bd 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -38,7 +38,7 @@
>  
>  #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
>  
> -static struct resource cam_resources[] = {
> +static struct resource omap2cam_resources[] = {

should this be __initdata ??

> @@ -158,6 +149,14 @@ int omap3_init_camera(void *pdata)
>  }
>  EXPORT_SYMBOL_GPL(omap3_init_camera);
>  
> +static inline void omap_init_camera(void)

why inline ? also, should this be marked __init ?

-- 
balbi
