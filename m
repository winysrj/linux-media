Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36809 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933771AbbENV50 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 17:57:26 -0400
Date: Thu, 14 May 2015 18:57:10 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Kishon Vijay Abraham I <kishon@ti.com>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Tony Prisk <linux@prisktech.co.nz>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Paul Bolle <pebolle@tiscali.nl>,
	Thomas Pugliese <thomas.pugliese@gmail.com>,
	"Srinivas Kandagatla" <srinivas.kandagatla@linaro.org>,
	Masanari Iida <standby24x7@gmail.com>,
	David Mosberger <davidm@egauge.net>,
	Peter Griffin <peter.griffin@linaro.org>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kevin Hao <haokexin@gmail.com>,
	"Jean Delvare" <jdelvare@suse.de>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	<linux-fbdev@vger.kernel.org>, Dmitry Torokhov <dtor@google.com>,
	Anatol Pomazau <anatol@google.com>,
	Jonathan Richardson <jonathar@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Ray Jui <rjui@broadcom.com>,
	<bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCHv3 1/4] phy: phy-core: Make GENERIC_PHY an invisible
 option
Message-ID: <20150514185710.2f8889a3@recife.lan>
In-Reply-To: <1429743853-10254-2-git-send-email-arun.ramamurthy@broadcom.com>
References: <1429743853-10254-1-git-send-email-arun.ramamurthy@broadcom.com>
	<1429743853-10254-2-git-send-email-arun.ramamurthy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 22 Apr 2015 16:04:10 -0700
Arun Ramamurthy <arun.ramamurthy@broadcom.com> escreveu:

> Most of the phy providers use "select" to enable GENERIC_PHY. Since select
> is only recommended when the config is not visible, GENERIC_PHY is changed
> an invisible option. To maintain consistency, all phy providers are changed
> to "select" GENERIC_PHY and all non-phy drivers use "depends on" when the
> phy framework is explicity required. USB_MUSB_OMAP2PLUS has a cyclic
> dependency, so it is left as "select".
> 
> Signed-off-by: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
> ---
>  drivers/ata/Kconfig                       | 1 -

>  drivers/media/platform/exynos4-is/Kconfig | 2 +-
For media part:
	Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

>  drivers/phy/Kconfig                       | 4 ++--
>  drivers/usb/host/Kconfig                  | 4 ++--
>  drivers/video/fbdev/exynos/Kconfig        | 2 +-
>  5 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index 5f60155..6d2e881 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -301,7 +301,6 @@ config SATA_MV
>  	tristate "Marvell SATA support"
>  	depends on PCI || ARCH_DOVE || ARCH_MV78XX0 || \
>  		   ARCH_MVEBU || ARCH_ORION5X || COMPILE_TEST
> -	select GENERIC_PHY
>  	help
>  	  This option enables support for the Marvell Serial ATA family.
>  	  Currently supports 88SX[56]0[48][01] PCI(-X) chips,
> diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
> index b7b2e47..b6f3eaa 100644
> --- a/drivers/media/platform/exynos4-is/Kconfig
> +++ b/drivers/media/platform/exynos4-is/Kconfig
> @@ -31,7 +31,7 @@ config VIDEO_S5P_FIMC
>  config VIDEO_S5P_MIPI_CSIS
>  	tristate "S5P/EXYNOS MIPI-CSI2 receiver (MIPI-CSIS) driver"
>  	depends on REGULATOR
> -	select GENERIC_PHY
> +	depends on GENERIC_PHY
>  	help
>  	  This is a V4L2 driver for Samsung S5P and EXYNOS4 SoC MIPI-CSI2
>  	  receiver (MIPI-CSIS) devices.
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 2962de2..edecdb1 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -5,7 +5,7 @@
>  menu "PHY Subsystem"
>  
>  config GENERIC_PHY
> -	bool "PHY Core"
> +	bool
>  	help
>  	  Generic PHY support.
>  
> @@ -72,7 +72,7 @@ config PHY_MIPHY365X
>  config PHY_RCAR_GEN2
>  	tristate "Renesas R-Car generation 2 USB PHY driver"
>  	depends on ARCH_SHMOBILE
> -	depends on GENERIC_PHY
> +	select GENERIC_PHY
>  	help
>  	  Support for USB PHY found on Renesas R-Car generation 2 SoCs.
>  
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 5ad60e4..e2197e2 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -182,7 +182,7 @@ config USB_EHCI_HCD_SPEAR
>  config USB_EHCI_HCD_STI
>  	tristate "Support for ST STiHxxx on-chip EHCI USB controller"
>  	depends on ARCH_STI && OF
> -	select GENERIC_PHY
> +	depends on GENERIC_PHY
>  	select USB_EHCI_HCD_PLATFORM
>  	help
>  	  Enable support for the on-chip EHCI controller found on
> @@ -409,7 +409,7 @@ config USB_OHCI_HCD_SPEAR
>  config USB_OHCI_HCD_STI
>  	tristate "Support for ST STiHxxx on-chip OHCI USB controller"
>  	depends on ARCH_STI && OF
> -	select GENERIC_PHY
> +	depends on GENERIC_PHY
>  	select USB_OHCI_HCD_PLATFORM
>  	help
>  	  Enable support for the on-chip OHCI controller found on
> diff --git a/drivers/video/fbdev/exynos/Kconfig b/drivers/video/fbdev/exynos/Kconfig
> index 1f16b46..6c53894 100644
> --- a/drivers/video/fbdev/exynos/Kconfig
> +++ b/drivers/video/fbdev/exynos/Kconfig
> @@ -16,7 +16,7 @@ if EXYNOS_VIDEO
>  
>  config EXYNOS_MIPI_DSI
>  	bool "EXYNOS MIPI DSI driver support."
> -	select GENERIC_PHY
> +	depends on GENERIC_PHY
>  	help
>  	  This enables support for MIPI-DSI device.
>  
