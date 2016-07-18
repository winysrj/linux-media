Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45871 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbcGRB4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Eric Engestrom <eric@engestrom.ch>, linux-doc@vger.kernel.org
Subject: [PATCH 34/36] [media] doc-rst: add vivid documentation
Date: Sun, 17 Jul 2016 22:56:17 -0300
Message-Id: <cff4c8acf229a53a4c959c9c7b74d1644ad3ab4c.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert it to ReST and add to media/v4l-drivers book.

As the sections here (and on other docs) are numbered,
let's also make this book auto-numbered.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst |   2 +
 Documentation/media/v4l-drivers/vivid.rst | 667 ++++++++++++++++++------------
 2 files changed, 415 insertions(+), 254 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 4431b089af49..d660623eeea6 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -17,6 +17,7 @@ License".
 
 .. toctree::
 	:maxdepth: 5
+	:numbered:
 
 	fourcc
 	cardlist
@@ -40,5 +41,6 @@ License".
 	si476x
 	soc-camera
 	uvcvideo
+	vivid
 	zoran
 	zr364xx
diff --git a/Documentation/media/v4l-drivers/vivid.rst b/Documentation/media/v4l-drivers/vivid.rst
index 1b26519c6ddc..c8cf371e8bb9 100644
--- a/Documentation/media/v4l-drivers/vivid.rst
+++ b/Documentation/media/v4l-drivers/vivid.rst
@@ -1,5 +1,5 @@
-vivid: Virtual Video Test Driver
-================================
+The Virtual Video Test Driver (vivid)
+=====================================
 
 This driver emulates video4linux hardware of various types: video capture, video
 output, vbi capture and output, radio receivers and transmitters and a software
@@ -37,49 +37,8 @@ This document describes the features implemented by this driver:
 
 These features will be described in more detail below.
 
-
-Table of Contents
------------------
-
-Section 1: Configuring the driver
-Section 2: Video Capture
-Section 2.1: Webcam Input
-Section 2.2: TV and S-Video Inputs
-Section 2.3: HDMI Input
-Section 3: Video Output
-Section 3.1: S-Video Output
-Section 3.2: HDMI Output
-Section 4: VBI Capture
-Section 5: VBI Output
-Section 6: Radio Receiver
-Section 7: Radio Transmitter
-Section 8: Software Defined Radio Receiver
-Section 9: Controls
-Section 9.1: User Controls - Test Controls
-Section 9.2: User Controls - Video Capture
-Section 9.3: User Controls - Audio
-Section 9.4: Vivid Controls
-Section 9.4.1: Test Pattern Controls
-Section 9.4.2: Capture Feature Selection Controls
-Section 9.4.3: Output Feature Selection Controls
-Section 9.4.4: Error Injection Controls
-Section 9.4.5: VBI Raw Capture Controls
-Section 9.5: Digital Video Controls
-Section 9.6: FM Radio Receiver Controls
-Section 9.7: FM Radio Modulator
-Section 10: Video, VBI and RDS Looping
-Section 10.1: Video and Sliced VBI looping
-Section 10.2: Radio & RDS Looping
-Section 11: Cropping, Composing, Scaling
-Section 12: Formats
-Section 13: Capture Overlay
-Section 14: Output Overlay
-Section 15: CEC (Consumer Electronics Control)
-Section 16: Some Future Improvements
-
-
-Section 1: Configuring the driver
----------------------------------
+Configuring the driver
+----------------------
 
 By default the driver will create a single instance that has a video capture
 device with webcam, TV, S-Video and HDMI inputs, a video output device with
@@ -89,71 +48,94 @@ radio receiver device, one radio transmitter device and one SDR device.
 The number of instances, devices, video inputs and outputs and their types are
 all configurable using the following module options:
 
-n_devs: number of driver instances to create. By default set to 1. Up to 64
+- n_devs:
+
+	number of driver instances to create. By default set to 1. Up to 64
 	instances can be created.
 
-node_types: which devices should each driver instance create. An array of
+- node_types:
+
+	which devices should each driver instance create. An array of
 	hexadecimal values, one for each instance. The default is 0x1d3d.
 	Each value is a bitmask with the following meaning:
-		bit 0: Video Capture node
-		bit 2-3: VBI Capture node: 0 = none, 1 = raw vbi, 2 = sliced vbi, 3 = both
-		bit 4: Radio Receiver node
-		bit 5: Software Defined Radio Receiver node
-		bit 8: Video Output node
-		bit 10-11: VBI Output node: 0 = none, 1 = raw vbi, 2 = sliced vbi, 3 = both
-		bit 12: Radio Transmitter node
-		bit 16: Framebuffer for testing overlays
+
+		- bit 0: Video Capture node
+		- bit 2-3: VBI Capture node: 0 = none, 1 = raw vbi, 2 = sliced vbi, 3 = both
+		- bit 4: Radio Receiver node
+		- bit 5: Software Defined Radio Receiver node
+		- bit 8: Video Output node
+		- bit 10-11: VBI Output node: 0 = none, 1 = raw vbi, 2 = sliced vbi, 3 = both
+		- bit 12: Radio Transmitter node
+		- bit 16: Framebuffer for testing overlays
 
 	So to create four instances, the first two with just one video capture
 	device, the second two with just one video output device you would pass
 	these module options to vivid:
 
+	.. code-block:: none
+
 		n_devs=4 node_types=0x1,0x1,0x100,0x100
 
