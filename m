Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:42901 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752731AbZF3XgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 19:36:01 -0400
Subject: Re: RFC: Remote control sensors and Linux input layer
From: hermann pitton <hermann-pitton@arcor.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-input@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
In-Reply-To: <m34otxr42y.fsf@intrepid.localdomain>
References: <m3ab3prdnv.fsf@intrepid.localdomain>
	 <m34otxr42y.fsf@intrepid.localdomain>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 01:32:19 +0200
Message-Id: <1246404739.12087.40.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Dienstag, den 30.06.2009, 20:04 +0200 schrieb Krzysztof Halasa:
> > I'm attaching a test patch for "1" and "3". It's incomplete, breaks
> > bttv, but it currently works with my Philips RC and Super 007 DVB-T
> > board.

your prior mail with the RFC is only on linux-input.

Please post that also to linux-media, maybe you get somebody interested,
but I don't have such a device anymore. I doubt that Mauro, who has it
now, has much time for it.

Please note, the term "rc5" is coming from bttv.

It is by far not an attempt to provide full RC5 and later support, but a
hack of completely unknown hardware not related to Philips, AFAIK.

I wonder, why you don't start with the remote coming with your Avermedia
card, but with some Philips remote coming with your TV.

On the supported Asus cards gpio18 goes high when the receiver is
plugged in. It is also 3.3Volts only and I did not find a replacement on
the markets yet. They seem to be all 5Volts.

Also the Asus' aim is not to fit a Philips TV, but m$ MCE ...

If you can't make sure not to break existing working devices, take what
you can need, but keep it away from them.

> Well, the patch (against 2.6.30):
> 
> --- a/drivers/media/common/ir-functions.c
> +++ b/drivers/media/common/ir-functions.c
> @@ -260,47 +260,12 @@ int ir_decode_biphase(u32 *samples, int count, int low, int high)
>  }
>  EXPORT_SYMBOL_GPL(ir_decode_biphase);
>  
> -/* RC5 decoding stuff, moved from bttv-input.c to share it with
> - * saa7134 */

It is years back, but we don't know until today, waiting nine months or
so then, if we did break the bttv device ... Please keep the comments.

