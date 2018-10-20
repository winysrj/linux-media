Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44137 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbeJTWhV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Oct 2018 18:37:21 -0400
Received: by mail-pg1-f193.google.com with SMTP id w3-v6so1475200pgs.11
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2018 07:26:42 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v4 0/6] media: video-i2c: support changing frame interval and runtime PM
Date: Sat, 20 Oct 2018 23:26:22 +0900
Message-Id: <1540045588-9091-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds support for changing frame interval and runtime PM for
video-i2c driver.  This also adds an helper macro to v4l2 common
internal API that is used to to find a suitable frame interval.

There are a couple of unrelated changes that are included for simplifying
driver initialization code and register accesses.

* v4
- Add Reviewed-by line
- Move set_power() call into release() callback

* v3
- Append result of v4l2-compliance in cover-letter
- Move the code causing use-after-free from video_i2c_remove() to the
  video device release() callback.
- Use regmap_init_i2c() instead of devm_regmap_init_i2c() and call
  regmap_exit_i2c() in video device release() callback in order to
  avoid releasing regmap when the driver is unbound.
- Add Acked-by lines

* v2
- Add Acked-by and Reviewed-by tags
- Update commit log to clarify the use after free
- Add thermistor and termperature register address definisions
- Stop adding v4l2_find_closest_fract() in v4l2 common internal API
- Add V4L2_FRACT_COMPARE() macro in v4l2 common internal API
- Use V4L2_FRACT_COMPARE() to find suitable frame interval instead of
  v4l2_find_closest_fract()
- Add comment for register address definisions

Akinobu Mita (6):
  media: video-i2c: avoid accessing released memory area when removing
    driver
  media: video-i2c: use i2c regmap
  media: v4l2-common: add V4L2_FRACT_COMPARE
  media: vivid: use V4L2_FRACT_COMPARE
  media: video-i2c: support changing frame interval
  media: video-i2c: support runtime PM

 drivers/media/i2c/video-i2c.c                | 286 +++++++++++++++++++++++----
 drivers/media/platform/vivid/vivid-vid-cap.c |   9 +-
 include/media/v4l2-common.h                  |   5 +
 3 files changed, 254 insertions(+), 46 deletions(-)

v4l2-compliance SHA: c36dbbdfa8b30b2badd4f893b59d0bd4f0bd12aa, 32 bits

Compliance test for device /dev/video2:

Driver Info:
	Driver name      : video-i2c
	Card type        : I2C 1-104 Transport Video
	Bus info         : I2C:1-104
	Driver version   : 4.19.0
	Capabilities     : 0x85200001
		Video Capture
		Read/Write
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x05200001
		Video Capture
		Read/Write
		Streaming
		Extended Pix Format

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video2 open: OK
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

Control ioctls (Input 0):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
	test VIDIOC_QUERYCTRL: OK (Not Supported)
	test VIDIOC_G/S_CTRL: OK (Not Supported)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls (Input 0):
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

Codec ioctls (Input 0):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 0):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK (Not Supported)

Total: 43, Succeeded: 43, Failed: 0, Warnings: 0

Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.7.4
