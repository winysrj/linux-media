Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:33874 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbdFOQcY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 12:32:24 -0400
Received: by mail-wr0-f177.google.com with SMTP id 77so25367160wrb.1
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 09:32:24 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v11 00/19] Qualcomm video decoder/encoder driver
Date: Thu, 15 Jun 2017 19:31:41 +0300
Message-Id: <1497544320-2269-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Changes since v10:
 * added patch 18/19 which updates firmware path.

regards,
Stan

Stanimir Varbanov (19):
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
  media: venus: hfi: fix mutex unlock
  media: venus: hfi_cmds: fix variable dereferenced before check
  media: venus: helpers: fix variable dereferenced before check
  media: venus: hfi_venus: fix variable dereferenced before check
  media: venus: hfi_msgs: fix set but not used variables
  media: venus: vdec: fix compile error in vdec_close
  media: venus: venc: fix compile error in venc_close
  media: venus: vdec: add support for min buffers for capture
  media: venus: update firmware path with linux-firmware place
  media: venus: enable building with COMPILE_TEST

 .../devicetree/bindings/media/qcom,venus.txt       |  107 ++
 MAINTAINERS                                        |    8 +
 drivers/media/platform/Kconfig                     |   13 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/qcom/venus/Makefile         |   11 +
 drivers/media/platform/qcom/venus/core.c           |  390 +++++
 drivers/media/platform/qcom/venus/core.h           |  324 ++++
 drivers/media/platform/qcom/venus/firmware.c       |  108 ++
 drivers/media/platform/qcom/venus/firmware.h       |   23 +
 drivers/media/platform/qcom/venus/helpers.c        |  725 +++++++++
 drivers/media/platform/qcom/venus/helpers.h        |   45 +
 drivers/media/platform/qcom/venus/hfi.c            |  522 +++++++
 drivers/media/platform/qcom/venus/hfi.h            |  175 +++
 drivers/media/platform/qcom/venus/hfi_cmds.c       | 1259 ++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_cmds.h       |  304 ++++
 drivers/media/platform/qcom/venus/hfi_helper.h     | 1050 +++++++++++++
 drivers/media/platform/qcom/venus/hfi_msgs.c       | 1052 +++++++++++++
 drivers/media/platform/qcom/venus/hfi_msgs.h       |  283 ++++
 drivers/media/platform/qcom/venus/hfi_venus.c      | 1572 ++++++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_venus.h      |   23 +
 drivers/media/platform/qcom/venus/hfi_venus_io.h   |  113 ++
 drivers/media/platform/qcom/venus/vdec.c           | 1162 +++++++++++++++
 drivers/media/platform/qcom/venus/vdec.h           |   23 +
 drivers/media/platform/qcom/venus/vdec_ctrls.c     |  158 ++
 drivers/media/platform/qcom/venus/venc.c           | 1283 ++++++++++++++++
 drivers/media/platform/qcom/venus/venc.h           |   23 +
 drivers/media/platform/qcom/venus/venc_ctrls.c     |  270 ++++
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   37 +
 include/media/v4l2-mem2mem.h                       |   92 ++
 29 files changed, 11157 insertions(+)
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