Cheers,
Hermann

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
> -			dprintk(1, "ir-common: ir_rc5_decode(%x) bad code\n", org_code);
> -			return 0;
> -		}
> -	}
> -	dprintk(1, "ir-common: code=%x, rc5=%x, start=%x, toggle=%x, address=%x, "
> -		"instr=%x\n", rc5, org_code, RC5_START(rc5),
> -		RC5_TOGGLE(rc5), RC5_ADDR(rc5), RC5_INSTR(rc5));
> -	return rc5;
> -}
> -
>  void ir_rc5_timer_end(unsigned long data)
>  {
>  	struct card_ir *ir = (struct card_ir *)data;
>  	struct timeval tv;
>  	unsigned long current_jiffies, timeout;
>  	u32 gap;
> -	u32 rc5 = 0;
>  
>  	/* get time */
>  	current_jiffies = jiffies;
> @@ -317,46 +282,46 @@ void ir_rc5_timer_end(unsigned long data)
>  	/* signal we're ready to start a new code */
>  	ir->active = 0;
>  
> -	/* Allow some timer jitter (RC5 is ~24ms anyway so this is ok) */
> -	if (gap < 28000) {
> -		dprintk(1, "ir-common: spurious timer_end\n");
> +	if (ir->last_bit == 1 && (ir->code & 2))
> +		ir->last_bit--; /* bit1: 1 -> bit0: 0 doesn't generate an IRQ */
> +
> +	if (ir->last_bit) {
> +		/* ignore spurious codes (caused by light/other remotes) */
> +		dprintk(1, "ir-common: short code: %X\n", ir->code);
>  		return;
>  	}
>  
> -	if (ir->last_bit < 20) {
> -		/* ignore spurious codes (caused by light/other remotes) */
> -		dprintk(1, "ir-common: short code: %x\n", ir->code);
> -	} else {
> -		ir->code = (ir->code << ir->shift_by) | 1;
> -		rc5 = ir_rc5_decode(ir->code);
> -
> -		/* two start bits? */
> -		if (RC5_START(rc5) != ir->start) {
> -			dprintk(1, "ir-common: rc5 start bits invalid: %u\n", RC5_START(rc5));
> -
> -			/* right address? */
> -		} else if (RC5_ADDR(rc5) == ir->addr) {
> -			u32 toggle = RC5_TOGGLE(rc5);
> -			u32 instr = RC5_INSTR(rc5);
> -
> -			/* Good code, decide if repeat/repress */
> -			if (toggle != RC5_TOGGLE(ir->last_rc5) ||
> -			    instr != RC5_INSTR(ir->last_rc5)) {
> -				dprintk(1, "ir-common: instruction %x, toggle %x\n", instr,
> -					toggle);
> -				ir_input_nokey(ir->dev, &ir->ir);
> -				ir_input_keydown(ir->dev, &ir->ir, instr,
> -						 instr);
> -			}
> +	//ir->code = (ir->code << ir->shift_by) | 1; /* FIXME check bttv */
>  
> -			/* Set/reset key-up timer */
> -			timeout = current_jiffies +
> -				  msecs_to_jiffies(ir->rc5_key_timeout);
> -			mod_timer(&ir->timer_keyup, timeout);
> +	if (!RC5_ADDR(ir->code)) {
> +		dprintk(1, "ir-common: bad RC5 code 0x%x\n", ir->code);
> +		return;
> +	}
>  
> -			/* Save code for repeat test */
> -			ir->last_rc5 = rc5;
> +	dprintk(1, "ir-common: rc5=0x%X, toggle=0x%X, address=0x%X, instr=%x\n",
> +		ir->code, RC5_TOGGLE(ir->code), RC5_ADDR(ir->code),
> +		RC5_INSTR(ir->code));
> +
> +	if (RC5_ADDR(ir->code) == ir->addr) {
> +		u32 toggle = RC5_TOGGLE(ir->code);
> +		u32 instr = RC5_INSTR(ir->code);
> +
> +		/* Good code, decide if repeat/repress */
> +		if (toggle != RC5_TOGGLE(ir->last_rc5) ||
> +		    instr != RC5_INSTR(ir->last_rc5)) {
> +			dprintk(1, "ir-common: instruction %x, toggle %x\n",
> +				instr, toggle);
> +			ir_input_nokey(ir->dev, &ir->ir);
> +			ir_input_keydown(ir->dev, &ir->ir, instr, instr);
>  		}
> +
> +		/* Set/reset key-up timer */
> +		timeout = current_jiffies +
> +			msecs_to_jiffies(ir->rc5_key_timeout);
> +		mod_timer(&ir->timer_keyup, timeout);
> +
> +		/* Save code for repeat test */
> +		ir->last_rc5 = ir->code;
>  	}
>  }
>  EXPORT_SYMBOL_GPL(ir_rc5_timer_end);
> --- a/drivers/media/common/ir-keymaps.c
> +++ b/drivers/media/common/ir-keymaps.c
> @@ -1487,6 +1487,53 @@ IR_KEYTAB_TYPE ir_codes_pv951[IR_KEYTAB_SIZE] = {
>  
>  EXPORT_SYMBOL_GPL(ir_codes_pv951);
>  
> +/*
> +  Philips RC2592 with MODE pressed, used by Philips TV sets
> +  RC5 group = 8, commands are 7-bit wide (1 start bit)
> +*/
> +IR_KEYTAB_TYPE ir_codes_rc2592_sat[IR_KEYTAB_SIZE] = {
> +	[ 0x00 ] = KEY_0,
> +	[ 0x01 ] = KEY_1,
> +	[ 0x02 ] = KEY_2,
> +	[ 0x03 ] = KEY_3,
> +	[ 0x04 ] = KEY_4,
> +	[ 0x05 ] = KEY_5,
> +	[ 0x06 ] = KEY_6,
> +	[ 0x07 ] = KEY_7,
> +	[ 0x08 ] = KEY_8,
> +	[ 0x09 ] = KEY_9,
> +
> +	[ 0x0C ] = KEY_SUSPEND,
> +
> +	[ 0x6B ] = KEY_RED,
> +	[ 0x6C ] = KEY_GREEN,
> +	[ 0x6D ] = KEY_YELLOW,
> +	[ 0x6E ] = KEY_BLUE,
> +	[ 0x6F ] = KEY_OPTION,		/* white */
> +
> +	[ 0x2A ] = KEY_TIME,
> +	[ 0x2C ] = KEY_QUESTION,
> +	[ 0x2B ] = KEY_ZOOM,
> +	[ 0x3C ] = KEY_TEXT,
> +
> +	[ 0x52 ] = KEY_MENU,
> +	[ 0x57 ] = KEY_OK,
> +	[ 0x50 ] = KEY_UP,
> +	[ 0x51 ] = KEY_DOWN,
> +	[ 0x55 ] = KEY_LEFT,
> +	[ 0x56 ] = KEY_RIGHT,
> +
> +	[ 0x20 ] = KEY_CHANNELUP,
> +	[ 0x21 ] = KEY_CHANNELDOWN,
> +
> +	[ 0x0F ] = KEY_INFO,		/* i+ */
> +	[ 0x22 ] = KEY_PREVIOUS,	/* P<P */
> +	[ 0x23 ] = KEY_LANGUAGE,	/* I-II */
> +	[ 0x38 ] = KEY_SUBTITLE		/* [1][2] */
> +};
> +
> +EXPORT_SYMBOL_GPL(ir_codes_rc2592_sat);
> +
>  /* generic RC5 keytable                                          */
>  /* see http://users.pandora.be/nenya/electronics/rc5/codes00.htm */
>  /* used by old (black) Hauppauge remotes                         */
> --- a/drivers/media/video/saa7134/saa7134-cards.c
> +++ b/drivers/media/video/saa7134/saa7134-cards.c
> @@ -6105,6 +6105,7 @@ int saa7134_board_init1(struct saa7134_dev *dev)
>  	case SAA7134_BOARD_AVERMEDIA_307:
>  	case SAA7134_BOARD_AVERMEDIA_STUDIO_507:
>  	case SAA7134_BOARD_AVERMEDIA_GO_007_FM:
> +	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
>  	case SAA7134_BOARD_AVERMEDIA_777:
>  	case SAA7134_BOARD_AVERMEDIA_M135A:
>  /*      case SAA7134_BOARD_SABRENT_SBTTVFM:  */ /* not finished yet */
> --- a/drivers/media/video/saa7134/saa7134-core.c
> +++ b/drivers/media/video/saa7134/saa7134-core.c
> @@ -695,9 +695,9 @@ static int saa7134_hw_enable2(struct saa7134_dev *dev)
>  	if (dev->has_remote == SAA7134_REMOTE_GPIO && dev->remote) {
>  		if (dev->remote->mask_keydown & 0x10000)
>  			irq2_mask |= SAA7134_IRQ2_INTE_GPIO16;
> -		else if (dev->remote->mask_keydown & 0x40000)
> +		if (dev->remote->mask_keydown & 0x40000)
>  			irq2_mask |= SAA7134_IRQ2_INTE_GPIO18;
> -		else if (dev->remote->mask_keyup & 0x40000)
> +		if (dev->remote->mask_keyup & 0x40000)
>  			irq2_mask |= SAA7134_IRQ2_INTE_GPIO18A;
>  	}
>  
> --- a/drivers/media/video/saa7134/saa7134-input.c
> +++ b/drivers/media/video/saa7134/saa7134-input.c
> @@ -374,7 +374,6 @@ void saa7134_ir_start(struct saa7134_dev *dev, struct card_ir *ir)
>  		ir->timer_keyup.data = (unsigned long)ir;
>  		ir->shift_by = 2;
>  		ir->start = 0x2;
> -		ir->addr = 0x17;
>  		ir->rc5_key_timeout = ir_rc5_key_timeout;
>  		ir->rc5_remote_gap = ir_rc5_remote_gap;
>  	} else if (ir->nec_gpio) {
> @@ -402,6 +401,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
>  	int rc5_gpio	 = 0;
>  	int nec_gpio	 = 0;
>  	int ir_type      = IR_TYPE_OTHER;
> +	int addr         = 0;
>  	int err;
>  
>  	if (dev->has_remote != SAA7134_REMOTE_GPIO)
> @@ -483,6 +483,12 @@ int saa7134_input_init1(struct saa7134_dev *dev)
>  		saa_setb(SAA7134_GPIO_GPMODE1, 0x1);
>  		saa_setb(SAA7134_GPIO_GPSTATUS1, 0x1);
>  		break;
> +	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
> +		ir_codes     = ir_codes_rc2592_sat;
> +		addr         = 8;
> +		mask_keyup   = 0x40000;
> +		rc5_gpio     = 1;
> +		break;
>  	case SAA7134_BOARD_KWORLD_TERMINATOR:
>  		ir_codes     = ir_codes_pixelview;
>  		mask_keycode = 0x00001f;
> @@ -562,6 +568,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
>  	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
>         case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
>  		ir_codes     = ir_codes_asus_pc39;
> +		addr         = 0x17;
>  		mask_keydown = 0x0040000;
>  		rc5_gpio = 1;
>  		break;
> @@ -623,6 +630,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
>  	ir->mask_keyup   = mask_keyup;
>  	ir->polling      = polling;
>  	ir->rc5_gpio	 = rc5_gpio;
> +	ir->addr	 = addr;
>  	ir->nec_gpio	 = nec_gpio;
>  
>  	/* init input device */
> @@ -748,26 +756,60 @@ static int saa7134_rc5_irq(struct saa7134_dev *dev)
>  		    tv.tv_usec - ir->base_time.tv_usec;
>  	}
>  
> +	/* rising SAA7134_GPIO_GPRESCAN reads the status */
> +	saa_clearb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN);
> +	saa_setb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN);
> +	printk(KERN_DEBUG "rc5 irq: %lu %lu %u gap %u\n", tv.tv_sec, tv.tv_usec,
> +	       (saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) / 0x40000) & 1, gap);
> +
>  	/* active code => add bit */
>  	if (ir->active) {
>  		/* only if in the code (otherwise spurious IRQ or timer
>  		   late) */
> -		if (ir->last_bit < 28) {
> -			ir->last_bit = (gap - ir_rc5_remote_gap / 2) /
> -			    ir_rc5_remote_gap;
> -			ir->code |= 1 << ir->last_bit;
> +		gap = (gap + ir_rc5_remote_gap / 2) / ir_rc5_remote_gap;
> +		if (ir->last_bit && ir->code) {
> +			u32 last = ir->code >> ir->last_bit;
> +
> +			printk(KERN_DEBUG "RC5 gap %u last %X last_bit %u code "
> +			       "0x%X\n", gap, last, ir->last_bit, ir->code);
> +
> +			if ((last & 1) == 1) {
> +				if (gap == 2)		/* 1 -> 1 */
> +					ir->code |= 1 << --ir->last_bit;
> +				else if (gap == 3)	/* 1 -> 00 */
> +					ir->last_bit -= 2;
> +				else if (gap == 4)	/* 1 -> 01 */
> +					ir->code |= 1 << (ir->last_bit -= 2);
> +				else
> +					goto invalid;
> +			} else if ((last & 3) == 0) {
> +				if (gap == 2)		/* 00 -> 0 */
> +					ir->last_bit--;
> +				else if (gap == 3)	/* 00 -> 1 */
> +					ir->code |= 1 << --ir->last_bit;
> +				else
> +					goto invalid;
> +			} else
> +				goto invalid;
> +
> +			printk(KERN_DEBUG "RC5: last_bit %u, code 0x%X\n",
> +			       ir->last_bit, ir->code);
>  		}
>  		/* starting new code */
>  	} else {
>  		ir->active = 1;
> -		ir->code = 0;
> -		ir->base_time = tv;
> -		ir->last_bit = 0;
> +		ir->code = 0x2000; /* start bit is always '1' */
> +		ir->last_bit = 13;
>  
>  		timeout = current_jiffies + (500 + 30 * HZ) / 1000;
>  		mod_timer(&ir->timer_end, timeout);
>  	}
>  
> +	ir->base_time = tv;
> +	return 1;
> +
> +invalid:
> +	ir->code = 0; /* mark as invalid */
>  	return 1;
>  }
>  
> --- a/include/media/ir-common.h
> +++ b/include/media/ir-common.h
> @@ -37,10 +37,10 @@
>  #define IR_KEYCODE(tab,code)	(((unsigned)code < IR_KEYTAB_SIZE) \
>  				 ? tab[code] : KEY_RESERVED)
>  
> -#define RC5_START(x)	(((x)>>12)&3)
> +#define RC5_START(x)	(((x) >> 13) & 1)
>  #define RC5_TOGGLE(x)	(((x)>>11)&1)
>  #define RC5_ADDR(x)	(((x)>>6)&31)
> -#define RC5_INSTR(x)	((x)&63)
> +#define RC5_INSTR(x)	((((~(x)) >> 6) & 0x40) | ((x) & 0x3F))
>  
>  struct ir_input_state {
>  	/* configuration */
> @@ -136,6 +136,7 @@ extern IR_KEYTAB_TYPE ir_codes_gotview7135[IR_KEYTAB_SIZE];
>  extern IR_KEYTAB_TYPE ir_codes_purpletv[IR_KEYTAB_SIZE];
>  extern IR_KEYTAB_TYPE ir_codes_pctv_sedna[IR_KEYTAB_SIZE];
>  extern IR_KEYTAB_TYPE ir_codes_pv951[IR_KEYTAB_SIZE];
> +extern IR_KEYTAB_TYPE ir_codes_rc2592_sat[IR_KEYTAB_SIZE];
>  extern IR_KEYTAB_TYPE ir_codes_rc5_tv[IR_KEYTAB_SIZE];
>  extern IR_KEYTAB_TYPE ir_codes_winfast[IR_KEYTAB_SIZE];
>  extern IR_KEYTAB_TYPE ir_codes_pinnacle_color[IR_KEYTAB_SIZE];
> 

