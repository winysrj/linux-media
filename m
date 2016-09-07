Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36645 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938957AbcIGLnH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 07:43:07 -0400
Received: by mail-wm0-f43.google.com with SMTP id b187so111155136wme.1
        for <linux-media@vger.kernel.org>; Wed, 07 Sep 2016 04:43:06 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2 0/8] Qualcomm video decoder/encoder driver
Date: Wed,  7 Sep 2016 14:37:01 +0300
Message-Id: <1473248229-5540-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v1:
  - s/ENOTSUPP/EINVAL in vidc_set_color_format()
  - use video_device_alloc
  - fill struct device pointer in vb2_queue_init instead of .setup_queue
  - fill device_caps in struct video_device instead of .vidioc_querycap
  - fill colorspace, ycbcr_enc, quantization and xfer_func only when type
    is V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE
  - delete rproc_boot|shutdown wrappers in core.c
  - delete unused list_head in struct vidc_core
  - delete mem.c|h and inline the function where they were used
  - delete int_bufs.c|h files and move the functions in helpers.c, also
    cleanup the code by removing buffer reuse mechanism
  - inline INIT_VIDC_LIST macro
  - rename queue to other_queue in .start_streaming for encoder and
    decoder
  - renamed vidc_buf_descs -> vidc_get_bufreq
  - optimize instance checks in vidc_open
  - moved resources structure in core.c and delete resources.c|h
  - delete streamon and streamoff flags

The previous v1 can be found at [1].

[1] https://lkml.org/lkml/2016/8/22/308

The output of v4l2-compliance for decoder and encoder are:

root@dragonboard-410c:/home/linaro# ./v4l2-compliance -d /dev/video0
v4l2-compliance SHA   : abc1453dfe89f244dccd3460d8e1a2e3091cbadb

Driver Info:
        Driver name   : vidc
        Card type     : video decoder
        Bus info      : platform:vidc
        Driver version: 4.8.0
        Capabilities  : 0x84204000
                Video Memory-to-Memory Multiplanar
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x04204000
                Video Memory-to-Memory Multiplanar
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
                Standard Controls: 7 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK
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
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

        Buffer ioctls:
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                test VIDIOC_EXPBUF: OK

Test input 0:


Total: 43, Succeeded: 43, Failed: 0, Warnings: 0


root@dragonboard-410c:/home/linaro# ./v4l2-compliance -d /dev/video1
v4l2-compliance SHA   : abc1453dfe89f244dccd3460d8e1a2e3091cbadb

Driver Info:
        Driver name   : vidc
        Card type     : video encoder
        Bus info      : platform:vidc
        Driver version: 4.8.0
        Capabilities  : 0x84204000
                Video Memory-to-Memory Multiplanar
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x04204000
                Video Memory-to-Memory Multiplanar
                Streaming
                Extended Pix Format

Compliance test for device /dev/video1 (not using libv4l2):

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
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 32 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                test VIDIOC_TRY_FMT: OK
                test VIDIOC_S_FMT: OK
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                test Cropping: OK
                test Composing: OK (Not Supported)
                test Scaling: OK

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

        Buffer ioctls:
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                test VIDIOC_EXPBUF: OK

Test input 0:


Total: 43, Succeeded: 43, Failed: 0, Warnings: 0


