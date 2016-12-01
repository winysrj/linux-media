Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f174.google.com ([209.85.210.174]:34023 "EHLO
        mail-wj0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbcLAJJe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2016 04:09:34 -0500
Received: by mail-wj0-f174.google.com with SMTP id mp19so198910405wjc.1
        for <linux-media@vger.kernel.org>; Thu, 01 Dec 2016 01:09:33 -0800 (PST)
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
Subject: [PATCH v4 0/9] Qualcomm video decoder/encoder driver
Date: Thu,  1 Dec 2016 11:03:12 +0200
Message-Id: <1480583001-32236-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here is version 4 of the Venus video driver.

The changes since v3 are:
  * the driver now use m2m APIs. In order to make possible to
use m2m I had to extend m2m APIs with few more helper functions
for buffer list manipulations.
  * addressed comments from Hans about buffer done on error path.
  * simplify s_selection in decoder.
  * avoid simple IRQ related wrappers in core.c and use HFI ones directly.
  * added kernel doc description of venus_core|inst structures.
  * replaced list_for_each_entry_safe with list_for_each_entry where
safer variants are not applicable.
  * revisit the locking per instance and come down to one lock per
instance.
  * added help text in the driver Kconfig option.
  * deleted custom venus_ctrl structure which duplicates v4l2_ctrl_config.
  * various cleanups on random places to avoid code duplications and
to reduce the code lines.
  * removed video memory (vmem) DT properties from binding document, this
will need more work.

The previous version can be found at https://lkml.org/lkml/2016/11/7/554

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

 .../devicetree/bindings/media/qcom,venus.txt       |   82 ++
 MAINTAINERS                                        |    8 +
 drivers/media/platform/Kconfig                     |   13 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/qcom/venus/Makefile         |   14 +
 drivers/media/platform/qcom/venus/core.c           |  474 ++++++
 drivers/media/platform/qcom/venus/core.h           |  296 ++++
 drivers/media/platform/qcom/venus/helpers.c        |  621 ++++++++
 drivers/media/platform/qcom/venus/helpers.h        |   41 +
 drivers/media/platform/qcom/venus/hfi.c            |  492 +++++++
 drivers/media/platform/qcom/venus/hfi.h            |  174 +++
 drivers/media/platform/qcom/venus/hfi_cmds.c       | 1256 ++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_cmds.h       |  304 ++++
 drivers/media/platform/qcom/venus/hfi_helper.h     | 1045 ++++++++++++++
 drivers/media/platform/qcom/venus/hfi_msgs.c       | 1054 ++++++++++++++
 drivers/media/platform/qcom/venus/hfi_msgs.h       |  283 ++++
 drivers/media/platform/qcom/venus/hfi_venus.c      | 1508 ++++++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_venus.h      |   23 +
 drivers/media/platform/qcom/venus/hfi_venus_io.h   |   98 ++
 drivers/media/platform/qcom/venus/vdec.c           |  976 +++++++++++++
 drivers/media/platform/qcom/venus/vdec.h           |   32 +
 drivers/media/platform/qcom/venus/vdec_ctrls.c     |  149 ++
 drivers/media/platform/qcom/venus/venc.c           | 1099 ++++++++++++++
 drivers/media/platform/qcom/venus/venc.h           |   32 +
 drivers/media/platform/qcom/venus/venc_ctrls.c     |  258 ++++
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   37 +
 include/media/v4l2-mem2mem.h                       |   83 ++
 27 files changed, 10454 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/qcom,venus.txt
 create mode 100644 drivers/media/platform/qcom/venus/Makefile
 create mode 100644 drivers/media/platform/qcom/venus/core.c
 create mode 100644 drivers/media/platform/qcom/venus/core.h
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

