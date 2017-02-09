Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:31963 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751775AbdBIRfa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Feb 2017 12:35:30 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v3 0/3] Add support for MPEG-2 in DELTA video decoder
Date: Thu, 9 Feb 2017 18:07:02 +0100
Message-ID: <1486660025-25678-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patchset implements the MPEG-2 part of V4L2 unified low-level decoder
API RFC [0] needed by stateless video decoders, ie decoders which requires
specific parsing metadata in addition to video bitstream chunk in order
to complete decoding.
A reference implementation using STMicroelectronics DELTA video decoder
is provided as initial support in this patchset.
In addition to this patchset, a libv4l plugin is also provided which convert
MPEG-2 video bitstream to "parsed MPEG-2" by parsing the user video bitstream
and filling accordingly the dedicated controls, doing so user code remains
unchanged whatever decoder is: stateless or not.

The first patch implements the MPEG-2 part of V4L2 unified low-level decoder
API RFC [0]. A dedicated "parsed MPEG-2" pixel format has been introduced with
its related extended controls in order that user provides both video bitstream
chunk and the associated extra data resulting from this video bitstream chunk
parsing.

The second patch adds the support of "parsed" pixel format inside DELTA video
decoder including handling of the dedicated controls and setting of parsing
metadata required by decoder layer.
Please note that the current implementation has a restriction regarding
the atomicity of S_EXT_CTRL/QBUF that must be guaranteed by user.
This restriction will be removed when V4L2 request API will be implemented [1].
Please also note the failure in v4l2-compliance in controls section, related
to complex compound controls handling, to be discussed to find the right way
to fix it in v4l2-compliance.

The third patch adds the support of DELTA MPEG-2 stateless video decoder back-end.


This driver depends on:
  [PATCH v7 00/10] Add support for DELTA video decoder of STMicroelectronics STiH4xx SoC series https://patchwork.linuxtv.org/patch/39186/

References:
  [0] [RFC] V4L2 unified low-level decoder API https://www.spinics.net/lists/linux-media/msg107150.html
  [1] [ANN] Report of the V4L2 Request API brainstorm meeting https://www.spinics.net/lists/linux-media/msg106699.html

===========
= history =
===========
version 3:
  - fix warning on parisc architecture

version 2:
  - rebase on top of DELTA v7, refer to [0]
  - change VIDEO_STI_DELTA_DRIVER to default=y as per Mauro recommendations

version 1:
  - Initial submission

===================
= v4l2-compliance =
===================
Below is the v4l2-compliance report, v4l2-compliance has been build from SHA1:
003f31e59f353b4aecc82e8fb1c7555964da7efa (v4l2-compliance: allow S_SELECTION to return ENOTTY)

root@sti-4:~# v4l2-compliance -d /dev/video3
v4l2-compliance SHA   : 003f31e59f353b4aecc82e8fb1c7555964da7efa


root@sti-lts:~# v4l2-compliance -d /dev/video3 
v4l2-compliance SHA   : not available

Driver Info:
	Driver name   : st-delta
	Card type     : st-delta-21.1-3
	Bus info      : platform:soc:delta0
	Driver version: 4.9.0
	Capabilities  : 0x84208000
		Video Memory-to-Memory
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04208000
		Video Memory-to-Memory
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
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		fail: ../../../../../../../../../sources/v4l-utils/utils/v4l2-compliance/v4l2-test-controls.cpp(585): g_ext_ctrls worked even when no controls are present
		test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 0 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK (Not Supported)
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		warn: ../../../../../../../../../sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(717): TRY_FMT cannot handle an invalid pixelformat.
		warn: ../../../../../../../../../sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(718): This may or may not be a problem. For more information see:
		warn: ../../../../../../../../../sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(719): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
		test VIDIOC_TRY_FMT: OK
		warn: ../../../../../../../../../sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(977): S_FMT cannot handle an invalid pixelformat.
		warn: ../../../../../../../../../sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(978): This may or may not be a problem. For more information see:
		warn: ../../../../../../../../../sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(979): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
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


Total: 43, Succeeded: 42, Failed: 1, Warnings: 6

Hugues Fruchet (3):
  [media] v4l: add parsed MPEG-2 support
  [media] st-delta: add parsing metadata controls support
  [media] st-delta: add mpeg2 support

 Documentation/media/uapi/v4l/extended-controls.rst |  363 +++++
 Documentation/media/uapi/v4l/pixfmt-013.rst        |   10 +
 drivers/media/platform/Kconfig                     |   11 +-
 drivers/media/platform/sti/delta/Makefile          |    3 +
 drivers/media/platform/sti/delta/delta-cfg.h       |    5 +
 drivers/media/platform/sti/delta/delta-mpeg2-dec.c | 1392 ++++++++++++++++++++
 drivers/media/platform/sti/delta/delta-mpeg2-fw.h  |  415 ++++++
 drivers/media/platform/sti/delta/delta-v4l2.c      |  129 +-
 drivers/media/platform/sti/delta/delta.h           |   34 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |   53 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +
 include/uapi/linux/v4l2-controls.h                 |   86 ++
 include/uapi/linux/videodev2.h                     |    8 +
 13 files changed, 2508 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/platform/sti/delta/delta-mpeg2-dec.c
 create mode 100644 drivers/media/platform/sti/delta/delta-mpeg2-fw.h

-- 
1.9.1

