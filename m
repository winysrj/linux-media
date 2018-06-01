Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53032 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752572AbeFAU0h (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 16:26:37 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: hverkuil@xs4all.nl, mchehab@kernel.org, robh@kernel.org,
        mark.rutland@arm.com, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, stanimir.varbanov@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, vgarodia@codeaurora.org,
        acourbot@chromium.org
Subject: [PATCH v2 0/5] Venus updates - PIL 
Date: Sat,  2 Jun 2018 01:56:03 +0530
Message-Id: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here is v2 with following comments addressed:

* drop 1/4 patch from v1 and use relevant api to load
  firmware without PAS.
* add some details on ARM9 role in video hardware.
* abstract scm calls to set hardware state.
* remove setting aperture range for firmware and vcodec
  context banks.
* add misc code review comments related to return
  handling, unwanted cast, etc.

Comments are welcome!

Vikash Garodia (5):
  media: venus: add a routine to reset ARM9
  media: venus: add a routine to set venus state
  venus: add check to make scm calls
  media: venus: add no TZ boot and shutdown routine
  venus: register separate driver for firmware device

 .../devicetree/bindings/media/qcom,venus.txt       |   8 +-
 drivers/media/platform/qcom/venus/core.c           |  58 +++++-
 drivers/media/platform/qcom/venus/core.h           |  10 +
 drivers/media/platform/qcom/venus/firmware.c       | 217 ++++++++++++++++++---
 drivers/media/platform/qcom/venus/firmware.h       |  12 +-
 drivers/media/platform/qcom/venus/hfi_venus.c      |  13 +-
 drivers/media/platform/qcom/venus/hfi_venus_io.h   |   5 +
 7 files changed, 275 insertions(+), 48 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
