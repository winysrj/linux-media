Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:2631 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751689AbcKRLZ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 06:25:59 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v2 00/10] Add support for DELTA video decoder of STMicroelectronics STiH4xx SoC series
Date: Fri, 18 Nov 2016 12:25:26 +0100
Message-ID: <1479468336-26199-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset introduces a basic support for DELTA multi-format video decoder
of STMicroelectronics STiH4xx SoC series.

DELTA hardware IP is controlled by a remote firmware loaded in a ST231
coprocessor. Communication with firmware is done within an IPC layer
using rpmsg kernel framework and a shared memory for messages handling.
This driver is compatible with firmware version 21.1-3.
While a single firmware is loaded in ST231 coprocessor, it is composed
of several firmwares, one per video format family.

This DELTA V4L2 driver is designed around files:
  - delta-v4l2.c   : handles V4L2 APIs using M2M framework and calls decoder ops
  - delta-<codec>* : implements <codec> decoder calling its associated
                     video firmware (for ex. MJPEG) using IPC layer
  - delta-ipc.c    : IPC layer which handles communication with firmware using rpmsg

This first basic support implements only MJPEG hardware acceleration but
the driver structure is in place to support all the features of the
DELTA video decoder hardware IP.

This driver depends on:
  - ST remoteproc/rpmsg: patchset posted at https://lkml.org/lkml/2016/9/6/77
  - ST DELTA firmware: its license is under review. When available,
    pull request will be done on linux-firmware.

===========
= history =
===========
version 2
  - update after v1 review:
    - simplified tracing
    - G_/S_SELECTION reworked to fit COMPOSE(CAPTURE)
    - fixed m2m_buf_done missing on start_streaming error case
    - fixed q->dev missing in queue_init()
  - switch to kernel-4.9 rpmsg API
  - DELTA support added in multi_v7_defconfig
  - minor typo fixes & code cleanup

version 1:
  - Initial submission

===================
= v4l2-compliance =
===================
Below is the v4l2-compliance report for the version 2 of the DELTA video
decoder driver. v4l2-compliance has been build from SHA1:
600492351ddf40cc524aab73802153674d7d287b (libdvb5: Fix multiple definition of dvb_dev_remote_init linking error)

root@sti-next:~# v4l2-compliance -d /dev/video0
v4l2-compliance SHA   : 600492351ddf40cc524aab73802153674d7d287b

Driver Info:
	Driver name   : st-delta
	Card type     : st-delta-21.1-3
	Bus info      : platform:soc:delta0
	Driver version: 4.8.0
	Capabilities  : 0x84208000
		Video Memory-to-Memory
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04208000
		Video Memory-to-Memory
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
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

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
		warn: sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(717): TRY_FMT cannot handle an invalid pixelformat.
		warn: sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(718): This may or may not be a problem. For more information see:
		warn: sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(719): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
		test VIDIOC_TRY_FMT: OK
		warn: sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(977): S_FMT cannot handle an invalid pixelformat.
		warn: sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(978): This may or may not be a problem. For more information see:
		warn: sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(979): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK (Not Supported)
		test Composing: OK
		test Scaling: OK

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK

Test input 0:


Total: 43, Succeeded: 43, Failed: 0, Warnings: 6

Hugues Fruchet (10):
  Documentation: DT: add bindings for ST DELTA
  ARM: dts: STiH410: add DELTA dt node
  ARM: multi_v7_defconfig: enable STMicroelectronics DELTA Support
  [media] MAINTAINERS: add st-delta driver
  [media] st-delta: STiH4xx multi-format video decoder v4l2 driver
  [media] st-delta: add contiguous memory allocator
  [media] st-delta: rpmsg ipc support
  [media] st-delta: EOS (End Of Stream) support
  [media] st-delta: add mjpeg support
  [media] st-delta: debug: trace stream/frame information & summary

 .../devicetree/bindings/media/st,st-delta.txt      |   17 +
 MAINTAINERS                                        |    8 +
 arch/arm/boot/dts/stih410.dtsi                     |   10 +
 arch/arm/configs/multi_v7_defconfig                |    1 +
 drivers/media/platform/Kconfig                     |   27 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/sti/delta/Makefile          |    6 +
 drivers/media/platform/sti/delta/delta-cfg.h       |   63 +
 drivers/media/platform/sti/delta/delta-debug.c     |   72 +
 drivers/media/platform/sti/delta/delta-debug.h     |   18 +
 drivers/media/platform/sti/delta/delta-ipc.c       |  590 ++++++
 drivers/media/platform/sti/delta/delta-ipc.h       |   76 +
 drivers/media/platform/sti/delta/delta-mem.c       |   51 +
 drivers/media/platform/sti/delta/delta-mem.h       |   14 +
 drivers/media/platform/sti/delta/delta-mjpeg-dec.c |  454 +++++
 drivers/media/platform/sti/delta/delta-mjpeg-fw.h  |  221 +++
 drivers/media/platform/sti/delta/delta-mjpeg-hdr.c |  150 ++
 drivers/media/platform/sti/delta/delta-mjpeg.h     |   35 +
 drivers/media/platform/sti/delta/delta-v4l2.c      | 1989 ++++++++++++++++++++
 drivers/media/platform/sti/delta/delta.h           |  566 ++++++
 20 files changed, 4370 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,st-delta.txt
 create mode 100644 drivers/media/platform/sti/delta/Makefile
 create mode 100644 drivers/media/platform/sti/delta/delta-cfg.h
 create mode 100644 drivers/media/platform/sti/delta/delta-debug.c
 create mode 100644 drivers/media/platform/sti/delta/delta-debug.h
 create mode 100644 drivers/media/platform/sti/delta/delta-ipc.c
 create mode 100644 drivers/media/platform/sti/delta/delta-ipc.h
 create mode 100644 drivers/media/platform/sti/delta/delta-mem.c
 create mode 100644 drivers/media/platform/sti/delta/delta-mem.h
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg-dec.c
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg-fw.h
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg-hdr.c
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg.h
 create mode 100644 drivers/media/platform/sti/delta/delta-v4l2.c
 create mode 100644 drivers/media/platform/sti/delta/delta.h

-- 
1.9.1