Stanimir Varbanov (8):
  doc: DT: vidc: binding document for Qualcomm video driver
  media: vidc: adding core part and helper functions
  media: vidc: decoder: add video decoder files
  media: vidc: encoder: add video encoder files
  media: vidc: add Host Firmware Interface (HFI)
  media: vidc: add Venus HFI files
  media: vidc: add Makefiles and Kconfig files
  media: vidc: enable building of the video codec driver

 .../devicetree/bindings/media/qcom,vidc.txt        |   61 +
 drivers/media/platform/Kconfig                     |    1 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/qcom/Kconfig                |    8 +
 drivers/media/platform/qcom/Makefile               |    6 +
 drivers/media/platform/qcom/vidc/Makefile          |   15 +
 drivers/media/platform/qcom/vidc/core.c            |  559 +++++++
 drivers/media/platform/qcom/vidc/core.h            |  207 +++
 drivers/media/platform/qcom/vidc/helpers.c         |  604 ++++++++
 drivers/media/platform/qcom/vidc/helpers.h         |   43 +
 drivers/media/platform/qcom/vidc/hfi.c             |  617 ++++++++
 drivers/media/platform/qcom/vidc/hfi.h             |  272 ++++
 drivers/media/platform/qcom/vidc/hfi_cmds.c        | 1261 ++++++++++++++++
 drivers/media/platform/qcom/vidc/hfi_cmds.h        |  338 +++++
 drivers/media/platform/qcom/vidc/hfi_helper.h      | 1143 +++++++++++++++
 drivers/media/platform/qcom/vidc/hfi_msgs.c        | 1072 ++++++++++++++
 drivers/media/platform/qcom/vidc/hfi_msgs.h        |  298 ++++
 drivers/media/platform/qcom/vidc/hfi_venus.c       | 1534 ++++++++++++++++++++
 drivers/media/platform/qcom/vidc/hfi_venus.h       |   25 +
 drivers/media/platform/qcom/vidc/hfi_venus_io.h    |   98 ++
 drivers/media/platform/qcom/vidc/vdec.c            | 1091 ++++++++++++++
 drivers/media/platform/qcom/vidc/vdec.h            |   29 +
 drivers/media/platform/qcom/vidc/vdec_ctrls.c      |  200 +++
 drivers/media/platform/qcom/vidc/vdec_ctrls.h      |   21 +
 drivers/media/platform/qcom/vidc/venc.c            | 1252 ++++++++++++++++
 drivers/media/platform/qcom/vidc/venc.h            |   29 +
 drivers/media/platform/qcom/vidc/venc_ctrls.c      |  396 +++++
 drivers/media/platform/qcom/vidc/venc_ctrls.h      |   23 +
 28 files changed, 11204 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/qcom,vidc.txt
 create mode 100644 drivers/media/platform/qcom/Kconfig
 create mode 100644 drivers/media/platform/qcom/Makefile
 create mode 100644 drivers/media/platform/qcom/vidc/Makefile
 create mode 100644 drivers/media/platform/qcom/vidc/core.c
 create mode 100644 drivers/media/platform/qcom/vidc/core.h
 create mode 100644 drivers/media/platform/qcom/vidc/helpers.c
 create mode 100644 drivers/media/platform/qcom/vidc/helpers.h
 create mode 100644 drivers/media/platform/qcom/vidc/hfi.c
 create mode 100644 drivers/media/platform/qcom/vidc/hfi.h
 create mode 100644 drivers/media/platform/qcom/vidc/hfi_cmds.c
 create mode 100644 drivers/media/platform/qcom/vidc/hfi_cmds.h
 create mode 100644 drivers/media/platform/qcom/vidc/hfi_helper.h
 create mode 100644 drivers/media/platform/qcom/vidc/hfi_msgs.c
 create mode 100644 drivers/media/platform/qcom/vidc/hfi_msgs.h
 create mode 100644 drivers/media/platform/qcom/vidc/hfi_venus.c
 create mode 100644 drivers/media/platform/qcom/vidc/hfi_venus.h
 create mode 100644 drivers/media/platform/qcom/vidc/hfi_venus_io.h
 create mode 100644 drivers/media/platform/qcom/vidc/vdec.c
 create mode 100644 drivers/media/platform/qcom/vidc/vdec.h
 create mode 100644 drivers/media/platform/qcom/vidc/vdec_ctrls.c
 create mode 100644 drivers/media/platform/qcom/vidc/vdec_ctrls.h
 create mode 100644 drivers/media/platform/qcom/vidc/venc.c
 create mode 100644 drivers/media/platform/qcom/vidc/venc.h
 create mode 100644 drivers/media/platform/qcom/vidc/venc_ctrls.c
 create mode 100644 drivers/media/platform/qcom/vidc/venc_ctrls.h

-- 
2.7.4

