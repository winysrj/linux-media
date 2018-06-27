Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34096 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753444AbeF0P1o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 11:27:44 -0400
Received: by mail-wm0-f66.google.com with SMTP id l15-v6so18348253wmc.1
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2018 08:27:44 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v4 00/27] Venus updates
Date: Wed, 27 Jun 2018 18:26:58 +0300
Message-Id: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here is v4 with following changes:

- fixed kbuild test robot in 12/27.
- fixed destination of memcpy in fill_xxx functions.

v3 can be found at https://lkml.org/lkml/2018/6/13/464

regards,
Stan

Stanimir Varbanov (27):
  venus: hfi_msgs: correct pointer increment
  venus: hfi: preparation to support venus 4xx
  venus: hfi: update sequence event to handle more properties
  venus: hfi_cmds: add set_properties for 4xx version
  venus: hfi: support session continue for 4xx version
  venus: hfi: handle buffer output2 type as well
  venus: hfi_venus: add halt AXI support for Venus 4xx
  venus: hfi_venus: fix suspend function for venus 3xx versions
  venus: hfi_venus: move set of default properties to core init
  venus: hfi_venus: add suspend functionality for Venus 4xx
  venus: core,helpers: add two more clocks found in Venus 4xx
  venus: hfi_parser: add common capability parser
  venus: helpers: rename a helper function and use buffer mode from caps
  venus: helpers: add a helper function to set dynamic buffer mode
  venus: helpers: add helper function to set actual buffer size
  venus: core: delete not used buffer mode flags
  venus: helpers: add buffer type argument to a helper
  venus: helpers: add a new helper to set raw format
  venus: helpers,vdec,venc: add helpers to set work mode and core usage
  venus: helpers: extend set_num_bufs helper with one more argument
  venus: helpers: add a helper to return opb buffer sizes
  venus: vdec: get required input buffers as well
  venus: vdec: a new function for output configuration
  venus: helpers: move frame size calculations on common place
  venus: implementing multi-stream support
  venus: core: add sdm845 DT compatible and resource data
  venus: add HEVC codec support

 .../devicetree/bindings/media/qcom,venus.txt       |   1 +
 drivers/media/platform/qcom/venus/Makefile         |   3 +-
 drivers/media/platform/qcom/venus/core.c           | 107 ++++
 drivers/media/platform/qcom/venus/core.h           | 100 ++--
 drivers/media/platform/qcom/venus/helpers.c        | 555 +++++++++++++++++++--
 drivers/media/platform/qcom/venus/helpers.h        |  23 +-
 drivers/media/platform/qcom/venus/hfi.c            |  12 +-
 drivers/media/platform/qcom/venus/hfi.h            |  10 +
 drivers/media/platform/qcom/venus/hfi_cmds.c       |  62 ++-
 drivers/media/platform/qcom/venus/hfi_helper.h     | 112 ++++-
 drivers/media/platform/qcom/venus/hfi_msgs.c       | 399 +++------------
 drivers/media/platform/qcom/venus/hfi_parser.c     | 278 +++++++++++
 drivers/media/platform/qcom/venus/hfi_parser.h     |  45 ++
 drivers/media/platform/qcom/venus/hfi_venus.c      | 109 +++-
 drivers/media/platform/qcom/venus/hfi_venus_io.h   |  10 +
 drivers/media/platform/qcom/venus/vdec.c           | 326 +++++++-----
 drivers/media/platform/qcom/venus/venc.c           | 220 ++++----
 17 files changed, 1694 insertions(+), 678 deletions(-)
 create mode 100644 drivers/media/platform/qcom/venus/hfi_parser.c
 create mode 100644 drivers/media/platform/qcom/venus/hfi_parser.h

-- 
2.14.1
