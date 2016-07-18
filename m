Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59560 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbcGRSat (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 14:30:49 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 16/18] [media] get rid of Documentation/video4linux/lifeview.txt
Date: Mon, 18 Jul 2016 15:30:38 -0300
Message-Id: <43efd1edc63534d3a7486a0548c8aedf8b1128d1.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the contents of this file to bttv.rst and saa7134.rst.

With that, we can finally remove Documentation/video4linux.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/bttv.rst    |  8 ++++++
 Documentation/media/v4l-drivers/saa7134.rst | 36 +++++++++++++++++++++++++
 Documentation/video4linux/lifeview.txt      | 42 -----------------------------
 3 files changed, 44 insertions(+), 42 deletions(-)
 delete mode 100644 Documentation/video4linux/lifeview.txt

diff --git a/Documentation/media/v4l-drivers/bttv.rst b/Documentation/media/v4l-drivers/bttv.rst
index 611e8d529f16..f78c135b40e7 100644
--- a/Documentation/media/v4l-drivers/bttv.rst
+++ b/Documentation/media/v4l-drivers/bttv.rst
@@ -782,6 +782,14 @@ FlyVideo A2 (Elta 8680)= LR90 Rev.F (w/Remote, w/o FM, stereo TV by tda9821) {Ge
 
 Lifeview 3000 (Elta 8681) as sold by Plus(April 2002), Germany = LR138 w/ saa7134
 
+lifeview config coding on gpio pins 0-9
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+- LR50 rev. Q ("PARTS: 7031505116), Tuner wurde als Nr. 5 erkannt, Eingänge
+  SVideo, TV, Composite, Audio, Remote:
+
+ - CP9..1=100001001 (1: 0-Ohm-Widerstand gegen GND unbestückt; 0: bestückt)
+
 
 Typhoon TV card series:
 ~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/Documentation/media/v4l-drivers/saa7134.rst b/Documentation/media/v4l-drivers/saa7134.rst
index 584caf8a3594..36b2ee9e0fdc 100644
--- a/Documentation/media/v4l-drivers/saa7134.rst
+++ b/Documentation/media/v4l-drivers/saa7134.rst
@@ -70,6 +70,42 @@ Some details about 30/34/35:
 - saa7133/35 - saa7135 is probably a marketing decision, since all those
   chips identifies itself as 33 on pci.
 
+LifeView GPIOs
+--------------
+
+This section was authored by: Peter Missel <peter.missel@onlinehome.de>
+
+- LifeView FlyTV Platinum FM (LR214WF)
+
+    - GP27    MDT2005 PB4 pin 10
+    - GP26    MDT2005 PB3 pin 9
+    - GP25    MDT2005 PB2 pin 8
+    - GP23    MDT2005 PB1 pin 7
+    - GP22    MDT2005 PB0 pin 6
+    - GP21    MDT2005 PB5 pin 11
+    - GP20    MDT2005 PB6 pin 12
+    - GP19    MDT2005 PB7 pin 13
+    - nc      MDT2005 PA3 pin 2
+    - Remote  MDT2005 PA2 pin 1
+    - GP18    MDT2005 PA1 pin 18
+    - nc      MDT2005 PA0 pin 17 strap low
+    - GP17    Strap "GP7"=High
+    - GP16    Strap "GP6"=High
+
+	- 0=Radio 1=TV
+	- Drives SA630D ENCH1 and HEF4052 A1 pinsto do FM radio through
+	  SIF input
+
+    - GP15    nc
+    - GP14    nc
+    - GP13    nc
+    - GP12    Strap "GP5" = High
+    - GP11    Strap "GP4" = High
+    - GP10    Strap "GP3" = High
+    - GP09    Strap "GP2" = Low
+    - GP08    Strap "GP1" = Low
+    - GP07.00 nc
+
 Credits
 -------
 
diff --git a/Documentation/video4linux/lifeview.txt b/Documentation/video4linux/lifeview.txt
deleted file mode 100644
index 05f9eb57aac9..000000000000
--- a/Documentation/video4linux/lifeview.txt
+++ /dev/null
@@ -1,42 +0,0 @@
-collecting data about the lifeview models and the config coding on
-gpio pins 0-9 ...
-==================================================================
-
-bt878:
- LR50 rev. Q ("PARTS: 7031505116), Tuner wurde als Nr. 5 erkannt, Eingänge
- SVideo, TV, Composite, Audio, Remote. CP9..1=100001001 (1: 0-Ohm-Widerstand
- gegen GND unbestückt; 0: bestückt)
-
-------------------------------------------------------------------------------
-
-saa7134:
-		/* LifeView FlyTV Platinum FM (LR214WF) */
-		/* "Peter Missel <peter.missel@onlinehome.de> */
-		.name           = "LifeView FlyTV Platinum FM",
-		/*      GP27    MDT2005 PB4 pin 10 */
-		/*      GP26    MDT2005 PB3 pin 9 */
-		/*      GP25    MDT2005 PB2 pin 8 */
-		/*      GP23    MDT2005 PB1 pin 7 */
-		/*      GP22    MDT2005 PB0 pin 6 */
-		/*      GP21    MDT2005 PB5 pin 11 */
-		/*      GP20    MDT2005 PB6 pin 12 */
-		/*      GP19    MDT2005 PB7 pin 13 */
-		/*      nc      MDT2005 PA3 pin 2 */
-		/*      Remote  MDT2005 PA2 pin 1 */
-		/*      GP18    MDT2005 PA1 pin 18 */
-		/*      nc      MDT2005 PA0 pin 17 strap low */
-
-		/*      GP17    Strap "GP7"=High */
-		/*      GP16    Strap "GP6"=High
-				0=Radio 1=TV
-				Drives SA630D ENCH1 and HEF4052 A1 pins
-				to do FM radio through SIF input */
-		/*      GP15    nc */
-		/*      GP14    nc */
-		/*      GP13    nc */
-		/*      GP12    Strap "GP5" = High */
-		/*      GP11    Strap "GP4" = High */
-		/*      GP10    Strap "GP3" = High */
-		/*      GP09    Strap "GP2" = Low */
-		/*      GP08    Strap "GP1" = Low */
-		/*      GP07.00 nc */
-- 
2.7.4


