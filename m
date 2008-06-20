Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <joshoekstra@gmx.net>) id 1K9giU-0005Dz-QX
	for linux-dvb@linuxtv.org; Fri, 20 Jun 2008 15:31:55 +0200
Message-ID: <485BB11E.6060204@gmx.net>
Date: Fri, 20 Jun 2008 15:31:10 +0200
From: Jos Hoekstra <joshoekstra@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------000800020107040203000109"
Cc: crope@iki.fi
Subject: [linux-dvb] Avermedia DVB-T Volar X
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------000800020107040203000109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This device has the following chips on it:
AF9015-NT*
MXL5003S

This device seems to work with the following additions to af9015.c in
the tree found under:

http://linuxtv.org/hg/~anttip/af9015-mxl500x/

Added under static struct usb_device_id af9015_usb_table[]:

	/* AverMedia DVB-T Volar X) */
	{USB_DEVICE(0x07ca,             0xa815)},

Added/ changed under static struct dvb_usb_device_properties
af9015_properties:

	.num_device_descs = 8, /* to add another case, without it the change
didn't get picked up. */

and:

		{
			.name = " AverMedia DVB-T Volar X",
			.cold_ids = {&af9015_usb_table[8], NULL},
			.warm_ids = {NULL},
		},

With these changes, which are in attached file as well, the normal make,
make install routine works and plugging the stick in to the usb-port it
gets recognized and firmware of:
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/

It can scan, tune and watch FTA-channels :)

Hope this helps and can be added to the official driver somehow?

Regards,

Jos Hoekstra



--------------000800020107040203000109
Content-Type: text/plain;
 name="af9015.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="af9015.c"

/*
 * DVB USB Linux driver for Afatech AF9015 DVB-T USB2.0 receiver
 *
 * Copyright (C) 2007 Antti Palosaari <crope@iki.fi>
 *
 * Thanks to Afatech who kindly provided information.
 *
 *    This program is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 2 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program; if not, write to the Free Software
 *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */

#include "af9015.h"
#include "af9013.h"
#include "mt2060.h"
#include "qt1010.h"
#include "tda18271.h"
#include "mxl500x.h"

/* debug */
int dvb_usb_af9015_debug = 0x3d;

module_param_named(debug, dvb_usb_af9015_debug, int, 0644);
MODULE_PARM_DESC(
	debug,
	"set debugging level (1=info,xfer=2,rc=4,reg=8,i2c=16,fw=32 (or-able))."
	DVB_USB_DEBUG_STATUS);

static struct af9013_config af9015_af9013_config[2] = {
	{
		.demod_address = AF9015_I2C_DEMOD,
		.ts_mode = AF9013_USB,
	}, {
		.demod_address = 0x3a,
		.ts_mode = AF9013_SERIAL_TS,
	}
};

static int af9015_rw_udev(struct usb_device *udev, struct req_t *req)
{
	int act_len, ret;
	u8 buf[64];
	u8 write = 1;
	u8 msg_len = 8;
	static u8 seq; /* packet sequence number */

	buf[0] = req->cmd;
	buf[1] = seq++;
	buf[2] = req->i2c_addr;
	buf[3] = req->addr >> 8;
	buf[4] = req->addr & 0xff;
	buf[5] = req->data0;
	buf[6] = req->data1;
	buf[7] = req->len;

	switch (req->cmd) {
	case GET_CONFIG:
	case BOOT:
	case READ_MEMORY:
	case RECONNECT_USB:
	case GET_IR_CODE:
		write = 0;
		break;
	case READ_I2C:
		write = 0;
		buf[2] |= 0x01; /* set I2C direction */
	case WRITE_I2C:
		buf[0] = READ_WRITE_I2C;
		break;
	case WRITE_VIRTUAL_MEMORY:
	case WRITE_MEMORY:
		if (((req->addr & 0xff00) == 0xff00) ||
		    ((req->addr & 0xae00) == 0xae00))
			buf[0] = WRITE_VIRTUAL_MEMORY;
	case COPY_FIRMWARE:
	case DOWNLOAD_FIRMWARE:
		break;
	default:
		err("%s: unknown command: %d", __func__, req->cmd);
	}

	/* write requested */
	if (write) {
		memcpy(&buf[8], req->data, req->len);
		msg_len += req->len;
	}
	deb_xfer(">>> ");
	debug_dump(buf, msg_len, deb_xfer);

	/* send req */
	ret = usb_bulk_msg(udev, usb_sndbulkpipe(udev, 0x02), buf, msg_len,
	&act_len, AF9015_USB_TIMEOUT);
	if (ret)
		err("%s: sending failed: %d (%d/%d)", __func__,
		    ret, msg_len, act_len);
	else
		if (act_len != msg_len)
			return -1; /* all data is not send */

	/* no ack for those packets */
	if (req->cmd == DOWNLOAD_FIRMWARE || req->cmd == RECONNECT_USB)
		return 0;

	/* receive ack and data if read req */
	msg_len = 1 + 1 + req->len;  /* seq + status + data len */
	ret = usb_bulk_msg(udev, usb_rcvbulkpipe(udev, 0x81), buf, msg_len,
			   &act_len, AF9015_USB_TIMEOUT);
	if (ret) {
		err("%s: receiving failed: %d", __func__, ret);
		return ret;
	}

	deb_xfer("<<< ");
	debug_dump(buf, act_len, deb_xfer);

	/* check status */
	if (buf[1]) {
		err("%s: command failed: %d", __func__, buf[1]);
		return -1;
	}

	/* read request, copy returned data to return buf */
	if (!write)
		memcpy(req->data, &buf[2], req->len);

	return 0;
}

