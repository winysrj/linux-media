Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate02.web.de ([217.72.192.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Andre.Weidemann@web.de>) id 1JTvTQ-000494-QK
	for linux-dvb@linuxtv.org; Tue, 26 Feb 2008 09:47:40 +0100
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate02.web.de (Postfix) with ESMTP id 7C291D229EEB
	for <linux-dvb@linuxtv.org>; Tue, 26 Feb 2008 09:47:07 +0100 (CET)
Received: from [84.184.116.196] (helo=[127.0.0.1])
	by smtp08.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.109 #226) id 1JTvSt-0004Ke-00
	for linux-dvb@linuxtv.org; Tue, 26 Feb 2008 09:47:07 +0100
Message-ID: <47C3D206.9020507@web.de>
Date: Tue, 26 Feb 2008 09:47:02 +0100
From: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <200801252245.58642.dkuhlen@gmx.net>
In-Reply-To: <200801252245.58642.dkuhlen@gmx.net>
Content-Type: multipart/mixed; boundary="------------040003070205010301050202"
Subject: Re: [linux-dvb] TT Connect S2-3600 (was: Pinnacle PCTV Sat HDTV Pro
 USB (PCTV452e) and DVB-S2)
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
--------------040003070205010301050202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Dominik Kuhlen wrote:
> Hi all,
>=20
> Manus multiproto HG tree (jusst.de/hg/multiproto) and the attached patc=
h make the pctv452e work with DVB-S2 and DVB-S :)

Hi all,
I took Dominiks patch and added support for the TT connect S2-3600.

The S2-3600 is tuning to DVB-S and DVB-S2 but I still got some image=20
distortions. I'm quite sure I got the correct firmware for the S2-3600=20
but I only did some quick testing last night.
The patch may still have some quirks... so use at your own risk.

If anyone should volunteer to try the attached patch, please make sure=20
to apply the patch for the PCTV 452e first!
The firmware for the S2-3600 can be found here:
http://ilpss8.dyndns.org/dvb-usb-tt-connect-s2-3600-01.fw

I will also have a PCTV 452e for testing at the end of the week. So I=20
can test both USB boxes with the driver.

  Andr=E9

--------------040003070205010301050202
Content-Type: text/plain;
 name="patch-TT_connect_S2-3600.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-TT_connect_S2-3600.diff"

diff -Nrubw multiproto-pctv452e/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h multiproto-s2-3600/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- multiproto-pctv452e/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-02-26 08:50:03.484626963 +0100
+++ multiproto-s2-3600/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-02-26 09:04:17.757309187 +0100
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
diff -Nrubw multiproto-pctv452e/linux/drivers/media/dvb/dvb-usb/Kconfig multiproto-s2-3600/linux/drivers/media/dvb/dvb-usb/Kconfig
--- multiproto-pctv452e/linux/drivers/media/dvb/dvb-usb/Kconfig	2008-02-26 08:49:32.034834741 +0100
+++ multiproto-s2-3600/linux/drivers/media/dvb/dvb-usb/Kconfig	2008-02-26 08:55:36.495604176 +0100
@@ -240,7 +240,7 @@
 	  Afatech AF9005 based receiver.
 
 config DVB_USB_PCTV452E
-	tristate "Pinnacle PCTV HDTV Pro USB device"
+	tristate "Pinnacle PCTV HDTV Pro USB device/TT Connect S2-3600"
 	depends on DVB_USB
 	select DVB_LNBP22
 	select DVB_STB0899
diff -Nrubw multiproto-pctv452e/linux/drivers/media/dvb/dvb-usb/pctv452e.c multiproto-s2-3600/linux/drivers/media/dvb/dvb-usb/pctv452e.c
--- multiproto-pctv452e/linux/drivers/media/dvb/dvb-usb/pctv452e.c	2008-02-26 08:49:32.174842719 +0100
+++ multiproto-s2-3600/linux/drivers/media/dvb/dvb-usb/pctv452e.c	2008-02-26 08:55:36.943629708 +0100
@@ -370,6 +370,7 @@
 static struct stb0899_config stb0899_config;
 static struct stb6100_config stb6100_config;
 static struct dvb_usb_device_properties pctv452e_properties;
