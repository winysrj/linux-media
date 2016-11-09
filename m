Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:6061 "EHLO
        relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751677AbcKIPyL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Nov 2016 10:54:11 -0500
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [PATCH 0/5] Add V4L2 SDR (DRIF & MAX2175) driver
Date: Wed,  9 Nov 2016 15:44:39 +0000
Message-Id: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This patch set contains two drivers
 - R-Car Digital Radio Interface (DRIF) driver
 - Maxim's MAX2175 RF to Bits tuner driver

These patches were based on top of media-next repo
commit: 778de01402328ca88cda84491d819bfc949935ff

These two drivers combined together expose a V4L2 SDR device that is compliant
with the V4L2 framework [1]. The RFC series of these two drivers were
published few weeks ago and the discussion thread is here [2]. Agreed review
comments are incorporated in this series.

Brief description of devices below

DRIF:
-----
This is a receive only slave controller that receives data into a FIFO from a
master device and uses DMA engine to move it from device to memory. It is a
serial I/O like controller with a design goal to act as digital radio receiver
targeting SDR solutions.

MAX2175:
--------
This is a RF front end tuner device that supports tuning to different bands &
frequency. It supports I2S output with programmable word lengths & single/dual
data lines usage based on selected receive mode. Each receive mode is
designated with a sample rate.

+---------------------+                +---------------------+
|                     |-----SCK------->|                     |
| MAX2175 (master)    |-----SS-------->|  DRIF (slave)       |
|                     |-----SD0------->|                     |
|                     |-----SD1------->|                     |
+---------------------+                +---------------------+

New SDR formats:
----------------
The combined driver exposes new SDR formats. DRIF as such requires the receive
word length as the only programmable parameter in a normal case. Otherwise it is
agnostic of the tuner.

V4L2 framework requires publishing SDR formats about position of I & Q data
within the buffers. I have published three such formats to give an example. More
such formats are possible and will be added when needed.

References:
------------
[1] v4l2-compliance test report

root@salvator-x:~# v4l2-compliance -S /dev/swradio0
v4l2-compliance SHA   : 788b674f3827607c09c31be11c91638f816aa6ae

Driver Info:
        Driver name   : rcar_drif
        Card type     : R-Car DRIF
        Bus info      : platform:R-Car DRIF
        Driver version: 4.9.0
        Capabilities  : 0x85310000
                SDR Capture
                Tuner
                Read/Write
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x05310000
                SDR Capture
                Tuner
                Read/Write
                Streaming
                Extended Pix Format

Compliance test for device /dev/swradio0 (not using libv4l2):

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second sdr open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK
        test for unlimited opens: OK

Debug ioctls:
        test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
        test VIDIOC_LOG_STATUS: OK

Input ioctls:
        test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK
        test VIDIOC_G/S_FREQUENCY: OK
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 0 Audio Inputs: 0 Tuners: 1

Output ioctls:
        test VIDIOC_G/S_MODULATOR: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK
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
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 5 Private Controls: 4

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
                test Scaling: OK (Not Supported)

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

        Buffer ioctls:
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                test VIDIOC_EXPBUF: OK (Not Supported)

Test input 0:


Total: 43, Succeeded: 43, Failed: 0, Warnings: 0
root@salvator-x:~#

[2] RFC patch set discussion thread
https://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg07968.html

Ramesh Shanmugasundaram (5):
  media: v4l2-ctrls: Reserve controls for MAX217X
  media: i2c: max2175: Add MAX2175 support
  media: Add new SDR formats SC16, SC18 & SC20
  doc_rst: media: New SDR formats SC16, SC18 & SC20
  media: platform: rcar_drif: Add DRIF support

 .../devicetree/bindings/media/i2c/max2175.txt      |   61 +
 .../devicetree/bindings/media/renesas,drif.txt     |  136 ++
 .../media/uapi/v4l/pixfmt-sdr-scu16be.rst          |   80 +
 .../media/uapi/v4l/pixfmt-sdr-scu18be.rst          |   80 +
 .../media/uapi/v4l/pixfmt-sdr-scu20be.rst          |   80 +
 Documentation/media/uapi/v4l/sdr-formats.rst       |    3 +
 drivers/media/i2c/Kconfig                          |    4 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/max2175/Kconfig                  |    8 +
 drivers/media/i2c/max2175/Makefile                 |    4 +
 drivers/media/i2c/max2175/max2175.c                | 1558 +++++++++++++++++++
 drivers/media/i2c/max2175/max2175.h                |  108 ++
 drivers/media/platform/Kconfig                     |   25 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/rcar_drif.c                 | 1574 ++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c               |    3 +
 include/uapi/linux/v4l2-controls.h                 |    5 +
 include/uapi/linux/videodev2.h                     |    3 +
 18 files changed, 3735 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/max2175.txt
 create mode 100644 Documentation/devicetree/bindings/media/renesas,drif.txt
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-scu16be.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-scu18be.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-scu20be.rst
 create mode 100644 drivers/media/i2c/max2175/Kconfig
 create mode 100644 drivers/media/i2c/max2175/Makefile
 create mode 100644 drivers/media/i2c/max2175/max2175.c
 create mode 100644 drivers/media/i2c/max2175/max2175.h
 create mode 100644 drivers/media/platform/rcar_drif.c

-- 
1.9.1

