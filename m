Return-path: <mchehab@gaivota>
Received: from casper.infradead.org ([85.118.1.10]:49553 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab0LVKp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 05:45:29 -0500
Message-ID: <4D11D6BF.4010305@infradead.org>
Date: Wed, 22 Dec 2010 08:45:19 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-media <linux-media@vger.kernel.org>,
	Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: DVB/V4L: Fix Kconfig select/depend conflicts
References: <1291486169.8025.63.camel@localhost>
In-Reply-To: <1291486169.8025.63.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 04-12-2010 16:09, Ben Hutchings escreveu:
> The selection of 'helper' drivers for peripheral chips can be done
> either automatically by the config entry for the controller chip in a
> device (default if !EMBEDDED) or manually if the user knows exactly
> which peripheral chips are used.
> 
> The config entries for these helper drivers are completely hidden if
> automatic selection is enabled.  However, the way that this is
> currently done results in a config dependency on manual selection, so
> Kconfig now warns of symbols being auto-selected without their
> dependencies being met.
> 
> This changes all those config entries so that only their visibility
> depends on manual selection being enabled.  It also necessarily
> removes some explicit menus, since explicit menus always result in a
> config dependency.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> 
> ---
> Mauro, please try to get this included in 2.6.37.  Now that Kconfig
> warns about such conflicts, it results in an enormous amount of noise in
> an all-modules config.

Hi Ben,

Thanks for the patch, but, due to the "if visible" option added at 
Kconfig, this patch became obsolete.

I like more the approach that hides the menu, instead of having to add a
per-symbol "prompt if" logic, as:
	1) a "prompt if" approach adds an extra complexity to 
	   something that is already too complex;
	2) opening a blank menu with all items hidden is a bad thing.
	   the better is to just hide the entire menu, if everything
	   there is disabled.

Thanks,
Mauro