-num_inputs: the number of inputs, one for each instance. By default 4 inputs
+- num_inputs:
+
+	the number of inputs, one for each instance. By default 4 inputs
 	are created for each video capture device. At most 16 inputs can be created,
 	and there must be at least one.
 
-input_types: the input types for each instance, the default is 0xe4. This defines
+- input_types:
+
+	the input types for each instance, the default is 0xe4. This defines
 	what the type of each input is when the inputs are created for each driver
 	instance. This is a hexadecimal value with up to 16 pairs of bits, each
 	pair gives the type and bits 0-1 map to input 0, bits 2-3 map to input 1,
 	30-31 map to input 15. Each pair of bits has the following meaning:
 
-		00: this is a webcam input
-		01: this is a TV tuner input
-		10: this is an S-Video input
-		11: this is an HDMI input
+		- 00: this is a webcam input
+		- 01: this is a TV tuner input
+		- 10: this is an S-Video input
+		- 11: this is an HDMI input
 
 	So to create a video capture device with 8 inputs where input 0 is a TV
 	tuner, inputs 1-3 are S-Video inputs and inputs 4-7 are HDMI inputs you
 	would use the following module options:
 
+	.. code-block:: none
+
 		num_inputs=8 input_types=0xffa9
 
-num_outputs: the number of outputs, one for each instance. By default 2 outputs
+- num_outputs:
+
+	the number of outputs, one for each instance. By default 2 outputs
 	are created for each video output device. At most 16 outputs can be
 	created, and there must be at least one.
 
-output_types: the output types for each instance, the default is 0x02. This defines
+- output_types:
+
+	the output types for each instance, the default is 0x02. This defines
 	what the type of each output is when the outputs are created for each
 	driver instance. This is a hexadecimal value with up to 16 bits, each bit
 	gives the type and bit 0 maps to output 0, bit 1 maps to output 1, bit
 	15 maps to output 15. The meaning of each bit is as follows:
 
-		0: this is an S-Video output
-		1: this is an HDMI output
+		- 0: this is an S-Video output
+		- 1: this is an HDMI output
 
 	So to create a video output device with 8 outputs where outputs 0-3 are
 	S-Video outputs and outputs 4-7 are HDMI outputs you would use the
 	following module options:
 
+	.. code-block:: none
+
 		num_outputs=8 output_types=0xf0
 
-vid_cap_nr: give the desired videoX start number for each video capture device.
+- vid_cap_nr:
+
+	give the desired videoX start number for each video capture device.
 	The default is -1 which will just take the first free number. This allows
 	you to map capture video nodes to specific videoX device nodes. Example:
 
+	.. code-block:: none
+
 		n_devs=4 vid_cap_nr=2,4,6,8
 
 	This will attempt to assign /dev/video2 for the video capture device of
@@ -161,25 +143,39 @@ vid_cap_nr: give the desired videoX start number for each video capture device.
 	instance. If it can't succeed, then it will just take the next free
 	number.
 
-vid_out_nr: give the desired videoX start number for each video output device.
-        The default is -1 which will just take the first free number.
+- vid_out_nr:
 
-vbi_cap_nr: give the desired vbiX start number for each vbi capture device.
-        The default is -1 which will just take the first free number.
+	give the desired videoX start number for each video output device.
+	The default is -1 which will just take the first free number.
 
-vbi_out_nr: give the desired vbiX start number for each vbi output device.
-        The default is -1 which will just take the first free number.
+- vbi_cap_nr:
 
-radio_rx_nr: give the desired radioX start number for each radio receiver device.
-        The default is -1 which will just take the first free number.
+	give the desired vbiX start number for each vbi capture device.
+	The default is -1 which will just take the first free number.
 
-radio_tx_nr: give the desired radioX start number for each radio transmitter
+- vbi_out_nr:
+
+	give the desired vbiX start number for each vbi output device.
+	The default is -1 which will just take the first free number.
+
+- radio_rx_nr:
+
+	give the desired radioX start number for each radio receiver device.
+	The default is -1 which will just take the first free number.
+
+- radio_tx_nr:
+
+	give the desired radioX start number for each radio transmitter
 	device. The default is -1 which will just take the first free number.
 
-sdr_cap_nr: give the desired swradioX start number for each SDR capture device.
-        The default is -1 which will just take the first free number.
+- sdr_cap_nr:
 
-ccs_cap_mode: specify the allowed video capture crop/compose/scaling combination
+	give the desired swradioX start number for each SDR capture device.
+	The default is -1 which will just take the first free number.
+
+- ccs_cap_mode:
+
+	specify the allowed video capture crop/compose/scaling combination
 	for each driver instance. Video capture devices can have any combination
 	of cropping, composing and scaling capabilities and this will tell the
 	vivid driver which of those is should emulate. By default the user can
@@ -188,21 +184,30 @@ ccs_cap_mode: specify the allowed video capture crop/compose/scaling combination
 	The value is either -1 (controlled by the user) or a set of three bits,
 	each enabling (1) or disabling (0) one of the features:
 
-		bit 0: Enable crop support. Cropping will take only part of the
-		       incoming picture.
-		bit 1: Enable compose support. Composing will copy the incoming
-		       picture into a larger buffer.
-		bit 2: Enable scaling support. Scaling can scale the incoming
-		       picture. The scaler of the vivid driver can enlarge up
-		       or down to four times the original size. The scaler is
-		       very simple and low-quality. Simplicity and speed were
-		       key, not quality.
+	- bit 0:
+
+		Enable crop support. Cropping will take only part of the
+		incoming picture.
+	- bit 1:
+
+		Enable compose support. Composing will copy the incoming
+		picture into a larger buffer.
+
+	- bit 2:
+
+		Enable scaling support. Scaling can scale the incoming
+		picture. The scaler of the vivid driver can enlarge up
+		or down to four times the original size. The scaler is
+		very simple and low-quality. Simplicity and speed were
+		key, not quality.
 
 	Note that this value is ignored by webcam inputs: those enumerate
 	discrete framesizes and that is incompatible with cropping, composing
 	or scaling.
 
