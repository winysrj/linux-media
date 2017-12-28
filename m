Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:43580 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751296AbdL1UKW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 15:10:22 -0500
Received: by mail-pg0-f68.google.com with SMTP id f18so3575609pga.10
        for <linux-media@vger.kernel.org>; Thu, 28 Dec 2017 12:10:22 -0800 (PST)
From: Tim Harvey <tharvey@gateworks.com>
To: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v6 0/6] TDA1997x HDMI video receiver
Date: Thu, 28 Dec 2017 12:09:43 -0800
Message-Id: <1514491789-8697-1-git-send-email-tharvey@gateworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a v4l2 subdev driver supporting the TDA1997x HDMI video receiver.

I've tested this on a Gateworks GW54xx/GW551x with an IMX6Q/IMX6DL which
uses the TDA19971 with 16bits connected to the IMX6 CSI and single-lane
I2S audio providing 2-channel audio.

For this configuration I've tested both 16bit YUV422 and 8bit
BT656 parallel video bus modes.

While the driver should support the TDA1993 I do not have one for testing.

Further potential development efforts include:
 - CEC support
 - HDCP support
 - mbus format selection support for bus widths that support multiple
   formats
 - TDA19972 support (2 inputs)

Media graphs can be found at http://dev.gateworks.com/docs/linux/media

History:
v6:
 - tda1997x: fix return on regulator enablei in tda1997x_set_power() (Fabio)
 - tda1997x: fix colorspace handling (Hans)
 - bindings: added Robs's ack (Rob)
 - replace copyright with SPDX tag (Philippe)

v5:
 - added v4l2_hdmi_colorimetry() patch from Hans to series
 - bindings: added Sakari's ack
 - tda1997x: uppercase string constants
 - tda1997x: use v4l2_hdmi_rx_coloriemtry to fill format
 - tda1997x: fix V4L2_CID_DV_RX_RGB_RANGE
 - tda1997x: fix interlaced mode format
 - dts: remove leading 0 from unit address
 - dts: add newline between property list and child node
 - dts: added missing audmux in GW551x dts

v4:
 - move include/dt-bindings/media/tda1997x.h to bindings patch
 - clarify port node details in bindings
 - fix typos
 - fix default quant range for VGA
 - fix quant range handling and conv matrix
 - add additional standards and capabilities to timings_cap

v3:
 - fix typo in dt bindings
 - added dt bindings for GW551x
 - use V4L2_DV_BT_FRAME_WIDTH/HEIGHT macros
 - fixed missing break
 - use only hdmi_infoframe_log for infoframe logging
 - simplify tda1997x_s_stream error handling
 - add delayed work proc to handle hotplug enable/disable
 - fix set_edid (disable HPD before writing, enable after)
 - remove enabling edid by default
 - initialize timings
 - take quant range into account in colorspace conversion
 - remove vendor/product tracking (we provide this in log_status via
   infoframes)
 - add v4l_controls
 - add more detail to log_status
 - calculate vhref generator timings
 - timing detection fixes (rounding errors, hswidth errors)
 - rename configure_input/configure_conv functions

v2:
 - encorporate feedback into dt bindings
 - change audio dt bindings
 - implement dv timings enum/cap
 - remove deprecated g_mbus_config op
 - fix dv_query_timings
 - add EDID get/set handling
 - remove max-pixel-rate support
 - add audio codec DAI support
 - added media-ctl and v4l2-compliance details

v1:
 - initial RFC

Media device topology:
# media-ctl -d /dev/media0 -p
Media controller API version 4.13.0

Media device information
------------------------
driver          imx-media
model           imx-media
serial          
bus info        
hw revision     0x0
driver version  4.13.0

Device topology
- entity 1: adv7180 2-0020 (1 pad, 1 link)
            type V4L2 subdev subtype Unknown flags 20004
            device node name /dev/v4l-subdev0
	pad0: Source
		[fmt:UYVY8_2X8/720x480 field:interlaced colorspace:smpte170m]
		-> "ipu2_csi1_mux":1 []

