Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36580 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933583AbbENU5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 16:57:45 -0400
Date: Thu, 14 May 2015 17:57:39 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] rc-core: use the full 32 bits for NEC scancodes
Message-ID: <20150514175739.45ee6fd7@recife.lan>
In-Reply-To: <20150406112308.23209.85627.stgit@zeus.muc.hardeman.nu>
References: <20150406112204.23209.27664.stgit@zeus.muc.hardeman.nu>
	<20150406112308.23209.85627.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 06 Apr 2015 13:23:08 +0200
David Härdeman <david@hardeman.nu> escreveu:

> Using the full 32 bits for all kinds of NEC scancodes simplifies rc-core
> and the nec decoder without any loss of functionality. At the same time
> it ensures that scancodes for NEC16/NEC24/NEC32 do not overlap and
> removes any ambiguity.
> 
> For example, before this patch, consider these two NEC messages:
> NEC16 message to address 0x05, command 0x03
> NEC24 message to address 0x0005, command 0x03
> 
> They'll both have scancode 0x00000503, and there's no way to tell which
> message was received.
> 
> In order to maintain backwards compatibility, some heuristics are added
> in rc-main.c to convert scancodes to NEC32 as necessary when userspace
> adds entries to the keytable using the regular input ioctls.
> 
> No conversion will be made for the newer "rc_keymap_entry" based ioctls
> (see the next patch).
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>

Checkpatch has something to say about this patch:

WARNING: else is not generally useful after a break or return
#140: FILE: drivers/media/rc/rc-main.c:357:
+		return b3 << 24 | b2 << 16 |  b1 << 8 | ((u8)~b1);
+	else

WARNING: line over 80 characters
#259: FILE: drivers/media/usb/dvb-usb-v2/af9035.c:1778:
+		   RC_SCANCODE_NEC32(b[0] << 24 | b[1] << 16 | b[2] << 8 | b[3]),

ERROR: space prohibited after that open parenthesis '('
#479: FILE: include/media/rc-map.h:79:
+	((( (addr) & 0xff) << 24) | \

ERROR: space prohibited after that open parenthesis '('
#481: FILE: include/media/rc-map.h:81:
+	 (( (cmd)  & 0xff) << 8 ) | \

ERROR: space prohibited before that close parenthesis ')'
#481: FILE: include/media/rc-map.h:81:
+	 (( (cmd)  & 0xff) << 8 ) | \

ERROR: space prohibited before that close parenthesis ')'
#482: FILE: include/media/rc-map.h:82:
+	 ((~(cmd)  & 0xff) << 0 ))

