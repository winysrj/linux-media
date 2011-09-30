Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3868 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758464Ab1I3MUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 08:20:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 6/7] V4L menu: reorganize the radio menu.
Date: Fri, 30 Sep 2011 14:18:33 +0200
Message-Id: <308c63208ef8063ea2acffc02c7e28b43da1f4f9.1317384926.git.hans.verkuil@cisco.com>
In-Reply-To: <1317385114-7475-1-git-send-email-hverkuil@xs4all.nl>
References: <1317385114-7475-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9198dc44ea6f7b8e481c8e6bb24c80fc1b2429ed.1317384926.git.hans.verkuil@cisco.com>
References: <9198dc44ea6f7b8e481c8e6bb24c80fc1b2429ed.1317384926.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Move all USB radio devices to the top of the list and move all ISA
devices to a separate menu.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/Kconfig |  298 +++++++++++++++++++++++--------------------
 1 files changed, 157 insertions(+), 141 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 52798a1..e954781 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -11,6 +11,162 @@ menuconfig RADIO_ADAPTERS
 
 if RADIO_ADAPTERS && VIDEO_V4L2
 
+config RADIO_SI470X
+	bool "Silicon Labs Si470x FM Radio Receiver support"
+	depends on VIDEO_V4L2
+
+source "drivers/media/radio/si470x/Kconfig"
+
+config USB_MR800
+	tristate "AverMedia MR 800 USB FM radio support"
+	depends on USB && VIDEO_V4L2
+	---help---
+	  Say Y here if you want to connect this type of radio to your
+	  computer's USB port. Note that the audio is not digital, and
+	  you must connect the line out connector to a sound card or a
+	  set of speakers.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-mr800.
+
+config USB_DSBR
+	tristate "D-Link/GemTek USB FM radio support"
+	depends on USB && VIDEO_V4L2
+	---help---
+	  Say Y here if you want to connect this type of radio to your
+	  computer's USB port. Note that the audio is not digital, and
+	  you must connect the line out connector to a sound card or a
+	  set of speakers.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called dsbr100.
+
+config RADIO_MAXIRADIO
+	tristate "Guillemot MAXI Radio FM 2000 radio"
+	depends on VIDEO_V4L2 && PCI
+	---help---
+	  Choose Y here if you have this radio card.  This card may also be
+	  found as Gemtek PCI FM.
+
+	  In order to control your radio card, you will need to use programs
+	  that are compatible with the Video For Linux API.  Information on
+	  this API and pointers to "v4l" programs may be found at
+	  <file:Documentation/video4linux/API.html>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-maxiradio.
+
+
+config I2C_SI4713
+	tristate "I2C driver for Silicon Labs Si4713 device"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  Say Y here if you want support to Si4713 I2C device.
+	  This device driver supports only i2c bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called si4713.
+
+config RADIO_SI4713
+	tristate "Silicon Labs Si4713 FM Radio Transmitter support"
+	depends on I2C && VIDEO_V4L2
+	select I2C_SI4713
+	---help---
+	  Say Y here if you want support to Si4713 FM Radio Transmitter.
+	  This device can transmit audio through FM. It can transmit
+	  RDS and RBDS signals as well. This module is the v4l2 radio
+	  interface for the i2c driver of this device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-si4713.
+
+config RADIO_TEA5764
+	tristate "TEA5764 I2C FM radio support"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  Say Y here if you want to use the TEA5764 FM chip found in
+	  EZX phones. This FM chip is present in EZX phones from Motorola,
+	  connected to internal pxa I2C bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-tea5764.
+
+config RADIO_TEA5764_XTAL
+	bool "TEA5764 crystal reference"
+	depends on RADIO_TEA5764=y
+	default y
+	help
+	  Say Y here if TEA5764 have a 32768 Hz crystal in circuit, say N
+	  here if TEA5764 reference frequency is connected in FREQIN.
+
+config RADIO_SAA7706H
+	tristate "SAA7706H Car Radio DSP"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  Say Y here if you want to use the SAA7706H Car radio Digital
+	  Signal Processor, found for instance on the Russellville development
+	  board. On the russellville the device is connected to internal
+	  timberdale I2C bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called SAA7706H.
+
+config RADIO_TEF6862
+	tristate "TEF6862 Car Radio Enhanced Selectivity Tuner"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  Say Y here if you want to use the TEF6862 Car Radio Enhanced
+	  Selectivity Tuner, found for instance on the Russellville development
+	  board. On the russellville the device is connected to internal
+	  timberdale I2C bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called TEF6862.
+
+config RADIO_TIMBERDALE
+	tristate "Enable the Timberdale radio driver"
+	depends on MFD_TIMBERDALE && VIDEO_V4L2
+	depends on I2C	# for RADIO_SAA7706H
+	select RADIO_TEF6862
+	select RADIO_SAA7706H
+	---help---
+	  This is a kind of umbrella driver for the Radio Tuner and DSP
+	  found behind the Timberdale FPGA on the Russellville board.
+	  Enabling this driver will automatically select the DSP and tuner.
+
+config RADIO_WL1273
+	tristate "Texas Instruments WL1273 I2C FM Radio"
+	depends on I2C && VIDEO_V4L2
+	select MFD_CORE
+	select MFD_WL1273_CORE
+	select FW_LOADER
+	---help---
+	  Choose Y here if you have this FM radio chip.
+
+	  In order to control your radio card, you will need to use programs
+	  that are compatible with the Video For Linux 2 API.  Information on
+	  this API and pointers to "v4l2" programs may be found at
+	  <file:Documentation/video4linux/API.html>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-wl1273.
+
+# TI's ST based wl128x FM radio
+source "drivers/media/radio/wl128x/Kconfig"
+
+#
+# ISA drivers configuration
+#
+
+menuconfig V4L_RADIO_ISA_DRIVERS
+	bool "ISA radio devices"
+	depends on ISA
+	default n
+	---help---
+	  Say Y here to enable support for these ISA drivers.
+
+if V4L_RADIO_ISA_DRIVERS
+
 config RADIO_CADET
 	tristate "ADS Cadet AM/FM Tuner"
 	depends on ISA && VIDEO_V4L2
