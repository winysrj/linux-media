Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound.smtp.vt.edu ([198.82.183.121]:35978 "EHLO
	omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752722AbbGOXBc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jul 2015 19:01:32 -0400
To: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
cc: contact@demhlyr.de, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ov519.c - allow setting i2c_detect_tries
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 15 Jul 2015 18:51:53 -0400
Message-ID: <43010.1437000713@turing-police.cc.vt.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I encountered a user who was having troubles getting a PlayStation EyeToy
(USB ID 054c:0155) working as a webcam. They reported that repeated attempts
would often make it work.  Looking at the code, there was support for
repeated attempts at I2C transactions - but only if you rebuilt the
module from source.

Added module parameter support so that users running a distro kernel
can tune it for recalcitrant devices.

While we're at it, fix the comment to reflect the error message actually issued.

Testing:

[/usr/src/linux-next] insmod drivers/media/usb/gspca/gspca_ov519.ko
[/usr/src/linux-next] cat /sys/module/gspca_ov519/parameters/i2c_detect_tries
10
[/usr/src/linux-next] rmmod gspca_ov519
[/usr/src/linux-next] insmod drivers/media/usb/gspca/gspca_ov519.ko i2c_detect_tries=50
[/usr/src/linux-next] cat /sys/module/gspca_ov519/parameters/i2c_detect_tries
50
[/usr/src/linux-next] modinfo drivers/media/usb/gspca/gspca_ov519.ko | grep parm
parm:           i2c_detect_tries:Number of times to try to init I2C (default 10) (int)
parm:           frame_rate:Frame rate (5, 10, 15, 20 or 30 fps) (int)

Reported-By: Demhlyr <contact@demhlyr.de>
Signed-Off-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- a/drivers/media/usb/gspca/ov519.c	2014-10-21 10:06:09.359806243 -0400
+++ b/drivers/media/usb/gspca/ov519.c	2015-07-15 18:35:21.063790541 -0400
@@ -57,8 +57,10 @@ MODULE_LICENSE("GPL");
 static int frame_rate;
 
 /* Number of times to retry a failed I2C transaction. Increase this if you
- * are getting "Failed to read sensor ID..." */
+ * are getting "Can't determine sensor slave IDs" */
 static int i2c_detect_tries = 10;
+module_param(i2c_detect_tries, int, 0644);
+MODULE_PARM_DESC(i2c_detect_tries,"Number of times to try to init I2C (default 10)");
 
 /* ov519 device descriptor */
 struct sd {

