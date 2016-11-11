Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:56724 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755999AbcKKLtk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 06:49:40 -0500
Subject: Re: [PATCH v3 0/9] Qualcomm video decoder/encoder driver
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f5120730-0e1d-f93c-eed9-7b71ff79f5db@xs4all.nl>
Date: Fri, 11 Nov 2016 12:49:34 +0100
MIME-Version: 1.0
In-Reply-To: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

Overall it looks good. As you saw, I do have some comments but nothing major.

One question: you use qcom as the directory name. How about using qualcomm?

It's really not that much longer and a bit more obvious.

Up to you, though.

Regards,

	Hans

On 11/07/2016 06:33 PM, Stanimir Varbanov wrote:
> Hi,
> 
> Here is v3 of the Venus v4l2 video encoder/decoder driver.
> 
> The changes since v2 are:
> 	- return queued buffers on stream_on error.
> 	- changed name of the driver vidc -> venus and reflect that in
> querycap.
> 	- fix video_device::release to point to video_device_release.
> 	- tried to implement correctly g_selection for decoder and encoder.
> 	- added Venus HFI 3xx basic support, to able to reuse driver on
> msm8996.
> 	- extend DT binding with reg-names and interrupt-names.
> 	- parse DT IRQ and MEM resources by name.
> 	- merge hfi_core,hfi_inst in venus_core and venus_inst structures.
> 	- killed hfi_pkt_ops struct and use functions.
> 	- various cleanups.
> 
> The output of v4l2-compliance looks like:
> 
> root@dragonboard-410c:/home/linaro# ./v4l2-compliance -d /dev/video0
> v4l2-compliance SHA   : 405f0c21e0b52836d22c999aa4ee1f51d87998b2
> 
> Driver Info:
>         Driver name   : qcom-venus
>         Card type     : Qualcomm Venus video decoder
>         Bus info      : platform:qcom-venus
>         Driver version: 4.4.23
>         Capabilities  : 0x84204000
>                 Video Memory-to-Memory Multiplanar
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x04204000
>                 Video Memory-to-Memory Multiplanar
>                 Streaming
>                 Extended Pix Format
> 
> Compliance test for device /dev/video0 (not using libv4l2):
> 
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>         test second video open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
>         test for unlimited opens: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>         test VIDIOC_LOG_STATUS: OK (Not Supported)
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 0 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>                 test VIDIOC_QUERYCTRL: OK
>                 test VIDIOC_G/S_CTRL: OK
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 7 Private Controls: 0
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK (Not Supported)
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK
>                 test Composing: OK
>                 test Scaling: OK
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
>         Buffer ioctls:
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>                 test VIDIOC_EXPBUF: OK
> 
> Test input 0:
> 
> 
> Total: 43, Succeeded: 43, Failed: 0, Warnings: 0
> 
> root@dragonboard-410c:/home/linaro# ./v4l2-compliance -d /dev/video1
> v4l2-compliance SHA   : 405f0c21e0b52836d22c999aa4ee1f51d87998b2
> 
> Driver Info:
>         Driver name   : vidc
>         Card type     : video encoder
>         Bus info      : platform:vidc
>         Driver version: 4.4.23
>         Capabilities  : 0x84204000
>                 Video Memory-to-Memory Multiplanar
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x04204000
>                 Video Memory-to-Memory Multiplanar
>                 Streaming
>                 Extended Pix Format
> 
> Compliance test for device /dev/video1 (not using libv4l2):
> 
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>         test second video open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
>         test for unlimited opens: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>         test VIDIOC_LOG_STATUS: OK (Not Supported)
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 0 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>                 test VIDIOC_QUERYCTRL: OK
>                 test VIDIOC_G/S_CTRL: OK
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 32 Private Controls: 0
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
>         Buffer ioctls:
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>                 test VIDIOC_EXPBUF: OK
> 
> Test input 0:
> 
> Total: 43, Succeeded: 43, Failed: 0, Warnings: 0
> 
> regards,
> Stan
> 
> Stanimir Varbanov (9):
>   doc: DT: vidc: binding document for Qualcomm video driver
>   MAINTAINERS: Add Qualcomm Venus video accelerator driver
>   media: venus: adding core part and helper functions
>   media: venus: vdec: add video decoder files
>   media: venus: venc: add video encoder files
>   media: venus: hfi: add Host Firmware Interface (HFI)
>   media: venus: hfi: add Venus HFI files
>   media: venus: add Makefiles and Kconfig files
>   media: venus: enable building of Venus video codec driver
> 
>  .../devicetree/bindings/media/qcom,venus.txt       |   98 ++
>  MAINTAINERS                                        |    8 +
>  drivers/media/platform/Kconfig                     |    1 +
>  drivers/media/platform/Makefile                    |    1 +
>  drivers/media/platform/qcom/Kconfig                |    7 +
>  drivers/media/platform/qcom/Makefile               |    1 +
>  drivers/media/platform/qcom/venus/Makefile         |   15 +
>  drivers/media/platform/qcom/venus/core.c           |  557 +++++++
>  drivers/media/platform/qcom/venus/core.h           |  261 ++++
>  drivers/media/platform/qcom/venus/helpers.c        |  612 ++++++++
>  drivers/media/platform/qcom/venus/helpers.h        |   43 +
>  drivers/media/platform/qcom/venus/hfi.c            |  604 ++++++++
>  drivers/media/platform/qcom/venus/hfi.h            |  180 +++
>  drivers/media/platform/qcom/venus/hfi_cmds.c       | 1255 ++++++++++++++++
>  drivers/media/platform/qcom/venus/hfi_cmds.h       |  304 ++++
>  drivers/media/platform/qcom/venus/hfi_helper.h     | 1045 ++++++++++++++
>  drivers/media/platform/qcom/venus/hfi_msgs.c       | 1054 ++++++++++++++
>  drivers/media/platform/qcom/venus/hfi_msgs.h       |  283 ++++
>  drivers/media/platform/qcom/venus/hfi_venus.c      | 1523 ++++++++++++++++++++
>  drivers/media/platform/qcom/venus/hfi_venus.h      |   23 +
>  drivers/media/platform/qcom/venus/hfi_venus_io.h   |   98 ++
>  drivers/media/platform/qcom/venus/vdec.c           | 1108 ++++++++++++++
>  drivers/media/platform/qcom/venus/vdec.h           |   32 +
>  drivers/media/platform/qcom/venus/vdec_ctrls.c     |  197 +++
>  drivers/media/platform/qcom/venus/venc.c           | 1212 ++++++++++++++++
>  drivers/media/platform/qcom/venus/venc.h           |   32 +
>  drivers/media/platform/qcom/venus/venc_ctrls.c     |  396 +++++
>  27 files changed, 10950 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/qcom,venus.txt
>  create mode 100644 drivers/media/platform/qcom/Kconfig
>  create mode 100644 drivers/media/platform/qcom/Makefile
>  create mode 100644 drivers/media/platform/qcom/venus/Makefile
>  create mode 100644 drivers/media/platform/qcom/venus/core.c
>  create mode 100644 drivers/media/platform/qcom/venus/core.h
>  create mode 100644 drivers/media/platform/qcom/venus/helpers.c
>  create mode 100644 drivers/media/platform/qcom/venus/helpers.h
>  create mode 100644 drivers/media/platform/qcom/venus/hfi.c
>  create mode 100644 drivers/media/platform/qcom/venus/hfi.h
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_cmds.c
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_cmds.h
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_helper.h
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_msgs.c
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_msgs.h
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_venus.c
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_venus.h
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_venus_io.h
>  create mode 100644 drivers/media/platform/qcom/venus/vdec.c
>  create mode 100644 drivers/media/platform/qcom/venus/vdec.h
>  create mode 100644 drivers/media/platform/qcom/venus/vdec_ctrls.c
>  create mode 100644 drivers/media/platform/qcom/venus/venc.c
>  create mode 100644 drivers/media/platform/qcom/venus/venc.h
>  create mode 100644 drivers/media/platform/qcom/venus/venc_ctrls.c
> 
