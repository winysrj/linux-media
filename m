Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:35739 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754050AbdEIPg3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 11:36:29 -0400
Received: by mail-wr0-f177.google.com with SMTP id z52so4125212wrc.2
        for <linux-media@vger.kernel.org>; Tue, 09 May 2017 08:36:28 -0700 (PDT)
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
Subject: [PATCH v9 0/9] Qualcomm video decoder/encoder driver
Date: Tue,  9 May 2017 18:35:52 +0300
Message-Id: <1494344161-28131-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

The changes since v8 are:
  * no functional changes.
  * dropped COMPILE_TEST support until the drivers which Venus
  driver selects got compile test support.
  * added venus_ prefix to the exported helper functions as
  suggested by Sakari.
  * fixed few signed-unsigned compare warnings.

Patches applies cleanly on next-20170509 and media_tree.
  
regards,
Stan

Stanimir Varbanov (9):
  media: v4l2-mem2mem: extend m2m APIs for more accurate buffer
    management
  doc: DT: venus: binding document for Qualcomm video driver
  MAINTAINERS: Add Qualcomm Venus video accelerator driver
  media: venus: adding core part and helper functions
  media: venus: vdec: add video decoder files
  media: venus: venc: add video encoder files
  media: venus: hfi: add Host Firmware Interface (HFI)
  media: venus: hfi: add Venus HFI files
  media: venus: enable building of Venus video driver

 .../devicetree/bindings/media/qcom,venus.txt       |  107 ++
 MAINTAINERS                                        |    8 +
 drivers/media/platform/Kconfig                     |   13 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/qcom/venus/Makefile         |   11 +
 drivers/media/platform/qcom/venus/core.c           |  388 +++++
 drivers/media/platform/qcom/venus/core.h           |  323 ++++
 drivers/media/platform/qcom/venus/firmware.c       |  109 ++
 drivers/media/platform/qcom/venus/firmware.h       |   22 +
 drivers/media/platform/qcom/venus/helpers.c        |  727 +++++++++
 drivers/media/platform/qcom/venus/helpers.h        |   45 +
 drivers/media/platform/qcom/venus/hfi.c            |  522 +++++++
 drivers/media/platform/qcom/venus/hfi.h            |  175 +++
 drivers/media/platform/qcom/venus/hfi_cmds.c       | 1255 ++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_cmds.h       |  304 ++++
 drivers/media/platform/qcom/venus/hfi_helper.h     | 1050 +++++++++++++
 drivers/media/platform/qcom/venus/hfi_msgs.c       | 1054 +++++++++++++
 drivers/media/platform/qcom/venus/hfi_msgs.h       |  283 ++++
 drivers/media/platform/qcom/venus/hfi_venus.c      | 1571 ++++++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_venus.h      |   23 +
 drivers/media/platform/qcom/venus/hfi_venus_io.h   |  113 ++
 drivers/media/platform/qcom/venus/vdec.c           | 1154 ++++++++++++++
 drivers/media/platform/qcom/venus/vdec.h           |   23 +
 drivers/media/platform/qcom/venus/vdec_ctrls.c     |  150 ++
 drivers/media/platform/qcom/venus/venc.c           | 1283 ++++++++++++++++
 drivers/media/platform/qcom/venus/venc.h           |   23 +
 drivers/media/platform/qcom/venus/venc_ctrls.c     |  270 ++++
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   37 +
 include/media/v4l2-mem2mem.h                       |   92 ++
 29 files changed, 11137 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/qcom,venus.txt
 create mode 100644 drivers/media/platform/qcom/venus/Makefile
 create mode 100644 drivers/media/platform/qcom/venus/core.c
 create mode 100644 drivers/media/platform/qcom/venus/core.h
 create mode 100644 drivers/media/platform/qcom/venus/firmware.c
 create mode 100644 drivers/media/platform/qcom/venus/firmware.h
 create mode 100644 drivers/media/platform/qcom/venus/helpers.c
 create mode 100644 drivers/media/platform/qcom/venus/helpers.h
 create mode 100644 drivers/media/platform/qcom/venus/hfi.c
 create mode 100644 drivers/media/platform/qcom/venus/hfi.h
 create mode 100644 drivers/media/platform/qcom/venus/hfi_cmds.c
 create mode 100644 drivers/media/platform/qcom/venus/hfi_cmds.h
 create mode 100644 drivers/media/platform/qcom/venus/hfi_helper.h
 create mode 100644 drivers/media/platform/qcom/venus/hfi_msgs.c
 create mode 100644 drivers/media/platform/qcom/venus/hfi_msgs.h
 create mode 100644 drivers/media/platform/qcom/venus/hfi_venus.c
 create mode 100644 drivers/media/platform/qcom/venus/hfi_venus.h
 create mode 100644 drivers/media/platform/qcom/venus/hfi_venus_io.h
 create mode 100644 drivers/media/platform/qcom/venus/vdec.c
 create mode 100644 drivers/media/platform/qcom/venus/vdec.h
 create mode 100644 drivers/media/platform/qcom/venus/vdec_ctrls.c
 create mode 100644 drivers/media/platform/qcom/venus/venc.c
 create mode 100644 drivers/media/platform/qcom/venus/venc.h
 create mode 100644 drivers/media/platform/qcom/venus/venc_ctrls.c

-- 
2.7.4