static int af9015_rw(struct dvb_usb_device *d, struct req_t *req)
{
	int ret;

	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
		return -EAGAIN;

	ret = af9015_rw_udev(d->udev, req);

	mutex_unlock(&d->i2c_mutex);

	return ret;
}

static int af9015_write_reg(struct dvb_usb_device *d, u16 addr, u8 val)
{
	struct req_t req = { WRITE_MEMORY, AF9015_I2C_DEMOD, addr, 0, 0, 1,
		&val };
	return af9015_rw(d, &req);
}

static int af9015_read_reg(struct dvb_usb_device *d, u16 addr, u8 *val)
{
	struct req_t req = { READ_MEMORY, AF9015_I2C_DEMOD, addr, 0, 0, 1,
		val };
	return af9015_rw(d, &req);
}

static int af9015_write_reg_i2c(struct dvb_usb_device *d, u8 addr, u16 reg,
	u8 val)
{
	struct req_t req = { WRITE_I2C, addr, reg, 1, 3, 1, &val };
	return af9015_rw(d, &req);
}

static int af9015_read_reg_i2c(struct dvb_usb_device *d, u8 addr, u16 reg,
	u8 *val)
{
	struct req_t req = { READ_I2C, addr, reg, 0, 3, 1, val };
	return af9015_rw(d, &req);
}

static int af9015_i2c_write_regs(struct dvb_usb_device *d, u8 addr, u8 reg,
	u8 *val, u8 count)
{
	struct req_t req = { WRITE_I2C, addr, reg, 0, 1, count, val };
	return af9015_rw(d, &req);
}

#if 0
static int af9015_i2c_write_reg(struct dvb_usb_device *d, u8 addr, u8 reg,
	u8 val)
{
	return af9015_i2c_write_regs(d, addr, reg, &val, 1);
}
#endif

static int af9015_i2c_read_reg(struct dvb_usb_device *d, u8 addr, u8 reg,
	u8 *val)
{
	struct req_t req = { READ_I2C, addr, reg, 0, 1, 1, val };
	return af9015_rw(d, &req);
}

#if 0
static int af9015_eeprom_write_reg(struct dvb_usb_device *d, u8 addr, u8 val)
{
	return af9015_i2c_write_reg(d, AF9015_I2C_EEPROM, addr, val);
}
#endif

static int af9015_eeprom_read_reg(struct dvb_usb_device *d, u8 addr, u8 *val)
{
	return af9015_i2c_read_reg(d, AF9015_I2C_EEPROM, addr, val);
}

static int af9015_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
	int num)
{
	struct dvb_usb_device *d = i2c_get_adapdata(adap);
	int ret = 0;
	u16 addr;

#if 0
	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
		return -EAGAIN;
#endif

	if (num > 2) {
		warn("more than 2 i2c messages at a time is not handled yet");
		return -EINVAL;
	}

	if (msg[0].addr == AF9015_I2C_DEMOD ||
	    msg[0].addr == 0x3a) { /* 0x38 is targeted to demod */
		addr = msg[0].buf[0] << 8;
		addr += msg[0].buf[1];
#if 1
		if (msg[0].addr == AF9015_I2C_DEMOD) {
			if (num == 2) {
				/* reads a single register */
				ret = af9015_read_reg(d, addr, &msg[1].buf[0]);
				if (!ret)
					ret = 2;
			} else {
				/* writes a single register */
				ret = af9015_write_reg(d, addr, msg[0].buf[2]);
				if (!ret)
					ret = 1;
			}
		} else {
			if (num == 2) {
				/* reads a single register */
				ret = af9015_read_reg_i2c(d, msg[0].addr, addr,
					&msg[1].buf[0]);
				if (!ret)
					ret = 2;
			} else {
				/* writes a single register */
				ret = af9015_write_reg_i2c(d, msg[0].addr, addr,
					msg[0].buf[2]);
				if (!ret)
					ret = 1;
			}
		}
#else
		if (num == 2) {
			/* reads a single register */
			ret = af9015_read_reg_i2c(d, msg[0].addr, addr,
				&msg[1].buf[0]);
			if (!ret)
				ret = 2;
		} else {
			/* writes a single register */
			ret = af9015_write_reg_i2c(d, msg[0].addr, addr,
				msg[0].buf[2]);
			if (!ret)
				ret = 1;
		}
#endif


	} else { /* normal i2c request, for e.g. tuner */
		if (num == 2) {
			/* reads a single register */
			ret = af9015_i2c_read_reg(d, msg[0].addr, *msg[0].buf,
				msg[1].buf);
			if (!ret)
				ret = 2;
		} else {
			/* writes a single register */
			ret = af9015_i2c_write_regs(d, msg[0].addr,
				msg[0].buf[0], &msg[0].buf[1], msg[0].len-1);
			if (!ret)
				ret = 1;
		}
	}

#if 0
	mutex_unlock(&d->i2c_mutex);
#endif
	return ret;
}

