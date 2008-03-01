Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate01.web.de ([217.72.192.221])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Andre.Weidemann@web.de>) id 1JVOWW-0003K5-Fu
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 11:00:56 +0100
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate01.web.de (Postfix) with ESMTP id 4D886D536DEF
	for <linux-dvb@linuxtv.org>; Sat,  1 Mar 2008 11:00:23 +0100 (CET)
Received: from [84.184.102.63] (helo=[192.168.0.1])
	by smtp07.web.de with asmtp (WEB.DE 4.109 #226) id 1JVOVz-000523-00
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 11:00:23 +0100
Message-ID: <47C92937.7000703@web.de>
Date: Sat, 01 Mar 2008 11:00:23 +0100
From: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------080803060806010401050303"
Subject: [linux-dvb] [PATCH] Support for TT connect S2-3600
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
--------------080803060806010401050303
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi,
I have reviewed my last week's quick shot patch and here is a new version=
.
The firmware I mentioned in the first patch is not needed, since it is=20
stored on the device itself.
I also got the black TT remote working with it. I had to set rc_interval=20
to 500, because the key repeats came in too fast.

The image distortions I mentioned in an earlier post are still visible.
Dominik said that he also had packet losses on a TS record. So I hope he=20
can fix it.

Before applying the attached patch you need to apply Dominik's patch for=20
the Pinnacle PCTV 452e.

Please test the attached patch and let me know if you ran into any proble=
ms.

Note:
Manu's code in changeset 7207 seems to have broken tuning for this=20
device. Changesets 7202 to 7205 are still working.


Have a nice weekend.
  Andr=E9

--------------080803060806010401050303
Content-Type: text/x-diff;
 name="patch-tt-connect-s2-3600.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-tt-connect-s2-3600.diff"

diff -Nrubw multiproto-452/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h multiproto_S2-3600/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- multiproto-452/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-03-01 10:48:28.674288316 +0100
+++ multiproto_S2-3600/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-03-01 10:48:48.715408833 +0100
@@ -40,6 +40,7 @@
 #define USB_VID_MSI				0x0db0
 #define USB_VID_OPERA1				0x695c
 #define USB_VID_PINNACLE			0x2304
+#define USB_VID_TECHNOTREND                     0x0b48
 #define USB_VID_TERRATEC			0x0ccd
 #define USB_VID_VISIONPLUS			0x13d3
 #define USB_VID_TWINHAN				0x1822
@@ -142,6 +143,7 @@
 #define USB_PID_PCTV_400E				0x020f
 #define USB_PID_PCTV_450E				0x0222
 #define USB_PID_PCTV_452E                               0x021f
+#define USB_PID_TECHNOTREND_CONNECT_S2_3600             0x3007
 #define USB_PID_NEBULA_DIGITV				0x0201
 #define USB_PID_DVICO_BLUEBIRD_LGDT			0xd820
 #define USB_PID_DVICO_BLUEBIRD_LG064F_COLD		0xd500
diff -Nrubw multiproto-452/linux/drivers/media/dvb/dvb-usb/Kconfig multiproto_S2-3600/linux/drivers/media/dvb/dvb-usb/Kconfig
--- multiproto-452/linux/drivers/media/dvb/dvb-usb/Kconfig	2008-03-01 10:48:28.674288316 +0100
+++ multiproto_S2-3600/linux/drivers/media/dvb/dvb-usb/Kconfig	2008-03-01 10:48:48.715408833 +0100
@@ -240,14 +240,15 @@
 	  Afatech AF9005 based receiver.
 
 config DVB_USB_PCTV452E
-	tristate "Pinnacle PCTV HDTV Pro USB device"
+	tristate "Pinnacle PCTV HDTV Pro USB device / TT connect S2-3600 (NEW)"
 	depends on DVB_USB
 	select DVB_LNBP22
 	select DVB_STB0899
 	select DVB_STB6100
 	help
-	  Support for external USB adapter designed by Pinnacle,
-	  shipped under the brand name 'PCTV HDTV Pro USB'.
+	  Support for external USB adapter designed by TechnoTrend and,
+	  shipped under the brand name 'Pinnacle PCTV HDTV Pro USB' and
+	  'TechnoTrend TT connect S2-3600'.
 
 	  These devices don't have a MPEG decoder built in, so you need
 	  an external software decoder to watch TV.
diff -Nrubw multiproto-452/linux/drivers/media/dvb/dvb-usb/pctv452e.c multiproto_S2-3600/linux/drivers/media/dvb/dvb-usb/pctv452e.c
--- multiproto-452/linux/drivers/media/dvb/dvb-usb/pctv452e.c	2008-03-01 10:48:28.678288540 +0100
+++ multiproto_S2-3600/linux/drivers/media/dvb/dvb-usb/pctv452e.c	2008-03-01 10:48:48.719409057 +0100
@@ -320,6 +320,53 @@
 	{0x07, 0x3f, KEY_HELP}
 };
 
