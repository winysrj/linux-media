Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60568 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbcGQRHU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 13:07:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 04/15] [media] doc-rst: convert bt8xx doc to rst
Date: Sun, 17 Jul 2016 14:06:59 -0300
Message-Id: <d61da478b31bdc2e181aaac104bd5b69e26c40f3.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This document almost follows a markup language, but it is
not ReST. Fix it to be handled by Sphinx.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dvb-drivers/bt8xx.rst | 120 ++++++++++++++++++------------
 Documentation/media/dvb-drivers/index.rst |   1 +
 2 files changed, 73 insertions(+), 48 deletions(-)

diff --git a/Documentation/media/dvb-drivers/bt8xx.rst b/Documentation/media/dvb-drivers/bt8xx.rst
index b7b1d1b1da46..b43958b7340c 100644
--- a/Documentation/media/dvb-drivers/bt8xx.rst
+++ b/Documentation/media/dvb-drivers/bt8xx.rst
@@ -1,33 +1,46 @@
 How to get the bt8xx cards working
 ==================================
 
-1) General information
-======================
+Authors: Richard Walker,
+	 Jamie Honan,
+	 Michael Hunold,
+	 Manu Abraham,
+	 Uwe Bugla,
+	 Michael Krufky
+
+.. note::
+
+   This documentation is outdated. Please check at the DVB wiki
+   at https://linuxtv.org/wiki for more updated info.
+
+General information
+-------------------
 
 This class of cards has a bt878a as the PCI interface, and require the bttv driver
 for accessing the i2c bus and the gpio pins of the bt8xx chipset.
 Please see Documentation/dvb/cards.txt => o Cards based on the Conexant Bt8xx PCI bridge:
 
 Compiling kernel please enable:
-a.)"Device drivers" => "Multimedia devices" => "Video For Linux" => "Enable Video for Linux API 1 (DEPRECATED)"
-b.)"Device drivers" => "Multimedia devices" => "Video For Linux" => "Video Capture Adapters" => "BT848 Video For Linux"
-c.)"Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices" => "DVB for Linux" "DVB Core Support" "Bt8xx based PCI Cards"
 
-Please use the following options with care as deselection of drivers which are in fact necessary
-may result in DVB devices that cannot be tuned due to lack of driver support:
-You can save RAM by deselecting every frontend module that your DVB card does not need.
+#) ``Device drivers`` => ``Multimedia devices`` => ``Video For Linux`` => ``Enable Video for Linux API 1 (DEPRECATED)``
+#) ``Device drivers`` => ``Multimedia devices`` => ``Video For Linux`` => ``Video Capture Adapters`` => ``BT848 Video For Linux``
+#) ``Device drivers`` => ``Multimedia devices`` => ``Digital Video Broadcasting Devices`` => ``DVB for Linux`` ``DVB Core Support`` ``Bt8xx based PCI Cards``
 
-First please remove the static dependency of DVB card drivers on all frontend modules for all possible card variants by enabling:
-d.) "Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices"
- => "DVB for Linux" "DVB Core Support" "Load and attach frontend modules as needed"
+  Please use the following options with care as deselection of drivers which are in fact necessary may result in DVB devices that cannot be tuned due to lack of driver support:
+  You can save RAM by deselecting every frontend module that your DVB card does not need.
+
+  First please remove the static dependency of DVB card drivers on all frontend modules for all possible card variants by enabling:
+
+#) ``Device drivers`` => ``Multimedia devices`` => ``Digital Video Broadcasting Devices`` => ``DVB for Linux`` ``DVB Core Support`` ``Load and attach frontend modules as needed``
+
+  If you know the frontend driver that your card needs please enable:
+
+#) ``Device drivers`` => ``Multimedia devices`` => ``Digital Video Broadcasting Devices`` => ``DVB for Linux`` ``DVB Core Support`` ``Customise DVB Frontends`` => ``Customise the frontend modules to build``
 
-If you know the frontend driver that your card needs please enable:
-e.)"Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices"
- => "DVB for Linux" "DVB Core Support" "Customise DVB Frontends" => "Customise the frontend modules to build"
  Then please select your card-specific frontend module.
 