-ccs_out_mode: specify the allowed video output crop/compose/scaling combination
+- ccs_out_mode:
+
+	specify the allowed video output crop/compose/scaling combination
 	for each driver instance. Video output devices can have any combination
 	of cropping, composing and scaling capabilities and this will tell the
 	vivid driver which of those is should emulate. By default the user can
@@ -211,28 +216,42 @@ ccs_out_mode: specify the allowed video output crop/compose/scaling combination
 	The value is either -1 (controlled by the user) or a set of three bits,
 	each enabling (1) or disabling (0) one of the features:
 
-		bit 0: Enable crop support. Cropping will take only part of the
-		       outgoing buffer.
-		bit 1: Enable compose support. Composing will copy the incoming
-		       buffer into a larger picture frame.
-		bit 2: Enable scaling support. Scaling can scale the incoming
-		       buffer. The scaler of the vivid driver can enlarge up
-		       or down to four times the original size. The scaler is
-		       very simple and low-quality. Simplicity and speed were
-		       key, not quality.
-
-multiplanar: select whether each device instance supports multi-planar formats,
+	- bit 0:
+
+		Enable crop support. Cropping will take only part of the
+		outgoing buffer.
+
+	- bit 1:
+
+		Enable compose support. Composing will copy the incoming
+		buffer into a larger picture frame.
+
+	- bit 2:
+
+		Enable scaling support. Scaling can scale the incoming
+		buffer. The scaler of the vivid driver can enlarge up
+		or down to four times the original size. The scaler is
+		very simple and low-quality. Simplicity and speed were
+		key, not quality.
+
+- multiplanar:
+
+	select whether each device instance supports multi-planar formats,
 	and thus the V4L2 multi-planar API. By default device instances are
 	single-planar.
 
 	This module option can override that for each instance. Values are:
 
-		1: this is a single-planar instance.
-		2: this is a multi-planar instance.
+		- 1: this is a single-planar instance.
+		- 2: this is a multi-planar instance.
 
-vivid_debug: enable driver debugging info
+- vivid_debug:
 
-no_error_inj: if set disable the error injecting controls. This option is
+	enable driver debugging info
+
+- no_error_inj:
+
+	if set disable the error injecting controls. This option is
 	needed in order to run a tool like v4l2-compliance. Tools like that
 	exercise all controls including a control like 'Disconnect' which
 	emulates a USB disconnect, making the device inaccessible and so
@@ -250,8 +269,8 @@ It is also very suitable to emulate hardware that is not yet available, e.g.
 when developing software for a new upcoming device.
 
 
-Section 2: Video Capture
-------------------------
+Video Capture
+-------------
 
 This is probably the most frequently used feature. The video capture device
 can be configured by using the module options num_inputs, input_types and
@@ -270,8 +289,8 @@ frame/field sequence counting will keep track of that so the sequence
 count will skip whenever frames are dropped.
 
 
-Section 2.1: Webcam Input
--------------------------
+Webcam Input
+~~~~~~~~~~~~
 
 The webcam input supports three framesizes: 320x180, 640x360 and 1280x720. It
 supports frames per second settings of 10, 15, 25, 30, 50 and 60 fps. Which ones
@@ -282,8 +301,8 @@ The initially selected colorspace when you switch to the webcam input will be
 sRGB.
 
 
-Section 2.2: TV and S-Video Inputs
-----------------------------------
+TV and S-Video Inputs
+~~~~~~~~~~~~~~~~~~~~~
 
 The only difference between the TV and S-Video input is that the TV has a
 tuner. Otherwise they behave identically.
@@ -338,8 +357,8 @@ Finally, for these inputs the v4l2_timecode struct is filled in in the
 dequeued v4l2_buffer struct.
 
 
-Section 2.3: HDMI Input
------------------------
+HDMI Input
+~~~~~~~~~~
 
 The HDMI inputs supports all CEA-861 and DMT timings, both progressive and
 interlaced, for pixelclock frequencies between 25 and 600 MHz. The field
@@ -372,8 +391,8 @@ There is a maximum of 15 HDMI inputs (if there are more, then they will be
 reduced to 15) since that's the limitation of the EDID physical address.
 
 
