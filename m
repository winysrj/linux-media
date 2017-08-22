Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:48891 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932849AbdHVOl3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 10:41:29 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v2 0/4] STM32 DCMI camera interface crop support
Date: Tue, 22 Aug 2017 16:41:07 +0200
Message-ID: <1503412871-29829-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset implements crop feature of Digital Camera Memory Interface
(DCMI) of STMicroelectronics STM32 SoC series, allowing user to crop
at pixel level inside sensor captured frame.

This patchset follows discussions initiated from a first submission of DCMI
crop support, see [1].

First part of patches brings few fixes and cleanup in DCMI driver
to prepare support of crop through g_/s_selection interface in latest
commit.

This has been tested on STM32F746G-DISCO + STM32F4DIS-CAM extension
running OV9655 sensor, using a modified version of yavta [2] utility
to support crop through S_SELECTION(V4L2_SEL_TGT_CROP) ioctl:
 yavta -s 480x272 -n 1 --capture=2 /dev/video0 --crop=0,0,480,272

v4l2-compliance cropping test is failed due to OV9655 sensor supporting
several discrete frame sizes and crop support added by DCMI interface [3]:
  fail: v4l2-test-formats.cpp(1266): node->frmsizes_count[pixfmt] > 1
    test Cropping: FAIL
If sensor is restricted to only a single supported resolution, test is OK.
Compliance test should be adapted to support this case.


[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg114652.html
[2] http://git.ideasonboard.org/?p=yavta.git;a=summary
[3] see v4l2-compliance test report below

===========
= history =
===========
version 2:
  - Fix remarks from Hans Verkuil on "cleanup" commit:
    http://www.mail-archive.com/linux-media@vger.kernel.org/msg116612.html
    - change "nb_of" to "num_of"
  - Drop "default format at open" commit as per Hans' remark:
    http://www.mail-archive.com/linux-media@vger.kernel.org/msg116614.html
  - Fix Kbuild warning on uninitialized ret variable:
    http://www.mail-archive.com/linux-media@vger.kernel.org/msg116398.html
  - Fix remarks from Hans Verkuil on crop commit:
    http://www.mail-archive.com/linux-media@vger.kernel.org/msg116615.html
    - refactor g_selection() code
    - revisit dcmi->do_crop true/false critera

version 1:
  - Initial version

===================
= v4l2-compliance =
===================
Below is the v4l2-compliance report for this current version of the DCMI camera interface.
v4l2-compliance has been built from v4l-utils-1.12.5.

~ # v4l2-compliance -s -f -d /dev/video0
v4l2-compliance SHA   : f5f45e17ee98a0ebad7836ade2b34ceec909d751

Driver Info:
        Driver name   : stm32-dcmi
        Card type     : STM32 Camera Memory Interface
        Bus info      : platform:dcmi
        Driver version: 4.12.0
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

Compliance test for device /dev/video0 (not using libv4l2):

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
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 2 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK (Not Supported)
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                test VIDIOC_TRY_FMT: OK
                test VIDIOC_S_FMT: OK
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                fail: v4l2-test-formats.cpp(1266): node->frmsizes_count[pixfmt] > 1
                test Cropping: FAIL
                test Composing: OK (Not Supported)
                fail: v4l2-test-formats.cpp(1633): node->can_scale && node->frmsizes_count[v4l_format_g_pixelformat(&cur)]
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
        test MMAP: OK
        test USERPTR: OK (Not Supported)
        test DMABUF: Cannot test, specify --expbuf-device

Stream using all formats:
        test MMAP for Format RGBP, Frame Size 160x120:
                Crop 160x120@0x0, Stride 320, Field None: OK
                Crop 0x0@0x0, Stride 320, Field None, SelTest: OK
                Crop 160x120@0x0, Stride 320, Field None, SelTest: OK
        test MMAP for Format RGBP, Frame Size 160x120:
                Crop 160x120@0x0, Stride 320, Field None: OK
        test MMAP for Format RGBP, Frame Size 160x120:
                Crop 160x120@0x0, Stride 320, Field None: OK

Total: 51, Succeeded: 50, Failed: 1, Warnings: 0
Hugues Fruchet (4):
  [media] stm32-dcmi: catch dma submission error
  [media] stm32-dcmi: revisit control register handling
  [media] stm32-dcmi: cleanup variable/fields namings
  [media] stm32-dcmi: g_/s_selection crop support

 drivers/media/platform/stm32/stm32-dcmi.c | 491 ++++++++++++++++++++++++++----
 1 file changed, 430 insertions(+), 61 deletions(-)

-- 
1.9.1