+
+/* Remote Control Stuff fo S2-3600 (copied from TT-S1500): */
+static struct dvb_usb_rc_key tt_connect_s2_3600_rc_key[] = {
+        {0x15, 0x01, KEY_POWER},
+        {0x15, 0x02, KEY_SHUFFLE}, /* ? double-arrow key */
+        {0x15, 0x03, KEY_1},
+        {0x15, 0x04, KEY_2},
+        {0x15, 0x05, KEY_3},
+        {0x15, 0x06, KEY_4},
+        {0x15, 0x07, KEY_5},
+        {0x15, 0x08, KEY_6},
+        {0x15, 0x09, KEY_7},
+        {0x15, 0x0a, KEY_8},
+        {0x15, 0x0b, KEY_9},
+        {0x15, 0x0c, KEY_0},
+        {0x15, 0x0d, KEY_UP},
+        {0x15, 0x0e, KEY_LEFT},
+        {0x15, 0x0f, KEY_OK},
+        {0x15, 0x10, KEY_RIGHT},
+        {0x15, 0x11, KEY_DOWN},
+        {0x15, 0x12, KEY_INFO},
+        {0x15, 0x13, KEY_EXIT},
+        {0x15, 0x14, KEY_RED},
+        {0x15, 0x15, KEY_GREEN},
+        {0x15, 0x16, KEY_YELLOW},
+        {0x15, 0x17, KEY_BLUE},
+        {0x15, 0x18, KEY_MUTE},
+        {0x15, 0x19, KEY_TEXT},
+        {0x15, 0x1a, KEY_MODE},  /* ? TV/Radio */
+        {0x15, 0x21, KEY_OPTION},
+        {0x15, 0x22, KEY_EPG},
+        {0x15, 0x23, KEY_CHANNELUP},
+        {0x15, 0x24, KEY_CHANNELDOWN},
+        {0x15, 0x25, KEY_VOLUMEUP},
+        {0x15, 0x26, KEY_VOLUMEDOWN},
+        {0x15, 0x27, KEY_SETUP},
+        {0x15, 0x3a, KEY_RECORD},/* these keys are only in the black remote */
+        {0x15, 0x3b, KEY_PLAY},
+        {0x15, 0x3c, KEY_STOP},
+        {0x15, 0x3d, KEY_REWIND},
+        {0x15, 0x3e, KEY_PAUSE},
+        {0x15, 0x3f, KEY_FORWARD}
+};
+
+
+
+
 static int pctv452e_rc_query(struct dvb_usb_device *d, u32 *keyevent, int *keystate) {
 	struct pctv452e_state *state = (struct pctv452e_state *)d->priv;
 	u8 b[CMD_BUFFER_SIZE];
@@ -370,6 +417,7 @@
 static struct stb0899_config stb0899_config;
 static struct stb6100_config stb6100_config;
 static struct dvb_usb_device_properties pctv452e_properties;
+static struct dvb_usb_device_properties tt_s2_3600_properties;
 
 int pctv452e_frontend_attach(struct dvb_usb_adapter *a) {
 
@@ -395,9 +443,13 @@
 	return 0;
 }
 
-static int pctv452e_usb_probe(struct usb_interface *intf,
-    const struct usb_device_id *id) {
-  return dvb_usb_device_init(intf, &pctv452e_properties, THIS_MODULE, NULL);
+static int pctv452e_usb_probe(struct usb_interface *intf, const struct usb_device_id *id) {
+        int ret;
+        if ((ret =  dvb_usb_device_init(intf, &pctv452e_properties, THIS_MODULE, NULL))==0)
+        {
+                return ret;
+        }
+        return dvb_usb_device_init(intf, &tt_s2_3600_properties, THIS_MODULE, NULL);
 }
 
 
@@ -423,7 +475,7 @@
 // 	{ STB0899_IRQMSK_3      , 0xff },
 // 	{ STB0899_IRQMSK_4      , 0xff },
 	{ STB0899_I2CCFG        , 0x88 },
-	{ STB0899_I2CRPT        , 0x5c },
+	{ STB0899_I2CRPT        , 0x58 },
 	{ STB0899_GPIO00CFG     , 0x82 },
 	{ STB0899_GPIO01CFG     , 0x82 }, /* 0x02 -> LED green 0x82 -> LED orange */
 	{ STB0899_GPIO02CFG     , 0x82 },
@@ -1007,6 +1059,7 @@
 
 static struct usb_device_id pctv452e_usb_table[] = {
 	{USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_452E)},
+	{USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_CONNECT_S2_3600)},
 	{}
 };
 MODULE_DEVICE_TABLE(usb, pctv452e_usb_table);