static u32 af9015_i2c_func(struct i2c_adapter *adapter)
{
	return I2C_FUNC_I2C;
}

static struct i2c_algorithm af9015_i2c_algo = {
	.master_xfer = af9015_i2c_xfer,
	.functionality = af9015_i2c_func,
};

static int af9015_do_reg_bit(struct dvb_usb_device *d, u16 addr, u8 bit, u8 op)
{
	int ret;
	u8 val, mask = 0x01;

	ret = af9015_read_reg(d, addr, &val);
	if (ret)
		return ret;

	mask <<= bit;
	if (op) {
		/* set bit */
		val |= mask;
	} else {
		/* clear bit */
		mask ^= 0xff;
		val &= mask;
	}

	return af9015_write_reg(d, addr, val);
}

static int af9015_set_reg_bit(struct dvb_usb_device *d, u16 addr, u8 bit)
{
	return af9015_do_reg_bit(d, addr, bit, 1);
}

static int af9015_clear_reg_bit(struct dvb_usb_device *d, u16 addr, u8 bit)
{
	return af9015_do_reg_bit(d, addr, bit, 0);
}

static int af9015_init_endpoint(struct dvb_usb_device *d)
{
	int ret;
	struct af9015_state *state = d->priv;
	u16 frame_size;
	u8  packet_size;
	deb_info("%s: USB speed:%d\n", __func__, d->udev->speed);

#define TS_PACKET_SIZE            188

#define TS_USB20_PACKET_COUNT     348
#define TS_USB20_FRAME_SIZE       (TS_PACKET_SIZE*TS_USB20_PACKET_COUNT)

#define TS_USB11_PACKET_COUNT      21
#define TS_USB11_FRAME_SIZE       (TS_PACKET_SIZE*TS_USB11_PACKET_COUNT)

#define TS_USB20_MAX_PACKET_SIZE  512
#define TS_USB11_MAX_PACKET_SIZE   64

	if (d->udev->speed == USB_SPEED_FULL) {
		frame_size = TS_USB11_FRAME_SIZE/4;
		packet_size = TS_USB11_MAX_PACKET_SIZE/4;
	} else {
		frame_size = TS_USB20_FRAME_SIZE/4;
		packet_size = TS_USB20_MAX_PACKET_SIZE/4;
	}

	ret = af9015_set_reg_bit(d, 0xd507, 2); /* assert EP4 reset */
	if (ret)
		goto exit;
	ret = af9015_set_reg_bit(d, 0xd50b, 1); /* assert EP5 reset */
	if (ret)
		goto exit;
	ret = af9015_clear_reg_bit(d, 0xdd11, 5); /* disable EP4 */
	if (ret)
		goto exit;
	ret = af9015_clear_reg_bit(d, 0xdd11, 6); /* disable EP5 */
	if (ret)
		goto exit;
	ret = af9015_set_reg_bit(d, 0xdd11, 5); /* enable EP4 */
	if (ret)
		goto exit;
	if (state->dual_mode) {
		ret = af9015_set_reg_bit(d, 0xdd11, 6); /* enable EP5 */
		if (ret)
			goto exit;
	}
	ret = af9015_clear_reg_bit(d, 0xdd13, 5); /* disable EP4 NAK */
	if (ret)
		goto exit;
	if (state->dual_mode) {
		ret = af9015_clear_reg_bit(d, 0xdd13, 6); /* disable EP5 NAK */
		if (ret)
			goto exit;
	}
	/* EP4 xfer length */
	ret = af9015_write_reg(d, 0xdd88, frame_size & 0xff);
	if (ret)
		goto exit;
	ret = af9015_write_reg(d, 0xdd89, frame_size >> 8);
	if (ret)
		goto exit;
	/* EP5 xfer length */
	ret = af9015_write_reg(d, 0xdd8a, frame_size & 0xff);
	if (ret)
		goto exit;
	ret = af9015_write_reg(d, 0xdd8b, frame_size >> 8);
	if (ret)
		goto exit;
	ret = af9015_write_reg(d, 0xdd0c, packet_size); /* EP4 packet size */
	if (ret)
		goto exit;
	ret = af9015_write_reg(d, 0xdd0d, packet_size); /* EP5 packet size */
	if (ret)
		goto exit;
	ret = af9015_clear_reg_bit(d, 0xd507, 2); /* negate EP4 reset */
	if (ret)
		goto exit;
	if (state->dual_mode) {
		ret = af9015_clear_reg_bit(d, 0xd50b, 1); /* negate EP5 reset */
		if (ret)
			goto exit;
	}

	/* enable / disable mp2if2 */
	if (state->dual_mode)
		ret = af9015_set_reg_bit(d, 0xd50b, 0);
	else
		ret = af9015_clear_reg_bit(d, 0xd50b, 0);

exit:
	if (ret)
		err("%s: failed:%d", __func__, ret);
	return ret;
}