-Section 3: Video Output
------------------------
+Video Output
+------------
 
 The video output device can be configured by using the module options
 num_outputs, output_types and ccs_out_mode (see section 1 for more detailed
@@ -384,8 +403,8 @@ below.
 Like with video capture the framerate is also exact in the long term.
 
 
-Section 3.1: S-Video Output
----------------------------
+S-Video Output
+~~~~~~~~~~~~~~
 
 This output supports audio outputs as well: "Line-Out 1" and "Line-Out 2".
 The S-Video output supports all TV standards.
@@ -396,8 +415,8 @@ The initially selected colorspace when you switch to the TV or S-Video input
 will be SMPTE-170M.
 
 
-Section 3.2: HDMI Output
-------------------------
+HDMI Output
+~~~~~~~~~~~
 
 The HDMI output supports all CEA-861 and DMT timings, both progressive and
 interlaced, for pixelclock frequencies between 25 and 600 MHz. The field
@@ -418,8 +437,8 @@ There is a maximum of 15 HDMI outputs (if there are more, then they will be
 reduced to 15) since that's the limitation of the EDID physical address. See
 also the CEC section for more details.
 
-Section 4: VBI Capture
-----------------------
+VBI Capture
+-----------
 
 There are three types of VBI capture devices: those that only support raw
 (undecoded) VBI, those that only support sliced (decoded) VBI and those that
@@ -435,8 +454,8 @@ The VBI device will only work for the S-Video and TV inputs, it will give
 back an error if the current input is a webcam or HDMI.
 
 
-Section 5: VBI Output
----------------------
+VBI Output
+----------
 
 There are three types of VBI output devices: those that only support raw
 (undecoded) VBI, those that only support sliced (decoded) VBI and those that
@@ -449,15 +468,15 @@ The VBI device will only work for the S-Video output, it will give
 back an error if the current output is HDMI.
 
 
-Section 6: Radio Receiver
--------------------------
+Radio Receiver
+--------------
 
 The radio receiver emulates an FM/AM/SW receiver. The FM band also supports RDS.
 The frequency ranges are:
 
-	FM: 64 MHz - 108 MHz
-	AM: 520 kHz - 1710 kHz
-	SW: 2300 kHz - 26.1 MHz
+	- FM: 64 MHz - 108 MHz
+	- AM: 520 kHz - 1710 kHz
+	- SW: 2300 kHz - 26.1 MHz
 
 Valid channels are emulated every 1 MHz for FM and every 100 kHz for AM and SW.
 The signal strength decreases the further the frequency is from the valid
@@ -485,15 +504,15 @@ The receiver supports HW frequency seek, either in Bounded mode, Wrap Around
 mode or both, which is configurable with the "Radio HW Seek Mode" control.
 
 
-Section 7: Radio Transmitter
-----------------------------
+Radio Transmitter
+-----------------
 
 The radio transmitter emulates an FM/AM/SW transmitter. The FM band also supports RDS.
 The frequency ranges are:
 
-	FM: 64 MHz - 108 MHz
-	AM: 520 kHz - 1710 kHz
-	SW: 2300 kHz - 26.1 MHz
+	- FM: 64 MHz - 108 MHz
+	- AM: 520 kHz - 1710 kHz
+	- SW: 2300 kHz - 26.1 MHz
 
 The initial frequency when the driver is loaded is 95.5 MHz.
 
@@ -503,8 +522,8 @@ using controls, and in 'Block I/O' mode the blocks are passed to the driver
 using write().
 
 
-Section 8: Software Defined Radio Receiver
-------------------------------------------
+Software Defined Radio Receiver
+-------------------------------
 
 The SDR receiver has three frequency bands for the ADC tuner:
 
@@ -518,15 +537,15 @@ The generated data contains the In-phase and Quadrature components of a
 1 kHz tone that has an amplitude of sqrt(2).
 
 
-Section 9: Controls
--------------------
+Controls
+--------
 
 Different devices support different controls. The sections below will describe
 each control and which devices support them.
 
 
-Section 9.1: User Controls - Test Controls
-------------------------------------------
+User Controls - Test Controls
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 The Button, Boolean, Integer 32 Bits, Integer 64 Bits, Menu, String, Bitmask and
 Integer Menu are controls that represent all possible control types. The Menu
@@ -537,8 +556,8 @@ allow you to check if your application can handle such things correctly.
 These controls are supported for every device type.
 
 
-Section 9.2: User Controls - Video Capture
-------------------------------------------
+User Controls - Video Capture
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 The following controls are specific to video capture.
 
@@ -563,8 +582,8 @@ The 'Alpha Component' control can be used to set the alpha component for
 formats containing an alpha channel.
 
 
-Section 9.3: User Controls - Audio
-----------------------------------
+User Controls - Audio
+~~~~~~~~~~~~~~~~~~~~~
 
 The following controls are specific to video capture and output and radio
 receivers and transmitters.
@@ -574,70 +593,98 @@ control the volume and mute the audio. They don't actually do anything in
 the vivid driver.
 
 
-Section 9.4: Vivid Controls
----------------------------
+Vivid Controls
+~~~~~~~~~~~~~~
 
 These vivid custom controls control the image generation, error injection, etc.
 
 
-Section 9.4.1: Test Pattern Controls
-------------------------------------
+Test Pattern Controls
+^^^^^^^^^^^^^^^^^^^^^
 
 The Test Pattern Controls are all specific to video capture.
 
-Test Pattern: selects which test pattern to use. Use the CSC Colorbar for
+- Test Pattern:
+
+	selects which test pattern to use. Use the CSC Colorbar for
 	testing colorspace conversions: the colors used in that test pattern
 	map to valid colors in all colorspaces. The colorspace conversion
 	is disabled for the other test patterns.
 
-OSD Text Mode: selects whether the text superimposed on the
+- OSD Text Mode:
+
+	selects whether the text superimposed on the
 	test pattern should be shown, and if so, whether only counters should
 	be displayed or the full text.
 
-Horizontal Movement: selects whether the test pattern should
+- Horizontal Movement:
+
+	selects whether the test pattern should
 	move to the left or right and at what speed.
 
-Vertical Movement: does the same for the vertical direction.
+- Vertical Movement:
 
-Show Border: show a two-pixel wide border at the edge of the actual image,
+	does the same for the vertical direction.
+
+- Show Border:
+
+	show a two-pixel wide border at the edge of the actual image,
 	excluding letter or pillarboxing.
 
-Show Square: show a square in the middle of the image. If the image is
+- Show Square:
+
+	show a square in the middle of the image. If the image is
 	displayed with the correct pixel and image aspect ratio corrections,
 	then the width and height of the square on the monitor should be
 	the same.
 
-Insert SAV Code in Image: adds a SAV (Start of Active Video) code to the image.
+- Insert SAV Code in Image:
+
+	adds a SAV (Start of Active Video) code to the image.
 	This can be used to check if such codes in the image are inadvertently
 	interpreted instead of being ignored.
 
-Insert EAV Code in Image: does the same for the EAV (End of Active Video) code.
+- Insert EAV Code in Image:
 
+	does the same for the EAV (End of Active Video) code.
 
-Section 9.4.2: Capture Feature Selection Controls
--------------------------------------------------
+
+Capture Feature Selection Controls
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 These controls are all specific to video capture.
 
-Sensor Flipped Horizontally: the image is flipped horizontally and the
+- Sensor Flipped Horizontally:
+
+	the image is flipped horizontally and the
 	V4L2_IN_ST_HFLIP input status flag is set. This emulates the case where
 	a sensor is for example mounted upside down.
 
-Sensor Flipped Vertically: the image is flipped vertically and the
+- Sensor Flipped Vertically:
+
+	the image is flipped vertically and the
 	V4L2_IN_ST_VFLIP input status flag is set. This emulates the case where
-        a sensor is for example mounted upside down.
+	a sensor is for example mounted upside down.
 
-Standard Aspect Ratio: selects if the image aspect ratio as used for the TV or
+- Standard Aspect Ratio:
+
+	selects if the image aspect ratio as used for the TV or
 	S-Video input should be 4x3, 16x9 or anamorphic widescreen. This may
 	introduce letterboxing.
 
-DV Timings Aspect Ratio: selects if the image aspect ratio as used for the HDMI
+- DV Timings Aspect Ratio:
+
+	selects if the image aspect ratio as used for the HDMI
 	input should be the same as the source width and height ratio, or if
 	it should be 4x3 or 16x9. This may introduce letter or pillarboxing.
 
-Timestamp Source: selects when the timestamp for each buffer is taken.
+- Timestamp Source:
 
-Colorspace: selects which colorspace should be used when generating the image.
+	selects when the timestamp for each buffer is taken.
+
+- Colorspace:
+
+	selects which colorspace should be used when generating the image.
 	This only applies if the CSC Colorbar test pattern is selected,
 	otherwise the test pattern will go through unconverted.
 	This behavior is also what you want, since a 75% Colorbar
@@ -647,95 +694,124 @@ Colorspace: selects which colorspace should be used when generating the image.
 	Changing the colorspace will result in the V4L2_EVENT_SOURCE_CHANGE
 	to be sent since it emulates a detected colorspace change.
 
-Transfer Function: selects which colorspace transfer function should be used when
+- Transfer Function:
+
+	selects which colorspace transfer function should be used when
 	generating an image. This only applies if the CSC Colorbar test pattern is
 	selected, otherwise the test pattern will go through unconverted.
-        This behavior is also what you want, since a 75% Colorbar
-        should really have 75% signal intensity and should not be affected
-        by colorspace conversions.
+	This behavior is also what you want, since a 75% Colorbar
+	should really have 75% signal intensity and should not be affected
+	by colorspace conversions.
 
 	Changing the transfer function will result in the V4L2_EVENT_SOURCE_CHANGE
 	to be sent since it emulates a detected colorspace change.
 
-Y'CbCr Encoding: selects which Y'CbCr encoding should be used when generating
+- Y'CbCr Encoding:
+
+	selects which Y'CbCr encoding should be used when generating
 	a Y'CbCr image.	This only applies if the format is set to a Y'CbCr format
 	as opposed to an RGB format.
 
 	Changing the Y'CbCr encoding will result in the V4L2_EVENT_SOURCE_CHANGE
 	to be sent since it emulates a detected colorspace change.
 
-Quantization: selects which quantization should be used for the RGB or Y'CbCr
+- Quantization:
+
+	selects which quantization should be used for the RGB or Y'CbCr
 	encoding when generating the test pattern.
 
 	Changing the quantization will result in the V4L2_EVENT_SOURCE_CHANGE
 	to be sent since it emulates a detected colorspace change.
 
-Limited RGB Range (16-235): selects if the RGB range of the HDMI source should
+- Limited RGB Range (16-235):
+
+	selects if the RGB range of the HDMI source should
 	be limited or full range. This combines with the Digital Video 'Rx RGB
 	Quantization Range' control and can be used to test what happens if
 	a source provides you with the wrong quantization range information.
 	See the description of that control for more details.
 
-Apply Alpha To Red Only: apply the alpha channel as set by the 'Alpha Component'
+- Apply Alpha To Red Only:
+
+	apply the alpha channel as set by the 'Alpha Component'
 	user control to the red color of the test pattern only.
 
-Enable Capture Cropping: enables crop support. This control is only present if
+- Enable Capture Cropping:
+
+	enables crop support. This control is only present if
 	the ccs_cap_mode module option is set to the default value of -1 and if
 	the no_error_inj module option is set to 0 (the default).
 
-Enable Capture Composing: enables composing support. This control is only
+- Enable Capture Composing:
+
+	enables composing support. This control is only
 	present if the ccs_cap_mode module option is set to the default value of
 	-1 and if the no_error_inj module option is set to 0 (the default).
 
-Enable Capture Scaler: enables support for a scaler (maximum 4 times upscaling
+- Enable Capture Scaler:
+
+	enables support for a scaler (maximum 4 times upscaling
 	and downscaling). This control is only present if the ccs_cap_mode
 	module option is set to the default value of -1 and if the no_error_inj
 	module option is set to 0 (the default).
 
-Maximum EDID Blocks: determines how many EDID blocks the driver supports.
+- Maximum EDID Blocks:
+
+	determines how many EDID blocks the driver supports.
 	Note that the vivid driver does not actually interpret new EDID
 	data, it just stores it. It allows for up to 256 EDID blocks
 	which is the maximum supported by the standard.
 
-Fill Percentage of Frame: can be used to draw only the top X percent
+- Fill Percentage of Frame:
+
+	can be used to draw only the top X percent
 	of the image. Since each frame has to be drawn by the driver, this
 	demands a lot of the CPU. For large resolutions this becomes
 	problematic. By drawing only part of the image this CPU load can
 	be reduced.
 
 
-Section 9.4.3: Output Feature Selection Controls
-------------------------------------------------
+Output Feature Selection Controls
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 These controls are all specific to video output.
 
-Enable Output Cropping: enables crop support. This control is only present if
+- Enable Output Cropping:
+
+	enables crop support. This control is only present if
 	the ccs_out_mode module option is set to the default value of -1 and if
 	the no_error_inj module option is set to 0 (the default).
 
-Enable Output Composing: enables composing support. This control is only
+- Enable Output Composing:
+
+	enables composing support. This control is only
 	present if the ccs_out_mode module option is set to the default value of
 	-1 and if the no_error_inj module option is set to 0 (the default).
 
-Enable Output Scaler: enables support for a scaler (maximum 4 times upscaling
+- Enable Output Scaler:
+
+	enables support for a scaler (maximum 4 times upscaling
 	and downscaling). This control is only present if the ccs_out_mode
 	module option is set to the default value of -1 and if the no_error_inj
 	module option is set to 0 (the default).
 
 
-Section 9.4.4: Error Injection Controls
----------------------------------------
+Error Injection Controls
+^^^^^^^^^^^^^^^^^^^^^^^^
 
 The following two controls are only valid for video and vbi capture.
 
-Standard Signal Mode: selects the behavior of VIDIOC_QUERYSTD: what should
-	it return?
+- Standard Signal Mode:
+
+	selects the behavior of VIDIOC_QUERYSTD: what should it return?
 
 	Changing this control will result in the V4L2_EVENT_SOURCE_CHANGE
 	to be sent since it emulates a changed input condition (e.g. a cable
 	was plugged in or out).
 
-Standard: selects the standard that VIDIOC_QUERYSTD should return if the
+- Standard:
+
+	selects the standard that VIDIOC_QUERYSTD should return if the
 	previous control is set to "Selected Standard".
 
 	Changing this control will result in the V4L2_EVENT_SOURCE_CHANGE
@@ -744,14 +820,17 @@ Standard: selects the standard that VIDIOC_QUERYSTD should return if the
 
 The following two controls are only valid for video capture.
 
-DV Timings Signal Mode: selects the behavior of VIDIOC_QUERY_DV_TIMINGS: what
+- DV Timings Signal Mode:
+	selects the behavior of VIDIOC_QUERY_DV_TIMINGS: what
 	should it return?
 
 	Changing this control will result in the V4L2_EVENT_SOURCE_CHANGE
 	to be sent since it emulates a changed input condition (e.g. a cable
 	was plugged in or out).
 
-DV Timings: selects the timings the VIDIOC_QUERY_DV_TIMINGS should return
+- DV Timings:
+
+	selects the timings the VIDIOC_QUERY_DV_TIMINGS should return
 	if the previous control is set to "Selected DV Timings".
 
 	Changing this control will result in the V4L2_EVENT_SOURCE_CHANGE
@@ -763,52 +842,74 @@ is set to 0 (the default). These controls are valid for video and vbi
 capture and output streams and for the SDR capture device except for the
 Disconnect control which is valid for all devices.
 
-Wrap Sequence Number: test what happens when you wrap the sequence number in
+- Wrap Sequence Number:
+
+	test what happens when you wrap the sequence number in
 	struct v4l2_buffer around.
 
-Wrap Timestamp: test what happens when you wrap the timestamp in struct
+- Wrap Timestamp:
+
+	test what happens when you wrap the timestamp in struct
 	v4l2_buffer around.
 
-Percentage of Dropped Buffers: sets the percentage of buffers that
+- Percentage of Dropped Buffers:
+
+	sets the percentage of buffers that
 	are never returned by the driver (i.e., they are dropped).
 
-Disconnect: emulates a USB disconnect. The device will act as if it has
+- Disconnect:
+
+	emulates a USB disconnect. The device will act as if it has
 	been disconnected. Only after all open filehandles to the device
 	node have been closed will the device become 'connected' again.
 
-Inject V4L2_BUF_FLAG_ERROR: when pressed, the next frame returned by
+- Inject V4L2_BUF_FLAG_ERROR:
+
+	when pressed, the next frame returned by
 	the driver will have the error flag set (i.e. the frame is marked
 	corrupt).
 
-Inject VIDIOC_REQBUFS Error: when pressed, the next REQBUFS or CREATE_BUFS
+- Inject VIDIOC_REQBUFS Error:
+
+	when pressed, the next REQBUFS or CREATE_BUFS
 	ioctl call will fail with an error. To be precise: the videobuf2
 	queue_setup() op will return -EINVAL.
 
-Inject VIDIOC_QBUF Error: when pressed, the next VIDIOC_QBUF or
+- Inject VIDIOC_QBUF Error:
+
+	when pressed, the next VIDIOC_QBUF or
 	VIDIOC_PREPARE_BUFFER ioctl call will fail with an error. To be
 	precise: the videobuf2 buf_prepare() op will return -EINVAL.
 
-Inject VIDIOC_STREAMON Error: when pressed, the next VIDIOC_STREAMON ioctl
+- Inject VIDIOC_STREAMON Error:
+
+	when pressed, the next VIDIOC_STREAMON ioctl
 	call will fail with an error. To be precise: the videobuf2
 	start_streaming() op will return -EINVAL.
 
-Inject Fatal Streaming Error: when pressed, the streaming core will be
+- Inject Fatal Streaming Error:
+
+	when pressed, the streaming core will be
 	marked as having suffered a fatal error, the only way to recover
 	from that is to stop streaming. To be precise: the videobuf2
 	vb2_queue_error() function is called.
 
 
-Section 9.4.5: VBI Raw Capture Controls
----------------------------------------
+VBI Raw Capture Controls
+^^^^^^^^^^^^^^^^^^^^^^^^
 
-Interlaced VBI Format: if set, then the raw VBI data will be interlaced instead
+- Interlaced VBI Format:
+
+	if set, then the raw VBI data will be interlaced instead
 	of providing it grouped by field.
 
 
-Section 9.5: Digital Video Controls
------------------------------------
+Digital Video Controls
+~~~~~~~~~~~~~~~~~~~~~~
 
-Rx RGB Quantization Range: sets the RGB quantization detection of the HDMI
+- Rx RGB Quantization Range:
+
+	sets the RGB quantization detection of the HDMI
 	input. This combines with the Vivid 'Limited RGB Range (16-235)'
 	control and can be used to test what happens if a source provides
 	you with the wrong quantization range information. This can be tested
@@ -817,72 +918,124 @@ Rx RGB Quantization Range: sets the RGB quantization detection of the HDMI
 	control. The effect is easy to see if the 'Gray Ramp' test pattern
 	is selected.
 
-Tx RGB Quantization Range: sets the RGB quantization detection of the HDMI
+- Tx RGB Quantization Range:
+
+	sets the RGB quantization detection of the HDMI
 	output. It is currently not used for anything in vivid, but most HDMI
 	transmitters would typically have this control.
 
-Transmit Mode: sets the transmit mode of the HDMI output to HDMI or DVI-D. This
+- Transmit Mode:
+
+	sets the transmit mode of the HDMI output to HDMI or DVI-D. This
 	affects the reported colorspace since DVI_D outputs will always use
 	sRGB.
 
 
-Section 9.6: FM Radio Receiver Controls
----------------------------------------
+FM Radio Receiver Controls
+~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-RDS Reception: set if the RDS receiver should be enabled.
+- RDS Reception:
 
-RDS Program Type:
-RDS PS Name:
-RDS Radio Text:
-RDS Traffic Announcement:
-RDS Traffic Program:
-RDS Music: these are all read-only controls. If RDS Rx I/O Mode is set to
+	set if the RDS receiver should be enabled.
+
+- RDS Program Type:
+
+
+- RDS PS Name:
+
+
+- RDS Radio Text:
+
+
+- RDS Traffic Announcement:
+
+
+- RDS Traffic Program:
+
+
+- RDS Music:
+
+	these are all read-only controls. If RDS Rx I/O Mode is set to
 	"Block I/O", then they are inactive as well. If RDS Rx I/O Mode is set
-	to "Controls", then these controls report the received RDS data. Note
-	that the vivid implementation of this is pretty basic: they are only
+	to "Controls", then these controls report the received RDS data.
+
+.. note::
+	The vivid implementation of this is pretty basic: they are only
 	updated when you set a new frequency or when you get the tuner status
 	(VIDIOC_G_TUNER).
 
-Radio HW Seek Mode: can be one of "Bounded", "Wrap Around" or "Both". This
+- Radio HW Seek Mode:
+
+	can be one of "Bounded", "Wrap Around" or "Both". This
 	determines if VIDIOC_S_HW_FREQ_SEEK will be bounded by the frequency
 	range or wrap-around or if it is selectable by the user.
 
-Radio Programmable HW Seek: if set, then the user can provide the lower and
+- Radio Programmable HW Seek:
+
+	if set, then the user can provide the lower and
 	upper bound of the HW Seek. Otherwise the frequency range boundaries
 	will be used.
 
-Generate RBDS Instead of RDS: if set, then generate RBDS (the US variant of
+- Generate RBDS Instead of RDS:
+
+	if set, then generate RBDS (the US variant of
 	RDS) data instead of RDS (European-style RDS). This affects only the
 	PICODE and PTY codes.
 
-RDS Rx I/O Mode: this can be "Block I/O" where the RDS blocks have to be read()
+- RDS Rx I/O Mode:
+
+	this can be "Block I/O" where the RDS blocks have to be read()
 	by the application, or "Controls" where the RDS data is provided by
 	the RDS controls mentioned above.
 
 
-Section 9.7: FM Radio Modulator Controls
-----------------------------------------
-
-RDS Program ID:
-RDS Program Type:
-RDS PS Name:
-RDS Radio Text:
-RDS Stereo:
-RDS Artificial Head:
-RDS Compressed:
-RDS Dynamic PTY:
-RDS Traffic Announcement:
-RDS Traffic Program:
-RDS Music: these are all controls that set the RDS data that is transmitted by
+FM Radio Modulator Controls
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+- RDS Program ID:
+
+
+- RDS Program Type:
+
+
+- RDS PS Name:
+
+
+- RDS Radio Text:
+
+
+- RDS Stereo:
+
+
+- RDS Artificial Head:
+
+
+- RDS Compressed:
+
+
+- RDS Dynamic PTY:
+
+
+- RDS Traffic Announcement:
+
+
+- RDS Traffic Program:
+
+
+- RDS Music:
+
+	these are all controls that set the RDS data that is transmitted by
 	the FM modulator.
 
-RDS Tx I/O Mode: this can be "Block I/O" where the application has to use write()
-	to pass the RDS blocks to the driver, or "Controls" where the RDS data is
-	provided by the RDS controls mentioned above.
+- RDS Tx I/O Mode:
 
+	this can be "Block I/O" where the application has to use write()
+	to pass the RDS blocks to the driver, or "Controls" where the RDS data
+	is Provided by the RDS controls mentioned above.
 
-Section 10: Video, VBI and RDS Looping
---------------------------------------
+
+Video, VBI and RDS Looping
+--------------------------
 
 The vivid driver supports looping of video output to video input, VBI output
 to VBI input and RDS output to RDS input. For video/VBI looping this emulates
@@ -898,8 +1051,8 @@ Looping is currently supported only between devices created by the same
 vivid driver instance.
 
 
-Section 10.1: Video and Sliced VBI looping
-------------------------------------------
+Video and Sliced VBI looping
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 The way to enable video/VBI looping is currently fairly crude. A 'Loop Video'
 control is available in the "Vivid" control class of the video
@@ -948,8 +1101,8 @@ for either raw or sliced VBI. Note that at the moment only CC/XDS (60 Hz formats
 and WSS (50 Hz formats) VBI data is looped. Teletext VBI data is not looped.
 
 
-Section 10.2: Radio & RDS Looping
----------------------------------
+Radio & RDS Looping
+~~~~~~~~~~~~~~~~~~~
 
 As mentioned in section 6 the radio receiver emulates stations are regular
 frequency intervals. Depending on the frequency of the radio receiver a
@@ -963,8 +1116,8 @@ frequencies of the radio receiver and transmitter are not identical, so
 initially no looping takes place.
 
 
-Section 11: Cropping, Composing, Scaling
-----------------------------------------
+Cropping, Composing, Scaling
+----------------------------
 
 This driver supports cropping, composing and scaling in any combination. Normally
 which features are supported can be selected through the Vivid controls,
@@ -997,8 +1150,8 @@ If the combination of crop, compose and scaling allows it, then it is possible
 to change crop and compose rectangles on the fly.
 
 
-Section 12: Formats
--------------------
+Formats
+-------
 
 The driver supports all the regular packed and planar 4:4:4, 4:2:2 and 4:2:0
 YUYV formats, 8, 16, 24 and 32 RGB packed formats and various multiplanar
@@ -1021,8 +1174,8 @@ data_offset to be non-zero, so this is a useful feature for testing applications
 Video output will also honor any data_offset that the application set.
 
 
-Section 13: Capture Overlay
----------------------------
+Capture Overlay
+---------------
 
 Note: capture overlay support is implemented primarily to test the existing
 V4L2 capture overlay API. In practice few if any GPUs support such overlays
@@ -1055,6 +1208,8 @@ the output overlay for the video output, turn on video looping and capture
 to see the blended framebuffer overlay that's being written to by the second
 instance. This setup would require the following commands:
 
+.. code-block:: none
+
 	$ sudo modprobe vivid n_devs=2 node_types=0x10101,0x1
 	$ v4l2-ctl -d1 --find-fb
 	/dev/fb1 is the framebuffer associated with base address 0x12800000
@@ -1072,10 +1227,14 @@ instance. This setup would require the following commands:
 
 And from another console:
 
+.. code-block:: none
+
 	$ v4l2-ctl -d1 --stream-out-mmap
 
 And yet another console:
 
+.. code-block:: none
+
 	$ qv4l2
 
 and start streaming.
@@ -1083,8 +1242,8 @@ and start streaming.
 As you can see, this is not for the faint of heart...
 
 
-Section 14: Output Overlay
---------------------------
+Output Overlay
+--------------
 
 Note: output overlays are primarily implemented in order to test the existing
 V4L2 output overlay API. Whether this API should be used for new drivers is
@@ -1116,8 +1275,8 @@ capabilities will slow down the video loop considerably as a lot of checks have
 to be done per pixel.
 
 
-Section 15: CEC (Consumer Electronics Control)
-----------------------------------------------
+CEC (Consumer Electronics Control)
+----------------------------------
 
 If there are HDMI inputs then a CEC adapter will be created that has
 the same number of input ports. This is the equivalent of e.g. a TV that
@@ -1135,8 +1294,8 @@ there are more outputs than inputs then the remaining outputs have a CEC adapter
 that is disabled and reports an invalid physical address.
 
 
-Section 16: Some Future Improvements
-------------------------------------
+Some Future Improvements
+------------------------
 
 Just as a reminder and in no particular order:
 
-- 
2.7.4

