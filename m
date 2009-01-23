Return-path: <linux-media-owner@vger.kernel.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]:8653 "EHLO
	ctsmtpout1.frontal.correo" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754851AbZAWRqV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 12:46:21 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-media@vger.kernel.org,
	Felipe Morales <felipe.morales.moreno@gmail.com>
Subject: New remote RM-KS for Avermedia Volar-X (af9015)
Date: Fri, 23 Jan 2009 18:46:07 +0100
Cc: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_pJgeJDpKN3AWdrT"
Message-Id: <200901231846.17506.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_pJgeJDpKN3AWdrT
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The new Avermedia Volar-X is shipped with a new remote(RM-KS). The attached 
patch add a new option to the remote parameter of dvb_usb_af9015 for this 
remote.

Signed-off-by: Felipe Morales Moreno <felipe.morales.moreno@gmail>
Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Jose Alberto

--Boundary-00=_pJgeJDpKN3AWdrT
Content-Type: text/x-patch;
  charset="us-ascii";
  name="af9015.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="af9015.diff"

diff -r 2ed72b192848 linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Thu Jan 22 22:20:24 2009 -0600
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Fri Jan 23 16:51:52 2009 +0100
@@ -751,6 +751,16 @@
 				af9015_config.ir_table_size =
 				  ARRAY_SIZE(af9015_ir_table_digittrade);
 				break;
+			case AF9015_REMOTE_AVERMEDIA_KS:
+				af9015_properties[i].rc_key_map =
+				  af9015_rc_keys_avermedia;
+				af9015_properties[i].rc_key_map_size =
+				  ARRAY_SIZE(af9015_rc_keys_avermedia);
+				af9015_config.ir_table =
+				  af9015_ir_table_avermedia_ks;
+				af9015_config.ir_table_size =
+				  ARRAY_SIZE(af9015_ir_table_avermedia_ks);
+				break;
 			}
 		} else {
 			switch (le16_to_cpu(udev->descriptor.idVendor)) {
diff -r 2ed72b192848 linux/drivers/media/dvb/dvb-usb/af9015.h
--- a/linux/drivers/media/dvb/dvb-usb/af9015.h	Thu Jan 22 22:20:24 2009 -0600
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.h	Fri Jan 23 16:51:52 2009 +0100
@@ -124,6 +124,7 @@
 	AF9015_REMOTE_MSI_DIGIVOX_MINI_II_V3,
 	AF9015_REMOTE_MYGICTV_U718,
 	AF9015_REMOTE_DIGITTRADE_DVB_T,
+	AF9015_REMOTE_AVERMEDIA_KS,
 };
 
 /* Leadtek WinFast DTV Dongle Gold */
@@ -597,6 +598,36 @@
 	0x03, 0xfc, 0x03, 0xfc, 0x0e, 0x05, 0x00,
 };
 
+static u8 af9015_ir_table_avermedia_ks[] = {
+	0x05, 0xfa, 0x01, 0xfe, 0x12, 0x05, 0x00, 
+	0x05, 0xfa, 0x02, 0xfd, 0x0e, 0x05, 0x00,
+	0x05, 0xfa, 0x03, 0xfc, 0x0d, 0x05, 0x00, 
+	0x05, 0xfa, 0x04, 0xfb, 0x2e, 0x05, 0x00, 
+	0x05, 0xfa, 0x05, 0xfa, 0x2d, 0x05, 0x00, 
+	0x05, 0xfa, 0x06, 0xf9, 0x10, 0x05, 0x00, 
+	0x05, 0xfa, 0x07, 0xf8, 0x0f, 0x05, 0x00, 
+	0x05, 0xfa, 0x08, 0xf7, 0x3d, 0x05, 0x00, 
+	0x05, 0xfa, 0x09, 0xf6, 0x1e, 0x05, 0x00, 
+	0x05, 0xfa, 0x0a, 0xf5, 0x1f, 0x05, 0x00, 
+	0x05, 0xfa, 0x0b, 0xf4, 0x20, 0x05, 0x00, 
+	0x05, 0xfa, 0x0c, 0xf3, 0x21, 0x05, 0x00, 
+	0x05, 0xfa, 0x0d, 0xf2, 0x22, 0x05, 0x00, 
+	0x05, 0xfa, 0x0e, 0xf1, 0x23, 0x05, 0x00, 
+	0x05, 0xfa, 0x0f, 0xf0, 0x24, 0x05, 0x00, 
+	0x05, 0xfa, 0x10, 0xef, 0x25, 0x05, 0x00, 
+	0x05, 0xfa, 0x11, 0xee, 0x26, 0x05, 0x00, 
+	0x05, 0xfa, 0x12, 0xed, 0x27, 0x05, 0x00, 
+	0x05, 0xfa, 0x13, 0xec, 0x04, 0x05, 0x00, 
+	0x05, 0xfa, 0x15, 0xea, 0x0a, 0x05, 0x00, 
+	0x05, 0xfa, 0x16, 0xe9, 0x11, 0x05, 0x00, 
+	0x05, 0xfa, 0x17, 0xe8, 0x15, 0x05, 0x00, 
+	0x05, 0xfa, 0x18, 0xe7, 0x16, 0x05, 0x00, 
+	0x05, 0xfa, 0x1c, 0xe3, 0x05, 0x05, 0x00, 
+	0x05, 0xfa, 0x1d, 0xe2, 0x09, 0x05, 0x00, 
+	0x05, 0xfa, 0x4d, 0xb2, 0x3f, 0x05, 0x00, 
+	0x05, 0xfa, 0x56, 0xa9, 0x3e, 0x05, 0x00  
+};
+
 /* Digittrade DVB-T USB Stick */
 static struct dvb_usb_rc_key af9015_rc_keys_digittrade[] = {
 	{ 0x01, 0x0f, KEY_LAST },	/* RETURN */

--Boundary-00=_pJgeJDpKN3AWdrT--
