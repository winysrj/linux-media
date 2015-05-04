Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34551 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbbEDKCj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 06:02:39 -0400
Received: by lbcga7 with SMTP id ga7so101265617lbc.1
        for <linux-media@vger.kernel.org>; Mon, 04 May 2015 03:02:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1430731461-8496-1-git-send-email-fabien.dessenne@st.com>
References: <1430731461-8496-1-git-send-email-fabien.dessenne@st.com>
Date: Mon, 4 May 2015 12:02:37 +0200
Message-ID: <CA+M3ks4GZwHJZ7jj-rEiUmS0xP9y7Jprtwfh3Um0-6QX3qA7PQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Add media bdisp driver for stihxxx platforms
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: Fabien Dessenne <fabien.dessenne@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	hugues.fruchet@st.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please, find below the v4l2-compliance report for the sti bdisp driver.

root@st:~# v4l2-compliance
Driver Info:
            Driver name   : 9f10000.bdisp
            Card type     : 9f10000.bdisp
            Bus info      : platform:bdisp0
            Driver version: 4.0.0
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
                        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
                        test VIDIOC_QUERYCTRL: OK
                        test VIDIOC_G/S_CTRL: OK
                        test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
                        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                        Standard Controls: 3 Private Controls: 0

            Format ioctls:
                        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                        test VIDIOC_G/S_PARM: OK (Not Supported)
                        test VIDIOC_G_FBUF: OK (Not Supported)
                        test VIDIOC_G_FMT: OK
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(707):
TRY_FMT cannot handle an invalid pixelformat.
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(708):
This may or may not be a problem. For more information see:
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(709):
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(707):
TRY_FMT cannot handle an invalid pixelformat.
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(708):
This may or may not be a problem. For more information see:
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(709):
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
                        test VIDIOC_TRY_FMT: OK
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(923):
S_FMT cannot handle an invalid pixelformat.
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(924):
This may or may not be a problem. For more information see:
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(925):
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(923):
S_FMT cannot handle an invalid pixelformat.
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(924):
This may or may not be a problem. For more information see:
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(925):
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
                        test VIDIOC_S_FMT: OK
                        test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                        test Cropping: OK
                        test Composing: OK
                        test Scaling: OK (Not Supported)

            Codec ioctls:
                        test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                        test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                        test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

            Buffer ioctls:
                        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                        test VIDIOC_EXPBUF: OK

Test input 0:


Total: 42, Succeeded: 42, Failed: 0, Warnings: 12

root@st:~# v4l2-compliance -s
Driver Info:
            Driver name   : 9f10000.bdisp
            Card type     : 9f10000.bdisp
            Bus info      : platform:bdisp0
            Driver version: 4.0.0
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
                        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
                        test VIDIOC_QUERYCTRL: OK
                        test VIDIOC_G/S_CTRL: OK
                        test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
                        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                        Standard Controls: 3 Private Controls: 0

            Format ioctls:
                        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                        test VIDIOC_G/S_PARM: OK (Not Supported)
                        test VIDIOC_G_FBUF: OK (Not Supported)
                        test VIDIOC_G_FMT: OK
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(707):
TRY_FMT cannot handle an invalid pixelformat.
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(708):
This may or may not be a problem. For more information see:
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(709):
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(707):
TRY_FMT cannot handle an invalid pixelformat.
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(708):
This may or may not be a problem. For more information see:
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(709):
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
                        test VIDIOC_TRY_FMT: OK
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(923):
S_FMT cannot handle an invalid pixelformat.
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(924):
This may or may not be a problem. For more information see:
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(925):
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(923):
S_FMT cannot handle an invalid pixelformat.
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(924):
This may or may not be a problem. For more information see:
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(925):
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
                        test VIDIOC_S_FMT: OK
                        test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                        test Cropping: OK
                        test Composing: OK
                        test Scaling: OK (Not Supported)

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
                        fail:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-buffers.cpp(346):
buf.querybuf(node, i)
                        fail:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-buffers.cpp(921):
testQueryBuf(node, cur_fmt.type, q.g_buffers())
            test MMAP: FAIL
            test USERPTR: OK (Not Supported)
            test DMABUF: Cannot test, specify --expbuf-device

Total: 45, Succeeded: 44, Failed: 1, Warnings: 12

