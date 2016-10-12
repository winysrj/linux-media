Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:49013 "EHLO
        relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933237AbcJLOZP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:25:15 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert@linux-m68k.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [RFC 0/5] Add V4L2 SDR (DRIF & MAX2175) driver
Date: Wed, 12 Oct 2016 15:10:24 +0100
Message-Id: <1476281429-27603-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This RFC patch set contains two drivers
 - Digital Radio Interface (DRIF) driver
 - Maxim's MAX2175 RF to Bits tuner driver

These patches were based on top of Mauro's media-next repo
commit: 02a628e5c024cf67bf10bc822fb9169713f8ea74

These two drivers combined together expose a V4L2 SDR device that is compliant
with the V4L2 framework.

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

Driver design:
--------------

Some important design decisions are listed below

- DRIF registers as main V4L2 SDR device & MAX2175 registers as V4L2 sub-device.
- DRIF expects a tuner device to attach asynchronously at runtime and the module
  loading order is independent of each other.
- The tuner device can be provided by any third party vendor (in this case
  MAX2175).
- The mapping between DRIF & tuner device is achieved through device tree port
  & endpoint configuration of the board.

  e.g.

  drif node:

        port {
                drif0_ep: endpoint {
                     remote-endpoint = <&max2175_0_ep>;
                };
	};

  max2175 node:

	port {
		max2175_0_ep: endpoint {
			remote-endpoint = <&drif0_ep>;
		};
	};

- The combined driver is V4L2 compliant as here [1]
- In this RFC patch the MAX2175 tuner supports only DAB1.2 mode, which uses
  16bit word length.

New SDR formats:
----------------
The combined driver exposes new SDR formats. DRIF as such requires the receive
word length as the only programmable parameter in a normal case. Otherwise it is
agnostic of the tuner.

V4L2 framework requires publishing SDR formats about position of I & Q data
within the buffers. I have published three such formats to give an example.

Topic for discussion:
---------------------
One of the design goals is keep DRIF & tuner driver as much independent as
possible. However, there are few things that are up for discussion

- SDR formats:
  --------------
  For e.g. when MAX2175 is configured in one of the FM modes it can do 80bit
  word length. By default only 18bits would be valid data in each data line
  and 2 bits would be status bits and the rest are stuff bits (zeros typically).
  However, it also supports a mode for some cases where it can do
  I&Q multiplexing by using SD0 data line alone. In that case, the device
  can send the samples in one of the following combinations

  <-------------- 80 bits ---------------------------->
  <--14I + 2Status + 14Q + 2Status--- 48 stuff bits --> I2S mode = 2
  <--18I + 2Status + 18Q + 2Status--- 40 stuff bits --> I2S mode = 3
  <--16I + 16Q ---------------------- 48 stuff bits --> I2S mode = 4

  DRIF will receive these 80bit word as four 32bits each having 20bit of valid
  data. Usually the 80bit word is received as

  <---------------32bits----------->
  <--20bits data---- 12bits zeros--> 0
  <--20bits data---- 12bits zeros--> 1
  <--20bits data---- 12bits zeros--> 2
  <--20bits data---- 12bits zeros--> 3

  For e.g. if MAX2175 uses 80bits=>14I+2+14Q+2 format, the placement of I & Q
  bits in DRIF buffers would be as below

  <-------------------------32bits---------------------->
  <--- 20bits = I[13:0]+2+Q[13:10]---- 12bit zeros------> 0
  <--- 20bits = Q[9:0]+2+ stuffbits[7:0]---12bit zeros--> 1
  <--- 20bits = stuffbits  ----------- 12bit zeros------> 2
  <--- 20bits = stuffbits  ----------- 12bit zeros------> 3

  As you can see neither MAX2175 or DRIF alone can fully define the
  V4L2 SDR format. It is a combination of both.

  - Should we define a SDR format for each such possibility?
  - If a new tuner vendors wants to add support, existing formats MAY still be
    reusable and new formats may be needed based on the tuner capability.

I would appreciate any feedback you may have?


References:
------------
[1] v4l2-compliance test report

root@salvator-x:~# v4l2-compliance -S /dev/swradio0
v4l2-compliance SHA   : 7c2664b9a9b411d8b183009146e4f8548ca1d81a

Driver Info:
        Driver name   : rcar_drif
        Card type     : R-Car DRIF
        Bus info      : platform:R-Car DRIF
        Driver version: 4.8.0
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
        test VIDIOC_DBG_G/S_REGISTER: OK
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
                Standard Controls: 5 Private Controls: 5

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
Ramesh Shanmugasundaram (5):
  media: i2c: max2175: Add MAX2175 support
  media: v4l2-ctrls: Reserve controls for MAX217X
  media: platform: rcar_drif: Add DRIF support
  media: Add new SDR formats SC16, SC18 & SC20
  doc_rst: media: New SDR formats SC16, SC18 & SC20

 .../devicetree/bindings/media/i2c/max2175.txt      |   60 +
 .../devicetree/bindings/media/renesas,drif.txt     |  109 ++
 .../media/uapi/v4l/pixfmt-sdr-scu16be.rst          |   44 +
 .../media/uapi/v4l/pixfmt-sdr-scu18be.rst          |   48 +
 .../media/uapi/v4l/pixfmt-sdr-scu20be.rst          |   48 +
 Documentation/media/uapi/v4l/sdr-formats.rst       |    3 +
 drivers/media/i2c/Kconfig                          |    4 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/max2175/Kconfig                  |    8 +
 drivers/media/i2c/max2175/Makefile                 |    4 +
 drivers/media/i2c/max2175/max2175.c                | 1624 ++++++++++++++++++++
 drivers/media/i2c/max2175/max2175.h                |  124 ++
 drivers/media/platform/Kconfig                     |   25 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/rcar_drif.c                 | 1534 ++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c               |    3 +
 include/uapi/linux/v4l2-controls.h                 |    5 +
 include/uapi/linux/videodev2.h                     |    3 +
 18 files changed, 3649 insertions(+)
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