@@ -1066,6 +1119,60 @@
 	}
 };
 
+static struct dvb_usb_device_properties tt_s2_3600_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER, /* more ? */
+	.usb_ctrl = DEVICE_SPECIFIC,
+
+	.size_of_priv     = sizeof(struct pctv452e_state),
+
+	.identify_state   = 0, // this is a warm only device
+
+	.power_ctrl       = pctv452e_power_ctrl,
+
+	.rc_key_map       = tt_connect_s2_3600_rc_key,
+	.rc_key_map_size  = ARRAY_SIZE(tt_connect_s2_3600_rc_key),
+	.rc_query         = pctv452e_rc_query,
+	.rc_interval      = 500,
+
+	.num_adapters     = 1,
+	.adapter = {{
+		.caps             = 0,
+		.pid_filter_count = 0,
+
+		.streaming_ctrl   = pctv452e_streaming_ctrl,
+
+		.frontend_attach  = pctv452e_frontend_attach,
+		.tuner_attach     = pctv452e_tuner_attach,
+
+		/* parameter for the MPEG2-data transfer */
+		.stream = {
+			.type     = USB_ISOC,
+			.count    = 7,
+			.endpoint = 0x02,
+			.u = {
+				.isoc = {
+					.framesperurb = 4,
+					.framesize    = 940,
+					.interval     = 1
+				}
+			}
+		},
+		.size_of_priv     = 0
+	}},
+
+	.i2c_algo = &pctv452e_i2c_algo,
+
+	.generic_bulk_ctrl_endpoint = 1, /* allow generice rw function*/
+
+	.num_device_descs = 1,
+	.devices = {
+		{ "Technotrend TT connect S2-3600",
+		  { NULL }, //can I force a firmware upload !?!
+		  { &pctv452e_usb_table[1], NULL }
+		},
+	}
+};
+
 
 
 static struct usb_driver pctv452e_usb_driver = {
@@ -1097,5 +1204,5 @@
 module_exit(pctv452e_usb_exit);
 
 MODULE_AUTHOR("Dominik Kuhlen <dkuhlen@gmx.net>");
-MODULE_DESCRIPTION("PCTV HDTV DVB Driver");
+MODULE_DESCRIPTION("PCTV HDTV DVB Driver / TT connect S2-3600");
 MODULE_LICENSE("GPL");

--------------080803060806010401050303
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------080803060806010401050303--
