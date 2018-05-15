Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36797 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbeEOH72 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:59:28 -0400
Received: by mail-wr0-f195.google.com with SMTP id p4-v6so14929106wrh.3
        for <linux-media@vger.kernel.org>; Tue, 15 May 2018 00:59:28 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2 00/29] Venus updates
Date: Tue, 15 May 2018 10:58:30 +0300
Message-Id: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here is v2 with following comments addressed:

* reworked venus suspend 3xx and reuse it for 4xx.
* drop 10/28 patch from v1, i.e. call of session_continue when
  buffer requirements are not sufficient.
* fixed kbuild test robot warning in 11/28 by allocating instance
  variable from heap.
* spelling typo in 15/28.
* added Reviewed-by for DT changes.
* extended 28/28 HEVC support for encoder, now the profile and
  level are selected properly.

Comments are welcome!

regards,
Stan

Stanimir Varbanov (29):
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
  venus: venc,vdec: adds clocks needed for venus 4xx
  venus: add common capability parser
  venus: helpers: make a commmon function for power_enable
  venus: core: delete not used flag for buffer mode
  venus: helpers: rename a helper function and use buffer mode from caps
  venus: add a helper function to set dynamic buffer mode
  venus: add helper function to set actual buffer size
  venus: delete no longer used bufmode flag from instance
  venus: helpers: add buffer type argument to a helper
  venus: helpers: add a new helper to set raw format
  venus: helpers,vdec,venc: add helpers to set work mode and core usage
  venus: helpers: extend set_num_bufs helper with one more argument
  venus: helpers: add a helper to return opb buffer sizes
  venus: vdec: get required input buffers as well
  venus: vdec: new function for output configuration
  venus: move frame size calculations in common place
  venus: implementing multi-stream support
  venus: add sdm845 compatible and resource data
  venus: add HEVC codec support

 .../devicetree/bindings/media/qcom,venus.txt       |   1 +
 drivers/media/platform/qcom/venus/Makefile         |   3 +-
 drivers/media/platform/qcom/venus/core.c           | 107 ++++
 drivers/media/platform/qcom/venus/core.h           |  93 ++--
 drivers/media/platform/qcom/venus/helpers.c        | 558 +++++++++++++++++++--
 drivers/media/platform/qcom/venus/helpers.h        |  23 +-
 drivers/media/platform/qcom/venus/hfi.c            |  12 +-
 drivers/media/platform/qcom/venus/hfi.h            |   9 +
 drivers/media/platform/qcom/venus/hfi_cmds.c       |  64 ++-
 drivers/media/platform/qcom/venus/hfi_helper.h     | 112 ++++-
 drivers/media/platform/qcom/venus/hfi_msgs.c       | 401 +++------------
 drivers/media/platform/qcom/venus/hfi_parser.c     | 291 +++++++++++
 drivers/media/platform/qcom/venus/hfi_parser.h     |  45 ++
 drivers/media/platform/qcom/venus/hfi_venus.c      |  95 +++-
 drivers/media/platform/qcom/venus/hfi_venus_io.h   |  25 +
 drivers/media/platform/qcom/venus/vdec.c           | 316 +++++++-----
 drivers/media/platform/qcom/venus/venc.c           | 211 ++++----
 17 files changed, 1689 insertions(+), 677 deletions(-)
 create mode 100644 drivers/media/platform/qcom/venus/hfi_parser.c
 create mode 100644 drivers/media/platform/qcom/venus/hfi_parser.h

-- 
2.14.1
