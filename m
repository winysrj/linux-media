Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95490C4360F
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4188021916
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550518156;
	bh=8rAPPLqLOqw4PFqrzWx0nu8Ok31qC607VI+4xfY4O08=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=KwB4osJt7AopCsWHTMHb2IqbeYLddtNTgBM3cQDpVenVMaJXMvGV1avFIpVwJVNN4
	 Was0/oSZg+QzSLlacrIYqH02Os1/qvz97iiwuPVr+mdt9P5AiDsP0ywu2Pn5Gf6MZH
	 lPEfYEi8BlKQY2lG11MESytJs+WZuxj5/GsZ2dJY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfBRT3P (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:29:15 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34230 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfBRT3O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 14:29:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=23keZg+VAJW6BpCQKzKJqHrN4y/bhYUny22ndg9+g4U=; b=A5DWNX2vvVnRK07IZTAUAwhHo1
        iwjnwWkolyHHckie5RzEVOzNhSP7v6MYKa2pTr8HuoLtiF1SVKNY46Ov4HNJr7XouQQt0z/0rVA+7
        ucb1vekRwuos801fEHBQqdXr0yzT1pk0pu7oDqRV5Yb4Gn2NX+c3e7Gy3kr7be/YfomTnpt8g56w4
        iOCL/SY+AvJ42kbqFk4k0+ruhzZYIX2NH/EpAky7lkWZZ41VbKnucjsGD8Yc7WU00MJ2HAC8QBhq/
        tQRPyIRphaLfJxH4yzEHJ2ho70JSGC5/dwgF8Hw3FvPq39WpA+NRHWFoL+jXYQm4OrH5HLR/catB7
        6oMOGBTg==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvobJ-0002Uo-5c; Mon, 18 Feb 2019 19:29:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gvobG-0006gZ-GT; Mon, 18 Feb 2019 14:29:10 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Todor Tomov <todor.too@gmail.com>
Subject: [PATCH 13/14] media: Documentation: fix several typos
Date:   Mon, 18 Feb 2019 14:29:07 -0500
Message-Id: <33336ded047b1ea1c491fa3055dbe274f7c427fa.1550518128.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
References: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Use codespell to fix lots of typos over frontends.

Manually verified to avoid false-positives.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/media/dvb-drivers/dvb-usb.rst            | 2 +-
 Documentation/media/kapi/dtv-core.rst                  | 2 +-
 Documentation/media/kapi/dtv-frontend.rst              | 2 +-
 Documentation/media/kapi/mc-core.rst                   | 2 +-
 Documentation/media/kapi/v4l2-device.rst               | 2 +-
 Documentation/media/kapi/v4l2-intro.rst                | 2 +-
 Documentation/media/kapi/v4l2-subdev.rst               | 4 ++--
 Documentation/media/uapi/dvb/audio-set-bypass-mode.rst | 2 +-
 Documentation/media/uapi/dvb/ca-set-descr.rst          | 2 +-
 Documentation/media/uapi/dvb/dmx-qbuf.rst              | 2 +-
 Documentation/media/uapi/dvb/dvbproperty.rst           | 2 +-
 Documentation/media/uapi/dvb/video_types.rst           | 2 +-
 Documentation/media/uapi/fdl-appendix.rst              | 2 +-
 Documentation/media/uapi/mediactl/media-types.rst      | 2 +-
 Documentation/media/uapi/rc/rc-tables.rst              | 4 ++--
 Documentation/media/uapi/v4l/control.rst               | 2 +-
 Documentation/media/uapi/v4l/extended-controls.rst     | 2 +-
 Documentation/media/uapi/v4l/subdev-formats.rst        | 6 +++---
 Documentation/media/uapi/v4l/vidioc-g-parm.rst         | 2 +-
 Documentation/media/v4l-drivers/bttv.rst               | 4 ++--
 Documentation/media/v4l-drivers/imx.rst                | 4 ++--
 Documentation/media/v4l-drivers/pxa_camera.rst         | 2 +-
 Documentation/media/v4l-drivers/qcom_camss.rst         | 2 +-
 23 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/Documentation/media/dvb-drivers/dvb-usb.rst b/Documentation/media/dvb-drivers/dvb-usb.rst
index 6679191819aa..b2d5d9e62b30 100644
--- a/Documentation/media/dvb-drivers/dvb-usb.rst
+++ b/Documentation/media/dvb-drivers/dvb-usb.rst
@@ -125,7 +125,7 @@ https://linuxtv.org/wiki/index.php/DVB_USB
 
   2004-12-26
 
-  - refactored the dibusb-driver, splitted into separate files
+  - refactored the dibusb-driver, split into separate files
   - i2c-probing enabled
 
   2004-12-06
diff --git a/Documentation/media/kapi/dtv-core.rst b/Documentation/media/kapi/dtv-core.rst
index 17454a2cf6b0..ac005b46f23e 100644
--- a/Documentation/media/kapi/dtv-core.rst
+++ b/Documentation/media/kapi/dtv-core.rst
@@ -12,7 +12,7 @@ Digital TV devices are implemented by several different drivers:
 - Frontend drivers that are usually implemented as two separate drivers:
 
   - A tuner driver that implements the logic with commands the part of the
-    hardware with is reponsible to tune into a digital TV transponder or
+    hardware with is responsible to tune into a digital TV transponder or
     physical channel. The output of a tuner is usually a baseband or
     Intermediate Frequency (IF) signal;
 
diff --git a/Documentation/media/kapi/dtv-frontend.rst b/Documentation/media/kapi/dtv-frontend.rst
index 8ea64742c7ba..fbc5517c8d5a 100644
--- a/Documentation/media/kapi/dtv-frontend.rst
+++ b/Documentation/media/kapi/dtv-frontend.rst
@@ -328,7 +328,7 @@ Statistics collect
 
 On almost all frontend hardware, the bit and byte counts are stored by
 the hardware after a certain amount of time or after the total bit/block
-counter reaches a certain value (usually programable), for example, on
+counter reaches a certain value (usually programmable), for example, on
 every 1000 ms or after receiving 1,000,000 bits.
 
 So, if you read the registers too soon, you'll end by reading the same
diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
index 0bcfeadbc52d..f930725e0d6b 100644
--- a/Documentation/media/kapi/mc-core.rst
+++ b/Documentation/media/kapi/mc-core.rst
@@ -60,7 +60,7 @@ Drivers initialize entity pads by calling
 
 Drivers register entities with a media device by calling
 :c:func:`media_device_register_entity()`
-and unregistred by calling
+and unregistered by calling
 :c:func:`media_device_unregister_entity()`.
 
 Interfaces
diff --git a/Documentation/media/kapi/v4l2-device.rst b/Documentation/media/kapi/v4l2-device.rst
index c4311f0421be..5e25bf182c18 100644
--- a/Documentation/media/kapi/v4l2-device.rst
+++ b/Documentation/media/kapi/v4l2-device.rst
@@ -93,7 +93,7 @@ You can iterate over all registered devices as follows:
 		int err;
 
 		/* Find driver 'ivtv' on the PCI bus.
-		pci_bus_type is a global. For USB busses use usb_bus_type. */
+		pci_bus_type is a global. For USB buses use usb_bus_type. */
 		drv = driver_find("ivtv", &pci_bus_type);
 		/* iterate over all ivtv device instances */
 		err = driver_for_each_device(drv, NULL, p, callback);
diff --git a/Documentation/media/kapi/v4l2-intro.rst b/Documentation/media/kapi/v4l2-intro.rst
index cea3e263e48b..4d54fa9d7a12 100644
--- a/Documentation/media/kapi/v4l2-intro.rst
+++ b/Documentation/media/kapi/v4l2-intro.rst
@@ -11,7 +11,7 @@ hardware: most devices have multiple ICs, export multiple device nodes in
 Especially the fact that V4L2 drivers have to setup supporting ICs to
 do audio/video muxing/encoding/decoding makes it more complex than most.
 Usually these ICs are connected to the main bridge driver through one or
-more I2C busses, but other busses can also be used. Such devices are
+more I2C buses, but other buses can also be used. Such devices are
 called 'sub-devices'.
 
 For a long time the framework was limited to the video_device struct for
diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index be4970909f40..29e07e23f888 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -23,7 +23,7 @@ device data.
 
 You also need a way to go from the low-level struct to :c:type:`v4l2_subdev`.
 For the common i2c_client struct the i2c_set_clientdata() call is used to store
-a :c:type:`v4l2_subdev` pointer, for other busses you may have to use other
+a :c:type:`v4l2_subdev` pointer, for other buses you may have to use other
 methods.
 
 Bridges might also need to store per-subdev private data, such as a pointer to
@@ -33,7 +33,7 @@ provides host private data for that purpose that can be accessed with
 
 From the bridge driver perspective, you load the sub-device module and somehow
 obtain the :c:type:`v4l2_subdev` pointer. For i2c devices this is easy: you call
-``i2c_get_clientdata()``. For other busses something similar needs to be done.
+``i2c_get_clientdata()``. For other buses something similar needs to be done.
 Helper functions exists for sub-devices on an I2C bus that do most of this
 tricky work for you.
 
diff --git a/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst b/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
index d537da90acf5..d68f05d48d12 100644
--- a/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
+++ b/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
@@ -57,7 +57,7 @@ Description
 
 This ioctl call asks the Audio Device to bypass the Audio decoder and
 forward the stream without decoding. This mode shall be used if streams
-that can’t be handled by the Digial TV system shall be decoded. Dolby
+that can’t be handled by the Digital TV system shall be decoded. Dolby
 DigitalTM streams are automatically forwarded by the Digital TV subsystem if
 the hardware can handle it.
 
diff --git a/Documentation/media/uapi/dvb/ca-set-descr.rst b/Documentation/media/uapi/dvb/ca-set-descr.rst
index 22c8b8f94c7e..d36464ba2317 100644
--- a/Documentation/media/uapi/dvb/ca-set-descr.rst
+++ b/Documentation/media/uapi/dvb/ca-set-descr.rst
@@ -39,7 +39,7 @@ Description
 -----------
 
 CA_SET_DESCR is used for feeding descrambler CA slots with descrambling
-keys (refered as control words).
+keys (referred as control words).
 
 Return Value
 ------------
diff --git a/Documentation/media/uapi/dvb/dmx-qbuf.rst b/Documentation/media/uapi/dvb/dmx-qbuf.rst
index 9a1d85147c25..9dc845daa59d 100644
--- a/Documentation/media/uapi/dvb/dmx-qbuf.rst
+++ b/Documentation/media/uapi/dvb/dmx-qbuf.rst
@@ -61,7 +61,7 @@ the device is closed.
 
 Applications call the ``DMX_DQBUF`` ioctl to dequeue a filled
 (capturing) buffer from the driver's outgoing queue.
-They just set the ``index`` field withe the buffer ID to be queued.
+They just set the ``index`` field with the buffer ID to be queued.
 When ``DMX_DQBUF`` is called with a pointer to struct :c:type:`dmx_buffer`,
 the driver fills the remaining fields or returns an error code.
 
diff --git a/Documentation/media/uapi/dvb/dvbproperty.rst b/Documentation/media/uapi/dvb/dvbproperty.rst
index 371c72bb9419..0c4f5598f2be 100644
--- a/Documentation/media/uapi/dvb/dvbproperty.rst
+++ b/Documentation/media/uapi/dvb/dvbproperty.rst
@@ -44,7 +44,7 @@ with supports all digital TV delivery systems.
       struct :c:type:`dvb_frontend_parameters`.
 
    2. Don't use DVB API version 3 calls on hardware with supports
-      newer standards. Such API provides no suport or a very limited
+      newer standards. Such API provides no support or a very limited
       support to new standards and/or new hardware.
 
    3. Nowadays, most frontends support multiple delivery systems.
diff --git a/Documentation/media/uapi/dvb/video_types.rst b/Documentation/media/uapi/dvb/video_types.rst
index 2ed8aad84003..479942ce6fb8 100644
--- a/Documentation/media/uapi/dvb/video_types.rst
+++ b/Documentation/media/uapi/dvb/video_types.rst
@@ -202,7 +202,7 @@ If video_blank is set video will be blanked out if the channel is
 changed or if playback is stopped. Otherwise, the last picture will be
 displayed. play_state indicates if the video is currently frozen,
 stopped, or being played back. The stream_source corresponds to the
-seleted source for the video stream. It can come either from the
+selected source for the video stream. It can come either from the
 demultiplexer or from memory. The video_format indicates the aspect
 ratio (one of 4:3 or 16:9) of the currently played video stream.
 Finally, display_format corresponds to the selected cropping mode in
diff --git a/Documentation/media/uapi/fdl-appendix.rst b/Documentation/media/uapi/fdl-appendix.rst
index f8dc85d3939c..9316b8617502 100644
--- a/Documentation/media/uapi/fdl-appendix.rst
+++ b/Documentation/media/uapi/fdl-appendix.rst
@@ -363,7 +363,7 @@ various documents with a single copy that is included in the collection,
 provided that you follow the rules of this License for verbatim copying
 of each of the documents in all other respects.
 
-You may extract a single document from such a collection, and dispbibute
+You may extract a single document from such a collection, and distribute
 it individually under this License, provided you insert a copy of this
 License into the extracted document, and follow this License in all
 other respects regarding verbatim copying of that document.
diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 8627587b7075..3af6a414b501 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -164,7 +164,7 @@ Types and flags used to represent the media graph elements
 
     *  -  ``MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV``
        -  Video pixel encoding converter. An entity capable of pixel
-	  enconding conversion must have at least one sink pad and one
+	  encoding conversion must have at least one sink pad and one
 	  source pad, and convert the encoding of pixels received on
 	  its sink pad(s) to a different encoding output on its source
 	  pad(s). Pixel encoding conversion includes but isn't limited
diff --git a/Documentation/media/uapi/rc/rc-tables.rst b/Documentation/media/uapi/rc/rc-tables.rst
index cb670d10998b..f460031d8531 100644
--- a/Documentation/media/uapi/rc/rc-tables.rst
+++ b/Documentation/media/uapi/rc/rc-tables.rst
@@ -385,7 +385,7 @@ the remote via /dev/input/event devices.
 
        -  ``KEY_CHANNELDOWN``
 
-       -  Decrease channel sequencially
+       -  Decrease channel sequentially
 
        -  CHANNEL - / CHANNEL DOWN / DOWN
 
@@ -393,7 +393,7 @@ the remote via /dev/input/event devices.
 
        -  ``KEY_CHANNELUP``
 
-       -  Increase channel sequencially
+       -  Increase channel sequentially
 
        -  CHANNEL + / CHANNEL UP / UP
 
diff --git a/Documentation/media/uapi/v4l/control.rst b/Documentation/media/uapi/v4l/control.rst
index 0d46526b5935..71417bba028c 100644
--- a/Documentation/media/uapi/v4l/control.rst
+++ b/Documentation/media/uapi/v4l/control.rst
@@ -499,7 +499,7 @@ Example: Changing controls
 .. [#f1]
    The use of ``V4L2_CID_PRIVATE_BASE`` is problematic because different
    drivers may use the same ``V4L2_CID_PRIVATE_BASE`` ID for different
-   controls. This makes it hard to programatically set such controls
+   controls. This makes it hard to programmatically set such controls
    since the meaning of the control with that ID is driver dependent. In
    order to resolve this drivers use unique IDs and the
    ``V4L2_CID_PRIVATE_BASE`` IDs are mapped to those unique IDs by the
diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 00934efdc9e4..44ba54c4b529 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1737,7 +1737,7 @@ MFC 5.1 Control IDs
     Display delay value for H264 decoder. The decoder is forced to
     return a decoded frame after the set 'display delay' number of
     frames. If this number is low it may result in frames returned out
-    of dispaly order, in addition the hardware may still be using the
+    of display order, in addition the hardware may still be using the
     returned buffer as a reference picture for subsequent frames.
 
 ``V4L2_CID_MPEG_MFC51_VIDEO_H264_NUM_REF_PIC_FOR_P (integer)``
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index ff4b2a972fd2..f5440d55d510 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -75,15 +75,15 @@ Media Bus Pixel Codes
 ---------------------
 
 The media bus pixel codes describe image formats as flowing over
-physical busses (both between separate physical components and inside
+physical buses (both between separate physical components and inside
 SoC devices). This should not be confused with the V4L2 pixel formats
 that describe, using four character codes, image formats as stored in
 memory.
 
-While there is a relationship between image formats on busses and image
+While there is a relationship between image formats on buses and image
 formats in memory (a raw Bayer image won't be magically converted to
 JPEG just by storing it to memory), there is no one-to-one
-correspondance between them.
+correspondence between them.
 
 
 Packed RGB Formats
diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
index 0d2593176c90..d9d5d97848d3 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-parm.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
@@ -213,7 +213,7 @@ union holding separate parameters for input and output devices.
 
 .. _parm-caps:
 
-.. flat-table:: Streaming Parameters Capabilites
+.. flat-table:: Streaming Parameters Capabilities
     :header-rows:  0
     :stub-columns: 0
     :widths:       3 1 4
diff --git a/Documentation/media/v4l-drivers/bttv.rst b/Documentation/media/v4l-drivers/bttv.rst
index d72a0f8fd267..f956ee264099 100644
--- a/Documentation/media/v4l-drivers/bttv.rst
+++ b/Documentation/media/v4l-drivers/bttv.rst
@@ -85,7 +85,7 @@ same card listens there is much higher...
 For problems with sound:  There are a lot of different systems used
 for TV sound all over the world.  And there are also different chips
 which decode the audio signal.  Reports about sound problems ("stereo
-does'nt work") are pretty useless unless you include some details
+doesn't work") are pretty useless unless you include some details
 about your hardware and the TV sound scheme used in your country (or
 at least the country you are living in).
 
@@ -771,7 +771,7 @@ Identifying:
       - Lifeview.com.tw states (Feb. 2002):
         "The FlyVideo2000 and FlyVideo2000s product name have renamed to FlyVideo98."
         Their Bt8x8 cards are listed as discontinued.
-      - Flyvideo 2000S was probably sold as Flyvideo 3000 in some contries(Europe?).
+      - Flyvideo 2000S was probably sold as Flyvideo 3000 in some countries(Europe?).
         The new Flyvideo 2000/3000 are SAA7130/SAA7134 based.
 
 "Flyvideo II" had been the name for the 848 cards, nowadays (in Germany)
diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
index 9314af00d067..1d7eb8c7bd5c 100644
--- a/Documentation/media/v4l-drivers/imx.rst
+++ b/Documentation/media/v4l-drivers/imx.rst
@@ -29,7 +29,7 @@ de-interlacing by interweaving even and odd lines during transfer
 (without motion compensation which requires the VDIC).
 
 The CSI is the backend capture unit that interfaces directly with
-camera sensors over Parallel, BT.656/1120, and MIPI CSI-2 busses.
+camera sensors over Parallel, BT.656/1120, and MIPI CSI-2 buses.
 
 The IC handles color-space conversion, resizing (downscaling and
 upscaling), horizontal flip, and 90/270 degree rotation operations.
@@ -207,7 +207,7 @@ The CSI supports cropping the incoming raw sensor frames. This is
 implemented in the ipuX_csiY entities at the sink pad, using the
 crop selection subdev API.
 
-The CSI also supports fixed divide-by-two downscaling indepently in
+The CSI also supports fixed divide-by-two downscaling independently in
 width and height. This is implemented in the ipuX_csiY entities at
 the sink pad, using the compose selection subdev API.
 
diff --git a/Documentation/media/v4l-drivers/pxa_camera.rst b/Documentation/media/v4l-drivers/pxa_camera.rst
index e4fbca755e1a..ee1bd96b66dd 100644
--- a/Documentation/media/v4l-drivers/pxa_camera.rst
+++ b/Documentation/media/v4l-drivers/pxa_camera.rst
@@ -18,7 +18,7 @@ Global video workflow
 ---------------------
 
 a) QCI stopped
-   Initialy, the QCI interface is stopped.
+   Initially, the QCI interface is stopped.
    When a buffer is queued (pxa_videobuf_ops->buf_queue), the QCI starts.
 
 b) QCI started
diff --git a/Documentation/media/v4l-drivers/qcom_camss.rst b/Documentation/media/v4l-drivers/qcom_camss.rst
index 6b15385b12b3..a72e17d09cb7 100644
--- a/Documentation/media/v4l-drivers/qcom_camss.rst
+++ b/Documentation/media/v4l-drivers/qcom_camss.rst
@@ -123,7 +123,7 @@ The considerations to split the driver in this particular way are as follows:
 - representing CSIPHY and CSID modules by a separate sub-device for each module
   allows to model the hardware links between these modules;
 - representing VFE by a separate sub-devices for each input interface allows
-  to use the input interfaces concurently and independently as this is
+  to use the input interfaces concurrently and independently as this is
   supported by the hardware;
 - representing ISPIF by a number of sub-devices equal to the number of CSID
   sub-devices allows to create linear media controller pipelines when using two
-- 
2.20.1

