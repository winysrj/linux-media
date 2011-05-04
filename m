Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:7345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab1EDPQW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2011 11:16:22 -0400
Message-ID: <4DC16DC1.1060109@redhat.com>
Date: Wed, 04 May 2011 12:16:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org, jarod@wilsonet.com
Subject: Re: [PATCH 07/10] rc-core: use the full 32 bits for NEC scancodes
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu> <20110428151348.8272.50675.stgit@felix.hardeman.nu>
In-Reply-To: <20110428151348.8272.50675.stgit@felix.hardeman.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 28-04-2011 12:13, David Härdeman escreveu:
> Using the full 32 bits for all kinds of NEC scancodes simplifies rc-core
> and the nec decoder without any loss of functionality.


This seems to be a good strategy. However, it breaks the existing NEC keymap
tables (/me is not considering patch 6/10 macros), and changes those keytables
on userspace. Not sure how to address this.

Comments?

Thanks,
Mauro.

> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/dvb/dvb-usb/af9015.c |   22 ++++++----------------
>  drivers/media/rc/ir-nec-decoder.c  |   28 ++++------------------------
>  include/media/rc-map.h             |   11 +++++++++--
>  3 files changed, 19 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
> index 08975f3..4ee8bb7 100644
> --- a/drivers/media/dvb/dvb-usb/af9015.c
> +++ b/drivers/media/dvb/dvb-usb/af9015.c
> @@ -1034,7 +1034,8 @@ static int af9015_rc_query(struct dvb_usb_device *d)
>  	if ((priv->rc_repeat != buf[6] || buf[0]) &&
>  					!memcmp(&buf[12], priv->rc_last, 4)) {
>  		deb_rc("%s: key repeated\n", __func__);
> -		rc_keydown(d->rc_dev, RC_TYPE_NEC, priv->rc_keycode, 0);
> +		rc_keydown(d->rc_dev, RC_TYPE_NEC,
> +			   RC_SCANCODE_NEC32(priv->rc_keycode), 0);
>  		priv->rc_repeat = buf[6];
>  		return ret;
>  	}
> @@ -1051,21 +1052,10 @@ static int af9015_rc_query(struct dvb_usb_device *d)
>  
>  		/* Remember this key */
>  		memcpy(priv->rc_last, &buf[12], 4);
> -		if (buf[14] == (u8) ~buf[15]) {
> -			if (buf[12] == (u8) ~buf[13]) {
> -				/* NEC */
> -				priv->rc_keycode = buf[12] << 8 | buf[14];
> -			} else {
> -				/* NEC extended*/
> -				priv->rc_keycode = buf[12] << 16 |
> -					buf[13] << 8 | buf[14];
> -			}
> -		} else {
> -			/* 32 bit NEC */
> -			priv->rc_keycode = buf[12] << 24 | buf[13] << 16 |
> -					buf[14] << 8 | buf[15];
> -		}
> -		rc_keydown(d->rc_dev, RC_TYPE_NEC, priv->rc_keycode, 0);
> +		priv->rc_keycode = buf[12] << 24 | buf[13] << 16 |
> +				   buf[14] << 8  | buf[15];
> +		rc_keydown(d->rc_dev, RC_TYPE_NEC,
> +			   RC_SCANCODE_NEC32(priv->rc_keycode), 0);
>  	} else {
>  		deb_rc("%s: no key press\n", __func__);
>  		/* Invalidate last keypress */
> diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
> index edd8543..0b1eef1 100644
> --- a/drivers/media/rc/ir-nec-decoder.c
> +++ b/drivers/media/rc/ir-nec-decoder.c
> @@ -49,7 +49,6 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	struct nec_dec *data = &dev->raw->nec;
>  	u32 scancode;
>  	u8 address, not_address, command, not_command;
> -	bool send_32bits = false;
>  
>  	if (!(dev->enabled_protocols & RC_BIT_NEC))
>  		return 0;
> @@ -162,33 +161,14 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		command	    = bitrev8((data->bits >>  8) & 0xff);
>  		not_command = bitrev8((data->bits >>  0) & 0xff);
>  
> -		if ((command ^ not_command) != 0xff) {
> -			IR_dprintk(1, "NEC checksum error: received 0x%08x\n",
> -				   data->bits);
> -			send_32bits = true;
> -		}
> -
> -		if (send_32bits) {
> -			/* NEC transport, but modified protocol, used by at
> -			 * least Apple and TiVo remotes */
> -			scancode = data->bits;
> -			IR_dprintk(1, "NEC (modified) scancode 0x%08x\n", scancode);
> -		} else if ((address ^ not_address) != 0xff) {
> -			/* Extended NEC */
> -			scancode = address     << 16 |
> -				   not_address <<  8 |
> -				   command;
> -			IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);
> -		} else {
> -			/* Normal NEC */
> -			scancode = address << 8 | command;
> -			IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
> -		}
> +		scancode = address << 24 | not_address << 16 |
> +			   command << 8  | not_command;
> +		IR_dprintk(1, "NEC scancode 0x%08x\n", scancode);
>  
>  		if (data->is_nec_x)
>  			data->necx_repeat = true;
>  
> -		rc_keydown(dev, RC_TYPE_NEC, scancode, 0);
> +		rc_keydown(dev, RC_TYPE_NEC, RC_SCANCODE_NEC32(scancode), 0);
>  		data->state = STATE_INACTIVE;
>  		return 0;
>  	}
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index 42c8ad9..aa503f0 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -44,8 +44,15 @@
>  
>  #define RC_SCANCODE_UNKNOWN(x) (x)
>  #define RC_SCANCODE_OTHER(x) (x)
> -#define RC_SCANCODE_NEC(addr, cmd) (((addr) << 8) | (cmd))
> -#define RC_SCANCODE_NECX(addr, cmd) (((addr) << 8) | (cmd))
> +#define RC_SCANCODE_NEC(addr, cmd)  \
> +	((( (addr) & 0xff) << 24) | \
> +	 ((~(addr) & 0xff) << 16) | \
> +	 (( (cmd)  & 0xff) << 8 ) | \
> +	 ((~(cmd)  & 0xff) << 0 ))
> +#define RC_SCANCODE_NECX(addr, cmd)   \
> +	((( (addr) & 0xffff) << 16) | \
> +	 (( (cmd)  & 0x00ff) << 8)  | \
> +	 ((~(cmd)  & 0x00ff) << 0))
>  #define RC_SCANCODE_NEC32(data) ((data) & 0xffffffff)
>  #define RC_SCANCODE_RC5(sys, cmd) (((sys) << 8) | (cmd))
>  #define RC_SCANCODE_RC5_SZ(sys, cmd) (((sys) << 8) | (cmd))
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

