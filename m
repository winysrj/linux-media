Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51312 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab3F3DHH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Jun 2013 23:07:07 -0400
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LjfpG-1UHbIf36Ii-00bZpB for
 <linux-media@vger.kernel.org>; Sun, 30 Jun 2013 05:07:05 +0200
Message-ID: <51CFA0DD.2040904@gmx.net>
Date: Sun, 30 Jun 2013 05:07:09 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Fwd: [PATCH 2/6 v2] dvbsky, dvb-s/s2 usb box
References: <201204271506222501798@gmail.com>
In-Reply-To: <201204271506222501798@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trying to figure out if a Mystique SaTiX-S2 Sky V2 USB device (USB ID 
0572:6831, looks like it is a DVBSKY S960 clone) would be supported 
before I buy, I came along this message.

Looking at 
http://git.linuxtv.org/media_tree.git/blob/HEAD:/drivers/media/usb/dvb-usb/dw2102.c 
it seems as if this patch never made it, so these USB S2 boxes would be 
unsupported.

Would it still be possible to include this patch?

Best regards,

P. van Gaans


-------- Original Message --------
Subject: [PATCH 2/6 v2] dvbsky, dvb-s/s2 usb box
Date: Fri, 27 Apr 2012 15:06:29 +0800
From: nibble.max <nibble.max@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media 
<linux-media@vger.kernel.org>

Also fix some code sytle errors checked by checkpatch.pl.
---
  drivers/media/dvb/dvb-usb/Kconfig  |    2 +
  drivers/media/dvb/dvb-usb/dw2102.c |  337 
++++++++++++++++++++++++++++++++----
  2 files changed, 305 insertions(+), 34 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Kconfig 
b/drivers/media/dvb/dvb-usb/Kconfig
index be1db75..93c9381 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -279,6 +279,8 @@ config DVB_USB_DW2102
  	select DVB_STV0288 if !DVB_FE_CUSTOMISE
  	select DVB_STB6000 if !DVB_FE_CUSTOMISE
  	select DVB_CX24116 if !DVB_FE_CUSTOMISE
+	select DVB_M88TS202X if !DVB_FE_CUSTOMISE
+	select DVB_M88DS3103 if !DVB_FE_CUSTOMISE
  	select DVB_SI21XX if !DVB_FE_CUSTOMISE
  	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
  	select DVB_MT312 if !DVB_FE_CUSTOMISE
diff --git a/drivers/media/dvb/dvb-usb/dw2102.c 
b/drivers/media/dvb/dvb-usb/dw2102.c
index 451c5a7..1cf62fb 100644
--- a/drivers/media/dvb/dvb-usb/dw2102.c
+++ b/drivers/media/dvb/dvb-usb/dw2102.c
@@ -19,6 +19,8 @@
  #include "stb6000.h"
  #include "eds1547.h"
  #include "cx24116.h"
+#include "m88ts202x.h"
+#include "m88ds3103.h"
  #include "tda1002x.h"
  #include "mt312.h"
  #include "zl10039.h"
