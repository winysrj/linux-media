Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:8054 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750990AbbLRKpl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 05:45:41 -0500
From: Yannick Fertre <yannick.fertre@st.com>
To: <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	<hugues.fruchet@st.com>, <kernel@stlinux.com>
Subject: [PATCH 0/3] support of v4l2 encoder for STMicroelectronics SOC.
Date: Fri, 18 Dec 2015 11:45:30 +0100
Message-ID: <1450435533-15974-1-git-send-email-yannick.fertre@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

version 1:
	- Initial submission.

Only one feature supported and tested:
- encode (RGB32, RGB24, RGB16, NV12, NV21, UYVY, VYUY) to h264 video format

The driver is mainly implemented across three files:
- hva-v4l2.c
- hva-h264.c
- hva-hw.c
hva-v4l2.c manages the V4L2 interface with the userland.
It calls the HW services that are implemented in hva-hw.c.
hva-h264.c manages specific part of h264 codec.

Below is the v4l2-compliance report for the sti hva driver.
Note: using patched v4l2-compliance:
"v4l2-compliance: test SELECTION only for the supported buf_type"

root@st-next:/# ./v4l2-compliance 
Driver Info:
        Driver name   : 8c85000.hva
        Card type     : 8c85000.hva
        Bus info      : platform:hva
        Driver version: 4.4.0
        Capabilities  : 0x84208000
                Video Memory-to-Memory
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x04208000
                Video Memory-to-Memory
                Streaming
                Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second video open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK

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
                test VIDIOC_G/S_CTRL: OK
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 0 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(707): TRY_FMT cannot handle an invalid pixelformat
.
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(708): This may or may not be a problem. For more i
nformation see:
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(709): http://www.mail-archive.com/linux-media@vger
.kernel.org/msg56550.html
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(707): TRY_FMT cannot handle an invalid pixelformat
.
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(708): This may or may not be a problem. For more i
nformation see:
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(709): http://www.mail-archive.com/linux-media@vger
.kernel.org/msg56550.html
                test VIDIOC_TRY_FMT: OK
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(923): S_FMT cannot handle an invalid pixelformat.
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(924): This may or may not be a problem. For more i
nformation see:
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(925): http://www.mail-archive.com/linux-media@vger
.kernel.org/msg56550.html
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(923): S_FMT cannot handle an invalid pixelformat.
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(924): This may or may not be a problem. For more i
nformation see:
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(925): http://www.mail-archive.com/linux-media@vger
.kernel.org/msg56550.html
                test VIDIOC_S_FMT: OK
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                test Cropping: OK
                test Composing: OK (Not Supported)
                fail: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(1435): doioctl(node, VIDIOC_S_FMT, &fmt)
                test Scaling: OK

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

        Buffer ioctls:
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                test VIDIOC_EXPBUF: OK

Test input 0:


Total: 42, Succeeded: 42, Failed: 0, Warnings: 12

root@st-next:/# ./v4l2-compliance -f
Driver Info:
        Driver name   : 8c85000.hva
        Card type     : 8c85000.hva
        Bus info      : platform:hva
        Driver version: 4.4.0
        Capabilities  : 0x84208000
                Video Memory-to-Memory
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x04208000
                Video Memory-to-Memory
                Streaming
                Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second video open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK

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
                test VIDIOC_G/S_CTRL: OK
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 0 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(707): TRY_FMT cannot handle an invalid pixelformat
.
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(708): This may or may not be a problem. For more i
nformation see:
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(709): http://www.mail-archive.com/linux-media@vger
.kernel.org/msg56550.html
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(707): TRY_FMT cannot handle an invalid pixelformat
.
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(708): This may or may not be a problem. For more i
nformation see:
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(709): http://www.mail-archive.com/linux-media@vger
.kernel.org/msg56550.html
                test VIDIOC_TRY_FMT: OK
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(923): S_FMT cannot handle an invalid pixelformat.
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(924): This may or may not be a problem. For more i
nformation see:
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(925): http://www.mail-archive.com/linux-media@vger
.kernel.org/msg56550.html
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(923): S_FMT cannot handle an invalid pixelformat.
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(924): This may or may not be a problem. For more i
nformation see:
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(925): http://www.mail-archive.com/linux-media@vger
.kernel.org/msg56550.html
                test VIDIOC_S_FMT: OK
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                test Cropping: OK
                test Composing: OK (Not Supported)
                fail: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(1435): doioctl(node, VIDIOC_S_FMT, &fmt)
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
        Not supported for M2M devices