-2) Loading Modules
-==================
+Loading Modules
+---------------
 
 Regular case: If the bttv driver detects a bt8xx-based DVB card, all frontend and backend modules will be loaded automatically.
 Exceptions are:
@@ -36,63 +49,74 @@ People running udev please see Documentation/dvb/udev.txt.
 
 In the following cases overriding the PCI type detection for dvb-bt8xx might be necessary:
 
-2a) Running TwinHan and Clones
-------------------------------
+Running TwinHan and Clones
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+.. code-block:: none
 
 	$ modprobe bttv card=113
 	$ modprobe dst
 
 Useful parameters for verbosity level and debugging the dst module:
 
-verbose=0:		messages are disabled
-	1:		only error messages are displayed
-	2:		notifications are displayed
-	3:		other useful messages are displayed
-	4:		debug setting
-dst_addons=0:		card is a free to air (FTA) card only
-	   0x20:	card has a conditional access slot for scrambled channels
+.. code-block:: none
+
+	verbose=0:		messages are disabled
+		1:		only error messages are displayed
+		2:		notifications are displayed
+		3:		other useful messages are displayed
+		4:		debug setting
+	dst_addons=0:		card is a free to air (FTA) card only
+		0x20:	card has a conditional access slot for scrambled channels
 
 The autodetected values are determined by the cards' "response string".
 In your logs see f. ex.: dst_get_device_id: Recognize [DSTMCI].
 For bug reports please send in a complete log with verbose=4 activated.
 Please also see Documentation/dvb/ci.txt.
 
-2b) Running multiple cards
---------------------------
+Running multiple cards
+~~~~~~~~~~~~~~~~~~~~~~
 
 Examples of card ID's:
 
-Pinnacle PCTV Sat:		 94
-Nebula Electronics Digi TV:	104
-pcHDTV HD-2000 TV:		112
-Twinhan DST and clones:		113
-Avermedia AverTV DVB-T 771:	123
-Avermedia AverTV DVB-T 761:	124
-DViCO FusionHDTV DVB-T Lite:	128
-DViCO FusionHDTV 5 Lite:	135
-
-Notice: The order of the card ID should be uprising:
-Example:
+.. code-block:: none
+
+	Pinnacle PCTV Sat:		 94
+	Nebula Electronics Digi TV:	104
+	pcHDTV HD-2000 TV:		112
+	Twinhan DST and clones:		113
+	Avermedia AverTV DVB-T 771:	123
+	Avermedia AverTV DVB-T 761:	124
+	DViCO FusionHDTV DVB-T Lite:	128
+	DViCO FusionHDTV 5 Lite:	135
+
+.. note::
+
+   The order of the card ID should be uprising:
+
+   Example:
+
+   .. code-block:: none
+
 	$ modprobe bttv card=113 card=135
 
 For a full list of card ID's please see Documentation/video4linux/CARDLIST.bttv.
 In case of further problems please subscribe and send questions to the mailing list: linux-dvb@linuxtv.org.
 
-2c) Probing the cards with broken PCI subsystem ID
---------------------------------------------------
+Probing the cards with broken PCI subsystem ID
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
 There are some TwinHan cards that the EEPROM has become corrupted for some
 reason. The cards do not have correct PCI subsystem ID. But we can force
 probing the cards with broken PCI subsystem ID
 
+.. code-block:: none
+
 	$ echo 109e 0878 $subvendor $subdevice > \
 		/sys/bus/pci/drivers/bt878/new_id
 
-109e: PCI_VENDOR_ID_BROOKTREE
-0878: PCI_DEVICE_ID_BROOKTREE_878
+.. code-block:: none
+
+	109e: PCI_VENDOR_ID_BROOKTREE
+	0878: PCI_DEVICE_ID_BROOKTREE_878
 
-Authors: Richard Walker,
-	 Jamie Honan,
-	 Michael Hunold,
-	 Manu Abraham,
-	 Uwe Bugla,
-	 Michael Krufky
diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index 2a09e9d22664..bcc29c70a7cc 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -20,3 +20,4 @@ License".
 
 	intro
 	avermedia
+	bt8xx
-- 
2.7.4

