Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.landsh.de ([193.101.67.2]:44708 "EHLO firewall.landsh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab0GVHR2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jul 2010 03:17:28 -0400
Received: from mscan1.landsh.de (unknown [10.1.12.36])
	by firewall.landsh.de (Postfix) with ESMTP id 98B8827613B
	for <linux-media@vger.kernel.org>; Thu, 22 Jul 2010 09:17:26 +0200 (CEST)
Received: from lr-ex2.lr.landsh.de (unknown [10.2.161.22])
	by mscan1.landsh.de (Postfix) with ESMTP id 0C0FB10001507
	for <linux-media@vger.kernel.org>; Thu, 22 Jul 2010 09:17:22 +0200 (CEST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Technisat AirStar TeleStick 2
Date: Thu, 22 Jul 2010 09:17:21 +0200
Message-ID: <36BCFE472FE7984D89C9B04F1E76EBA501ACC4D8@fm-dc1.lr.landsh.de>
From: <Veit.Berwig@fimi.landsh.de>
To: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello V4L-Team,

> Please re-base your patch against upstream tree, generate it
> at the unified format, and send it in-lined. 
> You also need to add your Signed-off-by:

I will do my very best althought i'm not a professional patch submitter
;-)
I suppose with "upstream tree" you mean the source tree from the
hg-repository above the "linux"-directory ?

Ok, here we go:

--- dvb-usb-ids.h_technisat_ast2.patch ---

Signed-off-by: veit berwig

--- linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2010-05-27
05:02:09.000000000 +0000
+++
v4l-dvb-9652f85e688a.technisat_ast2/linux/drivers/media/dvb/dvb-usb/dvb-
usb-ids.h	2010-06-25 14:37:15.000000000 +0000
@@ -304,4 +304,5 @@
 #define USB_PID_TERRATEC_DVBS2CI_V2			0x10ac
 #define USB_PID_TECHNISAT_USB2_HDCI_V1			0x0001
 #define USB_PID_TECHNISAT_USB2_HDCI_V2			0x0002
+#define USB_PID_TECHNISAT_AIRSTAR_TELESTICK_2		0x0004
 #endif

--- dib0700_devices.c_technisat_ast2.patch ---

Signed-off-by: veit berwig

--- linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2010-05-27
05:02:09.000000000 +0000
+++
v4l-dvb-9652f85e688a.technisat_ast2/linux/drivers/media/dvb/dvb-usb/dib0
700_devices.c	2010-06-25 14:36:51.000000000 +0000
@@ -686,6 +686,37 @@
 	{ 0x1e3b, KEY_GOTO },
 	{ 0x1e3d, KEY_POWER },
 
+	/* Key codes for the Technisat T035 remote*/
+	{ 0x128C, KEY_POWER },
+	{ 0x1281, KEY_1 },
+	{ 0x1282, KEY_2 },
+	{ 0x1283, KEY_3 },
+	{ 0x1284, KEY_4 },
+	{ 0x1285, KEY_5 },
+	{ 0x1286, KEY_6 },
+	{ 0x1287, KEY_7 },
+	{ 0x1288, KEY_8 },
+	{ 0x1289, KEY_9 },
+	{ 0x1280, KEY_0 },
+	{ 0x12AF, KEY_EPG },
+	{ 0x12A0, KEY_UP },
+	{ 0x1291, KEY_LEFT },
+	{ 0x0297, KEY_OK },
+	{ 0x1290, KEY_RIGHT },
+	{ 0x12A1, KEY_DOWN },
+	{ 0x0A8F, KEY_INFO },
+	{ 0x02AB, KEY_RED },
+	{ 0x02AC, KEY_GREEN },
+	{ 0x02AD, KEY_YELLOW },
+	{ 0x02AE, KEY_BLUE },
+	{ 0x128D, KEY_MUTE },
+	{ 0x0292, KEY_MENU }, /* DVD Menu */
+	{ 0x12BC, KEY_TEXT }, /* Teletext */
+	{ 0x0293, KEY_TV },
+	{ 0x12A9, KEY_STOP },
+	{ 0x12A2, KEY_BACK },
+	{ 0x12B8, KEY_SELECT }, /* Select EXT video input */
+
 	/* Key codes for the Leadtek Winfast DTV Dongle */
 	{ 0x0042, KEY_POWER },
 	{ 0x077c, KEY_TUNER },
@@ -2091,7 +2122,8 @@
 	{ USB_DEVICE(USB_VID_PINNACLE,	USB_PID_PINNACLE_PCTV282E) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK8096GP) },
 	{ USB_DEVICE(USB_VID_ELGATO,    USB_PID_ELGATO_EYETV_DIVERSITY)
},
-	{ 0 }		/* Terminating entry */
+	{ USB_DEVICE(USB_VID_TECHNISAT,
USB_PID_TECHNISAT_AIRSTAR_TELESTICK_2) },
+{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
 
@@ -2606,7 +2638,7 @@
 			},
 		},
 