@@ -118,12 +120,12 @@ MODULE_PARM_DESC(demod, "demod to probe (1=cx24116 
2=stv0903+stv6110 "
  DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);

  static int dw210x_op_rw(struct usb_device *dev, u8 request, u16 value,
-			u16 index, u8 * data, u16 len, int flags)
+			u16 index, u8 *data, u16 len, int flags)
  {
  	int ret;
  	u8 *u8buf;
  	unsigned int pipe = (flags == DW210X_READ_MSG) ?
-				usb_rcvctrlpipe(dev, 0) : usb_sndctrlpipe(dev, 0);
+			usb_rcvctrlpipe(dev, 0) : usb_sndctrlpipe(dev, 0);
  	u8 request_type = (flags == DW210X_READ_MSG) ? USB_DIR_IN : USB_DIR_OUT;

  	u8buf = kmalloc(len, GFP_KERNEL);
@@ -133,7 +135,8 @@ static int dw210x_op_rw(struct usb_device *dev, u8 
request, u16 value,

  	if (flags == DW210X_WRITE_MSG)
  		memcpy(u8buf, data, len);
-	ret = usb_control_msg(dev, pipe, request, request_type | USB_TYPE_VENDOR,
+	ret = usb_control_msg(dev, pipe,
+				request, request_type | USB_TYPE_VENDOR,
  				value, index , u8buf, len, 2000);

  	if (flags == DW210X_READ_MSG)
@@ -179,7 +182,7 @@ static int dw2102_i2c_transfer(struct i2c_adapter 
*adap, struct i2c_msg msg[],
  			break;
  		case 0x60:
  			if (msg[0].flags == 0) {
-			/* write to tuner pll */
+				/* write to tuner pll */
  				buf6[0] = 0x2c;
  				buf6[1] = 5;
  				buf6[2] = 0xc0;
@@ -190,7 +193,7 @@ static int dw2102_i2c_transfer(struct i2c_adapter 
*adap, struct i2c_msg msg[],
  				ret = dw210x_op_rw(d->udev, 0xb2, 0, 0,
  						buf6, 7, DW210X_WRITE_MSG);
  			} else {
-			/* read from tuner */
+				/* read from tuner */
  				ret = dw210x_op_rw(d->udev, 0xb5, 0, 0,
  						buf6, 1, DW210X_READ_MSG);
  				msg[0].buf[0] = buf6[0];
@@ -273,7 +276,8 @@ static int dw2102_serit_i2c_transfer(struct 
i2c_adapter *adap,
  	return num;
  }

-static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct 
i2c_msg msg[], int num)
+static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap,
+				struct i2c_msg msg[], int num)
  {
  	struct dvb_usb_device *d = i2c_get_adapdata(adap);
  	int ret = 0;
@@ -346,7 +350,8 @@ static int dw2102_earda_i2c_transfer(struct 
i2c_adapter *adap, struct i2c_msg ms
  	return num;
  }

-static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg 
msg[], int num)
+static int dw2104_i2c_transfer(struct i2c_adapter *adap,
+				struct i2c_msg msg[], int num)
  {
  	struct dvb_usb_device *d = i2c_get_adapdata(adap);
  	int ret = 0;
@@ -712,7 +717,8 @@ static int dw210x_read_mac_address(struct 
dvb_usb_device *d, u8 mac[6])
  	u8 eeprom[256], eepromline[16];

  	for (i = 0; i < 256; i++) {
-		if (dw210x_op_rw(d->udev, 0xb6, 0xa0 , i, ibuf, 2, DW210X_READ_MSG) < 
0) {
+		if (dw210x_op_rw(d->udev, 0xb6, 0xa0 , i, ibuf, 2,
+		DW210X_READ_MSG) < 0) {
  			err("read eeprom failed.");
  			return -1;
  		} else {
@@ -882,6 +888,41 @@ static int s660_set_voltage(struct dvb_frontend 
*fe, fe_sec_voltage_t voltage)
  	return 0;
  }

+static int bstusb_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t 
voltage)
+{
+
+	struct dvb_usb_adapter *udev_adap =
+		(struct dvb_usb_adapter *)(fe->dvb->priv);
+
+	u8 obuf[3] = { 0xe, 0x80, 0 };
+	u8 ibuf[] = { 0 };
+
+	info("US6830: %s!\n", __func__);
+
+	if (voltage == SEC_VOLTAGE_OFF)
+		obuf[2] = 0;
+	else
+		obuf[2] = 1;
+
+	if (dvb_usb_generic_rw(udev_adap->dev, obuf, 3, ibuf, 1, 0) < 0)
+		err("command 0x0e transfer failed.");
+	return 0;
+}
+
+static int bstusb_restart(struct dvb_frontend *fe)
+{
+
+	struct dvb_usb_adapter *udev_adap =
+		(struct dvb_usb_adapter *)(fe->dvb->priv);
+
+	u8 obuf[3] = { 0x36, 3, 0 };
+	u8 ibuf[] = { 0 };
+
+	if (dvb_usb_generic_rw(udev_adap->dev, obuf, 3, ibuf, 1, 0) < 0)
+		err("command 0x36 transfer failed.");
+	return 0;
+}
+
  static void dw210x_led_ctrl(struct dvb_frontend *fe, int offon)
  {
  	static u8 led_off[] = { 0 };
@@ -987,12 +1028,37 @@ static struct ds3000_config su3000_ds3000_config = {
  	.ci_mode = 1,
  };

+static struct m88ts202x_config dvbsky_ts202x_config = {
+	.bypasson = 0,
+	.clkout = 0,
+	.clkdiv = 0,
+};
+
+static struct m88ds3103_config US6830_ds3103_config = {
+	.demod_address = 0x68,
+	.ci_mode = 1,
+	.pin_ctrl = 0x83,
+	.ts_mode = 0,
+	.start_ctrl = bstusb_restart,
+	.set_voltage = bstusb_set_voltage,
+};
+
+static struct m88ds3103_config US6832_ds3103_config = {
+	.demod_address = 0x68,
+	.ci_mode = 1,
+	.pin_ctrl = 0x80,
+	.ts_mode = 0,
+	.start_ctrl = bstusb_restart,
+	.set_voltage = bstusb_set_voltage,
+};
+
  static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
  {
  	struct dvb_tuner_ops *tuner_ops = NULL;

  	if (demod_probe & 4) {
-		d->fe_adap[0].fe = dvb_attach(stv0900_attach, &dw2104a_stv0900_config,
+		d->fe_adap[0].fe = dvb_attach(stv0900_attach,
+				&dw2104a_stv0900_config,
  				&d->dev->i2c_adap, 0);
  		if (d->fe_adap[0].fe != NULL) {
  			if (dvb_attach(stb6100_attach, d->fe_adap[0].fe,
@@ -1003,7 +1069,8 @@ static int dw2104_frontend_attach(struct 
dvb_usb_adapter *d)
  				tuner_ops->get_frequency = stb6100_get_freq;
  				tuner_ops->set_bandwidth = stb6100_set_bandw;
  				tuner_ops->get_bandwidth = stb6100_get_bandw;
-				d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
+				d->fe_adap[0].fe->ops.set_voltage =
+							dw210x_set_voltage;
  				info("Attached STV0900+STB6100!\n");
  				return 0;
  			}
@@ -1011,13 +1078,15 @@ static int dw2104_frontend_attach(struct 
dvb_usb_adapter *d)
  	}

  	if (demod_probe & 2) {
-		d->fe_adap[0].fe = dvb_attach(stv0900_attach, &dw2104_stv0900_config,
+		d->fe_adap[0].fe = dvb_attach(stv0900_attach,
+				&dw2104_stv0900_config,
  				&d->dev->i2c_adap, 0);
  		if (d->fe_adap[0].fe != NULL) {
  			if (dvb_attach(stv6110_attach, d->fe_adap[0].fe,
  					&dw2104_stv6110_config,
  					&d->dev->i2c_adap)) {
-				d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
+				d->fe_adap[0].fe->ops.set_voltage =
+							dw210x_set_voltage;
  				info("Attached STV0900+STV6110A!\n");
  				return 0;
  			}
@@ -1053,7 +1122,8 @@ static int dw2102_frontend_attach(struct 
dvb_usb_adapter *d)
  {
  	if (dw2102_properties.i2c_algo == &dw2102_serit_i2c_algo) {
  		/*dw2102_properties.adapter->tuner_attach = NULL;*/
-		d->fe_adap[0].fe = dvb_attach(si21xx_attach, &serit_sp1511lhb_config,
+		d->fe_adap[0].fe = dvb_attach(si21xx_attach,
+					&serit_sp1511lhb_config,
  					&d->dev->i2c_adap);
  		if (d->fe_adap[0].fe != NULL) {
  			d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
@@ -1068,7 +1138,8 @@ static int dw2102_frontend_attach(struct 
dvb_usb_adapter *d)
  		if (d->fe_adap[0].fe != NULL) {
  			if (dvb_attach(stb6000_attach, d->fe_adap[0].fe, 0x61,
  					&d->dev->i2c_adap)) {
-				d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
+				d->fe_adap[0].fe->ops.set_voltage =
+							dw210x_set_voltage;
  				info("Attached stv0288!\n");
  				return 0;
  			}
@@ -1076,8 +1147,10 @@ static int dw2102_frontend_attach(struct 
dvb_usb_adapter *d)
  	}

  	if (dw2102_properties.i2c_algo == &dw2102_i2c_algo) {
-		/*dw2102_properties.adapter->tuner_attach = dw2102_tuner_attach;*/
-		d->fe_adap[0].fe = dvb_attach(stv0299_attach, &sharp_z0194a_config,
+		/*dw2102_properties.adapter->tuner_attach =
+						dw2102_tuner_attach;*/
+		d->fe_adap[0].fe = dvb_attach(stv0299_attach,
+					&sharp_z0194a_config,
  					&d->dev->i2c_adap);
  		if (d->fe_adap[0].fe != NULL) {
  			d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
@@ -1125,7 +1198,8 @@ static int stv0288_frontend_attach(struct 
dvb_usb_adapter *d)
  	if (d->fe_adap[0].fe == NULL)
  		return -EIO;

-	if (NULL == dvb_attach(stb6000_attach, d->fe_adap[0].fe, 0x61, 
&d->dev->i2c_adap))
+	if (NULL == dvb_attach(stb6000_attach, d->fe_adap[0].fe,
+				0x61, &d->dev->i2c_adap))
  		return -EIO;

  	d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
@@ -1213,6 +1287,63 @@ static int su3000_frontend_attach(struct 
dvb_usb_adapter *d)

  	return 0;
  }
+static int dvbsky_usb_frontend_attach(struct dvb_usb_adapter *d,
+					struct m88ds3103_config *pdconf,
+					struct m88ts202x_config *ptconf)
+{
+	struct m88ts202x_devctl *ctrl;
+
+	u8 obuf[3] = { 0xe, 0x83, 0 };
+	u8 ibuf[] = { 0 };
+
+	info("dvbsky: %s!\n", __func__);
+	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
+		err("command 0x0e transfer failed.");
+
+	obuf[0] = 0xe;
+	obuf[1] = 0x83;
+	obuf[2] = 1;
+
+	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
+		err("command 0x0e transfer failed.");
+
+	obuf[0] = 0x51;
+
+	if (dvb_usb_generic_rw(d->dev, obuf, 1, ibuf, 1, 0) < 0)
+		err("command 0x51 transfer failed.");
+
+	d->fe_adap[0].fe = dvb_attach(m88ds3103_attach, pdconf,
+					&d->dev->i2c_adap);
+	if (d->fe_adap[0].fe == NULL)
+		return -EIO;
+	ctrl =	dvb_attach(m88ts202x_attach,
+				d->fe_adap[0].fe, ptconf, &d->dev->i2c_adap);
+	if (!ctrl) {
+		printk(KERN_ERR "No m88ts202x found!\n");
+		return -ENODEV;
+	}
+	pdconf->tuner_init = ctrl->tuner_init;
+	pdconf->tuner_sleep = ctrl->tuner_sleep;
+	pdconf->tuner_wakeup = ctrl->tuner_wakeup;
+	pdconf->tuner_set_frequency = ctrl->tuner_set_frequency;
+	pdconf->tuner_get_rfgain = ctrl->tuner_get_rfgain;
+	info("Attached M88DS3103!\n");
+	return 0;
+}
+
+static int US6830_frontend_attach(struct dvb_usb_adapter *d)
+{
+	return dvbsky_usb_frontend_attach(d,
+					&US6830_ds3103_config,
+					&dvbsky_ts202x_config);
+}
+
+static int US6832_frontend_attach(struct dvb_usb_adapter *d)
+{
+	return dvbsky_usb_frontend_attach(d,
+					&US6832_ds3103_config,
+					&dvbsky_ts202x_config);
+}

  static int dw2102_tuner_attach(struct dvb_usb_adapter *adap)
  {
@@ -1435,6 +1566,28 @@ static int dw2102_rc_query(struct dvb_usb_device 
*d, u32 *event, int *state)
  	return 0;
  }

+/* dvbsky remote control */
+static int dvbsky_rc_query(struct dvb_usb_device *d)
+{
+	unsigned code = 0;
+	u8 obuf[0x40], ibuf[0x40], toggle;
+
+	obuf[0] = 0x10;
+	if (dvb_usb_generic_rw(d, obuf, 1, ibuf, 2, 0) < 0)
+		err("rc transfer failed.");
+	code = (ibuf[0] << 8) | ibuf[1];
+	if (code != 0xffff) {
+		info("dvbsky rc code: %x", code);
+
+		toggle = (code & 0x800) ? 1 : 0;
+		code &= 0x3f;
+
+		rc_keydown(d->rc_dev, code, toggle);
+	}
+
+	return 0;
+}
+
  enum dw2102_table_entry {
  	CYPRESS_DW2102,
  	CYPRESS_DW2101,
@@ -1451,6 +1604,9 @@ enum dw2102_table_entry {
  	TEVII_S480_1,
  	TEVII_S480_2,
  	X3M_SPC1400HD,
+	BST_US6830HD,
+	BST_US6831HD,
+	BST_US6832HD,
  };

  static struct usb_device_id dw2102_table[] = {
@@ -1458,7 +1614,8 @@ static struct usb_device_id dw2102_table[] = {
  	[CYPRESS_DW2101] = {USB_DEVICE(USB_VID_CYPRESS, 0x2101)},
  	[CYPRESS_DW2104] = {USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW2104)},
  	[TEVII_S650] = {USB_DEVICE(0x9022, USB_PID_TEVII_S650)},
-	[TERRATEC_CINERGY_S] = {USB_DEVICE(USB_VID_TERRATEC, USB_PID_CINERGY_S)},
+	[TERRATEC_CINERGY_S] = {USB_DEVICE(USB_VID_TERRATEC,
+				USB_PID_CINERGY_S)},
  	[CYPRESS_DW3101] = {USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW3101)},
  	[TEVII_S630] = {USB_DEVICE(0x9022, USB_PID_TEVII_S630)},
  	[PROF_1100] = {USB_DEVICE(0x3011, USB_PID_PROF_1100)},
@@ -1469,6 +1626,9 @@ static struct usb_device_id dw2102_table[] = {
  	[TEVII_S480_1] = {USB_DEVICE(0x9022, USB_PID_TEVII_S480_1)},
  	[TEVII_S480_2] = {USB_DEVICE(0x9022, USB_PID_TEVII_S480_2)},
  	[X3M_SPC1400HD] = {USB_DEVICE(0x1f4d, 0x3100)},
+	[BST_US6830HD] = {USB_DEVICE(0x0572, 0x6830)},
+	[BST_US6831HD] = {USB_DEVICE(0x0572, 0x6831)},
+	[BST_US6832HD] = {USB_DEVICE(0x0572, 0x6832)},
  	{ }
  };

@@ -1529,7 +1689,8 @@ static int dw2102_load_firmware(struct usb_device 
*dev,
  		/* init registers */
  		switch (dev->descriptor.idProduct) {
  		case USB_PID_TEVII_S650:
-			dw2104_properties.rc.legacy.rc_map_table = rc_map_tevii_table;
+			dw2104_properties.rc.legacy.rc_map_table =
+							rc_map_tevii_table;
  			dw2104_properties.rc.legacy.rc_map_size =
  					ARRAY_SIZE(rc_map_tevii_table);
  		case USB_PID_DW2104:
@@ -1553,7 +1714,8 @@ static int dw2102_load_firmware(struct usb_device 
*dev,
  					DW210X_READ_MSG);
  			if ((reset16[0] == 0xa1) || (reset16[0] == 0x80)) {
  				dw2102_properties.i2c_algo = &dw2102_i2c_algo;
-				dw2102_properties.adapter->fe[0].tuner_attach = &dw2102_tuner_attach;
+				dw2102_properties.adapter->fe[0].tuner_attach =
+							&dw2102_tuner_attach;
  				break;
  			} else {
  				/* check STV0288 frontend  */
@@ -1565,7 +1727,8 @@ static int dw2102_load_firmware(struct usb_device 
*dev,
  				dw210x_op_rw(dev, 0xc3, 0xd1, 0, &reset16[0], 3,
  						DW210X_READ_MSG);
  				if (reset16[2] == 0x11) {
-					dw2102_properties.i2c_algo = &dw2102_earda_i2c_algo;
+					dw2102_properties.i2c_algo =
+							&dw2102_earda_i2c_algo;
  					break;
  				}
  			}
@@ -1622,7 +1785,7 @@ static struct dvb_usb_device_properties 
dw2102_properties = {
  					}
  				}
  			},
-		}},
+		} },
  		}
  	},
  	.num_device_descs = 3,
@@ -1676,7 +1839,7 @@ static struct dvb_usb_device_properties 
dw2104_properties = {
  					}
  				}
  			},
-		}},
+		} },
  		}
  	},
  	.num_device_descs = 2,
@@ -1727,7 +1890,7 @@ static struct dvb_usb_device_properties 
dw3101_properties = {
  					}
  				}
  			},
-		}},
+		} },
  		}
  	},
  	.num_device_descs = 1,
