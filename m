Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:34627 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754315AbdBGNK5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 08:10:57 -0500
Received: by mail-wm0-f53.google.com with SMTP id 196so42618731wmm.1
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 05:10:56 -0800 (PST)
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
Subject: [PATCH v6 0/9] Qualcomm video decoder/encoder driver
Date: Tue,  7 Feb 2017 15:10:15 +0200
Message-Id: <1486473024-21705-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Here is sixth version of the patchset - no functional changes in
v4l2 APIs.

The changes since v5 are mainly related to support Venus IP on
msm8996 SoCs.
  * changes in DT binding document - added three DT subnodes
    video-decoder, video-encoder and video-firmware see 2/9.
  * splitting up the driver on three platform drivers called
    venus-core, venus-enc and venus-dec to satisfy requirement for
    Venus core on msm8996 SoCs where core, decoder and encoder have
    separate power-domains and clocks. 
  * moved part of the firmware loader in the venus-core driver
    (removed previous remoteproc API).
  * fixed various issues.

Build dependencies:
  - qcom_scm_set_remote_state is in linux-next
  - qcom mdt_loader will be soon in linux-next

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

 .../devicetree/bindings/media/qcom,venus.txt       |  112 ++
 MAINTAINERS                                        |    8 +
 drivers/media/platform/Kconfig                     |   14 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/qcom/venus/Makefile         |   11 +
 drivers/media/platform/qcom/venus/core.c           |  368 +++++
 drivers/media/platform/qcom/venus/core.h           |  303 ++++
 drivers/media/platform/qcom/venus/firmware.c       |  151 ++
 drivers/media/platform/qcom/venus/firmware.h       |   22 +
 drivers/media/platform/qcom/venus/helpers.c        |  640 ++++++++
 drivers/media/platform/qcom/venus/helpers.h        |   41 +
 drivers/media/platform/qcom/venus/hfi.c            |  506 +++++++
 drivers/media/platform/qcom/venus/hfi.h            |  174 +++
 drivers/media/platform/qcom/venus/hfi_cmds.c       | 1256 ++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_cmds.h       |  304 ++++
 drivers/media/platform/qcom/venus/hfi_helper.h     | 1045 +++++++++++++
 drivers/media/platform/qcom/venus/hfi_msgs.c       | 1057 +++++++++++++
 drivers/media/platform/qcom/venus/hfi_msgs.h       |  283 ++++
 drivers/media/platform/qcom/venus/hfi_venus.c      | 1574 ++++++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_venus.h      |   23 +
 drivers/media/platform/qcom/venus/hfi_venus_io.h   |  113 ++
 drivers/media/platform/qcom/venus/vdec.c           | 1083 ++++++++++++++
 drivers/media/platform/qcom/venus/vdec.h           |   23 +
 drivers/media/platform/qcom/venus/vdec_ctrls.c     |  149 ++
 drivers/media/platform/qcom/venus/venc.c           | 1231 +++++++++++++++
 drivers/media/platform/qcom/venus/venc.h           |   23 +
 drivers/media/platform/qcom/venus/venc_ctrls.c     |  258 ++++
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   37 +
 include/media/v4l2-mem2mem.h                       |   92 ++
 29 files changed, 10903 insertions(+)
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

