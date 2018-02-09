Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:41877 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbeBIGcy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 01:32:54 -0500
Received: by mail-pg0-f68.google.com with SMTP id t4so1953088pgp.8
        for <linux-media@vger.kernel.org>; Thu, 08 Feb 2018 22:32:53 -0800 (PST)
From: Tim Harvey <tharvey@gateworks.com>
To: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v10 0/8] TDA1997x HDMI video reciver
Date: Thu,  8 Feb 2018 22:32:28 -0800
Message-Id: <1518157956-14220-1-git-send-email-tharvey@gateworks.com>
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
 - TDA19972 support (2 inputs)

Media graphs can be found at http://dev.gateworks.com/docs/linux/media

See details below for configuration and compliance tests

History:
v10:
 - removed unnecessary check for !timings in get/set/query dv timings (Hans)
 - dropped pointless s_stream handler (Hans)
 - remove need for detected_timings and always use set timings (Hans)

v9:
 - add digital video decoder video interface entity function

v8:
 - fix clearing pad for VIDIOC_DV_TIMIGNS_CAP
 - support full range of input modes based on timings_cap
 - add patch to fix clearing pad for VIDIOC_DV_TIMIGINGS
 - fix available formats for tda19971 bt656 bus width >12
 - fix set_format (compliance)
 - fixed get/set edid (compliance)
 - add init_cfg to setup default pad config (compliance)
 - added missing pad checks to get_dv_timings_cap/enum_dv_timings (compliance)
 - fix alignment of if statement and whitespace in comment (Hans)
 - move regs to tda1997x_regs.h to clean up (Hans)
 - add define and sanity check for num of mbus_codes (Hans)

v7:
 - fix interlaced mode
 - support no AVI infoframe (ie DVI) (Hans)
 - add support for multiple output formats (Hans)

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

Pipeline configuration:
$ media-ctl -e 'tda19971 2-0048'
/dev/v4l-subdev1
$ v4l2-ctl -d /dev/v4l-subdev1 --set-dv-bt-timings=query
BT timings set
$ media-ctl --get-v4l2 '"tda19971 2-0048":0'
                [fmt:UYVY8_2X8/1280x720 field:none colorspace:srgb]

$ media-ctl --link "tda19971 2-0048":0 -> "ipu1_csi0_mux":1[1]
$ media-ctl --link "ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]
$ media-ctl --link "ipu1_csi0":2 -> "ipu1_csi0 capture":0[1]
$ media-ctl --set-v4l2 'tda19971 2-0048':0[fmt:UYVY8_2X8/1280x720]
$ media-ctl --set-v4l2 'ipu1_csi0_mux':2[fmt:UYVY8_2X8/1280x720]
$ media-ctl --set-v4l2 'ipu1_csi0':0[fmt:UYVY8_2X8/1280x720]
$ gst-launch-1.0 v4l2src device=/dev/video4 ! video/x-raw,width=1280,height=720,format=UYVY ! jpegenc ! rtpjpegpay ! udpsink host=172.24.40.6 port=5000

$ media-ctl -d /dev/media0 -p
Media controller API version 4.15.0

Media device information
------------------------
driver          imx-media
model           imx-media
serial          
bus info        
hw revision     0x0
driver version  4.15.0

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
		[fmt:UYVY8_2X8/1280x720 field:none colorspace:srgb]
		[dv.caps:BT.656/1120 min:640x350@13000000 max:1920x1200@165000000 stds:CEA-861,DMT,CVT,GTF caps:interlaced,progressive,reduced-blanking,custom]
		[dv.detect:BT.656/1120 1280x720p60 (1650x750) stds:CEA-861 flags:can-reduce-fps,CE-video,has-cea861-vic]
		[dv.current:BT.656/1120 1280x720p60 (1650x750) stds:CEA-861 flags:can-reduce-fps,CE-video,has-cea861-vic]
		-> "ipu1_csi0_mux":1 [ENABLED]

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
		[fmt:UYVY8_2X8/1280x720@1/30 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range
		 crop.bounds:(0,0)/1280x720
		 crop:(0,0)/1280x720
		 compose.bounds:(0,0)/1280x720
		 compose:(0,0)/1280x720]
		<- "ipu1_csi0_mux":2 [ENABLED]
	pad1: Source
		[fmt:AYUV8_1X32/1280x720@1/30 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]
		-> "ipu1_ic_prp":0 []
		-> "ipu1_vdic":0 []
	pad2: Source
		[fmt:AYUV8_1X32/1280x720@1/30 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]
		-> "ipu1_csi0 capture":0 [ENABLED]

