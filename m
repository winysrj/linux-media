Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613Ab0JQNXM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 09:23:12 -0400
Message-ID: <4CBAEAA7.6050206@redhat.com>
Date: Sun, 17 Oct 2010 10:23:03 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [GIT PULL request for 2.6.37] Add Technisat SkyStar HD USB driver
References: <201010171450.18459.pboettcher@kernellabs.com>
In-Reply-To: <201010171450.18459.pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 17-10-2010 10:50, Patrick Boettcher escreveu:
> Hi Mauro,
> 
> please 
> 
> git pull git://github.com/pboettch/linux-2.6.git for_mauro
> 
> for the following changes:
> 
> technisat-usb2: added driver for Technisat's USB2.0 DVB-S/S2 receiver
> stv090x: add tei-field to config-structure
> stv090x: added function to control GPIOs from the outside

Both stv090x patches seem ok to me.

> Thanks in advance for pulling and commenting,

I have a few comments for the technisat-usb2:

> technisat-usb2: added driver for Technisat's USB2.0 DVB-S/S2 receiver
> 
> This patch is adding support for Technisat's new USB2.0 DVB-S/S2 receiver
> device. The development was sponsored by Technisat.
> 
> The Green led is toggle depending on the frontend-state. The Red LED is turned
> on all the time.
> 
> The MAC address reading from the EEPROM along with the
> LRC-method to check whether its valid.
> 
> Support for the IR-receiver of the Technisat USB2 box. The keys of
> small, black remote-control are built-in, repeated key behaviour are
> simulated.
> 
> The i2c-mutex of the dvb-usb-structure is used as a general mutex for
> USB requests, as there are 3 threads racing for atomic requests
> consisting of multiple usb-requests.
> 
> A module option is there which disables the toggling of LEDs by the
> driver on certain triggers. Useful when being used in a "dark"
> environment.
> 
> Signed-off-by: Martin Wilks <m.wilks@technisat.com>
> Signed-off-by: Patrick Boettcher <pboettcher@kernellabs.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/dvb/dvb-usb/Kconfig          |    8 +
>  drivers/media/dvb/dvb-usb/Makefile         |    3 +
>  drivers/media/dvb/dvb-usb/dvb-usb-ids.h    |    1 +
>  drivers/media/dvb/dvb-usb/technisat-usb2.c |  886 ++++++++++++++++++++++++++++
>  4 files changed, 898 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/dvb/dvb-usb/technisat-usb2.c
> 
> diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
> index ce60c1e..1d0ba54 100644
> --- a/drivers/media/dvb/dvb-usb/Kconfig
> +++ b/drivers/media/dvb/dvb-usb/Kconfig
> @@ -349,6 +349,14 @@ config DVB_USB_AZ6027
>  	help
>  	  Say Y here to support the AZ6027 device
>  
> +config DVB_USB_TECHNISAT_USB2
> +	tristate "Technisat DVB-S/S2 USB2.0 support"
> +	depends on DVB_USB
> +	select DVB_STB0899 if !DVB_FE_CUSTOMISE
> +	select DVB_STB6100 if !DVB_FE_CUSTOMISE
> +	help
> +	  Say Y here to support the Technisat USB2 DVB-S/S2 device
> +
>  config DVB_USB_LME2510
>  	tristate "LME DM04/QQBOX DVB-S USB2.0 support"
>  	depends on DVB_USB
> diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
> index 5b1d12f..4bac13d 100644
> --- a/drivers/media/dvb/dvb-usb/Makefile
> +++ b/drivers/media/dvb/dvb-usb/Makefile
> @@ -91,6 +91,9 @@ obj-$(CONFIG_DVB_USB_AZ6027) += dvb-usb-az6027.o
>  dvb-usb-lmedm04-objs = lmedm04.o
>  obj-$(CONFIG_DVB_USB_LME2510) += dvb-usb-lmedm04.o
>  
> +dvb-usb-technisat-usb2-objs = technisat-usb2.o
> +obj-$(CONFIG_DVB_USB_TECHNISAT_USB2) += dvb-usb-technisat-usb2.o
> +
>  EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
>  # due to tuner-xc3028
>  EXTRA_CFLAGS += -Idrivers/media/common/tuners
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> index cea7767..8dfdb4f 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> @@ -309,4 +309,5 @@
>  #define USB_PID_TERRATEC_DVBS2CI_V2			0x10ac
>  #define USB_PID_TECHNISAT_USB2_HDCI_V1			0x0001
>  #define USB_PID_TECHNISAT_USB2_HDCI_V2			0x0002
> +#define USB_PID_TECHNISAT_USB2_DVB_S2			0x0500
>  #endif
> diff --git a/drivers/media/dvb/dvb-usb/technisat-usb2.c b/drivers/media/dvb/dvb-usb/technisat-usb2.c
> new file mode 100644
> index 0000000..43523a7
> --- /dev/null
> +++ b/drivers/media/dvb/dvb-usb/technisat-usb2.c
> @@ -0,0 +1,886 @@
> +/*
> + * Linux driver for Technisat DVB-S/S2 USB 2.0 device
> + *
> + * Copyright (C) 2010 Patrick Boettcher,
> + *                    Kernel Labs Inc. PO Box 745, St James, NY 11780
> + *
> + * Development was sponsored by Technisat Digital UK Limited, whose
> + * registered office is Witan Gate House 500 - 600 Witan Gate West,
> + * Milton Keynes, MK9 1SH
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of the
> + * License, or (at your option) any later version.
> + *
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + * THIS PROGRAM IS PROVIDED "AS IS" AND BOTH THE COPYRIGHT HOLDER AND
> + * TECHNISAT DIGITAL UK LTD DISCLAIM ALL WARRANTIES WITH REGARD TO
> + * THIS PROGRAM INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY OR
> + * FITNESS FOR A PARTICULAR PURPOSE.  NEITHER THE COPYRIGHT HOLDER
> + * NOR TECHNISAT DIGITAL UK LIMITED SHALL BE LIABLE FOR ANY SPECIAL,
> + * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
> + * RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
> + * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
> + * IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS PROGRAM. See the
> + * GNU General Public License for more details.
> + */
> +
> +#define DVB_USB_LOG_PREFIX "technisat-usb2"
> +#include "dvb-usb.h"
> +
> +#include "stv6110x.h"
> +#include "stv090x.h"
> +
> +/* module parameters */
> +DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
> +
> +static int technisat_usb2_debug;
> +module_param_named(debug, technisat_usb2_debug, int, 0644);