+static struct dvb_usb_device_properties tt_connect_s2_3600_properties;
 
 int pctv452e_frontend_attach(struct dvb_usb_adapter *a) {
 
@@ -395,9 +396,12 @@
 	return 0;
 }
 
-static int pctv452e_usb_probe(struct usb_interface *intf,
-    const struct usb_device_id *id) {
-  return dvb_usb_device_init(intf, &pctv452e_properties, THIS_MODULE, NULL);
+static int pctv452e_usb_probe(struct usb_interface *intf,const struct usb_device_id *id) {
+	int ret=-ENOMEM;
+        if ((ret=dvb_usb_device_init(intf, &pctv452e_properties, THIS_MODULE, NULL))==0){
+		return ret;
+	}
+        return dvb_usb_device_init(intf, &tt_connect_s2_3600_properties,THIS_MODULE,NULL);
 }
 
 
@@ -423,7 +427,7 @@
 // 	{ STB0899_IRQMSK_3      , 0xff },
 // 	{ STB0899_IRQMSK_4      , 0xff },
 	{ STB0899_I2CCFG        , 0x88 },
-	{ STB0899_I2CRPT        , 0x5c },
+	{ STB0899_I2CRPT        , 0x58 },
 	{ STB0899_GPIO00CFG     , 0x82 },
 	{ STB0899_GPIO01CFG     , 0x82 }, /* 0x02 -> LED green 0x82 -> LED orange */
 	{ STB0899_GPIO02CFG     , 0x82 },
@@ -1007,6 +1011,7 @@
 
 static struct usb_device_id pctv452e_usb_table[] = {
 	{USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_452E)},
+	{USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_CONNECT_S2_3600)},
 	{}
 };
 MODULE_DEVICE_TABLE(usb, pctv452e_usb_table);
@@ -1066,6 +1071,61 @@
 	}
 };
 
+static struct dvb_usb_device_properties tt_connect_s2_3600_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER, /* more ? */
+	.usb_ctrl = DEVICE_SPECIFIC,
+
+	.size_of_priv     = sizeof(struct pctv452e_state),
+
+	.identify_state   = 0, // this is a warm only device
+
+	.power_ctrl       = pctv452e_power_ctrl,
+
+	.rc_key_map       = pctv452e_rc_keys,
+	.rc_key_map_size  = ARRAY_SIZE(pctv452e_rc_keys),
+	.rc_query         = pctv452e_rc_query,
+	.rc_interval      = 100,
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
+		{ .name = "Technotrend TT Connect S2-3600",
+		  .cold_ids = { NULL, NULL }, // this is a warm only device
+		  .warm_ids = { &pctv452e_usb_table[1], NULL }
+		},
+		{ 0 },
+	}
+};
+
 
 
 static struct usb_driver pctv452e_usb_driver = {
@@ -1078,19 +1138,33 @@
 	.id_table   = pctv452e_usb_table,
 };
 
+static struct usb_driver tt_connects2_3600_usb_driver = {
+#if LINUX_VERSION_CODE <=  KERNEL_VERSION(2,6,15)
+	.owner      = THIS_MODULE,
+#endif
+	.name       = "dvb-usb-tt-connect-s2-3600-01.fw",
+	.probe      = pctv452e_usb_probe, 
+	.disconnect = dvb_usb_device_exit,
+	.id_table   = pctv452e_usb_table,
+};
+
 static int __init pctv452e_usb_init(void) {
-	int err;
+	int err=0;
 
 	if ((err = usb_register(&pctv452e_usb_driver))) {
 		printk("%s: usb_register failed! Error number %d", __FILE__, err);
 		return err;
 	}
+	if ((err = usb_register(&tt_connects2_3600_usb_driver))) {
+		printk("%s: usb_register failed! Error number %d", __FILE__, err);
+	}
 
-	return 0;
+	return err;
 }
 
 static void __exit pctv452e_usb_exit(void)  {
 	usb_deregister(&pctv452e_usb_driver);
+	usb_deregister(&tt_connects2_3600_usb_driver);
 }
 
 module_init(pctv452e_usb_init);

--------------040003070205010301050202
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------040003070205010301050202--
