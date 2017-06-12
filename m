Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor1.renesas.com ([210.160.252.171]:58785 "EHLO
        relmlie4.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751955AbdFLNjv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 09:39:51 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [PATCH v8 0/8] Add V4L2 SDR (DRIF & MAX2175) driver
Date: Mon, 12 Jun 2017 14:26:12 +0100
Message-Id: <20170612132620.1024-1-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Hans,

This patch set contains two drivers
 - Renesas R-Car Digital Radio Interface (DRIF) driver
 - Maxim's MAX2175 RF to Bits tuner driver

These patches were based on top of media_tree.
commit: 47f910f0e0deb880c2114811f7ea1ec115a19ee4

These two drivers combined together expose a V4L2 SDR device that is compliant
with the V4L2 framework [1]. Agreed review comments are incorporated in this
series.

The rcar_drif device is modelled using "renesas,bonding" property. The
discussion on this property is available here [2].

Change history:

v7 -> v8:
 - Added MAINTAINERS entry for both drivers
 - Fixed smatch warnings on both drivers (Thank you Hans)

v6 -> v7:
 - MAX2175 I2S enable/disable control is made private (Mauro #v4l)
 - Added COMPILE_TEST to rcar_drif in Kconfig (Hans)

v5 -> v6:
 - Addressed Sakari's comments & rebased to his branch.
 - Used fwnode_ instead of of_ apis whereever applicable.

v4 -> v5:
 - Minor documentation changes. Refer individual patches.

v3 -> v4:
 - Added ACKs
rcar_drif:
 - Incorporated a number of review comments from Laurent on DRIF driver.
 - Addressed comments from Rob and Laurent on bindings.
max2175:
 - Minor changes addressing Hans and Laurent's comments

v2 -> v3:
rcar_drif:
 - Reduced DRIF DT properties to expose tested I2S mode only (Hans - discussion on #v4l)
 - Fixed error path clean up of ctrl_hdl on rcar_drif

v1 -> v2:
 - SDR formats renamed as "planar" instead of sliced (Hans)
 - Documentation formatting correction (Laurent)

 rcar_drif:
 - DT model using "bonding" property
 - Addressed Laurent's coments on bindings - DT optional parameters rename & rework
 - Addressed Han's comments on driver
 - Addressed Geert's comments on DT

 max2175:
 - Avoided scaling using method proposed by Antti. Thanks
 - Bindings is a separate patch (Rob)
 - Addressed Rob's comment on bindings
 - Added Custom controls documentation (Laurent)

[1] v4l2-compliance report:
root@salvator-x:~# v4l2-compliance -S /dev/swradio0
v4l2-compliance SHA   : d57bb8af0c71d82b702e35a7362aa077189dd593

Driver Info:
        Driver name   : rcar_drif
        Card type     : R-Car DRIF
        Bus info      : platform:R-Car DRIF
        Driver version: 4.12.0
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
                Standard Controls: 5 Private Controls: 2

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

[2] "bonding" DT property discussion (https://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg09415.html)

Ramesh Shanmugasundaram (8):
  media: v4l2-ctrls: Reserve controls for MAX217X
  dt-bindings: media: Add MAX2175 binding description
  media: i2c: max2175: Add MAX2175 support
  media: Add new SDR formats PC16, PC18 & PC20
  doc_rst: media: New SDR formats PC16, PC18 & PC20
  dt-bindings: media: Add Renesas R-Car DRIF binding
  media: platform: rcar_drif: Add DRIF support
  MAINTAINERS: Add entry for R-Car DRIF & MAX2175 drivers

 .../devicetree/bindings/media/i2c/max2175.txt      |   59 +
 .../devicetree/bindings/media/renesas,drif.txt     |  176 +++
 .../devicetree/bindings/property-units.txt         |    1 +
 .../media/uapi/v4l/pixfmt-sdr-pcu16be.rst          |   55 +
 .../media/uapi/v4l/pixfmt-sdr-pcu18be.rst          |   55 +
 .../media/uapi/v4l/pixfmt-sdr-pcu20be.rst          |   54 +
 Documentation/media/uapi/v4l/sdr-formats.rst       |    3 +
 Documentation/media/v4l-drivers/index.rst          |    1 +
 Documentation/media/v4l-drivers/max2175.rst        |   62 +
 MAINTAINERS                                        |   19 +
 drivers/media/i2c/Kconfig                          |   12 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/max2175.c                        | 1453 +++++++++++++++++++
 drivers/media/i2c/max2175.h                        |  109 ++
 drivers/media/platform/Kconfig                     |   25 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/rcar_drif.c                 | 1498 ++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c               |    3 +
 include/uapi/linux/max2175.h                       |   28 +
 include/uapi/linux/v4l2-controls.h                 |    5 +
 include/uapi/linux/videodev2.h                     |    3 +
 21 files changed, 3624 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/max2175.txt
 create mode 100644 Documentation/devicetree/bindings/media/renesas,drif.txt
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst
 create mode 100644 Documentation/media/v4l-drivers/max2175.rst
 create mode 100644 drivers/media/i2c/max2175.c
 create mode 100644 drivers/media/i2c/max2175.h
 create mode 100644 drivers/media/platform/rcar_drif.c
 create mode 100644 include/uapi/linux/max2175.h

-- 
2.12.2
