Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44577 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751790AbdEVHhx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 03:37:53 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] Add qualcomm venus codec
Message-ID: <441c2430-ff9a-6212-4252-1502312248da@xs4all.nl>
Date: Mon, 22 May 2017 09:37:48 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull requests adds support for the Qualcomm venus codec driver.

Regards,

	Hans


The following changes since commit 36bcba973ad478042d1ffc6e89afd92e8bd17030:

  [media] mtk_vcodec_dec: return error at mtk_vdec_pic_info_update() (2017-05-19 07:12:05 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git venus

for you to fetch changes up to f0486d42560ae110f6e7d9b92352d7a1827cd38e:

  media: venus: enable building of Venus video driver (2017-05-22 09:24:20 +0200)

----------------------------------------------------------------
Stanimir Varbanov (9):
      media: v4l2-mem2mem: extend m2m APIs for more accurate buffer management
      doc: DT: venus: binding document for Qualcomm video driver
      MAINTAINERS: Add Qualcomm Venus video accelerator driver
      media: venus: adding core part and helper functions
      media: venus: vdec: add video decoder files
      media: venus: venc: add video encoder files
      media: venus: hfi: add Host Firmware Interface (HFI)
      media: venus: hfi: add Venus HFI files
      media: venus: enable building of Venus video driver

 Documentation/devicetree/bindings/media/qcom,venus.txt |  107 +++
 MAINTAINERS                                            |    8 +
 drivers/media/platform/Kconfig                         |   13 +
 drivers/media/platform/Makefile                        |    2 +
 drivers/media/platform/qcom/venus/Makefile             |   11 +
 drivers/media/platform/qcom/venus/core.c               |  388 +++++++++++
 drivers/media/platform/qcom/venus/core.h               |  323 +++++++++
 drivers/media/platform/qcom/venus/firmware.c           |  109 +++
 drivers/media/platform/qcom/venus/firmware.h           |   22 +
 drivers/media/platform/qcom/venus/helpers.c            |  727 ++++++++++++++++++++
 drivers/media/platform/qcom/venus/helpers.h            |   45 ++
 drivers/media/platform/qcom/venus/hfi.c                |  522 +++++++++++++++
 drivers/media/platform/qcom/venus/hfi.h                |  175 +++++
 drivers/media/platform/qcom/venus/hfi_cmds.c           | 1255 +++++++++++++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_cmds.h           |  304 +++++++++
 drivers/media/platform/qcom/venus/hfi_helper.h         | 1050 +++++++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_msgs.c           | 1054 +++++++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_msgs.h           |  283 ++++++++
 drivers/media/platform/qcom/venus/hfi_venus.c          | 1571 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_venus.h          |   23 +
 drivers/media/platform/qcom/venus/hfi_venus_io.h       |  113 ++++
 drivers/media/platform/qcom/venus/vdec.c               | 1154 ++++++++++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/vdec.h               |   23 +
 drivers/media/platform/qcom/venus/vdec_ctrls.c         |  150 +++++
 drivers/media/platform/qcom/venus/venc.c               | 1283 ++++++++++++++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/venc.h               |   23 +
 drivers/media/platform/qcom/venus/venc_ctrls.c         |  270 ++++++++
 drivers/media/v4l2-core/v4l2-mem2mem.c                 |   37 ++
 include/media/v4l2-mem2mem.h                           |   92 +++
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
