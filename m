Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:56399 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755278AbcIEOrn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Sep 2016 10:47:43 -0400
Subject: Re: [PATCH 0/8] Qualcomm video decoder/encoder driver
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1471871619-25873-1-git-send-email-stanimir.varbanov@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <51878905-ca77-b972-f374-9bf2b4be9204@xs4all.nl>
Date: Mon, 5 Sep 2016 16:47:36 +0200
MIME-Version: 1.0
In-Reply-To: <1471871619-25873-1-git-send-email-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/22/2016 03:13 PM, Stanimir Varbanov wrote:
> This patchset introduces a basic support for Qualcomm video
> acceleration hardware used for video stream decoding/encoding.
> The video IP can found on various qcom SoCs like apq8084, msm8916
> and msm8996, hence it is widly distributed but the driver is 
> missing in the mainline.
> 
> The v4l2 driver is something like a wrapper over Host Firmware
> Interface. The HFI itself is a set of command and message packets
> send/received through shared memory, and its purpose is to
> comunicate with the firmware which is run on remote processor.
> The Venus is the name of the video hardware IP that doing the
> video acceleration.
> 
> From the software point of view the HFI interface is implemented
> in the files with prefix hfi_xxx. It acts as a translation layer
> between HFI and v4l2 layer. There is one special file in the 
> driver called hfi_venus which doing most of the driver
> orchestration work. Something more it setups Venus core, run it
> and handle commands and messages from low-level point of view with
> the help of provided functions by HFI interface.
> 
> I think that the driver is in good shape for mainline kernel, and
> I hope the review comments will help to improve it, so please
> do review and make comments.

I was hoping that I could finish reviewing this patch series today,
but that didn't work out.

I have more time next week, but I wonder if it isn't better if you make a
v2 first, taking my comments into account. Then I can review v2 next week.

Also test with the latest v4l2-compliance (i.e. as of today) since I improved
a few tests relating to g/s_selection and g/s_parm.

Regards,

	Hans

