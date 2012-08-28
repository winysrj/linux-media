Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36948 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab2H1BTZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Aug 2012 21:19:25 -0400
Message-ID: <503C1C8B.8010502@iki.fi>
Date: Tue, 28 Aug 2012 04:19:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: linux-media@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH] v2 Add support to Avermedia Twinstar double tuner in
 af9035
References: <21730276.nBhNp4UZ8D@jar7.dominio>
In-Reply-To: <21730276.nBhNp4UZ8D@jar7.dominio>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
this is not final review, as there was more things to check I was first 
thinking. I have to look it tomorrow too. But few comments still.

On 08/27/2012 01:25 AM, Jose Alberto Reguero wrote:
> This patch add support to the Avermedia Twinstar double tuner in the af9035
> driver. Version 2 of the patch with suggestions of Antti.
>
> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
>
> Jose Alberto
>
> diff -upr linux/drivers/media/dvb-frontends/af9033.c linux.new/drivers/media/dvb-frontends/af9033.c
> --- linux/drivers/media/dvb-frontends/af9033.c	2012-08-14 05:45:22.000000000 +0200
> +++ linux.new/drivers/media/dvb-frontends/af9033.c	2012-08-26 23:38:10.527070150 +0200
> @@ -51,6 +51,8 @@ static int af9033_wr_regs(struct af9033_
>   	};
>
>   	buf[0] = (reg >> 16) & 0xff;
> +	if (state->cfg.ts_mode == AF9033_TS_MODE_SERIAL)
> +		buf[0] |= 0x10;
>   	buf[1] = (reg >>  8) & 0xff;
>   	buf[2] = (reg >>  0) & 0xff;
>   	memcpy(&buf[3], val, len);
> @@ -87,6 +89,9 @@ static int af9033_rd_regs(struct af9033_
>   		}
>   	};
>
> +	if (state->cfg.ts_mode == AF9033_TS_MODE_SERIAL)
> +		buf[0] |= 0x10;
> +

I don't like that if TS mode serial then tweak address bytes.

I looked those from the sniff and it looks like that bit is used as a 
mail box pointing out if chip is on secondary bus. Imagine it as a 
situation there is two I2C bus, 1st demod is on bus#0 and 2nd demod is 
on bus#1. Such kind of info does not belong here - correct place is 
I2C-adapter or even register multiple adapters.


