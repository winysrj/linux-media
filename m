Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45876 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbcGRB4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 25/36] [media] doc-rst: add documentation for radiotrack
Date: Sun, 17 Jul 2016 22:56:08 -0300
Message-Id: <6286d2b185812053cb9144cd765ed40b2393978f.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert it to ReST and add it to the media/v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst      |   1 +
 Documentation/media/v4l-drivers/radiotrack.rst | 179 ++++++++++++++-----------
 2 files changed, 100 insertions(+), 80 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index eb0ed669545e..03d07f25c5fb 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -32,4 +32,5 @@ License".
 	omap4_camera
 	pvrusb2
 	pxa_camera
+	radiotrack
 	zr364xx
diff --git a/Documentation/media/v4l-drivers/radiotrack.rst b/Documentation/media/v4l-drivers/radiotrack.rst
index d1f3ed199186..2f6325ebfd16 100644
--- a/Documentation/media/v4l-drivers/radiotrack.rst
+++ b/Documentation/media/v4l-drivers/radiotrack.rst
@@ -1,11 +1,13 @@
-NOTES ON RADIOTRACK CARD CONTROL
-by Stephen M. Benoit (benoits@servicepro.com)  Dec 14, 1996
-----------------------------------------------------------------------------
+The Radiotrack radio driver
+===========================
 
-Document version 1.0
+Author: Stephen M. Benoit <benoits@servicepro.com>
+
+Date:  Dec 14, 1996
 
 ACKNOWLEDGMENTS
 ----------------
+
 This document was made based on 'C' code for Linux from Gideon le Grange
 (legrang@active.co.za or legrang@cs.sun.ac.za) in 1994, and elaborations from
 Frans Brinkman (brinkman@esd.nl) in 1996.  The results reported here are from
@@ -18,6 +20,7 @@ want to use the RadioTrack card in an environment other than MS Windows.
 
 WHY THIS DOCUMENT?
 ------------------
+
 I have a RadioTrack card from back when I ran an MS-Windows platform.  After
 converting to Linux, I found Gideon le Grange's command-line software for
 running the card, and found that it was good!  Frans Brinkman made a
@@ -33,6 +36,7 @@ So, without further delay, here are the details.
 
 PHYSICAL DESCRIPTION
 --------------------
+
 The RadioTrack card is an ISA 8-bit FM radio card.  The radio frequency (RF)
 input is simply an antenna lead, and the output is a power audio signal
 available through a miniature phone plug.  Its RF frequencies of operation are
@@ -46,6 +50,7 @@ gets clipped beyond the limits mentioned above.
 
 CONTROLLING THE CARD WITH IOPORT
 --------------------------------
+
 The RadioTrack (base) ioport is configurable for 0x30c or 0x20c.  Only one
 ioport seems to be involved.  The ioport decoding circuitry must be pretty
 simple, as individual ioport bits are directly matched to specific functions
@@ -55,93 +60,107 @@ the ioports appears to be the "Stereo Detect" bit.
 
 The bits of the ioport are arranged as follows:
 
-  MSb                                                         LSb
-+------+------+------+--------+--------+-------+---------+--------+
-| VolA | VolB | ???? | Stereo | Radio  | TuneA | TuneB   | Tune   |
-|  (+) |  (-) |      | Detect | Audio  | (bit) | (latch) | Update |
-|      |      |      | Enable | Enable |       |         | Enable |
-+------+------+------+--------+--------+-------+---------+--------+
+.. code-block:: none
 
+	MSb                                                         LSb
+	+------+------+------+--------+--------+-------+---------+--------+
+	| VolA | VolB | ???? | Stereo | Radio  | TuneA | TuneB   | Tune   |
+	|  (+) |  (-) |      | Detect | Audio  | (bit) | (latch) | Update |
+	|      |      |      | Enable | Enable |       |         | Enable |
+	+------+------+------+--------+--------+-------+---------+--------+
 
-VolA . VolB  [AB......]
------------
-0 0 : audio mute
-0 1 : volume +    (some delay required)
-1 0 : volume -    (some delay required)
-1 1 : stay at present volume
 
-Stereo Detect Enable [...S....]
---------------------
-0 : No Detect
-1 : Detect
+====  ====  =================================
+VolA  VolB  Description
+====  ====  =================================
+0	 0  audio mute
+0	 1  volume +    (some delay required)
+1	 0  volume -    (some delay required)
+1	 1  stay at present volume
+====  ====  =================================
+
+====================	===========
+Stereo Detect Enable	Description
+====================	===========
+0			No Detect
+1			Detect
+====================	===========
+
+Results available by reading ioport >60 msec after last port write.
 
-  Results available by reading ioport >60 msec after last port write.
   0xff ==> no stereo detected,  0xfd ==> stereo detected.
 
-Radio to Audio (path) Enable [....R...]
-----------------------------
-0 : Disable path (silence)
-1 : Enable path  (audio produced)
+=============================	=============================
+Radio to Audio (path) Enable	Description
+=============================	=============================
+0				Disable path (silence)
+1				Enable path  (audio produced)
+=============================	=============================
 
