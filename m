Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58201 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab2HFUVy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 16:21:54 -0400
Received: by weyx8 with SMTP id x8so2218027wey.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 13:21:52 -0700 (PDT)
Message-ID: <1344284500.12234.12.camel@router7789>
Subject: [PATCH] lmedm04 2.06 conversion to dvb-usb-v2 version 2
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Antti Palosaari <crope@iki.fi>
Date: Mon, 06 Aug 2012 21:21:40 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Conversion of lmedm04 to dvb-usb-v2

Functional changes m88rs2000 tuner now uses all callbacks.
TODO migrate other tuners to the callbacks.

This patch is applied on top of [BUG] Re: dvb_usb_lmedm04 crash Kernel (rs2000)
http://patchwork.linuxtv.org/patch/13584/


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb-v2/Kconfig               |   13 +
 drivers/media/dvb/dvb-usb-v2/Makefile              |    3 +
 .../media/dvb/{dvb-usb => dvb-usb-v2}/lmedm04.c    |  588 +++++++++-----------
 .../media/dvb/{dvb-usb => dvb-usb-v2}/lmedm04.h    |    0
 drivers/media/dvb/dvb-usb/Kconfig                  |   13 -
 drivers/media/dvb/dvb-usb/Makefile                 |    3 -
 6 files changed, 291 insertions(+), 329 deletions(-)
 rename drivers/media/dvb/{dvb-usb => dvb-usb-v2}/lmedm04.c (69%)
 rename drivers/media/dvb/{dvb-usb => dvb-usb-v2}/lmedm04.h (100%)

diff --git a/drivers/media/dvb/dvb-usb-v2/Kconfig b/drivers/media/dvb/dvb-usb-v2/Kconfig
index e7ff148..14a635b 100644
--- a/drivers/media/dvb/dvb-usb-v2/Kconfig
+++ b/drivers/media/dvb/dvb-usb-v2/Kconfig
@@ -102,6 +102,19 @@ config DVB_USB_GL861
 	  Say Y here to support the MSI Megasky 580 (55801) DVB-T USB2.0
 	  receiver with USB ID 0db0:5581.
 
+config DVB_USB_LME2510
+	tristate "LME DM04/QQBOX DVB-S USB2.0 support"
+	depends on DVB_USB_V2
+	select DVB_TDA10086 if !DVB_FE_CUSTOMISE
+	select DVB_TDA826X if !DVB_FE_CUSTOMISE
+	select DVB_STV0288 if !DVB_FE_CUSTOMISE
+	select DVB_IX2505V if !DVB_FE_CUSTOMISE
+	select DVB_STV0299 if !DVB_FE_CUSTOMISE
+	select DVB_PLL if !DVB_FE_CUSTOMISE
+	select DVB_M88RS2000 if !DVB_FE_CUSTOMISE
+	help
+	  Say Y here to support the LME DM04/QQBOX DVB-S USB2.0
+
 config DVB_USB_MXL111SF
 	tristate "MxL111SF DTV USB2.0 support"
 	depends on DVB_USB_V2
diff --git a/drivers/media/dvb/dvb-usb-v2/Makefile b/drivers/media/dvb/dvb-usb-v2/Makefile
index a784bf4..26659bc 100644
--- a/drivers/media/dvb/dvb-usb-v2/Makefile
+++ b/drivers/media/dvb/dvb-usb-v2/Makefile
@@ -25,6 +25,9 @@ obj-$(CONFIG_DVB_USB_CE6230) += dvb-usb-ce6230.o
 dvb-usb-ec168-objs = ec168.o
 obj-$(CONFIG_DVB_USB_EC168) += dvb-usb-ec168.o
 
+dvb-usb-lmedm04-objs = lmedm04.o
+obj-$(CONFIG_DVB_USB_LME2510) += dvb-usb-lmedm04.o
+
 dvb-usb-gl861-objs = gl861.o
 obj-$(CONFIG_DVB_USB_GL861) += dvb-usb-gl861.o
 
diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb-v2/lmedm04.c
similarity index 69%
rename from drivers/media/dvb/dvb-usb/lmedm04.c
rename to drivers/media/dvb/dvb-usb-v2/lmedm04.c
index 26ba5bc..c6bc1b8 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb-v2/lmedm04.c
@@ -19,6 +19,8 @@
  *
  * MVB0194 (LME2510C+SHARP0194)
  *
+ * LME2510C + M88RS2000
+ *
  * For firmware see Documentation/dvb/lmedm04.txt
  *
  * I2C addresses:
@@ -62,13 +64,14 @@
  *	LME2510: SHARP:BS2F7HZ0194(MV0194) cannot cold reset and share system
  * with other tuners. After a cold reset streaming will not start.
  *
+ * M88RS2000 suffers from loss of lock.
  */
 #define DVB_USB_LOG_PREFIX "LME2510(C)"
 #include <linux/usb.h>
 #include <linux/usb/input.h>
 #include <media/rc-core.h>
 
-#include "dvb-usb.h"
+#include "dvb_usb.h"
 #include "lmedm04.h"
 #include "tda826x.h"
 #include "tda10086.h"
@@ -80,24 +83,28 @@
 #include "m88rs2000.h"
 
 
+#define LME2510_C_S7395	"dvb-usb-lme2510c-s7395.fw";
+#define LME2510_C_LG	"dvb-usb-lme2510c-lg.fw";
+#define LME2510_C_S0194	"dvb-usb-lme2510c-s0194.fw";
+#define LME2510_C_RS2000 "dvb-usb-lme2510c-rs2000.fw";
+#define LME2510_LG	"dvb-usb-lme2510-lg.fw";
+#define LME2510_S0194	"dvb-usb-lme2510-s0194.fw";
 
 /* debug */
 static int dvb_usb_lme2510_debug;
-#define l_dprintk(var, level, args...) do { \
+#define lme_debug(var, level, args...) do { \
 	if ((var >= level)) \
-		printk(KERN_DEBUG DVB_USB_LOG_PREFIX ": " args); \
+		pr_debug(DVB_USB_LOG_PREFIX": " args); \
 } while (0)
