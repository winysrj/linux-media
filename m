Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:54986 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752376AbdFNM0b (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 08:26:31 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [PATCH v10 00/18] Qualcomm video decoder/encoder driver
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <1497284875-19999-1-git-send-email-stanimir.varbanov@linaro.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Message-ID: <f712a088-274c-b634-b0bc-fd5eb12c5a68@mm-sol.com>
Date: Wed, 14 Jun 2017 15:21:17 +0300
MIME-Version: 1.0
In-Reply-To: <1497284875-19999-1-git-send-email-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

One note, I have sent pull request for the firmware but forgot to update
the firmware path in the driver for the new location. It is not a big
deal, but I have to send one more patch which changes the firmware path.

About COMPILE_TEST, the patch for qcom_scm driver probably will be taken
in 4.13 merge window through arm-soc. So I'm wondering could you
postpone 18/18 until this patch is merged to avoid build breakage.

regards,
Stan

On 06/12/2017 07:27 PM, Stanimir Varbanov wrote:
> Hello,
> 
> The changes since patchset v9 are the following:
>  * patches from 1/18 to 9/18 are the same.
>  * patches from 10/18 to 16/18 are fixes for warns/errors found by
>    Mauro when building with its gcc7.
>  * patch 17/18 adding support for minimum buffers for capture
>    get control. This fixes an issue with gstreamer and it will
>    be good to have it in the inital version of the venus driver.
>  * patch 18/18 enable COMPILE_TEST Kconfig option for the driver,
>    and this patch depends on the other one for qcom_scm driver.
>    The submited patch for qcom_scm driver can be found at [1].
> 
> Mauro, I failed to build gcc7 on my own machine and fallback to
> a pre-built version of the gcc-7 for may Ubuntu distro. The version
> which I tried was: gcc version 7.1.0 (Ubuntu 7.1.0-5ubuntu2~16.04).
> Unfortunately I cannot reproduce the warns/errors (except two
> warnings) from your compiler (even that the version looks
> the same 7.1.0). So I fixed the warns/errors as per your response
> to v9, and hope that the errors will disappear.
> 
> [1] https://patchwork.kernel.org/patch/9775803/
> 
> Stanimir Varbanov (18):
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
>   media: venus: hfi: fix mutex unlock
>   media: venus: hfi_cmds: fix variable dereferenced before check
>   media: venus: helpers: fix variable dereferenced before check
>   media: venus: hfi_venus: fix variable dereferenced before check
>   media: venus: hfi_msgs: fix set but not used variables
>   media: venus: vdec: fix compile error in vdec_close
>   media: venus: venc: fix compile error in venc_close
>   media: venus: vdec: add support for min buffers for capture
>   media: venus: enable building with COMPILE_TEST
> 
>  .../devicetree/bindings/media/qcom,venus.txt       |  107 ++
>  MAINTAINERS                                        |    8 +
>  drivers/media/platform/Kconfig                     |   13 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/qcom/venus/Makefile         |   11 +
>  drivers/media/platform/qcom/venus/core.c           |  388 +++++
>  drivers/media/platform/qcom/venus/core.h           |  323 ++++
>  drivers/media/platform/qcom/venus/firmware.c       |  109 ++
>  drivers/media/platform/qcom/venus/firmware.h       |   22 +
>  drivers/media/platform/qcom/venus/helpers.c        |  725 +++++++++
>  drivers/media/platform/qcom/venus/helpers.h        |   45 +
>  drivers/media/platform/qcom/venus/hfi.c            |  522 +++++++
>  drivers/media/platform/qcom/venus/hfi.h            |  175 +++
>  drivers/media/platform/qcom/venus/hfi_cmds.c       | 1259 ++++++++++++++++
>  drivers/media/platform/qcom/venus/hfi_cmds.h       |  304 ++++
>  drivers/media/platform/qcom/venus/hfi_helper.h     | 1050 +++++++++++++
>  drivers/media/platform/qcom/venus/hfi_msgs.c       | 1052 +++++++++++++
>  drivers/media/platform/qcom/venus/hfi_msgs.h       |  283 ++++
>  drivers/media/platform/qcom/venus/hfi_venus.c      | 1572 ++++++++++++++++++++
>  drivers/media/platform/qcom/venus/hfi_venus.h      |   23 +
>  drivers/media/platform/qcom/venus/hfi_venus_io.h   |  113 ++
>  drivers/media/platform/qcom/venus/vdec.c           | 1162 +++++++++++++++
>  drivers/media/platform/qcom/venus/vdec.h           |   23 +
>  drivers/media/platform/qcom/venus/vdec_ctrls.c     |  158 ++
>  drivers/media/platform/qcom/venus/venc.c           | 1283 ++++++++++++++++
>  drivers/media/platform/qcom/venus/venc.h           |   23 +
>  drivers/media/platform/qcom/venus/venc_ctrls.c     |  270 ++++
>  drivers/media/v4l2-core/v4l2-mem2mem.c             |   37 +
>  include/media/v4l2-mem2mem.h                       |   92 ++
>  29 files changed, 11154 insertions(+)
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
> Here is the output of v4l2-compliance for decoder (as in this version
> of the patchset only decoder has functional changes):
>  
> dragonboard-410c:~$ ./v4l2-compliance -d /dev/video0
> v4l2-compliance SHA   : 8fc88615b49843acb82cd8316d0bc4ab8474cba2
> 
> Driver Info:
>         Driver name   : qcom-venus
>         Card type     : Qualcomm Venus video decoder
>         Bus info      : platform:qcom-venus
>         Driver version: 4.9.27
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
>                 Standard Controls: 9 Private Controls: 0
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
