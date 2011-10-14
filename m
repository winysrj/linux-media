Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60471 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab1JNXyV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 19:54:21 -0400
Received: by wwf22 with SMTP id 22so4157458wwf.1
        for <linux-media@vger.kernel.org>; Fri, 14 Oct 2011 16:54:19 -0700 (PDT)
Message-ID: <4e98cba8.4a5ee30a.0f20.ffffd8e3@mx.google.com>
Subject: [PATCH] it913x [VER 1.07] Support for single ITE 9135 devices
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Sat, 15 Oct 2011 00:54:11 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for single ITE 9135 device.

Only single devices have been tested.  Dual ITE 9135 devices
should work, but have not been tested.

TODOs
support for ver 2 chip
config for other tuner types.
rework of firmware file.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    2 +
 drivers/media/dvb/dvb-usb/it913x.c      |  105 +++++++++++++++++++++++--------
 2 files changed, 80 insertions(+), 27 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 7433261..31b4aa4 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -37,6 +37,7 @@
 #define USB_VID_HAUPPAUGE			0x2040
 #define USB_VID_HYPER_PALTEK			0x1025
 #define USB_VID_INTEL				0x8086
+#define USB_VID_ITETECH				0x048d
 #define USB_VID_KWORLD				0xeb2a
 #define USB_VID_KWORLD_2			0x1b80
 #define USB_VID_KYE				0x0458
@@ -126,6 +127,7 @@
 #define USB_PID_GRANDTEC_DVBT_USB_COLD			0x0fa0
 #define USB_PID_GRANDTEC_DVBT_USB_WARM			0x0fa1
 #define USB_PID_INTEL_CE9500				0x9500
+#define USB_PID_ITETECH_IT9135				0x9135
 #define USB_PID_KWORLD_399U				0xe399
 #define USB_PID_KWORLD_399U_2				0xe400
 #define USB_PID_KWORLD_395U				0xe396
diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index f027a2c..c462261 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -60,6 +60,17 @@ struct it913x_state {
 	u8 id;
 };
 
