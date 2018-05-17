Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59126 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751274AbeEQLci (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 07:32:38 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: hverkuil@xs4all.nl, mchehab@kernel.org, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, stanimir.varbanov@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        acourbot@google.com, Vikash Garodia <vgarodia@codeaurora.org>
Subject: [PATCH 0/4] Venus updates - PIL 
Date: Thu, 17 May 2018 17:02:16 +0530
Message-Id: <1526556740-25494-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The patch set mainly adds PIL functionality in video driver. 
There are boards with qcom video hardware but does not have
trustzone. For such boards, the PIL added now will load the
video firmware and reset the ARM9.

The patch set is based on top of recent venus updates v2 patches
posted by Stanimir Varbanov.

Comments are welcome!

regards,
Vikash

Vikash Garodia (4):
  soc: qcom: mdt_loader: Add check to make scm calls
  media: venus: add a routine to reset ARM9
  venus: add check to make scm calls
  media: venus: add PIL support

 .../devicetree/bindings/media/qcom,venus.txt       |   8 +-
 drivers/media/platform/qcom/venus/core.c           |  67 +++++++-
 drivers/media/platform/qcom/venus/core.h           |   6 +
 drivers/media/platform/qcom/venus/firmware.c       | 189 ++++++++++++++++++---
 drivers/media/platform/qcom/venus/firmware.h       |  11 +-
 drivers/media/platform/qcom/venus/hfi_venus.c      |  26 ++-
 drivers/media/platform/qcom/venus/hfi_venus_io.h   |   5 +
 drivers/soc/qcom/mdt_loader.c                      |  21 ++-
 8 files changed, 281 insertions(+), 52 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
