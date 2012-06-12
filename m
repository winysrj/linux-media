Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3229 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2FLURy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 16:17:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 1/3] radio: Add Sanyo LM7000 tuner driver
Date: Tue, 12 Jun 2012 22:17:43 +0200
Cc: linux-media@vger.kernel.org
References: <201206122037.57039.linux@rainbow-software.org>
In-Reply-To: <201206122037.57039.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206122217.43545.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ondrej!

On Tue June 12 2012 20:37:54 Ondrej Zary wrote:
> Add very simple driver for Sanyo LM7000 AM/FM tuner chip. Only FM is supported
> as there is no known HW with AM implemented.

It feels to me that it is overkill to turn this into a full blown module.
Can't this be done as a single lm7000.h header that contains a single
static inline function like this:

static inline void lm7000_set_freq(u32 freq, void *handle,
						void (*set_pins)(void *handle, u8 pins))
{
	...
}

It does the job just as well.

Otherwise it looks fine.

Regards,

	Hans

> This will be used by radio-aimslab and radio-sf16fmi.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index c257da1..5bcce12 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -191,6 +191,9 @@ config RADIO_CADET
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called radio-cadet.
>  
> +config RADIO_LM7000
> +	tristate
> +
>  config RADIO_RTRACK
>  	tristate "AIMSlab RadioTrack (aka RadioReveal) support"
>  	depends on ISA && VIDEO_V4L2
> diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
> index ca8c7d1..7f6aa63 100644
> --- a/drivers/media/radio/Makefile
> +++ b/drivers/media/radio/Makefile
> @@ -28,5 +28,6 @@ obj-$(CONFIG_RADIO_TEF6862) += tef6862.o
>  obj-$(CONFIG_RADIO_TIMBERDALE) += radio-timb.o
>  obj-$(CONFIG_RADIO_WL1273) += radio-wl1273.o
>  obj-$(CONFIG_RADIO_WL128X) += wl128x/
> +obj-$(CONFIG_RADIO_LM7000) += lm7000.o
>  
>  ccflags-y += -Isound
> diff --git a/drivers/media/radio/lm7000.c b/drivers/media/radio/lm7000.c
> new file mode 100644
> index 0000000..681f3af
> --- /dev/null
> +++ b/drivers/media/radio/lm7000.c
> @@ -0,0 +1,52 @@
> +/* Sanyo LM7000 tuner chip driver
> + *
> + * Copyright 2012 Ondrej Zary <linux@rainbow-software.org>
> + * based on radio-aimslab.c by M. Kirkwood
> + * and radio-sf16fmi.c by M. Kirkwood and Petr Vandrovec
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/module.h>
> +#include "lm7000.h"
> +
> +MODULE_AUTHOR("Ondrej Zary <linux@rainbow-software.org>");
> +MODULE_DESCRIPTION("Routines for Sanyo LM7000 AM/FM radio tuner chip");
> +MODULE_LICENSE("GPL");
> +
> +/* write the 24-bit register, starting with LSB */
> +static void lm7000_write(struct lm7000 *lm, u32 val)
> +{
> +	int i;
> +	u8 data;
> +
> +	for (i = 0; i < 24; i++) {
> +		data = val & (1 << i) ? LM7000_DATA : 0;
> +		lm->set_pins(lm, data | LM7000_CE);
> +		udelay(2);
> +		lm->set_pins(lm, data | LM7000_CE | LM7000_CLK);
> +		udelay(2);
> +		lm->set_pins(lm, data | LM7000_CE);
> +		udelay(2);
> +	}
> +	lm->set_pins(lm, 0);
> +}
> +
> +void lm7000_set_freq(struct lm7000 *lm, u32 freq)
> +{
> +	freq += 171200;		/* Add 10.7 MHz IF */
> +	freq /= 400;		/* Convert to 25 kHz units */
> +	lm7000_write(lm, freq | LM7000_FM_25 | LM7000_BIT_FM);
> +}
> +EXPORT_SYMBOL(lm7000_set_freq);
> +
> +static int __init lm7000_module_init(void)
> +{
> +	return 0;
> +}
> +
> +static void __exit lm7000_module_exit(void)
> +{
> +}
> +
> +module_init(lm7000_module_init)
> +module_exit(lm7000_module_exit)
> diff --git a/drivers/media/radio/lm7000.h b/drivers/media/radio/lm7000.h
> new file mode 100644
> index 0000000..a5bc7d6
> --- /dev/null
> +++ b/drivers/media/radio/lm7000.h
> @@ -0,0 +1,32 @@
> +#ifndef __LM7000_H
> +#define __LM7000_H
> +
> +#define LM7000_DATA	(1 << 0)
> +#define LM7000_CLK	(1 << 1)
> +#define LM7000_CE	(1 << 2)
> +
> +#define LM7000_FREQ_MASK 0x3fff
> +#define LM7000_BIT_T0	(1 << 14)
> +#define LM7000_BIT_T1	(1 << 15)
> +#define LM7000_BIT_B0	(1 << 16)
> +#define LM7000_BIT_B1	(1 << 17)
> +#define LM7000_BIT_B2	(1 << 18)
> +#define LM7000_BIT_TB	(1 << 19)
> +#define LM7000_FM_100	(0 << 20)
> +#define LM7000_FM_50	(1 << 20)
> +#define LM7000_FM_25	(2 << 20)
> +#define LM7000_AM_5	(3 << 20)
> +#define LM7000_AM_10	(4 << 20)
> +#define LM7000_AM_9	(5 << 20)
> +#define LM7000_AM_1	(6 << 20)
> +#define LM7000_AM_5_	(7 << 20)
> +#define LM7000_BIT_FM	(1 << 23)
> +
> +
> +struct lm7000 {
> +	void (*set_pins)(struct lm7000 *lm, u8 pins);
> +};
> +
> +void lm7000_set_freq(struct lm7000 *lm, u32 freq);
> +
> +#endif /* __LM7000_H */
> 
> 