-
-#define deb_info(level, args...) l_dprintk(dvb_usb_lme2510_debug, level, args)
+#define deb_info(level, args...) lme_debug(dvb_usb_lme2510_debug, level, args)
 #define debug_data_snipet(level, name, p) \
 	 deb_info(level, name" (%02x%02x%02x%02x%02x%02x%02x%02x)", \
 		*p, *(p+1), *(p+2), *(p+3), *(p+4), \
 			*(p+5), *(p+6), *(p+7));
-
+#define info(args...) pr_info(DVB_USB_LOG_PREFIX": "args)
 
 module_param_named(debug, dvb_usb_lme2510_debug, int, 0644);
-MODULE_PARM_DESC(debug, "set debugging level (1=info (or-able))."
-			DVB_USB_DEBUG_STATUS);
+MODULE_PARM_DESC(debug, "set debugging level (1=info (or-able)).");
 
 static int dvb_usb_lme2510_firmware;
 module_param_named(firmware, dvb_usb_lme2510_firmware, int, 0644);
@@ -136,7 +143,8 @@ struct lme2510_state {
 	void *buffer;
 	struct urb *lme_urb;
 	void *usb_buffer;
-
+	int (*fe_set_voltage)(struct dvb_frontend *, fe_sec_voltage_t);
+	u8 dvb_usb_lme2510_firmware;
 };
 
 static int lme2510_bulk_write(struct usb_device *dev,
@@ -246,7 +254,7 @@ static int lme2510_enable_pid(struct dvb_usb_device *d, u8 index, u16 pid_out)
 static void lme2510_int_response(struct urb *lme_urb)
 {
 	struct dvb_usb_adapter *adap = lme_urb->context;
-	struct lme2510_state *st = adap->dev->priv;
+	struct lme2510_state *st = adap_to_priv(adap);
 	static u8 *ibuf, *rbuf;
 	int i = 0, offset;
 	u32 key;
@@ -283,8 +291,9 @@ static void lme2510_int_response(struct urb *lme_urb)
 					? (ibuf[3] ^ 0xff) << 8 : 0;
 				key += (ibuf[2] ^ 0xff) << 16;
 				deb_info(1, "INT Key =%08x", key);
-				if (adap->dev->rc_dev != NULL)
-					rc_keydown(adap->dev->rc_dev, key, 0);
+				if (adap_to_d(adap)->rc_dev != NULL)
+					rc_keydown(adap_to_d(adap)->rc_dev,
+						key, 0);
 			}
 			break;
 		case 0xbb:
@@ -313,12 +322,12 @@ static void lme2510_int_response(struct urb *lme_urb)
 				}
 				break;
 			case TUNER_RS2000:
-				if (ibuf[2] > 0)
+				if (ibuf[1] == 0x3 &&  ibuf[6] == 0xff)
 					st->signal_lock = 0xff;
 				else
-					st->signal_lock = 0xf0;
-				st->signal_level = ibuf[4];
-				st->signal_sn = ibuf[5];
+					st->signal_lock = 0x00;
+				st->signal_level = ibuf[5];
+				st->signal_sn = ibuf[4];
 				st->time_key = ibuf[7];
 			default:
 				break;
