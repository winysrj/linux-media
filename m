Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:20506 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbcHOTCP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 15:02:15 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v4 00/13] pxa_camera transition to v4l2 standalone device
Date: Mon, 15 Aug 2016 21:01:50 +0200
Message-Id: <1471287723-25451-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Now only your comments have been taken between v3 and v4, the buffer sequence
number reset, and the rebase on top of v4.8-rc1, which makes the diffstat with
the former submission :
 drivers/media/i2c/mt9m111.c               | 14 ++------------
 drivers/media/platform/pxa_camera.c       | 45 +++++----------------------------------------
 drivers/media/platform/soc_camera/Kconfig | 12 ++----------
 3 files changed, 9 insertions(+), 62 deletions(-)

I've also put the whole serie here if you want to fetch and review from git directly :
 - git fetch https://github.com/rjarzmik/linux.git work/v4l2

The result of v4l-compliance -s is in [1].
The result of v4l-compliance -f is in [2].

Happy review.

--
Robert

Robert Jarzmik (13):
  media: mt9m111: make a standalone v4l2 subdevice
  media: mt9m111: use only the SRGB colorspace
  media: mt9m111: move mt9m111 out of soc_camera
  media: platform: pxa_camera: convert to vb2
  media: platform: pxa_camera: trivial move of functions
  media: platform: pxa_camera: introduce sensor_call
  media: platform: pxa_camera: make printk consistent
  media: platform: pxa_camera: add buffer sequencing
  media: platform: pxa_camera: remove set_crop
  media: platform: pxa_camera: make a standalone v4l2 device
  media: platform: pxa_camera: add debug register access
  media: platform: pxa_camera: change stop_streaming semantics
  media: platform: pxa_camera: move pxa_camera out of soc_camera

 drivers/media/i2c/Kconfig                      |    7 +
 drivers/media/i2c/Makefile                     |    1 +
 drivers/media/i2c/mt9m111.c                    | 1033 ++++++++++++
 drivers/media/i2c/soc_camera/Kconfig           |    7 +-
 drivers/media/i2c/soc_camera/Makefile          |    1 -
 drivers/media/i2c/soc_camera/mt9m111.c         | 1054 ------------
 drivers/media/platform/Kconfig                 |    8 +
 drivers/media/platform/Makefile                |    1 +
 drivers/media/platform/pxa_camera.c            | 2096 ++++++++++++++++++++++++
 drivers/media/platform/soc_camera/Kconfig      |    8 -
 drivers/media/platform/soc_camera/Makefile     |    1 -
 drivers/media/platform/soc_camera/pxa_camera.c | 1866 ---------------------
 include/linux/platform_data/media/camera-pxa.h |    2 +
 13 files changed, 3153 insertions(+), 2932 deletions(-)
 create mode 100644 drivers/media/i2c/mt9m111.c
 delete mode 100644 drivers/media/i2c/soc_camera/mt9m111.c
 create mode 100644 drivers/media/platform/pxa_camera.c
 delete mode 100644 drivers/media/platform/soc_camera/pxa_camera.c

-- 
2.1.4

[1] v4l-compliance -s
v4l2-compliance SHA   : f1348b4a819271d4138d62be5cee2e5aed1601d7

Driver Info:
	Driver name   : pxa27x-camera
	Card type     : PXA_Camera
	Bus info      : platform:pxa-camera
	Driver version: 4.8.0
	Capabilities  : 0x84200001
		Video Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04200001
		Video Capture
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
	test VIDIOC_DBG_G/S_REGISTER: OK
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
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		fail: v4l2-test-controls.cpp(782): subscribe event for control 'User Controls' failed
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 7 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK (Not Supported)
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		warn: v4l2-test-formats.cpp(717): TRY_FMT cannot handle an invalid pixelformat.
		warn: v4l2-test-formats.cpp(718): This may or may not be a problem. For more information see:
		warn: v4l2-test-formats.cpp(719): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
		test VIDIOC_TRY_FMT: OK
		warn: v4l2-test-formats.cpp(977): S_FMT cannot handle an invalid pixelformat.
		warn: v4l2-test-formats.cpp(978): This may or may not be a problem. For more information see:
		warn: v4l2-test-formats.cpp(979): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
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