#define MERC_FW_DOWNLOAD_BASE 0x5100
#define MERC_FW_STATUS        0x98be
#define MERC_BOOT_REQUEST     0xe205
static int af9015_copy_firmware(struct dvb_usb_device *d)
{
	int ret;
	u8 buf[] = { 0x3e, 0x29, 0x98, 0x8d }; /* FW len & checksum FIXME */
	u8 val;
	struct req_t req = { COPY_FIRMWARE, 0, MERC_FW_DOWNLOAD_BASE, 0, 0,
		sizeof(buf), buf };

	deb_info("%s:\n", __func__);

	/* check firmware status */
	ret = af9015_read_reg_i2c(d, 0x3a, MERC_FW_STATUS, &val);
	if (ret)
		goto exit;
	deb_info("%s: firmware status:%02x\n", __func__, val);

	/* copy firmware */
	/* set I2C master clock to fast */
	ret = af9015_write_reg(d, 0xd416, 0x04); /* 0x04 * 400ns */
	if (ret)
		goto exit;

	msleep(50);

	ret = af9015_rw(d, &req);
	if (ret)
		goto exit;

	/* set I2C master clock back to normal */
	ret = af9015_write_reg(d, 0xd416, 0x01); /* 0x14 * 400ns */
	if (ret)
		goto exit;

	msleep(100);

	/* request boot firmware */
	ret = af9015_write_reg_i2c(d, 0x3a, MERC_BOOT_REQUEST, 1);
	if (ret)
		goto exit;

	msleep(100);

	/* check firmware status */
	ret = af9015_read_reg_i2c(d, 0x3a, MERC_FW_STATUS, &val);
	if (ret)
		goto exit;

exit:
	if (ret) {
		err("%s: failed, err:%d", __func__, ret);
		deb_info("%s: failed, err:%d\n", __func__, ret);
	}

	return ret;
}

/* dump eeprom */
static int af9015_eeprom_dump(struct dvb_usb_device *d)
{
	char buf[52], buf2[4];
	u8 reg, val;
	deb_info("%s:\n", __func__);

	for (reg = 0; ; reg++) {
		if (reg % 16 == 0) {
			if (reg)
				deb_info("%s\n", buf);
			sprintf(buf, "%02x: ", reg);
		}
		if (af9015_eeprom_read_reg(d, reg, &val) == 0)
			sprintf(buf2, "%02x ", val);
		else
			strcpy(buf2, "-- ");
		strcat(buf, buf2);
		if (reg == 0xff)
			break;
	}
	deb_info("%s\n", buf);
	return 0;
}

int af9015_download_ir_table(struct dvb_usb_device *d)
{
	int i, packets, ret;
	u16 addr = 0x9a56; /* ir-table start address */
	struct req_t req = { WRITE_MEMORY, AF9015_I2C_DEMOD, 0, 0, 0, 1, NULL };

	deb_info("%s:\n", __func__);

	packets = sizeof(ir_table);
	for (i = 0; i < packets; i++) {
		req.addr = addr + i;
		req.data = &ir_table[i];
		ret = af9015_rw(d, &req);
		if (ret) {
			err("%s: ir-table download failed at packet %d with " \
				"code %d", __func__, i, ret);
			return ret;
		}
	}
	return 0;
}

static int af9015_set_gpio(struct dvb_usb_device *d, u8 gpio, u8 gpioval)
{
	int ret;
	u8 regval;
	u16 addr;
	deb_info("%s: gpio:%d gpioval:%02x\n", __func__, gpio, gpioval);

/* GPIO0 & GPIO1 0xd735
   GPIO2 & GPIO3 0xd736 */

	switch (gpio) {
	case 0:
	case 1:
		addr = 0xd735;
		break;
	case 2:
	case 3:
		addr = 0xd736;
		break;

	default:
		err("%s: invalid gpio:%d\n", __func__, gpio);
		ret = -EINVAL;
		goto exit;
	};

	ret = af9015_read_reg(d, addr, &regval);
	if (ret)
		goto exit;

	switch (gpio) {
	case 0:
	case 2:
		regval &= 0xf0;
		regval |= (gpioval << 0);
		break;
	case 1:
	case 3:
		regval &= 0x0f;
		regval |= (gpioval << 4);
		break;
	};

	ret = af9015_write_reg(d, addr, regval);

exit:
	if (ret)
		err("%s: failed, err:%d", __func__, ret);
	return ret;
}

static int af9015_init(struct dvb_usb_device *d)
{
	int ret;
	deb_info("%s:\n", __func__);

	ret = af9015_init_endpoint(d);
	if (ret)
		goto exit;

	ret = af9015_download_ir_table(d);
	if (ret)
		goto exit;

exit:
	return ret;
}

static int af9015_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
{
	int ret;
	deb_info("%s: onoff:%d\n", __func__, onoff);

#if 0
	if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
		return -EAGAIN;
#endif

	if (onoff)
		ret = af9015_set_reg_bit(adap->dev, 0xd503, 0);
	else
		ret = af9015_clear_reg_bit(adap->dev, 0xd503, 0);

#if 0
	mutex_unlock(&adap->dev->i2c_mutex);
#endif

	return ret;
}

static int af9015_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
	int onoff)
{
	int ret;
	u8 idx;

	deb_info("%s: set pid filter, index %d, pid %x, onoff %d\n",
		__func__, index, pid, onoff);

#if 0
	if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
		return -EAGAIN;
#endif

	ret = af9015_write_reg(adap->dev, 0xd505, (pid & 0xff));
	if (ret)
		goto exit;

	ret = af9015_write_reg(adap->dev, 0xd506, (pid >> 8));
	if (ret)
		goto exit;

	idx = ((index & 0x1f) | (1 << 5));
	ret = af9015_write_reg(adap->dev, 0xd504, idx);

exit:
#if 0
	mutex_unlock(&adap->dev->i2c_mutex);
#endif

	return ret;
}