> 
> The driver depends on:
>  - venus remoteproc driver posted at [1].
>  - out-of-tree qcom IOMMU driver and IOMMU probe deferral support
>  at [2].
> 
> The driver has been tested on db410c (with apq8016 SoC) with simple 
> v4l2 test applications and with gstreamer v4l2 videodec plugin,
> and v4l2 h264 out-of-tree gstreamer videoenc plugin.
> 
> The output of v4l2-compliance test looks like:
> 
> root@dragonboard-410c:/home/linaro# ./v4l2-compliance -d /dev/video0 
> v4l2-compliance SHA   : ee1ab491019f80052834d14c76bdd1c1b46f2158
> 
> Driver Info:
>         Driver name   : vidc
>         Card type     : video decoder
>         Bus info      : platform:vidc
>         Driver version: 4.8.0
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
> Control ioctls:
>         test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>         test VIDIOC_QUERYCTRL: OK
>         test VIDIOC_G/S_CTRL: OK
>         test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>         test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>         test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>         Standard Controls: 7 Private Controls: 0
> 
> Format ioctls:
>         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>         test VIDIOC_G/S_PARM: OK
>         test VIDIOC_G_FBUF: OK (Not Supported)
>         test VIDIOC_G_FMT: OK
>         test VIDIOC_TRY_FMT: OK
>         test VIDIOC_S_FMT: OK
>         test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>         test Cropping: OK (Not Supported)
>         test Composing: OK (Not Supported)
>         test Scaling: OK
> 
> Codec ioctls:
>         test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>         test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>         test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> Buffer ioctls:
>         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>         test VIDIOC_EXPBUF: OK
> 
> Test input 0:
> 
> Total: 43, Succeeded: 43, Failed: 0, Warnings: 0
> 
> root@dragonboard-410c:/home/linaro# ./v4l2-compliance -d /dev/video1
> v4l2-compliance SHA   : ee1ab491019f80052834d14c76bdd1c1b46f2158
> 
> Driver Info:
>         Driver name   : vidc
>         Card type     : video encoder
>         Bus info      : platform:vidc
>         Driver version: 4.8.0
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
> Control ioctls:
>         test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>         test VIDIOC_QUERYCTRL: OK
>         test VIDIOC_G/S_CTRL: OK
>         test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>         test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>         test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>         Standard Controls: 32 Private Controls: 0
> 
> Format ioctls:
>         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>         test VIDIOC_G/S_PARM: OK
>         test VIDIOC_G_FBUF: OK (Not Supported)
>         test VIDIOC_G_FMT: OK
>         test VIDIOC_TRY_FMT: OK
>         test VIDIOC_S_FMT: OK
>         test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>         test Cropping: OK
>         test Composing: OK (Not Supported)
>         test Scaling: OK
> 
> Codec ioctls:
>         test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>         test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>         test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> Buffer ioctls:
>         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>         test VIDIOC_EXPBUF: OK
> 
> Test input 0:
> 
> Total: 43, Succeeded: 43, Failed: 0, Warnings: 0
> 
> regards,
> Stan
> 
> [1] https://lkml.org/lkml/2016/8/19/570
> [2] https://www.spinics.net/lists/arm-kernel/msg522505.html
> 
> Stanimir Varbanov (8):
>   doc: DT: vidc: binding document for Qualcomm video driver
>   media: vidc: adding core part and helper functions
>   media: vidc: decoder: add video decoder files
>   media: vidc: encoder: add video encoder files
>   media: vidc: add Host Firmware Interface (HFI)
>   media: vidc: add Venus HFI files
>   media: vidc: add Makefiles and Kconfig files
>   media: vidc: enable building of the video codec driver
> 
>  .../devicetree/bindings/media/qcom,vidc.txt        |   61 +
>  drivers/media/platform/Kconfig                     |    1 +
>  drivers/media/platform/Makefile                    |    1 +
>  drivers/media/platform/qcom/Kconfig                |    8 +
>  drivers/media/platform/qcom/Makefile               |    6 +
>  drivers/media/platform/qcom/vidc/Makefile          |   19 +
>  drivers/media/platform/qcom/vidc/core.c            |  548 +++++++
>  drivers/media/platform/qcom/vidc/core.h            |  196 +++
>  drivers/media/platform/qcom/vidc/helpers.c         |  394 +++++
>  drivers/media/platform/qcom/vidc/helpers.h         |   43 +
>  drivers/media/platform/qcom/vidc/hfi.c             |  622 ++++++++
>  drivers/media/platform/qcom/vidc/hfi.h             |  272 ++++
>  drivers/media/platform/qcom/vidc/hfi_cmds.c        | 1261 ++++++++++++++++
>  drivers/media/platform/qcom/vidc/hfi_cmds.h        |  338 +++++
>  drivers/media/platform/qcom/vidc/hfi_helper.h      | 1143 +++++++++++++++
>  drivers/media/platform/qcom/vidc/hfi_msgs.c        | 1072 ++++++++++++++
>  drivers/media/platform/qcom/vidc/hfi_msgs.h        |  298 ++++
>  drivers/media/platform/qcom/vidc/hfi_venus.c       | 1539 ++++++++++++++++++++
>  drivers/media/platform/qcom/vidc/hfi_venus.h       |   25 +
>  drivers/media/platform/qcom/vidc/hfi_venus_io.h    |   98 ++
>  drivers/media/platform/qcom/vidc/int_bufs.c        |  325 +++++
>  drivers/media/platform/qcom/vidc/int_bufs.h        |   23 +
>  drivers/media/platform/qcom/vidc/load.c            |  104 ++
>  drivers/media/platform/qcom/vidc/load.h            |   22 +
>  drivers/media/platform/qcom/vidc/mem.c             |   64 +
>  drivers/media/platform/qcom/vidc/mem.h             |   32 +
>  drivers/media/platform/qcom/vidc/resources.c       |   46 +
>  drivers/media/platform/qcom/vidc/resources.h       |   46 +
>  drivers/media/platform/qcom/vidc/vdec.c            | 1100 ++++++++++++++
>  drivers/media/platform/qcom/vidc/vdec.h            |   27 +
>  drivers/media/platform/qcom/vidc/vdec_ctrls.c      |  200 +++
>  drivers/media/platform/qcom/vidc/vdec_ctrls.h      |   21 +
>  drivers/media/platform/qcom/vidc/venc.c            | 1261 ++++++++++++++++
>  drivers/media/platform/qcom/vidc/venc.h            |   27 +
>  drivers/media/platform/qcom/vidc/venc_ctrls.c      |  396 +++++
>  drivers/media/platform/qcom/vidc/venc_ctrls.h      |   23 +
>  36 files changed, 11662 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/qcom,vidc.txt
>  create mode 100644 drivers/media/platform/qcom/Kconfig
>  create mode 100644 drivers/media/platform/qcom/Makefile
>  create mode 100644 drivers/media/platform/qcom/vidc/Makefile
>  create mode 100644 drivers/media/platform/qcom/vidc/core.c
>  create mode 100644 drivers/media/platform/qcom/vidc/core.h
>  create mode 100644 drivers/media/platform/qcom/vidc/helpers.c
>  create mode 100644 drivers/media/platform/qcom/vidc/helpers.h
>  create mode 100644 drivers/media/platform/qcom/vidc/hfi.c
>  create mode 100644 drivers/media/platform/qcom/vidc/hfi.h
>  create mode 100644 drivers/media/platform/qcom/vidc/hfi_cmds.c
>  create mode 100644 drivers/media/platform/qcom/vidc/hfi_cmds.h
>  create mode 100644 drivers/media/platform/qcom/vidc/hfi_helper.h
>  create mode 100644 drivers/media/platform/qcom/vidc/hfi_msgs.c
>  create mode 100644 drivers/media/platform/qcom/vidc/hfi_msgs.h
>  create mode 100644 drivers/media/platform/qcom/vidc/hfi_venus.c
>  create mode 100644 drivers/media/platform/qcom/vidc/hfi_venus.h
>  create mode 100644 drivers/media/platform/qcom/vidc/hfi_venus_io.h
>  create mode 100644 drivers/media/platform/qcom/vidc/int_bufs.c
>  create mode 100644 drivers/media/platform/qcom/vidc/int_bufs.h
>  create mode 100644 drivers/media/platform/qcom/vidc/load.c
>  create mode 100644 drivers/media/platform/qcom/vidc/load.h
>  create mode 100644 drivers/media/platform/qcom/vidc/mem.c
>  create mode 100644 drivers/media/platform/qcom/vidc/mem.h
>  create mode 100644 drivers/media/platform/qcom/vidc/resources.c
>  create mode 100644 drivers/media/platform/qcom/vidc/resources.h
>  create mode 100644 drivers/media/platform/qcom/vidc/vdec.c
>  create mode 100644 drivers/media/platform/qcom/vidc/vdec.h
>  create mode 100644 drivers/media/platform/qcom/vidc/vdec_ctrls.c
>  create mode 100644 drivers/media/platform/qcom/vidc/vdec_ctrls.h
>  create mode 100644 drivers/media/platform/qcom/vidc/venc.c
>  create mode 100644 drivers/media/platform/qcom/vidc/venc.h
>  create mode 100644 drivers/media/platform/qcom/vidc/venc_ctrls.c
>  create mode 100644 drivers/media/platform/qcom/vidc/venc_ctrls.h
> 