Streaming ioctls:
	test read/write: OK (Not Supported)
	test MMAP: OK
	test USERPTR: OK
	test DMABUF: Cannot test, specify --expbuf-device


Total: 46, Succeeded: 45, Failed: 1, Warnings: 6


[2] v4l-compliance -f
v4l2-compliance SHA   : f1348b4a819271d4138d62be5cee2e5aed1601d7

Driver Info:
	Driver name   : pxa27x-camera
	Card type     : PXA_Camera
	Bus info      : platform:pxa-camera
	Driver version: 4.8.0
	Capabilities  : 0x84200001
		Video Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04200001
		Video Capture
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
	test VIDIOC_DBG_G/S_REGISTER: OK
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
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		fail: v4l2-test-controls.cpp(782): subscribe event for control 'User Controls' failed
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 7 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK (Not Supported)
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		warn: v4l2-test-formats.cpp(717): TRY_FMT cannot handle an invalid pixelformat.
		warn: v4l2-test-formats.cpp(718): This may or may not be a problem. For more information see:
		warn: v4l2-test-formats.cpp(719): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
		test VIDIOC_TRY_FMT: OK
		warn: v4l2-test-formats.cpp(977): S_FMT cannot handle an invalid pixelformat.
		warn: v4l2-test-formats.cpp(978): This may or may not be a problem. For more information see:
		warn: v4l2-test-formats.cpp(979): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
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

Stream using all formats:
	test MMAP for Format YUYV, Frame Size 48x32:
		Stride 96, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format YUYV, Frame Size 1280x1024:
		Stride 2560, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format YUYV, Frame Size 640x480:
		Stride 1280, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format YVYU, Frame Size 48x32:
		Stride 96, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format YVYU, Frame Size 1280x1024:
		Stride 2560, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format YVYU, Frame Size 640x480:
		Stride 1280, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format 422P, Frame Size 48x32:
		Stride 48, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format 422P, Frame Size 1280x1024:
		Stride 1280, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format 422P, Frame Size 640x480:
		Stride 640, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format UYVY, Frame Size 48x32:
		Stride 96, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format UYVY, Frame Size 1280x1024:
		Stride 2560, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format UYVY, Frame Size 640x480:
		Stride 1280, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format VYUY, Frame Size 48x32:
		Stride 96, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format VYUY, Frame Size 1280x1024:
		Stride 2560, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format VYUY, Frame Size 640x480:
		Stride 1280, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format RGBO, Frame Size 48x32:
		Stride 96, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format RGBO, Frame Size 1280x1024:
		Stride 2560, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format RGBO, Frame Size 640x480:
		Stride 1280, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format RGBQ, Frame Size 48x32:
		Stride 96, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format RGBQ, Frame Size 1280x1024:
		Stride 2560, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format RGBQ, Frame Size 640x480:
		Stride 1280, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format RGBP, Frame Size 48x32:
		Stride 96, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format RGBP, Frame Size 1280x1024:
		Stride 2560, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format RGBP, Frame Size 640x480:
		Stride 1280, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format RGBR, Frame Size 48x32:
		Stride 96, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format RGBR, Frame Size 1280x1024:
		Stride 2560, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format RGBR, Frame Size 640x480:
		Stride 1280, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format BA81, Frame Size 48x32:
		Stride 48, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format BA81, Frame Size 1280x1024:
		Stride 1280, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format BA81, Frame Size 640x480:
		Stride 640, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format BG10, Frame Size 1280x1024:
		Stride 2560, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format BG10, Frame Size 1280x1024:
		Stride 2560, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   
	test MMAP for Format BG10, Frame Size 1280x1024:
		Stride 2560, Field None: OK   
		Stride 0, Field Top: OK   
		Stride 0, Field Bottom: OK   
		Stride 0, Field Interlaced: OK   
		Stride 0, Field Sequential Top-Bottom: OK   
		Stride 0, Field Sequential Bottom-Top: OK   
		Stride 0, Field Alternating: OK   
		Stride 0, Field Interlaced Top-Bottom: OK   
		Stride 0, Field Interlaced Bottom-Top: OK   

Total: 340, Succeeded: 339, Failed: 1, Warnings: 6