static int af9015_download_firmware(struct usb_device *udev,
	const struct firmware *fw)
{
	int i, len, packets, remainder, ret;
	struct req_t req = { DOWNLOAD_FIRMWARE, AF9015_I2C_DEMOD, 0, 0, 0, 0,
		NULL };
	u16 addr = 0x5100; /* firmware start address */
	u8 tmp;

	deb_info("%s:\n", __func__);

	#define FW_PACKET_MAX_DATA  55

	packets = fw->size / FW_PACKET_MAX_DATA;
	remainder = fw->size % FW_PACKET_MAX_DATA;
	len = FW_PACKET_MAX_DATA;
	for (i = 0; i <= packets; i++) {
		if (i == packets)  /* set size of the last packet */
			len = remainder;

		req.len = len;
		req.data = (fw->data + i * FW_PACKET_MAX_DATA);
		req.addr = addr;
		addr += FW_PACKET_MAX_DATA;

		ret = af9015_rw_udev(udev, &req);
		if (ret) {
			err("%s: firmware download failed at packet %d with " \
				"code %d", __func__, i, ret);
			goto exit;
		}
	}
	#undef FW_PACKET_MAX_DATA

	/* firmware loaded, request boot */
	req.cmd = BOOT;
	ret = af9015_rw_udev(udev, &req);
	if (ret) {
		err("%s: boot failed: %d", __func__, ret);
		goto exit;
	}
#if 0
	msleep(1);

	/* boot done, ensure that firmware is running */
	req.cmd = GET_CONFIG;
	req.len = 1;
	req.data = &tmp;
	ret = af9015_rw_udev(udev, &req);
	if (ret) {
		err("%s: get config failed: %d", __func__, ret);
		goto exit;
	}

	if (tmp != 0x02) {
		err("%s: firmware did not run (%02x)", __func__, tmp);
		return -EIO;
	}
#endif
#if 1
	/* firmware is running, reconnect device in the usb bus */
	req.cmd = RECONNECT_USB;
	ret = af9015_rw_udev(udev, &req);
	if (ret)
		err("%s: reconnect failed: %d", __func__, ret);
#endif
exit:
	return ret;
}

static int af9015_read_config(struct dvb_usb_device *d)
{
	int ret;
	struct af9015_state *state = d->priv;
	u8 val;

#if 0
	/* remote */
	ret = af9015_eeprom_read_reg(d, AF9015_EEPROM_IR_MODE, &val);
	if (ret)
		goto exit;
	deb_info("%s: ir mode:%d\n", __func__, val);

	ret = af9015_eeprom_read_reg(d, AF9015_EEPROM_IR_REMOTE_TYPE, &val);
	if (ret)
		goto exit;
	deb_info("%s: ir remote type:%d\n", __func__, val);
#endif

	/* TS mode - one or two receivers */
	ret = af9015_eeprom_read_reg(d, AF9015_EEPROM_TS_MODE, &val);
	if (ret)
		goto exit;
	state->dual_mode = val;
	deb_info("%s: TS mode:%d\n", __func__, val);

	/* xtal */
	ret = af9015_eeprom_read_reg(d, AF9015_EEPROM_XTAL_TYPE1, &val);
	if (ret)
		goto exit;
	switch (val) {
	case 0:
		af9015_af9013_config[0].adc_clock = 28800;
		af9015_af9013_config[1].adc_clock = 28800;
		break;
	case 1:
		af9015_af9013_config[0].adc_clock = 20480;
		af9015_af9013_config[1].adc_clock = 20480;
		break;
	case 2:
		af9015_af9013_config[0].adc_clock = 28000;
		af9015_af9013_config[1].adc_clock = 28000;
		break;
	case 3:
		af9015_af9013_config[0].adc_clock = 25000;
		af9015_af9013_config[1].adc_clock = 25000;
		break;
	};
	deb_info("%s: xtal:%d set adc_clock:%d\n", __func__, val,
		 af9015_af9013_config[0].adc_clock);

	/* tuner IF */
	ret = af9015_eeprom_read_reg(d, AF9015_EEPROM_IF1H, &val);
	if (ret)
		goto exit;
	af9015_af9013_config[0].tuner_if = val << 8;
	ret = af9015_eeprom_read_reg(d, AF9015_EEPROM_IF1L, &val);
	if (ret)
		goto exit;
	af9015_af9013_config[0].tuner_if += val;
	deb_info("%s: IF1:%d\n", __func__, af9015_af9013_config[0].tuner_if);

	af9015_af9013_config[1].tuner_if = af9015_af9013_config[0].tuner_if;

	/* MT2060 IF1 */
	ret = af9015_eeprom_read_reg(d, AF9015_EEPROM_MT2060_IF1H, &val);
	if (ret)
		goto exit;
	state->mt2060_if1 = val << 8;
	ret = af9015_eeprom_read_reg(d, AF9015_EEPROM_MT2060_IF1L, &val);
	if (ret)
		goto exit;
	state->mt2060_if1 += val;
	deb_info("%s: MT2060 IF1:%d\n", __func__, state->mt2060_if1);

	/* tuner */
	ret = af9015_eeprom_read_reg(d, AF9015_EEPROM_TUNER_ID1, &val);
	if (ret)
		goto exit;
	switch (val) {
	case AF9013_TUNER_MT2060:
	case AF9013_TUNER_QT1010:
	case AF9013_TUNER_TDA18271:
		af9015_af9013_config[0].rf_spec_inv = 1;
		break;
	case AF9013_TUNER_MXL5003D:
	case AF9013_TUNER_MXL5005D:
	case AF9013_TUNER_MXL5005R:
		af9015_af9013_config[0].rf_spec_inv = 0;
		af9015_af9013_config[1].rf_spec_inv = 0;
		break;
	default:
		warn("%s: tuner id:%d not supported, please report!",
			__func__, val);
		return -ENODEV;
	};
	af9015_af9013_config[0].tuner = val;
	af9015_af9013_config[1].tuner = val;
	deb_info("%s: tuner id1:%d\n", __func__, val);

	/* spectral inversion */
	ret = af9015_eeprom_read_reg(d, AF9015_EEPROM_SPEC_INV1, &val);
	if (ret)
		goto exit;
	/* does this really have any meaning? looks like it is always 0...
	af9015_af9013_config.rf_spec_inv = val; */
	deb_info("%s: spectral inversion:%d\n", __func__, val);

exit:
	if (ret)
		err("%s: eeprom read failed, err:%d", __func__, ret);
	return ret;
}

