Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:16650 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755438AbcHWJce (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 05:32:34 -0400
From: Jean Christophe TROTIN <jean-christophe.trotin@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kernel@stlinux.com" <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick FERTRE <yannick.fertre@st.com>,
        Hugues FRUCHET <hugues.fruchet@st.com>
Date: Tue, 23 Aug 2016 11:32:20 +0200
Subject: Re: [PATCH v4 0/3] support of v4l2 encoder for STMicroelectronics
 SOC
Message-ID: <fb32bd65-9c82-40f8-0067-ca023a38e38a@st.com>
References: <1469457850-17973-1-git-send-email-jean-christophe.trotin@st.com>
 <71e17b0e-cc89-e67f-f162-551ee636a6fa@xs4all.nl>
In-Reply-To: <71e17b0e-cc89-e67f-f162-551ee636a6fa@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I apologize for the delay in answering, but I was on vacation.
Thank you to have pointed out the compilation problem below.
I've corrected it (unsigned long is now used for dma_attrs).
I've still have few points to fix, and I will propose a new set of patches
beginning of next week.

Regards,
Jean-Christophe.

On 08/12/2016 04:46 PM, Hans Verkuil wrote:
> When I compile this driver using COMPILE_TEST I get:
>
> In file included from drivers/media/platform/sti/hva/hva-hw.h:11:0,
>                  from drivers/media/platform/sti/hva/hva-h264.c:9:
> drivers/media/platform/sti/hva/hva-mem.h:22:19: error: field ‘attrs’ has incomplete type
>   struct dma_attrs attrs;
>                    ^~~~~
> scripts/Makefile.build:289: recipe for target 'drivers/media/platform/sti/hva/hva-h264.o' failed
> make[4]: *** [drivers/media/platform/sti/hva/hva-h264.o] Error 1
> make[4]: *** Waiting for unfinished jobs....
> In file included from drivers/media/platform/sti/hva/hva-mem.c:9:0:
> drivers/media/platform/sti/hva/hva-mem.h:22:19: error: field ‘attrs’ has incomplete type
>   struct dma_attrs attrs;
>                    ^~~~~
> drivers/media/platform/sti/hva/hva-mem.c: In function ‘hva_mem_alloc’:
> drivers/media/platform/sti/hva/hva-mem.c:18:2: error: implicit declaration of function ‘DEFINE_DMA_ATTRS’
> [-Werror=implicit-function-declaration]
>   DEFINE_DMA_ATTRS(attrs);
>   ^~~~~~~~~~~~~~~~
> drivers/media/platform/sti/hva/hva-mem.c:18:19: error: ‘attrs’ undeclared (first use in this function)
>   DEFINE_DMA_ATTRS(attrs);
>                    ^~~~~
> drivers/media/platform/sti/hva/hva-mem.c:18:19: note: each undeclared identifier is reported only once for each function it appears in
> drivers/media/platform/sti/hva/hva-mem.c:24:2: error: implicit declaration of function ‘dma_set_attr’ [-Werror=implicit-function-declaration]
>   dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
>   ^~~~~~~~~~~~
> cc1: some warnings being treated as errors
> scripts/Makefile.build:289: recipe for target 'drivers/media/platform/sti/hva/hva-mem.o' failed
> make[4]: *** [drivers/media/platform/sti/hva/hva-mem.o] Error 1
> In file included from drivers/media/platform/sti/hva/hva-hw.h:11:0,
>                  from drivers/media/platform/sti/hva/hva-hw.c:14:
> drivers/media/platform/sti/hva/hva-mem.h:22:19: error: field ‘attrs’ has incomplete type
>   struct dma_attrs attrs;
>                    ^~~~~
> scripts/Makefile.build:289: recipe for target 'drivers/media/platform/sti/hva/hva-hw.o' failed
> make[4]: *** [drivers/media/platform/sti/hva/hva-hw.o] Error 1
> In file included from drivers/media/platform/sti/hva/hva-hw.h:11:0,
>                  from drivers/media/platform/sti/hva/hva-v4l2.c:16:
> drivers/media/platform/sti/hva/hva-mem.h:22:19: error: field ‘attrs’ has incomplete type
>   struct dma_attrs attrs;
>                    ^~~~~
> scripts/Makefile.build:289: recipe for target 'drivers/media/platform/sti/hva/hva-v4l2.o' failed
> make[4]: *** [drivers/media/platform/sti/hva/hva-v4l2.o] Error 1
> scripts/Makefile.build:440: recipe for target 'drivers/media/platform/sti/hva' failed
> make[3]: *** [drivers/media/platform/sti/hva] Error 2
> make[3]: *** Waiting for unfinished jobs....
>   LD [M]  drivers/media/platform/vsp1/vsp1.o
>   LD [M]  drivers/media/platform/vivid/vivid.o
> scripts/Makefile.build:440: recipe for target 'drivers/media/platform' failed
> make[2]: *** [drivers/media/platform] Error 2
> scripts/Makefile.build:440: recipe for target 'drivers/media' failed
> make[1]: *** [drivers/media] Error 2
> Makefile:975: recipe for target 'drivers' failed
> make: *** [drivers] Error 2
> make: *** Waiting for unfinished jobs....
>
> It seems that in 4.8-rc1 struct dma_attrs no longer exists.
>
> Can you take a look and prepare a new patch series?
>
> Thanks!
>
>         Hans
>
> On 07/25/2016 04:44 PM, Jean-Christophe Trotin wrote:
>> version 4:
>> - Module renamed "st-hva" as suggested by Hans
>> - resource_size() inline function used to calculate the esram size
>> - V4L2 compliance successfully passed with this version (see report below)
>>
>> version 3:
>> - Comments from Nicolas, Javier and Hans about version 2 taken into account:
>>       - Kconfig's comment reworked
>>         - querycap: "driver" contains the name of the encoder ("hva"), "card" identifies the hardware version ("hva<hw_ip_version>" with <hw_ip_version> equal to 400 here, which leads to "hva400"), and "bus_info" indicates the location of the device ("platform:8c85000.hva")
>>       - device_caps field of struct video_device set to V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M
>>       - colorspace management aligned on the vim2m and mtk-vcodec drivers' code
>>       - useless debug messages removed
>>       - in case of error in start_streaming, all pending buffers for queue are returned to vb2 in the QUEUED state
>>       - hardware restriction with regards to the number of codec instances managed in start_streaming instead of open (then, the v4l2-compliance test for unlimited opens passes)
>>       - typos corrected
>> - V4L2 compliance successfully passed with this version (see report below)
>>
>> version 2:
>> - List of pixel formats supported by the encoder reduced to NV12 and NV21
>> - x86_64 compilation warnings corrected
>> - V4L2 compliance successfully passed with this version (see report below)
>> - All remarks about version 1 of hva-v4l2.c taken into account:
>>         - V4L2 mem2mem framework used
>>       - V4L2 control framework used
>>       - allocator context initialized in the probe and cleaned up in the remove
>>       - start_streaming and stop_streaming ops added
>>       - colorspace, bytesperline and sizeimage fields initialized in TRY_FMT
>>       - better estimation of sizeimage for compressed formats
>>       - checks and debugging logs already covered by vb2 removed
>>       - some dev_err changed in dev_dbg
>>       - typos corrected
>>
>> version 1:
>> - Initial submission.
>>
>> Only one feature supported and tested:
>> - encode (NV12, NV21) to H.264 video format
>>
>> The driver is mainly implemented across three files:
>> - hva-v4l2.c
>> - hva-h264.c
>> - hva-hw.c
>> hva-v4l2.c manages the V4L2 interface with the userland.
>> It calls the HW services that are implemented in hva-hw.c.
>> hva-h264.c manages specific part of H.264 codec.
>>
>> Below is the v4l2-compliance report for the version 4 of the hva driver:
>>
>> root@sti-next:/home/video_test# v4l2-compliance -d /dev/video0
>>
>> Driver Info:
>>       Driver name   : st-hva
>>       Card type     : st-hva400
>>       Bus info      : platform:8c85000.hva
>>       Driver version: 4.7.0
>>       Capabilities  : 0x84208000
>>               Video Memory-to-Memory
>>               Streaming
>>               Extended Pix Format
>>               Device Capabilities
>>       Device Caps   : 0x04208000
>>               Video Memory-to-Memory
>>               Streaming
>>               Extended Pix Format
>>
>> Compliance test for device /dev/video0 (not using libv4l2):
>>
>> Required ioctls:
>>       test VIDIOC_QUERYCAP: OK
>>
>> Allow for multiple opens:
>>       test second video open: OK
>>       test VIDIOC_QUERYCAP: OK
>>       test VIDIOC_G/S_PRIORITY: OK
>>       test for unlimited opens: OK
>>
>> Debug ioctls:
>>       test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>>       test VIDIOC_LOG_STATUS: OK (Not Supported)
>>
>> Input ioctls:
>>       test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>>       test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>       test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>>       test VIDIOC_ENUMAUDIO: OK (Not Supported)
>>       test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>>       test VIDIOC_G/S_AUDIO: OK (Not Supported)
>>       Inputs: 0 Audio Inputs: 0 Tuners: 0
>>
>> Output ioctls:
>>       test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>>       test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>       test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>>       test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>>       test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>>       Outputs: 0 Audio Outputs: 0 Modulators: 0
>>
>> Input/Output configuration ioctls:
>>       test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>>       test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>>       test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>>       test VIDIOC_G/S_EDID: OK (Not Supported)
>>
>>       Control ioctls:
>>               test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>>               test VIDIOC_QUERYCTRL: OK
>>               test VIDIOC_G/S_CTRL: OK
>>               test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>>               test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>>               test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>>               Standard Controls: 16 Private Controls: 0
>>
>>       Format ioctls:
>>               test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(1187): S_PARM is supported for buftype 1, but not ENUM_FRAMEINTERVALS
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(1187): S_PARM is supported for buftype 2, but not ENUM_FRAMEINTERVALS
>>               test VIDIOC_G/S_PARM: OK
>>               test VIDIOC_G_FBUF: OK (Not Supported)
>>               test VIDIOC_G_FMT: OK
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(717): TRY_FMT cannot handle an invalid pixelformat.
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(718): This may or may not be a problem. For more information see:
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(719): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
>>               test VIDIOC_TRY_FMT: OK
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(977): S_FMT cannot handle an invalid pixelformat.
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(978): This may or may not be a problem. For more information see:
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(979): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
>>               test VIDIOC_S_FMT: OK
>>               test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>>               test Cropping: OK (Not Supported)
>>               test Composing: OK (Not Supported)
>>               test Scaling: OK
>>
>>       Codec ioctls:
>>               test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>>               test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>>               test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>>
>>       Buffer ioctls:
>>               test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>               test VIDIOC_EXPBUF: OK
>>
>> Test input 0:
>>
>>
>> Total: 43, Succeeded: 43, Failed: 0, Warnings: 8
>>
>> root@sti-next:/home/video_test# v4l2-compliance -f -d /dev/video0
>>
>> Driver Info:
>>       Driver name   : st-hva
>>       Card type     : st-hva400
>>       Bus info      : platform:8c85000.hva
>>       Driver version: 4.7.0
>>       Capabilities  : 0x84208000
>>               Video Memory-to-Memory
>>               Streaming
>>               Extended Pix Format
>>               Device Capabilities
>>       Device Caps   : 0x04208000
>>               Video Memory-to-Memory
>>               Streaming
>>               Extended Pix Format
>>
>> Compliance test for device /dev/video0 (not using libv4l2):
>>
>> Required ioctls:
>>       test VIDIOC_QUERYCAP: OK
>>
>> Allow for multiple opens:
>>       test second video open: OK
>>       test VIDIOC_QUERYCAP: OK
>>       test VIDIOC_G/S_PRIORITY: OK
>>       test for unlimited opens: OK
>>
>> Debug ioctls:
>>       test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>>       test VIDIOC_LOG_STATUS: OK (Not Supported)
>>
>> Input ioctls:
>>       test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>>       test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>       test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>>       test VIDIOC_ENUMAUDIO: OK (Not Supported)
>>       test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>>       test VIDIOC_G/S_AUDIO: OK (Not Supported)
>>       Inputs: 0 Audio Inputs: 0 Tuners: 0
>>
>> Output ioctls:
>>       test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>>       test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>       test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>>       test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>>       test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>>       Outputs: 0 Audio Outputs: 0 Modulators: 0
>>
>> Input/Output configuration ioctls:
>>       test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>>       test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>>       test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>>       test VIDIOC_G/S_EDID: OK (Not Supported)
>>
>>       Control ioctls:
>>               test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>>               test VIDIOC_QUERYCTRL: OK
>>               test VIDIOC_G/S_CTRL: OK
>>               test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>>               test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>>               test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>>               Standard Controls: 16 Private Controls: 0
>>
>>       Format ioctls:
>>               test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(1187): S_PARM is supported for buftype 1, but not ENUM_FRAMEINTERVALS
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(1187): S_PARM is supported for buftype 2, but not ENUM_FRAMEINTERVALS
>>               test VIDIOC_G/S_PARM: OK
>>               test VIDIOC_G_FBUF: OK (Not Supported)
>>               test VIDIOC_G_FMT: OK
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(717): TRY_FMT cannot handle an invalid pixelformat.
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(718): This may or may not be a problem. For more information see:
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(719): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
>>               test VIDIOC_TRY_FMT: OK
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(977): S_FMT cannot handle an invalid pixelformat.
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(978): This may or may not be a problem. For more information see:
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(979): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
>>               test VIDIOC_S_FMT: OK
>>               test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>>               test Cropping: OK (Not Supported)
>>               test Composing: OK (Not Supported)
>>               test Scaling: OK
>>
>>       Codec ioctls:
>>               test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>>               test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>>               test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>>
>>       Buffer ioctls:
>>               test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>               test VIDIOC_EXPBUF: OK
>>
>> Test input 0:
>>
>> Stream using all formats:
>>       Not supported for M2M devices
>>
>> Total: 43, Succeeded: 43, Failed: 0, Warnings: 8
>>
>> root@sti-next:/home/video_test# v4l2-compliance -a -d /dev/video0
>>
>> Driver Info:
>>       Driver name   : st-hva
>>       Card type     : st-hva400
>>       Bus info      : platform:8c85000.hva
>>       Driver version: 4.7.0
>>       Capabilities  : 0x84208000
>>               Video Memory-to-Memory
>>               Streaming
>>               Extended Pix Format
>>               Device Capabilities
>>       Device Caps   : 0x04208000
>>               Video Memory-to-Memory
>>               Streaming
>>               Extended Pix Format
>>
>> Compliance test for device /dev/video0 (not using libv4l2):
>>
>> Required ioctls:
>>       test VIDIOC_QUERYCAP: OK
>>
>> Allow for multiple opens:
>>       test second video open: OK
>>       test VIDIOC_QUERYCAP: OK
>>       test VIDIOC_G/S_PRIORITY: OK
>>       test for unlimited opens: OK
>>
>> Debug ioctls:
>>       test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>>       test VIDIOC_LOG_STATUS: OK (Not Supported)
>>
>> Input ioctls:
>>       test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>>       test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>       test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>>       test VIDIOC_ENUMAUDIO: OK (Not Supported)
>>       test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>>       test VIDIOC_G/S_AUDIO: OK (Not Supported)
>>       Inputs: 0 Audio Inputs: 0 Tuners: 0
>>
>> Output ioctls:
>>       test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>>       test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>       test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>>       test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>>       test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>>       Outputs: 0 Audio Outputs: 0 Modulators: 0
>>
>> Input/Output configuration ioctls:
>>       test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>>       test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>>       test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>>       test VIDIOC_G/S_EDID: OK (Not Supported)
>>
>>       Control ioctls:
>>               test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>>               test VIDIOC_QUERYCTRL: OK
>>               test VIDIOC_G/S_CTRL: OK
>>               test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>>               test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>>               test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>>               Standard Controls: 16 Private Controls: 0
>>
>>       Format ioctls:
>>               test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(1187): S_PARM is supported for buftype 1, but not ENUM_FRAMEINTERVALS
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(1187): S_PARM is supported for buftype 2, but not ENUM_FRAMEINTERVALS
>>               test VIDIOC_G/S_PARM: OK
>>               test VIDIOC_G_FBUF: OK (Not Supported)
>>               test VIDIOC_G_FMT: OK
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(717): TRY_FMT cannot handle an invalid pixelformat.
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(718): This may or may not be a problem. For more information see:
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(719): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
>>               test VIDIOC_TRY_FMT: OK
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(977): S_FMT cannot handle an invalid pixelformat.
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(978): This may or may not be a problem. For more information see:
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(979): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
>>               test VIDIOC_S_FMT: OK
>>               test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>>               test Cropping: OK (Not Supported)
>>               test Composing: OK (Not Supported)
>>               test Scaling: OK
>>
>>       Codec ioctls:
>>               test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>>               test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>>               test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>>
>>       Buffer ioctls:
>>               test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>               test VIDIOC_EXPBUF: OK
>>
>> Test input 0:
>>
>>
>> Total: 43, Succeeded: 43, Failed: 0, Warnings: 8
>>
>> root@sti-next:/home/video_test# v4l2-compliance -s -d /dev/video0
>>
>> Driver Info:
>>       Driver name   : st-hva
>>       Card type     : st-hva400
>>       Bus info      : platform:8c85000.hva
>>       Driver version: 4.7.0
>>       Capabilities  : 0x84208000
>>               Video Memory-to-Memory
>>               Streaming
>>               Extended Pix Format
>>               Device Capabilities
>>       Device Caps   : 0x04208000
>>               Video Memory-to-Memory
>>               Streaming
>>               Extended Pix Format
>>
>> Compliance test for device /dev/video0 (not using libv4l2):
>>
>> Required ioctls:
>>       test VIDIOC_QUERYCAP: OK
>>
>> Allow for multiple opens:
>>       test second video open: OK
>>       test VIDIOC_QUERYCAP: OK
>>       test VIDIOC_G/S_PRIORITY: OK
>>       test for unlimited opens: OK
>>
>> Debug ioctls:
>>       test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>>       test VIDIOC_LOG_STATUS: OK (Not Supported)
>>
>> Input ioctls:
>>       test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>>       test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>       test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>>       test VIDIOC_ENUMAUDIO: OK (Not Supported)
>>       test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>>       test VIDIOC_G/S_AUDIO: OK (Not Supported)
>>       Inputs: 0 Audio Inputs: 0 Tuners: 0
>>
>> Output ioctls:
>>       test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>>       test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>       test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>>       test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>>       test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>>       Outputs: 0 Audio Outputs: 0 Modulators: 0
>>
>> Input/Output configuration ioctls:
>>       test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>>       test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>>       test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>>       test VIDIOC_G/S_EDID: OK (Not Supported)
>>
>>       Control ioctls:
>>               test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>>               test VIDIOC_QUERYCTRL: OK
>>               test VIDIOC_G/S_CTRL: OK
>>               test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>>               test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>>               test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>>               Standard Controls: 16 Private Controls: 0
>>
>>       Format ioctls:
>>               test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(1187): S_PARM is supported for buftype 1, but not ENUM_FRAMEINTERVALS
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(1187): S_PARM is supported for buftype 2, but not ENUM_FRAMEINTERVALS
>>               test VIDIOC_G/S_PARM: OK
>>               test VIDIOC_G_FBUF: OK (Not Supported)
>>               test VIDIOC_G_FMT: OK
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(717): TRY_FMT cannot handle an invalid pixelformat.
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(718): This may or may not be a problem. For more information see:
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(719): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
>>               test VIDIOC_TRY_FMT: OK
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(977): S_FMT cannot handle an invalid pixelformat.
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(978): This may or may not be a problem. For more information see:
>>               warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(979): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
>>               test VIDIOC_S_FMT: OK
>>               test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>>               test Cropping: OK (Not Supported)
>>               test Composing: OK (Not Supported)
>>               test Scaling: OK
>>
>>       Codec ioctls:
>>               test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>>               test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>>               test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>>
>>       Buffer ioctls:
>>               test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>               test VIDIOC_EXPBUF: OK
>>
>> Test input 0:
>>
>> Streaming ioctls:
>>       test read/write: OK (Not Supported)
>>       test MMAP: OK
>>       test USERPTR: OK (Not Supported)
>>       test DMABUF: Cannot test, specify --expbuf-device
>>
>>
>> Total: 46, Succeeded: 46, Failed: 0, Warnings: 8
>>
>> Jean-Christophe Trotin (3):
>>   Documentation: DT: add bindings for ST HVA
>>   st-hva: multi-format video encoder V4L2 driver
>>   st-hva: add H.264 video encoding support
>>
>>  .../devicetree/bindings/media/st,st-hva.txt        |   24 +
>>  drivers/media/platform/Kconfig                     |   14 +
>>  drivers/media/platform/Makefile                    |    1 +
>>  drivers/media/platform/sti/hva/Makefile            |    2 +
>>  drivers/media/platform/sti/hva/hva-h264.c          | 1053 +++++++++++++++
>>  drivers/media/platform/sti/hva/hva-hw.c            |  538 ++++++++
>>  drivers/media/platform/sti/hva/hva-hw.h            |   42 +
>>  drivers/media/platform/sti/hva/hva-mem.c           |   60 +
>>  drivers/media/platform/sti/hva/hva-mem.h           |   36 +
>>  drivers/media/platform/sti/hva/hva-v4l2.c          | 1396 ++++++++++++++++++++
>>  drivers/media/platform/sti/hva/hva.h               |  315 +++++
>>  11 files changed, 3481 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/st,st-hva.txt
>>  create mode 100644 drivers/media/platform/sti/hva/Makefile
>>  create mode 100644 drivers/media/platform/sti/hva/hva-h264.c
>>  create mode 100644 drivers/media/platform/sti/hva/hva-hw.c
>>  create mode 100644 drivers/media/platform/sti/hva/hva-hw.h
>>  create mode 100644 drivers/media/platform/sti/hva/hva-mem.c
>>  create mode 100644 drivers/media/platform/sti/hva/hva-mem.h
>>  create mode 100644 drivers/media/platform/sti/hva/hva-v4l2.c
>>  create mode 100644 drivers/media/platform/sti/hva/hva.h
>>
