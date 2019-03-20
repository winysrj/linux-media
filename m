Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BC9C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 13:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 546882184D
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 13:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553089335;
	bh=8ZIwk89cEOzVSdBjMsqSEOWceKyXSdubrVvL7mJOz9g=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=u8+OTr1ZoIb2pZaCuSxHV/8b9DRPL96bM7nt/VDrkrXygCJdsx+nF5xsCHj/e7lnC
	 UyWlAkNDUjpsifQ2K1bxT8CemgZJkisRDB09jXH8QaP0TERumpzs6MLO1dVaurqVm4
	 X1+sQR8mtJniDuNE35+yNODSRKAmtYlgMbz9N+rs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbfCTNmO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 09:42:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfCTNmO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 09:42:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=N4/ue2eTsV8TshBpg7ktLqbY5uqtxScusQO4/lL1ens=; b=CGV1uaIQ9c39s0VbSBel6Dds+
        wh8XK8NfXKbovFN+p8VnIwqDSelfaLQRk88NX7580qXHMmgfEesZsGdlrlQFyaDq/dHOEzWl4u2sV
        sS/EcJke0TFsmMHjCnaKBnLaXnPpQr4aa/UYdJaGtbSx4n3cOq0VILf4nrPTtC3ylh6JxZv0jQh7z
        lTagRHMJFA9ZAluq4q5P/g2mxD7bv6cf/i1NhTNR/UT/nJUGhvqqnJ6/xUlsw46zysuJMDPFNfjjT
        w5XJ/FsF0h6AiJRrCrwg7nV6iYApvbPkrWlDfA2aDIfxvnaCNxuS7TBTB9jWdw2dzf4CH67pn0g0/
        IPfbNaHgg==;
Received: from [179.95.24.146] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h6bTu-0006GQ-Ky; Wed, 20 Mar 2019 13:42:11 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1h6bTq-0009Tg-20; Wed, 20 Mar 2019 09:42:06 -0400
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] media: Kconfig files: use the right help coding style
Date:   Wed, 20 Mar 2019 09:41:59 -0400
Message-Id: <b60a5b8dcf49af9f2c60ae82e0383ee8e62a9a52.1553089314.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Checkpatch wants to use 'help' instead of '---help---':

	WARNING: prefer 'help' over '---help---' for new help texts

Let's change it globally at the media subsystem, as otherwise people
would keep using the old way.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/Kconfig                        |  20 +-
 drivers/media/cec/Kconfig                    |   4 +-
 drivers/media/common/siano/Kconfig           |   4 +-
 drivers/media/i2c/Kconfig                    | 184 +++++++++----------
 drivers/media/i2c/cx25840/Kconfig            |   2 +-
 drivers/media/i2c/et8ek8/Kconfig             |   2 +-
 drivers/media/i2c/m5mols/Kconfig             |   2 +-
 drivers/media/i2c/smiapp/Kconfig             |   2 +-
 drivers/media/mmc/siano/Kconfig              |   2 +-
 drivers/media/pci/bt8xx/Kconfig              |   2 +-
 drivers/media/pci/cobalt/Kconfig             |   2 +-
 drivers/media/pci/cx18/Kconfig               |   4 +-
 drivers/media/pci/cx23885/Kconfig            |   4 +-
 drivers/media/pci/cx25821/Kconfig            |   4 +-
 drivers/media/pci/cx88/Kconfig               |  10 +-
 drivers/media/pci/ddbridge/Kconfig           |   4 +-
 drivers/media/pci/dt3155/Kconfig             |   2 +-
 drivers/media/pci/intel/ipu3/Kconfig         |   2 +-
 drivers/media/pci/ivtv/Kconfig               |  10 +-
 drivers/media/pci/meye/Kconfig               |   2 +-
 drivers/media/pci/netup_unidvb/Kconfig       |   2 +-
 drivers/media/pci/ngene/Kconfig              |   2 +-
 drivers/media/pci/saa7134/Kconfig            |  10 +-
 drivers/media/pci/saa7146/Kconfig            |   6 +-
 drivers/media/pci/saa7164/Kconfig            |   2 +-
 drivers/media/pci/solo6x10/Kconfig           |   2 +-
 drivers/media/pci/tw5864/Kconfig             |   2 +-
 drivers/media/pci/tw68/Kconfig               |   2 +-
 drivers/media/platform/Kconfig               |  72 ++++----
 drivers/media/platform/atmel/Kconfig         |   2 +-
 drivers/media/platform/marvell-ccic/Kconfig  |   4 +-
 drivers/media/platform/omap/Kconfig          |   2 +-
 drivers/media/platform/rcar-vin/Kconfig      |   2 +-
 drivers/media/platform/sti/c8sectpfe/Kconfig |   2 +-
 drivers/media/platform/vimc/Kconfig          |   2 +-
 drivers/media/platform/vivid/Kconfig         |   6 +-
 drivers/media/platform/xilinx/Kconfig        |   6 +-
 drivers/media/radio/Kconfig                  |  54 +++---
 drivers/media/radio/si470x/Kconfig           |   6 +-
 drivers/media/radio/si4713/Kconfig           |   6 +-
 drivers/media/rc/Kconfig                     |  80 ++++----
 drivers/media/rc/keymaps/Kconfig             |   2 +-
 drivers/media/spi/Kconfig                    |   2 +-
 drivers/media/usb/airspy/Kconfig             |   2 +-
 drivers/media/usb/au0828/Kconfig             |   6 +-
 drivers/media/usb/cpia2/Kconfig              |   2 +-
 drivers/media/usb/cx231xx/Kconfig            |   8 +-
 drivers/media/usb/em28xx/Kconfig             |   8 +-
 drivers/media/usb/go7007/Kconfig             |   8 +-
 drivers/media/usb/gspca/Kconfig              |   2 +-
 drivers/media/usb/hackrf/Kconfig             |   2 +-
 drivers/media/usb/hdpvr/Kconfig              |   2 +-
 drivers/media/usb/pulse8-cec/Kconfig         |   2 +-
 drivers/media/usb/pvrusb2/Kconfig            |   8 +-
 drivers/media/usb/pwc/Kconfig                |   4 +-
 drivers/media/usb/rainshadow-cec/Kconfig     |   2 +-
 drivers/media/usb/siano/Kconfig              |   2 +-
 drivers/media/usb/stk1160/Kconfig            |   2 +-
 drivers/media/usb/stkwebcam/Kconfig          |   2 +-
 drivers/media/usb/tm6000/Kconfig             |   4 +-
 drivers/media/usb/usbtv/Kconfig              |   2 +-
 drivers/media/usb/usbvision/Kconfig          |   2 +-
 drivers/media/usb/uvc/Kconfig                |   4 +-
 drivers/media/usb/zr364xx/Kconfig            |   2 +-
 drivers/media/v4l2-core/Kconfig              |   8 +-
 drivers/staging/media/Kconfig                |   2 +-
 drivers/staging/media/bcm2048/Kconfig        |   2 +-
 drivers/staging/media/imx/Kconfig            |   4 +-
 drivers/staging/media/ipu3/Kconfig           |   2 +-
 drivers/staging/media/omap4iss/Kconfig       |   2 +-
 70 files changed, 320 insertions(+), 320 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 102eb35fcf3f..8efaf99243e0 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -31,14 +31,14 @@ comment "Multimedia core support"
 #
 config MEDIA_CAMERA_SUPPORT
 	bool "Cameras/video grabbers support"
-	---help---
+	help
 	  Enable support for webcams and video grabbers.
 
 	  Say Y when you have a webcam or a video capture grabber board.
 
 config MEDIA_ANALOG_TV_SUPPORT
 	bool "Analog TV support"
-	---help---
+	help
 	  Enable analog TV support.
 
 	  Say Y when you have a TV board with analog support or with a
@@ -50,7 +50,7 @@ config MEDIA_ANALOG_TV_SUPPORT
 
 config MEDIA_DIGITAL_TV_SUPPORT
 	bool "Digital TV support"
-	---help---
+	help
 	  Enable digital TV support.
 
 	  Say Y when you have a board with digital support or a board with
@@ -58,7 +58,7 @@ config MEDIA_DIGITAL_TV_SUPPORT
 
 config MEDIA_RADIO_SUPPORT
 	bool "AM/FM radio receivers/transmitters support"
-	---help---
+	help
 	  Enable AM/FM radio support.
 
 	  Additional info and docs are available on the web at
@@ -72,14 +72,14 @@ config MEDIA_RADIO_SUPPORT
 
 config MEDIA_SDR_SUPPORT
 	bool "Software defined radio support"
-	---help---
+	help
 	  Enable software defined radio support.
 
 	  Say Y when you have a software defined radio device.
 
 config MEDIA_CEC_SUPPORT
 	bool "HDMI CEC support"
-	---help---
+	help
 	  Enable support for HDMI CEC (Consumer Electronics Control),
 	  which is an optional HDMI feature.
 
@@ -96,7 +96,7 @@ source "drivers/media/cec/Kconfig"
 config MEDIA_CONTROLLER
 	bool "Media Controller API"
 	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
-	---help---
+	help
 	  Enable the media controller API used to query media devices internal
 	  topology and configure it dynamically.
 
@@ -105,7 +105,7 @@ config MEDIA_CONTROLLER
 config MEDIA_CONTROLLER_DVB
 	bool "Enable Media controller for DVB (EXPERIMENTAL)"
 	depends on MEDIA_CONTROLLER && DVB_CORE
-	---help---
+	help
 	  Enable the media controller API support for DVB.
 
 	  This is currently experimental.
@@ -114,7 +114,7 @@ config MEDIA_CONTROLLER_REQUEST_API
 	bool "Enable Media controller Request API (EXPERIMENTAL)"
 	depends on MEDIA_CONTROLLER && STAGING_MEDIA
 	default n
-	---help---
+	help
 	  DO NOT ENABLE THIS OPTION UNLESS YOU KNOW WHAT YOU'RE DOING.
 
 	  This option enables the Request API for the Media controller and V4L2
@@ -137,7 +137,7 @@ config VIDEO_DEV
 config VIDEO_V4L2_SUBDEV_API
 	bool "V4L2 sub-device userspace API"
 	depends on VIDEO_DEV && MEDIA_CONTROLLER
-	---help---
+	help
 	  Enables the V4L2 sub-device pad-level userspace API used to configure
 	  video format, size and frame rate between hardware blocks.
 
diff --git a/drivers/media/cec/Kconfig b/drivers/media/cec/Kconfig
index 9c2b108c613a..b5aadacf335a 100644
--- a/drivers/media/cec/Kconfig
+++ b/drivers/media/cec/Kconfig
@@ -2,11 +2,11 @@ config MEDIA_CEC_RC
 	bool "HDMI CEC RC integration"
 	depends on CEC_CORE && RC_CORE
 	depends on CEC_CORE=m || RC_CORE=y
-	---help---
+	help
 	  Pass on CEC remote control messages to the RC framework.
 
 config CEC_PIN_ERROR_INJ
 	bool "Enable CEC error injection support"
 	depends on CEC_PIN && DEBUG_FS
-	---help---
+	help
 	  This option enables CEC error injection using debugfs.
diff --git a/drivers/media/common/siano/Kconfig b/drivers/media/common/siano/Kconfig
index 4bfbd5f463d1..577880b133eb 100644
--- a/drivers/media/common/siano/Kconfig
+++ b/drivers/media/common/siano/Kconfig
@@ -15,7 +15,7 @@ config SMS_SIANO_RC
 	depends on SMS_USB_DRV || SMS_SDIO_DRV
 	depends on MEDIA_COMMON_OPTIONS
 	default y
-	---help---
+	help
 	  Choose Y to select Remote Controller support for Siano driver.
 
 config SMS_SIANO_DEBUGFS
@@ -24,7 +24,7 @@ config SMS_SIANO_DEBUGFS
 	depends on DEBUG_FS
 	depends on SMS_USB_DRV = SMS_SDIO_DRV
 
-	---help---
+	help
 	  Choose Y to enable visualizing a dump of the frontend
 	  statistics response packets via debugfs. Currently, works
 	  only with Siano USB devices.
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 1ef6335463c1..1a1746b3db91 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -8,7 +8,7 @@ config VIDEO_IR_I2C
 	tristate "I2C module for IR" if !MEDIA_SUBDRV_AUTOSELECT
 	depends on I2C && RC_CORE
 	default y
-	---help---
+	help
 	  Most boards have an IR chip directly connected via GPIO. However,
 	  some video boards have the IR connected via I2C bus.
 
@@ -29,7 +29,7 @@ comment "Audio decoders, processors and mixers"
 config VIDEO_TVAUDIO
 	tristate "Simple audio decoder chips"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for several audio decoder chips found on some bt8xx boards:
 	  Philips: tda9840, tda9873h, tda9874h/a, tda9850, tda985x, tea6300,
 		   tea6320, tea6420, tda8425, ta8874z.
@@ -41,7 +41,7 @@ config VIDEO_TVAUDIO
 config VIDEO_TDA7432
 	tristate "Philips TDA7432 audio processor"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for tda7432 audio decoder chip found on some bt8xx boards.
 
 	  To compile this driver as a module, choose M here: the
@@ -50,7 +50,7 @@ config VIDEO_TDA7432
 config VIDEO_TDA9840
 	tristate "Philips TDA9840 audio processor"
 	depends on I2C
-	---help---
+	help
 	  Support for tda9840 audio decoder chip found on some Zoran boards.
 
 	  To compile this driver as a module, choose M here: the
@@ -62,7 +62,7 @@ config VIDEO_TDA1997X
 	depends on SND_SOC
 	select SND_PCM
 	select HDMI
-	---help---
+	help
 	  V4L2 subdevice driver for the NXP TDA1997x HDMI receivers.
 
 	  To compile this driver as a module, choose M here: the
@@ -71,7 +71,7 @@ config VIDEO_TDA1997X
 config VIDEO_TEA6415C
 	tristate "Philips TEA6415C audio processor"
 	depends on I2C
-	---help---
+	help
 	  Support for tea6415c audio decoder chip found on some bt8xx boards.
 
 	  To compile this driver as a module, choose M here: the
@@ -80,7 +80,7 @@ config VIDEO_TEA6415C
 config VIDEO_TEA6420
 	tristate "Philips TEA6420 audio processor"
 	depends on I2C
-	---help---
+	help
 	  Support for tea6420 audio decoder chip found on some bt8xx boards.
 
 	  To compile this driver as a module, choose M here: the
@@ -89,7 +89,7 @@ config VIDEO_TEA6420
 config VIDEO_MSP3400
 	tristate "Micronas MSP34xx audio decoders"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Micronas MSP34xx series of audio decoders.
 
 	  To compile this driver as a module, choose M here: the
@@ -98,7 +98,7 @@ config VIDEO_MSP3400
 config VIDEO_CS3308
 	tristate "Cirrus Logic CS3308 audio ADC"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Cirrus Logic CS3308 High Performance 8-Channel
 	  Analog Volume Control
 
@@ -108,7 +108,7 @@ config VIDEO_CS3308
 config VIDEO_CS5345
 	tristate "Cirrus Logic CS5345 audio ADC"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Cirrus Logic CS5345 24-bit, 192 kHz
 	  stereo A/D converter.
 
