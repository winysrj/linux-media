Return-path: <linux-media-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:54269 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754907Ab0A0QjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 11:39:05 -0500
Received: from chimera.site ([96.253.169.185]) by xenotime.net for <linux-media@vger.kernel.org>; Wed, 27 Jan 2010 08:38:51 -0800
Date: Wed, 27 Jan 2010 08:38:51 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Richard =?ISO-8859-1?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/2] radio: Add radio-timb to the Kconfig and
 Makefile
Message-Id: <20100127083851.18076f19.rdunlap@xenotime.net>
In-Reply-To: <4B606832.7080006@pelagicore.com>
References: <4B606832.7080006@pelagicore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 27 Jan 2010 17:22:10 +0100 Richard Röjfors wrote:

> This patch adds radio-timb to the Makefile and Kconfig.
> 
> Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
> ---
> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index 3f40f37..46fd8c4 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -429,4 +429,14 @@ config RADIO_TEF6862
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called TEF6862.
> 
> +config RADIO_TIMBERDALE
> +	tristate "Enable the Timberdale radio driver"
> +	depends on MFD_TIMBERDALE && VIDEO_V4L2 && HAS_IOMEM
> +	select RADIO_TEF6862
> +	select RADIO_SAA7706H
> +	---help---
> +	  This is a kind of umbrella driver for the Radio Tuner and DSP
> +	  found behind the Timberdale FPGA on the Russellville board.
> +	  Enable this driver will automatically select the DSP and tuner.

	  Enabling

> +
>  endif # RADIO_ADAPTERS
> diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
> index 01922ad..8973850 100644
> --- a/drivers/media/radio/Makefile
> +++ b/drivers/media/radio/Makefile
> @@ -24,5 +24,6 @@ obj-$(CONFIG_RADIO_SI470X) += si470x/
>  obj-$(CONFIG_USB_MR800) += radio-mr800.o
>  obj-$(CONFIG_RADIO_TEA5764) += radio-tea5764.o
>  obj-$(CONFIG_RADIO_TEF6862) += tef6862.o
> +obj-$(CONFIG_RADIO_TIMBERDALE) += radio-timb.o
> 
>  EXTRA_CFLAGS += -Isound
> 
> --


---
~Randy