static int af9015_identify_state(struct usb_device *udev,
				 struct dvb_usb_device_properties *props,
				 struct dvb_usb_device_description **desc,
				 int *cold)
{
	int ret;
	u8 reply;
	struct req_t req = { GET_CONFIG, AF9015_I2C_DEMOD, 0, 0, 0, 1, &reply };

	ret = af9015_rw_udev(udev, &req);
	if (ret)
		return ret;

	deb_info("%s: reply:%02x\n", __func__, reply);
	if (reply == 0x02)
		*cold = 0;
	else
		*cold = 1;

	return ret;
}

/* A-Link DTU(m) */
static struct dvb_usb_rc_key af9015_rc_keys[] = {
	{ 0x00, 0x1e, KEY_1 },
	{ 0x00, 0x1f, KEY_2 },
	{ 0x00, 0x20, KEY_3 },
	{ 0x00, 0x21, KEY_4 },
	{ 0x00, 0x22, KEY_5 },
	{ 0x00, 0x23, KEY_6 },
	{ 0x00, 0x24, KEY_7 },
	{ 0x00, 0x25, KEY_8 },
	{ 0x00, 0x26, KEY_9 },
	{ 0x00, 0x27, KEY_0 },
	{ 0x00, 0x2e, KEY_CHANNELUP },
	{ 0x00, 0x2d, KEY_CHANNELDOWN },
	{ 0x04, 0x28, KEY_ZOOM },
	{ 0x00, 0x41, KEY_MUTE },
	{ 0x00, 0x42, KEY_VOLUMEDOWN },
	{ 0x00, 0x43, KEY_VOLUMEUP },
	{ 0x00, 0x44, KEY_GOTO },         /* jump */
	{ 0x05, 0x45, KEY_POWER },
};

static int af9015_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
{
	u8 buf[8];
	struct req_t req = { GET_IR_CODE, 0, 0, 0, 0, sizeof(buf), buf };
	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
	int i, ret;

#if 0
	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
		return -EAGAIN;
#endif
	ret = af9015_rw(d, &req);

#if 0
	mutex_unlock(&d->i2c_mutex);
#endif

	if (ret)
		return ret;

	*event = 0;
	*state = REMOTE_NO_KEY_PRESSED;

	for (i = 0; i < d->props.rc_key_map_size; i++) {
		if (keymap[i].custom == buf[0] &&
		    keymap[i].data == buf[2]) {
			*event = keymap[i].event;
			*state = REMOTE_KEY_PRESSED;
			return 0;
		}
	}
	return 0;
}

static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
{
	int ret;
	struct af9015_state *state = adap->dev->priv;

	/* dump eeprom (debug) */
	ret = af9015_eeprom_dump(adap->dev);
	if (ret)
		return ret;

	/* read configuration from eeprom */
	ret = af9015_read_config(adap->dev);
	if (ret)
		return ret;

	/* copy firmware to 2nd demodulator */
	if (state->dual_mode) {
		ret = af9015_copy_firmware(adap->dev);
		if (ret) {
			info("%s: firmware copy to 2nd frontend failed, " \
				"will disable it", __func__);
			state->dual_mode = 0;
			ret = 0;
		}
	}

	/* attach demodulator */
	adap->fe = dvb_attach(af9013_attach, &af9015_af9013_config[0],
		&adap->dev->i2c_adap);
	if (adap->fe != NULL)
		return 0;

	return -EIO;
}

static int af9015_af9013_frontend2_attach(struct dvb_usb_adapter *adap)
{
	struct af9015_state *state = adap->dev->priv;

	/* attach 2nd demodulator */
	if (state->dual_mode) {
		adap->fe = dvb_attach(af9013_attach, &af9015_af9013_config[1],
			&adap->dev->i2c_adap);
		if (adap->fe != NULL)
			return 0;
	}

	return -EIO;
}

