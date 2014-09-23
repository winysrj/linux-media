Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46831 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaIWMqE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 08:46:04 -0400
Message-ID: <54216B88.7000300@iki.fi>
Date: Tue, 23 Sep 2014 15:46:00 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] af9035: Add support for IT930x USB bridge
References: <1411296799-3525-1-git-send-email-olli.salonen@iki.fi> <1411296799-3525-4-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1411296799-3525-4-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

Changes were a bit complicated, but I understood those in general and 
there is nothing wrong for my eyes. Mostly I was surprised of new 
implementation of init() (init is mainly for configuring TS interfaces).

Also I2C adapter xfer goes pretty complex, but that is because there is 
actually 3 I2C adapters and some of those even offer multiple access 
methods by firmware. Maybe there is also room for later improvement.

But as I said, patch it is OK.

regards
Antti


On 09/21/2014 01:53 PM, Olli Salonen wrote:
> Add support for IT930x USB bridge and IT9303 reference design.
>
> It is a DVB-T/T2/C tuner with the following components:
> - IT9303 USB bridge
> - Si2168-B40 demodulator
> - Si2147-A30 tuner
>
> The IT9303 requires firmware that can be downloaded here:
> http://trsqr.net/olli/linux/firmwares/it930x/
>
> The Si2168-B40 requires firmware, but the one that is used by PCTV 292e can be used.
> http://palosaari.fi/linux/v4l-dvb/firmware/Si2168/Si2168-B40/
>
> The Si2147-A30 tuner does not require firmware loading.
>
> Cc: crope@iki.fi
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/dvb-core/dvb-usb-ids.h  |   1 +
>   drivers/media/usb/dvb-usb-v2/af9035.c | 324 ++++++++++++++++++++++++++++++++--
>   drivers/media/usb/dvb-usb-v2/af9035.h |   6 +
>   3 files changed, 314 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
> index d484a51..e07a84e 100644
> --- a/drivers/media/dvb-core/dvb-usb-ids.h
> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> @@ -144,6 +144,7 @@
>   #define USB_PID_ITETECH_IT9135				0x9135
>   #define USB_PID_ITETECH_IT9135_9005			0x9005
>   #define USB_PID_ITETECH_IT9135_9006			0x9006
> +#define USB_PID_ITETECH_IT9303				0x9306
>   #define USB_PID_KWORLD_399U				0xe399
>   #define USB_PID_KWORLD_399U_2				0xe400
>   #define USB_PID_KWORLD_395U				0xe396
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index c50d27d..00758c8 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -290,7 +290,7 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>   		return -EAGAIN;
>
>   	/*
> -	 * I2C sub header is 5 bytes long. Meaning of those bytes are:
> +	 * AF9035 I2C sub header is 5 bytes long. Meaning of those bytes are:
>   	 * 0: data len
>   	 * 1: I2C addr << 1
>   	 * 2: reg addr len
> @@ -317,6 +317,12 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>   	 * bus. I2C subsystem does not allow register multiple devices to same
>   	 * bus, having same slave address. Due to that we reuse demod address,
>   	 * shifted by one bit, on that case.
> +	 *
> +	 * For IT930x we use a different command and the sub header is
> +	 * different as well:
> +	 * 0: data len
> +	 * 1: I2C bus (0x03 seems to be only value used)
> +	 * 2: I2C addr << 1
>   	 */
>   #define AF9035_IS_I2C_XFER_WRITE_READ(_msg, _num) \
>   	(_num == 2 && !(_msg[0].flags & I2C_M_RD) && (_msg[1].flags & I2C_M_RD))
> @@ -348,13 +354,24 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>   			struct usb_req req = { CMD_I2C_RD, 0, 5 + msg[0].len,
>   					buf, msg[1].len, msg[1].buf };
>
> +			if (state->chip_type == 0x9306) {
> +				req.cmd = CMD_GENERIC_I2C_RD;
> +				req.wlen = 3 + msg[0].len;
> +			}
>   			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
> +
>   			buf[0] = msg[1].len;
> -			buf[1] = msg[0].addr << 1;
> -			buf[2] = 0x00; /* reg addr len */
> -			buf[3] = 0x00; /* reg addr MSB */
> -			buf[4] = 0x00; /* reg addr LSB */
> -			memcpy(&buf[5], msg[0].buf, msg[0].len);
> +			if (state->chip_type == 0x9306) {
> +				buf[1] = 0x03; /* I2C bus */
> +				buf[2] = msg[0].addr << 1;
> +				memcpy(&buf[3], msg[0].buf, msg[0].len);
> +			} else {
> +				buf[1] = msg[0].addr << 1;
> +				buf[2] = 0x00; /* reg addr len */
> +				buf[3] = 0x00; /* reg addr MSB */
> +				buf[4] = 0x00; /* reg addr LSB */
> +				memcpy(&buf[5], msg[0].buf, msg[0].len);
> +			}
>   			ret = af9035_ctrl_msg(d, &req);
>   		}
>   	} else if (AF9035_IS_I2C_XFER_WRITE(msg, num)) {
> @@ -380,13 +397,24 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>   			struct usb_req req = { CMD_I2C_WR, 0, 5 + msg[0].len,
>   					buf, 0, NULL };
>
> +			if (state->chip_type == 0x9306) {
> +				req.cmd = CMD_GENERIC_I2C_WR;
> +				req.wlen = 3 + msg[0].len;
> +			}
> +
>   			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
>   			buf[0] = msg[0].len;
> -			buf[1] = msg[0].addr << 1;
> -			buf[2] = 0x00; /* reg addr len */
> -			buf[3] = 0x00; /* reg addr MSB */
> -			buf[4] = 0x00; /* reg addr LSB */
> -			memcpy(&buf[5], msg[0].buf, msg[0].len);
> +			if (state->chip_type == 0x9306) {
> +				buf[1] = 0x03; /* I2C bus */
> +				buf[2] = msg[0].addr << 1;
> +				memcpy(&buf[3], msg[0].buf, msg[0].len);
> +			} else {
> +				buf[1] = msg[0].addr << 1;
> +				buf[2] = 0x00; /* reg addr len */
> +				buf[3] = 0x00; /* reg addr MSB */
> +				buf[4] = 0x00; /* reg addr LSB */
> +				memcpy(&buf[5], msg[0].buf, msg[0].len);
> +			}
>   			ret = af9035_ctrl_msg(d, &req);
>   		}
>   	} else if (AF9035_IS_I2C_XFER_READ(msg, num)) {
> @@ -397,13 +425,23 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>   			/* I2C read */
>   			u8 buf[5];
>   			struct usb_req req = { CMD_I2C_RD, 0, sizeof(buf),
> -					buf, msg[0].len, msg[0].buf };
> +						buf, msg[0].len, msg[0].buf };
> +
> +			if (state->chip_type == 0x9306) {
> +				req.cmd = CMD_GENERIC_I2C_RD;
> +				req.wlen = 3;
> +			}
>   			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
>   			buf[0] = msg[0].len;
> -			buf[1] = msg[0].addr << 1;
> -			buf[2] = 0x00; /* reg addr len */
> -			buf[3] = 0x00; /* reg addr MSB */
> -			buf[4] = 0x00; /* reg addr LSB */
> +			if (state->chip_type == 0x9306) {
> +				buf[1] = 0x03; /* I2C bus */
> +				buf[2] = msg[0].addr << 1;
> +			} else {
> +				buf[1] = msg[0].addr << 1;
> +				buf[2] = 0x00; /* reg addr len */
> +				buf[3] = 0x00; /* reg addr MSB */
> +				buf[4] = 0x00; /* reg addr LSB */
> +			}
>   			ret = af9035_ctrl_msg(d, &req);
>   		}
>   	} else {
> @@ -465,6 +503,9 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
>   		else
>   			*name = AF9035_FIRMWARE_IT9135_V1;
>   		state->eeprom_addr = EEPROM_BASE_IT9135;
> +	} else if (state->chip_type == 0x9306) {
> +		*name = AF9035_FIRMWARE_IT9303;
> +		state->eeprom_addr = EEPROM_BASE_IT9135;
>   	} else {
>   		*name = AF9035_FIRMWARE_AF9035;
>   		state->eeprom_addr = EEPROM_BASE_AF9035;
> @@ -674,7 +715,8 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
>   		if (!tmp)
>   			tmp = 0x3a;
>
> -		if (state->chip_type == 0x9135) {
> +		if ((state->chip_type == 0x9135) ||
> +				(state->chip_type == 0x9306)) {
>   			ret = af9035_wr_reg(d, 0x004bfb, tmp);
>   			if (ret < 0)
>   				goto err;
> @@ -766,8 +808,16 @@ static int af9035_read_config(struct dvb_usb_device *d)
>   			dev_dbg(&d->udev->dev, "%s: no eeprom\n", __func__);
>   			goto skip_eeprom;
>   		}
> +	} else if (state->chip_type == 0x9306) {
> +		/*
> +		 * IT930x is an USB bridge, only single demod-single tuner
> +		 * configurations seen so far.
> +		 */
> +		return 0;
>   	}
>
> +
> +
>   	/* check if there is dual tuners */
>   	ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_TS_MODE, &tmp);
>   	if (ret < 0)
> @@ -1111,6 +1161,41 @@ err:
>   	return ret;
>   }
>
> +static int it930x_frontend_attach(struct dvb_usb_adapter *adap)
> +{
> +	struct state *state = adap_to_priv(adap);
> +	struct dvb_usb_device *d = adap_to_d(adap);
> +	int ret;
> +	struct si2168_config si2168_config;
> +	struct i2c_adapter *adapter;
> +
> +	dev_dbg(&d->udev->dev, "adap->id=%d\n", adap->id);
> +
> +	si2168_config.i2c_adapter = &adapter;
> +	si2168_config.fe = &adap->fe[0];
> +	si2168_config.ts_mode = SI2168_TS_SERIAL;
> +
> +	state->af9033_config[adap->id].fe = &adap->fe[0];
> +	state->af9033_config[adap->id].ops = &state->ops;
> +	ret = af9035_add_i2c_dev(d, "si2168", 0x67, &si2168_config,
> +				&d->i2c_adap);
> +	if (ret)
> +		goto err;
> +
> +	if (adap->fe[0] == NULL) {
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +	state->i2c_adapter_demod = adapter;
> +
> +	return 0;
> +
> +err:
> +	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
> +
> +	return ret;
> +}
> +
>   static int af9035_frontend_detach(struct dvb_usb_adapter *adap)
>   {
>   	struct state *state = adap_to_priv(adap);
> @@ -1430,6 +1515,93 @@ err:
>   	return ret;
>   }
>
> +static int it930x_tuner_attach(struct dvb_usb_adapter *adap)
> +{
> +	struct state *state = adap_to_priv(adap);
> +	struct dvb_usb_device *d = adap_to_d(adap);
> +	int ret;
> +	struct si2157_config si2157_config;
> +
> +	dev_dbg(&d->udev->dev, "%s: adap->id=%d\n", __func__, adap->id);
> +
> +	/* I2C master bus 2 clock speed 300k */
> +	ret = af9035_wr_reg(d, 0x00f6a7, 0x07);
> +	if (ret < 0)
> +		goto err;
> +
> +	/* I2C master bus 1,3 clock speed 300k */
> +	ret = af9035_wr_reg(d, 0x00f103, 0x07);
> +	if (ret < 0)
> +		goto err;
> +
> +	/* set gpio11 low */
> +	ret = af9035_wr_reg_mask(d, 0xd8d4, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = af9035_wr_reg_mask(d, 0xd8d5, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = af9035_wr_reg_mask(d, 0xd8d3, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	/* Tuner enable using gpiot2_en, gpiot2_on and gpiot2_o (reset) */
> +	ret = af9035_wr_reg_mask(d, 0xd8b8, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = af9035_wr_reg_mask(d, 0xd8b9, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = af9035_wr_reg_mask(d, 0xd8b7, 0x00, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	msleep(200);
> +
> +	ret = af9035_wr_reg_mask(d, 0xd8b7, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	memset(&si2157_config, 0, sizeof(si2157_config));
> +	si2157_config.fe = adap->fe[0];
> +	ret = af9035_add_i2c_dev(d, "si2157", 0x63,
> +			&si2157_config, state->i2c_adapter_demod);
> +
> +	if (ret)
> +		goto err;
> +
> +	return 0;
> +
> +err:
> +	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
> +
> +	return ret;
> +}
> +
> +
> +static int it930x_tuner_detach(struct dvb_usb_adapter *adap)
> +{
> +	struct state *state = adap_to_priv(adap);
> +	struct dvb_usb_device *d = adap_to_d(adap);
> +
> +	dev_dbg(&d->udev->dev, "adap->id=%d\n", adap->id);
> +
> +	if (adap->id == 1) {
> +		if (state->i2c_client[3])
> +			af9035_del_i2c_dev(d);
> +	} else if (adap->id == 0) {
> +		if (state->i2c_client[1])
> +			af9035_del_i2c_dev(d);
> +	}
> +
> +	return 0;
> +}
> +
> +
>   static int af9035_tuner_detach(struct dvb_usb_adapter *adap)
>   {
>   	struct state *state = adap_to_priv(adap);
> @@ -1503,6 +1675,89 @@ err:
>   	return ret;
>   }
>
> +static int it930x_init(struct dvb_usb_device *d)
> +{
> +	struct state *state = d_to_priv(d);
> +	int ret, i;
> +	u16 frame_size = (d->udev->speed == USB_SPEED_FULL ? 5 : 816) * 188 / 4;
> +	u8 packet_size = (d->udev->speed == USB_SPEED_FULL ? 64 : 512) / 4;
> +	struct reg_val_mask tab[] = {
> +		{ 0x00da1a, 0x00, 0x01 }, /* ignore_sync_byte */
> +		{ 0x00f41f, 0x04, 0x04 }, /* dvbt_inten */
> +		{ 0x00da10, 0x00, 0x01 }, /* mpeg_full_speed */
> +		{ 0x00f41a, 0x01, 0x01 }, /* dvbt_en */
> +		{ 0x00da1d, 0x01, 0x01 }, /* mp2_sw_rst, reset EP4 */
> +		{ 0x00dd11, 0x00, 0x20 }, /* ep4_tx_en, disable EP4 */
> +		{ 0x00dd13, 0x00, 0x20 }, /* ep4_tx_nak, disable EP4 NAK */
> +		{ 0x00dd11, 0x20, 0x20 }, /* ep4_tx_en, enable EP4 */
> +		{ 0x00dd11, 0x00, 0x40 }, /* ep5_tx_en, disable EP5 */
> +		{ 0x00dd13, 0x00, 0x40 }, /* ep5_tx_nak, disable EP5 NAK */
> +		{ 0x00dd11, state->dual_mode << 6, 0x40 }, /* enable EP5 */
> +		{ 0x00dd88, (frame_size >> 0) & 0xff, 0xff},
> +		{ 0x00dd89, (frame_size >> 8) & 0xff, 0xff},
> +		{ 0x00dd0c, packet_size, 0xff},
> +		{ 0x00dd8a, (frame_size >> 0) & 0xff, 0xff},
> +		{ 0x00dd8b, (frame_size >> 8) & 0xff, 0xff},
> +		{ 0x00dd0d, packet_size, 0xff },
> +		{ 0x00da1d, 0x00, 0x01 }, /* mp2_sw_rst, disable */
> +		{ 0x00d833, 0x01, 0xff }, /* slew rate ctrl: slew rate boosts */
> +		{ 0x00d830, 0x00, 0xff }, /* Bit 0 of output driving control */
> +		{ 0x00d831, 0x01, 0xff }, /* Bit 1 of output driving control */
> +		{ 0x00d832, 0x00, 0xff }, /* Bit 2 of output driving control */
> +
> +		/* suspend gpio1 for TS-C */
> +		{ 0x00d8b0, 0x01, 0xff }, /* gpio1 */
> +		{ 0x00d8b1, 0x01, 0xff }, /* gpio1 */
> +		{ 0x00d8af, 0x00, 0xff }, /* gpio1 */
> +
> +		/* suspend gpio7 for TS-D */
> +		{ 0x00d8c4, 0x01, 0xff }, /* gpio7 */
> +		{ 0x00d8c5, 0x01, 0xff }, /* gpio7 */
> +		{ 0x00d8c3, 0x00, 0xff }, /* gpio7 */
> +
> +		/* suspend gpio13 for TS-B */
> +		{ 0x00d8dc, 0x01, 0xff }, /* gpio13 */
> +		{ 0x00d8dd, 0x01, 0xff }, /* gpio13 */
> +		{ 0x00d8db, 0x00, 0xff }, /* gpio13 */
> +
> +		/* suspend gpio14 for TS-E */
> +		{ 0x00d8e4, 0x01, 0xff }, /* gpio14 */
> +		{ 0x00d8e5, 0x01, 0xff }, /* gpio14 */
> +		{ 0x00d8e3, 0x00, 0xff }, /* gpio14 */
> +
> +		/* suspend gpio15 for TS-A */
> +		{ 0x00d8e8, 0x01, 0xff }, /* gpio15 */
> +		{ 0x00d8e9, 0x01, 0xff }, /* gpio15 */
> +		{ 0x00d8e7, 0x00, 0xff }, /* gpio15 */
> +
> +		{ 0x00da58, 0x00, 0x01 }, /* ts_in_src, serial */
> +		{ 0x00da73, 0x01, 0xff }, /* ts0_aggre_mode */
> +		{ 0x00da78, 0x47, 0xff }, /* ts0_sync_byte */
> +		{ 0x00da4c, 0x01, 0xff }, /* ts0_en */
> +		{ 0x00da5a, 0x1f, 0xff }, /* ts_fail_ignore */
> +	};
> +
> +	dev_dbg(&d->udev->dev,
> +			"%s: USB speed=%d frame_size=%04x packet_size=%02x\n",
> +			__func__, d->udev->speed, frame_size, packet_size);
> +
> +	/* init endpoints */
> +	for (i = 0; i < ARRAY_SIZE(tab); i++) {
> +		ret = af9035_wr_reg_mask(d, tab[i].reg,
> +				tab[i].val, tab[i].mask);
> +
> +		if (ret < 0)
> +			goto err;
> +	}
> +
> +	return 0;
> +err:
> +	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
> +
> +	return ret;
> +}
> +
> +
>   #if IS_ENABLED(CONFIG_RC_CORE)
>   static int af9035_rc_query(struct dvb_usb_device *d)
>   {
> @@ -1706,6 +1961,37 @@ static const struct dvb_usb_device_properties af9035_props = {
>   	},
>   };
>
> +static const struct dvb_usb_device_properties it930x_props = {
> +	.driver_name = KBUILD_MODNAME,
> +	.owner = THIS_MODULE,
> +	.adapter_nr = adapter_nr,
> +	.size_of_priv = sizeof(struct state),
> +
> +	.generic_bulk_ctrl_endpoint = 0x02,
> +	.generic_bulk_ctrl_endpoint_response = 0x81,
> +
> +	.identify_state = af9035_identify_state,
> +	.download_firmware = af9035_download_firmware,
> +
> +	.i2c_algo = &af9035_i2c_algo,
> +	.read_config = af9035_read_config,
> +	.frontend_attach = it930x_frontend_attach,
> +	.frontend_detach = af9035_frontend_detach,
> +	.tuner_attach = it930x_tuner_attach,
> +	.tuner_detach = it930x_tuner_detach,
> +	.init = it930x_init,
> +	.get_stream_config = af9035_get_stream_config,
> +
> +	.get_adapter_count = af9035_get_adapter_count,
> +	.adapter = {
> +		{
> +			.stream = DVB_USB_STREAM_BULK(0x84, 4, 816 * 188),
> +		}, {
> +			.stream = DVB_USB_STREAM_BULK(0x85, 4, 816 * 188),
> +		},
> +	},
> +};
> +
>   static const struct usb_device_id af9035_id_table[] = {
>   	/* AF9035 devices */
>   	{ DVB_USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9035_9035,
> @@ -1759,6 +2045,9 @@ static const struct usb_device_id af9035_id_table[] = {
>   	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_CTVDIGDUAL_V2,
>   		&af9035_props, "Digital Dual TV Receiver CTVDIGDUAL_V2",
>   							RC_MAP_IT913X_V1) },
> +	/* IT930x devices */
> +	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9303,
> +		&it930x_props, "ITE 9303 Generic", NULL) },
>   	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
>   	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
>   		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)",
> @@ -1795,3 +2084,4 @@ MODULE_LICENSE("GPL");
>   MODULE_FIRMWARE(AF9035_FIRMWARE_AF9035);
>   MODULE_FIRMWARE(AF9035_FIRMWARE_IT9135_V1);
>   MODULE_FIRMWARE(AF9035_FIRMWARE_IT9135_V2);
> +MODULE_FIRMWARE(AF9035_FIRMWARE_IT9303);
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
> index edb3871..416a97f 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.h
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.h
> @@ -31,6 +31,8 @@
>   #include "tda18218.h"
>   #include "fc2580.h"
>   #include "it913x.h"
> +#include "si2168.h"
> +#include "si2157.h"
>
>   struct reg_val {
>   	u32 reg;
> @@ -66,6 +68,7 @@ struct state {
>   	struct af9033_ops ops;
>   	#define AF9035_I2C_CLIENT_MAX 4
>   	struct i2c_client *i2c_client[AF9035_I2C_CLIENT_MAX];
> +	struct i2c_adapter *i2c_adapter_demod;
>   };
>
>   static const u32 clock_lut_af9035[] = {
> @@ -99,6 +102,7 @@ static const u32 clock_lut_it9135[] = {
>   #define AF9035_FIRMWARE_AF9035 "dvb-usb-af9035-02.fw"
>   #define AF9035_FIRMWARE_IT9135_V1 "dvb-usb-it9135-01.fw"
>   #define AF9035_FIRMWARE_IT9135_V2 "dvb-usb-it9135-02.fw"
> +#define AF9035_FIRMWARE_IT9303 "dvb-usb-it9303-01.fw"
>
>   /*
>    * eeprom is memory mapped as read only. Writing that memory mapped address
> @@ -140,5 +144,7 @@ static const u32 clock_lut_it9135[] = {
>   #define CMD_FW_DL_BEGIN             0x24
>   #define CMD_FW_DL_END               0x25
>   #define CMD_FW_SCATTER_WR           0x29
> +#define CMD_GENERIC_I2C_RD          0x2a
> +#define CMD_GENERIC_I2C_WR          0x2b
>
>   #endif
>

-- 
http://palosaari.fi/