- entity 61: ipu1_csi0 capture (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video4
	pad0: Sink
		<- "ipu1_csi0":2 [ENABLED]

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
		[fmt:UYVY8_2X8/1280x720 field:none colorspace:srgb]
		<- "tda19971 2-0048":0 [ENABLED]
	pad2: Source
		[fmt:UYVY8_2X8/1280x720 field:none colorspace:srgb]
		-> "ipu1_csi0":0 [ENABLED]

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
 - with the following kernel patches:
   v4l2-subdev: clear reserved fields
   v4l2-subdev: without controls return -ENOTTY

$ v4l2-compliance -u1
v4l2-compliance SHA   : b2f8f9049056eb6f9e028927dacb2c715a062df8

Compliance test for device /dev/v4l-subdev1:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x0300008f
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x00000003 (3)
	Name             : tda19971 2-0048
	Function         : WARNING: Unknown Function (00006001), is v4l2-compliance out-of-date?
	Pad 0x01000004   : Source
	  Link 0x0200006f: to remote pad 0x1000063 of entity 'ipu1_csi0_mux': Data, Enabled

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev1 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
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
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK
	test VIDIOC_DV_TIMINGS_CAP: OK
	test VIDIOC_G/S_EDID: OK

Sub-Device ioctls (Source Pad 0):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
	test Try VIDIOC_SUBDEV_G/S_FMT: OK
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
	test Active VIDIOC_SUBDEV_G/S_FMT: OK
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Control ioctls:
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 4 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

Total: 47, Succeeded: 47, Failed: 0, Warnings: 0

$ v4l2-compliance -M0
v4l2-compliance SHA   : b2f8f9049056eb6f9e028927dacb2c715a062df8

Compliance test for device /dev/media0:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0

Required ioctls:
	test MEDIA_IOC_DEVICE_INFO: OK

Allow for multiple opens:
	test second /dev/media0 open: OK
	test MEDIA_IOC_DEVICE_INFO: OK
	test for unlimited opens: OK

Media Controller ioctls:
		fail: v4l2-test-media.cpp(96): function == MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN
		fail: v4l2-test-media.cpp(161): checkFunction(ent.function, true)
	test MEDIA_IOC_G_TOPOLOGY: FAIL
		fail: v4l2-test-media.cpp(290): num_data_links != num_links
	test MEDIA_IOC_ENUM_ENTITIES/LINKS: FAIL
	test MEDIA_IOC_SETUP_LINK: OK

Total: 7, Succeeded: 5, Failed: 2, Warnings: 0
^^^^ above failures are due to imx/adv7180 not setting a valid entity function

Hans Verkuil (1):
  v4l2-dv-timings: add v4l2_hdmi_colorimetry()

Tim Harvey (7):
  media: v4l-ioctl: fix clearing pad for VIDIOC_DV_TIMIGNS_CAP
  media: add digital video decoder video interface entity functions
  MAINTAINERS: add entry for NXP TDA1997x driver
  media: dt-bindings: Add bindings for TDA1997X
  media: i2c: Add TDA1997x HDMI receiver driver
  ARM: dts: imx: Add TDA19971 HDMI Receiver to GW54xx
  ARM: dts: imx: Add TDA19971 HDMI Receiver to GW551x

 .../devicetree/bindings/media/i2c/tda1997x.txt     |  179 ++
 Documentation/media/uapi/mediactl/media-types.rst  |   11 +
 MAINTAINERS                                        |    8 +
 arch/arm/boot/dts/imx6q-gw54xx.dts                 |  105 +
 arch/arm/boot/dts/imx6qdl-gw54xx.dtsi              |   29 +-
 arch/arm/boot/dts/imx6qdl-gw551x.dtsi              |  138 +
 drivers/media/i2c/Kconfig                          |    9 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/tda1997x.c                       | 2807 ++++++++++++++++++++
 drivers/media/i2c/tda1997x_regs.h                  |  641 +++++
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  141 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +-
 include/dt-bindings/media/tda1997x.h               |   74 +
 include/media/i2c/tda1997x.h                       |   42 +
 include/media/v4l2-dv-timings.h                    |   21 +
 include/uapi/linux/media.h                         |    5 +
 16 files changed, 4209 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tda1997x.txt
 create mode 100644 drivers/media/i2c/tda1997x.c
 create mode 100644 drivers/media/i2c/tda1997x_regs.h
 create mode 100644 include/dt-bindings/media/tda1997x.h
 create mode 100644 include/media/i2c/tda1997x.h

-- 
2.7.4
