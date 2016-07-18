Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59580 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbcGRSau (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 14:30:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 11/18] [media] cx2341x.rst: add contents of fw-osd-api.txt
Date: Mon, 18 Jul 2016 15:30:33 -0300
Message-Id: <61116fbf20d5bfcf4a83081d05b66947b3a4505d.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert it to ReST format and add to cx2341x.rst file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/cx2341x.rst      | 675 +++++++++++++++++++++++
 Documentation/video4linux/cx2341x/fw-osd-api.txt | 350 ------------
 Documentation/video4linux/cx2341x/fw-upload.txt  |  49 --
 3 files changed, 675 insertions(+), 399 deletions(-)
 delete mode 100644 Documentation/video4linux/cx2341x/fw-osd-api.txt
 delete mode 100644 Documentation/video4linux/cx2341x/fw-upload.txt

diff --git a/Documentation/media/v4l-drivers/cx2341x.rst b/Documentation/media/v4l-drivers/cx2341x.rst
index 0d1bd26623b9..57ae45938919 100644
--- a/Documentation/media/v4l-drivers/cx2341x.rst
+++ b/Documentation/media/v4l-drivers/cx2341x.rst
@@ -280,6 +280,681 @@ an interrupt. Only the 16 Results fields are used, the Flags, Command, Return
 value and Timeout words are not used.
 
 