@@ -151,21 +307,6 @@ config RADIO_GEMTEK_PROBE
 	  following ports will be probed: 0x20c, 0x30c, 0x24c, 0x34c, 0x248 and
 	  0x28c.
 
-config RADIO_MAXIRADIO
-	tristate "Guillemot MAXI Radio FM 2000 radio"
-	depends on VIDEO_V4L2 && PCI
-	---help---
-	  Choose Y here if you have this radio card.  This card may also be
-	  found as Gemtek PCI FM.
-
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called radio-maxiradio.
-
 config RADIO_MIROPCM20
 	tristate "miroSOUND PCM20 radio"
 	depends on ISA && ISA_DMA_API && VIDEO_V4L2 && SND
@@ -316,131 +457,6 @@ config RADIO_ZOLTRIX_PORT
 	help
 	  Enter the I/O port of your Zoltrix radio card.
 
-config I2C_SI4713
-	tristate "I2C driver for Silicon Labs Si4713 device"
-	depends on I2C && VIDEO_V4L2
-	---help---
-	  Say Y here if you want support to Si4713 I2C device.
-	  This device driver supports only i2c bus.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called si4713.
-
-config RADIO_SI4713
-	tristate "Silicon Labs Si4713 FM Radio Transmitter support"
-	depends on I2C && VIDEO_V4L2
-	select I2C_SI4713
-	---help---
-	  Say Y here if you want support to Si4713 FM Radio Transmitter.
-	  This device can transmit audio through FM. It can transmit
-	  RDS and RBDS signals as well. This module is the v4l2 radio
-	  interface for the i2c driver of this device.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called radio-si4713.
-
-config USB_DSBR
-	tristate "D-Link/GemTek USB FM radio support"
-	depends on USB && VIDEO_V4L2
-	---help---
-	  Say Y here if you want to connect this type of radio to your
-	  computer's USB port. Note that the audio is not digital, and
-	  you must connect the line out connector to a sound card or a
-	  set of speakers.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called dsbr100.
-
-config RADIO_SI470X
-	bool "Silicon Labs Si470x FM Radio Receiver support"
-	depends on VIDEO_V4L2
-
-source "drivers/media/radio/si470x/Kconfig"
-
-config USB_MR800
-	tristate "AverMedia MR 800 USB FM radio support"
-	depends on USB && VIDEO_V4L2
-	---help---
-	  Say Y here if you want to connect this type of radio to your
-	  computer's USB port. Note that the audio is not digital, and
-	  you must connect the line out connector to a sound card or a
-	  set of speakers.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called radio-mr800.
-
-config RADIO_TEA5764
-	tristate "TEA5764 I2C FM radio support"
-	depends on I2C && VIDEO_V4L2
-	---help---
-	  Say Y here if you want to use the TEA5764 FM chip found in
-	  EZX phones. This FM chip is present in EZX phones from Motorola,
-	  connected to internal pxa I2C bus.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called radio-tea5764.
-
-config RADIO_TEA5764_XTAL
-	bool "TEA5764 crystal reference"
-	depends on RADIO_TEA5764=y
-	default y
-	help
-	  Say Y here if TEA5764 have a 32768 Hz crystal in circuit, say N
-	  here if TEA5764 reference frequency is connected in FREQIN.
-
-config RADIO_SAA7706H
-	tristate "SAA7706H Car Radio DSP"
-	depends on I2C && VIDEO_V4L2
-	---help---
-	  Say Y here if you want to use the SAA7706H Car radio Digital
-	  Signal Processor, found for instance on the Russellville development
-	  board. On the russellville the device is connected to internal
-	  timberdale I2C bus.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called SAA7706H.
-
-config RADIO_TEF6862
-	tristate "TEF6862 Car Radio Enhanced Selectivity Tuner"
-	depends on I2C && VIDEO_V4L2
-	---help---
-	  Say Y here if you want to use the TEF6862 Car Radio Enhanced
-	  Selectivity Tuner, found for instance on the Russellville development
-	  board. On the russellville the device is connected to internal
-	  timberdale I2C bus.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called TEF6862.
-
-config RADIO_TIMBERDALE
-	tristate "Enable the Timberdale radio driver"
-	depends on MFD_TIMBERDALE && VIDEO_V4L2
-	depends on I2C	# for RADIO_SAA7706H
-	select RADIO_TEF6862
-	select RADIO_SAA7706H
-	---help---
-	  This is a kind of umbrella driver for the Radio Tuner and DSP
-	  found behind the Timberdale FPGA on the Russellville board.
-	  Enabling this driver will automatically select the DSP and tuner.
-
-config RADIO_WL1273
-	tristate "Texas Instruments WL1273 I2C FM Radio"
-	depends on I2C && VIDEO_V4L2
-	select MFD_CORE
-	select MFD_WL1273_CORE
-	select FW_LOADER
-	---help---
-	  Choose Y here if you have this FM radio chip.
-
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux 2 API.  Information on
-	  this API and pointers to "v4l2" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called radio-wl1273.
-
-# TI's ST based wl128x FM radio
-source "drivers/media/radio/wl128x/Kconfig"
+endif # V4L_RADIO_ISA_DRIVERS
 
 endif # RADIO_ADAPTERS
-- 
1.7.6.3