@@ -118,7 +118,7 @@ config VIDEO_CS5345
 config VIDEO_CS53L32A
 	tristate "Cirrus Logic CS53L32A audio ADC"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Cirrus Logic CS53L32A low voltage
 	  stereo A/D converter.
 
@@ -128,7 +128,7 @@ config VIDEO_CS53L32A
 config VIDEO_TLV320AIC23B
 	tristate "Texas Instruments TLV320AIC23B audio codec"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Texas Instruments TLV320AIC23B audio codec.
 
 	  To compile this driver as a module, choose M here: the
@@ -137,7 +137,7 @@ config VIDEO_TLV320AIC23B
 config VIDEO_UDA1342
 	tristate "Philips UDA1342 audio codec"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Philips UDA1342 audio codec.
 
 	  To compile this driver as a module, choose M here: the
@@ -146,7 +146,7 @@ config VIDEO_UDA1342
 config VIDEO_WM8775
 	tristate "Wolfson Microelectronics WM8775 audio ADC with input mixer"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Wolfson Microelectronics WM8775 high
 	  performance stereo A/D Converter with a 4 channel input mixer.
 
@@ -156,7 +156,7 @@ config VIDEO_WM8775
 config VIDEO_WM8739
 	tristate "Wolfson Microelectronics WM8739 stereo audio ADC"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Wolfson Microelectronics WM8739
 	  stereo A/D Converter.
 
@@ -166,7 +166,7 @@ config VIDEO_WM8739
 config VIDEO_VP27SMPX
 	tristate "Panasonic VP27's internal MPX"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the internal MPX of the Panasonic VP27s tuner.
 
 	  To compile this driver as a module, choose M here: the
@@ -200,7 +200,7 @@ comment "Video decoders"
 config VIDEO_ADV7180
 	tristate "Analog Devices ADV7180 decoder"
 	depends on GPIOLIB && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
-	---help---
+	help
 	  Support for the Analog Devices ADV7180 video decoder.
 
 	  To compile this driver as a module, choose M here: the
@@ -209,7 +209,7 @@ config VIDEO_ADV7180
 config VIDEO_ADV7183
 	tristate "Analog Devices ADV7183 decoder"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  V4l2 subdevice driver for the Analog Devices
 	  ADV7183 video decoder.
 
@@ -222,7 +222,7 @@ config VIDEO_ADV748X
 	depends on OF
 	select REGMAP_I2C
 	select V4L2_FWNODE
-	---help---
+	help
 	  V4L2 subdevice driver for the Analog Devices
 	  ADV7481 and ADV7482 HDMI/Analog video decoders.
 
@@ -235,7 +235,7 @@ config VIDEO_ADV7604
 	depends on GPIOLIB || COMPILE_TEST
 	select HDMI
 	select V4L2_FWNODE
-	---help---
+	help
 	  Support for the Analog Devices ADV7604 video decoder.
 
 	  This is a Analog Devices Component/Graphics Digitizer
@@ -248,7 +248,7 @@ config VIDEO_ADV7604_CEC
 	bool "Enable Analog Devices ADV7604 CEC support"
 	depends on VIDEO_ADV7604
 	select CEC_CORE
-	---help---
+	help
 	  When selected the adv7604 will support the optional
 	  HDMI CEC feature.
 
@@ -256,7 +256,7 @@ config VIDEO_ADV7842
 	tristate "Analog Devices ADV7842 decoder"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	select HDMI
-	---help---
+	help
 	  Support for the Analog Devices ADV7842 video decoder.
 
 	  This is a Analog Devices Component/Graphics/SD Digitizer
@@ -269,14 +269,14 @@ config VIDEO_ADV7842_CEC
 	bool "Enable Analog Devices ADV7842 CEC support"
 	depends on VIDEO_ADV7842
 	select CEC_CORE
-	---help---
+	help
 	  When selected the adv7842 will support the optional
 	  HDMI CEC feature.
 
 config VIDEO_BT819
 	tristate "BT819A VideoStream decoder"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for BT819A video decoder.
 
 	  To compile this driver as a module, choose M here: the
@@ -285,7 +285,7 @@ config VIDEO_BT819
 config VIDEO_BT856
 	tristate "BT856 VideoStream decoder"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for BT856 video decoder.
 
 	  To compile this driver as a module, choose M here: the
@@ -294,7 +294,7 @@ config VIDEO_BT856
 config VIDEO_BT866
 	tristate "BT866 VideoStream decoder"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for BT866 video decoder.
 
 	  To compile this driver as a module, choose M here: the
@@ -303,7 +303,7 @@ config VIDEO_BT866
 config VIDEO_KS0127
 	tristate "KS0127 video decoder"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for KS0127 video decoder.
 
 	  This chip is used on AverMedia AVS6EYES Zoran-based MJPEG
@@ -315,7 +315,7 @@ config VIDEO_KS0127
 config VIDEO_ML86V7667
 	tristate "OKI ML86V7667 video decoder"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the OKI Semiconductor ML86V7667 video decoder.
 
 	  To compile this driver as a module, choose M here: the
@@ -324,7 +324,7 @@ config VIDEO_ML86V7667
 config VIDEO_SAA7110
 	tristate "Philips SAA7110 video decoder"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Philips SAA7110 video decoders.
 
 	  To compile this driver as a module, choose M here: the
@@ -333,7 +333,7 @@ config VIDEO_SAA7110
 config VIDEO_SAA711X
 	tristate "Philips SAA7111/3/4/5 video decoders"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Philips SAA7111/3/4/5 video decoders.
 
 	  To compile this driver as a module, choose M here: the
@@ -344,7 +344,7 @@ config VIDEO_TC358743
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	select HDMI
 	select V4L2_FWNODE
-	---help---
+	help
 	  Support for the Toshiba TC358743 HDMI to MIPI CSI-2 bridge.
 
 	  To compile this driver as a module, choose M here: the
@@ -354,7 +354,7 @@ config VIDEO_TC358743_CEC
 	bool "Enable Toshiba TC358743 CEC support"
 	depends on VIDEO_TC358743
 	select CEC_CORE
-	---help---
+	help
 	  When selected the tc358743 will support the optional
 	  HDMI CEC feature.
 
@@ -362,7 +362,7 @@ config VIDEO_TVP514X
 	tristate "Texas Instruments TVP514x video decoder"
 	depends on VIDEO_V4L2 && I2C
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the TI TVP5146/47
 	  decoder. It is currently working with the TI OMAP3 camera
 	  controller.
@@ -374,7 +374,7 @@ config VIDEO_TVP5150
 	tristate "Texas Instruments TVP5150 video decoder"
 	depends on VIDEO_V4L2 && I2C
 	select V4L2_FWNODE
-	---help---
+	help
 	  Support for the Texas Instruments TVP5150 video decoder.
 
 	  To compile this driver as a module, choose M here: the
@@ -384,7 +384,7 @@ config VIDEO_TVP7002
 	tristate "Texas Instruments TVP7002 video decoder"
 	depends on VIDEO_V4L2 && I2C
 	select V4L2_FWNODE
-	---help---
+	help
 	  Support for the Texas Instruments TVP7002 video decoder.
 
 	  To compile this driver as a module, choose M here: the
@@ -393,7 +393,7 @@ config VIDEO_TVP7002
 config VIDEO_TW2804
 	tristate "Techwell TW2804 multiple video decoder"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Techwell tw2804 multiple video decoder.
 
 	  To compile this driver as a module, choose M here: the
@@ -402,7 +402,7 @@ config VIDEO_TW2804
 config VIDEO_TW9903
 	tristate "Techwell TW9903 video decoder"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Techwell tw9903 multi-standard video decoder
 	  with high quality down scaler.
 
@@ -412,7 +412,7 @@ config VIDEO_TW9903
 config VIDEO_TW9906
 	tristate "Techwell TW9906 video decoder"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Techwell tw9906 enhanced multi-standard comb filter
 	  video decoder with YCbCr input support.
 
@@ -422,7 +422,7 @@ config VIDEO_TW9906
 config VIDEO_TW9910
 	tristate "Techwell TW9910 video decoder"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for Techwell TW9910 NTSC/PAL/SECAM video decoder.
 
 	  To compile this driver as a module, choose M here: the
@@ -431,7 +431,7 @@ config VIDEO_TW9910
 config VIDEO_VPX3220
 	tristate "vpx3220a, vpx3216b & vpx3214c video decoders"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for VPX322x video decoders.
 
 	  To compile this driver as a module, choose M here: the
@@ -442,7 +442,7 @@ comment "Video and audio decoders"
 config VIDEO_SAA717X
 	tristate "Philips SAA7171/3/4 audio/video decoders"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Philips SAA7171/3/4 audio/video decoders.
 
 	  To compile this driver as a module, choose M here: the
@@ -455,7 +455,7 @@ comment "Video encoders"
 config VIDEO_SAA7127
 	tristate "Philips SAA7127/9 digital video encoders"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Philips SAA7127/9 digital video encoders.
 
 	  To compile this driver as a module, choose M here: the
@@ -464,7 +464,7 @@ config VIDEO_SAA7127
 config VIDEO_SAA7185
 	tristate "Philips SAA7185 video encoder"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Philips SAA7185 video encoder.
 
 	  To compile this driver as a module, choose M here: the
@@ -473,7 +473,7 @@ config VIDEO_SAA7185
 config VIDEO_ADV7170
 	tristate "Analog Devices ADV7170 video encoder"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Analog Devices ADV7170 video encoder driver
 
 	  To compile this driver as a module, choose M here: the
@@ -482,7 +482,7 @@ config VIDEO_ADV7170
 config VIDEO_ADV7175
 	tristate "Analog Devices ADV7175 video encoder"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Analog Devices ADV7175 video encoder driver
 
 	  To compile this driver as a module, choose M here: the
@@ -510,7 +510,7 @@ config VIDEO_ADV7511
 	tristate "Analog Devices ADV7511 encoder"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	select HDMI
-	---help---
+	help
 	  Support for the Analog Devices ADV7511 video encoder.
 
 	  This is a Analog Devices HDMI transmitter.
@@ -522,14 +522,14 @@ config VIDEO_ADV7511_CEC
 	bool "Enable Analog Devices ADV7511 CEC support"
 	depends on VIDEO_ADV7511
 	select CEC_CORE
-	---help---
+	help
 	  When selected the adv7511 will support the optional
 	  HDMI CEC feature.
 
 config VIDEO_AD9389B
 	tristate "Analog Devices AD9389B encoder"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
-	---help---
+	help
 	  Support for the Analog Devices AD9389B video encoder.
 
 	  This is a Analog Devices HDMI transmitter.
@@ -546,7 +546,7 @@ config VIDEO_AK881X
 config VIDEO_THS8200
 	tristate "Texas Instruments THS8200 video encoder"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Texas Instruments THS8200 video encoder.
 
 	  To compile this driver as a module, choose M here: the
@@ -576,7 +576,7 @@ config VIDEO_IMX258
 	tristate "Sony IMX258 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the Sony
 	  IMX258 camera.
 
@@ -588,7 +588,7 @@ config VIDEO_IMX274
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	select REGMAP_I2C
-	---help---
+	help
 	  This is a V4L2 sensor driver for the Sony IMX274
 	  CMOS image sensor.
 
@@ -630,7 +630,7 @@ config VIDEO_OV2659
 	depends on VIDEO_V4L2 && I2C
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV2659 camera.
 
@@ -642,7 +642,7 @@ config VIDEO_OV2680
 	depends on VIDEO_V4L2 && I2C && MEDIA_CONTROLLER
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV2680 camera.
 
@@ -654,7 +654,7 @@ config VIDEO_OV2685
 	depends on VIDEO_V4L2 && I2C && MEDIA_CONTROLLER
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV2685 camera.
 
@@ -667,7 +667,7 @@ config VIDEO_OV5640
 	depends on GPIOLIB && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the Omnivision
 	  OV5640 camera sensor with a MIPI CSI-2 interface.
 
@@ -677,7 +677,7 @@ config VIDEO_OV5645
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV5645 camera.
 
@@ -689,7 +689,7 @@ config VIDEO_OV5647
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV5647 camera.
 
@@ -700,7 +700,7 @@ config VIDEO_OV6650
 	tristate "OmniVision OV6650 sensor support"
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV6650 camera.
 
@@ -713,7 +713,7 @@ config VIDEO_OV5670
 	depends on MEDIA_CAMERA_SUPPORT
 	depends on MEDIA_CONTROLLER
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV5670 camera.
 
@@ -724,7 +724,7 @@ config VIDEO_OV5695
 	tristate "OmniVision OV5695 sensor support"
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV5695 camera.
 
@@ -748,7 +748,7 @@ config VIDEO_OV772X
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
 	select REGMAP_SCCB
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV772x camera.
 
@@ -759,7 +759,7 @@ config VIDEO_OV7640
 	tristate "OmniVision OV7640 sensor support"
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV7640 camera.
 
@@ -771,7 +771,7 @@ config VIDEO_OV7670
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV7670 VGA camera.  It currently only works with the M88ALP01
 	  controller.
@@ -780,7 +780,7 @@ config VIDEO_OV7740
 	tristate "OmniVision OV7740 sensor support"
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV7740 VGA camera sensor.
 
@@ -807,7 +807,7 @@ config VIDEO_OV9650
 	tristate "OmniVision OV9650/OV9652 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	select REGMAP_SCCB
-	---help---
+	help
 	  This is a V4L2 sensor driver for the Omnivision
 	  OV9650 and OV9652 camera sensors.
 
@@ -816,7 +816,7 @@ config VIDEO_OV13858
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV13858 camera.
 
@@ -824,7 +824,7 @@ config VIDEO_VS6624
 	tristate "ST VS6624 sensor support"
 	depends on VIDEO_V4L2 && I2C
 	depends on MEDIA_CAMERA_SUPPORT
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the ST VS6624
 	  camera.
 
@@ -844,7 +844,7 @@ config VIDEO_MT9M032
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	select VIDEO_APTINA_PLL
-	---help---
+	help
 	  This driver supports MT9M032 camera sensors from Aptina, monochrome
 	  models only.
 
@@ -861,7 +861,7 @@ config VIDEO_MT9P031
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	select VIDEO_APTINA_PLL
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the Aptina
 	  (Micron) mt9p031 5 Mpixel camera.
 
@@ -869,7 +869,7 @@ config VIDEO_MT9T001
 	tristate "Aptina MT9T001 support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the Aptina
 	  (Micron) mt0t001 3 Mpixel camera.
 
@@ -877,7 +877,7 @@ config VIDEO_MT9T112
 	tristate "Aptina MT9T111/MT9T112 support"
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the Aptina
 	  (Micron) MT9T111 and MT9T112 3 Mpixel camera.
 
@@ -888,7 +888,7 @@ config VIDEO_MT9V011
 	tristate "Micron mt9v011 sensor support"
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the Micron
 	  mt0v011 1.3 Mpixel camera.  It currently only works with the
 	  em28xx driver.
@@ -899,7 +899,7 @@ config VIDEO_MT9V032
 	depends on MEDIA_CAMERA_SUPPORT
 	select REGMAP_I2C
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a Video4Linux2 sensor driver for the Micron
 	  MT9V032 752x480 CMOS sensor.
 
@@ -918,14 +918,14 @@ config VIDEO_SR030PC30
 	tristate "Siliconfile SR030PC30 sensor support"
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
-	---help---
+	help
 	  This driver supports SR030PC30 VGA camera from Siliconfile
 
 config VIDEO_NOON010PC30
 	tristate "Siliconfile NOON010PC30 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
