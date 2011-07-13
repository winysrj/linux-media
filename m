Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab1GMWbQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 18:31:16 -0400
Message-ID: <4E1E1CA7.5090004@redhat.com>
Date: Wed, 13 Jul 2011 19:31:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Juergen Lock <nox@jelal.kn-bremen.de>
CC: linux-media@vger.kernel.org, hselasky@c2i.net
Subject: Re: [PATCH] pctv452e.c: switch rc handling to rc.core
References: <20110625193427.GA66720@triton8.kn-bremen.de>
In-Reply-To: <20110625193427.GA66720@triton8.kn-bremen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-06-2011 16:34, Juergen Lock escreveu:
> This is on top of the submitted pctv452e.c driver and was done similar
> to how ttusb2 works.  Tested with lirc (devinput) and ir-keytable(1).

You should submit pctv452e driver first, otherwise I can't apply
this one ;)

Regards,
Mauro

> 
> Signed-off-by: Juergen Lock <nox@jelal.kn-bremen.de>
> 
> --- a/drivers/media/dvb/dvb-usb/pctv452e.c
> +++ b/drivers/media/dvb/dvb-usb/pctv452e.c
> @@ -98,6 +98,7 @@ struct pctv452e_state {
>  
>  	u8 c;	   /* transaction counter, wraps around...  */
>  	u8 initialized; /* set to 1 if 0x15 has been sent */
> +	u16 last_rc_key;
>  };
>  
>  static int
> @@ -535,83 +536,10 @@ int pctv452e_power_ctrl(struct dvb_usb_d
>  	return 0;
>  }
>  
> -/* Remote control stuff */
> -static struct rc_map_table pctv452e_rc_keys[] = {
> -	{0x0700, KEY_MUTE},
> -	{0x0701, KEY_VENDOR},  // pinnacle logo (top middle)
> -	{0x0739, KEY_POWER},
> -	{0x0703, KEY_VOLUMEUP},
> -	{0x0709, KEY_VOLUMEDOWN},
> -	{0x0706, KEY_CHANNELUP},
> -	{0x070c, KEY_CHANNELDOWN},
> -	{0x070f, KEY_1},
> -	{0x0715, KEY_2},
> -	{0x0710, KEY_3},
> -	{0x0718, KEY_4},
> -	{0x071b, KEY_5},
> -	{0x071e, KEY_6},
> -	{0x0711, KEY_7},
> -	{0x0721, KEY_8},
> -	{0x0712, KEY_9},
> -	{0x0727, KEY_0},
> -	{0x0724, KEY_TV}, // left of '0'
> -	{0x072a, KEY_T}, // right of '0'
> -	{0x072d, KEY_REWIND},
> -	{0x0733, KEY_FORWARD},
> -	{0x0730, KEY_PLAY},
> -	{0x0736, KEY_RECORD},
> -	{0x073c, KEY_STOP},
> -	{0x073f, KEY_HELP}
> -};
> -
> -/* Remote Control Stuff fo S2-3600 (copied from TT-S1500): */
> -static struct rc_map_table tt_connect_s2_3600_rc_key[] = {
> -	{0x1501, KEY_POWER},
> -	{0x1502, KEY_SHUFFLE}, /* ? double-arrow key */
> -	{0x1503, KEY_1},
> -	{0x1504, KEY_2},
> -	{0x1505, KEY_3},
> -	{0x1506, KEY_4},
> -	{0x1507, KEY_5},
> -	{0x1508, KEY_6},
> -	{0x1509, KEY_7},
> -	{0x150a, KEY_8},
> -	{0x150b, KEY_9},
> -	{0x150c, KEY_0},
> -	{0x150d, KEY_UP},
> -	{0x150e, KEY_LEFT},
> -	{0x150f, KEY_OK},
> -	{0x1510, KEY_RIGHT},
> -	{0x1511, KEY_DOWN},
> -	{0x1512, KEY_INFO},
> -	{0x1513, KEY_EXIT},
> -	{0x1514, KEY_RED},
> -	{0x1515, KEY_GREEN},
> -	{0x1516, KEY_YELLOW},
> -	{0x1517, KEY_BLUE},
> -	{0x1518, KEY_MUTE},
> -	{0x1519, KEY_TEXT},
> -	{0x151a, KEY_MODE},  /* ? TV/Radio */
> -	{0x1521, KEY_OPTION},
> -	{0x1522, KEY_EPG},
> -	{0x1523, KEY_CHANNELUP},
> -	{0x1524, KEY_CHANNELDOWN},
> -	{0x1525, KEY_VOLUMEUP},
> -	{0x1526, KEY_VOLUMEDOWN},
> -	{0x1527, KEY_SETUP},
> -	{0x153a, KEY_RECORD},/* these keys are only in the black remote */
> -	{0x153b, KEY_PLAY},
> -	{0x153c, KEY_STOP},
> -	{0x153d, KEY_REWIND},
> -	{0x153e, KEY_PAUSE},
> -	{0x153f, KEY_FORWARD}
> -};
> -
> -static int pctv452e_rc_query(struct dvb_usb_device *d, u32 *keyevent, int *keystate) {
> +static int pctv452e_rc_query(struct dvb_usb_device *d) {
>  	struct pctv452e_state *state = (struct pctv452e_state *)d->priv;
>  	u8 b[CMD_BUFFER_SIZE];
>  	u8 rx[PCTV_ANSWER_LEN];
> -	u8 keybuf[5];
>  	int ret, i;
>  	u8 id = state->c++;
>  
> @@ -621,8 +549,6 @@ static int pctv452e_rc_query(struct dvb_
>  	b[2] = PCTV_CMD_IR;
>  	b[3] = 0;
>  
> -	*keystate = REMOTE_NO_KEY_PRESSED;
> -
>  	/* send ir request */
>  	ret = dvb_usb_generic_rw(d, b, 4, rx, PCTV_ANSWER_LEN, 0);
>  	if (ret != 0) return ret;
> @@ -637,16 +563,14 @@ static int pctv452e_rc_query(struct dvb_
>  
>  	if ((rx[3] == 9) &&  (rx[12] & 0x01)) {
>  		/* got a "press" event */
> +		state->last_rc_key = (rx[7] << 8) | rx[6];
>  		if (debug > 2) {
>  	 		printk("%s: cmd=0x%02x sys=0x%02x\n", __func__, rx[6], rx[7]);
>  		}
> -		keybuf[0] = 0x01;// DVB_USB_RC_NEC_KEY_PRESSED; why is this #define'd privately?
> -		keybuf[1] = rx[7];
> -		keybuf[2] = ~keybuf[1]; // fake checksum
> -		keybuf[3] = rx[6];
> -		keybuf[4] = ~keybuf[3]; // fake checksum
> -		dvb_usb_nec_rc_key_to_event(d, keybuf, keyevent, keystate);
> -
> +		rc_keydown(d->rc_dev, state->last_rc_key, 0);
> +	} else if (state->last_rc_key) {
> +		rc_keyup(d->rc_dev);
> +		state->last_rc_key = 0;
>  	}
>  
>  	return 0;
> @@ -1294,11 +1218,11 @@ static struct dvb_usb_device_properties 
>  	/* Untested. */
>  	/* .read_mac_address = pctv452e_read_mac_address, */
>  
> -	.rc.legacy = {
> -		.rc_map_table     = pctv452e_rc_keys,
> -		.rc_map_size      = ARRAY_SIZE(pctv452e_rc_keys),
> +	.rc.core = {
> +		.rc_interval      = 100, /* Less than IR_KEYPRESS_TIMEOUT */
> +		.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  		.rc_query         = pctv452e_rc_query,
> -		.rc_interval      = 100,
> +		.allowed_protos   = RC_TYPE_UNKNOWN,
>  	},
>  
>  	.num_adapters     = 1,
> @@ -1352,11 +1276,11 @@ static struct dvb_usb_device_properties 
>  	.power_ctrl		= pctv452e_power_ctrl,
>  	.read_mac_address	= pctv452e_read_mac_address,
>  
> -	.rc.legacy = {
> -		.rc_map_table   = tt_connect_s2_3600_rc_key,
> -		.rc_map_size    = ARRAY_SIZE(tt_connect_s2_3600_rc_key),
> -		.rc_query       = pctv452e_rc_query,
> -		.rc_interval    = 500,
> +	.rc.core = {
> +		.rc_interval      = 100, /* Less than IR_KEYPRESS_TIMEOUT */
> +		.rc_codes         = RC_MAP_TT_1500,
> +		.rc_query         = pctv452e_rc_query,
> +		.allowed_protos   = RC_TYPE_UNKNOWN,
>  	},
>  
>  	.num_adapters		= 1,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