Total: 42, Succeeded: 42, Failed: 0, Warnings: 12

root@st-next:/# ./v4l2-compliance -s
Driver Info:
        Driver name   : 8c85000.hva
        Card type     : 8c85000.hva
        Bus info      : platform:hva
        Driver version: 4.4.0
        Capabilities  : 0x84208000
                Video Memory-to-Memory
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x04208000
                Video Memory-to-Memory
                Streaming
                Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second video open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK

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
                test VIDIOC_G/S_CTRL: OK
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 0 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(707): TRY_FMT cannot handle an invalid pixelformat
.
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(708): This may or may not be a problem. For more i
nformation see:
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(709): http://www.mail-archive.com/linux-media@vger
.kernel.org/msg56550.html
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(707): TRY_FMT cannot handle an invalid pixelformat
.
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(708): This may or may not be a problem. For more i
nformation see:
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(709): http://www.mail-archive.com/linux-media@vger
.kernel.org/msg56550.html
                test VIDIOC_TRY_FMT: OK
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(923): S_FMT cannot handle an invalid pixelformat.
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(924): This may or may not be a problem. For more i
nformation see:
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(925): http://www.mail-archive.com/linux-media@vger
.kernel.org/msg56550.html
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(923): S_FMT cannot handle an invalid pixelformat.
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(924): This may or may not be a problem. For more i
nformation see:
                warn: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(925): http://www.mail-archive.com/linux-media@vger
.kernel.org/msg56550.html
                test VIDIOC_S_FMT: OK
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                test Cropping: OK
                test Composing: OK (Not Supported)
                fail: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(1435): doioctl(node, VIDIOC_S_FMT, &fmt)
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
                fail: /local/frq07647/views/opensdk-1.0.4/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-buffers.cpp(948): ret != EINVAL
        test MMAP: FAIL
        test USERPTR: OK (Not Supported)
        test DMABUF: Cannot test, specify --expbuf-device


Total: 45, Succeeded: 44, Failed: 1, Warnings: 12


Yannick Fertre (3):
  Documentation: devicetree: add STI HVA binding
  [media] hva: STiH41x multi-format video encoder V4L2 driver
  [media] hva: add h264 support

 .../devicetree/bindings/media/st,sti-hva.txt       |   26 +
 drivers/media/platform/Kconfig                     |   13 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/sti/hva/Makefile            |    2 +
 drivers/media/platform/sti/hva/hva-h264.c          | 1225 ++++++++++++++++
 drivers/media/platform/sti/hva/hva-hw.c            |  561 +++++++
 drivers/media/platform/sti/hva/hva-hw.h            |   76 +
 drivers/media/platform/sti/hva/hva-mem.c           |   63 +
 drivers/media/platform/sti/hva/hva-mem.h           |   20 +
 drivers/media/platform/sti/hva/hva-v4l2.c          | 1530 ++++++++++++++++++++
 drivers/media/platform/sti/hva/hva.h               |  499 +++++++
 11 files changed, 4016 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,sti-hva.txt
 create mode 100644 drivers/media/platform/sti/hva/Makefile
 create mode 100644 drivers/media/platform/sti/hva/hva-h264.c
 create mode 100644 drivers/media/platform/sti/hva/hva-hw.c
 create mode 100644 drivers/media/platform/sti/hva/hva-hw.h
 create mode 100644 drivers/media/platform/sti/hva/hva-mem.c
 create mode 100644 drivers/media/platform/sti/hva/hva-mem.h
 create mode 100644 drivers/media/platform/sti/hva/hva-v4l2.c
 create mode 100644 drivers/media/platform/sti/hva/hva.h

-- 
1.9.1