-	---help---
+	help
 	  This driver supports NOON010PC30 CIF camera from Siliconfile
 
 source "drivers/media/i2c/m5mols/Kconfig"
@@ -945,7 +945,7 @@ config VIDEO_S5K6AA
 	tristate "Samsung S5K6AAFX sensor support"
 	depends on MEDIA_CAMERA_SUPPORT
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
-	---help---
+	help
 	  This is a V4L2 sensor driver for Samsung S5K6AA(FX) 1.3M
 	  camera sensor with an embedded SoC image signal processor.
 
@@ -953,7 +953,7 @@ config VIDEO_S5K6A3
 	tristate "Samsung S5K6A3 sensor support"
 	depends on MEDIA_CAMERA_SUPPORT
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
-	---help---
+	help
 	  This is a V4L2 sensor driver for Samsung S5K6A3 raw
 	  camera sensor.
 
@@ -961,7 +961,7 @@ config VIDEO_S5K4ECGX
 	tristate "Samsung S5K4ECGX sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	select CRC32
-	---help---
+	help
 	  This is a V4L2 sensor driver for Samsung S5K4ECGX 5M
 	  camera sensor with an embedded SoC image signal processor.
 
@@ -969,7 +969,7 @@ config VIDEO_S5K5BAF
 	tristate "Samsung S5K5BAF sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a V4L2 sensor driver for Samsung S5K5BAF 2M
 	  camera sensor with an embedded SoC image signal processor.
 
@@ -980,7 +980,7 @@ config VIDEO_S5C73M3
 	tristate "Samsung S5C73M3 sensor support"
 	depends on I2C && SPI && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a V4L2 sensor driver for Samsung S5C73M3
 	  8 Mpixel camera.
 
@@ -989,7 +989,7 @@ comment "Lens drivers"
 config VIDEO_AD5820
 	tristate "AD5820 lens voice coil support"
 	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
-	---help---
+	help
 	  This is a driver for the AD5820 camera lens voice coil.
 	  It is used for example in Nokia N900 (RX-51).
 
@@ -1007,7 +1007,7 @@ config VIDEO_DW9714
 	tristate "DW9714 lens voice coil support"
 	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
 	depends on VIDEO_V4L2_SUBDEV_API
-	---help---
+	help
 	  This is a driver for the DW9714 camera lens voice coil.
 	  DW9714 is a 10 bit DAC with 120mA output current sink
 	  capability. This is designed for linear control of
@@ -1017,7 +1017,7 @@ config VIDEO_DW9807_VCM
 	tristate "DW9807 lens voice coil support"
 	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
 	depends on VIDEO_V4L2_SUBDEV_API
-	---help---
+	help
 	  This is a driver for the DW9807 camera lens voice coil.
 	  DW9807 is a 10 bit DAC with 100mA output current sink
 	  capability. This is designed for linear control of
@@ -1029,7 +1029,7 @@ config VIDEO_ADP1653
 	tristate "ADP1653 flash support"
 	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
 	depends on MEDIA_CAMERA_SUPPORT
-	---help---
+	help
 	  This is a driver for the ADP1653 flash controller. It is used for
 	  example in Nokia N900.
 
@@ -1038,7 +1038,7 @@ config VIDEO_LM3560
 	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
 	depends on MEDIA_CAMERA_SUPPORT
 	select REGMAP_I2C
-	---help---
+	help
 	  This is a driver for the lm3560 dual flash controllers. It controls
 	  flash, torch LEDs.
 
@@ -1047,7 +1047,7 @@ config VIDEO_LM3646
 	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
 	depends on MEDIA_CAMERA_SUPPORT
 	select REGMAP_I2C
-	---help---
+	help
 	  This is a driver for the lm3646 dual flash controllers. It controls
 	  flash, torch LEDs.
 
@@ -1056,7 +1056,7 @@ comment "Video improvement chips"
 config VIDEO_UPD64031A
 	tristate "NEC Electronics uPD64031A Ghost Reduction"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the NEC Electronics uPD64031A Ghost Reduction
 	  video chip. It is most often found in NTSC TV cards made for
 	  Japan and is used to reduce the 'ghosting' effect that can
@@ -1068,7 +1068,7 @@ config VIDEO_UPD64031A
 config VIDEO_UPD64083
 	tristate "NEC Electronics uPD64083 3-Dimensional Y/C separation"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the NEC Electronics uPD64083 3-Dimensional Y/C
 	  separation video chip. It is used to improve the quality of
 	  the colors of a composite signal.
@@ -1082,7 +1082,7 @@ config VIDEO_SAA6752HS
 	tristate "Philips SAA6752HS MPEG-2 Audio/Video Encoder"
 	depends on VIDEO_V4L2 && I2C
 	select CRC32
-	---help---
+	help
 	  Support for the Philips SAA6752HS MPEG-2 video and MPEG-audio/AC-3
 	  audio encoder with multiplexer.
 
@@ -1094,7 +1094,7 @@ comment "SDR tuner chips"
 config SDR_MAX2175
 	tristate "Maxim 2175 RF to Bits tuner"
 	depends on VIDEO_V4L2 && MEDIA_SDR_SUPPORT && I2C
-	---help---
+	help
 	  Support for Maxim 2175 tuner. It is an advanced analog/digital
 	  radio receiver with RF-to-Bits front-end designed for SDR solutions.
 
@@ -1115,7 +1115,7 @@ config VIDEO_THS7303
 config VIDEO_M52790
 	tristate "Mitsubishi M52790 A/V switch"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	 Support for the Mitsubishi M52790 A/V switch.
 
 	 To compile this driver as a module, choose M here: the
@@ -1126,7 +1126,7 @@ config VIDEO_I2C
 	depends on VIDEO_V4L2 && I2C
 	select VIDEOBUF2_VMALLOC
 	imply HWMON
-	---help---
+	help
 	  Enable the I2C transport video support which supports the
 	  following:
 	   * Panasonic AMG88xx Grid-Eye Sensors
diff --git a/drivers/media/i2c/cx25840/Kconfig b/drivers/media/i2c/cx25840/Kconfig
index 451133ad41ff..f4b31d7cb440 100644
--- a/drivers/media/i2c/cx25840/Kconfig
+++ b/drivers/media/i2c/cx25840/Kconfig
@@ -1,7 +1,7 @@
 config VIDEO_CX25840
 	tristate "Conexant CX2584x audio/video decoders"
 	depends on VIDEO_V4L2 && I2C
-	---help---
+	help
 	  Support for the Conexant CX2584x audio/video decoders.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/media/i2c/et8ek8/Kconfig b/drivers/media/i2c/et8ek8/Kconfig
index 9fe409e95666..ab23b41bf353 100644
--- a/drivers/media/i2c/et8ek8/Kconfig
+++ b/drivers/media/i2c/et8ek8/Kconfig
@@ -2,6 +2,6 @@ config VIDEO_ET8EK8
 	tristate "ET8EK8 camera sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a driver for the Toshiba ET8EK8 5 MP camera sensor.
 	  It is used for example in Nokia N900 (RX-51).
diff --git a/drivers/media/i2c/m5mols/Kconfig b/drivers/media/i2c/m5mols/Kconfig
index dc8c2505907e..be0bb3f1bc22 100644
--- a/drivers/media/i2c/m5mols/Kconfig
+++ b/drivers/media/i2c/m5mols/Kconfig
@@ -2,5 +2,5 @@ config VIDEO_M5MOLS
 	tristate "Fujitsu M-5MOLS 8MP sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
-	---help---
+	help
 	  This driver supports Fujitsu M-5MOLS camera sensor with ISP
diff --git a/drivers/media/i2c/smiapp/Kconfig b/drivers/media/i2c/smiapp/Kconfig
index f59718d8e51e..26b54f2aa95b 100644
--- a/drivers/media/i2c/smiapp/Kconfig
+++ b/drivers/media/i2c/smiapp/Kconfig
@@ -4,5 +4,5 @@ config VIDEO_SMIAPP
 	depends on MEDIA_CAMERA_SUPPORT
 	select VIDEO_SMIAPP_PLL
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a generic driver for SMIA++/SMIA camera modules.
diff --git a/drivers/media/mmc/siano/Kconfig b/drivers/media/mmc/siano/Kconfig
index 7693487e2f63..3941ee8352bb 100644
--- a/drivers/media/mmc/siano/Kconfig
+++ b/drivers/media/mmc/siano/Kconfig
@@ -9,5 +9,5 @@ config SMS_SDIO_DRV
 	depends on !RC_CORE || RC_CORE
 	select MEDIA_COMMON_OPTIONS
 	select SMS_SIANO_MDTV
-	---help---
+	help
 	  Choose if you would like to have Siano's support for SDIO interface
diff --git a/drivers/media/pci/bt8xx/Kconfig b/drivers/media/pci/bt8xx/Kconfig
index bc89e37608cd..0f46db7d5ffc 100644
--- a/drivers/media/pci/bt8xx/Kconfig
+++ b/drivers/media/pci/bt8xx/Kconfig
@@ -13,7 +13,7 @@ config VIDEO_BT848
 	select VIDEO_SAA6588 if MEDIA_SUBDRV_AUTOSELECT
 	select RADIO_ADAPTERS
 	select RADIO_TEA575X
-	---help---
+	help
 	  Support for BT848 based frame grabber/overlay boards. This includes
 	  the Miro, Hauppauge and STB boards. Please read the material in
 	  <file:Documentation/media/v4l-drivers/bttv.rst> for more information.
diff --git a/drivers/media/pci/cobalt/Kconfig b/drivers/media/pci/cobalt/Kconfig
index aa35cbc0a904..9a544bab3178 100644
--- a/drivers/media/pci/cobalt/Kconfig
+++ b/drivers/media/pci/cobalt/Kconfig
@@ -11,7 +11,7 @@ config VIDEO_COBALT
 	select VIDEO_ADV7511
 	select VIDEO_ADV7842
 	select VIDEOBUF2_DMA_SG
-	---help---
+	help
 	  This is a video4linux driver for the Cisco PCIe Cobalt card.
 
 	  This board is sadly not available outside of Cisco, but it is
diff --git a/drivers/media/pci/cx18/Kconfig b/drivers/media/pci/cx18/Kconfig
index c675b83c43a9..96477bba0d5c 100644
--- a/drivers/media/pci/cx18/Kconfig
+++ b/drivers/media/pci/cx18/Kconfig
@@ -13,7 +13,7 @@ config VIDEO_CX18
 	select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  This is a video4linux driver for Conexant cx23418 based
 	  PCI combo video recorder devices.
 
@@ -27,7 +27,7 @@ config VIDEO_CX18_ALSA
 	tristate "Conexant 23418 DMA audio support"
 	depends on VIDEO_CX18 && SND
 	select SND_PCM
-	---help---
+	help
 	  This is a video4linux driver for direct (DMA) audio on
 	  Conexant 23418 based TV cards using ALSA.
 
diff --git a/drivers/media/pci/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
index 3435bbaa3167..1bba9e497915 100644
--- a/drivers/media/pci/cx23885/Kconfig
+++ b/drivers/media/pci/cx23885/Kconfig
@@ -43,7 +43,7 @@ config VIDEO_CX23885
 	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_M88RS6000T if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TUNER_DIB0070 if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  This is a video4linux driver for Conexant 23885 based
 	  TV cards.
 
@@ -54,7 +54,7 @@ config MEDIA_ALTERA_CI
 	tristate "Altera FPGA based CI module"
 	depends on VIDEO_CX23885 && DVB_CORE
 	select ALTERA_STAPL
-	---help---
+	help
 	  An Altera FPGA CI module for NetUP Dual DVB-T/C RF CI card.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/media/pci/cx25821/Kconfig b/drivers/media/pci/cx25821/Kconfig
index 1755d3d2feaa..a64fa9a6d5d5 100644
--- a/drivers/media/pci/cx25821/Kconfig
+++ b/drivers/media/pci/cx25821/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_CX25821
 	depends on VIDEO_DEV && PCI && I2C
 	select I2C_ALGOBIT
 	select VIDEOBUF2_DMA_SG
-	---help---
+	help
 	  This is a video4linux driver for Conexant 25821 based
 	  TV cards.
 
@@ -14,7 +14,7 @@ config VIDEO_CX25821_ALSA
 	tristate "Conexant 25821 DMA audio support"
 	depends on VIDEO_CX25821 && SND
 	select SND_PCM
-	---help---
+	help
 	  This is a video4linux driver for direct (DMA) audio on
 	  Conexant 25821 based capture cards using ALSA.
 
diff --git a/drivers/media/pci/cx88/Kconfig b/drivers/media/pci/cx88/Kconfig
index 14b813d634a8..fbb17ddb6bc3 100644
--- a/drivers/media/pci/cx88/Kconfig
+++ b/drivers/media/pci/cx88/Kconfig
@@ -6,7 +6,7 @@ config VIDEO_CX88
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_WM8775 if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  This is a video4linux driver for Conexant 2388x based
 	  TV cards.
 
@@ -17,7 +17,7 @@ config VIDEO_CX88_ALSA
 	tristate "Conexant 2388x DMA audio support"
 	depends on VIDEO_CX88 && SND
 	select SND_PCM
-	---help---
+	help
 	  This is a video4linux driver for direct (DMA) audio on
 	  Conexant 2388x based TV cards using ALSA.
 
@@ -33,7 +33,7 @@ config VIDEO_CX88_BLACKBIRD
 	tristate "Blackbird MPEG encoder support (cx2388x + cx23416)"
 	depends on VIDEO_CX88
 	select VIDEO_CX2341X
-	---help---
+	help
 	  This adds support for MPEG encoder cards based on the
 	  Blackbird reference design, using the Conexant 2388x
 	  and 23416 chips.
@@ -64,7 +64,7 @@ config VIDEO_CX88_DVB
 	select DVB_DS3000 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TS2020 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  This adds support for DVB/ATSC cards based on the
 	  Conexant 2388x chip.
 
@@ -75,7 +75,7 @@ config VIDEO_CX88_ENABLE_VP3054
 	bool "VP-3054 Secondary I2C Bus Support"
 	default y
 	depends on VIDEO_CX88_DVB && DVB_MT352
-	---help---
+	help
 	  This adds DVB-T support for cards based on the
 	  Conexant 2388x chip and the MT352 demodulator,
 	  which also require support for the VP-3054
diff --git a/drivers/media/pci/ddbridge/Kconfig b/drivers/media/pci/ddbridge/Kconfig
index 16faef265e97..fc98b6d575d9 100644
--- a/drivers/media/pci/ddbridge/Kconfig
+++ b/drivers/media/pci/ddbridge/Kconfig
@@ -15,7 +15,7 @@ config DVB_DDBRIDGE
 	select DVB_MXL5XX if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_CXD2099 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DUMMY_FE if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  Support for cards with the Digital Devices PCI express bridge:
 	  - Octopus PCIe Bridge
 	  - Octopus mini PCIe Bridge
@@ -36,7 +36,7 @@ config DVB_DDBRIDGE_MSIENABLE
 	depends on DVB_DDBRIDGE
 	depends on PCI_MSI
 	default n
-	---help---
+	help
 	  Use PCI MSI (Message Signaled Interrupts) per default. Enabling this
 	  might lead to I2C errors originating from the bridge in conjunction
 	  with certain SATA controllers, requiring a reload of the ddbridge