+OSD firmware API description
+----------------------------
+
+.. note:: this API is part of the decoder firmware, so it's cx23415 only.
+
+
+
+CX2341X_OSD_GET_FRAMEBUFFER
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 65/0x41
+
+Description
+^^^^^^^^^^^
+
+Return base and length of contiguous OSD memory.
+
+Result[0]
+^^^^^^^^^
+
+OSD base address
+
+Result[1]
+^^^^^^^^^
+
+OSD length
+
+
+
+CX2341X_OSD_GET_PIXEL_FORMAT
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 66/0x42
+
+Description
+^^^^^^^^^^^
+
+Query OSD format
+
+Result[0]
+^^^^^^^^^
+
+0=8bit index
+1=16bit RGB 5:6:5
+2=16bit ARGB 1:5:5:5
+3=16bit ARGB 1:4:4:4
+4=32bit ARGB 8:8:8:8
+
+
+
+CX2341X_OSD_SET_PIXEL_FORMAT
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 67/0x43
+
+Description
+^^^^^^^^^^^
+
+Assign pixel format
+
+Param[0]
+^^^^^^^^
+
+- 0=8bit index
+- 1=16bit RGB 5:6:5
+- 2=16bit ARGB 1:5:5:5
+- 3=16bit ARGB 1:4:4:4
+- 4=32bit ARGB 8:8:8:8
+
+
+
+CX2341X_OSD_GET_STATE
+~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 68/0x44
+
+Description
+^^^^^^^^^^^
+
+Query OSD state
+
+Result[0]
+^^^^^^^^^
+
+- Bit  0   0=off, 1=on
+- Bits 1:2 alpha control
+- Bits 3:5 pixel format
+
+
+
+CX2341X_OSD_SET_STATE
+~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 69/0x45
+
+Description
+^^^^^^^^^^^
+
+OSD switch
+
+Param[0]
+^^^^^^^^
+
+0=off, 1=on
+
+
+
+CX2341X_OSD_GET_OSD_COORDS
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 70/0x46
+
+Description
+^^^^^^^^^^^
+
+Retrieve coordinates of OSD area blended with video
+
+Result[0]
+^^^^^^^^^
+
+OSD buffer address
+
+Result[1]
+^^^^^^^^^
+
+Stride in pixels
+
+Result[2]
+^^^^^^^^^
+
+Lines in OSD buffer
+
+Result[3]
+^^^^^^^^^
+
+Horizontal offset in buffer
+
+Result[4]
+^^^^^^^^^
+
+Vertical offset in buffer
+
+
+
+CX2341X_OSD_SET_OSD_COORDS
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 71/0x47
+
+Description
+^^^^^^^^^^^
+
+Assign the coordinates of the OSD area to blend with video
+
+Param[0]
+^^^^^^^^
+
+buffer address
+
+Param[1]
+^^^^^^^^
+
+buffer stride in pixels
+
+Param[2]
+^^^^^^^^
+
+lines in buffer
+
+Param[3]
+^^^^^^^^
+
+horizontal offset
+
+Param[4]
+^^^^^^^^
+
+vertical offset
+
+
+
+CX2341X_OSD_GET_SCREEN_COORDS
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 72/0x48
+
+Description
+^^^^^^^^^^^
+
+Retrieve OSD screen area coordinates
+
+Result[0]
+^^^^^^^^^
+
+top left horizontal offset
+
+Result[1]
+^^^^^^^^^
+
+top left vertical offset
+
+Result[2]
+^^^^^^^^^
+
+bottom right horizontal offset
+
+Result[3]
+^^^^^^^^^
+
+bottom right vertical offset
+
+
+
+CX2341X_OSD_SET_SCREEN_COORDS
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 73/0x49
+
+Description
+^^^^^^^^^^^
+
+Assign the coordinates of the screen area to blend with video
+
+Param[0]
+^^^^^^^^
+
+top left horizontal offset
+
+Param[1]
+^^^^^^^^
+
+top left vertical offset
+
+Param[2]
+^^^^^^^^
+
+bottom left horizontal offset
+
+Param[3]
+^^^^^^^^
+
+bottom left vertical offset
+
+
+
+CX2341X_OSD_GET_GLOBAL_ALPHA
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 74/0x4A
+
+Description
+^^^^^^^^^^^
+
+Retrieve OSD global alpha
+
+Result[0]
+^^^^^^^^^
+
+global alpha: 0=off, 1=on
+
+Result[1]
+^^^^^^^^^
+
+bits 0:7 global alpha
+
+
+
+CX2341X_OSD_SET_GLOBAL_ALPHA
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 75/0x4B
+
+Description
+^^^^^^^^^^^
+
+Update global alpha
+
+Param[0]
+^^^^^^^^
+
+global alpha: 0=off, 1=on
+
+Param[1]
+^^^^^^^^
+
+global alpha (8 bits)
+
+Param[2]
+^^^^^^^^
+
+local alpha: 0=on, 1=off
+
+
+
+CX2341X_OSD_SET_BLEND_COORDS
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 78/0x4C
+
+Description
+^^^^^^^^^^^
+
+Move start of blending area within display buffer
+
+Param[0]
+^^^^^^^^
+
+horizontal offset in buffer
+
+Param[1]
+^^^^^^^^
+
+vertical offset in buffer
+
+
+
+CX2341X_OSD_GET_FLICKER_STATE
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 79/0x4F
+
+Description
+^^^^^^^^^^^
+
+Retrieve flicker reduction module state
+
+Result[0]
+^^^^^^^^^
+
+flicker state: 0=off, 1=on
+
+
+
+CX2341X_OSD_SET_FLICKER_STATE
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 80/0x50
+
+Description
+^^^^^^^^^^^
+
+Set flicker reduction module state
+
+Param[0]
+^^^^^^^^
+
+State: 0=off, 1=on
+
+
+
+CX2341X_OSD_BLT_COPY
+~~~~~~~~~~~~~~~~~~~~
+
+Enum: 82/0x52
+
+Description
+^^^^^^^^^^^
+
+BLT copy
+
+Param[0]
+^^^^^^^^
+
+.. code-block:: none
+
+	'0000'  zero
+	'0001' ~destination AND ~source
+	'0010' ~destination AND  source
+	'0011' ~destination
+	'0100'  destination AND ~source
+	'0101'                  ~source
+	'0110'  destination XOR  source
+	'0111' ~destination OR  ~source
+	'1000' ~destination AND ~source
+	'1001'  destination XNOR source
+	'1010'                   source
+	'1011' ~destination OR   source
+	'1100'  destination
+	'1101'  destination OR  ~source
+	'1110'  destination OR   source
+	'1111'  one
+
+
+Param[1]
+^^^^^^^^
+
+Resulting alpha blending
+
+- '01' source_alpha
+- '10' destination_alpha
+- '11' source_alpha*destination_alpha+1
+  (zero if both source and destination alpha are zero)
+
+Param[2]
+^^^^^^^^
+
+.. code-block:: none
+
+	'00' output_pixel = source_pixel
+
+	'01' if source_alpha=0:
+		 output_pixel = destination_pixel
+	     if 256 > source_alpha > 1:
+		 output_pixel = ((source_alpha + 1)*source_pixel +
+				 (255 - source_alpha)*destination_pixel)/256
+
+	'10' if destination_alpha=0:
+		 output_pixel = source_pixel
+	      if 255 > destination_alpha > 0:
+		 output_pixel = ((255 - destination_alpha)*source_pixel +
+				 (destination_alpha + 1)*destination_pixel)/256
+
+	'11' if source_alpha=0:
+		 source_temp = 0
+	     if source_alpha=255:
+		 source_temp = source_pixel*256
+	     if 255 > source_alpha > 0:
+		 source_temp = source_pixel*(source_alpha + 1)
+	     if destination_alpha=0:
+		 destination_temp = 0
+	     if destination_alpha=255:
+		 destination_temp = destination_pixel*256
+	     if 255 > destination_alpha > 0:
+		 destination_temp = destination_pixel*(destination_alpha + 1)
+	     output_pixel = (source_temp + destination_temp)/256
+
+Param[3]
+^^^^^^^^
+
+width
+
+Param[4]
+^^^^^^^^
+
+height
+
+Param[5]
+^^^^^^^^
+
+destination pixel mask
+
+Param[6]
+^^^^^^^^
+
+destination rectangle start address
+
+Param[7]
+^^^^^^^^
+
+destination stride in dwords
+
+Param[8]
+^^^^^^^^
+
+source stride in dwords
+
+Param[9]
+^^^^^^^^
+
+source rectangle start address
+
+
+
+CX2341X_OSD_BLT_FILL
+~~~~~~~~~~~~~~~~~~~~
+
+Enum: 83/0x53
+
+Description
+^^^^^^^^^^^
+
+BLT fill color
+
+Param[0]
+^^^^^^^^
+
+Same as Param[0] on API 0x52
+
+Param[1]
+^^^^^^^^
+
+Same as Param[1] on API 0x52
+
+Param[2]
+^^^^^^^^
+
+Same as Param[2] on API 0x52
+
+Param[3]
+^^^^^^^^
+
+width
+
+Param[4]
+^^^^^^^^
+
+height
+
+Param[5]
+^^^^^^^^
+
+destination pixel mask
+
+Param[6]
+^^^^^^^^
+
+destination rectangle start address
+
+Param[7]
+^^^^^^^^
+
+destination stride in dwords
+
+Param[8]
+^^^^^^^^
+
+color fill value
+
+
+
+CX2341X_OSD_BLT_TEXT
+~~~~~~~~~~~~~~~~~~~~
+
+Enum: 84/0x54
+
+Description
+^^^^^^^^^^^
+
+BLT for 8 bit alpha text source
+
+Param[0]
+^^^^^^^^
+
+Same as Param[0] on API 0x52
+
+Param[1]
+^^^^^^^^
+
+Same as Param[1] on API 0x52
+
+Param[2]
+^^^^^^^^
+
+Same as Param[2] on API 0x52
+
+Param[3]
+^^^^^^^^
+
+width
+
+Param[4]
+^^^^^^^^
+
+height
+
+Param[5]
+^^^^^^^^
+
+destination pixel mask
+
+Param[6]
+^^^^^^^^
+
+destination rectangle start address
+
+Param[7]
+^^^^^^^^
+
+destination stride in dwords
+
+Param[8]
+^^^^^^^^
+
+source stride in dwords
+
+Param[9]
+^^^^^^^^
+
+source rectangle start address
+
+Param[10]
+^^^^^^^^^
+
+color fill value
+
+
+
+CX2341X_OSD_SET_FRAMEBUFFER_WINDOW
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 86/0x56
+
+Description
+^^^^^^^^^^^
+
+Positions the main output window on the screen. The coordinates must be
+such that the entire window fits on the screen.
+
+Param[0]
+^^^^^^^^
+
+window width
+
+Param[1]
+^^^^^^^^
+
+window height
+
+Param[2]
+^^^^^^^^
+
+top left window corner horizontal offset
+
+Param[3]
+^^^^^^^^
+
+top left window corner vertical offset
+
+
+
+CX2341X_OSD_SET_CHROMA_KEY
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 96/0x60
+
+Description
+^^^^^^^^^^^
+
+Chroma key switch and color
+
+Param[0]
+^^^^^^^^
+
+state: 0=off, 1=on
+
+Param[1]
+^^^^^^^^
+
+color
+
+
+
+CX2341X_OSD_GET_ALPHA_CONTENT_INDEX
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 97/0x61
+
+Description
+^^^^^^^^^^^
+
+Retrieve alpha content index
+
+Result[0]
+^^^^^^^^^
+
+alpha content index, Range 0:15
+
+
+
+CX2341X_OSD_SET_ALPHA_CONTENT_INDEX
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Enum: 98/0x62
+
+Description
+^^^^^^^^^^^
+
+Assign alpha content index
+
+Param[0]
+^^^^^^^^
+
+alpha content index, range 0:15
+
+
 Encoder firmware API description
 --------------------------------
 
