Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:59378 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751437AbdEEMoR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 08:44:17 -0400
Subject: Re: [PATCH v8 00/10] Qualcomm video decoder/encoder driver
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1493370837-19793-1-git-send-email-stanimir.varbanov@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c0bdbddd-e6df-f8a5-6d04-0d4e84c9dd0a@xs4all.nl>
Date: Fri, 5 May 2017 14:44:04 +0200
MIME-Version: 1.0
In-Reply-To: <1493370837-19793-1-git-send-email-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

It looks good to me. I do think that patch 01/10 shouldn't go through
media. This might mean that we have to drop the COMPILE_TEST dependency
on the media driver until this firmware driver patch gets merged, which
is fine with me as long as this is clearly stated in the commit log for
the media Kconfig. Let me know what you want to do with this.

I also saw some comments for patch 05/10, but I'm not sure if that would
block merging this driver or can be fixed afterwards.

Regards,

	Hans

On 04/28/17 11:13, Stanimir Varbanov wrote:
> Hi everyone,
> 
> The changes since v7 are:
>   * fixed error path in recovery handler.
>   * fixed the logic in helper_vb2_buf_prepare.
>   * added comments over venus_format arrays why MPLANE formats are used.
>   * added sequence for output queue as well.
>   * added COMPILE_TEST Kconfig option for the venus driver. To make
>   compile testing of the venus driver possible I had to create a patch
>   01/10 which fixing the qcom SCM driver.
> 
> I have made various fixes and improvements of the decoder and encoder
> to make them work on Venus hw versions 1xx & 3xx (Venus hw v.1xx is found
> on SoC apq8016 / db410c SBC board, and Venus hw v.3xx on apq8096).
> A brief of the changes:
>   * implemented buffer reference handling. This is adding delayed process
>   of the newly queued buffers until the firmware release them completely.
>   With this in place now vidioc_create_bufs op works properly.
>   * implemented vidioc_try_decoder_cmd and vidioc_decoder_cmd v4l2 ioctl
>   ops.
>   * cleanups and run checkpatch --strict
> 
> The patchset is based on next-20170426 and applies cleanly on media_tree
> as well.
> 
> The report of v4l2-compliance is below patchset diff status.
> 
> regards,
> Stan
>   
> Stanimir Varbanov (10):
>   firmware: qcom_scm: Fix to allow COMPILE_TEST-ing
>   media: v4l2-mem2mem: extend m2m APIs for more accurate buffer
>     management
>   doc: DT: venus: binding document for Qualcomm video driver
>   MAINTAINERS: Add Qualcomm Venus video accelerator driver
>   media: venus: adding core part and helper functions
>   media: venus: vdec: add video decoder files
>   media: venus: venc: add video encoder files
>   media: venus: hfi: add Host Firmware Interface (HFI)
>   media: venus: hfi: add Venus HFI files
>   media: venus: enable building of Venus video driver
> 
>  .../devicetree/bindings/media/qcom,venus.txt       |  107 ++
>  MAINTAINERS                                        |    8 +
>  drivers/firmware/Kconfig                           |    2 +-
>  drivers/firmware/qcom_scm.h                        |   72 +-
>  drivers/media/platform/Kconfig                     |   13 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/qcom/venus/Makefile         |   11 +
>  drivers/media/platform/qcom/venus/core.c           |  388 +++++
>  drivers/media/platform/qcom/venus/core.h           |  323 ++++
>  drivers/media/platform/qcom/venus/firmware.c       |  107 ++
>  drivers/media/platform/qcom/venus/firmware.h       |   22 +
>  drivers/media/platform/qcom/venus/helpers.c        |  725 +++++++++
>  drivers/media/platform/qcom/venus/helpers.h        |   44 +
>  drivers/media/platform/qcom/venus/hfi.c            |  522 +++++++
>  drivers/media/platform/qcom/venus/hfi.h            |  175 +++
>  drivers/media/platform/qcom/venus/hfi_cmds.c       | 1255 ++++++++++++++++
>  drivers/media/platform/qcom/venus/hfi_cmds.h       |  304 ++++
>  drivers/media/platform/qcom/venus/hfi_helper.h     | 1050 +++++++++++++
>  drivers/media/platform/qcom/venus/hfi_msgs.c       | 1056 +++++++++++++
>  drivers/media/platform/qcom/venus/hfi_msgs.h       |  283 ++++
>  drivers/media/platform/qcom/venus/hfi_venus.c      | 1571 ++++++++++++++++++++
>  drivers/media/platform/qcom/venus/hfi_venus.h      |   23 +
>  drivers/media/platform/qcom/venus/hfi_venus_io.h   |  113 ++
>  drivers/media/platform/qcom/venus/vdec.c           | 1152 ++++++++++++++
>  drivers/media/platform/qcom/venus/vdec.h           |   23 +
>  drivers/media/platform/qcom/venus/vdec_ctrls.c     |  149 ++
>  drivers/media/platform/qcom/venus/venc.c           | 1281 ++++++++++++++++
>  drivers/media/platform/qcom/venus/venc.h           |   23 +
>  drivers/media/platform/qcom/venus/venc_ctrls.c     |  269 ++++
>  drivers/media/v4l2-core/v4l2-mem2mem.c             |   37 +
>  include/linux/qcom_scm.h                           |   32 -
>  include/media/v4l2-mem2mem.h                       |   92 ++
>  32 files changed, 11190 insertions(+), 44 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/qcom,venus.txt
>  create mode 100644 drivers/media/platform/qcom/venus/Makefile
>  create mode 100644 drivers/media/platform/qcom/venus/core.c
>  create mode 100644 drivers/media/platform/qcom/venus/core.h
>  create mode 100644 drivers/media/platform/qcom/venus/firmware.c
>  create mode 100644 drivers/media/platform/qcom/venus/firmware.h
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
> dragonboard-410c:~$ ./v4l2-compliance -d /dev/video0
> v4l2-compliance SHA   : 8fc88615b49843acb82cd8316d0bc4ab8474cba2
> 
> Driver Info:
>         Driver name   : qcom-venus
>         Card type     : Qualcomm Venus video decoder
>         Bus info      : platform:qcom-venus
>         Driver version: 4.9.0
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
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK
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
> 
> 
> dragonboard-410c:~$ ./v4l2-compliance -d /dev/video1
> v4l2-compliance SHA   : 8fc88615b49843acb82cd8316d0bc4ab8474cba2
> 
> Driver Info:
>         Driver name   : qcom-venus
>         Card type     : Qualcomm Venus video encoder
>         Bus info      : platform:qcom-venus
>         Driver version: 4.9.0
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
>                 Standard Controls: 28 Private Controls: 0
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
> 
> Total: 43, Succeeded: 43, Failed: 0, Warnings: 0
>  
> 
