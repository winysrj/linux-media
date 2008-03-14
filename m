Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <47DAC4BE.5090805@iki.fi>
Date: Fri, 14 Mar 2008 20:32:30 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>	<47D847AC.9070803@linuxtv.org>	<abf3e5070803121425k326fd126l1bfd47595617c10f@mail.gmail.com>	<47D86336.2070200@iki.fi>	<abf3e5070803121920j5d05208fo1162e4d4e3f6c44f@mail.gmail.com>	<abf3e5070803131607j1432f590p44b9b9c80f1f36e7@mail.gmail.com>	<47D9C33E.6090503@iki.fi>	<abf3e5070803131953o5c52def9n5c6e4c3f26102e89@mail.gmail.com>	<47D9EED4.8090303@linuxtv.org>	<abf3e5070803132022g3e2c638fxc218030c535372b@mail.gmail.com>	<47DA0F01.8010707@iki.fi>	<47DA7008.8010404@linuxtv.org>
	<47DAC42D.7010306@iki.fi>
In-Reply-To: <47DAC42D.7010306@iki.fi>
Content-Type: multipart/mixed; boundary="------------030003000706070103020408"
Cc: linux-dvb@linuxtv.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [linux-dvb] NXP 18211HDC1 tuner
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
--------------030003000706070103020408
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

forgot attach patch...

Antti Palosaari wrote:
> Michael Krufky wrote:
>> 4.3 is not close enough to 3.8.  If you don't know how to set the demod
>> to 3.8, then we can do some hacks to make it work, but signal reception
>> is likely to be very poor -- better off looking in his snoop log to see
>> how the windows driver sets the demod to 3.8
> 
> OI have looked sniffs and tested linux driver and found that it is set 
> to 3800. There is 4300 kHz set in eeprom, it is ok for 8 MHz but not for 
> 6 or 7. Looks like driver needs to do some quirks when this tuner is 
> used. Anyhow, patch attached is hardcoded to use 3.8 now.
> 
> Jarryd, please test. Also some changes to stick plug done, if it does 
> not work for you can fix it as earlier.
> 
> regards
> Antti


-- 
http://palosaari.fi/

--------------030003000706070103020408
Content-Type: text/x-diff;
 name="af9015_tda18271_test1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="af9015_tda18271_test1.patch"

diff -r 67b68ae8e249 linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Thu Mar 13 00:58:29 2008 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Fri Mar 14 20:19:28 2008 +0200
@@ -18,6 +18,7 @@
 
 /* debug */
 int dvb_usb_af9015_debug = 0x3d;
+//int dvb_usb_af9015_debug = -1;
 
 module_param_named(debug, dvb_usb_af9015_debug, int, 0644);
 MODULE_PARM_DESC(
@@ -27,7 +28,10 @@ MODULE_PARM_DESC(
 
 static struct af9013_config af9015_af9013_config = {
 	.demod_address = AF9015_I2C_DEMOD,
-	.tuner_if = 36125,
+//	.tuner_if = 36125,
+//	.tuner_if = 4300,
+	.tuner_if = 3800, //7MHz
+//	.tuner_if = 3300,
 	.ts_mode = AF9013_USB,
 };
 
@@ -413,8 +417,9 @@ static int af9015_download_firmware(stru
 		err("%s: boot failed: %d", __FUNCTION__, ret);
 		goto exit;
 	}
-	msleep(20);
+	msleep(1);
 
+#if 1
 	/* boot done, ensure that firmware is running */
 	req.cmd = GET_CONFIG;
 	req.len = 1;
@@ -429,8 +434,8 @@ static int af9015_download_firmware(stru
 		err("%s: firmware did not run (%02x)", __FUNCTION__, tmp);
 		return -EIO;
 	}
-
-#if 0
+#endif
+#if 1
 	/* firmware is running, reconnect device in the usb bus */
 	req.cmd = RECONNECT_USB;
 	ret = af9015_rw_udev(udev, &req);
@@ -495,6 +500,7 @@ static int af9015_read_config(struct dvb
 	case AF9013_TUNER_TDA18271:
 		af9015_af9013_config.tuner = AF9013_TUNER_TDA18271;
 		af9015_af9013_config.rf_spec_inv = 1;
+//		af9015_af9013_config.rf_spec_inv = 0;
 		state->gpio3 = 0x3; /* connect tuner on GPIO3 */
 		break;
 	default:
@@ -738,18 +744,22 @@ static struct dvb_usb_device_properties 
 			},
 		}
 	},
-	.num_device_descs = 3,
+	.num_device_descs = 2,
 	.devices = {
 		{
 			.name = "Afatech AF9015 DVB-T USB2.0 stick",
-			.cold_ids = {&af9015_usb_table[0], NULL},
+			.cold_ids = {&af9015_usb_table[0], &af9015_usb_table[1], NULL},
 			.warm_ids = {NULL},
 		},
+#if 0
 		{
 			.name = "Afatech AF9015 DVB-T USB2.0 stick",
-			.cold_ids = {&af9015_usb_table[1], NULL},
-			.warm_ids = {NULL},
+			.cold_ids = {NULL},
+//			.cold_ids = {&af9015_usb_table[1], NULL},
+			.warm_ids = {&af9015_usb_table[1], NULL},
+//			.warm_ids = {NULL},
 		},
+#endif
 		{
 			/* Leadtek Winfast DTV Dongle Gold */
 			.name = "Afatech AF9015 DVB-T USB2.0 stick",
diff -r 67b68ae8e249 linux/drivers/media/dvb/frontends/af9013.c
--- a/linux/drivers/media/dvb/frontends/af9013.c	Thu Mar 13 00:58:29 2008 +0200
+++ b/linux/drivers/media/dvb/frontends/af9013.c	Fri Mar 14 20:19:28 2008 +0200
@@ -22,7 +22,7 @@
 #include "af9013_priv.h"
 #include "af9013.h"
 
-int debug;
+int debug = 1;
 
 struct af9013_state {
 	struct i2c_adapter *i2c;
@@ -347,6 +347,9 @@ static int af9013_set_adc_ctrl(struct af
 	buf[1] = (u8) ((adc_cw & 0x0000ff00) >> 8);
 	buf[2] = (u8) ((adc_cw & 0x00ff0000) >> 16);
 
+	deb_info("adc_cw:");
+	debug_dump(buf, sizeof(buf), deb_info);
+
 	/* program */
 	for (i = 0; i < sizeof(buf); i++) {
 		ret = af9013_write_reg(state, addr++, buf[i]);
@@ -402,9 +405,31 @@ static int af9013_set_freq_ctrl(struct a
 	for (i = 0; i < sizeof(buf); i++) {
 		ret = af9013_write_reg(state, addr++, buf[i]);
 		if (ret)
+			goto exit;
+	}
+
+	/* program to dummy ram also */
+	addr = 0x9be7;
+	for (i = 0; i < sizeof(buf); i++) {
+		ret = af9013_write_reg(state, addr++, buf[i]);
+		if (ret)
+			goto exit;
+//			break;
+	}
+
+#if 1
+	/* program other fcw FIXME */
+	addr = 0x9bea;
+	buf[0] = 0xec;
+	buf[1] = 0xa0;
+	buf[2] = 0x6e;
+	for (i = 0; i < sizeof(buf); i++) {
+		ret = af9013_write_reg(state, addr++, buf[i]);
+		if (ret)
 			break;
 	}
-
+#endif
+exit:
 	return ret;
 }
 

--------------030003000706070103020408
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------030003000706070103020408--