ERROR: space prohibited after that open parenthesis '('
#484: FILE: include/media/rc-map.h:84:
+	((( (addr) & 0xffff) << 16) | \

ERROR: space prohibited after that open parenthesis '('
#485: FILE: include/media/rc-map.h:85:
+	 (( (cmd)  & 0x00ff) << 8)  | \




> ---
>  drivers/media/rc/ir-nec-decoder.c        |   26 ++------------
>  drivers/media/rc/rc-main.c               |   54 +++++++++++++++++++++++++++++-
>  drivers/media/usb/dvb-usb-v2/af9015.c    |   22 ++----------
>  drivers/media/usb/dvb-usb-v2/af9035.c    |   25 +++-----------
>  drivers/media/usb/dvb-usb-v2/az6007.c    |   16 ++-------
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c  |   20 +++--------
>  drivers/media/usb/dvb-usb/dib0700_core.c |   24 +++----------
>  drivers/media/usb/em28xx/em28xx-input.c  |   37 +++++----------------
>  include/media/rc-map.h                   |   16 +++++++--
>  9 files changed, 102 insertions(+), 138 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
> index 7b81fec..16907c1 100644
> --- a/drivers/media/rc/ir-nec-decoder.c
> +++ b/drivers/media/rc/ir-nec-decoder.c
> @@ -50,7 +50,6 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	struct nec_dec *data = &dev->raw->nec;
>  	u32 scancode;
>  	u8 address, not_address, command, not_command;
> -	bool send_32bits = false;
>  
>  	if (!(dev->enabled_protocols & RC_BIT_NEC))
>  		return 0;
> @@ -163,28 +162,9 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
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
> +		scancode = RC_SCANCODE_NEC32(address << 24 | not_address << 16 |
> +					     command << 8  | not_command);
> +		IR_dprintk(1, "NEC scancode 0x%08x\n", scancode);
>  
>  		if (data->is_nec_x)
>  			data->necx_repeat = true;
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index d068c4e..3379379 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -317,6 +317,49 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
>  }
>  
>  /**
> + * guess_protocol() - heuristics to guess the protocol for a scancode
> + * @rdev:	the struct rc_dev device descriptor
> + * @return:	the guessed RC_TYPE_* protocol
> + *
> + * Internal routine to guess the current IR protocol for legacy ioctls.
> + */
> +static inline enum rc_type guess_protocol(struct rc_dev *rdev)
> +{
> +	struct rc_map *rc_map = &rdev->rc_map;
> +
> +	if (hweight64(rdev->enabled_protocols) == 1)
> +		return rc_bitmap_to_type(rdev->enabled_protocols);
> +	else if (hweight64(rdev->allowed_protocols) == 1)
> +		return rc_bitmap_to_type(rdev->allowed_protocols);
> +	else
> +		return rc_map->rc_type;
> +}
> +
> +/**
> + * to_nec32() - helper function to try to convert misc NEC scancodes to NEC32
> + * @orig:	original scancode
> + * @return:	NEC32 scancode
> + *
> + * This helper routine is used to provide backwards compatibility.
> + */
> +static u64 to_nec32(u64 orig)
> +{
> +	u8 b3 = (u8)(orig >> 16);
> +	u8 b2 = (u8)(orig >>  8);
> +	u8 b1 = (u8)(orig >>  0);
> +
> +	if (orig <= 0xffff)
> +		/* Plain old NEC */
> +		return b2 << 24 | ((u8)~b2) << 16 |  b1 << 8 | ((u8)~b1);
> +	else if (orig <= 0xffffff)
> +		/* NEC extended */
> +		return b3 << 24 | b2 << 16 |  b1 << 8 | ((u8)~b1);
> +	else
> +		/* NEC32 */
> +		return orig;
> +}
> +
> +/**
>   * ir_setkeycode() - set a keycode in the scancode->keycode table
>   * @idev:	the struct input_dev device descriptor
>   * @scancode:	the desired scancode
> @@ -349,6 +392,9 @@ static int ir_setkeycode(struct input_dev *idev,
>  		if (retval)
>  			goto out;
>  
> +		if (guess_protocol(rdev) == 0
> +			scancode = to_nec32(scancode);

This function can be called from userspace. I can't see how this would do
the right thing if more than one protocol is enabled. 

> +
>  		index = ir_establish_scancode(rdev, rc_map, scancode, true);
>  		if (index >= rc_map->len) {
>  			retval = -ENOMEM;
> @@ -389,7 +435,10 @@ static int ir_setkeytable(struct rc_dev *dev,
>  
>  	for (i = 0; i < from->size; i++) {
>  		index = ir_establish_scancode(dev, rc_map,
> -					      from->scan[i].scancode, false);
> +					      from->rc_type == RC_TYPE_NEC ?
> +					      to_nec32(from->scan[i].scancode) :
> +					      from->scan[i].scancode,
> +					      false);
>  		if (index >= rc_map->len) {
>  			rc = -ENOMEM;
>  			break;
> @@ -463,6 +512,8 @@ static int ir_getkeycode(struct input_dev *idev,
>  		if (retval)
>  			goto out;
>  
> +		if (guess_protocol(rdev) == RC_TYPE_NEC)
> +			scancode = to_nec32(scancode);

This also can be called from userspace. It should not return different
scancodes for the same mapping if just NEC is enabled or if more protocols 
are enabled.

>  		index = ir_lookup_by_scancode(rc_map, scancode);
>  	}
>  
> @@ -660,7 +711,6 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
>  
>  		led_trigger_event(led_feedback, LED_FULL);
>  	}
> -
>  	input_sync(dev->input_dev);
>  }
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
> index 16c0b7d..4cc1463 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9015.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9015.c
> @@ -1230,24 +1230,10 @@ static int af9015_rc_query(struct dvb_usb_device *d)
>  
>  		/* Remember this key */
>  		memcpy(state->rc_last, &buf[12], 4);
> -		if (buf[14] == (u8) ~buf[15]) {
> -			if (buf[12] == (u8) ~buf[13]) {
> -				/* NEC */
> -				state->rc_keycode = RC_SCANCODE_NEC(buf[12],
> -								    buf[14]);
> -			} else {
> -				/* NEC extended*/
> -				state->rc_keycode = RC_SCANCODE_NECX(buf[12] << 8 |
> -								     buf[13],
> -								     buf[14]);
> -			}
> -		} else {
> -			/* 32 bit NEC */
> -			state->rc_keycode = RC_SCANCODE_NEC32(buf[12] << 24 |
> -							      buf[13] << 16 |
> -							      buf[14] << 8  |
> -							      buf[15]);
> -		}
> +		state->rc_keycode = RC_SCANCODE_NEC32(buf[12] << 24 |
> +						      buf[13] << 16 |
> +						      buf[14] << 8  |
> +						      buf[15]);
>  		rc_keydown(d->rc_dev, RC_TYPE_NEC, state->rc_keycode, 0);
>  	} else {
>  		dev_dbg(&d->udev->dev, "%s: no key press\n", __func__);
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index 80a29f5..6c00233 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -1763,9 +1763,8 @@ err:
>  static int af9035_rc_query(struct dvb_usb_device *d)
>  {
>  	int ret;
> -	u32 key;
> -	u8 buf[4];
> -	struct usb_req req = { CMD_IR_GET, 0, 0, NULL, 4, buf };
> +	u8 b[4];
> +	struct usb_req req = { CMD_IR_GET, 0, 0, NULL, 4, b };
>  
>  	ret = af9035_ctrl_msg(d, &req);
>  	if (ret == 1)
> @@ -1773,23 +1772,11 @@ static int af9035_rc_query(struct dvb_usb_device *d)
>  	else if (ret < 0)
>  		goto err;
>  
> -	if ((buf[2] + buf[3]) == 0xff) {
> -		if ((buf[0] + buf[1]) == 0xff) {
> -			/* NEC standard 16bit */
> -			key = RC_SCANCODE_NEC(buf[0], buf[2]);
> -		} else {
> -			/* NEC extended 24bit */
> -			key = RC_SCANCODE_NECX(buf[0] << 8 | buf[1], buf[2]);
> -		}
> -	} else {
> -		/* NEC full code 32bit */
> -		key = RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |
> -					buf[2] << 8  | buf[3]);
> -	}
> -
> -	dev_dbg(&d->udev->dev, "%s: %*ph\n", __func__, 4, buf);
> +	dev_dbg(&d->udev->dev, "%s: %*ph\n", __func__, 4, b);
>  
> -	rc_keydown(d->rc_dev, RC_TYPE_NEC, key, 0);
> +	rc_keydown(d->rc_dev, RC_TYPE_NEC,
> +		   RC_SCANCODE_NEC32(b[0] << 24 | b[1] << 16 | b[2] << 8 | b[3]),
> +		   0);
>  
>  	return 0;
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
> index 935dbaa..7e38278 100644
> --- a/drivers/media/usb/dvb-usb-v2/az6007.c
> +++ b/drivers/media/usb/dvb-usb-v2/az6007.c
> @@ -214,18 +214,10 @@ static int az6007_rc_query(struct dvb_usb_device *d)
>  	if (st->data[1] == 0x44)
>  		return 0;
>  
> -	if ((st->data[3] ^ st->data[4]) == 0xff) {
> -		if ((st->data[1] ^ st->data[2]) == 0xff)
> -			code = RC_SCANCODE_NEC(st->data[1], st->data[3]);
> -		else
> -			code = RC_SCANCODE_NECX(st->data[1] << 8 | st->data[2],
> -						st->data[3]);
> -	} else {
> -		code = RC_SCANCODE_NEC32(st->data[1] << 24 |
> -					 st->data[2] << 16 |
> -					 st->data[3] << 8  |
> -					 st->data[4]);
> -	}
> +	code = RC_SCANCODE_NEC32(st->data[1] << 24 |
> +				 st->data[2] << 16 |
> +				 st->data[3] << 8  |
> +				 st->data[4]);
>  
>  	rc_keydown(d->rc_dev, RC_TYPE_NEC, code, st->data[5]);
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 77dcfdf..bef7b2c 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1432,7 +1432,7 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
>  	int ret, i;
>  	struct rtl28xxu_dev *dev = d->priv;
>  	u8 buf[5];
> -	u32 rc_code;
> +	u64 rc_code;
>  	struct rtl28xxu_reg_val rc_nec_tab[] = {
>  		{ 0x3033, 0x80 },
>  		{ 0x3020, 0x43 },
> @@ -1466,20 +1466,10 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
>  		goto err;
>  
>  	if (buf[4] & 0x01) {
> -		if (buf[2] == (u8) ~buf[3]) {
> -			if (buf[0] == (u8) ~buf[1]) {
> -				/* NEC standard (16 bit) */
> -				rc_code = RC_SCANCODE_NEC(buf[0], buf[2]);
> -			} else {
> -				/* NEC extended (24 bit) */
> -				rc_code = RC_SCANCODE_NECX(buf[0] << 8 | buf[1],
> -							   buf[2]);
> -			}
> -		} else {
> -			/* NEC full (32 bit) */
> -			rc_code = RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |
> -						    buf[2] << 8  | buf[3]);
> -		}
> +		rc_code = RC_SCANCODE_NEC32(buf[0] << 24 |
> +					    buf[1] << 16 |
> +					    buf[2] << 8  |
> +					    buf[3]);
>  
>  		rc_keydown(d->rc_dev, RC_TYPE_NEC, rc_code, 0);
>  
> diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
> index 605b090..2b059ca 100644
> --- a/drivers/media/usb/dvb-usb/dib0700_core.c
> +++ b/drivers/media/usb/dvb-usb/dib0700_core.c
> @@ -722,26 +722,14 @@ static void dib0700_rc_urb_completion(struct urb *purb)
>  		    poll_reply->nec.data       == 0x00 &&
>  		    poll_reply->nec.not_data   == 0xff) {
>  			poll_reply->data_state = 2;
> -			break;
> +			rc_repeat(d->rc_dev);
> +			goto resubmit;
>  		}
>  
> -		if ((poll_reply->nec.data ^ poll_reply->nec.not_data) != 0xff) {
> -			deb_data("NEC32 protocol\n");
> -			keycode = RC_SCANCODE_NEC32(poll_reply->nec.system     << 24 |
> -						     poll_reply->nec.not_system << 16 |
> -						     poll_reply->nec.data       << 8  |
> -						     poll_reply->nec.not_data);
> -		} else if ((poll_reply->nec.system ^ poll_reply->nec.not_system) != 0xff) {
> -			deb_data("NEC extended protocol\n");
> -			keycode = RC_SCANCODE_NECX(poll_reply->nec.system << 8 |
> -						    poll_reply->nec.not_system,
> -						    poll_reply->nec.data);
> -
> -		} else {
> -			deb_data("NEC normal protocol\n");
> -			keycode = RC_SCANCODE_NEC(poll_reply->nec.system,
> -						   poll_reply->nec.data);
> -		}
> +		keycode = RC_SCANCODE_NEC32(poll_reply->nec.system     << 24 |
> +					    poll_reply->nec.not_system << 16 |
> +					    poll_reply->nec.data       << 8  |
> +					    poll_reply->nec.not_data);
>  
>  		break;
>  	default:
> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> index 4007356..2b5c6a1 100644
> --- a/drivers/media/usb/em28xx/em28xx-input.c
> +++ b/drivers/media/usb/em28xx/em28xx-input.c
> @@ -67,7 +67,6 @@ struct em28xx_IR {
>  	/* poll decoder */
>  	int polling;
>  	struct delayed_work work;
> -	unsigned int full_code:1;
>  	unsigned int last_readcount;
>  	u64 rc_type;
>  
> @@ -258,18 +257,10 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
>  		break;
>  
>  	case RC_BIT_NEC:
> -		poll_result->protocol = RC_TYPE_RC5;
> -		poll_result->scancode = msg[1] << 8 | msg[2];
> -		if ((msg[3] ^ msg[4]) != 0xff)		/* 32 bits NEC */
> -			poll_result->scancode = RC_SCANCODE_NEC32((msg[1] << 24) |
> -								  (msg[2] << 16) |
> -								  (msg[3] << 8)  |
> -								  (msg[4]));
> -		else if ((msg[1] ^ msg[2]) != 0xff)	/* 24 bits NEC */
> -			poll_result->scancode = RC_SCANCODE_NECX(msg[1] << 8 |
> -								 msg[2], msg[3]);
> -		else					/* Normal NEC */
> -			poll_result->scancode = RC_SCANCODE_NEC(msg[1], msg[3]);
> +		poll_result->scancode = RC_SCANCODE_NEC32((msg[1] << 24) |
> +							  (msg[2] << 16) |
> +							  (msg[3] << 8)  |
> +							  (msg[4] << 0));
>  		break;
>  
>  	case RC_BIT_RC6_0:
> @@ -327,16 +318,11 @@ static void em28xx_ir_handle_key(struct em28xx_IR *ir)
>  		dprintk("%s: toggle: %d, count: %d, key 0x%04x\n", __func__,
>  			poll_result.toggle_bit, poll_result.read_count,
>  			poll_result.scancode);
> -		if (ir->full_code)
> -			rc_keydown(ir->rc,
> -				   poll_result.protocol,
> -				   poll_result.scancode,
> -				   poll_result.toggle_bit);
> -		else
> -			rc_keydown(ir->rc,
> -				   RC_TYPE_UNKNOWN,
> -				   poll_result.scancode & 0xff,
> -				   poll_result.toggle_bit);
> +
> +		rc_keydown(ir->rc,
> +			   poll_result.protocol,
> +			   poll_result.scancode,
> +			   poll_result.toggle_bit);

This hunk will break drivers. if !full_code, there are just 8 bits
for the protocol, and not 16. The table, however, may have scancodes
for 16-bits NEC.

The devices that use !full_code generally has a very crappy
micro-controller that returns only 8 bits of either RC5 or NEC.

>  
>  		if (ir->dev->chip_id == CHIP_ID_EM2874 ||
>  		    ir->dev->chip_id == CHIP_ID_EM2884)
> @@ -387,11 +373,9 @@ static int em2860_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
>  	/* Adjust xclk based on IR table for RC5/NEC tables */
>  	if (*rc_type & RC_BIT_RC5) {
>  		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
> -		ir->full_code = 1;
>  		*rc_type = RC_BIT_RC5;
>  	} else if (*rc_type & RC_BIT_NEC) {
>  		dev->board.xclk &= ~EM28XX_XCLK_IR_RC5_MODE;
> -		ir->full_code = 1;
>  		*rc_type = RC_BIT_NEC;
>  	} else if (*rc_type & RC_BIT_UNKNOWN) {
>  		*rc_type = RC_BIT_UNKNOWN;
> @@ -416,17 +400,14 @@ static int em2874_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
>  	/* Adjust xclk and set type based on IR table for RC5/NEC/RC6 tables */
>  	if (*rc_type & RC_BIT_RC5) {
>  		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
> -		ir->full_code = 1;
>  		*rc_type = RC_BIT_RC5;
>  	} else if (*rc_type & RC_BIT_NEC) {
>  		dev->board.xclk &= ~EM28XX_XCLK_IR_RC5_MODE;
>  		ir_config = EM2874_IR_NEC | EM2874_IR_NEC_NO_PARITY;
> -		ir->full_code = 1;
>  		*rc_type = RC_BIT_NEC;
>  	} else if (*rc_type & RC_BIT_RC6_0) {
>  		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
>  		ir_config = EM2874_IR_RC6_MODE_0;
> -		ir->full_code = 1;
>  		*rc_type = RC_BIT_RC6_0;
>  	} else if (*rc_type & RC_BIT_UNKNOWN) {
>  		*rc_type = RC_BIT_UNKNOWN;
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index e7a1514..d0bbfc1 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -34,6 +34,8 @@ enum rc_type {
>  	RC_TYPE_XMP		= 19,	/* XMP protocol */
>  };
>  
> +#define rc_bitmap_to_type(x) (fls64(x) - 1)
> +
>  #define RC_BIT_NONE		0
>  #define RC_BIT_UNKNOWN		(1 << RC_TYPE_UNKNOWN)
>  #define RC_BIT_OTHER		(1 << RC_TYPE_OTHER)
> @@ -68,14 +70,22 @@ enum rc_type {
>  
>  #define RC_SCANCODE_UNKNOWN(x)			(x)
>  #define RC_SCANCODE_OTHER(x)			(x)
> -#define RC_SCANCODE_NEC(addr, cmd)		(((addr) << 8) | (cmd))
> -#define RC_SCANCODE_NECX(addr, cmd)		(((addr) << 8) | (cmd))
> -#define RC_SCANCODE_NEC32(data)			((data) & 0xffffffff)
>  #define RC_SCANCODE_RC5(sys, cmd)		(((sys) << 8) | (cmd))
>  #define RC_SCANCODE_RC5_SZ(sys, cmd)		(((sys) << 8) | (cmd))
>  #define RC_SCANCODE_RC6_0(sys, cmd)		(((sys) << 8) | (cmd))
>  #define RC_SCANCODE_RC6_6A(vendor, sys, cmd)	(((vendor) << 16) | ((sys) << 8) | (cmd))
>  
> +#define RC_SCANCODE_NEC(addr, cmd)  \
> +	((( (addr) & 0xff) << 24) | \
> +	 ((~(addr) & 0xff) << 16) | \
> +	 (( (cmd)  & 0xff) << 8 ) | \
> +	 ((~(cmd)  & 0xff) << 0 ))
> +#define RC_SCANCODE_NECX(addr, cmd)   \
> +	((( (addr) & 0xffff) << 16) | \
> +	 (( (cmd)  & 0x00ff) << 8)  | \
> +	 ((~(cmd)  & 0x00ff) << 0))
> +#define RC_SCANCODE_NEC32(data) ((data) & 0xffffffff)
> +
>  struct rc_map_table {
>  	u32	scancode;
>  	u32	keycode;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
