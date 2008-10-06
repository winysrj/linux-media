Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@graeber-clan.de>) id 1KmxK0-0006XP-2Q
	for linux-dvb@linuxtv.org; Mon, 06 Oct 2008 23:08:52 +0200
Received: from wega.graeber.private (i53872A6B.versanet.de [83.135.42.107])
	by post.webmailer.de (mrclete mo63) (RZmta 17.10)
	with EDH-RSA-DES-CBC3-SHA encrypted ESMTP id 205bcck96KCgXu
	for <linux-dvb@linuxtv.org>; Mon, 6 Oct 2008 23:08:48 +0200 (MEST)
	(envelope-from: <lists@graeber-clan.de>)
Received: from localhost (localhost [127.0.0.1])
	by wega.graeber.private (Postfix) with ESMTP id D9A4064002
	for <linux-dvb@linuxtv.org>; Mon,  6 Oct 2008 23:08:47 +0200 (CEST)
Received: from wega.graeber.private ([127.0.0.1])
	by localhost (wega.graeber.private [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id JYPyMctMpcMm for <linux-dvb@linuxtv.org>;
	Mon,  6 Oct 2008 23:08:45 +0200 (CEST)
Received: from sirius.localnet (sirius.local [192.168.42.2])
	by wega.graeber.private (Postfix) with ESMTPS id 240D964001
	for <linux-dvb@linuxtv.org>; Mon,  6 Oct 2008 23:08:44 +0200 (CEST)
From: Herbert Graeber <lists@graeber-clan.de>
To: linux-dvb@linuxtv.org
Date: Mon, 6 Oct 2008 23:08:33 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_U5n6IAM6ykz+6q0"
Message-Id: <200810062308.36231.lists@graeber-clan.de>
Subject: [linux-dvb] [PATCH]Add USB ID for MSI DIGIVOX mini III
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

--Boundary-00=_U5n6IAM6ykz+6q0
Content-Type: multipart/alternative;
  boundary="Boundary-00=_U5n6IpSCfE65ze2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-00=_U5n6IpSCfE65ze2
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch adds the USB ID for the MSI Digi VOX mini III DVB-T Stick.

--Boundary-00=_U5n6IpSCfE65ze2
Content-Type: text/html;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">
<html><head><meta name="qrichtext" content="1" /><style type="text/css">
p, li { white-space: pre-wrap; }
</style></head><body style=" font-family:'DejaVu Sans'; font-size:10pt; font-weight:400; font-style:normal;">
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">This patch adds the USB ID for the MSI Digi VOX mini III DVB-T Stick.</p></body></html>
--Boundary-00=_U5n6IpSCfE65ze2--

--Boundary-00=_U5n6IAM6ykz+6q0
Content-Type: text/x-patch;
  charset="us-ascii";
  name="msi-digi-vox-mini-iii.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="msi-digi-vox-mini-iii.patch"

Add USB ID for MSI DIGIVOX mini III

From: Herbert Graeber <herbert@graeber-clan.de>

Add USB ID for MSI DIGIVOX mini III to af9015.c

Signed-off-by: Herbert Graeber <herbert@graeber-clan.de>

diff -r e9329da68ceb linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Fri Sep 26 17:40:53 2008 +0300
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Mon Oct 06 22:41:01 2008 +0200
@@ -1196,6 +1196,7 @@
 	{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_X_2)},
 	{USB_DEVICE(USB_VID_TELESTAR,  USB_PID_TELESTAR_STARSTICK_2)},
 	{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A309)},
+/* 15 */{USB_DEVICE(USB_VID_MSI_2,     USB_PID_MSI_DIGI_VOX_MINI_III)},
 	{0},
 };
 MODULE_DEVICE_TABLE(usb, af9015_usb_table);
@@ -1346,7 +1347,7 @@
 
 		.i2c_algo = &af9015_i2c_algo,
 
-		.num_device_descs = 5,
+		.num_device_descs = 6,
 		.devices = {
 			{
 				.name = "Xtensions XD-380",
@@ -1371,6 +1372,11 @@
 			{
 				.name = "AVerMedia A309",
 				.cold_ids = {&af9015_usb_table[14], NULL},
+				.warm_ids = {NULL},
+			},
+			{
+				.name = "MSI Digi VOX mini III",
+				.cold_ids = {&af9015_usb_table[15], NULL},
 				.warm_ids = {NULL},
 			},
 		}
diff -r e9329da68ceb linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Fri Sep 26 17:40:53 2008 +0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Mon Oct 06 22:41:01 2008 +0200
@@ -227,5 +227,6 @@
 #define USB_PID_DW2102					0x2102
 #define USB_PID_XTENSIONS_XD_380			0x0381
 #define USB_PID_TELESTAR_STARSTICK_2			0x8000
+#define USB_PID_MSI_DIGI_VOX_MINI_III                   0x8807
 
 #endif

--Boundary-00=_U5n6IAM6ykz+6q0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_U5n6IAM6ykz+6q0--
