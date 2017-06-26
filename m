Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37073 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdFZJUw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 05:20:52 -0400
Received: by mail-wm0-f41.google.com with SMTP id i127so2208654wma.0
        for <linux-media@vger.kernel.org>; Mon, 26 Jun 2017 02:20:51 -0700 (PDT)
Subject: Re: [PATCH v11 00/19] Qualcomm video decoder/encoder driver
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <1497544320-2269-1-git-send-email-stanimir.varbanov@linaro.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <e4ac8371-6474-8371-08ba-72689349f118@linaro.org>
Date: Mon, 26 Jun 2017 12:20:26 +0300
MIME-Version: 1.0
In-Reply-To: <1497544320-2269-1-git-send-email-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

In case someone wants to play with the driver I've pushed a git tree at
[1] which contains few patches on top of the driver. Those patches are
on upstreaming phase but doesn't merged yet.

[1] https://github.com/svarbanov/linux/tree/master-venus-v11

On 06/15/2017 07:31 PM, Stanimir Varbanov wrote:
> Hello,
> 
> Changes since v10:
>  * added patch 18/19 which updates firmware path.
> 
> regards,
> Stan
> 
> Stanimir Varbanov (19):
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
>   media: venus: update firmware path with linux-firmware place
>   media: venus: enable building with COMPILE_TEST
> 
>  .../devicetree/bindings/media/qcom,venus.txt       |  107 ++
>  MAINTAINERS                                        |    8 +
>  drivers/media/platform/Kconfig                     |   13 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/qcom/venus/Makefile         |   11 +
>  drivers/media/platform/qcom/venus/core.c           |  390 +++++
>  drivers/media/platform/qcom/venus/core.h           |  324 ++++
>  drivers/media/platform/qcom/venus/firmware.c       |  108 ++
>  drivers/media/platform/qcom/venus/firmware.h       |   23 +
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
>  29 files changed, 11157 insertions(+)
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

-- 
regards,
Stan