- entity 3: tda19971 2-0048 (1 pad, 1 link)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev1
	pad0: Source
		[fmt:UYVY8_1X16/640x480 field:none colorspace:srgb]
		[dv.caps:BT.656/1120 min:640x480@13000000 max:1920x1080@165000000 stds:CEA-861,DMT caps:progressive]
		[dv.detect:BT.656/1120 640x480p59 (800x525) stds:CEA-861,DMT flags:has-cea861-vic]
		[dv.current:BT.656/1120 1920x1080p60 (2200x1125) stds:CEA-861,DMT flags:can-reduce-fps,CE-video,has-cea861-vic]
		-> "ipu1_csi0_mux":1 []

- entity 5: ipu1_vdic (3 pads, 3 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev2
	pad0: Sink
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		<- "ipu1_csi0":1 []
		<- "ipu1_csi1":1 []
	pad1: Sink
		[fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
	pad2: Source
		[fmt:AYUV8_1X32/640x480@1/60 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu1_ic_prp":0 []

- entity 9: ipu2_vdic (3 pads, 3 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev3
	pad0: Sink
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		<- "ipu2_csi0":1 []
		<- "ipu2_csi1":1 []
	pad1: Sink
		[fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
	pad2: Source
		[fmt:AYUV8_1X32/640x480@1/60 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu2_ic_prp":0 []

- entity 13: ipu1_ic_prp (3 pads, 5 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev4
	pad0: Sink
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		<- "ipu1_vdic":2 []
		<- "ipu1_csi0":1 []
		<- "ipu1_csi1":1 []
	pad1: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu1_ic_prpenc":0 []
	pad2: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu1_ic_prpvf":0 []

- entity 17: ipu1_ic_prpenc (2 pads, 2 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev5
	pad0: Sink
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		<- "ipu1_ic_prp":1 []
	pad1: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu1_ic_prpenc capture":0 []

- entity 20: ipu1_ic_prpenc capture (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video0
	pad0: Sink
		<- "ipu1_ic_prpenc":1 []

- entity 26: ipu1_ic_prpvf (2 pads, 2 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev6
	pad0: Sink
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		<- "ipu1_ic_prp":2 []
	pad1: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu1_ic_prpvf capture":0 []

- entity 29: ipu1_ic_prpvf capture (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video1
	pad0: Sink
		<- "ipu1_ic_prpvf":1 []

- entity 35: ipu2_ic_prp (3 pads, 5 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev7
	pad0: Sink
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		<- "ipu2_vdic":2 []
		<- "ipu2_csi0":1 []
		<- "ipu2_csi1":1 []
	pad1: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu2_ic_prpenc":0 []
	pad2: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu2_ic_prpvf":0 []

- entity 39: ipu2_ic_prpenc (2 pads, 2 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev8
	pad0: Sink
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		<- "ipu2_ic_prp":1 []
	pad1: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu2_ic_prpenc capture":0 []

- entity 42: ipu2_ic_prpenc capture (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video2
	pad0: Sink
		<- "ipu2_ic_prpenc":1 []

- entity 48: ipu2_ic_prpvf (2 pads, 2 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev9
	pad0: Sink
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		<- "ipu2_ic_prp":2 []
	pad1: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu2_ic_prpvf capture":0 []

- entity 51: ipu2_ic_prpvf capture (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video3
	pad0: Sink
		<- "ipu2_ic_prpvf":1 []

- entity 57: ipu1_csi0 (3 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev10
	pad0: Sink
		[fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range
		 crop.bounds:(0,0)/640x480
		 crop:(0,0)/640x480
		 compose.bounds:(0,0)/640x480
		 compose:(0,0)/640x480]
		<- "ipu1_csi0_mux":2 []
	pad1: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu1_ic_prp":0 []
		-> "ipu1_vdic":0 []
	pad2: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu1_csi0 capture":0 []

- entity 61: ipu1_csi0 capture (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video4
	pad0: Sink
		<- "ipu1_csi0":2 []

- entity 67: ipu1_csi1 (3 pads, 3 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev11
	pad0: Sink
		[fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range
		 crop.bounds:(0,0)/640x480
		 crop:(0,0)/640x480
		 compose.bounds:(0,0)/640x480
		 compose:(0,0)/640x480]
	pad1: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu1_ic_prp":0 []
		-> "ipu1_vdic":0 []
	pad2: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu1_csi1 capture":0 []

- entity 71: ipu1_csi1 capture (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video5
	pad0: Sink
		<- "ipu1_csi1":2 []

- entity 77: ipu2_csi0 (3 pads, 3 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev12
	pad0: Sink
		[fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range
		 crop.bounds:(0,0)/640x480
		 crop:(0,0)/640x480
		 compose.bounds:(0,0)/640x480
		 compose:(0,0)/640x480]
	pad1: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu2_ic_prp":0 []
		-> "ipu2_vdic":0 []
	pad2: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu2_csi0 capture":0 []

- entity 81: ipu2_csi0 capture (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video6
	pad0: Sink
		<- "ipu2_csi0":2 []

- entity 87: ipu2_csi1 (3 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev13
	pad0: Sink
		[fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range
		 crop.bounds:(0,0)/640x480
		 crop:(0,0)/640x480
		 compose.bounds:(0,0)/640x480
		 compose:(0,0)/640x480]
		<- "ipu2_csi1_mux":2 []
	pad1: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu2_ic_prp":0 []
		-> "ipu2_vdic":0 []
	pad2: Source
		[fmt:AYUV8_1X32/640x480@1/30 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
		-> "ipu2_csi1 capture":0 []

- entity 91: ipu2_csi1 capture (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video7
	pad0: Sink
		<- "ipu2_csi1":2 []

- entity 97: ipu1_csi0_mux (3 pads, 2 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev14
	pad0: Sink
		[fmt:unknown/0x0]
	pad1: Sink
		[fmt:unknown/0x0]
		<- "tda19971 2-0048":0 []
	pad2: Source
		[fmt:unknown/0x0]
		-> "ipu1_csi0":0 []

- entity 101: ipu2_csi1_mux (3 pads, 2 links)
              type V4L2 subdev subtype Unknown flags 0
              device node name /dev/v4l-subdev15
	pad0: Sink
		[fmt:unknown/0x0]
	pad1: Sink
		[fmt:unknown/0x0]
		<- "adv7180 2-0020":0 []
	pad2: Source
		[fmt:unknown/0x0]
		-> "ipu2_csi1":0 []


v4l2-compliance test results:
(on /dev/video6 as v4l2-compliance doesn't yet support subdevs)
Driver Info:
	Driver name   : imx-media-captu
	Card type     : imx-media-capture
	Bus info      : platform:ipu2_csi0
	Driver version: 4.13.0
	Capabilities  : 0x84200001
		Video Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04200001
		Video Capture
		Streaming
		Extended Pix Format

Compliance test for device /dev/video6 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
		fail: v4l2-test-input-output.cpp(418): G_INPUT not supported for a capture device
	test VIDIOC_G/S/ENUMINPUT: FAIL
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 0 Audio Inputs: 0 Tuners: 0

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

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		fail: v4l2-test-controls.cpp(574): g_ext_ctrls does not support count == 0
		test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 0 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		test VIDIOC_TRY_FMT: OK
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK (Not Supported)
		test Composing: OK (Not Supported)
		test Scaling: OK (Not Supported)

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK

Test input 0:


Total: 42, Succeeded: 40, Failed: 2, Warnings: 0

Hans Verkuil (1):
  v4l2-dv-timings: add v4l2_hdmi_colorimetry()

Tim Harvey (5):
  MAINTAINERS: add entry for NXP TDA1997x driver
  media: dt-bindings: Add bindings for TDA1997X
  media: i2c: Add TDA1997x HDMI receiver driver
  ARM: dts: imx: Add TDA19971 HDMI Receiver to GW54xx
  ARM: dts: imx: Add TDA19971 HDMI Receiver to GW551x

 .../devicetree/bindings/media/i2c/tda1997x.txt     |  179 +
 MAINTAINERS                                        |    8 +
 arch/arm/boot/dts/imx6q-gw54xx.dts                 |  105 +
 arch/arm/boot/dts/imx6qdl-gw54xx.dtsi              |   29 +-
 arch/arm/boot/dts/imx6qdl-gw551x.dtsi              |  138 +
 drivers/media/i2c/Kconfig                          |    9 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/tda1997x.c                       | 3476 ++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  141 +
 include/dt-bindings/media/tda1997x.h               |   74 +
 include/media/i2c/tda1997x.h                       |   41 +
 include/media/v4l2-dv-timings.h                    |   21 +
 12 files changed, 4219 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tda1997x.txt
 create mode 100644 drivers/media/i2c/tda1997x.c
 create mode 100644 include/dt-bindings/media/tda1997x.h
 create mode 100644 include/media/i2c/tda1997x.h

-- 
2.7.4
