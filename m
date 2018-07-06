Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:57912 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932995AbeGFNS1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jul 2018 09:18:27 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] Venus updates
Message-ID: <c4a1d51e-a2f9-a54a-2329-5e209596c542@xs4all.nl>
Date: Fri, 6 Jul 2018 15:18:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Venus driver updates:

* add initial support for Venus version 4xx (found on sdm845).

* introduce a common capability parser to enumerate better
  supported uncompressed formats, capabilities by codec,
  supported codecs and so on.

* also contains various cleanups, readability improvements
  and fixes.

* adds HEVC codec support for the Venus versions which has
  support for it.

* add multi-stream support (secondary decoder output), which
  will give as an opportunity to use UBWC compressed formats
  to optimize internal interconnect bandwidth on higher
  resolutions.

Regards,

	Hans


The following changes since commit 666e994aa2278e948e2492ee9d81b4df241e7222:

  media: platform: s5p-mfc: simplify getting .drvdata (2018-07-04 11:45:40 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git venus

for you to fetch changes up to ed2a7f1012a41533483c8a72644d71cc7ecf0eab:

  venus: add HEVC codec support (2018-07-06 15:10:51 +0200)

----------------------------------------------------------------
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
      venus: core, helpers: add two more clocks found in Venus 4xx
      venus: hfi_parser: add common capability parser
      venus: helpers: rename a helper function and use buffer mode from caps
      venus: helpers: add a helper function to set dynamic buffer mode
      venus: helpers: add helper function to set actual buffer size
      venus: core: delete not used buffer mode flags
      venus: helpers: add buffer type argument to a helper
      venus: helpers: add a new helper to set raw format
      venus: helpers, vdec, venc: add helpers to set work mode and core usage
      venus: helpers: extend set_num_bufs helper with one more argument
      venus: helpers: add a helper to return opb buffer sizes
      venus: vdec: get required input buffers as well
      venus: vdec: a new function for output configuration
      venus: helpers: move frame size calculations on common place
      venus: implementing multi-stream support
      venus: core: add sdm845 DT compatible and resource data
      venus: add HEVC codec support

 Documentation/devicetree/bindings/media/qcom,venus.txt |   1 +
 drivers/media/platform/qcom/venus/Makefile             |   3 +-
 drivers/media/platform/qcom/venus/core.c               | 107 +++++++++
 drivers/media/platform/qcom/venus/core.h               | 100 ++++++---
 drivers/media/platform/qcom/venus/helpers.c            | 568 +++++++++++++++++++++++++++++++++++++++++++-----
 drivers/media/platform/qcom/venus/helpers.h            |  23 +-
 drivers/media/platform/qcom/venus/hfi.c                |  12 +-
 drivers/media/platform/qcom/venus/hfi.h                |  10 +
 drivers/media/platform/qcom/venus/hfi_cmds.c           |  62 +++++-
 drivers/media/platform/qcom/venus/hfi_helper.h         | 112 ++++++++--
 drivers/media/platform/qcom/venus/hfi_msgs.c           | 407 ++++++----------------------------
 drivers/media/platform/qcom/venus/hfi_parser.c         | 278 ++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_parser.h         | 110 ++++++++++
 drivers/media/platform/qcom/venus/hfi_venus.c          | 108 ++++++---
 drivers/media/platform/qcom/venus/hfi_venus_io.h       |  10 +
 drivers/media/platform/qcom/venus/vdec.c               | 326 ++++++++++++++++-----------
 drivers/media/platform/qcom/venus/venc.c               | 220 +++++++++++--------
 17 files changed, 1767 insertions(+), 690 deletions(-)
 create mode 100644 drivers/media/platform/qcom/venus/hfi_parser.c
 create mode 100644 drivers/media/platform/qcom/venus/hfi_parser.h
