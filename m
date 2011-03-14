Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:57186 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab1CNQDC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 12:03:02 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	"Nori, Sekhar" <nsekhar@ti.com>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 14 Mar 2011 21:32:38 +0530
Subject: RE: [PATCH 1/7] davinci: move DM64XX_VDD3P3V_PWDN to devices.c
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF729@dbde02.ent.ti.com>
In-Reply-To: <1300110918-15928-1-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Please ignore this platform patch series. I will repost it with the core driver patch series as well.

Thx,
-Manju


On Mon, Mar 14, 2011 at 19:25:18, Hadli, Manjunath wrote:
> Move the definition of DM64XX_VDD3P3V_PWDN from hardware.h to devices.c since it is used only there.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> ---
>  arch/arm/mach-davinci/devices.c               |    1 +
>  arch/arm/mach-davinci/include/mach/hardware.h |    3 ---
>  2 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c index 22ebc64..d3b2040 100644
> --- a/arch/arm/mach-davinci/devices.c
> +++ b/arch/arm/mach-davinci/devices.c
> @@ -182,6 +182,7 @@ static struct platform_device davinci_mmcsd1_device = {
>  	.resource = mmcsd1_resources,
>  };
>  
> +#define DM64XX_VDD3P3V_PWDN     0x48
>  
>  void __init davinci_setup_mmc(int module, struct davinci_mmc_config *config)  { diff --git a/arch/arm/mach-davinci/include/mach/hardware.h b/arch/arm/mach-davinci/include/mach/hardware.h
> index c45ba1f..414e0b9 100644
> --- a/arch/arm/mach-davinci/include/mach/hardware.h
> +++ b/arch/arm/mach-davinci/include/mach/hardware.h
> @@ -21,9 +21,6 @@
>   */
>  #define DAVINCI_SYSTEM_MODULE_BASE        0x01C40000
>  
> -/* System control register offsets */
> -#define DM64XX_VDD3P3V_PWDN	0x48
> -
>  /*
>   * I/O mapping
>   */
> --
> 1.6.2.4
> 
> 

