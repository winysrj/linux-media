Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:40195 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731345AbeKMSVV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 13:21:21 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 0/5] media: Allwinner A10 CSI support
Date: Tue, 13 Nov 2018 09:24:12 +0100
Message-Id: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here is a series introducing the support for the A10 (and SoCs of the same
generation) CMOS Sensor Interface (called CSI, not to be confused with
MIPI-CSI, which isn't support by that IP).

That interface is pretty straightforward, but the driver has a few issues
that I wanted to bring up:

  * The only board I've been testing this with has an ov5640 sensor
    attached, which doesn't work with the upstream driver. Copying the
    Allwinner init sequence works though, and this is how it has been
    tested. Testing with a second sensor would allow to see if it's an
    issue on the CSI side or the sensor side.
  * When starting a capture, the last buffer to capture will fail due to
    double buffering being used, and we don't have a next buffer for the
    last frame. I'm not sure how to deal with that though. It seems like
    some drivers use a scratch buffer in such a case, some don't care, so
    I'm not sure which solution should be preferred.
  * We don't have support for the ISP at the moment, but this can be added
    eventually.

  * How to model the CSI module clock isn't really clear to me. It looks
    like it goes through the CSI controller and then is muxed to one of the
    CSI pin so that it can clock the sensor. I'm not quite sure how to
    model it, if it should be a clock, the CSI driver being a clock
    provider, or if the sensor should just use the module clock directly.

Here is the v4l2-compliance output:
v4l2-compliance SHA   : 339d550e92ac15de8668f32d66d16f198137006c

Driver Info:
	Driver name   : sun4i_csi
	Card type     : sun4i-csi
	Bus info      : platform:1c09000.csi
	Driver version: 4.19.0
	Capabilities  : 0x84201000
		Video Capture Multiplanar
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04201000
		Video Capture Multiplanar
		Streaming
		Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 1 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

Test input 0:

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
		test VIDIOC_QUERYCTRL: OK (Not Supported)
		test VIDIOC_G/S_CTRL: OK (Not Supported)
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 0 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK (Not Supported)
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		test VIDIOC_TRY_FMT: OK
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK (Not Supported)
		test Composing: OK (Not Supported)
		test Scaling: OK

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK

Test input 0:

Total: 43, Succeeded: 43, Failed: 0, Warnings: 0

Let me know what you think,
Maxime

Maxime Ripard (5):
  dt-bindings: media: Add Allwinner A10 CSI binding
  media: sunxi: Refactor the Makefile and Kconfig
  media: sunxi: Add A10 CSI driver
  ARM: dts: sun7i: Add CSI0 controller
  DO NOT MERGE: ARM: dts: bananapi: Add Camera support

 Documentation/devicetree/bindings/media/sun4i-csi.txt |  71 ++-
 arch/arm/boot/dts/sun7i-a20-bananapi.dts              |  98 +++-
 arch/arm/boot/dts/sun7i-a20.dtsi                      |  13 +-
 drivers/media/platform/Kconfig                        |   2 +-
 drivers/media/platform/Makefile                       |   2 +-
 drivers/media/platform/sunxi/Kconfig                  |   2 +-
 drivers/media/platform/sunxi/Makefile                 |   2 +-
 drivers/media/platform/sunxi/sun4i-csi/Kconfig        |  12 +-
 drivers/media/platform/sunxi/sun4i-csi/Makefile       |   5 +-
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c    | 275 ++++++++-
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.h    | 137 ++++-
 drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c    | 383 +++++++++++-
 drivers/media/platform/sunxi/sun4i-csi/sun4i_v4l2.c   | 287 ++++++++-
 13 files changed, 1287 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/sun4i-csi.txt
 create mode 100644 drivers/media/platform/sunxi/Kconfig
 create mode 100644 drivers/media/platform/sunxi/Makefile
 create mode 100644 drivers/media/platform/sunxi/sun4i-csi/Kconfig
 create mode 100644 drivers/media/platform/sunxi/sun4i-csi/Makefile
 create mode 100644 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c
 create mode 100644 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.h
 create mode 100644 drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c
 create mode 100644 drivers/media/platform/sunxi/sun4i-csi/sun4i_v4l2.c

base-commit: 94517eaa3d43005472864615dfd17f1ef6ca3935
-- 
git-series 0.9.1