As this is static, you could just name it as:

	static int debug;

and use module_param() instead.

> +MODULE_PARM_DESC(debug,
> +		"set debugging level (bit-mask: 1=info,2=eeprom,4=i2c,8=rc)." \
> +		DVB_USB_DEBUG_STATUS);
> +
> +/* disables all LED control command and
> + * also does not start the signal polling thread */
> +static int disable_led_control;
> +module_param(disable_led_control, int, 0444);
> +MODULE_PARM_DESC(disable_led_control,
> +		"disable LED control of the device "
> +		"(default: 0 - LED control is active).");
> +
> +/* device private data */
> +struct technisat_usb2_state {
> +	struct dvb_usb_device *dev;
> +	struct delayed_work green_led_work;
> +	u8 power_state;
> +
> +	u16 last_scan_code;
> +};
> +
> +/* debug print helpers */
> +#define deb_info(args...)    dprintk(technisat_usb2_debug, 0x01, args)
> +#define deb_eeprom(args...)  dprintk(technisat_usb2_debug, 0x02, args)
> +#define deb_i2c(args...)     dprintk(technisat_usb2_debug, 0x04, args)
> +#define deb_rc(args...)      dprintk(technisat_usb2_debug, 0x08, args)
> +
> +/* vendor requests */
> +#define SET_IFCLK_TO_EXTERNAL_TSCLK_VENDOR_REQUEST 0xB3
> +#define SET_FRONT_END_RESET_VENDOR_REQUEST         0xB4
> +#define GET_VERSION_INFO_VENDOR_REQUEST            0xB5
> +#define SET_GREEN_LED_VENDOR_REQUEST               0xB6
> +#define SET_RED_LED_VENDOR_REQUEST                 0xB7
> +#define GET_IR_DATA_VENDOR_REQUEST                 0xB8
> +#define SET_LED_TIMER_DIVIDER_VENDOR_REQUEST       0xB9
> +#define SET_USB_REENUMERATION                      0xBA
> +
> +/* i2c-access methods */
> +#define I2C_SPEED_100KHZ_BIT 0x40
> +
> +#define I2C_STATUS_NAK 7
> +#define I2C_STATUS_OK 8
> +
> +static int technisat_usb2_i2c_access(struct usb_device *udev,
> +		u8 device_addr, u8 *tx, u8 txlen, u8 *rx, u8 rxlen)
> +{
> +	u8 b[64];
> +	int ret, actual_length;
> +
> +	deb_i2c("i2c-access: %02x, tx: ", device_addr);
> +	debug_dump(tx, txlen, deb_i2c);
> +	deb_i2c(" ");
> +
> +	if (txlen > 62) {
> +		err("i2c TX buffer can't exceed 62 bytes (dev 0x%02x)",
> +				device_addr);
> +		txlen = 62;
> +	}
> +	if (rxlen > 62) {
> +		err("i2c RX buffer can't exceed 62 bytes (dev 0x%02x)",
> +				device_addr);
> +		txlen = 62;
> +	}
> +
> +	b[0] = I2C_SPEED_100KHZ_BIT;
> +	b[1] = device_addr << 1;
> +
> +	if (rx != NULL) {
> +		b[0] |= rxlen;
> +		b[1] |= 1;
> +	}
> +
> +	memcpy(&b[2], tx, txlen);
> +	ret = usb_bulk_msg(udev,
> +			usb_sndbulkpipe(udev, 0x01),
> +			b, 2 + txlen,
> +			NULL, 1000);
> +
> +	if (ret < 0) {
> +		err("i2c-error: out failed %02x = %d", device_addr, ret);
> +		return -ENODEV;
> +	}
> +
> +	ret = usb_bulk_msg(udev,
> +			usb_rcvbulkpipe(udev, 0x01),
> +			b, 64, &actual_length, 1000);
> +	if (ret < 0) {
> +		err("i2c-error: in failed %02x = %d", device_addr, ret);
> +		return -ENODEV;
> +	}
> +
> +	if (b[0] != I2C_STATUS_OK) {
> +		err("i2c-error: %02x = %d", device_addr, b[0]);
> +		/* handle tuner-i2c-nak */
> +		if (!(b[0] == I2C_STATUS_NAK &&
> +				device_addr == 0x60
> +				/* && device_is_technisat_usb2 */))
> +			return -ENODEV;
> +	}
> +
> +	deb_i2c("status: %d, ", b[0]);
> +
> +	if (rx != NULL) {
> +		memcpy(rx, &b[2], rxlen);
> +
> +		deb_i2c("rx (%d): ", rxlen);
> +		debug_dump(rx, rxlen, deb_i2c);
> +	}
> +
> +	deb_i2c("\n");
> +
> +	return 0;
> +}
> +
> +static int technisat_usb2_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msg,
> +				int num)
> +{
> +	int ret = 0, i;
> +	struct dvb_usb_device *d = i2c_get_adapdata(adap);
> +
> +	/* Ensure nobody else hits the i2c bus while we're sending our
> +	   sequence of messages, (such as the remote control thread) */
> +	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
> +		return -EAGAIN;
> +
> +	for (i = 0; i < num; i++) {
> +		if (i+1 < num && msg[i+1].flags & I2C_M_RD) {
> +			ret = technisat_usb2_i2c_access(d->udev, msg[i+1].addr,
> +						msg[i].buf, msg[i].len,
> +						msg[i+1].buf, msg[i+1].len);
> +			if (ret != 0)
> +				break;
> +			i++;
> +		} else {
> +			ret = technisat_usb2_i2c_access(d->udev, msg[i].addr,
> +						msg[i].buf, msg[i].len,
> +						NULL, 0);
> +			if (ret != 0)
> +				break;
> +		}
> +	}
> +
> +	if (ret == 0)
> +		ret = i;
> +
> +	mutex_unlock(&d->i2c_mutex);
> +
> +	return ret;
> +}
> +
> +static u32 technisat_usb2_i2c_func(struct i2c_adapter *adapter)
> +{
> +	return I2C_FUNC_I2C;
> +}
> +
> +static struct i2c_algorithm technisat_usb2_i2c_algo = {
> +	.master_xfer   = technisat_usb2_i2c_xfer,
> +	.functionality = technisat_usb2_i2c_func,
> +
> +#ifdef NEED_ALGO_CONTROL
> +	.algo_control = dummy_algo_control,
> +#endif

You don't need it. This is always false upstream.

> +};
> +
> +#if 0
> +static void technisat_usb2_frontend_reset(struct usb_device *udev)
> +{
> +	usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
> +			SET_FRONT_END_RESET_VENDOR_REQUEST,
> +			USB_TYPE_VENDOR | USB_DIR_OUT,
> +			10, 0,
> +			NULL, 0, 500);
> +}
> +#endif
> +
> +/* LED control */
> +enum technisat_usb2_led_state {
> +	LED_OFF,
> +	LED_BLINK,
> +	LED_ON,
> +	LED_UNDEFINED
> +};
> +
> +static int technisat_usb2_set_led(struct dvb_usb_device *d, int red, enum technisat_usb2_led_state state)
> +{
> +	int ret;
> +
> +	u8 led[8] = {
> +		red ? SET_RED_LED_VENDOR_REQUEST : SET_GREEN_LED_VENDOR_REQUEST,
> +		0
> +	};
> +
> +	if (disable_led_control && state != LED_OFF)
> +		return 0;
> +
> +	switch (state) {
> +	case LED_ON:
> +		led[1] = 0x82;
> +		break;
> +	case LED_BLINK:
> +		led[1] = 0x82;
> +		if (red) {
> +			led[2] = 0x02;
> +			led[3] = 10;
> +			led[4] = 10;
> +		} else {
> +			led[2] = 0xff;
> +			led[3] = 50;
> +			led[4] = 50;
> +		}
> +		led[5] = 1;
> +		break;
> +
> +	default:
> +	case LED_OFF:
> +		led[1] = 0x80;
> +		break;
> +	}
> +
> +	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
> +		return -EAGAIN;
> +
> +	ret = usb_control_msg(d->udev, usb_sndctrlpipe(d->udev, 0),
> +		red ? SET_RED_LED_VENDOR_REQUEST : SET_GREEN_LED_VENDOR_REQUEST,
> +		USB_TYPE_VENDOR | USB_DIR_OUT,
> +		0, 0,
> +		led, sizeof(led), 500);
> +
> +	mutex_unlock(&d->i2c_mutex);
> +	return ret;
> +}
> +
> +static int technisat_usb2_set_led_timer(struct dvb_usb_device *d, u8 red, u8 green)
> +{
> +	int ret;
> +	u8 b = 0;
> +
> +	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
> +		return -EAGAIN;
> +
> +	ret = usb_control_msg(d->udev, usb_sndctrlpipe(d->udev, 0),
> +		SET_LED_TIMER_DIVIDER_VENDOR_REQUEST,
> +		USB_TYPE_VENDOR | USB_DIR_OUT,
> +		(red << 8) | green, 0,
> +		&b, 1, 500);
> +
> +	mutex_unlock(&d->i2c_mutex);
> +
> +	return ret;
> +}
> +
> +static void technisat_usb2_green_led_control(struct work_struct *work)
> +{
> +	struct technisat_usb2_state *state =
> +		container_of(work, struct technisat_usb2_state, green_led_work.work);
> +	struct dvb_frontend *fe = state->dev->adapter[0].fe;
> +
> +	if (state->power_state == 0)
> +		goto schedule;
> +
> +	if (fe != NULL) {
> +		enum fe_status status;
> +
> +		if (fe->ops.read_status(fe, &status) != 0)
> +			goto schedule;
> +
> +		if (status & FE_HAS_LOCK) {
> +			u32 ber;
> +
> +			if (fe->ops.read_ber(fe, &ber) != 0)
> +				goto schedule;
> +
> +			if (ber > 1000)
> +				technisat_usb2_set_led(state->dev, 0, LED_BLINK);
> +			else
> +				technisat_usb2_set_led(state->dev, 0, LED_ON);
> +		} else
> +			technisat_usb2_set_led(state->dev, 0, LED_OFF);
> +	}
> +
> +schedule:
> +	schedule_delayed_work(&state->green_led_work,
> +			msecs_to_jiffies(500));
> +}
> +
> +/* method to find out whether the firmware has to be downloaded or not */
> +static int technisat_usb2_identify_state(struct usb_device *udev,
> +		struct dvb_usb_device_properties *props,
> +		struct dvb_usb_device_description **desc, int *cold)
> +{
> +	int ret;
> +	u8 version[3];
> +
> +	/* first select the interface */
> +	if (usb_set_interface(udev, 0, 1) != 0) {
> +		err("could not set alternate setting to 0");
> +	} else {
> +		info("set alternate setting");
> +	}
> +
> +	*cold = 0; /* by default do not download a firmware - just in case something is wrong */
> +
> +	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> +		GET_VERSION_INFO_VENDOR_REQUEST,
> +		USB_TYPE_VENDOR | USB_DIR_IN,
> +		0, 0,
> +		version, sizeof(version), 500);
> +
> +	if (ret < 0)
> +		*cold = 1;
> +	else {
> +		info("firmware version: %d.%d", version[1], version[2]);
> +		*cold = 0;
> +	}
> +
> +	return 0;
> +}
> +
> +/* power control */
> +static int technisat_usb2_power_ctrl(struct dvb_usb_device *d, int level)
> +{
> +	struct technisat_usb2_state *state = d->priv;
> +
> +	state->power_state = level;
> +
> +	if (disable_led_control)
> +		return 0;
> +
> +	/* green led is turned off in any case - will be turned on when tuning */
> +	technisat_usb2_set_led(d, 0, LED_OFF);
> +	/* red led is turned on all the time */
> +	technisat_usb2_set_led(d, 1, LED_ON);
> +	return 0;
> +}
> +
> +/* mac address reading - from the eeprom */
> +#if 0
> +static void technisat_usb2_eeprom_dump(struct dvb_usb_device *d)
> +{
> +	u8 reg;
> +	u8 b[16];
> +	int i,j;
> +
> +	/* full EEPROM dump */
> +	for (j = 0; j < 256 * 4; j += 16) {
> +		reg = j;
> +		if (technisat_usb2_i2c_access(d->udev, 0x50 + j / 256, &reg, 1, b, 16) != 0)
> +			break;
> +
> +		deb_eeprom("EEPROM: %01x%02x: ", j / 256, reg);
> +		for (i = 0; i < 16; i++)
> +			deb_eeprom("%02x ", b[i]);
> +		deb_eeprom("\n");
> +	}
> +}
> +#endif
> +
> +static u8 technisat_usb2_calc_lrc(const u8 *b, u16 length)
> +{
> +	u8 lrc = 0;
> +	while (--length)
> +		lrc ^= *b++;
> +	return lrc;
> +}
> +
> +static int technisat_usb2_eeprom_lrc_read(struct dvb_usb_device *d,
> +	u16 offset, u8 *b, u16 length, u8 tries)
> +{
> +	u8 bo = offset & 0xff;
> +	struct i2c_msg msg[] = {
> +		{
> +			.addr = 0x50 | ((offset >> 8) & 0x3),
> +			.buf = &bo,
> +			.len = 1
> +		}, {
> +			.addr = 0x50 | ((offset >> 8) & 0x3),
> +			.flags	= I2C_M_RD,
> +			.buf = b,
> +			.len = length
> +		}
> +	};
> +
> +	while (tries--) {
> +		int status;
> +
> +		if (i2c_transfer(&d->i2c_adap, msg, 2) != 2)
> +			break;
> +
> +		status =
> +			technisat_usb2_calc_lrc(b, length - 1) == b[length - 1];
> +
> +		if (status)
> +			return 0;
> +	}
> +
> +	return -EREMOTEIO;
> +}
> +
> +#define EEPROM_MAC_START 0x3f8
> +#define EEPROM_MAC_TOTAL 8
> +static int technisat_usb2_read_mac_address(struct dvb_usb_device *d,
> +		u8 mac[])
> +{
> +	u8 buf[EEPROM_MAC_TOTAL];
> +
> +	if (technisat_usb2_eeprom_lrc_read(d, EEPROM_MAC_START,
> +				buf, EEPROM_MAC_TOTAL, 4) != 0)
> +		return -ENODEV;
> +
> +	memcpy(mac, buf, 6);
> +	return 0;
> +}
> +
> +/* frontend attach */
> +static int technisat_usb2_set_voltage(struct dvb_frontend *fe,
> +		fe_sec_voltage_t voltage)
> +{
> +	int i;
> +	u8 gpio[3] = { 0 }; /* 0 = 2, 1 = 3, 2 = 4 */
> +
> +	gpio[2] = 1; /* high - voltage ? */
> +
> +	switch (voltage) {
> +	case SEC_VOLTAGE_13:
> +		gpio[0] = 1;
> +		break;
> +	case SEC_VOLTAGE_18:
> +		gpio[0] = 1;
> +		gpio[1] = 1;
> +		break;
> +	default:
> +	case SEC_VOLTAGE_OFF:
> +		break;
> +	}
> +
> +	for (i = 0; i < 3; i++)
> +		if (stv090x_set_gpio(fe, i+2, 0, gpio[i], 0) != 0)
> +			return -EREMOTEIO;
> +	return 0;
> +}
> +
> +static struct stv090x_config technisat_usb2_stv090x_config = {
> +	.device         = STV0903,
> +	.demod_mode     = STV090x_SINGLE,
> +	.clk_mode       = STV090x_CLK_EXT,
> +
> +	.xtal           = 8000000,
> +	.address        = 0x68,
> +
> +	.ts1_mode       = STV090x_TSMODE_DVBCI,
> +	.ts1_clk        = 13400000,
> +	.ts1_tei        = 1,
> +
> +	.repeater_level = STV090x_RPTLEVEL_64,
> +
> +	.tuner_bbgain   = 6,
> +};
> +
> +static struct stv6110x_config technisat_usb2_stv6110x_config = {
> +    .addr           = 0x60,
> +    .refclk         = 16000000,
> +    .clk_div        = 2,
> +};
> +
> +static int technisat_usb2_frontend_attach(struct dvb_usb_adapter *a)
> +{
> +	struct usb_device *udev = a->dev->udev;
> +	int ret;
> +
> +	a->fe = dvb_attach(stv090x_attach, &technisat_usb2_stv090x_config,
> +			&a->dev->i2c_adap, STV090x_DEMODULATOR_0);
> +
> +	if (a->fe) {
> +		struct stv6110x_devctl *ctl;
> +
> +		ctl = dvb_attach(stv6110x_attach,
> +				a->fe,
> +				&technisat_usb2_stv6110x_config,
> +				&a->dev->i2c_adap);
> +
> +		if (ctl) {
> +			technisat_usb2_stv090x_config.tuner_init          = ctl->tuner_init;
> +			technisat_usb2_stv090x_config.tuner_sleep         = ctl->tuner_sleep;
> +			technisat_usb2_stv090x_config.tuner_set_mode      = ctl->tuner_set_mode;
> +			technisat_usb2_stv090x_config.tuner_set_frequency = ctl->tuner_set_frequency;
> +			technisat_usb2_stv090x_config.tuner_get_frequency = ctl->tuner_get_frequency;
> +			technisat_usb2_stv090x_config.tuner_set_bandwidth = ctl->tuner_set_bandwidth;
> +			technisat_usb2_stv090x_config.tuner_get_bandwidth = ctl->tuner_get_bandwidth;
> +			technisat_usb2_stv090x_config.tuner_set_bbgain    = ctl->tuner_set_bbgain;
> +			technisat_usb2_stv090x_config.tuner_get_bbgain    = ctl->tuner_get_bbgain;
> +			technisat_usb2_stv090x_config.tuner_set_refclk    = ctl->tuner_set_refclk;
> +			technisat_usb2_stv090x_config.tuner_get_status    = ctl->tuner_get_status;
> +
> +			/* call the init function once to initialize
> +			   tuner's clock output divider and demod's
> +			   master clock */
> +			if (a->fe->ops.init)
> +				a->fe->ops.init(a->fe);
> +
> +			if (mutex_lock_interruptible(&a->dev->i2c_mutex) < 0)
> +				return -EAGAIN;
> +
> +			ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
> +					SET_IFCLK_TO_EXTERNAL_TSCLK_VENDOR_REQUEST,
> +					USB_TYPE_VENDOR | USB_DIR_OUT,
> +					0, 0,
> +					NULL, 0, 500);
> +			mutex_unlock(&a->dev->i2c_mutex);
> +
> +			if (ret != 0)
> +				err("could not set IF_CLK to external");
> +
> +			a->fe->ops.set_voltage = technisat_usb2_set_voltage;
> +
> +			/* if everything was successful assign a nice name to the frontend */
> +			strlcpy(a->fe->ops.info.name, a->dev->desc->name,
> +					sizeof(a->fe->ops.info.name));
> +		} else {
> +			dvb_frontend_detach(a->fe);
> +			a->fe = NULL;
> +		}
> +	}
> +
> +	technisat_usb2_set_led_timer(a->dev, 1, 1);
> +
> +	return a->fe == NULL ? -ENODEV : 0;
> +}
> +
> +/* Remote control */
> +
> +/* the device is giving providing raw IR-signals to the host mapping
> + * it only to one remote control is just the default implementation
> + */
> +#define NOMINAL_IR_BIT_TRANSITION_TIME_US 889
> +#define NOMINAL_IR_BIT_TIME_US (2 * NOMINAL_IR_BIT_TRANSITION_TIME_US)
> +
> +#define FIRMWARE_CLOCK_TICK 83333
> +#define FIRMWARE_CLOCK_DIVISOR 256
> +
> +#define IR_PERCENT_TOLERANCE 15
> +
> +#define NOMINAL_IR_BIT_TRANSITION_TICKS ((NOMINAL_IR_BIT_TRANSITION_TIME_US * 1000 * 1000) / FIRMWARE_CLOCK_TICK)
> +#define NOMINAL_IR_BIT_TRANSITION_TICK_COUNT (NOMINAL_IR_BIT_TRANSITION_TICKS / FIRMWARE_CLOCK_DIVISOR)
> +
> +#define NOMINAL_IR_BIT_TIME_TICKS ((NOMINAL_IR_BIT_TIME_US * 1000 * 1000) / FIRMWARE_CLOCK_TICK)
> +#define NOMINAL_IR_BIT_TIME_TICK_COUNT (NOMINAL_IR_BIT_TIME_TICKS / FIRMWARE_CLOCK_DIVISOR)
> +
> +#define MINIMUM_IR_BIT_TRANSITION_TICK_COUNT (NOMINAL_IR_BIT_TRANSITION_TICK_COUNT - ((NOMINAL_IR_BIT_TRANSITION_TICK_COUNT * IR_PERCENT_TOLERANCE) / 100))
> +#define MAXIMUM_IR_BIT_TRANSITION_TICK_COUNT (NOMINAL_IR_BIT_TRANSITION_TICK_COUNT + ((NOMINAL_IR_BIT_TRANSITION_TICK_COUNT * IR_PERCENT_TOLERANCE) / 100))
> +
> +#define MINIMUM_IR_BIT_TIME_TICK_COUNT (NOMINAL_IR_BIT_TIME_TICK_COUNT - ((NOMINAL_IR_BIT_TIME_TICK_COUNT * IR_PERCENT_TOLERANCE) / 100))
> +#define MAXIMUM_IR_BIT_TIME_TICK_COUNT (NOMINAL_IR_BIT_TIME_TICK_COUNT + ((NOMINAL_IR_BIT_TIME_TICK_COUNT * IR_PERCENT_TOLERANCE) / 100))
> +
> +static int technisat_usb2_get_ir(struct dvb_usb_device *d)
> +{
> +	u8 buf[62], *b;
> +	int ret;
> +	int bit_cnt = 1;
> +	u32 ir_data = 0x1,
> +		next_bit = 0x1;
> +
> +	buf[0] = GET_IR_DATA_VENDOR_REQUEST;
> +	buf[1] = 0x08;
> +	buf[2] = 0x8f;
> +	buf[3] = MINIMUM_IR_BIT_TRANSITION_TICK_COUNT;
> +	buf[4] = MAXIMUM_IR_BIT_TIME_TICK_COUNT;
> +
> +	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
> +		return -EAGAIN;
> +	ret = usb_control_msg(d->udev, usb_sndctrlpipe(d->udev, 0),
> +			GET_IR_DATA_VENDOR_REQUEST,
> +			USB_TYPE_VENDOR | USB_DIR_OUT,
> +			0, 0,
> +			buf, 5, 500);
> +	if (ret < 0)
> +		goto unlock;
> +
> +	buf[1] = 0;
> +	buf[2] = 0;
> +	ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
> +			GET_IR_DATA_VENDOR_REQUEST,
> +			USB_TYPE_VENDOR | USB_DIR_IN,
> +			0x8080, 0,
> +			buf, sizeof(buf), 500);
> +
> +unlock:
> +	mutex_unlock(&d->i2c_mutex);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret == 1)
> +		return 0; /* no key pressed */
> +
> +	/* decoding */
> +	b = buf+1;
> +
> +#if 0
> +	deb_rc("RC: %d ", ret);
> +	debug_dump(b, ret, deb_rc);
> +#endif
> +
> +	while (1) {
> +		/* if value is outside range */
> +		if ((*b < MINIMUM_IR_BIT_TRANSITION_TICK_COUNT ||
> +				*b > MAXIMUM_IR_BIT_TRANSITION_TICK_COUNT)
> +			&&
> +				(*b < MINIMUM_IR_BIT_TIME_TICK_COUNT ||
> +				*b > MAXIMUM_IR_BIT_TIME_TICK_COUNT))
> +			break;
> +
> +		next_bit = ir_data & 0x1;
> +		if (*b > 50)
> +			next_bit = !next_bit;
> +		ir_data <<= 1;
> +		ir_data |= next_bit;
> +
> +		if (*b < 50) {
> +			b++;
> +			if (*b == 0xff)
> +				break;
> +		}
> +
> +		bit_cnt++;
> +		if (bit_cnt > 13)
> +			break;
> +
> +		b++;
> +		if (*b == 0xff)
> +			break;
> +	}

