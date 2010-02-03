Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab0BCJ7l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 04:59:41 -0500
Message-ID: <4B694909.80504@infradead.org>
Date: Wed, 03 Feb 2010 07:59:37 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/2] radio: Add radio-timb to the Kconfig and Makefile
References: <4B606832.7080006@pelagicore.com>
In-Reply-To: <4B606832.7080006@pelagicore.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Richard Röjfors wrote:
> This patch adds radio-timb to the Makefile and Kconfig.

On your next submission, please fold with patch 1/2. 
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
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
