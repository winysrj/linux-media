Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:56394 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbbLFIZ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Dec 2015 03:25:58 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout0.freenet.de with esmtpa (ID stguenth@freenet.de) (port 25) (Exim 4.85 #1)
	id 1a5UK0-00040W-B5
	for linux-media@vger.kernel.org; Sun, 06 Dec 2015 09:05:28 +0100
Received: from localhost ([::1]:51105 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID stguenth@freenet.de) (Exim 4.85 #1)
	id 1a5UK0-00031f-6u
	for linux-media@vger.kernel.org; Sun, 06 Dec 2015 09:05:28 +0100
Received: from mx3.freenet.de ([195.4.92.13]:36194)
	by mjail0.freenet.de with esmtpa (ID stguenth@freenet.de) (Exim 4.85 #1)
	id 1a5UHp-0006R6-Kb
	for linux-media@vger.kernel.org; Sun, 06 Dec 2015 09:03:13 +0100
Received: from aftr-37-24-144-114.unity-media.net ([37.24.144.114]:13222 helo=[192.168.1.100])
	by mx3.freenet.de with esmtpsa (ID stguenth@freenet.de) (TLSv1.2:DHE-RSA-AES128-SHA:128) (port 587) (Exim 4.85 #1)
	id 1a5UHp-0004tJ-As
	for linux-media@vger.kernel.org; Sun, 06 Dec 2015 09:03:13 +0100
To: linux-media@vger.kernel.org
From: =?UTF-8?Q?Steffen_G=c3=bcnther?= <stguenth@freenet.de>
Subject: Changes in dw2102.c to support my Tevii S662
Message-ID: <5663EBBF.6060504@freenet.de>
Date: Sun, 6 Dec 2015 09:03:11 +0100
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010307040900070401000905"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010307040900070401000905
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I made some small changes on top of this patch

https://patchwork.linuxtv.org/patch/28925/

to support my Tevii S662 with module dvb-usb-dw2102.

Scanning and tuning in works for me.

Hope this is usefull!?

Regards
Steffen

--------------010307040900070401000905
Content-Type: text/x-patch;
 name="tevii_s662-dw2102.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tevii_s662-dw2102.patch"

--- /home/sguenther/Downloads/tv-treiber/drivers/media/usb/dvb-usb/dw2102.c
+++ /home/sguenther/Downloads/media-test-orig/dw2102.c
@@ -1,6 +1,6 @@
 /* DVB USB framework compliant Linux driver for the
  *	DVBWorld DVB-S 2101, 2102, DVB-S2 2104, DVB-C 3101,
- *	TeVii S600, S630, S650, S660, S480, S421, S632
+ *	TeVii S600, S630, S650, S660, S480, S421, S632, S482, S662,
  *	Prof 1100, 7500,
  *	Geniatech SU3000, T220,
  *	TechnoTrend S2-4600 Cards
@@ -1686,6 +1686,7 @@
 	GOTVIEW_SAT_HD,
 	GENIATECH_T220,
 	TECHNOTREND_S2_4600,
+	TEVII_S662,
 	TEVII_S482_1,
 	TEVII_S482_2,
 };
@@ -1713,6 +1714,7 @@
 	[GENIATECH_T220] = {USB_DEVICE(0x1f4d, 0xD220)},
 	[TECHNOTREND_S2_4600] = {USB_DEVICE(USB_VID_TECHNOTREND,
 		USB_PID_TECHNOTREND_CONNECT_S2_4600)},
+	[TEVII_S662] = {USB_DEVICE(0x9022, 0xd662)},
 	[TEVII_S482_1] = {USB_DEVICE(0x9022, 0xd483)},
 	[TEVII_S482_2] = {USB_DEVICE(0x9022, 0xd484)},
 	{ }
@@ -2232,10 +2234,14 @@
 		} },
 		}
 	},
-	.num_device_descs = 3,
+	.num_device_descs = 4,
 	.devices = {
 		{ "TechnoTrend TT-connect S2-4600",
 			{ &dw2102_table[TECHNOTREND_S2_4600], NULL },
+			{ NULL },
+		},
+		{ "TeVii S662",
+			{ &dw2102_table[TEVII_S662], NULL },
 			{ NULL },
 		},
 		{ "TeVii S482 (tuner 1)",
@@ -2359,7 +2365,7 @@
 MODULE_AUTHOR("Igor M. Liplianin (c) liplianin@me.by");
 MODULE_DESCRIPTION("Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104,"
 			" DVB-C 3101 USB2.0,"
-			" TeVii S600, S630, S650, S660, S480, S421, S632"
+			" TeVii S600, S630, S650, S660, S480, S421, S632, S482, S662,"
 			" Prof 1100, 7500 USB2.0,"
 			" Geniatech SU3000, T220,"
 			" TechnoTrend S2-4600 devices");

--------------010307040900070401000905--
