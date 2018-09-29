Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52836 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbeI2S26 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 14:28:58 -0400
From: Srinu Gorle <sgorle@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        sgorle@codeaurora.org
Cc: acourbot@chromium.org, vgarodia@codeaurora.org
Subject: [PATCH v1 0/5] Venus - Decode reconfig sequence
Date: Sat, 29 Sep 2018 17:30:27 +0530
Message-Id: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The patch set mainly adds logic to handle multiresolution clips
for video decode. And also added few miscellaneous fixes.

The patch set is based on top of recent Venus updates - PIL v9 patches
posted by Vikash Garodia.
This patch series to align with https://patchwork.linuxtv.org/patch/52153/ 

Comments are welcome!

Regards,
Srinu Gorle

Srinu Gorle (5):
  media: venus: handle video decoder resolution change
  media: venus: dynamically configure codec type
  media: venus: do not destroy video session during queue setup
  media: venus: video decoder drop frames handling
  media: venus: update number of bytes used field properly for EOS
    frames

 drivers/media/platform/qcom/venus/helpers.c | 210 ++++++++++++++++++++--------
 drivers/media/platform/qcom/venus/helpers.h |   4 +
 drivers/media/platform/qcom/venus/hfi.c     |   8 +-
 drivers/media/platform/qcom/venus/hfi.h     |   2 +-
 drivers/media/platform/qcom/venus/vdec.c    | 114 +++++++++++++--
 drivers/media/platform/qcom/venus/venc.c    |  20 ++-
 6 files changed, 285 insertions(+), 73 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
