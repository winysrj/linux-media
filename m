Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:32878 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932568AbcIBQqz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2016 12:46:55 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, hans.verkuil@cisco.com
Cc: slongerbeam@gmail.com, lars@metafoo.de, mchehab@kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv3 0/6] Fix rcar-vin field handling
Date: Fri,  2 Sep 2016 18:44:55 +0200
Message-Id: <20160902164501.19535-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series deals with how fields are handled in the rcar-vin driver.  
The current state is that the user is forced to use whatever field type 
is set by the subdevice. This series allows the user to freely choose 
the filed type.

It fixes the current handling of V4L2_FIELD_INTERLACED so that it 
depends on the current video standard to select between TB or BT mode 
(if the video standard can be determined that is). It also adds support 
for V4L2_FIELD_ALTERNATE.

All work is based on top of media-tree and is tested on Koelsch. Output 
of 'v4l2-compliance -fs' is attached bellow and I have tested all fields 
using qv4l2 and it looks OK to me. I need to disable 'Enable Video 
Scaling' in the 'Capture' Menu for ODD/EVEN/ALTERNATE or I get a 
horizontally stretched image. Also for ALTERNATE the 1 line difference 
between the fields are noticeable. The image jumps up/down 1 line for 
each other field, but I guess that is normal since the fields are 
different right?

# v4l2-compliance -d 2 -fs
v4l2-compliance SHA   : a737a6161485fffb70bf51e4fd7f6e2d910174c1

Driver Info:
	Driver name   : rcar_vin
	Card type     : R_Car_VIN
	Bus info      : platform:e6ef1000.video
	Driver version: 4.8.0
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

Compliance test for device /dev/video2 (not using libv4l2):

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
	test MMAP: OKg
	test USERPTR: OK (Not Supported)
	test DMABUF: Cannot test, specify --expbuf-device

Stream using all formats:
	test MMAP for Format NV16, Frame Size 2x4:
		Crop 720x576@0x0, Compose 6x4@0x0, Stride 32, Field None: OKg
		Crop 720x288@0x0, Compose 6x4@0x0, Stride 32, Field Top: OKg
		Crop 720x288@0x0, Compose 6x4@0x0, Stride 32, Field Bottom: OKg
		Crop 720x288@0x0, Compose 6x4@0x0, Stride 32, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 6x4@0x0, Stride 32, Field Alternating: OKg
		Crop 720x288@0x0, Compose 6x4@0x0, Stride 32, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 6x4@0x0, Stride 32, Field Interlaced Bottom-Top: OKg
	test MMAP for Format NV16, Frame Size 2048x2048:
		Crop 720x576@0x0, Compose 2048x2048@0x0, Stride 2048, Field None: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 2048, Field Top: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 2048, Field Bottom: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 2048, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 2048, Field Alternating: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 2048, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 2048, Field Interlaced Bottom-Top: OKg
	test MMAP for Format NV16, Frame Size 736x576:
		Crop 720x576@0x0, Compose 736x576@0x0, Stride 736, Field None: OKg
		Crop 720x288@0x0, Compose 736x576@0x0, Stride 736, Field Top: OKg
		Crop 720x288@0x0, Compose 736x576@0x0, Stride 736, Field Bottom: OKg
		Crop 720x288@0x0, Compose 736x576@0x0, Stride 736, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 736x576@0x0, Stride 736, Field Alternating: OKg
		Crop 720x288@0x0, Compose 736x576@0x0, Stride 736, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 736x576@0x0, Stride 736, Field Interlaced Bottom-Top: OKg
	test MMAP for Format YUYV, Frame Size 32x4:
		Crop 720x576@0x0, Compose 32x4@0x0, Stride 64, Field None: OKg
		Crop 720x288@0x0, Compose 32x4@0x0, Stride 64, Field Top: OKg
		Crop 720x288@0x0, Compose 32x4@0x0, Stride 64, Field Bottom: OKg
		Crop 720x288@0x0, Compose 32x4@0x0, Stride 64, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 32x4@0x0, Stride 64, Field Alternating: OKg
		Crop 720x288@0x0, Compose 32x4@0x0, Stride 64, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 32x4@0x0, Stride 64, Field Interlaced Bottom-Top: OKg
	test MMAP for Format YUYV, Frame Size 2048x2048:
		Crop 720x576@0x0, Compose 2048x2048@0x0, Stride 4096, Field None: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Top: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Bottom: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Alternating: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Bottom-Top: OKg
	test MMAP for Format YUYV, Frame Size 736x576:
		Crop 720x576@0x0, Compose 736x576@0x0, Stride 1472, Field None: OKg
		Crop 720x288@0x0, Compose 736x576@0x0, Stride 1472, Field Top: OKg
		Crop 720x288@0x0, Compose 736x576@0x0, Stride 1472, Field Bottom: OKg
		Crop 720x288@0x0, Compose 736x576@0x0, Stride 1472, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 736x576@0x0, Stride 1472, Field Alternating: OKg
		Crop 720x288@0x0, Compose 736x576@0x0, Stride 1472, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 736x576@0x0, Stride 1472, Field Interlaced Bottom-Top: OKg
	test MMAP for Format UYVY, Frame Size 2x4:
		Crop 720x576@0x0, Compose 2x4@0x0, Stride 4, Field None: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Top: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Bottom: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Alternating: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Bottom-Top: OKg
	test MMAP for Format UYVY, Frame Size 2048x2048:
		Crop 720x576@0x0, Compose 2048x2048@0x0, Stride 4096, Field None: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Top: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Bottom: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Alternating: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Bottom-Top: OKg
	test MMAP for Format UYVY, Frame Size 720x576:
		Crop 720x576@0x0, Compose 720x576@0x0, Stride 1440, Field None: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Top: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Bottom: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Alternating: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Interlaced Bottom-Top: OKg
	test MMAP for Format RGBP, Frame Size 2x4:
		Crop 720x576@0x0, Compose 2x4@0x0, Stride 4, Field None: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Top: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Bottom: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Alternating: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Bottom-Top: OKg
	test MMAP for Format RGBP, Frame Size 2048x2048:
		Crop 720x576@0x0, Compose 2048x2048@0x0, Stride 4096, Field None: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Top: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Bottom: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Alternating: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Bottom-Top: OKg
	test MMAP for Format RGBP, Frame Size 720x576:
		Crop 720x576@0x0, Compose 720x576@0x0, Stride 1440, Field None: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Top: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Bottom: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Alternating: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Interlaced Bottom-Top: OKg
	test MMAP for Format XR15, Frame Size 2x4:
		Crop 720x576@0x0, Compose 2x4@0x0, Stride 4, Field None: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Top: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Bottom: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Alternating: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Bottom-Top: OKg
	test MMAP for Format XR15, Frame Size 2048x2048:
		Crop 720x576@0x0, Compose 2048x2048@0x0, Stride 4096, Field None: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Top: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Bottom: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Alternating: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Bottom-Top: OKg
	test MMAP for Format XR15, Frame Size 720x576:
		Crop 720x576@0x0, Compose 720x576@0x0, Stride 1440, Field None: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Top: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Bottom: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Alternating: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 1440, Field Interlaced Bottom-Top: OKg
	test MMAP for Format XR24, Frame Size 2x4:
		Crop 720x576@0x0, Compose 2x4@0x0, Stride 8, Field None: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 8, Field Top: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 8, Field Bottom: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 8, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 8, Field Alternating: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 8, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 2x4@0x0, Stride 8, Field Interlaced Bottom-Top: OKg
	test MMAP for Format XR24, Frame Size 2048x2048:
		Crop 720x576@0x0, Compose 2048x2048@0x0, Stride 8192, Field None: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 8192, Field Top: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 8192, Field Bottom: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 8192, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 8192, Field Alternating: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 8192, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 2048x2048@0x0, Stride 8192, Field Interlaced Bottom-Top: OKg
	test MMAP for Format XR24, Frame Size 720x576:
		Crop 720x576@0x0, Compose 720x576@0x0, Stride 2880, Field None: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 2880, Field Top: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 2880, Field Bottom: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 2880, Field Interlaced: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 2880, Field Alternating: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 2880, Field Interlaced Top-Bottom: OKg
		Crop 720x288@0x0, Compose 720x576@0x0, Stride 2880, Field Interlaced Bottom-Top: OKg

