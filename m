Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53946 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbbGVV4V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 17:56:21 -0400
Date: Wed, 22 Jul 2015 18:56:15 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 11/12] [media] tsin: c8sectpfe: Add Kconfig and Makefile
 for the driver.
Message-ID: <20150722185615.2033a1fb@recife.lan>
In-Reply-To: <1435158670-7195-12-git-send-email-peter.griffin@linaro.org>
References: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
	<1435158670-7195-12-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 24 Jun 2015 16:11:09 +0100
Peter Griffin <peter.griffin@linaro.org> escreveu:

> This patch adds the Kconfig and Makefile for the c8sectpfe driver
> so it will be built. It also selects additional demodulator and tuners
> which are required by the supported NIM cards.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  drivers/media/Kconfig                 |  1 +
>  drivers/media/Makefile                |  1 +
>  drivers/media/tsin/c8sectpfe/Kconfig  | 26 ++++++++++++++++++++++++++
>  drivers/media/tsin/c8sectpfe/Makefile | 11 +++++++++++
>  4 files changed, 39 insertions(+)
>  create mode 100644 drivers/media/tsin/c8sectpfe/Kconfig
>  create mode 100644 drivers/media/tsin/c8sectpfe/Makefile
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 1570992..82bc1dc 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -170,6 +170,7 @@ source "drivers/media/pci/Kconfig"
>  source "drivers/media/platform/Kconfig"
>  source "drivers/media/mmc/Kconfig"
>  source "drivers/media/radio/Kconfig"
> +source "drivers/media/tsin/c8sectpfe/Kconfig"
>  
>  comment "Supported FireWire (IEEE 1394) Adapters"
>  	depends on DVB_CORE && FIREWIRE
> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> index e608bbc..0a567b8 100644
> --- a/drivers/media/Makefile
> +++ b/drivers/media/Makefile
> @@ -29,5 +29,6 @@ obj-y += rc/
>  #
>  
>  obj-y += common/ platform/ pci/ usb/ mmc/ firewire/
> +obj-$(CONFIG_DVB_C8SECTPFE) += tsin/c8sectpfe/

Hmm... why are you adding it at a new "tsin" directory? We're putting
those SoC platform drivers under platform/.

>  obj-$(CONFIG_VIDEO_DEV) += radio/
>  
> diff --git a/drivers/media/tsin/c8sectpfe/Kconfig b/drivers/media/tsin/c8sectpfe/Kconfig
> new file mode 100644
> index 0000000..8d99a87
> --- /dev/null
> +++ b/drivers/media/tsin/c8sectpfe/Kconfig
> @@ -0,0 +1,26 @@
> +config DVB_C8SECTPFE
> +	tristate "STMicroelectronics C8SECTPFE DVB support"
> +	depends on DVB_CORE && I2C && (ARCH_STI || ARCH_MULTIPLATFORM)
> +	select DVB_LNBP21 if MEDIA_SUBDRV_AUTOSELECT
> +	select DVB_STV090x if MEDIA_SUBDRV_AUTOSELECT
> +	select DVB_STB6100 if MEDIA_SUBDRV_AUTOSELECT
> +	select DVB_STV6110 if MEDIA_SUBDRV_AUTOSELECT
> +	select DVB_STV0900 if MEDIA_SUBDRV_AUTOSELECT
> +	select DVB_STV0367 if MEDIA_SUBDRV_AUTOSELECT
> +	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
> +	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
> +
> +	---help---
> +	  This adds support for DVB front-end cards connected
> +	  to TS inputs of STiH407/410 SoC.
> +
> +	  The driver currently supports C8SECTPFE's TS input block,
> +	  memdma engine, and HW PID filtering.
> +
> +	  Supported DVB front-end cards are:
> +	  - STMicroelectronics DVB-T B2100A (STV0367 + TDA18212)
> +	  - STMicroelectronics DVB-T STV0367 PLL board (STV0367 + DTT7546X)
> +	  - STMicroelectronics DVB-S/S2 STV0903 + STV6110 + LNBP24 board
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called c8sectpfe.
> diff --git a/drivers/media/tsin/c8sectpfe/Makefile b/drivers/media/tsin/c8sectpfe/Makefile
> new file mode 100644
> index 0000000..777f06d
> --- /dev/null
> +++ b/drivers/media/tsin/c8sectpfe/Makefile
> @@ -0,0 +1,11 @@
> +c8sectpfe-y += c8sectpfe-core.o c8sectpfe-common.o c8sectpfe-dvb.o
> +
> +obj-$(CONFIG_DVB_C8SECTPFE) += c8sectpfe.o
> +
> +ifneq ($(CONFIG_DVB_C8SECTPFE),)
> +	c8sectpfe-y += c8sectpfe-debugfs.o
> +endif
> +
> +ccflags-y += -Idrivers/media/i2c
> +ccflags-y += -Idrivers/media/common
> +ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends/ -Idrivers/media/tuners/
