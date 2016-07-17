Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbcGQRHQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 13:07:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 13/15] [media] doc-rst: convert ttusb-dev to rst
Date: Sun, 17 Jul 2016 14:07:08 -0300
Message-Id: <d91b11bfdb6dd83f4cd0538a9af65276b9b77ace.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some things that needed to be done to convert
it to ReST. Also, there are some obsolete info there
related to Kernels 2.4 and 2.6. Update them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dvb-drivers/index.rst     |  1 +
 Documentation/media/dvb-drivers/ttusb-dec.rst | 46 +++++++++++++--------------
 2 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index 7db298f3c6ce..dbc41950d328 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -28,4 +28,5 @@ License".
 	lmedm04
 	opera-firmware
 	technisat
+	ttusb-dec
 	contributors
diff --git a/Documentation/media/dvb-drivers/ttusb-dec.rst b/Documentation/media/dvb-drivers/ttusb-dec.rst
index b2f271cd784b..84fc2199dc29 100644
--- a/Documentation/media/dvb-drivers/ttusb-dec.rst
+++ b/Documentation/media/dvb-drivers/ttusb-dec.rst
@@ -5,41 +5,39 @@ Driver Status
 -------------
 
 Supported:
-	DEC2000-t
-	DEC2450-t
-	DEC3000-s
-	Linux Kernels 2.4 and 2.6
-	Video Streaming
-	Audio Streaming
-	Section Filters
-	Channel Zapping
-	Hotplug firmware loader under 2.6 kernels
+
+	- DEC2000-t
+	- DEC2450-t
+	- DEC3000-s
+	- Video Streaming
+	- Audio Streaming
+	- Section Filters
+	- Channel Zapping
+	- Hotplug firmware loader
 
 To Do:
-	Tuner status information
-	DVB network interface
-	Streaming video PC->DEC
-	Conax support for 2450-t
+
+	- Tuner status information
+	- DVB network interface
+	- Streaming video PC->DEC
+	- Conax support for 2450-t
 
 Getting the Firmware
 --------------------
 To download the firmware, use the following commands:
-"get_dvb_firmware dec2000t"
-"get_dvb_firmware dec2540t"
-"get_dvb_firmware dec3000s"
 
+.. code-block:: none
 
-Compilation Notes for 2.4 kernels
----------------------------------
-For 2.4 kernels the firmware for the DECs is compiled into the driver itself.
+	scripts/get_dvb_firmware dec2000t
+	scripts/get_dvb_firmware dec2540t
+	scripts/get_dvb_firmware dec3000s
 
-Copy the three files downloaded above into the build-2.4 directory.
 
+Hotplug Firmware Loading
+------------------------
 
-Hotplug Firmware Loading for 2.6 kernels
-----------------------------------------
-For 2.6 kernels the firmware is loaded at the point that the driver module is
-loaded.  See linux/Documentation/dvb/firmware.txt for more information.
+Since 2.6 kernels, the firmware is loaded at the point that the driver module
+is loaded.
 
 Copy the three files downloaded above into the /usr/lib/hotplug/firmware or
 /lib/firmware directory (depending on configuration of firmware hotplug).
-- 
2.7.4

