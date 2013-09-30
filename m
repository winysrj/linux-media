Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:25152 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3I3HXz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 03:23:55 -0400
From: Kukjin Kim <kgene@kernel.org>
To: 'Tomasz Figa' <tomasz.figa@gmail.com>,
	linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, 'Arnd Bergmann' <arnd@arndb.de>,
	'Olof Johansson' <olof@lixom.net>,
	'Russell King - ARM Linux' <linux@arm.linux.org.uk>,
	'Ben Dooks' <ben-linux@fluff.org>,
	'Linus Walleij' <linus.walleij@linaro.org>,
	'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'Sangbeom Kim' <sbkim73@samsung.com>,
	'Liam Girdwood' <lgirdwood@gmail.com>,
	'Mark Brown' <broonie@kernel.org>,
	'Jaroslav Kysela' <perex@perex.cz>,
	'Takashi Iwai' <tiwai@suse.de>,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Geert Uytterhoeven' <geert@linux-m68k.org>,
	'Martin Schwidefsky' <schwidefsky@de.ibm.com>
References: <1380392497-27406-1-git-send-email-tomasz.figa@gmail.com>
In-reply-to: <1380392497-27406-1-git-send-email-tomasz.figa@gmail.com>
Subject: RE: [PATCH 1/5] ARM: Kconfig: Move if ARCH_S3C64XX statement to
 mach-s3c64xx/Kconfig
Date: Mon, 30 Sep 2013 16:22:51 +0900
Message-id: <069301cebdad$df658f90$9e30aeb0$@org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tomasz Figa wrote:
> 
> All other platforms have this condition checked inside their own Kconfig
> files, so for consistency this patch makes it this way for mach-s3c64xx
> as well.
> 
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> ---
>  arch/arm/Kconfig              | 2 --
>  arch/arm/mach-s3c64xx/Kconfig | 4 ++++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index b766dad..dc51f8a 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -995,9 +995,7 @@ source "arch/arm/mach-sti/Kconfig"
> 
>  source "arch/arm/mach-s3c24xx/Kconfig"
> 
> -if ARCH_S3C64XX
>  source "arch/arm/mach-s3c64xx/Kconfig"
> -endif
> 
>  source "arch/arm/mach-s5p64x0/Kconfig"
> 
> diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
> index bd14e3a..0e23910 100644
> --- a/arch/arm/mach-s3c64xx/Kconfig
> +++ b/arch/arm/mach-s3c64xx/Kconfig
> @@ -3,6 +3,8 @@
>  #
>  # Licensed under GPLv2
> 
> +if ARCH_S3C64XX
> +
>  # temporary until we can eliminate all drivers using it.
>  config PLAT_S3C64XX
>  	bool
> @@ -322,3 +324,5 @@ config MACH_S3C64XX_DT
>  	  board.
>  	  Note: This is under development and not all peripherals can be
>  	  supported with this machine file.
> +
> +endif
> --
> 1.8.3.2

Looks good to me, applied 1 to 5 patches into cleanup.

Thanks,
Kukjin

