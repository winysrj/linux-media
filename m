Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2870 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2FWJOT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 05:14:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [git:v4l-dvb/for_v3.6] [media] radio: Add Sanyo LM7000 tuner driver
Date: Sat, 23 Jun 2012 11:14:06 +0200
Cc: linux-media@vger.kernel.org,
	Ondrej Zary <linux@rainbow-software.org>
References: <E1Shleh-0006kq-F7@www.linuxtv.org>
In-Reply-To: <E1Shleh-0006kq-F7@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206231114.06812.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

You accidentally merged the wrong first version of the lm7000 patch series.

These are the correct second version patches:

http://patchwork.linuxtv.org/patch/11689/
http://patchwork.linuxtv.org/patch/11690/
http://patchwork.linuxtv.org/patch/11691/

The second version is much simpler and doesn't require the creation of a whole
new driver.

Can you revert the old version and apply the correct one?

Thanks!

	Hans

On Thu June 21 2012 17:12:03 Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] radio: Add Sanyo LM7000 tuner driver
> Author:  Ondrej Zary <linux@rainbow-software.org>
> Date:    Tue Jun 12 14:37:54 2012 -0300
> 
> Add very simple driver for Sanyo LM7000 AM/FM tuner chip. Only FM is supported
> as there is no known HW with AM implemented.
> 
> This will be used by radio-aimslab and radio-sf16fmi.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  drivers/media/radio/Kconfig  |    3 ++
>  drivers/media/radio/Makefile |    1 +
>  drivers/media/radio/lm7000.c |   52 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/media/radio/lm7000.h |   32 +++++++++++++++++++++++++
>  4 files changed, 88 insertions(+), 0 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=4ecbb69414c61af3594209e081d6e834ea68a16d
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
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
> 
