Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41794 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965827AbeEYLDq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 07:03:46 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: linux-firmware@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, mchehab@infradead.org,
        linux-media@vger.kernel.org, stanimir.varbanov@linaro.org,
        vgarodia@codeaurora.org, acourbot@google.com
Subject: qcom: add firmware file for Venus on SDM845
Date: Fri, 25 May 2018 16:33:29 +0530
Message-Id: <1527246209-26685-2-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1527246209-26685-1-git-send-email-vgarodia@codeaurora.org>
References: <1527246209-26685-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request adds firmware files for Venus h/w codec found on the Qualcomm SDM845 chipset.

The following changes since commit 2a9b2cf50fb32e36e4fc1586c2f6f1421913b553:

  Merge branch 'for-upstreaming-v1.7.2' of https://github.com/felix-cavium/linux-firmware (2018-05-18 08:35:22 -0400)

are available in the git repository at:


  https://github.com/vgarodia/linux-firmware master

for you to fetch changes up to d6088b9c9d7f49d3c6c43681190889eca0abdcce:

  qcom: add venus firmware files for v5.2 (2018-05-25 15:16:43 +0530)

----------------------------------------------------------------
Vikash Garodia (1):
      qcom: add venus firmware files for v5.2

 WHENCE                   |   9 +++++++++
 qcom/venus-5.2/venus.b00 | Bin 0 -> 212 bytes
 qcom/venus-5.2/venus.b01 | Bin 0 -> 6600 bytes
 qcom/venus-5.2/venus.b02 | Bin 0 -> 819552 bytes
 qcom/venus-5.2/venus.b03 | Bin 0 -> 33536 bytes
 qcom/venus-5.2/venus.b04 |   1 +
 qcom/venus-5.2/venus.mbn | Bin 0 -> 865408 bytes
 qcom/venus-5.2/venus.mdt | Bin 0 -> 6812 bytes
 8 files changed, 10 insertions(+)
 create mode 100644 qcom/venus-5.2/venus.b00
 create mode 100644 qcom/venus-5.2/venus.b01
 create mode 100644 qcom/venus-5.2/venus.b02
 create mode 100644 qcom/venus-5.2/venus.b03
 create mode 100644 qcom/venus-5.2/venus.b04
 create mode 100644 qcom/venus-5.2/venus.mbn
 create mode 100644 qcom/venus-5.2/venus.mdt