static struct mt2060_config af9015_mt2060_config = {
	.i2c_address = 0xc0,
	.clock_out = 0,
};

static struct qt1010_config af9015_qt1010_config = {
	.i2c_address = 0xc4,
};

static struct tda18271_config af9015_tda18271_config = {
	.gate = TDA18271_GATE_DIGITAL,
	.small_i2c = 1,
};

static struct mxl500x_config af9015_mxl5003_config = {
	.delsys = MXL500x_MODE_DVBT,
	.octf = 0,
	.xtal_freq = 16000000,
	.iflo_freq = 4570000,
	.ref_freq = 365600000,
	.rssi_ena = 0,
	.addr = 0xc6,
};

static struct mxl500x_config af9015_mxl5005_config = {
	.delsys = MXL500x_MODE_DVBT,
	.octf = MXL500x_OCTF_OFF,
	.xtal_freq = 16000000,
	.iflo_freq = 4570000,
	.ref_freq = 365600000,
	.rssi_ena = 0,
	.addr = 0xc6,
};

static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
{
	struct af9015_state *state = adap->dev->priv;
	int ret = 0;
	deb_info("%s: \n", __func__);

#if 0
	/* connect tuner */
	switch (af9015_af9013_config[0].tuner) {
	case AF9013_TUNER_MT2060:
	case AF9013_TUNER_QT1010:
	case AF9013_TUNER_TDA18271:
		ret = af9015_set_gpio(adap->dev, 3, AF9015_GPIO_TUNER_ON);
		break;
	case AF9013_TUNER_MXL5003D:
	case AF9013_TUNER_MXL5005D:
	case AF9013_TUNER_MXL5005R:
		ret = af9015_set_gpio(adap->dev, 1, AF9015_GPIO_TUNER_ON);
		if (state->dual_mode)
			ret = af9015_set_gpio(adap->dev, 0,
				AF9015_GPIO_TUNER_ON);
		break;
	}
	if (ret)
		return ret;
#endif

	switch (af9015_af9013_config[0].tuner) {
	case AF9013_TUNER_MT2060:
		ret = dvb_attach(mt2060_attach,
			adap->fe, &adap->dev->i2c_adap,
			&af9015_mt2060_config,
			state->mt2060_if1) == NULL ? -ENODEV : 0;
		break;
	case AF9013_TUNER_QT1010:
		ret = dvb_attach(qt1010_attach,
			adap->fe, &adap->dev->i2c_adap,
			&af9015_qt1010_config) == NULL ? -ENODEV : 0;
		break;
	case AF9013_TUNER_TDA18271:
		ret = dvb_attach(tda18271_attach,
			adap->fe, 0xc0, &adap->dev->i2c_adap,
			&af9015_tda18271_config) == NULL ? -ENODEV : 0;
		break;
	case AF9013_TUNER_MXL5003D:
		ret = dvb_attach(mxl500x_attach,
			adap->fe,
			&af9015_mxl5003_config,
			&adap->dev->i2c_adap) == NULL ? -ENODEV : 0;
		break;
	case AF9013_TUNER_MXL5005D:
	case AF9013_TUNER_MXL5005R:
		ret = dvb_attach(mxl500x_attach,
			adap->fe,
			&af9015_mxl5005_config,
			&adap->dev->i2c_adap) == NULL ? -ENODEV : 0;
		break;
	default:
		ret = -EINVAL;
		err("%s: Unknown tuner id:%d", __func__,
			af9015_af9013_config[0].tuner);
	}

	return ret;
}

static struct dvb_usb_device_properties af9015_properties;

static int af9015_usb_probe(struct usb_interface *intf,
			    const struct usb_device_id *id)
{
	int ret = 0;
	struct dvb_usb_device *d = NULL;

	deb_info("%s: interface:%d\n", __func__,
		intf->cur_altsetting->desc.bInterfaceNumber);

	/* interface 0 is used by DVB-T receiver and
	   interface 1 is for remote controller (HID) */
	if (intf->cur_altsetting->desc.bInterfaceNumber == 0) {
		ret = dvb_usb_device_init(intf, &af9015_properties,
			THIS_MODULE, &d);
		if (ret)
			return ret;

		if (d)
			ret = af9015_init(d);
	}

	return ret;
}

static struct usb_device_id af9015_usb_table[] = {
	{USB_DEVICE(USB_VID_AFATECH,    USB_PID_AFATECH_AF9015_9015)},
	{USB_DEVICE(USB_VID_AFATECH,    USB_PID_AFATECH_AF9015_9016)},
	{USB_DEVICE(USB_VID_LEADTEK,    USB_PID_WINFAST_DTV_DONGLE_GOLD)},
	{USB_DEVICE(USB_VID_PINNACLE,   USB_PID_PINNACLE_PCTV_71E)},
	/* KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) */
	{USB_DEVICE(0x1b80,             0xe399)},
	{USB_DEVICE(USB_VID_VISIONPLUS, 0x3226)},
	/* TwinHan AzureWave AD-TU700(704J) */
	{USB_DEVICE(USB_VID_VISIONPLUS, 0x3237)},
	/* TerraTec Cinergy T USB XE (Rev. 2) */
	{USB_DEVICE(USB_VID_TERRATEC,   0x0069)},
	/* AverMedia DVB-T Volar X) */
	{USB_DEVICE(0x07ca,             0xa815)},
	{0},
};
MODULE_DEVICE_TABLE(usb, af9015_usb_table);