>   	ret = i2c_transfer(state->i2c, msg, 2);
>   	if (ret == 2) {
>   		ret = 0;
> @@ -325,6 +330,18 @@ static int af9033_init(struct dvb_fronte
>   		if (ret < 0)
>   			goto err;
>   	}
> +
> +	if (state->cfg.ts_mode == AF9033_TS_MODE_SERIAL) {
> +		ret = af9033_wr_reg_mask(state, 0x00d91c, 0x01, 0x01);
> +		if (ret < 0)
> +			goto err;
> +		ret = af9033_wr_reg_mask(state, 0x00d917, 0x00, 0x01);
> +		if (ret < 0)
> +			goto err;
> +		ret = af9033_wr_reg_mask(state, 0x00d916, 0x00, 0x01);
> +		if (ret < 0)
> +			goto err;
> +	}

Haven't looked these yet.

>
>   	state->bandwidth_hz = 0; /* force to program all parameters */
>
> diff -upr linux/drivers/media/tuners/mxl5007t.c linux.new/drivers/media/tuners/mxl5007t.c
> --- linux/drivers/media/tuners/mxl5007t.c	2012-08-14 05:45:22.000000000 +0200
> +++ linux.new/drivers/media/tuners/mxl5007t.c	2012-08-25 19:36:44.689924518 +0200
> @@ -374,7 +374,6 @@ static struct reg_pair_t *mxl5007t_calc_
>   	mxl5007t_set_if_freq_bits(state, cfg->if_freq_hz, cfg->invert_if);
>   	mxl5007t_set_xtal_freq_bits(state, cfg->xtal_freq_hz);
>
> -	set_reg_bits(state->tab_init, 0x04, 0x01, cfg->loop_thru_enable);
>   	set_reg_bits(state->tab_init, 0x03, 0x08, cfg->clk_out_enable << 3);
>   	set_reg_bits(state->tab_init, 0x03, 0x07, cfg->clk_out_amp);
>
> @@ -531,9 +530,11 @@ static int mxl5007t_tuner_init(struct mx
>   	struct reg_pair_t *init_regs;
>   	int ret;
>
> -	ret = mxl5007t_soft_reset(state);
> -	if (mxl_fail(ret))
> -		goto fail;
> +	if (!state->config->no_reset) {
> +	 	ret = mxl5007t_soft_reset(state);
> + 		if (mxl_fail(ret))
> + 			goto fail;
> +	}

What happens if you do soft reset as normally?

I would like to mention that AF9035/AF9033/MXL5007T was supported even 
earlier that given patch in question and I can guess it has been 
working. So why you are changing it now ?

If you do these changes because what you see is different compared to 
windows sniff then you are on wrong way. Windows and Linux drivers are 
not needed to do 100% similar USB commands.

>   	/* calculate initialization reg array */
>   	init_regs = mxl5007t_calc_init_regs(state, mode);
> @@ -887,7 +888,10 @@ struct dvb_frontend *mxl5007t_attach(str
>   		if (fe->ops.i2c_gate_ctrl)
>   			fe->ops.i2c_gate_ctrl(fe, 1);
>
> -		ret = mxl5007t_get_chip_id(state);
> +		if (!state->config->no_probe)
> +			ret = mxl5007t_get_chip_id(state);

Same here. AF9015 firmware does not support reading for MXL5007T. Due to 
that, it outputs something like unknown chip revision detected but works 
as it should. Similar case here as AF9015 ?

> +
> +		ret = mxl5007t_write_reg(state, 0x04, state->config->loop_thru_enable);
>
>   		if (fe->ops.i2c_gate_ctrl)
>   			fe->ops.i2c_gate_ctrl(fe, 0);
> diff -upr linux/drivers/media/tuners/mxl5007t.h linux.new/drivers/media/tuners/mxl5007t.h
> --- linux/drivers/media/tuners/mxl5007t.h	2012-08-14 05:45:22.000000000 +0200
> +++ linux.new/drivers/media/tuners/mxl5007t.h	2012-08-25 19:38:19.990920623 +0200
> @@ -73,8 +73,10 @@ struct mxl5007t_config {
>   	enum mxl5007t_xtal_freq xtal_freq_hz;
>   	enum mxl5007t_if_freq if_freq_hz;
>   	unsigned int invert_if:1;
> -	unsigned int loop_thru_enable:1;
> +	unsigned int loop_thru_enable:2;
>   	unsigned int clk_out_enable:1;
> +	unsigned int no_probe:1;
> +	unsigned int no_reset:1;
>   };
>
>   #if defined(CONFIG_MEDIA_TUNER_MXL5007T) || (defined(CONFIG_MEDIA_TUNER_MXL5007T_MODULE) && defined(MODULE))
> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
> --- linux/drivers/media/usb/dvb-usb-v2/af9035.c	2012-08-16 05:45:24.000000000 +0200
> +++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2012-08-26 23:46:10.702070148 +0200
> @@ -209,7 +209,8 @@ static int af9035_i2c_master_xfer(struct
>   		if (msg[0].len > 40 || msg[1].len > 40) {
>   			/* TODO: correct limits > 40 */
>   			ret = -EOPNOTSUPP;
> -		} else if (msg[0].addr == state->af9033_config[0].i2c_addr) {
> +		} else if ((msg[0].addr == state->af9033_config[0].i2c_addr) ||
> +			   (msg[0].addr == state->af9033_config[1].i2c_addr)) {
>   			/* integrated demod */
>   			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
>   					msg[0].buf[2];
> @@ -220,6 +221,11 @@ static int af9035_i2c_master_xfer(struct
>   			u8 buf[5 + msg[0].len];
>   			struct usb_req req = { CMD_I2C_RD, 0, sizeof(buf),
>   					buf, msg[1].len, msg[1].buf };
> +			if (msg[0].addr == state->tuner_address[1]) {
> +				req.mbox += 0x10;
> +				msg[0].addr -= 1;
> +
> +			}
>   			buf[0] = msg[1].len;
>   			buf[1] = msg[0].addr << 1;
>   			buf[2] = 0x00; /* reg addr len */
> @@ -232,7 +238,8 @@ static int af9035_i2c_master_xfer(struct
>   		if (msg[0].len > 40) {
>   			/* TODO: correct limits > 40 */
>   			ret = -EOPNOTSUPP;
> -		} else if (msg[0].addr == state->af9033_config[0].i2c_addr) {
> +		} else if ((msg[0].addr == state->af9033_config[0].i2c_addr) ||
> +			   (msg[0].addr == state->af9033_config[1].i2c_addr)) {
>   			/* integrated demod */
>   			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
>   					msg[0].buf[2];
> @@ -243,6 +250,10 @@ static int af9035_i2c_master_xfer(struct
>   			u8 buf[5 + msg[0].len];
>   			struct usb_req req = { CMD_I2C_WR, 0, sizeof(buf), buf,
>   					0, NULL };
> +			if (msg[0].addr == state->tuner_address[1]) {
> +				req.mbox += 0x10;
> +				msg[0].addr -= 1;
> +			}
>   			buf[0] = msg[0].len;
>   			buf[1] = msg[0].addr << 1;
>   			buf[2] = 0x00; /* reg addr len */


It took somehow a quite long time to realize what all this is. First I 
was looking tuner commands from the sniff searching 0xc2 (0x61 << 1) and 
didn't find. After that I realized 0x61 was a fake address and that 
logic is done for handling it. Ugly hacks without any commends...

I am quite sure original I2C-adapter logic is about 99% correct. But as 
I saw from the sniff that bit 4 from 2nd byte was used as a mail box to 
select 2nd I2C-adapter or multiplexing I2C in firmware I  admit 
something should be done in order to handle it. That is much better 
situation than was for AF9015 where was no way to select used 
I2C-adapter other than demod I2C-gate.

Lets put here:

both demodulators
001957:  OUT: 000000 ms 057146 ms BULK[00002] >>> 0b 80 00 2b 01 02 00 
00 f9 99 b9 05
001977:  OUT: 000002 ms 057164 ms BULK[00002] >>> 0b 90 00 35 01 02 00 
00 f9 99 9f 05

both tuners:
002069:  OUT: 000001 ms 058016 ms BULK[00002] >>> 0b 00 03 63 01 c0 01 
00 04 00 dc f6
002087:  OUT: 000002 ms 058045 ms BULK[00002] >>> 0b 10 03 6c 01 c0 01 
00 04 03 c0 f6

bit4 from 2nd byte does selection between I2C-adapter as can be seen easily.

Most elegant way is to implement two I2C-adapters, one for each tuner. 
But as it is some more code I encourage to some other "abused" solution. 
I2C-addresses are 7bit long, but 8bit (or even more as 10bit addresses) 
could be used. I see best solution to use that one extra bit to carry 
info about used I2C-bus. Then that adapter hackish code will be much 
more shorter. Just add MSB bit from I2C-address to req.mbox, req.mbox += 
((msg[0].addr & 0x80) >> 3) and thats it. And please comment it too.


> @@ -283,9 +294,30 @@ static int af9035_identify_state(struct
>   	int ret;
>   	u8 wbuf[1] = { 1 };
>   	u8 rbuf[4];
> +	u8 tmp;
>   	struct usb_req req = { CMD_FW_QUERYINFO, 0, sizeof(wbuf), wbuf,
>   			sizeof(rbuf), rbuf };
>
> +	/* check if there is dual tuners */
> +	ret = af9035_rd_reg(d, EEPROM_DUAL_MODE, &tmp);
> +	if (ret < 0)
> +		goto err;
> +
> +	if (tmp) {
> +		/* read 2nd demodulator I2C address */
> +		ret = af9035_rd_reg(d, EEPROM_2WIREADDR, &tmp);
> +		if (ret < 0)
> +			goto err;
> +	
> +		ret = af9035_wr_reg(d, 0x00417f, tmp);
> +		if (ret < 0)
> +			goto err;
> +
> +		ret = af9035_wr_reg(d, 0x00d81a, 1);
> +		if (ret < 0)
> +			goto err;
> +	}

That is already done in af9035_read_config(). You are not allowed to 
abuse af9035_identify_state() unless very good reason. Leave 
af9035_identify_state() alone and hack with af9035_read_config().

> +
>   	ret = af9035_ctrl_msg(d, &req);
>   	if (ret < 0)
>   		goto err;
> @@ -492,7 +524,14 @@ static int af9035_read_config(struct dvb
>
>   	state->dual_mode = tmp;
>   	pr_debug("%s: dual mode=%d\n", __func__, state->dual_mode);
> -
> +	if (state->dual_mode) {
> +		/* read 2nd demodulator I2C address */
> +		ret = af9035_rd_reg(d, EEPROM_2WIREADDR, &tmp);
> +		if (ret < 0)
> +			goto err;
> +		state->af9033_config[1].i2c_addr = tmp;
> +		pr_debug("%s: 2nd demod I2C addr:%02x\n", __func__, tmp);
> +	}

Why this is again here?

>   	for (i = 0; i < state->dual_mode + 1; i++) {
>   		/* tuner */
>   		ret = af9035_rd_reg(d, EEPROM_1_TUNER_ID + eeprom_shift, &tmp);
> @@ -671,6 +710,12 @@ static int af9035_frontend_callback(void
>   	return -EINVAL;
>   }
>
> +static int af9035_get_adapter_count(struct dvb_usb_device *d)
> +{
> +	struct state *state = d_to_priv(d);
> +	return state->dual_mode + 1;
> +}
> +
>   static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
>   {
>   	struct state *state = adap_to_priv(adap);
> @@ -726,13 +771,26 @@ static const struct fc0011_config af9035
>   	.i2c_address = 0x60,
>   };
>
> -static struct mxl5007t_config af9035_mxl5007t_config = {
> -	.xtal_freq_hz = MxL_XTAL_24_MHZ,
> -	.if_freq_hz = MxL_IF_4_57_MHZ,
> -	.invert_if = 0,
> -	.loop_thru_enable = 0,
> -	.clk_out_enable = 0,
> -	.clk_out_amp = MxL_CLKOUT_AMP_0_94V,
> +static struct mxl5007t_config af9035_mxl5007t_config[] = {
> +	{
> +		.xtal_freq_hz = MxL_XTAL_24_MHZ,
> +		.if_freq_hz = MxL_IF_4_57_MHZ,
> +		.invert_if = 0,
> +		.loop_thru_enable = 0,
> +		.clk_out_enable = 0,
> +		.clk_out_amp = MxL_CLKOUT_AMP_0_94V,
> +		.no_probe = 1,
> +		.no_reset = 1,
> +	},{
> +		.xtal_freq_hz = MxL_XTAL_24_MHZ,
> +		.if_freq_hz = MxL_IF_4_57_MHZ,
> +		.invert_if = 0,
> +		.loop_thru_enable = 3,
> +		.clk_out_enable = 1,
> +		.clk_out_amp = MxL_CLKOUT_AMP_0_94V,
> +		.no_probe = 1,
> +		.no_reset = 1,
> +	}
>   };
>
>   static struct tda18218_config af9035_tda18218_config = {
> @@ -795,46 +853,50 @@ static int af9035_tuner_attach(struct dv
>   				&d->i2c_adap, &af9035_fc0011_config);
>   		break;
>   	case AF9033_TUNER_MXL5007T:
> -		ret = af9035_wr_reg(d, 0x00d8e0, 1);
> -		if (ret < 0)
> -			goto err;
> -		ret = af9035_wr_reg(d, 0x00d8e1, 1);
> -		if (ret < 0)
> -			goto err;
> -		ret = af9035_wr_reg(d, 0x00d8df, 0);
> -		if (ret < 0)
> -			goto err;
> +		state->tuner_address[adap->id] = 0x60;
> +		state->tuner_address[adap->id] += adap->id;

Better to use MSB bit to mark 2nd bus.

Like that:
state->tuner_address[adap->id] = (1 << 7) | 0x60; /* hack, use b[7] to 
carry used I2C-bus */

> +		if (adap->id == 0) {
> +			ret = af9035_wr_reg(d, 0x00d8e0, 1);
> +			if (ret < 0)
> +				goto err;
> +			ret = af9035_wr_reg(d, 0x00d8e1, 1);
> +			if (ret < 0)
> +				goto err;
> +			ret = af9035_wr_reg(d, 0x00d8df, 0);
> +			if (ret < 0)
> +				goto err;
>
> -		msleep(30);
> +			msleep(30);
>
> -		ret = af9035_wr_reg(d, 0x00d8df, 1);
> -		if (ret < 0)
> -			goto err;
> +			ret = af9035_wr_reg(d, 0x00d8df, 1);
> +			if (ret < 0)
> +				goto err;
>
> -		msleep(300);
> +			msleep(300);

300ms is like 10 years in time to wait tuner to wake up from reset. I 
guess it is reset as *no comments at all*. OK, it has been earlier there 
too...

>
> -		ret = af9035_wr_reg(d, 0x00d8c0, 1);
> -		if (ret < 0)
> -			goto err;
> -		ret = af9035_wr_reg(d, 0x00d8c1, 1);
> -		if (ret < 0)
> -			goto err;
> -		ret = af9035_wr_reg(d, 0x00d8bf, 0);
> -		if (ret < 0)
> -			goto err;
> -		ret = af9035_wr_reg(d, 0x00d8b4, 1);
> -		if (ret < 0)
> -			goto err;
> -		ret = af9035_wr_reg(d, 0x00d8b5, 1);
> -		if (ret < 0)
> -			goto err;
> -		ret = af9035_wr_reg(d, 0x00d8b3, 1);
> -		if (ret < 0)
> -			goto err;
> +			ret = af9035_wr_reg(d, 0x00d8c0, 1);
> +			if (ret < 0)
> +				goto err;
> +			ret = af9035_wr_reg(d, 0x00d8c1, 1);
> +			if (ret < 0)
> +				goto err;
> +			ret = af9035_wr_reg(d, 0x00d8bf, 0);
> +			if (ret < 0)
> +				goto err;
> +			ret = af9035_wr_reg(d, 0x00d8b4, 1);
> +			if (ret < 0)
> +				goto err;
> +			ret = af9035_wr_reg(d, 0x00d8b5, 1);
> +			if (ret < 0)
> +				goto err;
> +			ret = af9035_wr_reg(d, 0x00d8b3, 1);
> +			if (ret < 0)
> +				goto err;
> +		}

Could you add description which GPIOs are which. Which one demod, which 
for tuner, which for reset, which for standby etc.

>
>   		/* attach tuner */
>   		fe = dvb_attach(mxl5007t_attach, adap->fe[0],
> -				&d->i2c_adap, 0x60, &af9035_mxl5007t_config);
> +				&d->i2c_adap, state->tuner_address[adap->id], &af9035_mxl5007t_config[adap->id]);
>   		break;
>   	case AF9033_TUNER_TDA18218:
>   		/* attach tuner */
> @@ -879,8 +941,8 @@ static int af9035_init(struct dvb_usb_de
>   		{ 0x00dd8a, (frame_size >> 0) & 0xff, 0xff},
>   		{ 0x00dd8b, (frame_size >> 8) & 0xff, 0xff},
>   		{ 0x00dd0d, packet_size, 0xff },
> -		{ 0x80f9a3, 0x00, 0x01 },
> -		{ 0x80f9cd, 0x00, 0x01 },
> +		{ 0x80f9a3, state->dual_mode, 0x01 },
> +		{ 0x80f9cd, state->dual_mode, 0x01 },
>   		{ 0x80f99d, 0x00, 0x01 },
>   		{ 0x80f9a4, 0x00, 0x01 },
>   	};
> @@ -1001,7 +1063,7 @@ static const struct dvb_usb_device_prope
>   	.init = af9035_init,
>   	.get_rc_config = af9035_get_rc_config,
>
> -	.num_adapters = 1,
> +	.get_adapter_count = af9035_get_adapter_count,
>   	.adapter = {
>   		{
>   			.stream = DVB_USB_STREAM_BULK(0x84, 6, 87 * 188),
> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.h linux.new/drivers/media/usb/dvb-usb-v2/af9035.h
> --- linux/drivers/media/usb/dvb-usb-v2/af9035.h	2012-08-14 05:45:22.000000000 +0200
> +++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.h	2012-08-26 23:45:08.774070150 +0200
> @@ -54,6 +54,8 @@ struct state {
>   	bool dual_mode;
>
>   	struct af9033_config af9033_config[2];
> +
> +	u8 tuner_address[2];
>   };
>
>   u32 clock_lut[] = {
> @@ -87,6 +89,7 @@ u32 clock_lut_it9135[] = {
>   /* EEPROM locations */
>   #define EEPROM_IR_MODE            0x430d
>   #define EEPROM_DUAL_MODE          0x4326
> +#define EEPROM_2WIREADDR          0x4327
>   #define EEPROM_IR_TYPE            0x4329
>   #define EEPROM_1_IFFREQ_L         0x432d
>   #define EEPROM_1_IFFREQ_H         0x432e
>

And I saw these errors too when imported that patch to my local git tree:

[crope@localhost linux]$ wget -O - 
http://patchwork.linuxtv.org/patch/14067/mbox/ | git am -s
--2012-08-28 02:17:55--  http://patchwork.linuxtv.org/patch/14067/mbox/
Resolving patchwork.linuxtv.org... 130.149.80.248
Connecting to patchwork.linuxtv.org|130.149.80.248|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [text/plain]
Saving to: `STDOUT'

     [ <=> 
 
        ] 12,017      --.-K/s   in 0.06s

2012-08-28 02:17:55 (206 KB/s) - written to stdout [12017]

Applying: v2 Add support to Avermedia Twinstar double tuner in af9035
/home/crope/linuxtv/code/linux/.git/rebase-apply/patch:66: space before 
tab in indent.
	 	ret = mxl5007t_soft_reset(state);
/home/crope/linuxtv/code/linux/.git/rebase-apply/patch:67: space before 
tab in indent.
  		if (mxl_fail(ret))
/home/crope/linuxtv/code/linux/.git/rebase-apply/patch:68: space before 
tab in indent.
  			goto fail;
/home/crope/linuxtv/code/linux/.git/rebase-apply/patch:164: trailing 
whitespace.
	
warning: 4 lines add whitespace errors.
[crope@localhost linux]$
[crope@localhost linux]$ git show --pretty=email | ./scripts/checkpatch.pl -
ERROR: code indent should use tabs where possible
#76: FILE: drivers/media/tuners/mxl5007t.c:534:
+^I ^Iret = mxl5007t_soft_reset(state);$

WARNING: please, no space before tabs
#76: FILE: drivers/media/tuners/mxl5007t.c:534:
+^I ^Iret = mxl5007t_soft_reset(state);$

ERROR: code indent should use tabs where possible
#77: FILE: drivers/media/tuners/mxl5007t.c:535:
+ ^I^Iif (mxl_fail(ret))$

WARNING: please, no space before tabs
#77: FILE: drivers/media/tuners/mxl5007t.c:535:
+ ^I^Iif (mxl_fail(ret))$

WARNING: please, no spaces at the start of a line
#77: FILE: drivers/media/tuners/mxl5007t.c:535:
+ ^I^Iif (mxl_fail(ret))$

ERROR: code indent should use tabs where possible
#78: FILE: drivers/media/tuners/mxl5007t.c:536:
+ ^I^I^Igoto fail;$

WARNING: please, no space before tabs
#78: FILE: drivers/media/tuners/mxl5007t.c:536:
+ ^I^I^Igoto fail;$

WARNING: please, no spaces at the start of a line
#78: FILE: drivers/media/tuners/mxl5007t.c:536:
+ ^I^I^Igoto fail;$

WARNING: line over 80 characters
#91: FILE: drivers/media/tuners/mxl5007t.c:894:
+		ret = mxl5007t_write_reg(state, 0x04, state->config->loop_thru_enable);

ERROR: trailing whitespace
#176: FILE: drivers/media/usb/dvb-usb-v2/af9035.c:311:
+^I$

ERROR: space required after that ',' (ctx:VxV)
#239: FILE: drivers/media/usb/dvb-usb-v2/af9035.c:784:
+	},{
  	 ^

WARNING: line over 80 characters
#332: FILE: drivers/media/usb/dvb-usb-v2/af9035.c:899:
+				&d->i2c_adap, state->tuner_address[adap->id], 
&af9035_mxl5007t_config[adap->id]);

total: 5 errors, 7 warnings, 323 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
       scripts/cleanfile

Your patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.
[crope@localhost linux]$


I think it is quite OK when these findings are fixed or you explain 
better alternative.

regards
Antti

-- 
http://palosaari.fi/