diff --git a/drivers/media/pci/dt3155/Kconfig b/drivers/media/pci/dt3155/Kconfig
index 858b0f2f15be..d770eec541d4 100644
--- a/drivers/media/pci/dt3155/Kconfig
+++ b/drivers/media/pci/dt3155/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_DT3155
 	depends on PCI && VIDEO_DEV && VIDEO_V4L2
 	select VIDEOBUF2_DMA_CONTIG
 	default n
-	---help---
+	help
 	  Enables dt3155 device driver for the DataTranslation DT3155 frame grabber.
 	  Say Y here if you have this hardware.
 	  In doubt, say N.
diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
index 715f77651482..bd518bdc9f5f 100644
--- a/drivers/media/pci/intel/ipu3/Kconfig
+++ b/drivers/media/pci/intel/ipu3/Kconfig
@@ -7,7 +7,7 @@ config VIDEO_IPU3_CIO2
 	select V4L2_FWNODE
 	select VIDEOBUF2_DMA_SG
 
-	---help---
+	help
 	  This is the Intel IPU3 CIO2 CSI-2 receiver unit, found in Intel
 	  Skylake and Kaby Lake SoCs and used for capturing images and
 	  video from a camera sensor.
diff --git a/drivers/media/pci/ivtv/Kconfig b/drivers/media/pci/ivtv/Kconfig
index 06ca4e23f9fb..e96b3c182a2f 100644
--- a/drivers/media/pci/ivtv/Kconfig
+++ b/drivers/media/pci/ivtv/Kconfig
@@ -18,7 +18,7 @@ config VIDEO_IVTV
 	select VIDEO_VP27SMPX
 	select VIDEO_UPD64031A
 	select VIDEO_UPD64083
-	---help---
+	help
 	  This is a video4linux driver for Conexant cx23416 or cx23415 based
 	  PCI personal video recorder devices.
 
@@ -32,7 +32,7 @@ config VIDEO_IVTV_DEPRECATED_IOCTLS
 	bool "enable the DVB ioctls abuse on ivtv driver"
 	depends on VIDEO_IVTV
 	default n
-	---help---
+	help
 	  Enable the usage of the a DVB set of ioctls that were abused by
 	  IVTV driver for a while.
 
@@ -45,7 +45,7 @@ config VIDEO_IVTV_ALSA
 	tristate "Conexant cx23415/cx23416 ALSA interface for PCM audio capture"
 	depends on VIDEO_IVTV && SND
 	select SND_PCM
-	---help---
+	help
 	  This driver provides an ALSA interface as another method for user
 	  applications to obtain PCM audio data from Conexant cx23415/cx23416
 	  based PCI TV cards supported by the ivtv driver.
@@ -63,7 +63,7 @@ config VIDEO_FB_IVTV
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	---help---
+	help
 	  This is a framebuffer driver for the Conexant cx23415 MPEG
 	  encoder/decoder.
 
@@ -77,7 +77,7 @@ config VIDEO_FB_IVTV_FORCE_PAT
 	bool "force cx23415 framebuffer init with x86 PAT enabled"
 	depends on VIDEO_FB_IVTV && X86_PAT
 	default n
-	---help---
+	help
 	  With PAT enabled, the cx23415 framebuffer driver does not
 	  utilize write-combined caching on the framebuffer memory.
 	  For this reason, the driver will by default disable itself
diff --git a/drivers/media/pci/meye/Kconfig b/drivers/media/pci/meye/Kconfig
index 9a50f54231ad..ce0463c81886 100644
--- a/drivers/media/pci/meye/Kconfig
+++ b/drivers/media/pci/meye/Kconfig
@@ -2,7 +2,7 @@ config VIDEO_MEYE
 	tristate "Sony Vaio Picturebook Motion Eye Video For Linux"
 	depends on PCI && VIDEO_V4L2
 	depends on SONY_LAPTOP || COMPILE_TEST
-	---help---
+	help
 	  This is the video4linux driver for the Motion Eye camera found
 	  in the Vaio Picturebook laptops. Please read the material in
 	  <file:Documentation/media/v4l-drivers/meye.rst> for more information.
diff --git a/drivers/media/pci/netup_unidvb/Kconfig b/drivers/media/pci/netup_unidvb/Kconfig
index b663154d0cc4..60057585f04c 100644
--- a/drivers/media/pci/netup_unidvb/Kconfig
+++ b/drivers/media/pci/netup_unidvb/Kconfig
@@ -8,7 +8,7 @@ config DVB_NETUP_UNIDVB
 	select DVB_HELENE if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_LNBH25 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_CXD2841ER if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  Support for NetUP PCI express Universal DVB card.
 
 	  Say Y when you want to support NetUP Dual Universal DVB card.
diff --git a/drivers/media/pci/ngene/Kconfig b/drivers/media/pci/ngene/Kconfig
index e06d019996f3..8a80a5bab8e9 100644
--- a/drivers/media/pci/ngene/Kconfig
+++ b/drivers/media/pci/ngene/Kconfig
@@ -15,6 +15,6 @@ config DVB_NGENE
 	select DVB_STV6111 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_LNBH25 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_CXD2099 if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  Support for Micronas PCI express cards with nGene bridge.
 
diff --git a/drivers/media/pci/saa7134/Kconfig b/drivers/media/pci/saa7134/Kconfig
index b44e0d70907e..8b28783b3fcd 100644
--- a/drivers/media/pci/saa7134/Kconfig
+++ b/drivers/media/pci/saa7134/Kconfig
@@ -7,7 +7,7 @@ config VIDEO_SAA7134
 	select CRC32
 	select VIDEO_SAA6588 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_SAA6752HS if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  This is a video4linux driver for Philips SAA713x based
 	  TV cards.
 
@@ -18,7 +18,7 @@ config VIDEO_SAA7134_ALSA
 	tristate "Philips SAA7134 DMA audio support"
 	depends on VIDEO_SAA7134 && SND
 	select SND_PCM
-	---help---
+	help
 	  This is a video4linux driver for direct (DMA) audio in
 	  Philips SAA713x based TV cards using ALSA
 
@@ -31,7 +31,7 @@ config VIDEO_SAA7134_RC
 	depends on VIDEO_SAA7134
 	depends on !(RC_CORE=m && VIDEO_SAA7134=y)
 	default y
-	---help---
+	help
 	  Enables Remote Controller support on saa7134 driver.
 
 config VIDEO_SAA7134_DVB
@@ -57,7 +57,7 @@ config VIDEO_SAA7134_DVB
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_ZL10039 if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  This adds support for DVB cards based on the
 	  Philips saa7134 chip.
 
@@ -68,6 +68,6 @@ config VIDEO_SAA7134_GO7007
 	tristate "go7007 support for saa7134 based TV cards"
 	depends on VIDEO_SAA7134
 	depends on VIDEO_GO7007
-	---help---
+	help
 	  Enables saa7134 driver support for boards with go7007
 	  MPEG encoder (WIS Voyager or compatible).
diff --git a/drivers/media/pci/saa7146/Kconfig b/drivers/media/pci/saa7146/Kconfig
index da88b77a916c..60d9862580ff 100644
--- a/drivers/media/pci/saa7146/Kconfig
+++ b/drivers/media/pci/saa7146/Kconfig
@@ -2,7 +2,7 @@ config VIDEO_HEXIUM_GEMINI
 	tristate "Hexium Gemini frame grabber"
 	depends on PCI && VIDEO_V4L2 && I2C
 	select VIDEO_SAA7146_VV
-	---help---
+	help
 	  This is a video4linux driver for the Hexium Gemini frame
 	  grabber card by Hexium. Please note that the Gemini Dual
 	  card is *not* fully supported.
@@ -14,7 +14,7 @@ config VIDEO_HEXIUM_ORION
 	tristate "Hexium HV-PCI6 and Orion frame grabber"
 	depends on PCI && VIDEO_V4L2 && I2C
 	select VIDEO_SAA7146_VV
-	---help---
+	help
 	  This is a video4linux driver for the Hexium HV-PCI6 and
 	  Orion frame grabber cards by Hexium.
 
@@ -30,7 +30,7 @@ config VIDEO_MXB
 	select VIDEO_TDA9840 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_TEA6415C if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_TEA6420 if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  This is a video4linux driver for the 'Multimedia eXtension Board'
 	  TV card by Siemens-Nixdorf.
 
diff --git a/drivers/media/pci/saa7164/Kconfig b/drivers/media/pci/saa7164/Kconfig
index 9098ef5feca4..265c5a4fd823 100644
--- a/drivers/media/pci/saa7164/Kconfig
+++ b/drivers/media/pci/saa7164/Kconfig
@@ -8,7 +8,7 @@ config VIDEO_SAA7164
 	select DVB_TDA10048 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  This is a video4linux driver for NXP SAA7164 based
 	  TV cards.
 
diff --git a/drivers/media/pci/solo6x10/Kconfig b/drivers/media/pci/solo6x10/Kconfig
index d9e06a6bf1eb..2061d02a82d0 100644
--- a/drivers/media/pci/solo6x10/Kconfig
+++ b/drivers/media/pci/solo6x10/Kconfig
@@ -8,7 +8,7 @@ config VIDEO_SOLO6X10
 	select VIDEOBUF2_DMA_CONTIG
 	select SND_PCM
 	select FONT_8x16
-	---help---
+	help
 	  This driver supports the Bluecherry H.264 and MPEG-4 hardware
 	  compression capture cards and other Softlogic-based ones.
 
diff --git a/drivers/media/pci/tw5864/Kconfig b/drivers/media/pci/tw5864/Kconfig
index 760fb11dfeae..e5d52f076232 100644
--- a/drivers/media/pci/tw5864/Kconfig
+++ b/drivers/media/pci/tw5864/Kconfig
@@ -2,7 +2,7 @@ config VIDEO_TW5864
 	tristate "Techwell TW5864 video/audio grabber and encoder"
 	depends on VIDEO_DEV && PCI && VIDEO_V4L2
 	select VIDEOBUF2_DMA_CONTIG
-	---help---
+	help
 	  Support for boards based on Techwell TW5864 chip which provides
 	  multichannel video & audio grabbing and encoding (H.264, MJPEG,
 	  ADPCM G.726).
diff --git a/drivers/media/pci/tw68/Kconfig b/drivers/media/pci/tw68/Kconfig
index 95d5d5202048..4bfc4fa416e5 100644
--- a/drivers/media/pci/tw68/Kconfig
+++ b/drivers/media/pci/tw68/Kconfig
@@ -2,7 +2,7 @@ config VIDEO_TW68
 	tristate "Techwell tw68x Video For Linux"
 	depends on VIDEO_DEV && PCI && VIDEO_V4L2
 	select VIDEOBUF2_DMA_SG
-	---help---
+	help
 	  Support for Techwell tw68xx based frame grabber boards.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 4acbed189644..1611ec23d733 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -6,7 +6,7 @@ menuconfig V4L_PLATFORM_DRIVERS
 	bool "V4L platform devices"
 	depends on MEDIA_CAMERA_SUPPORT
 	default n
-	---help---
+	help
 	  Say Y here to enable support for platform-specific V4L drivers.
 
 if V4L_PLATFORM_DRIVERS
@@ -55,7 +55,7 @@ config VIDEO_VIU
 	depends on VIDEO_V4L2 && (PPC_MPC512x || COMPILE_TEST) && I2C
 	select VIDEOBUF_DMA_CONTIG
 	default y
-	---help---
+	help
 	  Support for Freescale VIU video driver. This device captures
 	  video data, or overlays video on DIU frame buffer.
 
@@ -80,13 +80,13 @@ config VIDEO_OMAP3
 	select VIDEOBUF2_DMA_CONTIG
 	select MFD_SYSCON
 	select V4L2_FWNODE
-	---help---
+	help
 	  Driver for an OMAP 3 camera controller.
 
 config VIDEO_OMAP3_DEBUG
 	bool "OMAP 3 Camera debug messages"
 	depends on VIDEO_OMAP3
-	---help---
+	help
 	  Enable debug messages on OMAP 3 camera controller driver.
 
 config VIDEO_PXA27x
@@ -96,7 +96,7 @@ config VIDEO_PXA27x
 	select VIDEOBUF2_DMA_SG
 	select SG_SPLIT
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a v4l2 driver for the PXA27x Quick Capture Interface
 
 config VIDEO_QCOM_CAMSS
@@ -112,7 +112,7 @@ config VIDEO_S3C_CAMIF
 	depends on PM
 	depends on ARCH_S3C64XX || PLAT_S3C24XX || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
-	---help---
+	help
 	  This is a v4l2 driver for s3c24xx and s3c64xx SoC series camera
 	  host interface (CAMIF).
 
@@ -125,7 +125,7 @@ config VIDEO_STM32_DCMI
 	depends on ARCH_STM32 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
-	---help---
+	help
 	  This module makes the STM32 Digital Camera Memory Interface (DCMI)
 	  available as a v4l2 device.
 
@@ -138,7 +138,7 @@ config VIDEO_RENESAS_CEU
 	depends on ARCH_SHMOBILE || ARCH_R7S72100 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
-	---help---
+	help
 	  This is a v4l2 driver for the Renesas CEU Interface
 
 source "drivers/media/platform/exynos4-is/Kconfig"
@@ -155,7 +155,7 @@ config VIDEO_TI_CAL
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
 	default n
-	---help---
+	help
 	  Support for the TI CAL (Camera Adaptation Layer) block
 	  found on DRA72X SoC.
 	  In TI Technical Reference Manual this module is referred as
@@ -168,7 +168,7 @@ menuconfig V4L_MEM2MEM_DRIVERS
 	depends on VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
 	default n
-	---help---
+	help
 	  Say Y here to enable selecting drivers for V4L devices that
 	  use system memory for both source and destination buffers, as opposed
 	  to capture and output drivers, which use memory buffers for just
@@ -184,7 +184,7 @@ config VIDEO_CODA
 	select VIDEOBUF2_VMALLOC
 	select V4L2_MEM2MEM_DEV
 	select GENERIC_ALLOCATOR
-	---help---
+	help
 	   Coda is a range of video codec IPs that supports
 	   H.264, MPEG-4, and other video formats.
 
@@ -207,7 +207,7 @@ config VIDEO_MEDIATEK_JPEG
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-	---help---
+	help
 	  Mediatek jpeg codec driver provides HW capability to decode
 	  JPEG format
 
@@ -218,7 +218,7 @@ config VIDEO_MEDIATEK_VPU
 	tristate "Mediatek Video Processor Unit"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	---help---
+	help
 	    This driver provides downloading VPU firmware and
 	    communicating with VPU. This driver for hw video
 	    codec embedded in Mediatek's MT8173 SOCs. It is able
@@ -236,7 +236,7 @@ config VIDEO_MEDIATEK_MDP
 	select V4L2_MEM2MEM_DEV
 	select VIDEO_MEDIATEK_VPU
 	default n
-	---help---
+	help
 	    It is a v4l2 driver and present in Mediatek MT8173 SoCs.
 	    The driver supports for scaling and color space conversion.
 
@@ -252,7 +252,7 @@ config VIDEO_MEDIATEK_VCODEC
 	select V4L2_MEM2MEM_DEV
 	select VIDEO_MEDIATEK_VPU
 	default n