@@ -338,22 +347,23 @@ static void lme2510_int_response(struct urb *lme_urb)
 
 static int lme2510_int_read(struct dvb_usb_adapter *adap)
 {
-	struct lme2510_state *lme_int = adap->dev->priv;
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct lme2510_state *lme_int = adap_to_priv(adap);
 
 	lme_int->lme_urb = usb_alloc_urb(0, GFP_ATOMIC);
 
 	if (lme_int->lme_urb == NULL)
 			return -ENOMEM;
 
-	lme_int->buffer = usb_alloc_coherent(adap->dev->udev, 128, GFP_ATOMIC,
+	lme_int->buffer = usb_alloc_coherent(d->udev, 128, GFP_ATOMIC,
 					&lme_int->lme_urb->transfer_dma);
 
 	if (lme_int->buffer == NULL)
 			return -ENOMEM;
 
 	usb_fill_int_urb(lme_int->lme_urb,
-				adap->dev->udev,
-				usb_rcvintpipe(adap->dev->udev, 0xa),
+				d->udev,
+				usb_rcvintpipe(d->udev, 0xa),
 				lme_int->buffer,
 				128,
 				lme2510_int_response,
@@ -370,17 +380,18 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 
 static int lme2510_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
-	struct lme2510_state *st = adap->dev->priv;
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct lme2510_state *st = adap_to_priv(adap);
 	static u8 clear_pid_reg[] = LME_ALL_PIDS;
 	static u8 rbuf[1];
 	int ret = 0;
 
 	deb_info(1, "PID Clearing Filter");
 
-	mutex_lock(&adap->dev->i2c_mutex);
+	mutex_lock(&d->i2c_mutex);
 
 	if (!onoff) {
-		ret |= lme2510_usb_talk(adap->dev, clear_pid_reg,
+		ret |= lme2510_usb_talk(d, clear_pid_reg,
 			sizeof(clear_pid_reg), rbuf, sizeof(rbuf));
 		st->pid_off = true;
 	} else
@@ -388,7 +399,7 @@ static int lme2510_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 
 	st->pid_size = 0;
 
-	mutex_unlock(&adap->dev->i2c_mutex);
+	mutex_unlock(&d->i2c_mutex);
 
 	return 0;
 }
@@ -396,15 +407,16 @@ static int lme2510_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 static int lme2510_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 	int onoff)
 {
+	struct dvb_usb_device *d = adap_to_d(adap);
 	int ret = 0;
 
 	deb_info(3, "%s PID=%04x Index=%04x onoff=%02x", __func__,
 		pid, index, onoff);
 
 	if (onoff) {
-		mutex_lock(&adap->dev->i2c_mutex);
-		ret |= lme2510_enable_pid(adap->dev, index, pid);
-		mutex_unlock(&adap->dev->i2c_mutex);
+		mutex_lock(&d->i2c_mutex);
+		ret |= lme2510_enable_pid(d, index, pid);
+		mutex_unlock(&d->i2c_mutex);
 	}
 
 
@@ -412,7 +424,7 @@ static int lme2510_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 }
 
 
-static int lme2510_return_status(struct usb_device *dev)
+static int lme2510_return_status(struct dvb_usb_device *d)
 {
 	int ret = 0;
 	u8 *data;
@@ -421,7 +433,7 @@ static int lme2510_return_status(struct usb_device *dev)
 	if (!data)
 		return -ENOMEM;
 
-	ret |= usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
+	ret |= usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
 			0x06, 0x80, 0x0302, 0x00, data, 0x0006, 200);
 	info("Firmware Status: %x (%x)", ret , data[2]);
 
@@ -613,10 +625,6 @@ static int lme2510_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	if (gate == 0)
 		gate = 5;
 
-	if (num > 2)
-		warn("more than 2 i2c messages"
-			"at a time is not handled yet.	TODO.");
-
 	for (i = 0; i < num; i++) {
 		read_o = 1 & (msg[i].flags & I2C_M_RD);
 		read = i+1 < num && (msg[i+1].flags & I2C_M_RD);
@@ -676,22 +684,11 @@ static struct i2c_algorithm lme2510_i2c_algo = {
 	.functionality = lme2510_i2c_func,
 };
 
-/* Callbacks for DVB USB */
-static int lme2510_identify_state(struct usb_device *udev,
-		struct dvb_usb_device_properties *props,
-		struct dvb_usb_device_description **desc,
-		int *cold)
+static int lme2510_streaming_ctrl(struct dvb_frontend *fe, int onoff)
 {
-	if (pid_filter != 2)
-		props->adapter[0].fe[0].caps &=
-			~DVB_USB_ADAP_NEED_PID_FILTERING;
-	*cold = 0;
-	return 0;
-}
-
-static int lme2510_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
-{
-	struct lme2510_state *st = adap->dev->priv;
+	struct dvb_usb_adapter *adap = fe_to_adap(fe);
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct lme2510_state *st = adap_to_priv(adap);
 	static u8 clear_reg_3[] = LME_ALL_PIDS;
 	static u8 rbuf[1];
 	int ret = 0, rlen = sizeof(rbuf);
@@ -704,14 +701,14 @@ static int lme2510_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	else {
 		deb_info(1, "STM Steam Off");
 		/* mutex is here only to avoid collision with I2C */
-		mutex_lock(&adap->dev->i2c_mutex);
+		mutex_lock(&d->i2c_mutex);
 
-		ret = lme2510_usb_talk(adap->dev, clear_reg_3,
+		ret = lme2510_usb_talk(d, clear_reg_3,
 				sizeof(clear_reg_3), rbuf, rlen);
 		st->stream_on = 0;
 		st->i2c_talk_onoff = 1;
 
-		mutex_unlock(&adap->dev->i2c_mutex);
+		mutex_unlock(&d->i2c_mutex);
 	}
 
 	return (ret < 0) ? -ENODEV : 0;
@@ -725,7 +722,7 @@ static u8 check_sum(u8 *p, u8 len)
 	return sum;
 }
 
-static int lme2510_download_firmware(struct usb_device *dev,
+static int lme2510_download_firmware(struct dvb_usb_device *d,
 					const struct firmware *fw)
 {
 	int ret = 0;
@@ -737,9 +734,10 @@ static int lme2510_download_firmware(struct usb_device *dev,
 	packet_size = 0x31;
 	len_in = 1;
 
-	data = kzalloc(512, GFP_KERNEL);
+	data = kzalloc(128, GFP_KERNEL);
 	if (!data) {
-		info("FRM Could not start Firmware Download (Buffer allocation failed)");
+		info("FRM Could not start Firmware Download"\
+			"(Buffer allocation failed)");
 		return -ENOMEM;
 	}
 
@@ -763,21 +761,19 @@ static int lme2510_download_firmware(struct usb_device *dev,
 			data[wlen-1] = check_sum(fw_data, dlen+1);
 			deb_info(1, "Data S=%02x:E=%02x CS= %02x", data[3],
 				data[dlen+2], data[dlen+3]);
-			ret |= lme2510_bulk_write(dev, data,  wlen, 1);
-			ret |= lme2510_bulk_read(dev, data, len_in , 1);
+			lme2510_usb_talk(d, data, wlen, data, len_in);
 			ret |= (data[0] == 0x88) ? 0 : -1;
 		}
 	}
 
-	usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
+	usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
 			0x06, 0x80, 0x0200, 0x00, data, 0x0109, 1000);
 
 
 	data[0] = 0x8a;
 	len_in = 1;
 	msleep(2000);
-	ret |= lme2510_bulk_write(dev, data , len_in, 1); /*Resetting*/
-	ret |= lme2510_bulk_read(dev, data, len_in, 1);
+	lme2510_usb_talk(d, data, len_in, data, len_in);
 	msleep(400);
 
 	if (ret < 0)
@@ -786,44 +782,42 @@ static int lme2510_download_firmware(struct usb_device *dev,
 		info("FRM Firmware Download Completed - Resetting Device");
 
 	kfree(data);
-	return (ret < 0) ? -ENODEV : 0;
+	return RECONNECTS_USB;
 }
 
-static void lme_coldreset(struct usb_device *dev)
+static void lme_coldreset(struct dvb_usb_device *d)
 {
-	int ret = 0, len_in;
-	u8 data[512] = {0};
-
+	u8 data[1] = {0};
 	data[0] = 0x0a;
-	len_in = 1;
 	info("FRM Firmware Cold Reset");
-	ret |= lme2510_bulk_write(dev, data , len_in, 1); /*Cold Resetting*/
-	ret |= lme2510_bulk_read(dev, data, len_in, 1);
+
+	lme2510_usb_talk(d, data, sizeof(data), data, sizeof(data));
 
 	return;
 }
 
-static int lme_firmware_switch(struct usb_device *udev, int cold)
+static const char fw_c_s7395[] = LME2510_C_S7395;
+static const char fw_c_lg[] = LME2510_C_LG;
+static const char fw_c_s0194[] = LME2510_C_S0194;
+static const char fw_c_rs2000[] = LME2510_C_RS2000;
+static const char fw_lg[] = LME2510_LG;
+static const char fw_s0194[] = LME2510_S0194;
+
+const char *lme_firmware_switch(struct dvb_usb_device *d, int cold)
 {
+	struct lme2510_state *st = d->priv;
+	struct usb_device *udev = d->udev;
 	const struct firmware *fw = NULL;
-	const char fw_c_s7395[] = "dvb-usb-lme2510c-s7395.fw";
-	const char fw_c_lg[] = "dvb-usb-lme2510c-lg.fw";
-	const char fw_c_s0194[] = "dvb-usb-lme2510c-s0194.fw";
-	const char fw_c_rs2000[] = "dvb-usb-lme2510c-rs2000.fw";
-	const char fw_lg[] = "dvb-usb-lme2510-lg.fw";
-	const char fw_s0194[] = "dvb-usb-lme2510-s0194.fw";
 	const char *fw_lme;
-	int ret = 0, cold_fw;
+	int ret = 0;
 
 	cold = (cold > 0) ? (cold & 1) : 0;
 
-	cold_fw = !cold;
-
 	switch (le16_to_cpu(udev->descriptor.idProduct)) {
 	case 0x1122:
-		switch (dvb_usb_lme2510_firmware) {
+		switch (st->dvb_usb_lme2510_firmware) {
 		default:
-			dvb_usb_lme2510_firmware = TUNER_S0194;
+			st->dvb_usb_lme2510_firmware = TUNER_S0194;
 		case TUNER_S0194:
 			fw_lme = fw_s0194;
 			ret = request_firmware(&fw, fw_lme, &udev->dev);
@@ -831,23 +825,20 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
 				cold = 0;
 				break;
 			}
-			dvb_usb_lme2510_firmware = TUNER_LG;
+			st->dvb_usb_lme2510_firmware = TUNER_LG;
 		case TUNER_LG:
 			fw_lme = fw_lg;
 			ret = request_firmware(&fw, fw_lme, &udev->dev);
 			if (ret == 0)
 				break;
-			info("FRM No Firmware Found - please install");
-			dvb_usb_lme2510_firmware = TUNER_DEFAULT;
-			cold = 0;
-			cold_fw = 0;
+			st->dvb_usb_lme2510_firmware = TUNER_DEFAULT;
 			break;
 		}
 		break;
 	case 0x1120:
-		switch (dvb_usb_lme2510_firmware) {
+		switch (st->dvb_usb_lme2510_firmware) {
 		default:
-			dvb_usb_lme2510_firmware = TUNER_S7395;
+			st->dvb_usb_lme2510_firmware = TUNER_S7395;
 		case TUNER_S7395:
 			fw_lme = fw_c_s7395;
 			ret = request_firmware(&fw, fw_lme, &udev->dev);
@@ -855,53 +846,41 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
 				cold = 0;
 				break;
 			}
-			dvb_usb_lme2510_firmware = TUNER_LG;
+			st->dvb_usb_lme2510_firmware = TUNER_LG;
 		case TUNER_LG:
 			fw_lme = fw_c_lg;
 			ret = request_firmware(&fw, fw_lme, &udev->dev);
 			if (ret == 0)
 				break;
-			dvb_usb_lme2510_firmware = TUNER_S0194;
+			st->dvb_usb_lme2510_firmware = TUNER_S0194;
 		case TUNER_S0194:
 			fw_lme = fw_c_s0194;
 			ret = request_firmware(&fw, fw_lme, &udev->dev);
 			if (ret == 0)
 				break;
-			info("FRM No Firmware Found - please install");
-			dvb_usb_lme2510_firmware = TUNER_DEFAULT;
+			st->dvb_usb_lme2510_firmware = TUNER_DEFAULT;
 			cold = 0;
-			cold_fw = 0;
 			break;
 		}
 		break;
 	case 0x22f0:
 		fw_lme = fw_c_rs2000;
-		ret = request_firmware(&fw, fw_lme, &udev->dev);
-		dvb_usb_lme2510_firmware = TUNER_RS2000;
-		if (ret == 0)
-			break;
-		info("FRM No Firmware Found - please install");
-		cold_fw = 0;
+		st->dvb_usb_lme2510_firmware = TUNER_RS2000;
 		break;
 	default:
 		fw_lme = fw_c_s7395;
 	}
 
-
-	if (cold_fw) {
-		info("FRM Loading %s file", fw_lme);
-		ret = lme2510_download_firmware(udev, fw);
-	}
-
 	release_firmware(fw);
 
 	if (cold) {
+		dvb_usb_lme2510_firmware = st->dvb_usb_lme2510_firmware;
 		info("FRM Changing to %s firmware", fw_lme);
-		lme_coldreset(udev);
-		return -ENODEV;
+		lme_coldreset(d);
+		return NULL;
 	}
 
-	return ret;
+	return fw_lme;
 }
 
 static int lme2510_kill_urb(struct usb_data_stream *stream)
@@ -953,8 +932,8 @@ static struct stv0299_config sharp_z0194_config = {
 static int dm04_rs2000_set_ts_param(struct dvb_frontend *fe,
 	int caller)
 {
-	struct dvb_usb_adapter *adap = fe->dvb->priv;
-	struct dvb_usb_device *d = adap->dev;
+	struct dvb_usb_adapter *adap = fe_to_adap(fe);
+	struct dvb_usb_device *d = adap_to_d(adap);
 	struct lme2510_state *st = d->priv;
 
 	mutex_lock(&d->i2c_mutex);
@@ -976,29 +955,35 @@ static struct m88rs2000_config m88rs2000_config = {
 static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 					fe_sec_voltage_t voltage)
 {
-	struct dvb_usb_adapter *adap = fe->dvb->priv;
-	static u8 voltage_low[]	= LME_VOLTAGE_L;
+	struct dvb_usb_device *d = fe_to_d(fe);
+	struct lme2510_state *st = fe_to_priv(fe);
+	static u8 voltage_low[] = LME_VOLTAGE_L;
 	static u8 voltage_high[] = LME_VOLTAGE_H;
 	static u8 rbuf[1];
 	int ret = 0, len = 3, rlen = 1;
 
-	mutex_lock(&adap->dev->i2c_mutex);
+	mutex_lock(&d->i2c_mutex);
 
 	switch (voltage) {
 	case SEC_VOLTAGE_18:
-		ret |= lme2510_usb_talk(adap->dev,
+		ret |= lme2510_usb_talk(d,
 			voltage_high, len, rbuf, rlen);
 		break;
 
 	case SEC_VOLTAGE_OFF:
 	case SEC_VOLTAGE_13:
 	default:
-		ret |= lme2510_usb_talk(adap->dev,
+		ret |= lme2510_usb_talk(d,
 				voltage_low, len, rbuf, rlen);
 		break;
 	}
 
-	mutex_unlock(&adap->dev->i2c_mutex);
+	mutex_unlock(&d->i2c_mutex);
+
+	if (st->tuner_config == TUNER_RS2000)
+		if (st->fe_set_voltage)
+			st->fe_set_voltage(fe, voltage);
+
 
 	return (ret < 0) ? -ENODEV : 0;
 }
@@ -1006,29 +991,44 @@ static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 static int dm04_rs2000_read_signal_strength(struct dvb_frontend *fe,
 	u16 *strength)
 {
-	struct dvb_usb_adapter *adap = fe->dvb->priv;
-	struct lme2510_state *st = adap->dev->priv;
+	struct lme2510_state *st = fe_to_priv(fe);
+
+	*strength = (u16)((u32)st->signal_level * 0xffff / 0xff);
 
-	*strength = (u16)((u32)st->signal_level * 0xffff / 0x7f);
 	return 0;
 }
 
 static int dm04_rs2000_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	struct dvb_usb_adapter *adap = fe->dvb->priv;
-	struct lme2510_state *st = adap->dev->priv;
+	struct lme2510_state *st = fe_to_priv(fe);
+
+	*snr = (u16)((u32)st->signal_sn * 0xffff / 0x7f);
+
+	return 0;
+}
+
+static int dm04_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	*ber = 0;
+
+	return 0;
+}
+
+static int dm04_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	*ucblocks = 0;
 
-	*snr = (u16)((u32)st->signal_sn * 0xffff / 0xff);
 	return 0;
 }
 
 static int lme_name(struct dvb_usb_adapter *adap)
 {
-	struct lme2510_state *st = adap->dev->priv;
-	const char *desc = adap->dev->desc->name;
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct lme2510_state *st = adap_to_priv(adap);
+	const char *desc = d->name;
 	char *fe_name[] = {"", " LG TDQY-P001F", " SHARP:BS2F7HZ7395",
 				" SHARP:BS2F7HZ0194", " RS2000"};
-	char *name = adap->fe_adap[0].fe->ops.info.name;
+	char *name = adap->fe[0]->ops.info.name;
 
 	strlcpy(name, desc, 128);
 	strlcat(name, fe_name[st->tuner_config], 128);
@@ -1038,120 +1038,128 @@ static int lme_name(struct dvb_usb_adapter *adap)
 
 static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	struct lme2510_state *st = adap->dev->priv;
-
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct lme2510_state *st = d->priv;
 	int ret = 0;
 
 	st->i2c_talk_onoff = 1;
-	switch (le16_to_cpu(adap->dev->udev->descriptor.idProduct)) {
+	switch (le16_to_cpu(d->udev->descriptor.idProduct)) {
 	case 0x1122:
 	case 0x1120:
 		st->i2c_gate = 4;
-		adap->fe_adap[0].fe = dvb_attach(tda10086_attach,
-			&tda10086_config, &adap->dev->i2c_adap);
-		if (adap->fe_adap[0].fe) {
+		adap->fe[0] = dvb_attach(tda10086_attach,
+			&tda10086_config, &d->i2c_adap);
+		if (adap->fe[0]) {
 			info("TUN Found Frontend TDA10086");
 			st->i2c_tuner_gate_w = 4;
 			st->i2c_tuner_gate_r = 4;
 			st->i2c_tuner_addr = 0xc0;
 			st->tuner_config = TUNER_LG;
-			if (dvb_usb_lme2510_firmware != TUNER_LG) {
-				dvb_usb_lme2510_firmware = TUNER_LG;
-				ret = lme_firmware_switch(adap->dev->udev, 1);
+			if (st->dvb_usb_lme2510_firmware != TUNER_LG) {
+				st->dvb_usb_lme2510_firmware = TUNER_LG;
+				ret = lme_firmware_switch(d, 1) ? 0 : -ENODEV;
 			}
 			break;
 		}
 
 		st->i2c_gate = 4;
-		adap->fe_adap[0].fe = dvb_attach(stv0299_attach,
-				&sharp_z0194_config, &adap->dev->i2c_adap);
-		if (adap->fe_adap[0].fe) {
+		adap->fe[0] = dvb_attach(stv0299_attach,
+				&sharp_z0194_config, &d->i2c_adap);
+		if (adap->fe[0]) {
 			info("FE Found Stv0299");
 			st->i2c_tuner_gate_w = 4;
 			st->i2c_tuner_gate_r = 5;
 			st->i2c_tuner_addr = 0xc0;
 			st->tuner_config = TUNER_S0194;
-			if (dvb_usb_lme2510_firmware != TUNER_S0194) {
-				dvb_usb_lme2510_firmware = TUNER_S0194;
-				ret = lme_firmware_switch(adap->dev->udev, 1);
+			if (st->dvb_usb_lme2510_firmware != TUNER_S0194) {
+				st->dvb_usb_lme2510_firmware = TUNER_S0194;
+				ret = lme_firmware_switch(d, 1) ? 0 : -ENODEV;
 			}
 			break;
 		}
 
 		st->i2c_gate = 5;
-		adap->fe_adap[0].fe = dvb_attach(stv0288_attach, &lme_config,
-			&adap->dev->i2c_adap);
+		adap->fe[0] = dvb_attach(stv0288_attach, &lme_config,
+			&d->i2c_adap);
 
-		if (adap->fe_adap[0].fe) {
+		if (adap->fe[0]) {
 			info("FE Found Stv0288");
 			st->i2c_tuner_gate_w = 4;
 			st->i2c_tuner_gate_r = 5;
 			st->i2c_tuner_addr = 0xc0;
 			st->tuner_config = TUNER_S7395;
-			if (dvb_usb_lme2510_firmware != TUNER_S7395) {
-				dvb_usb_lme2510_firmware = TUNER_S7395;
-				ret = lme_firmware_switch(adap->dev->udev, 1);
+			if (st->dvb_usb_lme2510_firmware != TUNER_S7395) {
+				st->dvb_usb_lme2510_firmware = TUNER_S7395;
+				ret = lme_firmware_switch(d, 1) ? 0 : -ENODEV;
 			}
 			break;
 		}
 	case 0x22f0:
 		st->i2c_gate = 5;
-		adap->fe_adap[0].fe = dvb_attach(m88rs2000_attach,
-			&m88rs2000_config, &adap->dev->i2c_adap);
+		adap->fe[0] = dvb_attach(m88rs2000_attach,
+			&m88rs2000_config, &d->i2c_adap);
 
-		if (adap->fe_adap[0].fe) {
+		if (adap->fe[0]) {
 			info("FE Found M88RS2000");
 			st->i2c_tuner_gate_w = 5;
 			st->i2c_tuner_gate_r = 5;
 			st->i2c_tuner_addr = 0xc0;
 			st->tuner_config = TUNER_RS2000;
-			adap->fe_adap[0].fe->ops.read_signal_strength =
+			st->fe_set_voltage =
+				adap->fe[0]->ops.set_voltage;
+
+			adap->fe[0]->ops.read_signal_strength =
 				dm04_rs2000_read_signal_strength;
-			adap->fe_adap[0].fe->ops.read_snr =
+			adap->fe[0]->ops.read_snr =
 				dm04_rs2000_read_snr;
+			adap->fe[0]->ops.read_ber =
+				dm04_read_ber;
+			adap->fe[0]->ops.read_ucblocks =
+				dm04_read_ucblocks;
 		}
 		break;
 	}
 
-	if (adap->fe_adap[0].fe == NULL) {
-			info("DM04/QQBOX Not Powered up or not Supported");
-			return -ENODEV;
+	if (adap->fe[0] == NULL) {
+		info("DM04/QQBOX Not Powered up or not Supported");
+		return -ENODEV;
 	}
 
 	if (ret) {
-		if (adap->fe_adap[0].fe) {
-			dvb_frontend_detach(adap->fe_adap[0].fe);
-			adap->fe_adap[0].fe = NULL;
+		if (adap->fe[0]) {
+			dvb_frontend_detach(adap->fe[0]);
+			adap->fe[0] = NULL;
 		}
-		adap->dev->props.rc.core.rc_codes = NULL;
+		d->rc_map = NULL;
 		return -ENODEV;
 	}
 
-	adap->fe_adap[0].fe->ops.set_voltage = dm04_lme2510_set_voltage;
+	adap->fe[0]->ops.set_voltage = dm04_lme2510_set_voltage;
 	ret = lme_name(adap);
 	return ret;
 }
 
 static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
 {
-	struct lme2510_state *st = adap->dev->priv;
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct lme2510_state *st = adap_to_priv(adap);
 	char *tun_msg[] = {"", "TDA8263", "IX2505V", "DVB_PLL_OPERA", "RS2000"};
 	int ret = 0;
 
 	switch (st->tuner_config) {
 	case TUNER_LG:
-		if (dvb_attach(tda826x_attach, adap->fe_adap[0].fe, 0xc0,
-			&adap->dev->i2c_adap, 1))
+		if (dvb_attach(tda826x_attach, adap->fe[0], 0xc0,
+			&d->i2c_adap, 1))
 			ret = st->tuner_config;
 		break;
 	case TUNER_S7395:
-		if (dvb_attach(ix2505v_attach , adap->fe_adap[0].fe, &lme_tuner,
-			&adap->dev->i2c_adap))
+		if (dvb_attach(ix2505v_attach , adap->fe[0], &lme_tuner,
+			&d->i2c_adap))
 			ret = st->tuner_config;
 		break;
 	case TUNER_S0194:
-		if (dvb_attach(dvb_pll_attach , adap->fe_adap[0].fe, 0xc0,
-			&adap->dev->i2c_adap, DVB_PLL_OPERA1))
+		if (dvb_attach(dvb_pll_attach , adap->fe[0], 0xc0,
+			&d->i2c_adap, DVB_PLL_OPERA1))
 			ret = st->tuner_config;
 		break;
 	case TUNER_RS2000:
@@ -1165,7 +1173,7 @@ static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
 		info("TUN Found %s tuner", tun_msg[ret]);
 	else {
 		info("TUN No tuner found --- resetting device");
-		lme_coldreset(adap->dev->udev);
+		lme_coldreset(d);
 		return -ENODEV;
 	}
 
@@ -1201,158 +1209,57 @@ static int lme2510_powerup(struct dvb_usb_device *d, int onoff)
 	return ret;
 }
 
-/* DVB USB Driver stuff */
-static struct dvb_usb_device_properties lme2510_properties;
-static struct dvb_usb_device_properties lme2510c_properties;
-
-static int lme2510_probe(struct usb_interface *intf,
-		const struct usb_device_id *id)
+static int lme2510_get_adapter_count(struct dvb_usb_device *d)
 {
-	struct usb_device *udev = interface_to_usbdev(intf);
+	return 1;
+}
 
-	usb_reset_configuration(udev);
+static int lme2510_identify_state(struct dvb_usb_device *d, const char **name)
+{
+	struct lme2510_state *st = d->priv;
 
-	usb_set_interface(udev, intf->cur_altsetting->desc.bInterfaceNumber, 1);
+	usb_reset_configuration(d->udev);
 
-	if (udev->speed != USB_SPEED_HIGH) {
-		usb_reset_device(udev);
-		info("DEV Failed to connect in HIGH SPEED mode");
-		return -ENODEV;
-	}
+	usb_set_interface(d->udev,
+		d->intf->cur_altsetting->desc.bInterfaceNumber, 1);
 
-	if (lme2510_return_status(udev) == 0x44) {
-		lme_firmware_switch(udev, 0);
-		return -ENODEV;
-	}
+	st->dvb_usb_lme2510_firmware = dvb_usb_lme2510_firmware;
 
-	if (0 == dvb_usb_device_init(intf, &lme2510_properties,
-				     THIS_MODULE, NULL, adapter_nr)) {
-		info("DEV registering device driver");
-		return 0;
-	}
-	if (0 == dvb_usb_device_init(intf, &lme2510c_properties,
-				     THIS_MODULE, NULL, adapter_nr)) {
-		info("DEV registering device driver");
-		return 0;
+	if (lme2510_return_status(d) == 0x44) {
+		*name = lme_firmware_switch(d, 0);
+		return COLD;
 	}
 
-	info("DEV lme2510 Error");
-	return -ENODEV;
-
+	return 0;
 }
 
-static struct usb_device_id lme2510_table[] = {
-	{ USB_DEVICE(0x3344, 0x1122) },  /* LME2510 */
-	{ USB_DEVICE(0x3344, 0x1120) },  /* LME2510C */
-	{ USB_DEVICE(0x3344, 0x22f0) },  /* LME2510C RS2000 */
-	{}		/* Terminating entry */
-};
-
-MODULE_DEVICE_TABLE(usb, lme2510_table);
-
-static struct dvb_usb_device_properties lme2510_properties = {
-	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
-	.size_of_priv = sizeof(struct lme2510_state),
-	.num_adapters = 1,
-	.adapter = {
-		{
-		.num_frontends = 1,
-		.fe = {{
-			.caps = DVB_USB_ADAP_HAS_PID_FILTER|
-				DVB_USB_ADAP_NEED_PID_FILTERING|
-				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
-			.streaming_ctrl   = lme2510_streaming_ctrl,
-			.pid_filter_count = 32,
-			.pid_filter = lme2510_pid_filter,
-			.pid_filter_ctrl  = lme2510_pid_filter_ctrl,
-			.frontend_attach  = dm04_lme2510_frontend_attach,
-			.tuner_attach = dm04_lme2510_tuner,
-			/* parameter for the MPEG2-data transfer */
-			.stream = {
-				.type = USB_BULK,
-				.count = 10,
-				.endpoint = 0x06,
-				.u = {
-					.bulk = {
-						.buffersize = 4096,
-
-					}
-				}
-			}
-		}},
-		}
-	},
-	.rc.core = {
-		.protocol	= RC_TYPE_NEC,
-		.module_name	= "LME2510 Remote Control",
-		.allowed_protos	= RC_TYPE_NEC,
-		.rc_codes	= RC_MAP_LME2510,
-	},
-	.power_ctrl       = lme2510_powerup,
-	.identify_state   = lme2510_identify_state,
-	.i2c_algo         = &lme2510_i2c_algo,
-	.generic_bulk_ctrl_endpoint = 0,
-	.num_device_descs = 1,
-	.devices = {
-		{   "DM04_LME2510_DVB-S",
-			{ &lme2510_table[0], NULL },
-			},
+static int lme2510_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
+		struct usb_data_stream_properties *stream)
+{
+	struct dvb_usb_adapter *adap = fe_to_adap(fe);
+	struct dvb_usb_device *d = adap_to_d(adap);
 
+	if (adap == NULL)
+		return 0;
+	/* Turn PID filter on the fly by module option */
+	if (pid_filter == 2) {
+		adap->pid_filtering  = 1;
+		adap->max_feed_count = 15;
 	}
-};
 
-static struct dvb_usb_device_properties lme2510c_properties = {
-	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
-	.size_of_priv = sizeof(struct lme2510_state),
-	.num_adapters = 1,
-	.adapter = {
-		{
-		.num_frontends = 1,
-		.fe = {{
-			.caps = DVB_USB_ADAP_HAS_PID_FILTER|
-				DVB_USB_ADAP_NEED_PID_FILTERING|
-				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
-			.streaming_ctrl   = lme2510_streaming_ctrl,
-			.pid_filter_count = 32,
-			.pid_filter = lme2510_pid_filter,
-			.pid_filter_ctrl  = lme2510_pid_filter_ctrl,
-			.frontend_attach  = dm04_lme2510_frontend_attach,
-			.tuner_attach = dm04_lme2510_tuner,
-			/* parameter for the MPEG2-data transfer */
-			.stream = {
-				.type = USB_BULK,
-				.count = 10,
-				.endpoint = 0x8,
-				.u = {
-					.bulk = {
-						.buffersize = 4096,
+	if (!(le16_to_cpu(d->udev->descriptor.idProduct)
+		== 0x1122))
+		stream->endpoint = 0x8;
 
-					}
-				}
-			}
-		}},
-		}
-	},
-	.rc.core = {
-		.protocol	= RC_TYPE_NEC,
-		.module_name	= "LME2510 Remote Control",
-		.allowed_protos	= RC_TYPE_NEC,
-		.rc_codes	= RC_MAP_LME2510,
-	},
-	.power_ctrl       = lme2510_powerup,
-	.identify_state   = lme2510_identify_state,
-	.i2c_algo         = &lme2510_i2c_algo,
-	.generic_bulk_ctrl_endpoint = 0,
-	.num_device_descs = 2,
-	.devices = {
-		{   "DM04_LME2510C_DVB-S",
-			{ &lme2510_table[1], NULL },
-			},
-		{   "DM04_LME2510C_DVB-S RS2000",
-			{ &lme2510_table[2], NULL },
-			},
-	}
-};
+	return 0;
+}
+
+static int lme2510_get_rc_config(struct dvb_usb_device *d,
+	struct dvb_usb_rc *rc)
+{
+	rc->allowed_protos = RC_TYPE_NEC;
+	return 0;
+}
 
 static void *lme2510_exit_int(struct dvb_usb_device *d)
 {
@@ -1361,8 +1268,7 @@ static void *lme2510_exit_int(struct dvb_usb_device *d)
 	void *buffer = NULL;
 
 	if (adap != NULL) {
-		lme2510_kill_urb(&adap->fe_adap[0].stream);
-		adap->feedcount = 0;
+		lme2510_kill_urb(&adap->stream);
 	}
 
 	if (st->usb_buffer != NULL) {
@@ -1383,29 +1289,85 @@ static void *lme2510_exit_int(struct dvb_usb_device *d)
 	return buffer;
 }
 
-static void lme2510_exit(struct usb_interface *intf)
+static void lme2510_exit(struct dvb_usb_device *d)
 {
-	struct dvb_usb_device *d = usb_get_intfdata(intf);
 	void *usb_buffer;
 
 	if (d != NULL) {
 		usb_buffer = lme2510_exit_int(d);
-		dvb_usb_device_exit(intf);
 		if (usb_buffer != NULL)
 			kfree(usb_buffer);
 	}
 }
 
+static struct dvb_usb_device_properties lme2510_props = {
+	.driver_name = KBUILD_MODNAME,
+	.owner = THIS_MODULE,
+	.bInterfaceNumber = 0,
+	.adapter_nr = adapter_nr,
+	.size_of_priv = sizeof(struct lme2510_state),
+
+	.download_firmware = lme2510_download_firmware,
+
+	.power_ctrl       = lme2510_powerup,
+	.identify_state   = lme2510_identify_state,
+	.i2c_algo         = &lme2510_i2c_algo,
+
+	.frontend_attach  = dm04_lme2510_frontend_attach,
+	.tuner_attach = dm04_lme2510_tuner,
+	.get_stream_config = lme2510_get_stream_config,
+	.get_adapter_count = lme2510_get_adapter_count,
+	.streaming_ctrl   = lme2510_streaming_ctrl,
+
+	.get_rc_config = lme2510_get_rc_config,
+
+	.exit = lme2510_exit,
+	.adapter = {
+		{
+			.caps = DVB_USB_ADAP_HAS_PID_FILTER|
+				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+			.pid_filter_count = 15,
+			.pid_filter = lme2510_pid_filter,
+			.pid_filter_ctrl  = lme2510_pid_filter_ctrl,
+			.stream =
+			DVB_USB_STREAM_BULK(0x86, 10, 4096),
+		},
+		{
+		}
+	},
+};
+
+static const struct usb_device_id lme2510_id_table[] = {
+	{	DVB_USB_DEVICE(0x3344, 0x1122, &lme2510_props,
+		"DM04_LME2510_DVB-S", RC_MAP_LME2510)	},
+	{	DVB_USB_DEVICE(0x3344, 0x1120, &lme2510_props,
+		"DM04_LME2510C_DVB-S", RC_MAP_LME2510)	},
+	{	DVB_USB_DEVICE(0x3344, 0x22f0, &lme2510_props,
+		"DM04_LME2510C_DVB-S RS2000", RC_MAP_LME2510)	},
+	{}		/* Terminating entry */
+};
+
+MODULE_DEVICE_TABLE(usb, lme2510_id_table);
+
 static struct usb_driver lme2510_driver = {
-	.name		= "LME2510C_DVB-S",
-	.probe		= lme2510_probe,
-	.disconnect	= lme2510_exit,
-	.id_table	= lme2510_table,
+	.name		= KBUILD_MODNAME,
+	.probe		= dvb_usbv2_probe,
+	.disconnect	= dvb_usbv2_disconnect,
+	.id_table	= lme2510_id_table,
+	.no_dynamic_id = 1,
+	.soft_unbind = 1,
 };
 
 module_usb_driver(lme2510_driver);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.99");
+MODULE_VERSION("2.06");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(LME2510_C_S7395);
+MODULE_FIRMWARE(LME2510_C_LG);
+MODULE_FIRMWARE(LME2510_C_S0194);
+MODULE_FIRMWARE(LME2510_C_RS2000);
+MODULE_FIRMWARE(LME2510_LG);
+MODULE_FIRMWARE(LME2510_S0194);
+
diff --git a/drivers/media/dvb/dvb-usb/lmedm04.h b/drivers/media/dvb/dvb-usb-v2/lmedm04.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/lmedm04.h
rename to drivers/media/dvb/dvb-usb-v2/lmedm04.h
diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index 29bba9a..8e13877 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -304,19 +304,6 @@ config DVB_USB_AZ6027
 	help
 	  Say Y here to support the AZ6027 device
 
-config DVB_USB_LME2510
-	tristate "LME DM04/QQBOX DVB-S USB2.0 support"
-	depends on DVB_USB
-	select DVB_TDA10086 if !DVB_FE_CUSTOMISE
-	select DVB_TDA826X if !DVB_FE_CUSTOMISE
-	select DVB_STV0288 if !DVB_FE_CUSTOMISE
-	select DVB_IX2505V if !DVB_FE_CUSTOMISE
-	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_PLL if !DVB_FE_CUSTOMISE
-	select DVB_M88RS2000 if !DVB_FE_CUSTOMISE
-	help
-	  Say Y here to support the LME DM04/QQBOX DVB-S USB2.0 .
-
 config DVB_USB_TECHNISAT_USB2
 	tristate "Technisat DVB-S/S2 USB2.0 support"
 	depends on DVB_USB
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index 5261c7d..859baf9 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -72,9 +72,6 @@ obj-$(CONFIG_DVB_USB_FRIIO) += dvb-usb-friio.o
 dvb-usb-az6027-objs = az6027.o
 obj-$(CONFIG_DVB_USB_AZ6027) += dvb-usb-az6027.o
 
-dvb-usb-lmedm04-objs = lmedm04.o
-obj-$(CONFIG_DVB_USB_LME2510) += dvb-usb-lmedm04.o
-
 dvb-usb-technisat-usb2-objs = technisat-usb2.o
 obj-$(CONFIG_DVB_USB_TECHNISAT_USB2) += dvb-usb-technisat-usb2.o
 
-- 
1.7.9.5