Don't implement your own IR RC5 decoding logic. We have it already at IR core, 
and it is able to handle several protocols. Instead, just sent the raw events 
to RC core.

See drivers/media/dvb/siano/smsir.c for an example on how to do it.

> +
> +	return ir_data;
> +}
> +
> +static struct ir_scancode technisat_usb2_rc_keys[] = {
> +	{0x328c, KEY_POWER},
> +	{0x3281, KEY_1},
> +	{0x3282, KEY_2},
> +	{0x3283, KEY_3},
> +	{0x328d, KEY_MUTE},
> +	{0x3284, KEY_4},
> +	{0x3285, KEY_5},
> +	{0x3286, KEY_6},
> +	{0x32b8, KEY_VIDEO}, /* EXT */
> +	{0x3287, KEY_7},
> +	{0x3288, KEY_8},
> +	{0x3289, KEY_9},
> +	{0x3280, KEY_0},
> +	{0x228f, KEY_INFO},
> +	{0x32a0, KEY_CHANNELUP},
> +	{0x2292, KEY_MENU},
> +	{0x3291, KEY_VOLUMEUP},
> +	{0x2297, KEY_OK},
> +	{0x3290, KEY_VOLUMEDOWN},
> +	{0x32af, KEY_EPG},
> +	{0x32a1, KEY_CHANNELDOWN},
> +	{0x32a2, KEY_REFRESH},
> +	{0x32bc, KEY_TEXT},
> +	{0x22b6, KEY_ENTER}, /* HOOK */
> +	{0x328f, KEY_HELP},
> +	{0x22ab, KEY_RED},
> +	{0x22ac, KEY_GREEN},
> +	{0x22ad, KEY_YELLOW},
> +	{0x22ae, KEY_BLUE},
> +	{0x32a9, KEY_STOP},
> +	{0x32a3, KEY_LANGUAGE},
> +	{0x2293, KEY_TV},
> +	{0x328a, KEY_PROGRAM},
> +};