static struct dvb_usb_device_properties af9015_properties = {
	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
	.i2c_algo = &af9015_i2c_algo,
	.usb_ctrl = DEVICE_SPECIFIC,
	.size_of_priv = sizeof(struct af9015_state),

#if 0
	.rc_interval      = 200,
	.rc_key_map       = af9015_rc_keys,
	.rc_key_map_size  = ARRAY_SIZE(af9015_rc_keys),
	.rc_query         = af9015_rc_query,
#endif

	.identify_state = af9015_identify_state,
	.firmware = "dvb-usb-af9015.fw",
	.download_firmware = af9015_download_firmware,

	.num_adapters = 2,
	.adapter = {
		{
#if 0
			.caps = DVB_USB_ADAP_HAS_PID_FILTER |
				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,

			.pid_filter_count = 32,
			.pid_filter       = af9015_pid_filter,
			.pid_filter_ctrl  = af9015_pid_filter_ctrl,
#endif

			.frontend_attach = af9015_af9013_frontend_attach,
			.tuner_attach    = af9015_tuner_attach,
			.stream = {
				.type = USB_BULK,
				.count = 6,
				.endpoint = 0x84,
				.u = {
					.bulk = {
						.buffersize =
							TS_USB20_FRAME_SIZE,
					}
				}
			},
		},
		{
#if 0
			.caps = DVB_USB_ADAP_HAS_PID_FILTER |
				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,

			.pid_filter_count = 32,
			.pid_filter       = af9015_pid_filter,
			.pid_filter_ctrl  = af9015_pid_filter_ctrl,
#endif

			.frontend_attach = af9015_af9013_frontend2_attach,
			.tuner_attach    = af9015_tuner_attach,
			.stream = {
				.type = USB_BULK,
				.count = 6,
				.endpoint = 0x85,
				.u = {
					.bulk = {
						.buffersize =
							TS_USB20_FRAME_SIZE,
					}
				}
			},
		}
	},
	.num_device_descs = 8,
	.devices = {
		{
			.name = "Afatech AF9015 DVB-T USB2.0 stick",
			.cold_ids = {&af9015_usb_table[0],
				     &af9015_usb_table[1], NULL},
			.warm_ids = {NULL},
		},
		{
			.name = "Leadtek WinFast DTV Dongle Gold",
			.cold_ids = {&af9015_usb_table[2], NULL},
			.warm_ids = {NULL},
		},
		{
			.name = "Pinnacle PCTV 71e",
			.cold_ids = {&af9015_usb_table[3], NULL},
			.warm_ids = {NULL},
		},
		{
			.name = "KWorld PlusTV Dual DVB-T Stick (DVB-T 399U)",
			.cold_ids = {&af9015_usb_table[4], NULL},
			.warm_ids = {NULL},
		},
		{
			.name = "DigitalNow TinyTwin DVB-T Receiver",
			.cold_ids = {&af9015_usb_table[5], NULL},
			.warm_ids = {NULL},
		},
		{
			.name = "TwinHan AzureWave AD-TU700(704J)",
			.cold_ids = {&af9015_usb_table[6], NULL},
			.warm_ids = {NULL},
		},
		{
			.name = "TerraTec Cinergy T USB XE",
			.cold_ids = {&af9015_usb_table[7], NULL},
			.warm_ids = {NULL},
		},
		{
			.name = " AverMedia DVB-T Volar X",
			.cold_ids = {&af9015_usb_table[8], NULL},
			.warm_ids = {NULL},
		},
		{NULL},
	}
};

/* usb specific object needed to register this driver with the usb subsystem */
static struct usb_driver af9015_usb_driver = {
#if LINUX_VERSION_CODE <=  KERNEL_VERSION(2, 6, 15)
	.owner = THIS_MODULE,
#endif
	.name = "dvb_usb_af9015",
	.probe = af9015_usb_probe,
	.disconnect = dvb_usb_device_exit,
	.id_table = af9015_usb_table,
};

/* module stuff */
static int __init af9015_usb_module_init(void)
{
	int ret;
	ret = usb_register(&af9015_usb_driver);
	if (ret)
		err("%s: usb_register failed. Error number %d", __func__, ret);

	return ret;
}

static void __exit af9015_usb_module_exit(void)
{
	/* deregister this driver from the USB subsystem */
	usb_deregister(&af9015_usb_driver);
}

module_init(af9015_usb_module_init);
module_exit(af9015_usb_module_exit);

MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
MODULE_DESCRIPTION("Driver for Afatech AF9015 DVB-T");
MODULE_LICENSE("GPL");


--------------000800020107040203000109
Content-Type: text/plain;
 name="Avermedia Volar X.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Avermedia Volar X.txt"

Stuff on Chips:

AF9015-NT*
0729 HKH2T

MXL5003S
D37t3.21
0732

Bus 007 Device 003: ID 07ca:a815 AVerMedia Technologies, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x07ca AVerMedia Technologies, Inc.
  idProduct          0xa815 
  bcdDevice            2.00
  iManufacturer           1 AVerMedia
  iProduct                2 A815
  iSerial                 3 300700301156000
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           71
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.01
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      65
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              16
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)


--------------000800020107040203000109
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------000800020107040203000109--
