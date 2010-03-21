Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:43302 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab0CULXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Mar 2010 07:23:50 -0400
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 9742F794407
	for <linux-media@vger.kernel.org>; Sun, 21 Mar 2010 12:15:34 +0100 (CET)
Message-ID: <4BA5FFA5.7030800@free.fr>
Date: Sun, 21 Mar 2010 12:14:45 +0100
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9015 : more robust eeprom parsing
Content-Type: multipart/mixed;
 boundary="------------050809010503070309040100"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050809010503070309040100
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

the af9015 eeprom parsing accept 0x38 as 2nd demodulator. But this is impossible because the
first one is already hardcoded to 0x38.
This remove a special case for AverMedia AVerTV Volar Black HD.

Also in af9015_copy_firmware don't hardcode the 2nd demodulator address to 0x3a.


Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr> 

--------------050809010503070309040100
Content-Type: text/x-diff;
 name="af9015.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="af9015.diff"

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index d797538..f93767e 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -493,7 +493,7 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 	/* wait 2nd demodulator ready */
 	msleep(100);
 
-	ret = af9015_read_reg_i2c(d, 0x3a, 0x98be, &val);
+	ret = af9015_read_reg_i2c(d, af9015_af9013_config[1].demod_address, 0x98be, &val);
 	if (ret)
 		goto error;
 	else
@@ -913,8 +913,13 @@ static int af9015_read_config(struct usb_device *udev)
 		ret = af9015_rw_udev(udev, &req);
 		if (ret)
 			goto error;
-		af9015_af9013_config[1].demod_address = val;
+		if (val != AF9015_I2C_DEMOD)
+			af9015_af9013_config[1].demod_address = val;
+		else 
+			af9015_config.dual_mode = 0;
+	}
 
+	if (af9015_config.dual_mode) {
 		/* enable 2nd adapter */
 		for (i = 0; i < af9015_properties_count; i++)
 			af9015_properties[i].num_adapters = 2;
@@ -1023,11 +1028,6 @@ error:
 	if (le16_to_cpu(udev->descriptor.idVendor) == USB_VID_AVERMEDIA &&
 	    le16_to_cpu(udev->descriptor.idProduct) == USB_PID_AVERMEDIA_A850) {
 		deb_info("%s: AverMedia A850: overriding config\n", __func__);
-		/* disable dual mode */
-		af9015_config.dual_mode = 0;
-		 /* disable 2nd adapter */
-		for (i = 0; i < af9015_properties_count; i++)
-			af9015_properties[i].num_adapters = 1;
 
 		/* set correct IF */
 		af9015_af9013_config[0].tuner_if = 4570;

--------------050809010503070309040100--