-		.num_device_descs = 2,
+		.num_device_descs = 3,
 		.devices = {
 			{   "DiBcom STK7770P reference design",
 				{ &dib0700_usb_id_table[59], NULL },
@@ -2618,6 +2650,10 @@
 					&dib0700_usb_id_table[60],
NULL},
 				{ NULL },
 			},
+			{   "TechniSat AirStar TeleStick 2",
+				{ &dib0700_usb_id_table[69], NULL },
+				{ NULL },
+			},
 		},
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = ir_codes_dib0700_table,


---

I hope this stuff corresponds to your expectation.

Best greetings,

  veit berwig


-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Sichern Sie Ihre Mitteilungen mit GnuPG und GPGSX !
Comment: ===================================================

mQGiBElHwnIRBAChSjFMtb+tdsfNPPC8UnP+9PR9TPAoRWVHJ2U1zk8i37fssfhD
fFMUinCcfmErdk8aCnFlJTcdj5rtzHpV+qwZ8eI06uuLlKN9nnyhpErrGgE26eS7
YvZIcymVdOo4gHggNanfuQxa9OCGsVLAbLuOkrnF/fP2+12PZhXw/wVgywCgv1HB
TrrQ8WxLHZiNa3xNleWJvOUD/0HBRqqdb8dV0IQrl78kyQqe2f1ZEQs097hyL2wg
2nBVT6VUF+IVNl/m2lxCXfV7a+/+xA9/x1uBlGPkJiO8yxemrqhTGr1vQGoPBI3f
bukYzhAJq0gnRUjXwbCSLjnuRlAT8VkjHhdJ1kfI1gsSe1E0OqapJO/QZlfmi425
Fhg3A/9sF7CMiJokme0ECVDWAobC8JTwG67mZ2KgfeY5PiAQ5cPCF6XBZXOr8Dls
rkJ/rAHrBELH8nBX8Cb+W059FXSMUqlDJdZYejumRpEz5cdbQtquuVWeyQQpj8Xm
97IIR2o226k2oVFEZtpw58PUcdYpwjl1qk5zP6Gi9Mot07XlEbQoVmVpdCBCZXJ3
aWcgPHZlaXQuYmVyd2lnQGZpbWkubGFuZHNoLmRlPohgBBMRAgAgBQJJR8JyAhsj
BgsJCAcDAgQVAggDBBYCAwECHgECF4AACgkQ1yqoDtvs9NnNUgCgkLxdP2EZl+b/
ZpPCvC1tw4vUn1YAn0R4svbplnzrpi6h1fynIqv22NMyuQINBElHwnIQCADbqXtH
fynLNckiwqDnznWY5JNOlacoG+ge53Rk7DmXUv1TH2dLcDsd/UGlIcS43jEUUhLa
6l4vF+uT6hwaXYirhy/leZ90HMDd5xM+bqL+/CUWcrGBF4ig40HKUziXVQOn/9ZY
4FJChDyAZxIaC3xExPOMB8MQ/ijCJe6Z3GPIJU1T/GHuhC3okU0q4Bor6wHjgwNs
ZRNSzHogNnIgTa566aKhnD1++QS2pb8NFn5Ok6VWIEJEg8HJz9Ak0WSjQ0H6fb/u
mW+iOu4DO1nIPYUAbYGAo6gSEWJFQwwwIeopm5hW7HsgL3ZwzU5ku6cTpy5/CH5u
XYe1Pt2tCfbFSGEPAAURB/9xf65FGfggJTjiBqk4XDA4vAj8VBNFz1McySpIORMq
xAB3R00e5j4albVTKEhxcdSzB5go1ldkaHpG8d2rPpalpp05IfWXDl3OTl9uyapt
O3iMw7OzmWkOC2VCfftEI8NQsHK6Sux3CoQaZ2YD48EnPFWfBAfxIxmP223U4naz
Z+2AZdEEdnyizXmJQ5UiqX8DUCewhTdXvUEmfFL42fnljbTio7EDrUj8l7BJAESb
uY9aUl3x13+a4yvnAb898sxwX4sUwa1n0nv1de+vM8grsykxXjqOJW8/t+HIA8+f
DibtHhS0aUDh16n7fkboiBDC8MxvPMnJAG8qX5QhlNediEkEGBECAAkFAklHwnIC
GwwACgkQ1yqoDtvs9Nn35ACdHQukq/1buapWoCR3TqykOemaF+gAnRz8cKJzqUd3
A4kJcW4v2VCN9hsy
=CW0b
-----END PGP PUBLIC KEY BLOCK-----