Also, don't put the RC tables at the driver. Move it to a separate file, at drivers/media/IR/keymaps/.
This allows importing the RC keycodes by ir-keytable userspace tool (from v4l-utils.git).

> +
> +static int technisat_usb2_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
> +{
> +	struct technisat_usb2_state *priv = d->priv;
> +	const struct ir_scancode *keymap = technisat_usb2_rc_keys;
> +	int ret = technisat_usb2_get_ir(d);
> +	int i;
> +
> +	*event = 0;
> +	*state = REMOTE_NO_KEY_PRESSED;
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret == 0)
> +		return 0;
> +
> +	if (!disable_led_control)
> +		technisat_usb2_set_led(d, 1, LED_BLINK);
> +
> +	for (i = 0; i < ARRAY_SIZE(technisat_usb2_rc_keys); i++) {
> +		if (keymap[i].scancode == (ret & 0xf7ff))
> +			break;
> +	}
> +
> +	deb_rc("key: 0x%04x, toggle: %d\n", ret & 0xf7ff, !!(ret & 0x0800));
> +	if (i == ARRAY_SIZE(technisat_usb2_rc_keys)) {
> +		deb_rc("unknown scan code: 0x%04x\n", ret & 0xf7ff);
> +		return 0;
> +	}
> +
> +	/* swallow first keypress */
> +	if (priv->last_scan_code != ret)
> +		priv->last_scan_code = ret;
> +	else {
> +		*event = keymap[i].keycode;
> +		*state = REMOTE_KEY_PRESSED;
> +	}
> +
> +	return 0;
> +}
> +
> +/* DVB-USB and USB stuff follows */
> +static struct usb_device_id technisat_usb2_id_table[] = {
> +	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_DVB_S2) },
> +	{ 0 }		/* Terminating entry */
> +};
> +
> +/* device description */
> +static struct dvb_usb_device_properties technisat_usb2_devices = {
> +	.caps              = DVB_USB_IS_AN_I2C_ADAPTER,
> +
> +	.usb_ctrl          = CYPRESS_FX2,
> +
> +	.identify_state    = technisat_usb2_identify_state,
> +	.firmware          = "dvb-usb-SkyStar_USB_HD_FW_v17_63.HEX.fw",
> +
> +	.size_of_priv      = sizeof(struct technisat_usb2_state),
> +
> +	.i2c_algo          = &technisat_usb2_i2c_algo,
> +
> +	.power_ctrl        = technisat_usb2_power_ctrl,
> +	.read_mac_address  = technisat_usb2_read_mac_address,
> +
> +	.num_adapters = 1,
> +	.adapter = {
> +		{
> +			.frontend_attach  = technisat_usb2_frontend_attach,
> +
> +			.stream = {
> +				.type = USB_ISOC,
> +				.count = 8,
> +				.endpoint = 0x2,
> +				.u = {
> +					.isoc = {
> +						.framesperurb = 32,
> +						.framesize = 2048,
> +						.interval = 3,
> +					}
> +				}
> +			},
> +
> +			.size_of_priv = 0,
> +		},
> +	},
> +
> +	.num_device_descs = 1,
> +	.devices = {
> +		{   "Technisat SkyStar USB HD (DVB-S/S2)",
> +			{ &technisat_usb2_id_table[0], NULL },
> +			{ NULL },
> +		},
> +	},
> +
> +	.rc.legacy = {
> +		.rc_interval      = 100,
> +		.rc_key_map       = technisat_usb2_rc_keys,
> +		.rc_key_map_size  = ARRAY_SIZE(technisat_usb2_rc_keys),
> +		.rc_query         = technisat_usb2_rc_query,
> +	},
> +};
> +
> +static int technisat_usb2_probe(struct usb_interface *intf,
> +		const struct usb_device_id *id)
> +{
> +	struct dvb_usb_device *dev;
> +
> +	if (dvb_usb_device_init(intf, &technisat_usb2_devices, THIS_MODULE,
> +				&dev, adapter_nr) != 0)
> +		return -ENODEV;
> +
> +	if (dev) {
> +		struct technisat_usb2_state *state = dev->priv;
> +		state->dev = dev;
> +
> +		if (!disable_led_control) {
> +			INIT_DELAYED_WORK(&state->green_led_work,
> +					technisat_usb2_green_led_control);
> +			schedule_delayed_work(&state->green_led_work,
> +					msecs_to_jiffies(500));
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void technisat_usb2_disconnect(struct usb_interface *intf)
> +{
> +	struct dvb_usb_device *dev = usb_get_intfdata(intf);
> +
> +	/* work and stuff was only created when the device is is hot-state */
> +	if (dev != NULL) {
> +		struct technisat_usb2_state *state = dev->priv;
> +		if (state != NULL) {
> +			cancel_rearming_delayed_work(&state->green_led_work);
> +			flush_scheduled_work();
> +		}
> +	}
> +
> +	dvb_usb_device_exit(intf);
> +}
> +
> +static struct usb_driver technisat_usb2_driver = {
> +	.name       = "dvb_usb_technisat_usb2",
> +	.probe      = technisat_usb2_probe,
> +	.disconnect = technisat_usb2_disconnect,
> +	.id_table   = technisat_usb2_id_table,
> +};
> +
> +/* module stuff */
> +static int __init technisat_usb2_module_init(void)
> +{
> +	int result = usb_register(&technisat_usb2_driver);
> +	if (result) {
> +		err("usb_register failed. Code %d", result);
> +		return result;
> +	}
> +
> +	return 0;
> +}
> +
> +static void __exit technisat_usb2_module_exit(void)
> +{
> +	usb_deregister(&technisat_usb2_driver);
> +}
> +
> +module_init(technisat_usb2_module_init);
> +module_exit(technisat_usb2_module_exit);
> +
> +MODULE_AUTHOR("Patrick Boettcher <pboettcher@kernellabs.com>");
> +MODULE_DESCRIPTION("Driver for Technisat DVB-S/S2 USB 2.0 device");
> +MODULE_VERSION("1.0");
> +MODULE_LICENSE("GPL");
> -- 
> 1.7.1
> 
