Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:43013 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935190AbeFMPIl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 11:08:41 -0400
Received: by mail-wr0-f195.google.com with SMTP id d2-v6so3125378wrm.10
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2018 08:08:41 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v3 00/27] Venus updates
Date: Wed, 13 Jun 2018 18:07:34 +0300
Message-Id: <20180613150801.11702-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is a new version of the patch-set which addressing most of review
comments made by Tomasz. The changes are:

* added Reviewed-by tags
* in 02/29 dropped vcodec noc error registers for now,
* in 03/29 added a comment for new properties and drop entropy_mode local
  variable.
* in 04/29 drop ret local variable and call pkt_session_set_property_3xx
  directly from switch default.
* in 07/29 added defines for register bits.
* in 08/29 added venus_cpu_and_video_core_idle and
  venus_cpu_idle_and_pc_ready and use readx_poll_timeout.
* squashed v2's 11/29 and 13/29 and reworked error handling in vdec/venc
  suspend/resume
* in 12/29 
  - switched to for_each_set_bit when init codecs capability structure
  - added a define for MAX_ALLOC_MODE_ENTRIES, now
  - fill profile/level capabilities in capabilities structure.
  - announce data argument as const in callback function.
  - dropped some not needed loops.
* squashed v2's 14/29 and 18/29
* in 15/29 make is_dynamic_bufmode bool and drop inline.

v2 can found at https://lkml.org/lkml/2018/5/15/190

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