+struct ite_config {
+	u8 chip_ver;
+	u16 chip_type;
+	u32 firmware;
+	u8 tuner_id_0;
+	u8 tuner_id_1;
+	u8 dual_mode;
+};
+
+struct ite_config it913x_config;
+
 static int it913x_bulk_write(struct usb_device *dev,
 				u8 *snd, int len, u8 pipe)
 {
@@ -191,18 +202,23 @@ static int it913x_read_reg(struct usb_device *udev, u32 reg)
 static u32 it913x_query(struct usb_device *udev, u8 pro)
 {
 	int ret;
-	u32 res = 0;
 	u8 data[4];
 	ret = it913x_io(udev, READ_LONG, pro, CMD_DEMOD_READ,
-		0x1222, 0, &data[0], 1);
-	if (data[0] == 0x1) {
-		ret = it913x_io(udev, READ_SHORT, pro,
+		0x1222, 0, &data[0], 3);
+
+	it913x_config.chip_ver = data[0];
+	it913x_config.chip_type = (u16)(data[2] << 8) + data[1];
+
+	info("Chip Version=%02x Chip Type=%04x", it913x_config.chip_ver,
+		it913x_config.chip_type);
+
+	ret |= it913x_io(udev, READ_SHORT, pro,
 			CMD_QUERYINFO, 0, 0x1, &data[0], 4);
-		res = (data[0] << 24) + (data[1] << 16) +
+
+	it913x_config.firmware = (data[0] << 24) + (data[1] << 16) +
 			(data[2] << 8) + data[3];
-	}
 
-	return (ret < 0) ? 0 : res;
+	return (ret < 0) ? 0 : it913x_config.firmware;
 }
 
 static int it913x_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
@@ -336,26 +352,35 @@ static int it913x_identify_state(struct usb_device *udev,
 		int *cold)
 {
 	int ret = 0, firm_no;
-	u8 reg, adap, ep, tun0, tun1;
+	u8 reg, remote;
 
 	firm_no = it913x_return_status(udev);
 
-	ep = it913x_read_reg(udev, 0x49ac);
-	adap = it913x_read_reg(udev, 0x49c5);
-	tun0 = it913x_read_reg(udev, 0x49d0);
-	info("No. Adapters=%x Endpoints=%x Tuner Type=%x", adap, ep, tun0);
+	/* checnk for dual mode */
+	it913x_config.dual_mode =  it913x_read_reg(udev, 0x49c5);
+
+	/* TODO different remotes */
+	remote = it913x_read_reg(udev, 0x49ac); /* Remote */
+	if (remote == 0)
+		props->rc.core.rc_codes = NULL;
+
+	/* TODO at the moment tuner_id is always assigned to 0x38 */
+	it913x_config.tuner_id_0 = it913x_read_reg(udev, 0x49d0);
+
+	info("Dual mode=%x Remote=%x Tuner Type=%x", it913x_config.dual_mode
+		, remote, it913x_config.tuner_id_0);
 
 	if (firm_no > 0) {
 		*cold = 0;
 		return 0;
 	}
 
-	if (adap > 2) {
-		tun1 = it913x_read_reg(udev, 0x49e0);
+	if (it913x_config.dual_mode) {
+		it913x_config.tuner_id_1 = it913x_read_reg(udev, 0x49e0);
 		ret = it913x_wr_reg(udev, DEV_0, GPIOH1_EN, 0x1);
 		ret |= it913x_wr_reg(udev, DEV_0, GPIOH1_ON, 0x1);
 		ret |= it913x_wr_reg(udev, DEV_0, GPIOH1_O, 0x1);
-		msleep(50); /* Delay noticed reset cycle ? */
+		msleep(50);
 		ret |= it913x_wr_reg(udev, DEV_0, GPIOH1_O, 0x0);
 		msleep(50);
 		reg = it913x_read_reg(udev, GPIOH1_O);
@@ -366,14 +391,19 @@ static int it913x_identify_state(struct usb_device *udev,
 				ret = it913x_wr_reg(udev, DEV_0,
 					GPIOH1_O, 0x0);
 		}
+		props->num_adapters = 2;
 	} else
 		props->num_adapters = 1;
 
 	reg = it913x_read_reg(udev, IO_MUX_POWER_CLK);
 
-	ret |= it913x_wr_reg(udev, DEV_0, 0x4bfb, CHIP2_I2C_ADDR);
-
-	ret |= it913x_wr_reg(udev, DEV_0,  CLK_O_EN, 0x1);
+	if (it913x_config.dual_mode) {
+		ret |= it913x_wr_reg(udev, DEV_0, 0x4bfb, CHIP2_I2C_ADDR);
+		ret |= it913x_wr_reg(udev, DEV_0,  CLK_O_EN, 0x1);
+	} else {
+		ret |= it913x_wr_reg(udev, DEV_0, 0x4bfb, 0x0);
+		ret |= it913x_wr_reg(udev, DEV_0,  CLK_O_EN, 0x0);
+	}
 
 	*cold = 1;
 
@@ -403,13 +433,11 @@ static int it913x_download_firmware(struct usb_device *udev,
 					const struct firmware *fw)
 {
 	int ret = 0, i;
-	u8 packet_size, dlen, tun1;
+	u8 packet_size, dlen;
 	u8 *fw_data;
 
 	packet_size = 0x29;
 
-	tun1 = it913x_read_reg(udev, 0x49e0);
-
 	ret = it913x_wr_reg(udev, DEV_0,  I2C_CLK, I2C_CLK_100);
 
 	info("FRM Starting Firmware Download");
@@ -444,11 +472,12 @@ static int it913x_download_firmware(struct usb_device *udev,
 	ret |= it913x_wr_reg(udev, DEV_0,  I2C_CLK, I2C_CLK_400);
 
 	/* Tuner function */
-	ret |= it913x_wr_reg(udev, DEV_0_DMOD , 0xec4c, 0xa0);
+	if (it913x_config.dual_mode)
+		ret |= it913x_wr_reg(udev, DEV_0_DMOD , 0xec4c, 0xa0);
 
 	ret |= it913x_wr_reg(udev, DEV_0,  PADODPU, 0x0);
 	ret |= it913x_wr_reg(udev, DEV_0,  AGC_O_D, 0x0);
-	if (tun1 > 0) {
+	if (it913x_config.dual_mode) {
 		ret |= it913x_wr_reg(udev, DEV_1,  PADODPU, 0x0);
 		ret |= it913x_wr_reg(udev, DEV_1,  AGC_O_D, 0x0);
 	}
@@ -475,9 +504,28 @@ static int it913x_frontend_attach(struct dvb_usb_adapter *adap)
 	u8 adf = it913x_read_reg(udev, IO_MUX_POWER_CLK);
 	u8 adap_addr = I2C_BASE_ADDR + (adap->id << 5);
 	u16 ep_size = adap->props.fe[0].stream.u.bulk.buffersize;
+	u8 tuner_id, tuner_type;
+
+	if (adap->id == 0)
+		tuner_id = it913x_config.tuner_id_0;
+	else
+		tuner_id = it913x_config.tuner_id_1;
+
+	/* TODO we always use IT9137 possible references here*/
+	/* Documentation suggests don't care */
+	switch (tuner_id) {
+	case 0x51:
+	case 0x52:
+	case 0x60:
+	case 0x61:
+	case 0x62:
+	default:
+	case 0x38:
+		tuner_type = IT9137;
+	}
 
 	adap->fe_adap[0].fe = dvb_attach(it913x_fe_attach,
-		&adap->dev->i2c_adap, adap_addr, adf, IT9137);
+		&adap->dev->i2c_adap, adap_addr, adf, tuner_type);
 
 	if (adap->id == 0 && adap->fe_adap[0].fe) {
 		ret = it913x_wr_reg(udev, DEV_0_DMOD, MP2_SW_RST, 0x1);
@@ -533,6 +581,7 @@ static int it913x_probe(struct usb_interface *intf,
 
 static struct usb_device_id it913x_table[] = {
 	{ USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_UB499_2T_T09) },
+	{ USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135) },
 	{}		/* Terminating entry */
 };
 
@@ -608,12 +657,14 @@ static struct dvb_usb_device_properties it913x_properties = {
 		.rc_codes	= RC_MAP_KWORLD_315U,
 	},
 	.i2c_algo         = &it913x_i2c_algo,
-	.num_device_descs = 1,
+	.num_device_descs = 2,
 	.devices = {
 		{   "Kworld UB499-2T T09(IT9137)",
 			{ &it913x_table[0], NULL },
 			},
-
+		{   "ITE 9135 Generic",
+			{ &it913x_table[1], NULL },
+			},
 	}
 };
 
@@ -647,5 +698,5 @@ module_exit(it913x_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.06");
+MODULE_VERSION("1.07");
 MODULE_LICENSE("GPL");
-- 
1.7.5.4


