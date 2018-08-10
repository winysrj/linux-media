Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47206 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbeHJMNk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 08:13:40 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: linux-firmware@kernel.org, linux-arm-kernel@lists.infradead.org,
        mchehab@infradead.org, linux-media@vger.kernel.org
Cc: stanimir.varbanov@linaro.org, acourbot@google.com,
        linux-media-owner@vger.kernel.org
Subject: qcom: update firmware file for Venus on SDM845
Date: Fri, 10 Aug 2018 15:14:23 +0530
Message-Id: <1533894263-10692-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi,

This pull request updates firmware files for Venus h/w codec found on the Qualcomm SDM845 chipset.

The following changes since commit 7b5835fd37630d18ac0c755329172f6a17c1af29:

  linux-firmware: add firmware for mt76x2u (2018-07-30 07:20:31 -0400)

are available in the git repository at:

  https://github.com/vgarodia/venus_firmware_23 master

for you to fetch changes up to 6ae7a5bf57f035aecc7613943528e52ada7e1e03:

  qcom: update venus firmware files for v5.2 (2018-08-10 12:57:47 +0530)

----------------------------------------------------------------
Vikash Garodia (1):
      qcom: update venus firmware files for v5.2

 WHENCE                   |   2 +-
 qcom/venus-5.2/venus.b00 | Bin 212 -> 212 bytes
 qcom/venus-5.2/venus.b01 | Bin 6600 -> 6600 bytes
 qcom/venus-5.2/venus.b02 | Bin 819552 -> 837304 bytes
 qcom/venus-5.2/venus.b03 | Bin 33536 -> 33640 bytes
 qcom/venus-5.2/venus.mbn | Bin 865408 -> 883264 bytes
 qcom/venus-5.2/venus.mdt | Bin 6812 -> 6812 bytes
 7 files changed, 1 insertion(+), 1 deletion(-)