-	---help---
+	help
 	    Mediatek video codec driver provides HW capability to
 	    encode and decode in a range of video formats
 	    This driver rely on VPU driver to communicate with VPU.
@@ -276,7 +276,7 @@ config VIDEO_SAMSUNG_S5P_G2D
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	default n
-	---help---
+	help
 	  This is a v4l2 driver for Samsung S5P and EXYNOS4 G2D
 	  2d graphics accelerator.
 
@@ -286,7 +286,7 @@ config VIDEO_SAMSUNG_S5P_JPEG
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-	---help---
+	help
 	  This is a v4l2 driver for Samsung S5P, EXYNOS3250
 	  and EXYNOS4 JPEG codec
 
@@ -407,7 +407,7 @@ config VIDEO_RENESAS_FDP1
 	depends on (!ARM64 && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-	---help---
+	help
 	  This is a V4L2 driver for the Renesas Fine Display Processor
 	  providing colour space conversion, and de-interlacing features.
 
@@ -420,7 +420,7 @@ config VIDEO_RENESAS_JPU
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-	---help---
+	help
 	  This is a V4L2 driver for the Renesas JPEG Processing Unit.
 
 	  To compile this driver as a module, choose M here: the module
@@ -430,7 +430,7 @@ config VIDEO_RENESAS_FCP
 	tristate "Renesas Frame Compression Processor"
 	depends on ARCH_RENESAS || COMPILE_TEST
 	depends on OF
-	---help---
+	help
 	  This is a driver for the Renesas Frame Compression Processor (FCP).
 	  The FCP is a companion module of video processing modules in the
 	  Renesas R-Car Gen3 SoCs. It handles memory access for the codec,
@@ -446,7 +446,7 @@ config VIDEO_RENESAS_VSP1
 	depends on (!ARM64 && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_VMALLOC
-	---help---
+	help
 	  This is a V4L2 driver for the Renesas VSP1 video processing engine.
 
 	  To compile this driver as a module, choose M here: the module
@@ -459,7 +459,7 @@ config VIDEO_ROCKCHIP_RGA
 	select VIDEOBUF2_DMA_SG
 	select V4L2_MEM2MEM_DEV
 	default n
-	---help---
+	help
 	  This is a v4l2 driver for Rockchip SOC RGA 2d graphics accelerator.
 	  Rockchip RGA is a separate 2D raster graphic acceleration unit.
 	  It accelerates 2D graphics operations, such as point/line drawing,
@@ -477,14 +477,14 @@ config VIDEO_TI_VPE
 	select VIDEO_TI_SC
 	select VIDEO_TI_CSC
 	default n
-	---help---
+	help
 	  Support for the TI VPE(Video Processing Engine) block
 	  found on DRA7XX SoC.
 
 config VIDEO_TI_VPE_DEBUG
 	bool "VPE debug messages"
 	depends on VIDEO_TI_VPE
-	---help---
+	help
 	  Enable debug messages on VPE driver.
 
 config VIDEO_QCOM_VENUS
@@ -495,7 +495,7 @@ config VIDEO_QCOM_VENUS
 	select QCOM_SCM if ARCH_QCOM
 	select VIDEOBUF2_DMA_SG
 	select V4L2_MEM2MEM_DEV
-	---help---
+	help
 	  This is a V4L2 driver for Qualcomm Venus video accelerator
 	  hardware. It accelerates encoding and decoding operations
 	  on various Qualcomm SoCs.
@@ -530,7 +530,7 @@ config VIDEO_VIM2M
 	select VIDEOBUF2_VMALLOC
 	select V4L2_MEM2MEM_DEV
 	default n
-	---help---
+	help
 	  This is a virtual test device for the memory-to-memory driver
 	  framework.
 
@@ -542,7 +542,7 @@ menuconfig DVB_PLATFORM_DRIVERS
 	bool "DVB platform devices"
 	depends on MEDIA_DIGITAL_TV_SUPPORT
 	default n
-	---help---
+	help
 	  Say Y here to enable support for platform-specific Digital TV drivers.
 
 if DVB_PLATFORM_DRIVERS
@@ -562,7 +562,7 @@ config VIDEO_CROS_EC_CEC
 	select CEC_NOTIFIER
 	select CHROME_PLATFORMS
 	select CROS_EC_PROTO
-	---help---
+	help
 	  If you say yes here you will get support for the
 	  ChromeOS Embedded Controller's CEC.
 	  The CEC bus is present in the HDMI connector and enables communication
@@ -573,7 +573,7 @@ config VIDEO_MESON_AO_CEC
 	depends on ARCH_MESON || COMPILE_TEST
 	select CEC_CORE
 	select CEC_NOTIFIER
-	---help---
+	help
 	  This is a driver for Amlogic Meson SoCs AO CEC interface. It uses the
 	  generic CEC framework interface.
 	  CEC bus is present in the HDMI connector and enables communication
@@ -584,7 +584,7 @@ config CEC_GPIO
 	select CEC_CORE
 	select CEC_PIN
 	select GPIOLIB
-	---help---
+	help
 	  This is a generic GPIO-based CEC driver.
 	  The CEC bus is present in the HDMI connector and enables communication
 	  between compatible devices.
@@ -594,7 +594,7 @@ config VIDEO_SAMSUNG_S5P_CEC
        depends on ARCH_EXYNOS || COMPILE_TEST
        select CEC_CORE
        select CEC_NOTIFIER
-       ---help---
+       help
 	 This is a driver for Samsung S5P HDMI CEC interface. It uses the
 	 generic CEC framework interface.
 	 CEC bus is present in the HDMI connector and enables communication
@@ -605,7 +605,7 @@ config VIDEO_STI_HDMI_CEC
        depends on ARCH_STI || COMPILE_TEST
        select CEC_CORE
        select CEC_NOTIFIER
-       ---help---
+       help
 	 This is a driver for STIH4xx HDMI CEC interface. It uses the
 	 generic CEC framework interface.
 	 CEC bus is present in the HDMI connector and enables communication
@@ -617,7 +617,7 @@ config VIDEO_STM32_HDMI_CEC
        select REGMAP
        select REGMAP_MMIO
        select CEC_CORE
-       ---help---
+       help
 	 This is a driver for STM32 interface. It uses the
 	 generic CEC framework interface.
 	 CEC bus is present in the HDMI connector and enables communication
@@ -628,7 +628,7 @@ config VIDEO_TEGRA_HDMI_CEC
        depends on ARCH_TEGRA || COMPILE_TEST
        select CEC_CORE
        select CEC_NOTIFIER
-       ---help---
+       help
 	 This is a driver for the Tegra HDMI CEC interface. It uses the
 	 generic CEC framework interface.
 	 The CEC bus is present in the HDMI connector and enables communication
@@ -662,7 +662,7 @@ menuconfig SDR_PLATFORM_DRIVERS
 	bool "SDR platform devices"
 	depends on MEDIA_SDR_SUPPORT
 	default n
-	---help---
+	help
 	  Say Y here to enable support for platform-specific SDR Drivers.
 
 if SDR_PLATFORM_DRIVERS
@@ -672,7 +672,7 @@ config VIDEO_RCAR_DRIF
 	depends on VIDEO_V4L2
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_VMALLOC
-	---help---
+	help
 	  Say Y if you want to enable R-Car Gen3 DRIF support. DRIF is Digital
 	  Radio Interface that interfaces with an RF front end chip. It is a
 	  receiver of digital data which uses DMA to transfer received data to
diff --git a/drivers/media/platform/atmel/Kconfig b/drivers/media/platform/atmel/Kconfig
index a211ef20f77e..c3f6a47cdc0e 100644
--- a/drivers/media/platform/atmel/Kconfig
+++ b/drivers/media/platform/atmel/Kconfig
@@ -15,6 +15,6 @@ config VIDEO_ATMEL_ISI
 	depends on ARCH_AT91 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
-	---help---
+	help
 	  This module makes the ATMEL Image Sensor Interface available
 	  as a v4l2 device.
diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
index cf12e077203a..cd88e2eed749 100644
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -5,7 +5,7 @@ config VIDEO_CAFE_CCIC
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_DMA_SG
-	---help---
+	help
 	  This is a video4linux2 driver for the Marvell 88ALP01 integrated
 	  CMOS camera controller.  This is the controller found on first-
 	  generation OLPC systems.
@@ -19,7 +19,7 @@ config VIDEO_MMP_CAMERA
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_DMA_SG
-	---help---
+	help
 	  This is a Video4Linux2 driver for the integrated camera
 	  controller found on Marvell Armada 610 application
 	  processors (and likely beyond).  This is the controller found
diff --git a/drivers/media/platform/omap/Kconfig b/drivers/media/platform/omap/Kconfig
index 4b5e55d41ad4..30ce2ba120a1 100644
--- a/drivers/media/platform/omap/Kconfig
+++ b/drivers/media/platform/omap/Kconfig
@@ -14,5 +14,5 @@ config VIDEO_OMAP2_VOUT
 	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3
 	select FRAME_VECTOR
 	default n
-	---help---
+	help
 	  V4L2 Display driver support for OMAP2/3 based boards.
diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
index e3eb8fee2536..2433ec960010 100644
--- a/drivers/media/platform/rcar-vin/Kconfig
+++ b/drivers/media/platform/rcar-vin/Kconfig
@@ -17,7 +17,7 @@ config VIDEO_RCAR_VIN
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
-	---help---
+	help
 	  Support for Renesas R-Car Video Input (VIN) driver.
 	  Supports R-Car Gen2 and Gen3 SoCs.
 
diff --git a/drivers/media/platform/sti/c8sectpfe/Kconfig b/drivers/media/platform/sti/c8sectpfe/Kconfig
index 7420a50572d3..93eaabfd5437 100644
--- a/drivers/media/platform/sti/c8sectpfe/Kconfig
+++ b/drivers/media/platform/sti/c8sectpfe/Kconfig
@@ -12,7 +12,7 @@ config DVB_C8SECTPFE
 	select DVB_STV0367 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
 
-	---help---
+	help
 	  This adds support for DVB front-end cards connected
 	  to TS inputs of STiH407/410 SoC.
 
diff --git a/drivers/media/platform/vimc/Kconfig b/drivers/media/platform/vimc/Kconfig
index 71c9fe7d3370..1de9bc9aa49b 100644
--- a/drivers/media/platform/vimc/Kconfig
+++ b/drivers/media/platform/vimc/Kconfig
@@ -4,7 +4,7 @@ config VIDEO_VIMC
 	select VIDEOBUF2_VMALLOC
 	select VIDEO_V4L2_TPG
 	default n
-	---help---
+	help
 	  Skeleton driver for Virtual Media Controller
 
 	  This driver can be compared to the vivid driver for emulating
diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
index 154de92dd809..4b51d4d6cf93 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -11,7 +11,7 @@ config VIDEO_VIVID
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEO_V4L2_TPG
 	default n
-	---help---
+	help
 	  Enables a virtual video driver. This driver emulates a webcam,
 	  TV, S-Video and HDMI capture hardware, including VBI support for
 	  the SDTV inputs. Also video output, VBI output, radio receivers,
@@ -28,7 +28,7 @@ config VIDEO_VIVID_CEC
 	bool "Enable CEC emulation support"
 	depends on VIDEO_VIVID
 	select CEC_CORE
-	---help---
+	help
 	  When selected the vivid module will emulate the optional
 	  HDMI CEC feature.
 
@@ -36,6 +36,6 @@ config VIDEO_VIVID_MAX_DEVS
 	int "Maximum number of devices"
 	depends on VIDEO_VIVID
 	default "64"
-	---help---
+	help
 	  This allows you to specify the maximum number of devices supported
 	  by the vivid driver.
diff --git a/drivers/media/platform/xilinx/Kconfig b/drivers/media/platform/xilinx/Kconfig
index 74ec8aaa5ae0..a2773ad7c185 100644
--- a/drivers/media/platform/xilinx/Kconfig
+++ b/drivers/media/platform/xilinx/Kconfig
@@ -5,7 +5,7 @@ config VIDEO_XILINX
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
-	---help---
+	help
 	  Driver for Xilinx Video IP Pipelines
 
 if VIDEO_XILINX
@@ -14,13 +14,13 @@ config VIDEO_XILINX_TPG
 	tristate "Xilinx Video Test Pattern Generator"
 	depends on VIDEO_XILINX
 	select VIDEO_XILINX_VTC
-	---help---
+	help
 	   Driver for the Xilinx Video Test Pattern Generator
 
 config VIDEO_XILINX_VTC
 	tristate "Xilinx Video Timing Controller"
 	depends on VIDEO_XILINX
-	---help---
+	help
 	   Driver for the Xilinx Video Timing Controller
 
 endif #VIDEO_XILINX
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 9b99dfb2d0c6..9cd00f64af32 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -7,7 +7,7 @@ menuconfig RADIO_ADAPTERS
 	depends on VIDEO_V4L2
 	depends on MEDIA_RADIO_SUPPORT
 	default y
-	---help---
+	help
 	  Say Y here to enable selecting AM/FM radio adapters.
 
 if RADIO_ADAPTERS && VIDEO_V4L2
@@ -29,7 +29,7 @@ config RADIO_SI476X
 	depends on MFD_SI476X_CORE
 	depends on SND_SOC
 	select SND_SOC_SI476X
-	---help---
+	help
 	  Choose Y here if you have this FM radio chip.
 
 	  In order to control your radio card, you will need to use programs
@@ -43,7 +43,7 @@ config RADIO_SI476X
 config USB_MR800
 	tristate "AverMedia MR 800 USB FM radio support"
 	depends on USB && VIDEO_V4L2
-	---help---
+	help
 	  Say Y here if you want to connect this type of radio to your
 	  computer's USB port. Note that the audio is not digital, and
 	  you must connect the line out connector to a sound card or a
@@ -55,7 +55,7 @@ config USB_MR800
 config USB_DSBR
 	tristate "D-Link/GemTek USB FM radio support"
 	depends on USB && VIDEO_V4L2
-	---help---
+	help
 	  Say Y here if you want to connect this type of radio to your
 	  computer's USB port. Note that the audio is not digital, and
 	  you must connect the line out connector to a sound card or a
@@ -68,7 +68,7 @@ config RADIO_MAXIRADIO
 	tristate "Guillemot MAXI Radio FM 2000 radio"
 	depends on VIDEO_V4L2 && PCI
 	select RADIO_TEA575X
-	---help---
+	help
 	  Choose Y here if you have this radio card.  This card may also be
 	  found as Gemtek PCI FM.
 
@@ -84,7 +84,7 @@ config RADIO_SHARK
 	tristate "Griffin radioSHARK USB radio receiver"
 	depends on USB
 	select RADIO_TEA575X
-	---help---
+	help
 	  Choose Y here if you have this radio receiver.
 
 	  There are 2 versions of this device, this driver is for version 1,
@@ -101,7 +101,7 @@ config RADIO_SHARK
 config RADIO_SHARK2
 	tristate "Griffin radioSHARK2 USB radio receiver"
 	depends on USB
-	---help---
+	help
 	  Choose Y here if you have this radio receiver.
 
 	  There are 2 versions of this device, this driver is for version 2,
@@ -118,7 +118,7 @@ config RADIO_SHARK2
 config USB_KEENE
 	tristate "Keene FM Transmitter USB support"
 	depends on USB && VIDEO_V4L2
-	---help---
+	help
 	  Say Y here if you want to connect this type of FM transmitter
 	  to your computer's USB port.
 
@@ -128,7 +128,7 @@ config USB_KEENE
 config USB_RAREMONO
 	tristate "Thanko's Raremono AM/FM/SW radio support"
 	depends on USB && VIDEO_V4L2
-	---help---
+	help
 	  The 'Thanko's Raremono' device contains the Si4734 chip from Silicon Labs Inc.
 	  It is one of the very few or perhaps the only consumer USB radio device
 	  to receive the AM/FM/SW bands.
@@ -142,7 +142,7 @@ config USB_RAREMONO
 config USB_MA901
 	tristate "Masterkit MA901 USB FM radio support"
 	depends on USB && VIDEO_V4L2
-	---help---
+	help
 	  Say Y here if you want to connect this type of radio to your
 	  computer's USB port. Note that the audio is not digital, and
 	  you must connect the line out connector to a sound card or a
@@ -154,7 +154,7 @@ config USB_MA901
 config RADIO_TEA5764
 	tristate "TEA5764 I2C FM radio support"
 	depends on I2C && VIDEO_V4L2
-	---help---
+	help
 	  Say Y here if you want to use the TEA5764 FM chip found in
 	  EZX phones. This FM chip is present in EZX phones from Motorola,
 	  connected to internal pxa I2C bus.
@@ -173,7 +173,7 @@ config RADIO_TEA5764_XTAL
 config RADIO_SAA7706H
 	tristate "SAA7706H Car Radio DSP"
 	depends on I2C && VIDEO_V4L2
-	---help---
+	help
 	  Say Y here if you want to use the SAA7706H Car radio Digital
 	  Signal Processor, found for instance on the Russellville development
 	  board. On the russellville the device is connected to internal
@@ -185,7 +185,7 @@ config RADIO_SAA7706H
 config RADIO_TEF6862
 	tristate "TEF6862 Car Radio Enhanced Selectivity Tuner"
 	depends on I2C && VIDEO_V4L2
-	---help---
+	help
 	  Say Y here if you want to use the TEF6862 Car Radio Enhanced
 	  Selectivity Tuner, found for instance on the Russellville development
 	  board. On the russellville the device is connected to internal
@@ -200,7 +200,7 @@ config RADIO_TIMBERDALE
 	depends on I2C	# for RADIO_SAA7706H
 	select RADIO_TEF6862
 	select RADIO_SAA7706H
-	---help---
+	help
 	  This is a kind of umbrella driver for the Radio Tuner and DSP
 	  found behind the Timberdale FPGA on the Russellville board.
 	  Enabling this driver will automatically select the DSP and tuner.
@@ -211,7 +211,7 @@ config RADIO_WL1273
 	select MFD_CORE
 	select MFD_WL1273_CORE
 	select FW_LOADER
-	---help---
+	help
 	  Choose Y here if you have this FM radio chip.
 
 	  In order to control your radio card, you will need to use programs
@@ -233,7 +233,7 @@ menuconfig V4L_RADIO_ISA_DRIVERS
 	bool "ISA radio devices"
 	depends on ISA || COMPILE_TEST
 	default n
-	---help---
+	help
 	  Say Y here to enable support for these ISA drivers.
 
 if V4L_RADIO_ISA_DRIVERS
@@ -246,7 +246,7 @@ config RADIO_CADET
 	tristate "ADS Cadet AM/FM Tuner"
 	depends on ISA || COMPILE_TEST
 	depends on VIDEO_V4L2
-	---help---
+	help
 	  Choose Y here if you have one of these AM/FM radio cards, and then
 	  fill in the port address below.
 
@@ -258,7 +258,7 @@ config RADIO_RTRACK
 	depends on ISA || COMPILE_TEST
 	depends on VIDEO_V4L2
 	select RADIO_ISA
-	---help---
+	help
 	  Choose Y here if you have one of these FM radio cards, and then fill
 	  in the port address below.
 
@@ -290,7 +290,7 @@ config RADIO_RTRACK2
 	depends on ISA || COMPILE_TEST
 	depends on VIDEO_V4L2
 	select RADIO_ISA
-	---help---
+	help
 	  Choose Y here if you have this FM radio card, and then fill in the
 	  port address below.
 
@@ -314,7 +314,7 @@ config RADIO_AZTECH
 	depends on ISA || COMPILE_TEST
 	depends on VIDEO_V4L2
 	select RADIO_ISA
-	---help---
+	help
 	  Choose Y here if you have one of these FM radio cards, and then fill
 	  in the port address below.
 
@@ -335,7 +335,7 @@ config RADIO_GEMTEK
 	depends on ISA || COMPILE_TEST
 	depends on VIDEO_V4L2
 	select RADIO_ISA
-	---help---
+	help
 	  Choose Y here if you have this FM radio card, and then fill in the
 	  I/O port address and settings below. The following cards either have
 	  GemTek Radio tuner or are rebranded GemTek Radio cards:
@@ -377,7 +377,7 @@ config RADIO_MIROPCM20
 	depends on ISA_DMA_API && VIDEO_V4L2 && SND
 	select SND_ISA
 	select SND_MIRO
-	---help---
+	help
 	  Choose Y here if you have this FM radio card. You also need to enable
 	  the ALSA sound system. This choice automatically selects the ALSA
 	  sound card driver "Miro miroSOUND PCM1pro/PCM12/PCM20radio" as this
@@ -390,7 +390,7 @@ config RADIO_SF16FMI
 	tristate "SF16-FMI/SF16-FMP/SF16-FMD Radio"
 	depends on ISA || COMPILE_TEST
 	depends on VIDEO_V4L2
-	---help---
+	help
 	  Choose Y here if you have one of these FM radio cards.
 
 	  To compile this driver as a module, choose M here: the
@@ -401,7 +401,7 @@ config RADIO_SF16FMR2
 	depends on ISA || COMPILE_TEST
 	depends on VIDEO_V4L2
 	select RADIO_TEA575X
-	---help---
+	help
 	  Choose Y here if you have one of these FM radio cards.
 
 	  To compile this driver as a module, choose M here: the
@@ -412,7 +412,7 @@ config RADIO_TERRATEC
 	depends on ISA || COMPILE_TEST
 	depends on VIDEO_V4L2
 	select RADIO_ISA
-	---help---
+	help
 	  Choose Y here if you have this FM radio card.
 
 	  Note: this driver hasn't been tested since a long time due to lack
@@ -451,7 +451,7 @@ config RADIO_TYPHOON
 	depends on ISA || COMPILE_TEST
 	depends on VIDEO_V4L2
 	select RADIO_ISA
-	---help---
+	help
 	  Choose Y here if you have one of these FM radio cards, and then fill
 	  in the port address and the frequency used for muting below.
 
@@ -486,7 +486,7 @@ config RADIO_ZOLTRIX
 	depends on ISA || COMPILE_TEST
 	depends on VIDEO_V4L2
 	select RADIO_ISA
-	---help---
+	help
 	  Choose Y here if you have one of these FM radio cards, and then fill
 	  in the port address below.
 
diff --git a/drivers/media/radio/si470x/Kconfig b/drivers/media/radio/si470x/Kconfig
index 6dbb158cd2a0..21026488de90 100644
--- a/drivers/media/radio/si470x/Kconfig
+++ b/drivers/media/radio/si470x/Kconfig
@@ -1,7 +1,7 @@
 config RADIO_SI470X
         tristate "Silicon Labs Si470x FM Radio Receiver support"
         depends on VIDEO_V4L2
-	---help---
+	help
 	  This is a driver for devices with the Silicon Labs SI470x
 	  chip (either via USB or I2C buses).
 
@@ -15,7 +15,7 @@ config RADIO_SI470X
 config USB_SI470X
 	tristate "Silicon Labs Si470x FM Radio Receiver support with USB"
 	depends on USB && RADIO_SI470X
-	---help---
+	help
 	  This is a driver for USB devices with the Silicon Labs SI470x
 	  chip. Currently these devices are known to work:
 	  - 10c4:818a: Silicon Labs USB FM Radio Reference Design
@@ -40,7 +40,7 @@ config USB_SI470X
 config I2C_SI470X
 	tristate "Silicon Labs Si470x FM Radio Receiver support with I2C"
 	depends on I2C && RADIO_SI470X
-	---help---
+	help
 	  This is a driver for I2C devices with the Silicon Labs SI470x
 	  chip.
 
diff --git a/drivers/media/radio/si4713/Kconfig b/drivers/media/radio/si4713/Kconfig
index 9c8b887cff75..17567c917554 100644
--- a/drivers/media/radio/si4713/Kconfig
+++ b/drivers/media/radio/si4713/Kconfig
@@ -2,7 +2,7 @@ config USB_SI4713
 	tristate "Silicon Labs Si4713 FM Radio Transmitter support with USB"
 	depends on USB && I2C && RADIO_SI4713
 	select I2C_SI4713
-	---help---
+	help
 	  This is a driver for USB devices with the Silicon Labs SI4713
 	  chip. Currently these devices are known to work.
 	  - 10c4:8244: Silicon Labs FM Transmitter USB device.
@@ -17,7 +17,7 @@ config PLATFORM_SI4713
 	tristate "Silicon Labs Si4713 FM Radio Transmitter support with I2C"
 	depends on I2C && RADIO_SI4713
 	select I2C_SI4713
-	---help---
+	help
 	  This is a driver for I2C devices with the Silicon Labs SI4713
 	  chip.
 
@@ -30,7 +30,7 @@ config PLATFORM_SI4713
 config I2C_SI4713
 	tristate "Silicon Labs Si4713 FM Radio Transmitter support"
 	depends on I2C && RADIO_SI4713
-	---help---
+	help
 	  Say Y here if you want support to Si4713 FM Radio Transmitter.
 	  This device can transmit audio through FM. It can transmit
 	  RDS and RBDS signals as well. This module is the v4l2 radio
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 96ce3e5524e0..3fc6ac15c66d 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -2,7 +2,7 @@
 menuconfig RC_CORE
 	tristate "Remote Controller support"
 	depends on INPUT
-	---help---
+	help
 	  Enable support for Remote Controllers on Linux. This is
 	  needed in order to support several video capture adapters,
 	  standalone IR receivers/transmitters, and RF receivers.
@@ -19,7 +19,7 @@ source "drivers/media/rc/keymaps/Kconfig"
 config LIRC
 	bool "LIRC user interface"
 	depends on RC_CORE
-	---help---
+	help
 	   Enable this option to enable the Linux Infrared Remote
 	   Control user interface (e.g. /dev/lirc*). This interface
 	   passes raw IR to and from userspace, which is needed for
@@ -48,7 +48,7 @@ config IR_NEC_DECODER
 	depends on RC_CORE
 	select BITREVERSE
 
-	---help---
+	help
 	   Enable this option if you have IR with NEC protocol, and
 	   if the IR is decoded in software
 
@@ -57,7 +57,7 @@ config IR_RC5_DECODER
 	depends on RC_CORE
 	select BITREVERSE
 
-	---help---
+	help
 	   Enable this option if you have IR with RC-5 protocol, and
 	   if the IR is decoded in software
 
@@ -66,7 +66,7 @@ config IR_RC6_DECODER
 	depends on RC_CORE
 	select BITREVERSE
 
-	---help---
+	help
 	   Enable this option if you have an infrared remote control which
 	   uses the RC6 protocol, and you need software decoding support.
 
@@ -75,7 +75,7 @@ config IR_JVC_DECODER
 	depends on RC_CORE
 	select BITREVERSE
 
-	---help---
+	help
 	   Enable this option if you have an infrared remote control which
 	   uses the JVC protocol, and you need software decoding support.
 
@@ -84,7 +84,7 @@ config IR_SONY_DECODER
 	depends on RC_CORE
 	select BITREVERSE
 
-	---help---
+	help
 	   Enable this option if you have an infrared remote control which
 	   uses the Sony protocol, and you need software decoding support.
 
@@ -92,7 +92,7 @@ config IR_SANYO_DECODER
 	tristate "Enable IR raw decoder for the Sanyo protocol"
 	depends on RC_CORE
 
-	---help---
+	help
 	   Enable this option if you have an infrared remote control which
 	   uses the Sanyo protocol (Sanyo, Aiwa, Chinon remotes),
 	   and you need software decoding support.
@@ -101,7 +101,7 @@ config IR_SHARP_DECODER
 	tristate "Enable IR raw decoder for the Sharp protocol"
 	depends on RC_CORE
 
-	---help---
+	help
 	   Enable this option if you have an infrared remote control which
 	   uses the Sharp protocol (Sharp, Denon), and you need software
 	   decoding support.
@@ -111,7 +111,7 @@ config IR_MCE_KBD_DECODER
 	depends on RC_CORE
 	select BITREVERSE
 
-	---help---
+	help
 	   Enable this option if you have a Microsoft Remote Keyboard for
 	   Windows Media Center Edition, which you would like to use with
 	   a raw IR receiver in your system.
@@ -121,14 +121,14 @@ config IR_XMP_DECODER
 	depends on RC_CORE
 	select BITREVERSE
 
-	---help---
+	help
 	   Enable this option if you have IR with XMP protocol, and
 	   if the IR is decoded in software
 
 config IR_IMON_DECODER
 	tristate "Enable IR raw decoder for the iMON protocol"
 	depends on RC_CORE
-	---help---
+	help
 	   Enable this option if you have iMON PAD or Antec Veris infrared
 	   remote control and you would like to use it with a raw IR
 	   receiver, or if you wish to use an encoder to transmit this IR.
@@ -177,7 +177,7 @@ config IR_ENE
 	tristate "ENE eHome Receiver/Transceiver (pnp id: ENE0100/ENE02xxx)"
 	depends on PNP || COMPILE_TEST
 	depends on RC_CORE
-	---help---
+	help
 	   Say Y here to enable support for integrated infrared receiver
 	   /transceiver made by ENE.
 
@@ -203,7 +203,7 @@ config IR_IMON
 	depends on USB_ARCH_HAS_HCD
 	depends on RC_CORE
 	select USB
-	---help---
+	help
 	   Say Y here if you want to use a SoundGraph iMON (aka Antec Veris)
 	   IR Receiver and/or LCD/VFD/VGA display.
 
@@ -215,7 +215,7 @@ config IR_IMON_RAW
 	depends on USB_ARCH_HAS_HCD
 	depends on RC_CORE
 	select USB
-	---help---
+	help
 	   Say Y here if you want to use a SoundGraph iMON IR Receiver,
 	   early raw models.
 
@@ -227,7 +227,7 @@ config IR_MCEUSB
 	depends on USB_ARCH_HAS_HCD
 	depends on RC_CORE
 	select USB
-	---help---
+	help
 	   Say Y here if you want to use a Windows Media Center Edition
 	   eHome Infrared Transceiver.
 
@@ -238,7 +238,7 @@ config IR_ITE_CIR
 	tristate "ITE Tech Inc. IT8712/IT8512 Consumer Infrared Transceiver"
 	depends on PNP || COMPILE_TEST
 	depends on RC_CORE
-	---help---
+	help
 	   Say Y here to enable support for integrated infrared receivers
 	   /transceivers made by ITE Tech Inc. These are found in
 	   several ASUS devices, like the ASUS Digimatrix or the ASUS
@@ -251,7 +251,7 @@ config IR_FINTEK
 	tristate "Fintek Consumer Infrared Transceiver"
 	depends on PNP || COMPILE_TEST
 	depends on RC_CORE
-	---help---
+	help
 	   Say Y here to enable support for integrated infrared receiver
 	   /transceiver made by Fintek. This chip is found on assorted
 	   Jetway motherboards (and of course, possibly others).
@@ -263,7 +263,7 @@ config IR_MESON
 	tristate "Amlogic Meson IR remote receiver"
 	depends on RC_CORE
 	depends on ARCH_MESON || COMPILE_TEST
-	---help---
+	help
 	   Say Y if you want to use the IR remote receiver available
 	   on Amlogic Meson SoCs.
 
@@ -274,7 +274,7 @@ config IR_MTK
 	tristate "Mediatek IR remote receiver"
 	depends on RC_CORE
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	---help---
+	help
 	   Say Y if you want to use the IR remote receiver available
 	   on Mediatek SoCs.
 
@@ -285,7 +285,7 @@ config IR_NUVOTON
 	tristate "Nuvoton w836x7hg Consumer Infrared Transceiver"
 	depends on PNP || COMPILE_TEST
 	depends on RC_CORE
-	---help---
+	help
 	   Say Y here to enable support for integrated infrared receiver
 	   /transceiver made by Nuvoton (formerly Winbond). This chip is
 	   found in the ASRock ION 330HT, as well as assorted Intel
@@ -301,7 +301,7 @@ config IR_REDRAT3
 	select NEW_LEDS
 	select LEDS_CLASS
 	select USB
-	---help---
+	help
 	   Say Y here if you want to use a RedRat3 Infrared Transceiver.
 
 	   To compile this driver as a module, choose M here: the
@@ -311,7 +311,7 @@ config IR_SPI
 	tristate "SPI connected IR LED"
 	depends on SPI && LIRC
 	depends on OF || COMPILE_TEST
-	---help---
+	help
 	  Say Y if you want to use an IR LED connected through SPI bus.
 
 	  To compile this driver as a module, choose M here: the module will be
@@ -322,7 +322,7 @@ config IR_STREAMZAP
 	depends on USB_ARCH_HAS_HCD
 	depends on RC_CORE
 	select USB
-	---help---
+	help
 	   Say Y here if you want to use a Streamzap PC Remote
 	   Infrared Receiver.
 
@@ -336,7 +336,7 @@ config IR_WINBOND_CIR
 	select NEW_LEDS
 	select LEDS_CLASS
 	select BITREVERSE
-	---help---
+	help
 	   Say Y here if you want to use the IR remote functionality found
 	   in some Winbond SuperI/O chips. Currently only the WPCD376I
 	   chip is supported (included in some Intel Media series
@@ -350,7 +350,7 @@ config IR_IGORPLUGUSB
 	depends on USB_ARCH_HAS_HCD
 	depends on RC_CORE
 	select USB
-	---help---
+	help
 	   Say Y here if you want to use the IgorPlug-USB IR Receiver by
 	   Igor Cesko. This device is included on the Fit-PC2.
 
@@ -365,7 +365,7 @@ config IR_IGUANA
 	depends on USB_ARCH_HAS_HCD
 	depends on RC_CORE
 	select USB
-	---help---
+	help
 	   Say Y here if you want to use the IguanaWorks USB IR Transceiver.
 	   Both infrared receive and send are supported. If you want to
 	   change the ID or the pin config, use the user space driver from
@@ -383,7 +383,7 @@ config IR_TTUSBIR
 	select USB
 	select NEW_LEDS
 	select LEDS_CLASS
-	---help---
+	help
 	   Say Y here if you want to use the TechnoTrend USB IR Receiver. The
 	   driver can control the led.
 
@@ -393,7 +393,7 @@ config IR_TTUSBIR
 config IR_RX51
 	tristate "Nokia N900 IR transmitter diode"
 	depends on (OMAP_DM_TIMER && PWM_OMAP_DMTIMER && ARCH_OMAP2PLUS || COMPILE_TEST) && RC_CORE
-	---help---
+	help
 	   Say Y or M here if you want to enable support for the IR
 	   transmitter diode built in the Nokia N900 (RX51) device.
 
@@ -405,7 +405,7 @@ source "drivers/media/rc/img-ir/Kconfig"
 config RC_LOOPBACK
 	tristate "Remote Control Loopback Driver"
 	depends on RC_CORE
-	---help---
+	help
 	   Say Y here if you want support for the remote control loopback
 	   driver which allows TX data to be sent back as RX data.
 	   This is mostly useful for debugging purposes.
@@ -419,7 +419,7 @@ config IR_GPIO_CIR
 	tristate "GPIO IR remote control"
 	depends on RC_CORE
 	depends on (OF && GPIOLIB) || COMPILE_TEST
-	---help---
+	help
 	   Say Y if you want to use GPIO based IR Receiver.
 
 	   To compile this driver as a module, choose M here: the module will
@@ -430,7 +430,7 @@ config IR_GPIO_TX
 	depends on RC_CORE
 	depends on LIRC
 	depends on (OF && GPIOLIB) || COMPILE_TEST
-	---help---
+	help
 	   Say Y if you want to a GPIO based IR transmitter. This is a
 	   bit banging driver.
 
@@ -443,7 +443,7 @@ config IR_PWM_TX
 	depends on LIRC
 	depends on PWM
 	depends on OF || COMPILE_TEST
-	---help---
+	help
 	   Say Y if you want to use a PWM based IR transmitter. This is
 	   more power efficient than the bit banging gpio driver.
 
@@ -454,7 +454,7 @@ config RC_ST
 	tristate "ST remote control receiver"
 	depends on RC_CORE
 	depends on ARCH_STI || COMPILE_TEST
-	---help---
+	help
 	   Say Y here if you want support for ST remote control driver
 	   which allows both IR and UHF RX.
 	   The driver passes raw pulse and space information to the LIRC decoder.
@@ -465,7 +465,7 @@ config IR_SUNXI
 	tristate "SUNXI IR remote control"
 	depends on RC_CORE
 	depends on ARCH_SUNXI || COMPILE_TEST
-	---help---
+	help
 	   Say Y if you want to use sunXi internal IR Controller
 
 	   To compile this driver as a module, choose M here: the module will
@@ -474,7 +474,7 @@ config IR_SUNXI
 config IR_SERIAL
 	tristate "Homebrew Serial Port Receiver"
 	depends on RC_CORE
-	---help---
+	help
 	   Say Y if you want to use Homebrew Serial Port Receivers and
 	   Transceivers.
 
@@ -484,13 +484,13 @@ config IR_SERIAL
 config IR_SERIAL_TRANSMITTER
 	bool "Serial Port Transmitter"
 	depends on IR_SERIAL
-	---help---
+	help
 	   Serial Port Transmitter support
 
 config IR_SIR
 	tristate "Built-in SIR IrDA port"
 	depends on RC_CORE
-	---help---
+	help
 	   Say Y if you want to use a IrDA SIR port Transceivers.
 
 	   To compile this driver as a module, choose M here: the module will
@@ -500,7 +500,7 @@ config IR_TANGO
 	tristate "Sigma Designs SMP86xx IR decoder"
 	depends on RC_CORE
 	depends on ARCH_TANGO || COMPILE_TEST
-	---help---
+	help
 	   Adds support for the HW IR decoder embedded on Sigma Designs
 	   Tango-based systems (SMP86xx, SMP87xx).
 	   The HW decoder supports NEC, RC-5, RC-6 IR protocols.
@@ -522,7 +522,7 @@ config IR_ZX
 	tristate "ZTE ZX IR remote control"
 	depends on RC_CORE
 	depends on ARCH_ZX || COMPILE_TEST
-	---help---
+	help
 	   Say Y if you want to use the IR remote control available
 	   on ZTE ZX family SoCs.
 
diff --git a/drivers/media/rc/keymaps/Kconfig b/drivers/media/rc/keymaps/Kconfig
index 767423bbbdd0..f459096d8e9c 100644
--- a/drivers/media/rc/keymaps/Kconfig
+++ b/drivers/media/rc/keymaps/Kconfig
@@ -3,7 +3,7 @@ config RC_MAP
 	depends on RC_CORE
 	default y
 
-	---help---
+	help
 	   This option enables the compilation of lots of Remote
 	   Controller tables. They are short tables, but if you
 	   don't use a remote controller, or prefer to load the
diff --git a/drivers/media/spi/Kconfig b/drivers/media/spi/Kconfig
index b07ac86fc53c..df169ecf0c27 100644
--- a/drivers/media/spi/Kconfig
+++ b/drivers/media/spi/Kconfig
@@ -6,7 +6,7 @@ menu "SPI helper chips"
 config VIDEO_GS1662
 	tristate "Gennum Serializers video"
 	depends on SPI && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
-	---help---
+	help
 	  Enable the GS1662 driver which serializes video streams.
 
 endmenu
diff --git a/drivers/media/usb/airspy/Kconfig b/drivers/media/usb/airspy/Kconfig
index 10b204cf4dbc..67578511bb9a 100644
--- a/drivers/media/usb/airspy/Kconfig
+++ b/drivers/media/usb/airspy/Kconfig
@@ -2,7 +2,7 @@ config USB_AIRSPY
 	tristate "AirSpy"
 	depends on VIDEO_V4L2
 	select VIDEOBUF2_VMALLOC
-	---help---
+	help
 	  This is a video4linux2 driver for AirSpy SDR device.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/media/usb/au0828/Kconfig b/drivers/media/usb/au0828/Kconfig
index 65fc067eb864..ab4092bdff69 100644
--- a/drivers/media/usb/au0828/Kconfig
+++ b/drivers/media/usb/au0828/Kconfig
@@ -9,7 +9,7 @@ config VIDEO_AU0828
 	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MXL5007T if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  This is a hybrid analog/digital tv capture driver for
 	  Auvitek's AU0828 USB device.
 
@@ -23,7 +23,7 @@ config VIDEO_AU0828_V4L2
 	select DVB_AU8522_V4L if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_TUNER
 	default y
-	---help---
+	help
 	  This is a video4linux driver for Auvitek's USB device.
 
 	  Choose Y here to include support for v4l2 analog video
@@ -34,5 +34,5 @@ config VIDEO_AU0828_RC
 	depends on RC_CORE
 	depends on !(RC_CORE=m && VIDEO_AU0828=y)
 	depends on VIDEO_AU0828
-	---help---
+	help
 	   Enables Remote Controller support on au0828 driver.
diff --git a/drivers/media/usb/cpia2/Kconfig b/drivers/media/usb/cpia2/Kconfig
index 66e9283f5993..7029a04f3ffd 100644
--- a/drivers/media/usb/cpia2/Kconfig
+++ b/drivers/media/usb/cpia2/Kconfig
@@ -1,7 +1,7 @@
 config VIDEO_CPIA2
 	tristate "CPiA2 Video For Linux"
 	depends on VIDEO_DEV && USB && VIDEO_V4L2
-	---help---
+	help
 	  This is the video4linux driver for cameras based on Vision's CPiA2
 	  (Colour Processor Interface ASIC), such as the Digital Blue QX5
 	  Microscope. If you have one of these cameras, say Y here
diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 9e5b3e7c3ef5..9262d0d7439a 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -7,7 +7,7 @@ config VIDEO_CX231XX
 	select VIDEO_CX25840
 	select VIDEO_CX2341X
 
-	---help---
+	help
 	  This is a video4linux driver for Conexant 231xx USB based TV cards.
 
 	  To compile this driver as a module, choose M here: the
@@ -18,7 +18,7 @@ config VIDEO_CX231XX_RC
 	depends on RC_CORE=y || RC_CORE=VIDEO_CX231XX
 	depends on VIDEO_CX231XX
 	default y
-	---help---
+	help
 	  cx231xx hardware has a builtin RX/TX support. However, a few
 	  designs opted to not use it, but, instead, some other hardware.
 	  This module enables the usage of those other hardware, like the
@@ -31,7 +31,7 @@ config VIDEO_CX231XX_ALSA
 	depends on VIDEO_CX231XX && SND
 	select SND_PCM
 
-	---help---
+	help
 	  This is an ALSA driver for Cx231xx USB based TV cards.
 
 	  To compile this driver as a module, choose M here: the
@@ -52,6 +52,6 @@ config VIDEO_CX231XX_DVB
 	select DVB_MN88473 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_R820T if MEDIA_SUBDRV_AUTOSELECT
 
-	---help---
+	help
 	  This adds support for DVB cards based on the
 	  Conexant cx231xx chips.
diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index 451e076525d3..639da7e24066 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -13,7 +13,7 @@ config VIDEO_EM28XX_V4L2
 	select VIDEO_MSP3400 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_MT9V011 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_CAMERA_SUPPORT
 	select VIDEO_OV2640 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_CAMERA_SUPPORT
-	---help---
+	help
 	  This is a video4linux driver for Empia 28xx based TV cards.
 
 	  To compile this driver as a module, choose M here: the
@@ -23,7 +23,7 @@ config VIDEO_EM28XX_ALSA
 	depends on VIDEO_EM28XX && SND
 	select SND_PCM
 	tristate "Empia EM28xx ALSA audio module"
-	---help---
+	help
 	  This is an ALSA driver for some Empia 28xx based TV cards.
 
 	  This is not required for em2800/em2820/em2821 boards. However,
@@ -66,7 +66,7 @@ config VIDEO_EM28XX_DVB
 	select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  This adds support for DVB cards based on the
 	  Empiatech em28xx chips.
 
@@ -76,5 +76,5 @@ config VIDEO_EM28XX_RC
 	depends on VIDEO_EM28XX
 	depends on !(RC_CORE=m && VIDEO_EM28XX=y)
 	default VIDEO_EM28XX
-	---help---
+	help
 	  Enables Remote Controller support on em28xx driver.
diff --git a/drivers/media/usb/go7007/Kconfig b/drivers/media/usb/go7007/Kconfig
index af1d02430931..beab257c092f 100644
--- a/drivers/media/usb/go7007/Kconfig
+++ b/drivers/media/usb/go7007/Kconfig
@@ -13,7 +13,7 @@ config VIDEO_GO7007
 	select VIDEO_TW9906 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_OV7640 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_CAMERA_SUPPORT
 	select VIDEO_UDA1342 if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  This is a video4linux driver for the WIS GO7007 MPEG
 	  encoder chip.
 
@@ -23,7 +23,7 @@ config VIDEO_GO7007
 config VIDEO_GO7007_USB
 	tristate "WIS GO7007 USB support"
 	depends on VIDEO_GO7007 && USB
-	---help---
+	help
 	  This is a video4linux driver for the WIS GO7007 MPEG
 	  encoder chip over USB.
 
@@ -34,7 +34,7 @@ config VIDEO_GO7007_LOADER
 	tristate "WIS GO7007 Loader support"
 	depends on VIDEO_GO7007
 	default y
-	---help---
+	help
 	  This is a go7007 firmware loader driver for the WIS GO7007
 	  MPEG encoder chip over USB.
 
@@ -44,7 +44,7 @@ config VIDEO_GO7007_LOADER
 config VIDEO_GO7007_USB_S2250_BOARD
 	tristate "Sensoray 2250/2251 support"
 	depends on VIDEO_GO7007_USB && USB
-	---help---
+	help
 	  This is a video4linux driver for the Sensoray 2250/2251 device.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/media/usb/gspca/Kconfig b/drivers/media/usb/gspca/Kconfig
index 088566e88467..0e6f36cb46e6 100644
--- a/drivers/media/usb/gspca/Kconfig
+++ b/drivers/media/usb/gspca/Kconfig
@@ -4,7 +4,7 @@ menuconfig USB_GSPCA
 	depends on INPUT || INPUT=n
 	select VIDEOBUF2_VMALLOC
 	default m
-	---help---
+	help
 	  Say Y here if you want to enable selecting webcams based
 	  on the GSPCA framework.
 
diff --git a/drivers/media/usb/hackrf/Kconfig b/drivers/media/usb/hackrf/Kconfig
index 937e6f5c1e8e..072e186018f5 100644
--- a/drivers/media/usb/hackrf/Kconfig
+++ b/drivers/media/usb/hackrf/Kconfig
@@ -2,7 +2,7 @@ config USB_HACKRF
 	tristate "HackRF"
 	depends on VIDEO_V4L2
 	select VIDEOBUF2_VMALLOC
-	---help---
+	help
 	  This is a video4linux2 driver for HackRF SDR device.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/media/usb/hdpvr/Kconfig b/drivers/media/usb/hdpvr/Kconfig
index d73d9a1952b4..9e78c0c32651 100644
--- a/drivers/media/usb/hdpvr/Kconfig
+++ b/drivers/media/usb/hdpvr/Kconfig
@@ -2,7 +2,7 @@
 config VIDEO_HDPVR
 	tristate "Hauppauge HD PVR support"
 	depends on VIDEO_DEV && VIDEO_V4L2
-	---help---
+	help
 	  This is a video4linux driver for Hauppauge's HD PVR USB device.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/media/usb/pulse8-cec/Kconfig b/drivers/media/usb/pulse8-cec/Kconfig
index 18ead44824ba..11f1b75d3efd 100644
--- a/drivers/media/usb/pulse8-cec/Kconfig
+++ b/drivers/media/usb/pulse8-cec/Kconfig
@@ -4,7 +4,7 @@ config USB_PULSE8_CEC
 	select CEC_CORE
 	select SERIO
 	select SERIO_SERPORT
-	---help---
+	help
 	  This is a cec driver for the Pulse Eight HDMI CEC device.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/media/usb/pvrusb2/Kconfig b/drivers/media/usb/pvrusb2/Kconfig
index 1ad913fc30bf..ac6612cf1bec 100644
--- a/drivers/media/usb/pvrusb2/Kconfig
+++ b/drivers/media/usb/pvrusb2/Kconfig
@@ -9,7 +9,7 @@ config VIDEO_PVRUSB2
 	select VIDEO_MSP3400
 	select VIDEO_WM8775
 	select VIDEO_CS53L32A
-	---help---
+	help
 	  This is a video4linux driver for Conexant 23416 based
 	  usb2 personal video recorder devices.
 
@@ -20,7 +20,7 @@ config VIDEO_PVRUSB2_SYSFS
 	bool "pvrusb2 sysfs support"
 	default y
 	depends on VIDEO_PVRUSB2 && SYSFS
-	---help---
+	help
 	  This option enables the operation of a sysfs based
 	  interface for query and control of the pvrusb2 driver.
 
@@ -43,7 +43,7 @@ config VIDEO_PVRUSB2_DVB
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  This option enables a DVB interface for the pvrusb2 driver.
 	  If your device does not support digital television, this
 	  feature will have no affect on the driver's operation.
@@ -53,7 +53,7 @@ config VIDEO_PVRUSB2_DVB
 config VIDEO_PVRUSB2_DEBUGIFC
 	bool "pvrusb2 debug interface"
 	depends on VIDEO_PVRUSB2_SYSFS
-	---help---
+	help
 	  This option enables the inclusion of a debug interface
 	  in the pvrusb2 driver, hosted through sysfs.
 
diff --git a/drivers/media/usb/pwc/Kconfig b/drivers/media/usb/pwc/Kconfig
index d63d0a850035..5f6d91edca41 100644
--- a/drivers/media/usb/pwc/Kconfig
+++ b/drivers/media/usb/pwc/Kconfig
@@ -2,7 +2,7 @@ config USB_PWC
 	tristate "USB Philips Cameras"
 	depends on VIDEO_V4L2
 	select VIDEOBUF2_VMALLOC
-	---help---
+	help
 	  Say Y or M here if you want to use one of these Philips & OEM
 	  webcams:
 	   * Philips PCA645, PCA646
@@ -41,7 +41,7 @@ config USB_PWC_INPUT_EVDEV
 	bool "USB Philips Cameras input events device support"
 	default y
 	depends on USB_PWC && (USB_PWC=INPUT || INPUT=y)
-	---help---
+	help
 	  This option makes USB Philips cameras register the snapshot button as
 	  an input device to report button events.
 
diff --git a/drivers/media/usb/rainshadow-cec/Kconfig b/drivers/media/usb/rainshadow-cec/Kconfig
index 030ef01b1ff0..6b00be618db8 100644
--- a/drivers/media/usb/rainshadow-cec/Kconfig
+++ b/drivers/media/usb/rainshadow-cec/Kconfig
@@ -4,7 +4,7 @@ config USB_RAINSHADOW_CEC
 	select CEC_CORE
 	select SERIO
 	select SERIO_SERPORT
-	---help---
+	help
 	  This is a cec driver for the RainShadow Tech HDMI CEC device.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/media/usb/siano/Kconfig b/drivers/media/usb/siano/Kconfig
index d37b742d4f7a..cc5e5aa3c93a 100644
--- a/drivers/media/usb/siano/Kconfig
+++ b/drivers/media/usb/siano/Kconfig
@@ -8,6 +8,6 @@ config SMS_USB_DRV
 	depends on !RC_CORE || RC_CORE
 	select MEDIA_COMMON_OPTIONS
 	select SMS_SIANO_MDTV
-	---help---
+	help
 	  Choose if you would like to have Siano's support for USB interface
 
diff --git a/drivers/media/usb/stk1160/Kconfig b/drivers/media/usb/stk1160/Kconfig
index 425ed00e2599..03426e4437ea 100644
--- a/drivers/media/usb/stk1160/Kconfig
+++ b/drivers/media/usb/stk1160/Kconfig
@@ -2,7 +2,7 @@ config VIDEO_STK1160_COMMON
 	tristate "STK1160 USB video capture support"
 	depends on VIDEO_DEV && I2C
 
-	---help---
+	help
 	  This is a video4linux driver for STK1160 based video capture devices.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/media/usb/stkwebcam/Kconfig b/drivers/media/usb/stkwebcam/Kconfig
index a6a00aa4fce6..ea9e04b3caaf 100644
--- a/drivers/media/usb/stkwebcam/Kconfig
+++ b/drivers/media/usb/stkwebcam/Kconfig
@@ -1,7 +1,7 @@
 config USB_STKWEBCAM
 	tristate "USB Syntek DC1125 Camera support"
 	depends on VIDEO_V4L2
-	---help---
+	help
 	  Say Y here if you want to use this type of camera.
 	  Supported devices are typically found in some Asus laptops,
 	  with USB id 174f:a311 and 05e1:0501. Other Syntek cameras
diff --git a/drivers/media/usb/tm6000/Kconfig b/drivers/media/usb/tm6000/Kconfig
index a43b77abd931..321ae691f4d9 100644
--- a/drivers/media/usb/tm6000/Kconfig
+++ b/drivers/media/usb/tm6000/Kconfig
@@ -18,7 +18,7 @@ config VIDEO_TM6000_ALSA
 	tristate "TV Master TM5600/6000/6010 audio support"
 	depends on VIDEO_TM6000 && SND
 	select SND_PCM
-	---help---
+	help
 	  This is a video4linux driver for direct (DMA) audio for
 	  TM5600/TM6000/TM6010 USB Devices.
 
@@ -29,5 +29,5 @@ config VIDEO_TM6000_DVB
 	tristate "DVB Support for tm6000 based TV cards"
 	depends on VIDEO_TM6000 && DVB_CORE && USB
 	select DVB_ZL10353
-	---help---
+	help
 	  This adds support for DVB cards based on the tm5600/tm6000 chip.
diff --git a/drivers/media/usb/usbtv/Kconfig b/drivers/media/usb/usbtv/Kconfig
index 14a0941fa0d0..2b4ac0848469 100644
--- a/drivers/media/usb/usbtv/Kconfig
+++ b/drivers/media/usb/usbtv/Kconfig
@@ -4,7 +4,7 @@ config VIDEO_USBTV
 	select SND_PCM
 	select VIDEOBUF2_VMALLOC
 
-	---help---
+	help
 	  This is a video4linux2 driver for USBTV007 based video capture devices.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/media/usb/usbvision/Kconfig b/drivers/media/usb/usbvision/Kconfig
index 6b6afc5d8f7e..7aa080cb9884 100644
--- a/drivers/media/usb/usbvision/Kconfig
+++ b/drivers/media/usb/usbvision/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_USBVISION
 	depends on I2C && VIDEO_V4L2
 	select VIDEO_TUNER
 	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
-	---help---
+	help
 	  There are more than 50 different USB video devices based on
 	  NT1003/1004/1005 USB Bridges. This driver enables using those
 	  devices.
diff --git a/drivers/media/usb/uvc/Kconfig b/drivers/media/usb/uvc/Kconfig
index 6ed85efabcaa..94937d0cc2e3 100644
--- a/drivers/media/usb/uvc/Kconfig
+++ b/drivers/media/usb/uvc/Kconfig
@@ -2,7 +2,7 @@ config USB_VIDEO_CLASS
 	tristate "USB Video Class (UVC)"
 	depends on VIDEO_V4L2
 	select VIDEOBUF2_VMALLOC
-	---help---
+	help
 	  Support for the USB Video Class (UVC).  Currently only video
 	  input devices, such as webcams, are supported.
 
@@ -13,7 +13,7 @@ config USB_VIDEO_CLASS_INPUT_EVDEV
 	default y
 	depends on USB_VIDEO_CLASS
 	depends on USB_VIDEO_CLASS=INPUT || INPUT=y
-	---help---
+	help
 	  This option makes USB Video Class devices register an input device
 	  to report button events.
 
diff --git a/drivers/media/usb/zr364xx/Kconfig b/drivers/media/usb/zr364xx/Kconfig
index ac429bca70e8..979b1d4f3f68 100644
--- a/drivers/media/usb/zr364xx/Kconfig
+++ b/drivers/media/usb/zr364xx/Kconfig
@@ -3,7 +3,7 @@ config USB_ZR364XX
 	depends on VIDEO_V4L2
 	select VIDEOBUF_GEN
 	select VIDEOBUF_VMALLOC
-	---help---
+	help
 	  Say Y here if you want to connect this type of camera to your
 	  computer's USB port.
 	  See <file:Documentation/media/v4l-drivers/zr364xx.rst> for more info
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index c0940f5c69b4..8402096f7796 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -13,7 +13,7 @@ config VIDEO_V4L2
 config VIDEO_ADV_DEBUG
 	bool "Enable advanced debug functionality on V4L2 drivers"
 	default n
-	---help---
+	help
 	  Say Y here to enable advanced debugging functionality on some
 	  V4L devices.
 	  In doubt, say N.
@@ -21,7 +21,7 @@ config VIDEO_ADV_DEBUG
 config VIDEO_FIXED_MINOR_RANGES
 	bool "Enable old-style fixed minor ranges on drivers/video devices"
 	default n
-	---help---
+	help
 	  Say Y here to enable the old-style fixed-range minor assignments.
 	  Only useful if you rely on the old behavior and use mknod instead of udev.
 
@@ -33,7 +33,7 @@ config VIDEO_PCI_SKELETON
 	depends on SAMPLES
 	depends on VIDEO_V4L2 && VIDEOBUF2_CORE
 	depends on VIDEOBUF2_MEMOPS && VIDEOBUF2_DMA_CONTIG
-	---help---
+	help
 	  Enable build of the skeleton PCI driver, used as a reference
 	  when developing new drivers.
 
@@ -51,7 +51,7 @@ config V4L2_FLASH_LED_CLASS
 	tristate "V4L2 flash API for LED flash class devices"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on LEDS_CLASS_FLASH
-	---help---
+	help
 	  Say Y here to enable V4L2 flash API support for LED flash
 	  class drivers.
 
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 1da5c20d65c0..277df2b39384 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -1,7 +1,7 @@
 menuconfig STAGING_MEDIA
 	bool "Media staging drivers"
 	default n
-	---help---
+	help
 	  This option allows you to select a number of media drivers that
 	  don't have the "normal" Linux kernel quality level.
 	  Most of them don't follow properly the V4L, DVB and/or RC API's,
diff --git a/drivers/staging/media/bcm2048/Kconfig b/drivers/staging/media/bcm2048/Kconfig
index a9fc6e186494..a1526175eccb 100644
--- a/drivers/staging/media/bcm2048/Kconfig
+++ b/drivers/staging/media/bcm2048/Kconfig
@@ -5,7 +5,7 @@
 config I2C_BCM2048
 	tristate "Broadcom BCM2048 FM Radio Receiver support"
 	depends on I2C && VIDEO_V4L2 && RADIO_ADAPTERS
-	---help---
+	help
 	  Say Y here if you want support to BCM2048 FM Radio Receiver.
 	  This device driver supports only i2c bus.
 
diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
index 36b276ea2ecc..f6d220b649fb 100644
--- a/drivers/staging/media/imx/Kconfig
+++ b/drivers/staging/media/imx/Kconfig
@@ -6,7 +6,7 @@ config VIDEO_IMX_MEDIA
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
-	---help---
+	help
 	  Say yes here to enable support for video4linux media controller
 	  driver for the i.MX5/6 SOC.
 
@@ -17,7 +17,7 @@ config VIDEO_IMX_CSI
 	tristate "i.MX5/6 Camera Sensor Interface driver"
 	depends on VIDEO_IMX_MEDIA && VIDEO_DEV && I2C
 	default y
-	---help---
+	help
 	  A video4linux camera sensor interface driver for i.MX5/6.
 
 config VIDEO_IMX7_CSI
diff --git a/drivers/staging/media/ipu3/Kconfig b/drivers/staging/media/ipu3/Kconfig
index 75cd889f18f7..d5e50f88684a 100644
--- a/drivers/staging/media/ipu3/Kconfig
+++ b/drivers/staging/media/ipu3/Kconfig
@@ -5,7 +5,7 @@ config VIDEO_IPU3_IMGU
 	depends on X86
 	select IOMMU_IOVA
 	select VIDEOBUF2_DMA_SG
-	---help---
+	help
 	  This is the Video4Linux2 driver for Intel IPU3 image processing unit,
 	  found in Intel Skylake and Kaby Lake SoCs and used for processing
 	  images and video.
diff --git a/drivers/staging/media/omap4iss/Kconfig b/drivers/staging/media/omap4iss/Kconfig
index 841cc0b3ce13..4dcbc5065821 100644
--- a/drivers/staging/media/omap4iss/Kconfig
+++ b/drivers/staging/media/omap4iss/Kconfig
@@ -6,5 +6,5 @@ config VIDEO_OMAP4
 	depends on ARCH_OMAP4 || COMPILE_TEST
 	select MFD_SYSCON
 	select VIDEOBUF2_DMA_CONTIG
-	---help---
+	help
 	  Driver for an OMAP 4 ISS controller.
-- 
2.20.1

