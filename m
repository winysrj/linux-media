Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:52967 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934524AbcHBOvc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2016 10:51:32 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 0/7] Fix adv7180 and rcar-vin field handling
Date: Tue,  2 Aug 2016 16:51:00 +0200
Message-Id: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series add V4L2_FIELD_ALTERNATE support to the rcar-vin driver and 
changes the field mode reported by adv7180 from V4L2_FIELD_INTERLACED to 
V4L2_FIELD_ALTERNATE.

The change field mode reported by adv7180 was first done by Steve 
Longerbeam (https://lkml.org/lkml/2016/7/23/107), I have kept and 
reworked Steves patch to report V4L2_FIELD_ALTERNATE instead of 
V4L2_FIELD_SEQ_{TB,BT}, after discussions on #v4l this seems more
correct.

The rcar-vin changes contains some bug fixes needed to enable 
V4L2_FIELD_ALTERNATE.

All work is based on top of media-next and is tested on Koelsch. Output 
of 'v4l2-compliance -fs' is attached bellow and I have tested all fields 
using qv4l2 and it looks OK to me. I need to disable 'Enable Video 
Scaling' in the 'Capture' Menu for ODD/EVEN/ALTERNATE or I get a 
horizontally stretched image. Also for ALTERNATE the 1 line difference 
between the fields are noticeable. The image jumps up/down 1 line for 
each other field, but I guess that is normal since the fields are 
different right?

This series touch two drivers which is not a good thing. But I could not 
figure out a good way to post them separately since if the adv7180 parts 
where too be merged before the rcar-vin changes the driver would stop to 
work on the Koelsch. If some one wants this series split in two let me 
know.

* Changes since v1
- Added patch so that V4L2_FIELD_INTERLACED is not treated the same as 
  V4L2_FIELD_INTERLACED_TB. Instead G_STD will be used to get the video 
  standard and make a TB/BT decision based on that.
- Add changelog to Stevens patch which I dropped by mistake when I 
  applied it to my tree.
- Add better commit message, comment explaining that INTERLACED will be 
  used as the default if the subdeivce uses ALTERNATE field mode and 
  implements G_STD.


# v4l2-compliance -d 3 -fs
v4l2-compliance SHA   : 7785594dd82b4fa04585928e5b825a0df73a2774

Driver Info:
	Driver name   : rcar_vin
	Card type     : R_Car_VIN
	Bus info      : platform:e6ef1000.video
	Driver version: 4.7.0
	Capabilities  : 0x85200001
		Video Capture
		Read/Write
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x05200001
		Video Capture
		Read/Write
		Streaming
		Extended Pix Format

Compliance test for device /dev/video3 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK

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
	test VIDIOC_ENUM/G/S/QUERY_STD: OK
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

Test input 0:

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 5 Private Controls: 1

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		test VIDIOC_TRY_FMT: OK
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK
		test Composing: OK
		test Scaling: OK

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK

Test input 0:

Streaming ioctls:
	test read/write: OK
	test MMAP: OK
	test USERPTR: OK (Not Supported)
	test DMABUF: Cannot test, specify --expbuf-device

Stream using all formats:
	test MMAP for Format NV16, Frame Size 2x4:
		Crop 720x480@0x0, Compose 6x4@0x0, Stride 32, Field None: OK
		Crop 720x240@0x0, Compose 6x4@0x0, Stride 32, Field Top: OK
		Crop 720x240@0x0, Compose 6x4@0x0, Stride 32, Field Bottom: OK
		Crop 720x240@0x0, Compose 6x4@0x0, Stride 32, Field Interlaced: OK
		Crop 720x240@0x0, Compose 6x4@0x0, Stride 32, Field Alternating: OK
		Crop 720x240@0x0, Compose 6x4@0x0, Stride 32, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 6x4@0x0, Stride 32, Field Interlaced Bottom-Top: OK
	test MMAP for Format NV16, Frame Size 2048x2048:
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 2048, Field None: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 2048, Field Top: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 2048, Field Bottom: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 2048, Field Interlaced: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 2048, Field Alternating: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 2048, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 2048, Field Interlaced Bottom-Top: OK
	test MMAP for Format NV16, Frame Size 736x480:
		Crop 720x480@0x0, Compose 736x480@0x0, Stride 736, Field None: OK
		Crop 720x240@0x0, Compose 736x480@0x0, Stride 736, Field Top: OK
		Crop 720x240@0x0, Compose 736x480@0x0, Stride 736, Field Bottom: OK
		Crop 720x240@0x0, Compose 736x480@0x0, Stride 736, Field Interlaced: OK
		Crop 720x240@0x0, Compose 736x480@0x0, Stride 736, Field Alternating: OK
		Crop 720x240@0x0, Compose 736x480@0x0, Stride 736, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 736x480@0x0, Stride 736, Field Interlaced Bottom-Top: OK
	test MMAP for Format YUYV, Frame Size 32x4:
		Crop 720x480@0x0, Compose 32x4@0x0, Stride 64, Field None: OK
		Crop 720x240@0x0, Compose 32x4@0x0, Stride 64, Field Top: OK
		Crop 720x240@0x0, Compose 32x4@0x0, Stride 64, Field Bottom: OK
		Crop 720x240@0x0, Compose 32x4@0x0, Stride 64, Field Interlaced: OK
		Crop 720x240@0x0, Compose 32x4@0x0, Stride 64, Field Alternating: OK
		Crop 720x240@0x0, Compose 32x4@0x0, Stride 64, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 32x4@0x0, Stride 64, Field Interlaced Bottom-Top: OK
	test MMAP for Format YUYV, Frame Size 2048x2048:
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field None: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Top: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Bottom: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Alternating: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Bottom-Top: OK
	test MMAP for Format YUYV, Frame Size 736x480:
		Crop 720x480@0x0, Compose 736x480@0x0, Stride 1472, Field None: OK
		Crop 720x240@0x0, Compose 736x480@0x0, Stride 1472, Field Top: OK
		Crop 720x240@0x0, Compose 736x480@0x0, Stride 1472, Field Bottom: OK
		Crop 720x240@0x0, Compose 736x480@0x0, Stride 1472, Field Interlaced: OK
		Crop 720x240@0x0, Compose 736x480@0x0, Stride 1472, Field Alternating: OK
		Crop 720x240@0x0, Compose 736x480@0x0, Stride 1472, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 736x480@0x0, Stride 1472, Field Interlaced Bottom-Top: OK
	test MMAP for Format UYVY, Frame Size 2x4:
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field None: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Top: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Bottom: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Alternating: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Bottom-Top: OK
	test MMAP for Format UYVY, Frame Size 2048x2048:
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field None: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Top: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Bottom: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Alternating: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Bottom-Top: OK
	test MMAP for Format UYVY, Frame Size 720x480:
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field None: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Top: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Bottom: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Alternating: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced Bottom-Top: OK
	test MMAP for Format RGBP, Frame Size 2x4:
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field None: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Top: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Bottom: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Alternating: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Bottom-Top: OK
	test MMAP for Format RGBP, Frame Size 2048x2048:
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field None: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Top: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Bottom: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Alternating: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Bottom-Top: OK
	test MMAP for Format RGBP, Frame Size 720x480:
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field None: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Top: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Bottom: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Alternating: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced Bottom-Top: OK
	test MMAP for Format XR15, Frame Size 2x4:
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field None: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Top: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Bottom: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Alternating: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Bottom-Top: OK
	test MMAP for Format XR15, Frame Size 2048x2048:
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field None: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Top: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Bottom: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Alternating: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Bottom-Top: OK
	test MMAP for Format XR15, Frame Size 720x480:
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field None: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Top: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Bottom: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Alternating: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced Bottom-Top: OK
	test MMAP for Format XR24, Frame Size 2x4:
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 8, Field None: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 8, Field Top: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 8, Field Bottom: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 8, Field Interlaced: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 8, Field Alternating: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 8, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 2x4@0x0, Stride 8, Field Interlaced Bottom-Top: OK
	test MMAP for Format XR24, Frame Size 2048x2048:
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 8192, Field None: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 8192, Field Top: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 8192, Field Bottom: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 8192, Field Interlaced: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 8192, Field Alternating: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 8192, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 2048x2048@0x0, Stride 8192, Field Interlaced Bottom-Top: OK
	test MMAP for Format XR24, Frame Size 720x480:
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 2880, Field None: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 2880, Field Top: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 2880, Field Bottom: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 2880, Field Interlaced: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 2880, Field Alternating: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 2880, Field Interlaced Top-Bottom: OK
		Crop 720x240@0x0, Compose 720x480@0x0, Stride 2880, Field Interlaced Bottom-Top: OK

Total: 172, Succeeded: 172, Failed: 0, Warnings: 0

Niklas Söderlund (6):
  media: rcar-vin: make V4L2_FIELD_INTERLACED standard dependent
  media: rcar-vin: allow field to be changed
  media: rcar-vin: fix bug in scaling
  media: rcar-vin: fix height for TOP and BOTTOM fields
  media: rcar-vin: add support for V4L2_FIELD_ALTERNATE
  media: adv7180: fill in mbus format in set_fmt

Steve Longerbeam (1):
  media: adv7180: fix field type

 drivers/media/i2c/adv7180.c                 |  21 ++--
 drivers/media/platform/rcar-vin/rcar-dma.c  |  34 ++++--
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 156 +++++++++++++++++-----------
 3 files changed, 136 insertions(+), 75 deletions(-)

-- 
2.9.0

