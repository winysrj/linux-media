Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45860 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbcGRB4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 13/36] [media] doc-rst: add Zoran zr364xx documentation
Date: Sun, 17 Jul 2016 22:55:56 -0300
Message-Id: <f3d295c5e28803555329f652c94fe9657c6af016.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the documentation to rst and add it to the book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst   |  1 +
 Documentation/media/v4l-drivers/zr364xx.rst | 89 +++++++++++++++++++++--------
 2 files changed, 65 insertions(+), 25 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 72a96206fcf8..264ff5cf85f4 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -21,3 +21,4 @@ License".
 	fourcc
 	cardlist
 	cafe_ccic
+	zr364xx
diff --git a/Documentation/media/v4l-drivers/zr364xx.rst b/Documentation/media/v4l-drivers/zr364xx.rst
index d98e4d302977..d8d1171887cd 100644
--- a/Documentation/media/v4l-drivers/zr364xx.rst
+++ b/Documentation/media/v4l-drivers/zr364xx.rst
@@ -1,40 +1,78 @@
-Zoran 364xx based USB webcam module version 0.72
+Zoran 364xx based USB webcam module
+===================================
+
 site: http://royale.zerezo.com/zr364xx/
+
 mail: royale@zerezo.com
 
-introduction:
-This brings support under Linux for the Aiptek PocketDV 3300 in webcam mode.
-If you just want to get on your PC the pictures and movies on the camera, you should use the usb-storage module instead.
-The driver works with several other cameras in webcam mode (see the list below).
-Maybe this code can work for other JPEG/USB cams based on the Coach chips from Zoran?
-Possible chipsets are : ZR36430 (ZR36430BGC) and maybe ZR36431, ZR36440, ZR36442...
-You can try the experience changing the vendor/product ID values (look at the source code).
-You can get these values by looking at /var/log/messages when you plug your camera, or by typing : cat /proc/bus/usb/devices.
-If you manage to use your cam with this code, you can send me a mail (royale@zerezo.com) with the name of your cam and a patch if needed.
-This is a beta release of the driver.
-Since version 0.70, this driver is only compatible with V4L2 API and 2.6.x kernels.
-If you need V4L1 or 2.4x kernels support, please use an older version, but the code is not maintained anymore.
-Good luck!
-
-install:
+.. note:
+
+   This documentation is outdated
+
+Introduction
+------------
+
+
+This brings support under Linux for the Aiptek PocketDV 3300 in webcam
+mode. If you just want to get on your PC the pictures and movies on the
+camera, you should use the usb-storage module instead.
+
+The driver works with several other cameras in webcam mode (see the list
+below).
+
+Maybe this code can work for other JPEG/USB cams based on the Coach
+chips from Zoran?
+
+Possible chipsets are : ZR36430 (ZR36430BGC) and
+maybe ZR36431, ZR36440, ZR36442...
+
+You can try the experience changing the vendor/product ID values (look
+at the source code).
+
+You can get these values by looking at /var/log/messages when you plug
+your camera, or by typing : cat /proc/bus/usb/devices.
+
+If you manage to use your cam with this code, you can send me a mail
+(royale@zerezo.com) with the name of your cam and a patch if needed.
+
+This is a beta release of the driver. Since version 0.70, this driver is
+only compatible with V4L2 API and 2.6.x kernels. If you need V4L1 or
+2.4x kernels support, please use an older version, but the code is not
+maintained anymore. Good luck!
+
+Install
+-------
+
 In order to use this driver, you must compile it with your kernel.
+
 Location: Device Drivers -> Multimedia devices -> Video For Linux -> Video Capture Adapters -> V4L USB devices
 
-usage:
+Usage
+-----
+
 modprobe zr364xx debug=X mode=Y
- - debug      : set to 1 to enable verbose debug messages
- - mode       : 0 = 320x240, 1 = 160x120, 2 = 640x480
-You can then use the camera with V4L2 compatible applications, for example Ekiga.
-To capture a single image, try this: dd if=/dev/video0 of=test.jpg bs=1M count=1
 
-links :
+- debug      : set to 1 to enable verbose debug messages
+- mode       : 0 = 320x240, 1 = 160x120, 2 = 640x480
+
+You can then use the camera with V4L2 compatible applications, for
+example Ekiga.
+
+To capture a single image, try this: dd if=/dev/video0 of=test.jpg bs=1M
+count=1
+
+links
+-----
+
 http://mxhaard.free.fr/ (support for many others cams including some Aiptek PocketDV)
 http://www.harmwal.nl/pccam880/ (this project also supports cameras based on this chipset)
 
-supported devices:
-------  -------  -----------     -----
+Supported devices
+-----------------
+
+======  =======  ==============  ====================
 Vendor  Product  Distributor     Model
-------  -------  -----------     -----
+======  =======  ==============  ====================
 0x08ca  0x0109   Aiptek          PocketDV 3300
 0x08ca  0x0109   Maxell          Maxcam PRO DV3
 0x041e  0x4024   Creative        PC-CAM 880
@@ -67,3 +105,4 @@ Vendor  Product  Distributor     Model
 0x041e  0x405d   Creative        DiVi CAM 516
 0x08ca  0x2102   Aiptek          DV T300
 0x06d6  0x003d   Trust           Powerc@m 910Z
+======  =======  ==============  ====================
-- 
2.7.4

