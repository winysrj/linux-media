Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39706 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab2GFRrL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 13:47:11 -0400
Date: Fri, 6 Jul 2012 18:47:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, fabio.estevam@freescale.com,
	sakari.ailus@maxwell.research.nokia.com, kernel@pengutronix.de,
	arnaud.patard@rtp-net.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, p.zabel@pengutronix.de,
	shawn.guo@linaro.org, linux-arm-kernel@lists.infradead.org,
	richard.zhu@linaro.org
Subject: Re: [PATCH 3/3] Visstrim M10: Add support for Coda.
Message-ID: <20120706174700.GD31508@n2100.arm.linux.org.uk>
References: <1341579471-25208-1-git-send-email-javier.martin@vista-silicon.com> <1341579471-25208-4-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341579471-25208-4-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 06, 2012 at 02:57:51PM +0200, Javier Martin wrote:
> Support the codadx6 that is included in
> the i.MX27 SoC.
> ---
>  arch/arm/mach-imx/mach-imx27_visstrim_m10.c |   24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> index f76edb9..bee2714 100644
> --- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> +++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> @@ -232,10 +232,10 @@ static void __init visstrim_camera_init(void)
>  static void __init visstrim_reserve(void)
>  {
>  	/* reserve 4 MiB for mx2-camera */
> -	mx2_camera_base = memblock_alloc(MX2_CAMERA_BUF_SIZE,
> +	mx2_camera_base = memblock_alloc(2 * MX2_CAMERA_BUF_SIZE,
>  			MX2_CAMERA_BUF_SIZE);
> -	memblock_free(mx2_camera_base, MX2_CAMERA_BUF_SIZE);
> -	memblock_remove(mx2_camera_base, MX2_CAMERA_BUF_SIZE);
> +	memblock_free(mx2_camera_base, 2 * MX2_CAMERA_BUF_SIZE);
> +	memblock_remove(mx2_camera_base, 2 * MX2_CAMERA_BUF_SIZE);

NAK.  If you're going to do this please move it to the right API:

 arch/arm/mach-imx/mach-imx27_visstrim_m10.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index f7b074f..c27058e 100644
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
@@ -32,12 +32,12 @@
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/leds.h>
-#include <linux/memblock.h>
 #include <media/soc_camera.h>
 #include <sound/tlv320aic32x4.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
+#include <asm/memblock.h>
 #include <mach/common.h>
 #include <mach/iomux-mx27.h>
 
@@ -193,10 +193,8 @@ static void __init visstrim_camera_init(void)
 static void __init visstrim_reserve(void)
 {
 	/* reserve 4 MiB for mx2-camera */
-	mx2_camera_base = memblock_alloc(MX2_CAMERA_BUF_SIZE,
+	mx2_camera_base = memblock_steal(MX2_CAMERA_BUF_SIZE,
 			MX2_CAMERA_BUF_SIZE);
-	memblock_free(mx2_camera_base, MX2_CAMERA_BUF_SIZE);
-	memblock_remove(mx2_camera_base, MX2_CAMERA_BUF_SIZE);
 }
 
 /* GPIOs used as events for applications */

