Return-path: <mchehab@pedra>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:45016 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080Ab0KNBHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 20:07:03 -0500
Subject: Re: [PATCH 3/3] [media] rc: Remove ir-common module
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <20101113173319.53942066@pedra>
References: <cover.1289676395.git.mchehab@redhat.com>
	 <20101113173319.53942066@pedra>
Content-Type: text/plain
Date: Sun, 14 Nov 2010 01:58:24 +0100
Message-Id: <1289696304.3167.4.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Am Samstag, den 13.11.2010, 17:33 -0200 schrieb Mauro Carvalho Chehab:
> Now, just one old bttv board uses the old RC5 raw decoding routines.
> Its conversion to rc-core requires the generation of IRQ data for both
> positive and negative transitions at the IRQ line. I'm not sure if
> bttv driver supports it or if the transitions will be reliable enough.
> So, due to the lack of hardware for testing, the better for now is to
> just move the legacy routines to bttv driver, and wait for someone with
> a Nebula Digi could help to port it to use also rc-core raw decoders.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Without any testing feedback from the bttv Nebula Digi since we made it
available for the saa7134 for Asus IR IRQ sampling too

Acked-by: hermann pitton <hermann-pitton@arcor.de>

Cheers,
Hermann 


>  delete mode 100644 drivers/media/rc/ir-functions.c
> 
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index 2d15468..ef19375 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -10,11 +10,6 @@ menuconfig IR_CORE
>  	  if you don't need IR, as otherwise, you may not be able to
>  	  compile the driver for your adapter.
>  
> -config IR_LEGACY
> -	tristate
> -	depends on IR_CORE
> -	default IR_CORE
> -
>  if IR_CORE
>  
>  config LIRC
> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> index 859c12c..8c0e4cb 100644
> --- a/drivers/media/rc/Makefile
> +++ b/drivers/media/rc/Makefile
> @@ -1,10 +1,8 @@
> -ir-common-objs  := ir-functions.o
>  rc-core-objs	:= rc-main.o rc-raw.o
>  
>  obj-y += keymaps/
>  
>  obj-$(CONFIG_IR_CORE) += rc-core.o
> -obj-$(CONFIG_IR_LEGACY) += ir-common.o
>  obj-$(CONFIG_LIRC) += lirc_dev.o
>  obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
>  obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
> diff --git a/drivers/media/rc/ir-functions.c b/drivers/media/rc/ir-functions.c
> deleted file mode 100644
> index 14397d0..0000000
> --- a/drivers/media/rc/ir-functions.c
> +++ /dev/null
> @@ -1,120 +0,0 @@
> -/*
> - * some common functions to handle infrared remote protocol decoding for
> - * drivers which have not yet been (or can't be) converted to use the
> - * regular protocol decoders...
> - *
> - * (c) 2003 Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
> - *
> - *  This program is free software; you can redistribute it and/or modify
> - *  it under the terms of the GNU General Public License as published by
> - *  the Free Software Foundation; either version 2 of the License, or
> - *  (at your option) any later version.
> - *
> - *  This program is distributed in the hope that it will be useful,
> - *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> - *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - *  GNU General Public License for more details.
> - *
> - *  You should have received a copy of the GNU General Public License
> - *  along with this program; if not, write to the Free Software
> - *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - */
> -
> -#include <linux/module.h>
> -#include <linux/string.h>
> -#include <linux/jiffies.h>
> -#include <media/ir-common.h>
> -#include "rc-core-priv.h"
> -
> -/* -------------------------------------------------------------------------- */
> -
> -MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
> -MODULE_LICENSE("GPL");
> -
> -/* RC5 decoding stuff, moved from bttv-input.c to share it with
> - * saa7134 */
> -
> -/* decode raw bit pattern to RC5 code */
> -static u32 ir_rc5_decode(unsigned int code)
> -{
> -	unsigned int org_code = code;
> -	unsigned int pair;
> -	unsigned int rc5 = 0;
> -	int i;
> -
> -	for (i = 0; i < 14; ++i) {
> -		pair = code & 0x3;
> -		code >>= 2;
> -
> -		rc5 <<= 1;
> -		switch (pair) {
> -		case 0:
> -		case 2:
> -			break;
> -		case 1:
> -			rc5 |= 1;
> -			break;
> -		case 3:
> -			IR_dprintk(1, "ir-common: ir_rc5_decode(%x) bad code\n", org_code);
> -			return 0;
> -		}
> -	}
> -	IR_dprintk(1, "ir-common: code=%x, rc5=%x, start=%x, toggle=%x, address=%x, "
> -		"instr=%x\n", rc5, org_code, RC5_START(rc5),
> -		RC5_TOGGLE(rc5), RC5_ADDR(rc5), RC5_INSTR(rc5));
> -	return rc5;
> -}
> -
> -void ir_rc5_timer_end(unsigned long data)
> -{
> -	struct card_ir *ir = (struct card_ir *)data;
> -	struct timeval tv;
> -	unsigned long current_jiffies;
> -	u32 gap;
> -	u32 rc5 = 0;
> -
> -	/* get time */
> -	current_jiffies = jiffies;
> -	do_gettimeofday(&tv);
> -
> -	/* avoid overflow with gap >1s */
> -	if (tv.tv_sec - ir->base_time.tv_sec > 1) {
> -		gap = 200000;
> -	} else {
> -		gap = 1000000 * (tv.tv_sec - ir->base_time.tv_sec) +
> -		    tv.tv_usec - ir->base_time.tv_usec;
> -	}
> -
> -	/* signal we're ready to start a new code */
> -	ir->active = 0;
> -
> -	/* Allow some timer jitter (RC5 is ~24ms anyway so this is ok) */
> -	if (gap < 28000) {
> -		IR_dprintk(1, "ir-common: spurious timer_end\n");
> -		return;
> -	}
> -
> -	if (ir->last_bit < 20) {
> -		/* ignore spurious codes (caused by light/other remotes) */
> -		IR_dprintk(1, "ir-common: short code: %x\n", ir->code);
> -	} else {
> -		ir->code = (ir->code << ir->shift_by) | 1;
> -		rc5 = ir_rc5_decode(ir->code);
> -
> -		/* two start bits? */
> -		if (RC5_START(rc5) != ir->start) {
> -			IR_dprintk(1, "ir-common: rc5 start bits invalid: %u\n", RC5_START(rc5));
> -
> -			/* right address? */
> -		} else if (RC5_ADDR(rc5) == ir->addr) {
> -			u32 toggle = RC5_TOGGLE(rc5);
> -			u32 instr = RC5_INSTR(rc5);
> -
> -			/* Good code */
> -			ir_keydown(ir->dev, instr, toggle);
> -			IR_dprintk(1, "ir-common: instruction %x, toggle %x\n",
> -				   instr, toggle);
> -		}
> -	}
> -}
> -EXPORT_SYMBOL_GPL(ir_rc5_timer_end);
> diff --git a/drivers/media/video/bt8xx/Kconfig b/drivers/media/video/bt8xx/Kconfig
> index 659e448..3c7c0a5 100644
> --- a/drivers/media/video/bt8xx/Kconfig
> +++ b/drivers/media/video/bt8xx/Kconfig
> @@ -4,7 +4,7 @@ config VIDEO_BT848
>  	select I2C_ALGOBIT
>  	select VIDEO_BTCX
>  	select VIDEOBUF_DMA_SG
> -	depends on IR_LEGACY
> +	depends on IR_CORE
>  	select VIDEO_TUNER
>  	select VIDEO_TVEEPROM
>  	select VIDEO_MSP3400 if VIDEO_HELPER_CHIPS_AUTO
> diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
> index 4b4f613..03ef89f 100644
> --- a/drivers/media/video/bt8xx/bttv-input.c
> +++ b/drivers/media/video/bt8xx/bttv-input.c
> @@ -140,7 +140,100 @@ static void bttv_input_timer(unsigned long data)
>  	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
>  }
>  
> -/* ---------------------------------------------------------------*/
> +/*
> + * FIXME: Nebula digi uses the legacy way to decode RC5, instead of relying
> + * on the rc-core way. As we need to be sure that both IRQ transitions are
> + * properly triggered, Better to touch it only with this hardware for
> + * testing.
> + */
> +
> +/* decode raw bit pattern to RC5 code */
> +static u32 bttv_rc5_decode(unsigned int code)
> +{
> +	unsigned int org_code = code;
> +	unsigned int pair;
> +	unsigned int rc5 = 0;
> +	int i;
> +
> +	for (i = 0; i < 14; ++i) {
> +		pair = code & 0x3;
> +		code >>= 2;
> +
> +		rc5 <<= 1;
> +		switch (pair) {
> +		case 0:
> +		case 2:
> +			break;
> +		case 1:
> +			rc5 |= 1;
> +		break;
> +		case 3:
> +			dprintk(KERN_INFO DEVNAME ":rc5_decode(%x) bad code\n",
> +				org_code);
> +			return 0;
> +		}
> +	}
> +	dprintk(KERN_INFO DEVNAME ":"
> +		"code=%x, rc5=%x, start=%x, toggle=%x, address=%x, "
> +		"instr=%x\n", rc5, org_code, RC5_START(rc5),
> +		RC5_TOGGLE(rc5), RC5_ADDR(rc5), RC5_INSTR(rc5));
> +	return rc5;
> +}
> +
> +void bttv_rc5_timer_end(unsigned long data)
> +{
> +	struct card_ir *ir = (struct card_ir *)data;
> +	struct timeval tv;
> +	unsigned long current_jiffies;
> +	u32 gap;
> +	u32 rc5 = 0;
> +
> +	/* get time */
> +	current_jiffies = jiffies;
> +	do_gettimeofday(&tv);
> +
> +	/* avoid overflow with gap >1s */
> +	if (tv.tv_sec - ir->base_time.tv_sec > 1) {
> +		gap = 200000;
> +	} else {
> +		gap = 1000000 * (tv.tv_sec - ir->base_time.tv_sec) +
> +		    tv.tv_usec - ir->base_time.tv_usec;
> +	}
> +
> +	/* signal we're ready to start a new code */
> +	ir->active = 0;
> +
> +	/* Allow some timer jitter (RC5 is ~24ms anyway so this is ok) */
> +	if (gap < 28000) {
> +		dprintk(KERN_INFO DEVNAME ": spurious timer_end\n");
> +		return;
> +	}
> +
> +	if (ir->last_bit < 20) {
> +		/* ignore spurious codes (caused by light/other remotes) */
> +		dprintk(KERN_INFO DEVNAME ": short code: %x\n", ir->code);
> +	} else {
> +		ir->code = (ir->code << ir->shift_by) | 1;
> +		rc5 = bttv_rc5_decode(ir->code);
> +
> +		/* two start bits? */
> +		if (RC5_START(rc5) != ir->start) {
> +			printk(KERN_INFO DEVNAME ":"
> +			       " rc5 start bits invalid: %u\n", RC5_START(rc5));
> +
> +			/* right address? */
> +		} else if (RC5_ADDR(rc5) == ir->addr) {
> +			u32 toggle = RC5_TOGGLE(rc5);
> +			u32 instr = RC5_INSTR(rc5);
> +
> +			/* Good code */
> +			ir_keydown(ir->dev, instr, toggle);
> +			dprintk(KERN_INFO DEVNAME ":"
> +				" instruction %x, toggle %x\n",
> +				instr, toggle);
> +		}
> +	}
> +}
>  
>  static int bttv_rc5_irq(struct bttv *btv)
>  {
> @@ -283,10 +376,10 @@ void __devinit init_bttv_i2c_ir(struct bttv *btv)
>  	default:
>  		/*
>  		 * The external IR receiver is at i2c address 0x34 (0x35 for
> -                 * reads).  Future Hauppauge cards will have an internal
> -                 * receiver at 0x30 (0x31 for reads).  In theory, both can be
> -                 * fitted, and Hauppauge suggest an external overrides an
> -                 * internal.
> +		 * reads).  Future Hauppauge cards will have an internal
> +		 * receiver at 0x30 (0x31 for reads).  In theory, both can be
> +		 * fitted, and Hauppauge suggest an external overrides an
> +		 * internal.
>  		 * That's why we probe 0x1a (~0x34) first. CB
>  		 */
>  
> diff --git a/drivers/media/video/saa7134/Kconfig b/drivers/media/video/saa7134/Kconfig
> index 32a95a2..e03bff9 100644
> --- a/drivers/media/video/saa7134/Kconfig
> +++ b/drivers/media/video/saa7134/Kconfig
> @@ -26,7 +26,7 @@ config VIDEO_SAA7134_ALSA
>  
>  config VIDEO_SAA7134_RC
>  	bool "Philips SAA7134 Remote Controller support"
> -	depends on IR_LEGACY
> +	depends on IR_CORE
>  	depends on VIDEO_SAA7134
>  	default y
>  	---help---

