Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44640 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932875AbeDXIeH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 04:34:07 -0400
Subject: Re: [PATCH] sound, isapnp: allow building more drivers with
 COMPILE_TEST
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org
References: <082977bdb133dc0570f690d3f3a120207f1d63f1.1524229123.git.mchehab@s-opensource.com>
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Message-ID: <d6007528-98a3-492a-e1d3-d43c23bf3a09@intel.com>
Date: Tue, 24 Apr 2018 10:34:04 +0200
MIME-Version: 1.0
In-Reply-To: <082977bdb133dc0570f690d3f3a120207f1d63f1.1524229123.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4/20/2018 2:58 PM, Mauro Carvalho Chehab wrote:
> Drivers that depend on ISAPNP currently can't be built with
> COMPILE_TEST. However, looking at isapnp.h, there are already
> stubs there to allow drivers to include it even when isa
> PNP is not supported.
>
> So, remove such dependencies when COMPILE_TEST.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>   drivers/pnp/isapnp/Kconfig | 2 +-
>   sound/isa/Kconfig          | 6 +++---
>   2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/pnp/isapnp/Kconfig b/drivers/pnp/isapnp/Kconfig
> index f1ef36673ad4..a1af146d2d90 100644
> --- a/drivers/pnp/isapnp/Kconfig
> +++ b/drivers/pnp/isapnp/Kconfig
> @@ -3,7 +3,7 @@
>   #
>   config ISAPNP
>   	bool "ISA Plug and Play support"
> -	depends on ISA
> +	depends on ISA || COMPILE_TEST
>   	help
>   	  Say Y here if you would like support for ISA Plug and Play devices.
>   	  Some information is in <file:Documentation/isapnp.txt>.
> diff --git a/sound/isa/Kconfig b/sound/isa/Kconfig
> index d2a6cdd0395c..43b35a873d78 100644
> --- a/sound/isa/Kconfig
> +++ b/sound/isa/Kconfig
> @@ -39,7 +39,7 @@ config SND_ADLIB
>   
>   config SND_AD1816A
>   	tristate "Analog Devices SoundPort AD1816A"
> -	depends on PNP && ISA
> +	depends on PNP
>   	select ISAPNP
>   	select SND_OPL3_LIB
>   	select SND_MPU401_UART
> @@ -67,7 +67,7 @@ config SND_AD1848
>   
>   config SND_ALS100
>   	tristate "Diamond Tech. DT-019x and Avance Logic ALSxxx"
> -	depends on PNP && ISA
> +	depends on PNP
>   	select ISAPNP
>   	select SND_OPL3_LIB
>   	select SND_MPU401_UART
> @@ -108,7 +108,7 @@ config SND_AZT2316
>   
>   config SND_AZT2320
>   	tristate "Aztech Systems AZT2320"
> -	depends on PNP && ISA
> +	depends on PNP
>   	select ISAPNP
>   	select SND_OPL3_LIB
>   	select SND_MPU401_UART


Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
