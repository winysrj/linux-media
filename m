Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36950 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751265AbdGQI6C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 04:58:02 -0400
Received: by mail-wm0-f47.google.com with SMTP id b134so40588366wma.0
        for <linux-media@vger.kernel.org>; Mon, 17 Jul 2017 01:58:01 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 0/4] Venus fixes for v4.13-rc1
Date: Mon, 17 Jul 2017 11:56:46 +0300
Message-Id: <20170717085650.12185-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here is a collection of fixes for the issues found so far. The
patches 1/4, 3/4 and 4/4 has been already sent to the linux-media.
2/4 is a reworked version of [1], which has been sent
from Arnd, but the change was not correct, so please review it.

Arnd Bergmann (2):
  venus: mark PM functions as __maybe_unused
  venus: fix compile-test build on non-qcom ARM platform

Rob Clark (1):
  media: venus: hfi: fix error handling in hfi_sys_init_done()

Stanimir Varbanov (1):
  media: venus: don't abuse dma_alloc for non-DMA allocations

 drivers/media/platform/Kconfig               |  4 +-
 drivers/media/platform/qcom/venus/core.c     | 16 +++---
 drivers/media/platform/qcom/venus/core.h     |  1 -
 drivers/media/platform/qcom/venus/firmware.c | 76 ++++++++++++----------------
 drivers/media/platform/qcom/venus/firmware.h |  5 +-
 drivers/media/platform/qcom/venus/hfi_msgs.c | 11 ++--
 6 files changed, 50 insertions(+), 63 deletions(-)

[1] https://lkml.org/lkml/2017/6/27/664

-- 
2.11.0