root@st:~# v4l2-compliance -f
Driver Info:
            Driver name   : 9f10000.bdisp
            Card type     : 9f10000.bdisp
            Bus info      : platform:bdisp0
            Driver version: 4.0.0
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
                        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
                        test VIDIOC_QUERYCTRL: OK
                        test VIDIOC_G/S_CTRL: OK
                        test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
                        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                        Standard Controls: 3 Private Controls: 0

            Format ioctls:
                        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                        test VIDIOC_G/S_PARM: OK (Not Supported)
                        test VIDIOC_G_FBUF: OK (Not Supported)
                        test VIDIOC_G_FMT: OK
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(707):
TRY_FMT cannot handle an invalid pixelformat.
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(708):
This may or may not be a problem. For more information see:
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(709):
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(707):
TRY_FMT cannot handle an invalid pixelformat.
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(708):
This may or may not be a problem. For more information see:
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(709):
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
                        test VIDIOC_TRY_FMT: OK
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(923):
S_FMT cannot handle an invalid pixelformat.
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(924):
This may or may not be a problem. For more information see:
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(925):
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(923):
S_FMT cannot handle an invalid pixelformat.
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(924):
This may or may not be a problem. For more information see:
                        warn:
/local/frq07368/view/opensdk-0.31/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(925):
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
                        test VIDIOC_S_FMT: OK
                        test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                        test Cropping: OK
                        test Composing: OK
                        test Scaling: OK (Not Supported)

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

2015-05-04 11:24 GMT+02:00 Fabien Dessenne <fabien.dessenne@st.com>:
> This series of patches adds the support of v4l2 2D blitter driver for
> STMicroelectronics SOC.
>
> version 2:
>         - Renamed to STI_BDISP, inserted the sti directory.
>         - Reworked the cropping vs selection API.
>         - Used additional v4l2_m2m helpers and fops.
>         - Dropped pixel format description.
>         - Fixed memory release issue.
>
> version 1:
>         - Initial submission.
>
> The following features are supported and tested:
> - Color format conversion (RGB32, RGB24, RGB16, NV12, YUV420P)
> - Copy
> - Scale
> - Flip
> - Deinterlace
> - Wide (4K) picture support
> - Crop
>
> This driver uses the v4l2 mem2mem framework and its implementation was largely
> inspired by the Exynos G-Scaler (exynos-gsc) driver.
>
> The driver is mainly implemented across two files:
> - bdisp-v4l2.c
> - bdisp-hw.c
> bdisp-v4l2.c uses v4l2_m2m to manage the V4L2 interface with the userland.
> It calls the HW services that are implemented in bdisp-hw.c.
>
> The additional bdisp-debug.c file manages some debugfs entries.
>
> Fabien Dessenne (3):
>   [media] bdisp: add DT bindings documentation
>   [media] bdisp: 2D blitter driver using v4l2 mem2mem framework
>   [media] bdisp: add debug file system
>
>  .../devicetree/bindings/media/st,stih4xx.txt       |   32 +
>  drivers/media/platform/Kconfig                     |   10 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/sti/bdisp/Kconfig           |    9 +
>  drivers/media/platform/sti/bdisp/Makefile          |    3 +
>  drivers/media/platform/sti/bdisp/bdisp-debug.c     |  668 ++++++++++
>  drivers/media/platform/sti/bdisp/bdisp-filter.h    |  346 +++++
>  drivers/media/platform/sti/bdisp/bdisp-hw.c        |  823 ++++++++++++
>  drivers/media/platform/sti/bdisp/bdisp-reg.h       |  235 ++++
>  drivers/media/platform/sti/bdisp/bdisp-v4l2.c      | 1408 ++++++++++++++++++++
>  drivers/media/platform/sti/bdisp/bdisp.h           |  216 +++
>  11 files changed, 3752 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/st,stih4xx.txt
>  create mode 100644 drivers/media/platform/sti/bdisp/Kconfig
>  create mode 100644 drivers/media/platform/sti/bdisp/Makefile
>  create mode 100644 drivers/media/platform/sti/bdisp/bdisp-debug.c
>  create mode 100644 drivers/media/platform/sti/bdisp/bdisp-filter.h
>  create mode 100644 drivers/media/platform/sti/bdisp/bdisp-hw.c
>  create mode 100644 drivers/media/platform/sti/bdisp/bdisp-reg.h
>  create mode 100644 drivers/media/platform/sti/bdisp/bdisp-v4l2.c
>  create mode 100644 drivers/media/platform/sti/bdisp/bdisp.h
>
> --
> 1.9.1
>



-- 
Benjamin Gaignard

Graphic Working Group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