> 
> Ben.
> 
>  drivers/media/common/tuners/Kconfig |   61 ++++++----
>  drivers/media/dvb/frontends/Kconfig |  245 ++++++++++++++++++++++-------------
>  drivers/media/video/Kconfig         |  138 +++++++++++++-------
>  drivers/media/video/cx25840/Kconfig |    3 +-
>  4 files changed, 287 insertions(+), 160 deletions(-)
> 
> diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
> index 2385e6c..adac6cf 100644
> --- a/drivers/media/common/tuners/Kconfig
> +++ b/drivers/media/common/tuners/Kconfig
> @@ -44,10 +44,9 @@ menuconfig MEDIA_TUNER_CUSTOMISE
>  
>  	  If unsure say N.
>  
> -if MEDIA_TUNER_CUSTOMISE
> -
>  config MEDIA_TUNER_SIMPLE
> -	tristate "Simple tuner support"
> +	tristate
> +	prompt "Simple tuner support" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	select MEDIA_TUNER_TDA9887
>  	default m if MEDIA_TUNER_CUSTOMISE
> @@ -55,7 +54,8 @@ config MEDIA_TUNER_SIMPLE
>  	  Say Y here to include support for various simple tuners.
>  
>  config MEDIA_TUNER_TDA8290
> -	tristate "TDA 8290/8295 + 8275(a)/18271 tuner combo"
> +	tristate
> +	prompt "TDA 8290/8295 + 8275(a)/18271 tuner combo" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	select MEDIA_TUNER_TDA827X
>  	select MEDIA_TUNER_TDA18271
> @@ -64,21 +64,24 @@ config MEDIA_TUNER_TDA8290
>  	  Say Y here to include support for Philips TDA8290+8275(a) tuner.
>  
>  config MEDIA_TUNER_TDA827X
> -	tristate "Philips TDA827X silicon tuner"
> +	tristate
> +	prompt "Philips TDA827X silicon tuner" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
>  	  A DVB-T silicon tuner module. Say Y when you want to support this tuner.
>  
>  config MEDIA_TUNER_TDA18271
> -	tristate "NXP TDA18271 silicon tuner"
> +	tristate
> +	prompt "NXP TDA18271 silicon tuner" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
>  	  A silicon tuner module. Say Y when you want to support this tuner.
>  
>  config MEDIA_TUNER_TDA9887
> -	tristate "TDA 9885/6/7 analog IF demodulator"
> +	tristate
> +	prompt "TDA 9885/6/7 analog IF demodulator" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
> @@ -86,7 +89,8 @@ config MEDIA_TUNER_TDA9887
>  	  analog IF demodulator.
>  
>  config MEDIA_TUNER_TEA5761
> -	tristate "TEA 5761 radio tuner (EXPERIMENTAL)"
> +	tristate
> +	prompt "TEA 5761 radio tuner (EXPERIMENTAL)" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	depends on EXPERIMENTAL
>  	default m if MEDIA_TUNER_CUSTOMISE
> @@ -94,56 +98,64 @@ config MEDIA_TUNER_TEA5761
>  	  Say Y here to include support for the Philips TEA5761 radio tuner.
>  
>  config MEDIA_TUNER_TEA5767
> -	tristate "TEA 5767 radio tuner"
> +	tristate
> +	prompt "TEA 5767 radio tuner" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
>  	  Say Y here to include support for the Philips TEA5767 radio tuner.
>  
>  config MEDIA_TUNER_MT20XX
> -	tristate "Microtune 2032 / 2050 tuners"
> +	tristate
> +	prompt "Microtune 2032 / 2050 tuners" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
>  	  Say Y here to include support for the MT2032 / MT2050 tuner.
>  
>  config MEDIA_TUNER_MT2060
> -	tristate "Microtune MT2060 silicon IF tuner"
> +	tristate
> +	prompt "Microtune MT2060 silicon IF tuner" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
>  	  A driver for the silicon IF tuner MT2060 from Microtune.
>  
>  config MEDIA_TUNER_MT2266
> -	tristate "Microtune MT2266 silicon tuner"
> +	tristate
> +	prompt "Microtune MT2266 silicon tuner" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
>  	  A driver for the silicon baseband tuner MT2266 from Microtune.
>  
>  config MEDIA_TUNER_MT2131
> -	tristate "Microtune MT2131 silicon tuner"
> +	tristate
> +	prompt "Microtune MT2131 silicon tuner" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
>  	  A driver for the silicon baseband tuner MT2131 from Microtune.
>  
>  config MEDIA_TUNER_QT1010
> -	tristate "Quantek QT1010 silicon tuner"
> +	tristate
> +	prompt "Quantek QT1010 silicon tuner" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
>  	  A driver for the silicon tuner QT1010 from Quantek.
>  
>  config MEDIA_TUNER_XC2028
> -	tristate "XCeive xc2028/xc3028 tuners"
> +	tristate
> +	prompt "XCeive xc2028/xc3028 tuners" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
>  	  Say Y here to include support for the xc2028/xc3028 tuners.
>  
>  config MEDIA_TUNER_XC5000
> -	tristate "Xceive XC5000 silicon tuner"
> +	tristate
> +	prompt "Xceive XC5000 silicon tuner" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
> @@ -152,38 +164,41 @@ config MEDIA_TUNER_XC5000
>  	  demodulator for now.
>  
>  config MEDIA_TUNER_MXL5005S
> -	tristate "MaxLinear MSL5005S silicon tuner"
> +	tristate
> +	prompt "MaxLinear MSL5005S silicon tuner" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
>  	  A driver for the silicon tuner MXL5005S from MaxLinear.
>  
>  config MEDIA_TUNER_MXL5007T
> -	tristate "MaxLinear MxL5007T silicon tuner"
> +	tristate
> +	prompt "MaxLinear MxL5007T silicon tuner" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
>  	  A driver for the silicon tuner MxL5007T from MaxLinear.
>  
>  config MEDIA_TUNER_MC44S803
> -	tristate "Freescale MC44S803 Low Power CMOS Broadband tuners"
> +	tristate
> +	prompt "Freescale MC44S803 Low Power CMOS Broadband tuners" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
>  	  Say Y here to support the Freescale MC44S803 based tuners
>  
>  config MEDIA_TUNER_MAX2165
> -	tristate "Maxim MAX2165 silicon tuner"
> +	tristate
> +	prompt "Maxim MAX2165 silicon tuner" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
>  	  A driver for the silicon tuner MAX2165 from Maxim.
>  
>  config MEDIA_TUNER_TDA18218
> -	tristate "NXP TDA18218 silicon tuner"
> +	tristate
> +	prompt "NXP TDA18218 silicon tuner" if MEDIA_TUNER_CUSTOMISE
>  	depends on VIDEO_MEDIA && I2C
>  	default m if MEDIA_TUNER_CUSTOMISE
>  	help
>  	  NXP TDA18218 silicon tuner driver.
> -
> -endif # MEDIA_TUNER_CUSTOMISE
> diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
> index e9062b0..476836d 100644
> --- a/drivers/media/dvb/frontends/Kconfig
> +++ b/drivers/media/dvb/frontends/Kconfig
> @@ -1,4 +1,4 @@
> -config DVB_FE_CUSTOMISE
> +menuconfig DVB_FE_CUSTOMISE
>  	bool "Customise the frontend modules to build"
>  	depends on DVB_CORE
>  	default y if EMBEDDED
> @@ -12,15 +12,12 @@ config DVB_FE_CUSTOMISE
>  
>  	  If unsure say N.
>  
> -if DVB_FE_CUSTOMISE
> -
> -menu "Customise DVB Frontends"
> -
>  comment "Multistandard (satellite) frontends"
> -	depends on DVB_CORE
> +	depends on DVB_CORE && DVB_FE_CUSTOMISE
>  
>  config DVB_STB0899
> -	tristate "STB0899 based"
> +	tristate
> +	prompt "STB0899 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -28,7 +25,8 @@ config DVB_STB0899
>  	  to support this demodulator based frontends
>  
>  config DVB_STB6100
> -	tristate "STB6100 based tuners"
> +	tristate
> +	prompt "STB6100 based tuners" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -36,7 +34,8 @@ config DVB_STB6100
>  	  demodulator. Say Y when you want to support this tuner.
>  
>  config DVB_STV090x
> -	tristate "STV0900/STV0903(A/B) based"
> +	tristate
> +	prompt "STV0900/STV0903(A/B) based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -44,129 +43,147 @@ config DVB_STV090x
>  	  Say Y when you want to support these frontends.
>  
>  config DVB_STV6110x
> -	tristate "STV6110/(A) based tuners"
> +	tristate
> +	prompt "STV6110/(A) based tuners" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A Silicon tuner that supports DVB-S and DVB-S2 modes
>  
>  comment "DVB-S (satellite) frontends"
> -	depends on DVB_CORE
> +	depends on DVB_CORE && DVB_FE_CUSTOMISE
>  
>  config DVB_CX24110
> -	tristate "Conexant CX24110 based"
> +	tristate
> +	prompt "Conexant CX24110 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_CX24123
> -	tristate "Conexant CX24123 based"
> +	tristate
> +	prompt "Conexant CX24123 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_MT312
> -	tristate "Zarlink VP310/MT312/ZL10313 based"
> +	tristate
> +	prompt "Zarlink VP310/MT312/ZL10313 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_ZL10036
> -	tristate "Zarlink ZL10036 silicon tuner"
> +	tristate
> +	prompt "Zarlink ZL10036 silicon tuner" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_ZL10039
> -	tristate "Zarlink ZL10039 silicon tuner"
> +	tristate
> +	prompt "Zarlink ZL10039 silicon tuner" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_S5H1420
> -	tristate "Samsung S5H1420 based"
> +	tristate
> +	prompt "Samsung S5H1420 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_STV0288
> -	tristate "ST STV0288 based"
> +	tristate
> +	prompt "ST STV0288 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_STB6000
> -	tristate "ST STB6000 silicon tuner"
> +	tristate
> +	prompt "ST STB6000 silicon tuner" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	  help
>  	  A DVB-S silicon tuner module. Say Y when you want to support this tuner.
>  
>  config DVB_STV0299
> -	tristate "ST STV0299 based"
> +	tristate
> +	prompt "ST STV0299 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_STV6110
> -	tristate "ST STV6110 silicon tuner"
> +	tristate
> +	prompt "ST STV6110 silicon tuner" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	  help
>  	  A DVB-S silicon tuner module. Say Y when you want to support this tuner.
>  
>  config DVB_STV0900
> -	tristate "ST STV0900 based"
> +	tristate
> +	prompt "ST STV0900 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S/S2 demodulator. Say Y when you want to support this frontend.
>  
>  config DVB_TDA8083
> -	tristate "Philips TDA8083 based"
> +	tristate
> +	prompt "Philips TDA8083 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_TDA10086
> -	tristate "Philips TDA10086 based"
> +	tristate
> +	prompt "Philips TDA10086 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_TDA8261
> -	tristate "Philips TDA8261 based"
> +	tristate
> +	prompt "Philips TDA8261 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_VES1X93
> -	tristate "VLSI VES1893 or VES1993 based"
> +	tristate
> +	prompt "VLSI VES1893 or VES1993 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_TUNER_ITD1000
> -	tristate "Integrant ITD1000 Zero IF tuner for DVB-S/DSS"
> +	tristate
> +	prompt "Integrant ITD1000 Zero IF tuner for DVB-S/DSS" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_TUNER_CX24113
> -	tristate "Conexant CX24113/CX24128 tuner for DVB-S/DSS"
> +	tristate
> +	prompt "Conexant CX24113/CX24128 tuner for DVB-S/DSS" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -174,42 +191,48 @@ config DVB_TUNER_CX24113
>  
> 
>  config DVB_TDA826X
> -	tristate "Philips TDA826X silicon tuner"
> +	tristate
> +	prompt "Philips TDA826X silicon tuner" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S silicon tuner module. Say Y when you want to support this tuner.
>  
>  config DVB_TUA6100
> -	tristate "Infineon TUA6100 PLL"
> +	tristate
> +	prompt "Infineon TUA6100 PLL" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S PLL chip.
>  
>  config DVB_CX24116
> -	tristate "Conexant CX24116 based"
> +	tristate
> +	prompt "Conexant CX24116 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S/S2 tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_SI21XX
> -	tristate "Silicon Labs SI21XX based"
> +	tristate
> +	prompt "Silicon Labs SI21XX based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_DS3000
> -	tristate "Montage Tehnology DS3000 based"
> +	tristate
> +	prompt "Montage Tehnology DS3000 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S/S2 tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_MB86A16
> -	tristate "Fujitsu MB86A16 based"
> +	tristate
> +	prompt "Fujitsu MB86A16 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -217,10 +240,11 @@ config DVB_MB86A16
>  	  Say Y when you want to support this frontend.
>  
>  comment "DVB-T (terrestrial) frontends"
> -	depends on DVB_CORE
> +	depends on DVB_CORE && DVB_FE_CUSTOMISE
>  
>  config DVB_SP8870
> -	tristate "Spase sp8870 based"
> +	tristate
> +	prompt "Spase sp8870 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -232,7 +256,8 @@ config DVB_SP8870
>  	  or /lib/firmware (depending on configuration of firmware hotplug).
>  
>  config DVB_SP887X
> -	tristate "Spase sp887x based"
> +	tristate
> +	prompt "Spase sp887x based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -244,28 +269,32 @@ config DVB_SP887X
>  	  or /lib/firmware (depending on configuration of firmware hotplug).
>  
>  config DVB_CX22700
> -	tristate "Conexant CX22700 based"
> +	tristate
> +	prompt "Conexant CX22700 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-T tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_CX22702
> -	tristate "Conexant cx22702 demodulator (OFDM)"
> +	tristate
> +	prompt "Conexant cx22702 demodulator (OFDM)" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-T tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_S5H1432
> -	tristate "Samsung s5h1432 demodulator (OFDM)"
> +	tristate
> +	prompt "Samsung s5h1432 demodulator (OFDM)" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-T tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_DRX397XD
> -	tristate "Micronas DRX3975D/DRX3977D based"
> +	tristate
> +	prompt "Micronas DRX3975D/DRX3977D based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -278,14 +307,16 @@ config DVB_DRX397XD
>  	  or /lib/firmware (depending on configuration of firmware hotplug).
>  
>  config DVB_L64781
> -	tristate "LSI L64781"
> +	tristate
> +	prompt "LSI L64781" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-T tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_TDA1004X
> -	tristate "Philips TDA10045H/TDA10046H based"
> +	tristate
> +	prompt "Philips TDA10045H/TDA10046H based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -298,28 +329,32 @@ config DVB_TDA1004X
>  	  or /lib/firmware (depending on configuration of firmware hotplug).
>  
>  config DVB_NXT6000
> -	tristate "NxtWave Communications NXT6000 based"
> +	tristate
> +	prompt "NxtWave Communications NXT6000 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-T tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_MT352
> -	tristate "Zarlink MT352 based"
> +	tristate
> +	prompt "Zarlink MT352 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-T tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_ZL10353
> -	tristate "Zarlink ZL10353 based"
> +	tristate
> +	prompt "Zarlink ZL10353 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-T tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_DIB3000MB
> -	tristate "DiBcom 3000M-B"
> +	tristate
> +	prompt "DiBcom 3000M-B" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -327,7 +362,8 @@ config DVB_DIB3000MB
>  	  to support this frontend.
>  
>  config DVB_DIB3000MC
> -	tristate "DiBcom 3000P/M-C"
> +	tristate
> +	prompt "DiBcom 3000P/M-C" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -335,7 +371,8 @@ config DVB_DIB3000MC
>  	  to support this frontend.
>  
>  config DVB_DIB7000M
> -	tristate "DiBcom 7000MA/MB/PA/PB/MC"
> +	tristate
> +	prompt "DiBcom 7000MA/MB/PA/PB/MC" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -343,7 +380,8 @@ config DVB_DIB7000M
>  	  to support this frontend.
>  
>  config DVB_DIB7000P
> -	tristate "DiBcom 7000PC"
> +	tristate
> +	prompt "DiBcom 7000PC" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -351,62 +389,70 @@ config DVB_DIB7000P
>  	  to support this frontend.
>  
>  config DVB_TDA10048
> -	tristate "Philips TDA10048HN based"
> +	tristate
> +	prompt "Philips TDA10048HN based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-T tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_AF9013
> -	tristate "Afatech AF9013 demodulator"
> +	tristate
> +	prompt "Afatech AF9013 demodulator" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  Say Y when you want to support this frontend.
>  
>  config DVB_EC100
> -	tristate "E3C EC100"
> +	tristate
> +	prompt "E3C EC100" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  Say Y when you want to support this frontend.
>  
>  comment "DVB-C (cable) frontends"
> -	depends on DVB_CORE
> +	depends on DVB_CORE && DVB_FE_CUSTOMISE
>  
>  config DVB_VES1820
> -	tristate "VLSI VES1820 based"
> +	tristate
> +	prompt "VLSI VES1820 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-C tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_TDA10021
> -	tristate "Philips TDA10021 based"
> +	tristate
> +	prompt "Philips TDA10021 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-C tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_TDA10023
> -	tristate "Philips TDA10023 based"
> +	tristate
> +	prompt "Philips TDA10023 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-C tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_STV0297
> -	tristate "ST STV0297 based"
> +	tristate
> +	prompt "ST STV0297 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-C tuner module. Say Y when you want to support this frontend.
>  
>  comment "ATSC (North American/Korean Terrestrial/Cable DTV) frontends"
> -	depends on DVB_CORE
> +	depends on DVB_CORE && DVB_FE_CUSTOMISE
>  
>  config DVB_NXT200X
> -	tristate "NxtWave Communications NXT2002/NXT2004 based"
> +	tristate
> +	prompt "NxtWave Communications NXT2002/NXT2004 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -420,7 +466,8 @@ config DVB_NXT200X
>  	  or /lib/firmware (depending on configuration of firmware hotplug).
>  
>  config DVB_OR51211
> -	tristate "Oren OR51211 based"
> +	tristate
> +	prompt "Oren OR51211 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -432,7 +479,8 @@ config DVB_OR51211
>  	  or /lib/firmware (depending on configuration of firmware hotplug).
>  
>  config DVB_OR51132
> -	tristate "Oren OR51132 based"
> +	tristate
> +	prompt "Oren OR51132 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -447,7 +495,8 @@ config DVB_OR51132
>  	  configuration of firmware hotplug).
>  
>  config DVB_BCM3510
> -	tristate "Broadcom BCM3510"
> +	tristate
> +	prompt "Broadcom BCM3510" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -455,7 +504,8 @@ config DVB_BCM3510
>  	  support this frontend.
>  
>  config DVB_LGDT330X
> -	tristate "LG Electronics LGDT3302/LGDT3303 based"
> +	tristate
> +	prompt "LG Electronics LGDT3302/LGDT3303 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -463,7 +513,8 @@ config DVB_LGDT330X
>  	  to support this frontend.
>  
>  config DVB_LGDT3305
> -	tristate "LG Electronics LGDT3304 and LGDT3305 based"
> +	tristate
> +	prompt "LG Electronics LGDT3304 and LGDT3305 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -471,7 +522,8 @@ config DVB_LGDT3305
>  	  to support this frontend.
>  
>  config DVB_S5H1409
> -	tristate "Samsung S5H1409 based"
> +	tristate
> +	prompt "Samsung S5H1409 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -479,7 +531,8 @@ config DVB_S5H1409
>  	  to support this frontend.
>  
>  config DVB_AU8522
> -	tristate "Auvitek AU8522 based"
> +	tristate
> +	prompt "Auvitek AU8522 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C && VIDEO_V4L2
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -487,7 +540,8 @@ config DVB_AU8522
>  	  to support this frontend.
>  
>  config DVB_S5H1411
> -	tristate "Samsung S5H1411 based"
> +	tristate
> +	prompt "Samsung S5H1411 based" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -495,10 +549,11 @@ config DVB_S5H1411
>  	  to support this frontend.
>  
>  comment "ISDB-T (terrestrial) frontends"
> -	depends on DVB_CORE
> +	depends on DVB_CORE && DVB_FE_CUSTOMISE
>  
>  config DVB_S921
> -	tristate "Sharp S921 tuner"
> +	tristate
> +	prompt "Sharp S921 tuner" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -506,7 +561,8 @@ config DVB_S921
>  	  Say Y when you want to support this frontend.
>  
>  config DVB_DIB8000
> -	tristate "DiBcom 8000MB/MC"
> +	tristate
> +	prompt "DiBcom 8000MB/MC" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -514,10 +570,11 @@ config DVB_DIB8000
>  	  Say Y when you want to support this frontend.
>  
>  comment "Digital terrestrial only tuners/PLL"
> -	depends on DVB_CORE
> +	depends on DVB_CORE && DVB_FE_CUSTOMISE
>  
>  config DVB_PLL
> -	tristate "Generic I2C PLL based tuners"
> +	tristate
> +	prompt "Generic I2C PLL based tuners" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -525,7 +582,8 @@ config DVB_PLL
>  	  common I2C interface. Say Y when you want to support these tuners.
>  
>  config DVB_TUNER_DIB0070
> -	tristate "DiBcom DiB0070 silicon base-band tuner"
> +	tristate
> +	prompt "DiBcom DiB0070 silicon base-band tuner" if DVB_FE_CUSTOMISE
>  	depends on I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -534,7 +592,8 @@ config DVB_TUNER_DIB0070
>  	  demodulator for now.
>  
>  config DVB_TUNER_DIB0090
> -	tristate "DiBcom DiB0090 silicon base-band tuner"
> +	tristate
> +	prompt "DiBcom DiB0090 silicon base-band tuner" if DVB_FE_CUSTOMISE
>  	depends on I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -543,45 +602,51 @@ config DVB_TUNER_DIB0090
>  	  demodulator for now.
>  
>  comment "SEC control devices for DVB-S"
> -	depends on DVB_CORE
> +	depends on DVB_CORE && DVB_FE_CUSTOMISE
>  
>  config DVB_LNBP21
> -	tristate "LNBP21/LNBH24 SEC controllers"
> +	tristate
> +	prompt "LNBP21/LNBH24 SEC controllers" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  An SEC control chips.
>  
>  config DVB_ISL6405
> -	tristate "ISL6405 SEC controller"
> +	tristate
> +	prompt "ISL6405 SEC controller" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  An SEC control chip.
>  
>  config DVB_ISL6421
> -	tristate "ISL6421 SEC controller"
> +	tristate
> +	prompt "ISL6421 SEC controller" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  An SEC control chip.
>  
>  config DVB_ISL6423
> -	tristate "ISL6423 SEC controller"
> +	tristate
> +	prompt "ISL6423 SEC controller" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A SEC controller chip from Intersil
>  
>  config DVB_LGS8GL5
> -	tristate "Silicon Legend LGS-8GL5 demodulator (OFDM)"
> +	tristate
> +	prompt "Silicon Legend LGS-8GL5 demodulator (OFDM)" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DMB-TH tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_LGS8GXX
> -	tristate "Legend Silicon LGS8913/LGS8GL5/LGS8GXX DMB-TH demodulator"
> +	tristate
> +	prompt "Legend Silicon LGS8913/LGS8GL5/LGS8GXX DMB-TH demodulator" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	select FW_LOADER
>  	default m if DVB_FE_CUSTOMISE
> @@ -589,14 +654,16 @@ config DVB_LGS8GXX
>  	  A DMB-TH tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_ATBM8830
> -	tristate "AltoBeam ATBM8830/8831 DMB-TH demodulator"
> +	tristate
> +	prompt "AltoBeam ATBM8830/8831 DMB-TH demodulator" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DMB-TH tuner module. Say Y when you want to support this frontend.
>  
>  config DVB_TDA665x
> -	tristate "TDA665x tuner"
> +	tristate
> +	prompt "TDA665x tuner" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
> @@ -607,17 +674,17 @@ config DVB_TDA665x
>  	  * Panasonic ENV57H12D5 (ET-50DT)
>  
>  config DVB_IX2505V
> -	tristate "Sharp IX2505V silicon tuner"
> +	tristate
> +	prompt "Sharp IX2505V silicon tuner" if DVB_FE_CUSTOMISE
>  	depends on DVB_CORE && I2C
>  	default m if DVB_FE_CUSTOMISE
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
>  
>  comment "Tools to develop new frontends"
> +	depends on DVB_FE_CUSTOMISE
>  
>  config DVB_DUMMY_FE
> -	tristate "Dummy frontend driver"
> +	tristate
> +	prompt "Dummy frontend driver" if DVB_FE_CUSTOMISE
>  	default n
> -endmenu
> -
> -endif
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index ac16e81..ea77fae 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -95,7 +95,8 @@ config VIDEO_HELPER_CHIPS_AUTO
>  	  In doubt, say Y.
>  
>  config VIDEO_IR_I2C
> -	tristate "I2C module for IR" if !VIDEO_HELPER_CHIPS_AUTO
> +	tristate
> +	prompt "I2C module for IR" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on I2C && VIDEO_IR
>  	default y
>  	---help---
> @@ -111,13 +112,12 @@ config VIDEO_IR_I2C
>  # Encoder / Decoder module configuration
>  #
>  
> -menu "Encoders/decoders and other helper chips"
> -	depends on !VIDEO_HELPER_CHIPS_AUTO
> -
>  comment "Audio decoders"
> +	depends on !VIDEO_HELPER_CHIPS_AUTO
>  
>  config VIDEO_TVAUDIO
> -	tristate "Simple audio decoder chips"
> +	tristate
> +	prompt "Simple audio decoder chips" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for several audio decoder chips found on some bt8xx boards:
> @@ -129,7 +129,8 @@ config VIDEO_TVAUDIO
>  	  module will be called tvaudio.
>  
>  config VIDEO_TDA7432
> -	tristate "Philips TDA7432 audio processor"
> +	tristate
> +	prompt "Philips TDA7432 audio processor" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for tda7432 audio decoder chip found on some bt8xx boards.
> @@ -138,7 +139,8 @@ config VIDEO_TDA7432
>  	  module will be called tda7432.
>  
>  config VIDEO_TDA9840
> -	tristate "Philips TDA9840 audio processor"
> +	tristate
> +	prompt "Philips TDA9840 audio processor" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on I2C
>  	---help---
>  	  Support for tda9840 audio decoder chip found on some Zoran boards.
> @@ -147,7 +149,8 @@ config VIDEO_TDA9840
>  	  module will be called tda9840.
>  
>  config VIDEO_TDA9875
> -	tristate "Philips TDA9875 audio processor"
> +	tristate
> +	prompt "Philips TDA9875 audio processor" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for tda9875 audio decoder chip found on some bt8xx boards.
> @@ -156,7 +159,8 @@ config VIDEO_TDA9875
>  	  module will be called tda9875.
>  
>  config VIDEO_TEA6415C
> -	tristate "Philips TEA6415C audio processor"
> +	tristate
> +	prompt "Philips TEA6415C audio processor" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on I2C
>  	---help---
>  	  Support for tea6415c audio decoder chip found on some bt8xx boards.
> @@ -165,7 +169,8 @@ config VIDEO_TEA6415C
>  	  module will be called tea6415c.
>  
>  config VIDEO_TEA6420
> -	tristate "Philips TEA6420 audio processor"
> +	tristate
> +	prompt "Philips TEA6420 audio processor" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on I2C
>  	---help---
>  	  Support for tea6420 audio decoder chip found on some bt8xx boards.
> @@ -174,7 +179,8 @@ config VIDEO_TEA6420
>  	  module will be called tea6420.
>  
>  config VIDEO_MSP3400
> -	tristate "Micronas MSP34xx audio decoders"
> +	tristate
> +	prompt "Micronas MSP34xx audio decoders" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Micronas MSP34xx series of audio decoders.
> @@ -183,7 +189,8 @@ config VIDEO_MSP3400
>  	  module will be called msp3400.
>  
>  config VIDEO_CS5345
> -	tristate "Cirrus Logic CS5345 audio ADC"
> +	tristate
> +	prompt "Cirrus Logic CS5345 audio ADC" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Cirrus Logic CS5345 24-bit, 192 kHz
> @@ -193,7 +200,8 @@ config VIDEO_CS5345
>  	  module will be called cs5345.
>  
>  config VIDEO_CS53L32A
> -	tristate "Cirrus Logic CS53L32A audio ADC"
> +	tristate
> +	prompt "Cirrus Logic CS53L32A audio ADC" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Cirrus Logic CS53L32A low voltage
> @@ -203,7 +211,8 @@ config VIDEO_CS53L32A
>  	  module will be called cs53l32a.
>  
>  config VIDEO_M52790
> -	tristate "Mitsubishi M52790 A/V switch"
> +	tristate
> +	prompt "Mitsubishi M52790 A/V switch" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	 Support for the Mitsubishi M52790 A/V switch.
> @@ -212,7 +221,8 @@ config VIDEO_M52790
>  	 module will be called m52790.
>  
>  config VIDEO_TLV320AIC23B
> -	tristate "Texas Instruments TLV320AIC23B audio codec"
> +	tristate
> +	prompt "Texas Instruments TLV320AIC23B audio codec" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
>  	---help---
>  	  Support for the Texas Instruments TLV320AIC23B audio codec.
> @@ -221,7 +231,8 @@ config VIDEO_TLV320AIC23B
>  	  module will be called tlv320aic23b.
>  
>  config VIDEO_WM8775
> -	tristate "Wolfson Microelectronics WM8775 audio ADC with input mixer"
> +	tristate
> +	prompt "Wolfson Microelectronics WM8775 audio ADC with input mixer" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Wolfson Microelectronics WM8775 high
> @@ -231,7 +242,8 @@ config VIDEO_WM8775
>  	  module will be called wm8775.
>  
>  config VIDEO_WM8739
> -	tristate "Wolfson Microelectronics WM8739 stereo audio ADC"
> +	tristate
> +	prompt "Wolfson Microelectronics WM8739 stereo audio ADC" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Wolfson Microelectronics WM8739
> @@ -241,7 +253,8 @@ config VIDEO_WM8739
>  	  module will be called wm8739.
>  
>  config VIDEO_VP27SMPX
> -	tristate "Panasonic VP27s internal MPX"
> +	tristate
> +	prompt "Panasonic VP27s internal MPX" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the internal MPX of the Panasonic VP27s tuner.
> @@ -250,9 +263,11 @@ config VIDEO_VP27SMPX
>  	  module will be called vp27smpx.
>  
>  comment "RDS decoders"
> +	depends on !VIDEO_HELPER_CHIPS_AUTO
>  
>  config VIDEO_SAA6588
> -	tristate "SAA6588 Radio Chip RDS decoder support"
> +	tristate
> +	prompt "SAA6588 Radio Chip RDS decoder support" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  
>  	help
> @@ -264,9 +279,11 @@ config VIDEO_SAA6588
>  	  module will be called saa6588.
>  
>  comment "Video decoders"
> +	depends on !VIDEO_HELPER_CHIPS_AUTO
>  
>  config VIDEO_ADV7180
> -	tristate "Analog Devices ADV7180 decoder"
> +	tristate
> +	prompt "Analog Devices ADV7180 decoder" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Analog Devices ADV7180 video decoder.
> @@ -275,7 +292,8 @@ config VIDEO_ADV7180
>  	  module will be called adv7180.
>  
>  config VIDEO_BT819
> -	tristate "BT819A VideoStream decoder"
> +	tristate
> +	prompt "BT819A VideoStream decoder" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for BT819A video decoder.
> @@ -284,7 +302,8 @@ config VIDEO_BT819
>  	  module will be called bt819.
>  
>  config VIDEO_BT856
> -	tristate "BT856 VideoStream decoder"
> +	tristate
> +	prompt "BT856 VideoStream decoder" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for BT856 video decoder.
> @@ -293,7 +312,8 @@ config VIDEO_BT856
>  	  module will be called bt856.
>  
>  config VIDEO_BT866
> -	tristate "BT866 VideoStream decoder"
> +	tristate
> +	prompt "BT866 VideoStream decoder" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for BT866 video decoder.
> @@ -302,7 +322,8 @@ config VIDEO_BT866
>  	  module will be called bt866.
>  
>  config VIDEO_KS0127
> -	tristate "KS0127 video decoder"
> +	tristate
> +	prompt "KS0127 video decoder" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for KS0127 video decoder.
> @@ -314,7 +335,8 @@ config VIDEO_KS0127
>  	  module will be called ks0127.
>  
>  config VIDEO_OV7670
> -	tristate "OmniVision OV7670 sensor support"
> +	tristate
> +	prompt "OmniVision OV7670 sensor support" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on I2C && VIDEO_V4L2
>  	---help---
>  	  This is a Video4Linux2 sensor-level driver for the OmniVision
> @@ -322,7 +344,8 @@ config VIDEO_OV7670
>  	  controller.
>  
>  config VIDEO_MT9V011
> -	tristate "Micron mt9v011 sensor support"
> +	tristate
> +	prompt "Micron mt9v011 sensor support" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on I2C && VIDEO_V4L2
>  	---help---
>  	  This is a Video4Linux2 sensor-level driver for the Micron
> @@ -330,14 +353,16 @@ config VIDEO_MT9V011
>  	  em28xx driver.
>  
>  config VIDEO_TCM825X
> -	tristate "TCM825x camera sensor support"
> +	tristate
> +	prompt "TCM825x camera sensor support" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on I2C && VIDEO_V4L2
>  	---help---
>  	  This is a driver for the Toshiba TCM825x VGA camera sensor.
>  	  It is used for example in Nokia N800.
>  
>  config VIDEO_SAA7110
> -	tristate "Philips SAA7110 video decoder"
> +	tristate
> +	prompt "Philips SAA7110 video decoder" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Philips SAA7110 video decoders.
> @@ -346,7 +371,8 @@ config VIDEO_SAA7110
>  	  module will be called saa7110.
>  
>  config VIDEO_SAA711X
> -	tristate "Philips SAA7111/3/4/5 video decoders"
> +	tristate
> +	prompt "Philips SAA7111/3/4/5 video decoders" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Philips SAA7111/3/4/5 video decoders.
> @@ -355,7 +381,8 @@ config VIDEO_SAA711X
>  	  module will be called saa7115.
>  
>  config VIDEO_SAA717X
> -	tristate "Philips SAA7171/3/4 audio/video decoders"
> +	tristate
> +	prompt "Philips SAA7171/3/4 audio/video decoders" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Philips SAA7171/3/4 audio/video decoders.
> @@ -364,7 +391,8 @@ config VIDEO_SAA717X
>  	  module will be called saa717x.
>  
>  config VIDEO_SAA7191
> -	tristate "Philips SAA7191 video decoder"
> +	tristate
> +	prompt "Philips SAA7191 video decoder" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Philips SAA7191 video decoder.
> @@ -373,7 +401,8 @@ config VIDEO_SAA7191
>  	  module will be called saa7191.
>  
>  config VIDEO_TVP514X
> -	tristate "Texas Instruments TVP514x video decoder"
> +	tristate
> +	prompt "Texas Instruments TVP514x video decoder" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  This is a Video4Linux2 sensor-level driver for the TI TVP5146/47
> @@ -384,7 +413,8 @@ config VIDEO_TVP514X
>  	  module will be called tvp514x.
>  
>  config VIDEO_TVP5150
> -	tristate "Texas Instruments TVP5150 video decoder"
> +	tristate
> +	prompt "Texas Instruments TVP5150 video decoder" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Texas Instruments TVP5150 video decoder.
> @@ -393,7 +423,8 @@ config VIDEO_TVP5150
>  	  module will be called tvp5150.
>  
>  config VIDEO_TVP7002
> -	tristate "Texas Instruments TVP7002 video decoder"
> +	tristate
> +	prompt "Texas Instruments TVP7002 video decoder" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Texas Instruments TVP7002 video decoder.
> @@ -402,7 +433,8 @@ config VIDEO_TVP7002
>  	  module will be called tvp7002.
>  
>  config VIDEO_VPX3220
> -	tristate "vpx3220a, vpx3216b & vpx3214c video decoders"
> +	tristate
> +	prompt "vpx3220a, vpx3216b & vpx3214c video decoders" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for VPX322x video decoders.
> @@ -411,13 +443,16 @@ config VIDEO_VPX3220
>  	  module will be called vpx3220.
>  
>  comment "Video and audio decoders"
> +	depends on !VIDEO_HELPER_CHIPS_AUTO
>  
>  source "drivers/media/video/cx25840/Kconfig"
>  
>  comment "MPEG video encoders"
> +	depends on !VIDEO_HELPER_CHIPS_AUTO
>  
>  config VIDEO_CX2341X
> -	tristate "Conexant CX2341x MPEG encoders"
> +	tristate
> +	prompt "Conexant CX2341x MPEG encoders" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && VIDEO_V4L2_COMMON
>  	---help---
>  	  Support for the Conexant CX23416 MPEG encoders
> @@ -429,9 +464,11 @@ config VIDEO_CX2341X
>  	  module will be called cx2341x.
>  
>  comment "Video encoders"
> +	depends on !VIDEO_HELPER_CHIPS_AUTO
>  
>  config VIDEO_SAA7127
> -	tristate "Philips SAA7127/9 digital video encoders"
> +	tristate
> +	prompt "Philips SAA7127/9 digital video encoders" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Philips SAA7127/9 digital video encoders.
> @@ -440,7 +477,8 @@ config VIDEO_SAA7127
>  	  module will be called saa7127.
>  
>  config VIDEO_SAA7185
> -	tristate "Philips SAA7185 video encoder"
> +	tristate
> +	prompt "Philips SAA7185 video encoder" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Philips SAA7185 video encoder.
> @@ -449,7 +487,8 @@ config VIDEO_SAA7185
>  	  module will be called saa7185.
>  
>  config VIDEO_ADV7170
> -	tristate "Analog Devices ADV7170 video encoder"
> +	tristate
> +	prompt "Analog Devices ADV7170 video encoder" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Analog Devices ADV7170 video encoder driver
> @@ -458,7 +497,8 @@ config VIDEO_ADV7170
>  	  module will be called adv7170.
>  
>  config VIDEO_ADV7175
> -	tristate "Analog Devices ADV7175 video encoder"
> +	tristate
> +	prompt "Analog Devices ADV7175 video encoder" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Analog Devices ADV7175 video encoder driver
> @@ -467,7 +507,8 @@ config VIDEO_ADV7175
>  	  module will be called adv7175.
>  
>  config VIDEO_THS7303
> -	tristate "THS7303 Video Amplifier"
> +	tristate
> +	prompt "THS7303 Video Amplifier" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on I2C
>  	help
>  	  Support for TI THS7303 video amplifier
> @@ -476,7 +517,8 @@ config VIDEO_THS7303
>  	  module will be called ths7303.
>  
>  config VIDEO_ADV7343
> -	tristate "ADV7343 video encoder"
> +	tristate
> +	prompt "ADV7343 video encoder" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on I2C
>  	help
>  	  Support for Analog Devices I2C bus based ADV7343 encoder.
> @@ -485,15 +527,18 @@ config VIDEO_ADV7343
>  	  module will be called adv7343.
>  
>  config VIDEO_AK881X
> -	tristate "AK8813/AK8814 video encoders"
> +	tristate
> +	prompt "AK8813/AK8814 video encoders" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on I2C
>  	help
>  	  Video output driver for AKM AK8813 and AK8814 TV encoders
>  
>  comment "Video improvement chips"
> +	depends on !VIDEO_HELPER_CHIPS_AUTO
>  
>  config VIDEO_UPD64031A
> -	tristate "NEC Electronics uPD64031A Ghost Reduction"
> +	tristate
> +	prompt "NEC Electronics uPD64031A Ghost Reduction" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the NEC Electronics uPD64031A Ghost Reduction
> @@ -505,7 +550,8 @@ config VIDEO_UPD64031A
>  	  module will be called upd64031a.
>  
>  config VIDEO_UPD64083
> -	tristate "NEC Electronics uPD64083 3-Dimensional Y/C separation"
> +	tristate
> +	prompt "NEC Electronics uPD64083 3-Dimensional Y/C separation" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the NEC Electronics uPD64083 3-Dimensional Y/C
> @@ -515,8 +561,6 @@ config VIDEO_UPD64083
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called upd64083.
>  
> -endmenu # encoder / decoder chips
> -
>  config VIDEO_SH_VOU
>  	tristate "SuperH VOU video output driver"
>  	depends on VIDEO_DEV && ARCH_SHMOBILE
> diff --git a/drivers/media/video/cx25840/Kconfig b/drivers/media/video/cx25840/Kconfig
> index 451133a..3d76fa6 100644
> --- a/drivers/media/video/cx25840/Kconfig
> +++ b/drivers/media/video/cx25840/Kconfig
> @@ -1,5 +1,6 @@
>  config VIDEO_CX25840
> -	tristate "Conexant CX2584x audio/video decoders"
> +	tristate
> +	prompt "Conexant CX2584x audio/video decoders" if !VIDEO_HELPER_CHIPS_AUTO
>  	depends on VIDEO_V4L2 && I2C
>  	---help---
>  	  Support for the Conexant CX2584x audio/video decoders.
> 