diff --git a/Documentation/video4linux/cx2341x/fw-osd-api.txt b/Documentation/video4linux/cx2341x/fw-osd-api.txt
deleted file mode 100644
index 89c4601042c1..000000000000
--- a/Documentation/video4linux/cx2341x/fw-osd-api.txt
+++ /dev/null
@@ -1,350 +0,0 @@
-OSD firmware API description
-============================
-
-Note: this API is part of the decoder firmware, so it's cx23415 only.
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_GET_FRAMEBUFFER
-Enum 	65/0x41
-Description
-	Return base and length of contiguous OSD memory.
-Result[0]
-	OSD base address
-Result[1]
-	OSD length
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_GET_PIXEL_FORMAT
-Enum 	66/0x42
-Description
-	Query OSD format
-Result[0]
-	0=8bit index
-	1=16bit RGB 5:6:5
-	2=16bit ARGB 1:5:5:5
-	3=16bit ARGB 1:4:4:4
-	4=32bit ARGB 8:8:8:8
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_SET_PIXEL_FORMAT
-Enum 	67/0x43
-Description
-	Assign pixel format
-Param[0]
-	0=8bit index
-	1=16bit RGB 5:6:5
-	2=16bit ARGB 1:5:5:5
-	3=16bit ARGB 1:4:4:4
-	4=32bit ARGB 8:8:8:8
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_GET_STATE
-Enum 	68/0x44
-Description
-	Query OSD state
-Result[0]
-	Bit  0   0=off, 1=on
-	Bits 1:2 alpha control
-	Bits 3:5 pixel format
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_SET_STATE
-Enum 	69/0x45
-Description
-	OSD switch
-Param[0]
-	0=off, 1=on
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_GET_OSD_COORDS
-Enum 	70/0x46
-Description
-	Retrieve coordinates of OSD area blended with video
-Result[0]
-	OSD buffer address
-Result[1]
-	Stride in pixels
-Result[2]
-	Lines in OSD buffer
-Result[3]
-	Horizontal offset in buffer
-Result[4]
-	Vertical offset in buffer
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_SET_OSD_COORDS
-Enum 	71/0x47
-Description
-	Assign the coordinates of the OSD area to blend with video
-Param[0]
-	buffer address
-Param[1]
-	buffer stride in pixels
-Param[2]
-	lines in buffer
-Param[3]
-	horizontal offset
-Param[4]
-	vertical offset
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_GET_SCREEN_COORDS
-Enum 	72/0x48
-Description
-	Retrieve OSD screen area coordinates
-Result[0]
-	top left horizontal offset
-Result[1]
-	top left vertical offset
-Result[2]
-	bottom right horizontal offset
-Result[3]
-	bottom right vertical offset
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_SET_SCREEN_COORDS
-Enum 	73/0x49
-Description
-	Assign the coordinates of the screen area to blend with video
-Param[0]
-	top left horizontal offset
-Param[1]
-	top left vertical offset
-Param[2]
-	bottom left horizontal offset
-Param[3]
-	bottom left vertical offset
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_GET_GLOBAL_ALPHA
-Enum 	74/0x4A
-Description
-	Retrieve OSD global alpha
-Result[0]
-	global alpha: 0=off, 1=on
-Result[1]
-	bits 0:7 global alpha
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_SET_GLOBAL_ALPHA
-Enum 	75/0x4B
-Description
-	Update global alpha
-Param[0]
-	global alpha: 0=off, 1=on
-Param[1]
-	global alpha (8 bits)
-Param[2]
-	local alpha: 0=on, 1=off
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_SET_BLEND_COORDS
-Enum 	78/0x4C
-Description
-	Move start of blending area within display buffer
-Param[0]
-	horizontal offset in buffer
-Param[1]
-	vertical offset in buffer
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_GET_FLICKER_STATE
-Enum 	79/0x4F
-Description
-	Retrieve flicker reduction module state
-Result[0]
-	flicker state: 0=off, 1=on
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_SET_FLICKER_STATE
-Enum 	80/0x50
-Description
-	Set flicker reduction module state
-Param[0]
-	State: 0=off, 1=on
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_BLT_COPY
-Enum 	82/0x52
-Description
-	BLT copy
-Param[0]
-'0000'  zero
-'0001' ~destination AND ~source
-'0010' ~destination AND  source
-'0011' ~destination
-'0100'  destination AND ~source
-'0101'                  ~source
-'0110'  destination XOR  source
-'0111' ~destination OR  ~source
-'1000' ~destination AND ~source
-'1001'  destination XNOR source
-'1010'                   source
-'1011' ~destination OR   source
-'1100'  destination
-'1101'  destination OR  ~source
-'1110'  destination OR   source
-'1111'  one
-
-Param[1]
-	Resulting alpha blending
-	    '01' source_alpha
-	    '10' destination_alpha
-	    '11' source_alpha*destination_alpha+1
-		 (zero if both source and destination alpha are zero)
-Param[2]
-	'00' output_pixel = source_pixel
-
-	'01' if source_alpha=0:
-		 output_pixel = destination_pixel
-	     if 256 > source_alpha > 1:
-		 output_pixel = ((source_alpha + 1)*source_pixel +
-				 (255 - source_alpha)*destination_pixel)/256
-
-	'10' if destination_alpha=0:
-		 output_pixel = source_pixel
-	      if 255 > destination_alpha > 0:
-		 output_pixel = ((255 - destination_alpha)*source_pixel +
-				 (destination_alpha + 1)*destination_pixel)/256
-
-	'11' if source_alpha=0:
-		 source_temp = 0
-	     if source_alpha=255:
-		 source_temp = source_pixel*256
-	     if 255 > source_alpha > 0:
-		 source_temp = source_pixel*(source_alpha + 1)
-	     if destination_alpha=0:
-		 destination_temp = 0
-	     if destination_alpha=255:
-		 destination_temp = destination_pixel*256
-	     if 255 > destination_alpha > 0:
-		 destination_temp = destination_pixel*(destination_alpha + 1)
-	     output_pixel = (source_temp + destination_temp)/256
-Param[3]
-	width
-Param[4]
-	height
-Param[5]
-	destination pixel mask
-Param[6]
-	destination rectangle start address
-Param[7]
-	destination stride in dwords
-Param[8]
-	source stride in dwords
-Param[9]
-	source rectangle start address
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_BLT_FILL
-Enum 	83/0x53
-Description
-	BLT fill color
-Param[0]
-	Same as Param[0] on API 0x52
-Param[1]
-	Same as Param[1] on API 0x52
-Param[2]
-	Same as Param[2] on API 0x52
-Param[3]
-	width
-Param[4]
-	height
-Param[5]
-	destination pixel mask
-Param[6]
-	destination rectangle start address
-Param[7]
-	destination stride in dwords
-Param[8]
-	color fill value
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_BLT_TEXT
-Enum 	84/0x54
-Description
-	BLT for 8 bit alpha text source
-Param[0]
-	Same as Param[0] on API 0x52
-Param[1]
-	Same as Param[1] on API 0x52
-Param[2]
-	Same as Param[2] on API 0x52
-Param[3]
-	width
-Param[4]
-	height
-Param[5]
-	destination pixel mask
-Param[6]
-	destination rectangle start address
-Param[7]
-	destination stride in dwords
-Param[8]
-	source stride in dwords
-Param[9]
-	source rectangle start address
-Param[10]
-	color fill value
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_SET_FRAMEBUFFER_WINDOW
-Enum 	86/0x56
-Description
-	Positions the main output window on the screen. The coordinates must be
-	such that the entire window fits on the screen.
-Param[0]
-	window width
-Param[1]
-	window height
-Param[2]
-	top left window corner horizontal offset
-Param[3]
-	top left window corner vertical offset
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_SET_CHROMA_KEY
-Enum 	96/0x60
-Description
-	Chroma key switch and color
-Param[0]
-	state: 0=off, 1=on
-Param[1]
-	color
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_GET_ALPHA_CONTENT_INDEX
-Enum 	97/0x61
-Description
-	Retrieve alpha content index
-Result[0]
-	alpha content index, Range 0:15
-
--------------------------------------------------------------------------------
-
-Name 	CX2341X_OSD_SET_ALPHA_CONTENT_INDEX
-Enum 	98/0x62
-Description
-	Assign alpha content index
-Param[0]
-	alpha content index, range 0:15
diff --git a/Documentation/video4linux/cx2341x/fw-upload.txt b/Documentation/video4linux/cx2341x/fw-upload.txt
deleted file mode 100644
index 60c502ce3215..000000000000
--- a/Documentation/video4linux/cx2341x/fw-upload.txt
+++ /dev/null
@@ -1,49 +0,0 @@
-This document describes how to upload the cx2341x firmware to the card.
-
-How to find
-===========
-
-See the web pages of the various projects that uses this chip for information
-on how to obtain the firmware.
-
-The firmware stored in a Windows driver can be detected as follows:
-
-- Each firmware image is 256k bytes.
-- The 1st 32-bit word of the Encoder image is 0x0000da7
-- The 1st 32-bit word of the Decoder image is 0x00003a7
-- The 2nd 32-bit word of both images is 0xaa55bb66
-
-How to load
-===========
-
-- Issue the FWapi command to stop the encoder if it is running. Wait for the
-  command to complete.
-- Issue the FWapi command to stop the decoder if it is running. Wait for the
-  command to complete.
-- Issue the I2C command to the digitizer to stop emitting VSYNC events.
-- Issue the FWapi command to halt the encoder's firmware.
-- Sleep for 10ms.
-- Issue the FWapi command to halt the decoder's firmware.
-- Sleep for 10ms.
-- Write 0x00000000 to register 0x2800 to stop the Video Display Module.
-- Write 0x00000005 to register 0x2D00 to stop the AO (audio output?).
-- Write 0x00000000 to register 0xA064 to ping? the APU.
-- Write 0xFFFFFFFE to register 0x9058 to stop the VPU.
-- Write 0xFFFFFFFF to register 0x9054 to reset the HW blocks.
-- Write 0x00000001 to register 0x9050 to stop the SPU.
-- Sleep for 10ms.
-- Write 0x0000001A to register 0x07FC to init the Encoder SDRAM's pre-charge.
-- Write 0x80000640 to register 0x07F8 to init the Encoder SDRAM's refresh to 1us.
-- Write 0x0000001A to register 0x08FC to init the Decoder SDRAM's pre-charge.
-- Write 0x80000640 to register 0x08F8 to init the Decoder SDRAM's refresh to 1us.
-- Sleep for 512ms. (600ms is recommended)
-- Transfer the encoder's firmware image to offset 0 in Encoder memory space.
-- Transfer the decoder's firmware image to offset 0 in Decoder memory space.
-- Use a read-modify-write operation to Clear bit 0 of register 0x9050 to
-  re-enable the SPU.
-- Sleep for 1 second.
-- Use a read-modify-write operation to Clear bits 3 and 0 of register 0x9058
-  to re-enable the VPU.
-- Sleep for 1 second.
-- Issue status API commands to both firmware images to verify.
-
-- 
2.7.4


