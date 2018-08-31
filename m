Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:51277 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbeHaM6j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 08:58:39 -0400
Received: by mail-wm0-f67.google.com with SMTP id y2-v6so4456312wma.1
        for <linux-media@vger.kernel.org>; Fri, 31 Aug 2018 01:52:11 -0700 (PDT)
From: Maxime Jourdan <mjourdan@baylibre.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: Maxime Jourdan <mjourdan@baylibre.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH 0/4] Add Amlogic video decoder driver
Date: Fri, 31 Aug 2018 10:52:01 +0200
Message-Id: <20180831085205.14760-1-mjourdan@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

This patch series adds support for the Amlogic video decoder,
as well as the corresponding dt bindings for GXBB/GXL/GXM chips.

It features decoding for the following formats:
- MPEG 1
- MPEG 2

The following formats will be added in future patches:
- MJPEG
- MPEG 4 (incl. Xvid, H.263)
- H.264
- HEVC (incl. 10-bit)

The following formats' development has still not started, but they are
supported by the hardware:
- VC1
- VP9

The code was made in such a way to allow easy inclusion of those formats
in the future.

The decoder is single instance.

Files:
 - vdec.c handles the V4L2 M2M logic
 - esparser.c manages the hardware bitstream parser
 - vdec_helpers.c provides helpers to DONE the dst buffers as well as
 various common code used by the codecs
 - vdec_1.c manages the VDEC_1 block of the vdec IP
 - codec_mpeg12.c enables decoding for MPEG 1/2.
 - vdec_platform.c links codec units with vdec units
 (e.g vdec_1 with codec_mpeg12) and lists all the available
 src/dst formats and requirements (max width/height, etc.),
 per compatible chip.

Firmwares are necessary to run the vdec. They can currently be found at:
https://github.com/chewitt/meson-firmware

It was tested primarily with ffmpeg's v4l2-m2m implementation. For instance:
$ ffmpeg -c:v mpeg2_v4l2m2m -i sample_mpeg2.mkv -f null -

Note: This patch series depends on
"[PATCH v3 0/3] soc: amlogic: add meson-canvas"
https://patchwork.kernel.org/cover/10573763/

The v4l2-compliance results are available below the patch diff.

Maxime Jourdan (4):
  dt-bindings: media: add Amlogic Video Decoder Bindings
  media: meson: add v4l2 m2m video decoder driver
  ARM64: dts: meson-gx: add vdec entry
  ARM64: dts: meson: add vdec entries

 .../bindings/media/amlogic,vdec.txt           |  63 ++
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi     |  13 +
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi   |  11 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |  11 +
 arch/arm64/boot/dts/amlogic/meson-gxm.dtsi    |   4 +
 drivers/media/platform/Kconfig                |  10 +
 drivers/media/platform/meson/Makefile         |   1 +
 drivers/media/platform/meson/vdec/Makefile    |   8 +
 .../media/platform/meson/vdec/codec_mpeg12.c  | 169 +++
 .../media/platform/meson/vdec/codec_mpeg12.h  |  13 +
 drivers/media/platform/meson/vdec/dos_regs.h  |  97 ++
 drivers/media/platform/meson/vdec/esparser.c  | 367 +++++++
 drivers/media/platform/meson/vdec/esparser.h  |  27 +
 drivers/media/platform/meson/vdec/vdec.c      | 987 ++++++++++++++++++
 drivers/media/platform/meson/vdec/vdec.h      | 233 +++++
 drivers/media/platform/meson/vdec/vdec_1.c    | 227 ++++
 drivers/media/platform/meson/vdec/vdec_1.h    |  13 +
 .../media/platform/meson/vdec/vdec_helpers.c  | 353 +++++++
 .../media/platform/meson/vdec/vdec_helpers.h  |  44 +
 .../media/platform/meson/vdec/vdec_platform.c | 100 ++
 .../media/platform/meson/vdec/vdec_platform.h |  29 +
 21 files changed, 2780 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/amlogic,vdec.txt
 create mode 100644 drivers/media/platform/meson/vdec/Makefile
 create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg12.c
 create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg12.h
 create mode 100644 drivers/media/platform/meson/vdec/dos_regs.h
 create mode 100644 drivers/media/platform/meson/vdec/esparser.c
 create mode 100644 drivers/media/platform/meson/vdec/esparser.h
 create mode 100644 drivers/media/platform/meson/vdec/vdec.c
 create mode 100644 drivers/media/platform/meson/vdec/vdec.h
 create mode 100644 drivers/media/platform/meson/vdec/vdec_1.c
 create mode 100644 drivers/media/platform/meson/vdec/vdec_1.h
 create mode 100644 drivers/media/platform/meson/vdec/vdec_helpers.c
 create mode 100644 drivers/media/platform/meson/vdec/vdec_helpers.h
 create mode 100644 drivers/media/platform/meson/vdec/vdec_platform.c
 create mode 100644 drivers/media/platform/meson/vdec/vdec_platform.h

root@libretech-cc:~/v4l-utils# v4l2-compliance -d /dev/video0 
v4l2-compliance SHA: not available, 64 bits

Compliance test for device /dev/video0:

Driver Info:
	Driver name      : meson-vdec
	Card type        : Amlogic Video Decoder
	Bus info         : platform:meson-vdec
	Driver version   : 4.18.0
	Capabilities     : 0x84204000
		Video Memory-to-Memory Multiplanar
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04204000
		Video Memory-to-Memory Multiplanar
		Streaming
		Extended Pix Format

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video0 open: OK
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
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

Total: 43, Succeeded: 43, Failed: 0, Warnings: 0

-- 
2.18.0
