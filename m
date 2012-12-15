Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45220 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab2LOQKq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 11:10:46 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so2488164eek.19
        for <linux-media@vger.kernel.org>; Sat, 15 Dec 2012 08:10:45 -0800 (PST)
Message-ID: <50CCA112.8010405@googlemail.com>
Date: Sat, 15 Dec 2012 17:10:58 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/2] [media] em28xx: add support for NEC proto variants
 on em2874 and upper
References: <1355574552-18472-1-git-send-email-mchehab@redhat.com> <1355574552-18472-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1355574552-18472-2-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 15.12.2012 13:29, schrieb Mauro Carvalho Chehab:
> By disabling the NEC parity check, it is possible to handle all 3 NEC
> protocol variants (32, 24 or 16 bits).
>
> Change the driver in order to handle all of them.
>
> Unfortunately, em2860/em2863 provide only 16 bits for the IR scancode,
> even when NEC parity is disabled. So, this change should affect only
> em2874 and newer devices, with provides up to 32 bits for the scancode.
>
> Tested with one NEC-16, one NEC-24 and one RC5 IR.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/usb/em28xx/em28xx-input.c | 58 +++++++++++++++++++++------------
>  drivers/media/usb/em28xx/em28xx-reg.h   |  1 +
>  2 files changed, 39 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> index 660bf80..507370c 100644
> --- a/drivers/media/usb/em28xx/em28xx-input.c
> +++ b/drivers/media/usb/em28xx/em28xx-input.c
> @@ -57,8 +57,8 @@ MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
>  struct em28xx_ir_poll_result {
>  	unsigned int toggle_bit:1;
>  	unsigned int read_count:7;
> -	u8 rc_address;
> -	u8 rc_data[4]; /* 1 byte on em2860/2880, 4 on em2874 */
> +
> +	u32 scancode;
>  };
>  
>  struct em28xx_IR {
> @@ -72,6 +72,7 @@ struct em28xx_IR {
>  	struct delayed_work work;
>  	unsigned int full_code:1;
>  	unsigned int last_readcount;
> +	u64 rc_type;
>  
>  	int  (*get_key)(struct em28xx_IR *, struct em28xx_ir_poll_result *);
>  };
> @@ -236,11 +237,8 @@ static int default_polling_getkey(struct em28xx_IR *ir,
>  	/* Infrared read count (Reg 0x45[6:0] */
>  	poll_result->read_count = (msg[0] & 0x7f);
>  
> -	/* Remote Control Address (Reg 0x46) */
> -	poll_result->rc_address = msg[1];
> -
> -	/* Remote Control Data (Reg 0x47) */
> -	poll_result->rc_data[0] = msg[2];
> +	/* Remote Control Address/Data (Regs 0x46/0x47) */
> +	poll_result->scancode = msg[1] << 8 | msg[2];
>  
>  	return 0;
>  }
> @@ -266,13 +264,32 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
>  	/* Infrared read count (Reg 0x51[6:0] */
>  	poll_result->read_count = (msg[0] & 0x7f);
>  
> -	/* Remote Control Address (Reg 0x52) */
> -	poll_result->rc_address = msg[1];
> -
> -	/* Remote Control Data (Reg 0x53-55) */
> -	poll_result->rc_data[0] = msg[2];
> -	poll_result->rc_data[1] = msg[3];
> -	poll_result->rc_data[2] = msg[4];
> +	/*
> +	 * Remote Control Address (Reg 0x52)
> +	 * Remote Control Data (Reg 0x53-0x55)
> +	 */

Should be

+	/*
+	 * Remote Control Scan Code (Reg 0x52-0x55)
+	 */

> +	switch (ir->rc_type) {
> +	case RC_BIT_RC5:
> +		poll_result->scancode = msg[1] << 8 | msg[2];
> +		break;
> +	case RC_BIT_NEC:
> +		if ((msg[3] ^ msg[4]) != 0xff)		/* 32 bits NEC */
> +			poll_result->scancode = (msg[1] << 24) |
> +						(msg[2] << 16) |
> +						(msg[3] << 8)  |
> +						 msg[4];
> +		else if ((msg[1] ^ msg[2]) != 0xff)	/* 24 bits NEC */
> +			poll_result->scancode = (msg[1] << 16) |
> +						(msg[2] << 8)  |
> +						 msg[3];
> +		else					/* Normal NEC */
> +			poll_result->scancode = msg[1] << 8 | msg[3];
> +		break;
> +	default:
> +		poll_result->scancode = (msg[1] << 24) | (msg[2] << 16) |
> +					(msg[3] << 8)  | msg[4];
> +		break;
> +	}
>  
>  	return 0;
>  }
> @@ -294,17 +311,16 @@ static void em28xx_ir_handle_key(struct em28xx_IR *ir)
>  	}
>  
>  	if (unlikely(poll_result.read_count != ir->last_readcount)) {
> -		dprintk("%s: toggle: %d, count: %d, key 0x%02x%02x\n", __func__,
> +		dprintk("%s: toggle: %d, count: %d, key 0x%04x\n", __func__,
>  			poll_result.toggle_bit, poll_result.read_count,
> -			poll_result.rc_address, poll_result.rc_data[0]);
> +			poll_result.scancode);
>  		if (ir->full_code)
>  			rc_keydown(ir->rc,
> -				   poll_result.rc_address << 8 |
> -				   poll_result.rc_data[0],
> +				   poll_result.scancode,
>  				   poll_result.toggle_bit);
>  		else
>  			rc_keydown(ir->rc,
> -				   poll_result.rc_data[0],
> +				   poll_result.scancode & 0xff,
>  				   poll_result.toggle_bit);
>  
>  		if (ir->dev->chip_id == CHIP_ID_EM2874 ||
> @@ -360,12 +376,14 @@ static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
>  		*rc_type = RC_BIT_RC5;
>  	} else if (*rc_type & RC_BIT_NEC) {
>  		dev->board.xclk &= ~EM28XX_XCLK_IR_RC5_MODE;
> -		ir_config = EM2874_IR_NEC;
> +		ir_config = EM2874_IR_NEC | EM2874_IR_NEC_NO_PARITY;
>  		ir->full_code = 1;
>  		*rc_type = RC_BIT_NEC;
>  	} else if (*rc_type != RC_BIT_UNKNOWN)
>  		rc = -EINVAL;
>  
> +	ir->rc_type = *rc_type;
> +
This is actually a bug fix, right ?

The patch looks good.

Regards,
Frank

>  	em28xx_write_reg_bits(dev, EM28XX_R0F_XCLK, dev->board.xclk,
>  			      EM28XX_XCLK_IR_RC5_MODE);
>  
> diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
> index 6ff3682..2ad3573 100644
> --- a/drivers/media/usb/em28xx/em28xx-reg.h
> +++ b/drivers/media/usb/em28xx/em28xx-reg.h
> @@ -177,6 +177,7 @@
>  
>  /* em2874 IR config register (0x50) */
>  #define EM2874_IR_NEC           0x00
> +#define EM2874_IR_NEC_NO_PARITY 0x01
>  #define EM2874_IR_RC5           0x04
>  #define EM2874_IR_RC6_MODE_0    0x08
>  #define EM2874_IR_RC6_MODE_6A   0x0b