-TuneA . TuneB [.....AB.]
--------------
-0 0 : "zero" bit phase 1
-0 1 : "zero" bit phase 2
+=====  =====  ==================
+TuneA  TuneB  Description
+=====  =====  ==================
+0	0     "zero" bit phase 1
+0	1     "zero" bit phase 2
+1	0     "one" bit phase 1
+1	1     "one" bit phase 2
+=====  =====  ==================
 
-1 0 : "one" bit phase 1
-1 1 : "one" bit phase 2
 
-  24-bit code, where bits = (freq*40) + 10486188.
-  The Most Significant 11 bits must be 1010 xxxx 0x0 to be valid.
-  The bits are shifted in LSb first.
+24-bit code, where bits = (freq*40) + 10486188.
+The Most Significant 11 bits must be 1010 xxxx 0x0 to be valid.
+The bits are shifted in LSb first.
 
-Tune Update Enable [.......T]
-------------------
-0 : Tuner held constant
-1 : Tuner updating in progress
+==================	===========================
+Tune Update Enable	Description
+==================	===========================
+0			Tuner held constant
+1			Tuner updating in progress
+==================	===========================
 
 
 PROGRAMMING EXAMPLES
 --------------------
-Default:        BASE <-- 0xc8  (current volume, no stereo detect,
-				radio enable, tuner adjust disable)
-
-Card Off:	BASE <-- 0x00  (audio mute, no stereo detect,
-				radio disable, tuner adjust disable)
-
-Card On:	BASE <-- 0x00  (see "Card Off", clears any unfinished business)
-		BASE <-- 0xc8  (see "Default")
-
-Volume Down:    BASE <-- 0x48  (volume down, no stereo detect,
-				radio enable, tuner adjust disable)
-		* wait 10 msec *
-		BASE <-- 0xc8  (see "Default")
-
-Volume Up:      BASE <-- 0x88  (volume up, no stereo detect,
-				radio enable, tuner adjust disable)
-		* wait 10 msec *
-		BASE <-- 0xc8  (see "Default")
-
-Check Stereo:   BASE <-- 0xd8  (current volume, stereo detect,
-				radio enable, tuner adjust disable)
-		* wait 100 msec *
-		x <-- BASE     (read ioport)
-		BASE <-- 0xc8  (see "Default")
-
-		x=0xff ==> "not stereo", x=0xfd ==> "stereo detected"
-
-Set Frequency:  code = (freq*40) + 10486188
-		foreach of the 24 bits in code,
-		(from Least to Most Significant):
-		  to write a "zero" bit,
-		    BASE <-- 0x01  (audio mute, no stereo detect, radio
-				    disable, "zero" bit phase 1, tuner adjust)
-		    BASE <-- 0x03  (audio mute, no stereo detect, radio
-				    disable, "zero" bit phase 2, tuner adjust)
-		  to write a "one" bit,
-		    BASE <-- 0x05  (audio mute, no stereo detect, radio
-				    disable, "one" bit phase 1, tuner adjust)
-		    BASE <-- 0x07  (audio mute, no stereo detect, radio
-				    disable, "one" bit phase 2, tuner adjust)
-
-----------------------------------------------------------------------------
+
+.. code-block:: none
+
+	Default:        BASE <-- 0xc8  (current volume, no stereo detect,
+					radio enable, tuner adjust disable)
+
+	Card Off:	BASE <-- 0x00  (audio mute, no stereo detect,
+					radio disable, tuner adjust disable)
+
+	Card On:	BASE <-- 0x00  (see "Card Off", clears any unfinished business)
+			BASE <-- 0xc8  (see "Default")
+
+	Volume Down:    BASE <-- 0x48  (volume down, no stereo detect,
+					radio enable, tuner adjust disable)
+			wait 10 msec
+			BASE <-- 0xc8  (see "Default")
+
+	Volume Up:      BASE <-- 0x88  (volume up, no stereo detect,
+					radio enable, tuner adjust disable)
+			wait 10 msec
+			BASE <-- 0xc8  (see "Default")
+
+	Check Stereo:   BASE <-- 0xd8  (current volume, stereo detect,
+					radio enable, tuner adjust disable)
+			wait 100 msec
+			x <-- BASE     (read ioport)
+			BASE <-- 0xc8  (see "Default")
+
+			x=0xff ==> "not stereo", x=0xfd ==> "stereo detected"
+
+	Set Frequency:  code = (freq*40) + 10486188
+			foreach of the 24 bits in code,
+			(from Least to Most Significant):
+			to write a "zero" bit,
+			BASE <-- 0x01  (audio mute, no stereo detect, radio
+					disable, "zero" bit phase 1, tuner adjust)
+			BASE <-- 0x03  (audio mute, no stereo detect, radio
+					disable, "zero" bit phase 2, tuner adjust)
+			to write a "one" bit,
+			BASE <-- 0x05  (audio mute, no stereo detect, radio
+					disable, "one" bit phase 1, tuner adjust)
+			BASE <-- 0x07  (audio mute, no stereo detect, radio
+					disable, "one" bit phase 2, tuner adjust)
-- 
2.7.4

