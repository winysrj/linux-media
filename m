Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:30324 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3FOCPy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 22:15:54 -0400
From: Kukjin Kim <kgene.kim@samsung.com>
To: 'Tomasz Figa' <t.figa@samsung.com>,
	linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	'Arnd Bergmann' <arnd@arndb.de>,
	'Olof Johansson' <olof@lixom.net>,
	'Marek Szyprowski' <m.szyprowski@samsung.com>,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Thomas Abraham' <thomas.abraham@linaro.org>,
	"'Rafael J. Wysocki'" <rjw@sisk.pl>,
	'Viresh Kumar' <viresh.kumar@linaro.org>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Zhang Rui' <rui.zhang@intel.com>,
	'Eduardo Valentin' <eduardo.valentin@ti.com>,
	'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
	cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-media@vger.kernel.org, linux-serial@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>
References: <1371238384-1504-1-git-send-email-t.figa@samsung.com>
 <1371238384-1504-28-git-send-email-t.figa@samsung.com>
In-reply-to: <1371238384-1504-28-git-send-email-t.figa@samsung.com>
Subject: RE: [PATCH 27/28] ARM: EXYNOS: Remove CONFIG_SOC_EXYNOS4412
Date: Sat, 15 Jun 2013 11:15:51 +0900
Message-id: <172201ce696e$4200f0c0$c602d240$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tomasz Figa wrote:
> 
> Exynos4212 and Exynos4412 SoCs differ only in number of ARM cores and
> there is no need to have separate Kconfig options for them, since they
> use the same code.
> 
> This patch removes CONFIG_SOC_EXYNOS4412, leaving CONFIG_SOC_EXYNOS4212
> as the one supporting both SoCs from this series.
> 
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <eduardo.valentin@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: cpufreq@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: linux-serial@vger.kernel.org
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-exynos/Kconfig              | 11 +----------
>  arch/arm/plat-samsung/include/plat/cpu.h  |  6 +-----
>  drivers/cpufreq/Kconfig.arm               |  2 +-
>  drivers/media/platform/exynos4-is/Kconfig |  2 +-
>  drivers/thermal/exynos_thermal.c          |  2 +-
>  drivers/tty/serial/samsung.c              |  3 +--
>  6 files changed, 6 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index 47d8d9e..fe75a65 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -46,7 +46,7 @@ config CPU_EXYNOS4210
>  	  Enable EXYNOS4210 CPU support
> 
>  config SOC_EXYNOS4212
> -	bool "SAMSUNG EXYNOS4212"
> +	bool "SAMSUNG EXYNOS4212/4412"
>  	default y
>  	depends on ARCH_EXYNOS4
>  	select PINCTRL_EXYNOS
> @@ -56,15 +56,6 @@ config SOC_EXYNOS4212
>  	help
>  	  Enable EXYNOS4212 SoC support
> 
> -config SOC_EXYNOS4412
> -	bool "SAMSUNG EXYNOS4412"
> -	default y
> -	depends on ARCH_EXYNOS4
> -	select PINCTRL_EXYNOS
> -	select SAMSUNG_DMADEV
> -	help
> -	  Enable EXYNOS4412 SoC support
> -
>  config SOC_EXYNOS5250
>  	bool "SAMSUNG EXYNOS5250"
>  	default y
> diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-
> samsung/include/plat/cpu.h
> index 989fefe..87b03bb 100644
> --- a/arch/arm/plat-samsung/include/plat/cpu.h
> +++ b/arch/arm/plat-samsung/include/plat/cpu.h
> @@ -122,13 +122,9 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID,
> EXYNOS5_SOC_MASK)
> 
>  #if defined(CONFIG_SOC_EXYNOS4212)
>  # define soc_is_exynos4212()	is_samsung_exynos4212()
> -#else
> -# define soc_is_exynos4212()	0
> -#endif
> -
> -#if defined(CONFIG_SOC_EXYNOS4412)
>  # define soc_is_exynos4412()	is_samsung_exynos4412()
>  #else
> +# define soc_is_exynos4212()	0
>  # define soc_is_exynos4412()	0
>  #endif
> 
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index a924408..b214ad6 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -32,7 +32,7 @@ config ARM_EXYNOS4210_CPUFREQ
>  	  SoC (S5PV310 or S5PC210).
> 
>  config ARM_EXYNOS4X12_CPUFREQ
> -	def_bool (SOC_EXYNOS4212 || SOC_EXYNOS4412)
> +	def_bool SOC_EXYNOS4212
>  	help
>  	  This adds the CPUFreq driver for Samsung EXYNOS4X12
>  	  SoC (EXYNOS4212 or EXYNOS4412).
> diff --git a/drivers/media/platform/exynos4-is/Kconfig
> b/drivers/media/platform/exynos4-is/Kconfig
> index 6ff99b5..f483e11 100644
> --- a/drivers/media/platform/exynos4-is/Kconfig
> +++ b/drivers/media/platform/exynos4-is/Kconfig
> @@ -32,7 +32,7 @@ config VIDEO_S5P_MIPI_CSIS
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called s5p-csis.
> 
> -if SOC_EXYNOS4212 || SOC_EXYNOS4412 || SOC_EXYNOS5250
> +if SOC_EXYNOS4212 || SOC_EXYNOS5250
> 
>  config VIDEO_EXYNOS_FIMC_LITE
>  	tristate "EXYNOS FIMC-LITE camera interface driver"
> diff --git a/drivers/thermal/exynos_thermal.c
> b/drivers/thermal/exynos_thermal.c
> index 788b1dd..f88a2ad 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -817,7 +817,7 @@ static struct exynos_tmu_platform_data const
> exynos4210_default_tmu_data = {
>  #define EXYNOS4210_TMU_DRV_DATA (NULL)
>  #endif
> 
> -#if defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412)
> +#if defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4212)
>  static struct exynos_tmu_platform_data const exynos_default_tmu_data = {
>  	.threshold_falling = 10,
>  	.trigger_levels[0] = 85,
> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
> index 0c8a9fa..eeb8ecb 100644
> --- a/drivers/tty/serial/samsung.c
> +++ b/drivers/tty/serial/samsung.c
> @@ -1714,8 +1714,7 @@ static struct s3c24xx_serial_drv_data
> s5pv210_serial_drv_data = {
>  #endif
> 
>  #if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS4212) || \
> -	defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250) ||
> \
> -	defined(CONFIG_SOC_EXYNOS5440)
> +	defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS5440)
>  static struct s3c24xx_serial_drv_data exynos4210_serial_drv_data = {
>  	.info = &(struct s3c24xx_uart_info) {
>  		.name		= "Samsung Exynos4 UART",
> --
> 1.8.2.1

Hmm, how about SOC_EXYNOS4X12 for exynos4212 and exynos4412?

BTW, AFAIK, we need to leave both to support something...I need to check :)

- Kukjin