Total: 172, Succeeded: 172, Failed: 0, Warnings: 0

* Changes since v2
- Dropped the patch from Steve Longerbeam which changed the filed type 
  reported by the adv7180 since discussion is still ongoing on how to 
  best solve it. It was this patch that sparked this series so that the 
  rcar-vin driver could be able to handle the V4L2_FIELD_ALTERNATE type 
  which was suggested by Steve's patch for the adv7180 at some point.
- Reorderd the order of the patches so the 'media: adv7180: fill in mbus 
  format in set_fmt' is first in the series as the rcar-vin patches 
  depends on the mbus format being set in set_fmt. This was overlooked 
  in previous versions..
- Fixed spelling and a style error pointed out by Sergei Shtylyov, thanks!
- Rebased on top of latest media-tree master branch which have picked up 
  some other rcar-vin cleanup patches to ease the merge.

* Changes since v1
- Added patch so that V4L2_FIELD_INTERLACED is not treated the same as 
  V4L2_FIELD_INTERLACED_TB. Instead G_STD will be used to get the video 
  standard and make a TB/BT decision based on that.
- Add changelog to Stevens patch which I dropped by mistake when I 
  applied it to my tree.
- Add better commit message, comment explaining that INTERLACED will be 
  used as the default if the subdeivce uses ALTERNATE field mode and 
  implements G_STD.

Niklas Söderlund (6):
  media: adv7180: fill in mbus format in set_fmt
  media: rcar-vin: make V4L2_FIELD_INTERLACED standard dependent
  media: rcar-vin: allow field to be changed
  media: rcar-vin: fix bug in scaling
  media: rcar-vin: fix height for TOP and BOTTOM fields
  media: rcar-vin: add support for V4L2_FIELD_ALTERNATE

 drivers/media/i2c/adv7180.c                 |   6 +-
 drivers/media/platform/rcar-vin/rcar-dma.c  |  35 +++++--
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 156 +++++++++++++++++-----------
 3 files changed, 126 insertions(+), 71 deletions(-)

-- 
2.9.3

