Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47214 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbeJHUov (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2018 16:44:51 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
Subject: [PATCH v11 0/5] Venus updates - PIL
Date: Mon,  8 Oct 2018 19:02:47 +0530
Message-Id: <1539005572-803-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This version of the series
* extends the description of firmware subnode in documentation.
* renames the flag suggesting the presence of tz and update code
  accordingly.

Stanimir Varbanov (1):
  venus: firmware: register separate platform_device for firmware loader

Vikash Garodia (4):
  venus: firmware: add routine to reset ARM9
  venus: firmware: move load firmware in a separate function
  venus: firmware: add no TZ boot and shutdown routine
  dt-bindings: media: Document bindings for venus firmware device

 .../devicetree/bindings/media/qcom,venus.txt       |  14 +-
 drivers/media/platform/qcom/venus/core.c           |  24 ++-
 drivers/media/platform/qcom/venus/core.h           |   6 +
 drivers/media/platform/qcom/venus/firmware.c       | 235 +++++++++++++++++++--
 drivers/media/platform/qcom/venus/firmware.h       |  17 +-
 drivers/media/platform/qcom/venus/hfi_venus.c      |  13 +-
 drivers/media/platform/qcom/venus/hfi_venus_io.h   |   8 +
 7 files changed, 274 insertions(+), 43 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
