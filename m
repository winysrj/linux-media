Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45847 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbcGRB4a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 26/36] [media] doc-rst: add documentation for saa7134
Date: Sun, 17 Jul 2016 22:56:09 -0300
Message-Id: <ae9d2873a8aae5df64608228175fdf921c35786f.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert it to ReST and add to the media/v4l-device book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst   |  1 +
 Documentation/media/v4l-drivers/saa7134.rst | 43 +++++++++++++----------------
 2 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 03d07f25c5fb..f761627d3fa1 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -33,4 +33,5 @@ License".
 	pvrusb2
 	pxa_camera
 	radiotrack
+	saa7134
 	zr364xx
diff --git a/Documentation/media/v4l-drivers/saa7134.rst b/Documentation/media/v4l-drivers/saa7134.rst
index b911f0871874..584caf8a3594 100644
--- a/Documentation/media/v4l-drivers/saa7134.rst
+++ b/Documentation/media/v4l-drivers/saa7134.rst
@@ -1,7 +1,8 @@
+The saa7134 driver
+==================
 
+Author Gerd Hoffmann
 
-What is it?
-===========
 
 This is a v4l2/oss device driver for saa7130/33/34/35 based capture / TV
 boards.  See http://www.semiconductors.philips.com/pip/saa7134hl for a
@@ -9,7 +10,7 @@ description.
 
 
 Status
-======
+------
 
 Almost everything is working.  video, sound, tuner, radio, mpeg ts, ...
 
@@ -19,12 +20,14 @@ configuration info.
 
 
 Build
-=====
+-----
 
 Pick up videodev + v4l2 patches from http://bytesex.org/patches/.
 Configure, build, install + boot the new kernel.  You'll need at least
 these config options:
 
+.. code-block:: none
+
 	CONFIG_I2C=m
 	CONFIG_VIDEO_DEV=m
 
@@ -35,7 +38,7 @@ valid choices.
 
 
 Changes / Fixes
-===============
+---------------
 
 Please mail me unified diffs ("diff -u") with your changes, and don't
 forget to tell me what it changes / which problem it fixes / whatever
@@ -43,40 +46,32 @@ it is good for ...
 
 
 Known Problems
-==============
+--------------
 
 * The tuner for the flyvideos isn't detected automatically and the
   default might not work for you depending on which version you have.
   There is a tuner= insmod option to override the driver's default.
 
 Card Variations:
-================
+----------------
 
 Cards can use either of these two crystals (xtal):
- - 32.11 MHz -> .audio_clock=0x187de7
- - 24.576MHz -> .audio_clock=0x200000
-(xtal * .audio_clock = 51539600)
+
+- 32.11 MHz -> .audio_clock=0x187de7
+- 24.576MHz -> .audio_clock=0x200000 (xtal * .audio_clock = 51539600)
 
 Some details about 30/34/35:
 
- - saa7130 - low-price chip, doesn't have mute, that is why all those
- cards should have .mute field defined in their tuner structure.
+- saa7130 - low-price chip, doesn't have mute, that is why all those
+  cards should have .mute field defined in their tuner structure.
 
- - saa7134 - usual chip
+- saa7134 - usual chip
 
- - saa7133/35 - saa7135 is probably a marketing decision, since all those
- chips identifies itself as 33 on pci.
+- saa7133/35 - saa7135 is probably a marketing decision, since all those
+  chips identifies itself as 33 on pci.
 
 Credits
-=======
+-------
 
 andrew.stevens@philips.com + werner.leeb@philips.com for providing
 saa7134 hardware specs and sample board.
-
-
-Have fun,
-
-  Gerd
-
---
-Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
-- 
2.7.4