@@ -1773,7 +1936,7 @@ static struct dvb_usb_device_properties 
s6x0_properties = {
  					}
  				}
  			},
-		}},
+		} },
  		}
  	},
  	.num_device_descs = 1,
@@ -1854,7 +2017,7 @@ static struct dvb_usb_device_properties 
su3000_properties = {
  					}
  				}
  			}
-		}},
+		} },
  		}
  	},
  	.num_device_descs = 3,
@@ -1874,6 +2037,108 @@ static struct dvb_usb_device_properties 
su3000_properties = {
  	}
  };

+static struct dvb_usb_device_properties US6830_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.size_of_priv = sizeof(struct su3000_state),
+	.power_ctrl = su3000_power_ctrl,
+	.num_adapters = 1,
+	.identify_state	= su3000_identify_state,
+	.i2c_algo = &su3000_i2c_algo,
+
+	.rc.core = {
+		.rc_interval      = 300,
+		.rc_codes         = RC_MAP_DVBSKY,
+		.module_name	  = "dvbskyir",
+		.rc_query         = dvbsky_rc_query,
+		.allowed_protos   = RC_TYPE_RC5,
+	},
+
+	.read_mac_address = su3000_read_mac_address,
+
+	.generic_bulk_ctrl_endpoint = 0x01,
+
+	.adapter = {
+		{
+		.num_frontends = 1,
+		.fe = { {
+			.streaming_ctrl   = su3000_streaming_ctrl,
+			.frontend_attach  = US6830_frontend_attach,
+			.stream = {
+				.type = USB_BULK,
+				.count = 8,
+				.endpoint = 0x82,
+				.u = {
+					.bulk = {
+						.buffersize = 4096,
+					}
+				}
+			}
+		} },
+		}
+	},
+	.num_device_descs = 2,
+	.devices = {
+		{ "Bestunar US6830 HD",
+			{ &dw2102_table[BST_US6830HD], NULL },
+			{ NULL },
+		},
+		{ "Bestunar US6831 HD",
+			{ &dw2102_table[BST_US6831HD], NULL },
+			{ NULL },
+		},
+	}
+};
+
+static struct dvb_usb_device_properties US6832_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.size_of_priv = sizeof(struct su3000_state),
+	.power_ctrl = su3000_power_ctrl,
+	.num_adapters = 1,
+	.identify_state	= su3000_identify_state,
+	.i2c_algo = &su3000_i2c_algo,
+
+	.rc.core = {
+		.rc_interval      = 300,
+		.rc_codes         = RC_MAP_DVBSKY,
+		.module_name	  = "dvbskyir",
+		.rc_query         = dvbsky_rc_query,
+		.allowed_protos   = RC_TYPE_RC5,
+	},
+
+	.read_mac_address = su3000_read_mac_address,
+
+	.generic_bulk_ctrl_endpoint = 0x01,
+
+	.adapter = {
+		{
+		.num_frontends = 1,
+		.fe = { {
+			.streaming_ctrl   = su3000_streaming_ctrl,
+			.frontend_attach  = US6832_frontend_attach,
+			.stream = {
+				.type = USB_BULK,
+				.count = 8,
+				.endpoint = 0x82,
+				.u = {
+					.bulk = {
+						.buffersize = 4096,
+					}
+				}
+			}
+		} },
+		}
+	},
+	.num_device_descs = 1,
+	.devices = {
+		{ "Bestunar US6832 HD",
+			{ &dw2102_table[BST_US6832HD], NULL },
+			{ NULL },
+		},
+	}
+};
+
  static int dw2102_probe(struct usb_interface *intf,
  		const struct usb_device_id *id)
  {
@@ -1917,20 +2182,24 @@ static int dw2102_probe(struct usb_interface *intf,

  	if (0 == dvb_usb_device_init(intf, &dw2102_properties,
  			THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, &dw2104_properties,
+		0 == dvb_usb_device_init(intf, &dw2104_properties,
+			THIS_MODULE, NULL, adapter_nr) ||
+		0 == dvb_usb_device_init(intf, &dw3101_properties,
+			THIS_MODULE, NULL, adapter_nr) ||
+		0 == dvb_usb_device_init(intf, &s6x0_properties,
  			THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, &dw3101_properties,
+		0 == dvb_usb_device_init(intf, p1100,
  			THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, &s6x0_properties,
+		0 == dvb_usb_device_init(intf, s660,
  			THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, p1100,
+		0 == dvb_usb_device_init(intf, p7500,
  			THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, s660,
+		0 == dvb_usb_device_init(intf, &su3000_properties,
  			THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, p7500,
+		0 == dvb_usb_device_init(intf, &US6830_properties,
  			THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, &su3000_properties,
-				     THIS_MODULE, NULL, adapter_nr))
+		0 == dvb_usb_device_init(intf, &US6832_properties,
+			THIS_MODULE, NULL, adapter_nr))
  		return 0;

  	return -ENODEV;
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



