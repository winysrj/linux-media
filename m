Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53244 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbZLCGkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 01:40:03 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 3 Dec 2009 12:10:02 +0530
Subject: RE: [PATCH - v0 2/2] DaVinci - vpfe capture - Make clocks
 configurable
Message-ID: <19F8576C6E063C45BE387C64729E7394043716B186@dbde02.ent.ti.com>
References: <1259687940-31435-1-git-send-email-m-karicheri2@ti.com>
 <1259687940-31435-2-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1259687940-31435-2-git-send-email-m-karicheri2@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Karicheri, Muralidharan
> Sent: Tuesday, December 01, 2009 10:49 PM
> To: linux-media@vger.kernel.org; hverkuil@xs4all.nl;
> khilman@deeprootsystems.com
> Cc: davinci-linux-open-source@linux.davincidsp.com; Hiremath,
> Vaibhav; Karicheri, Muralidharan
> Subject: [PATCH - v0 2/2] DaVinci - vpfe capture - Make clocks
> configurable
> 
> From: Muralidharan Karicheri <m-karicheri2@ti.com>
> 
> Adding the clocks in vpfe capture configuration
> 
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
>  arch/arm/mach-davinci/board-dm355-evm.c  |    2 ++
>  arch/arm/mach-davinci/board-dm644x-evm.c |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-dm355-evm.c
> b/arch/arm/mach-davinci/board-dm355-evm.c
> index a9b650d..a28985c 100644
> --- a/arch/arm/mach-davinci/board-dm355-evm.c
> +++ b/arch/arm/mach-davinci/board-dm355-evm.c
> @@ -239,6 +239,8 @@ static struct vpfe_config vpfe_cfg = {
>  	.sub_devs = vpfe_sub_devs,
>  	.card_name = "DM355 EVM",
>  	.ccdc = "DM355 CCDC",
> +	.num_clocks = 2,
> +	.clocks = {"vpss_master", "vpss_slave"},
[Hiremath, Vaibhav] Hi Murali,

I was talking to Sekhar about this and actually he made some good points about this implementation. 

If we consider specific IP, then the required clocks would remain always be the same. There might be some devices which may not be using some clocks (so as that specific feature).

Actually we are trying to create one more wrapper for clock configuration. Just to illustrate I am putting some other generic drivers examples - 

Omap-hsmmc.c - 

This driver requires 2 clocks, interface and functional. The devices which would be using this driver have to define clock with names "ick" and "fck".

VPFE-Capture (Considering only current implementation) - 

Currently we have vpfe_capture.c file (master/bridge driver) which is handling clk_get/put, and platform data is providing the details about it. 
Ideally we should handle it in respective ccdc driver file, since he has all the knowledge about required number of clocks and its name. This way we don't have to maintain/pass clock information in platform data.

I would appreciate any comments/thoughts/pointers here.

Thanks,
Vaibhav

>  };
> 
>  static struct platform_device *davinci_evm_devices[] __initdata = {
> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c
> b/arch/arm/mach-davinci/board-dm644x-evm.c
> index fd0398b..45beb99 100644
> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
> @@ -250,6 +250,8 @@ static struct vpfe_config vpfe_cfg = {
>  	.sub_devs = vpfe_sub_devs,
>  	.card_name = "DM6446 EVM",
>  	.ccdc = "DM6446 CCDC",
> +	.num_clocks = 2,
> +	.clocks = {"vpss_master", "vpss_slave"},
>  };
> 
>  static struct platform_device rtc_dev = {
> --
> 1.6.0.4

