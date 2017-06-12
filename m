Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:35893 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754194AbdFLQae (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 12:30:34 -0400
Received: by mail-lf0-f43.google.com with SMTP id o83so53507366lff.3
        for <linux-media@vger.kernel.org>; Mon, 12 Jun 2017 09:30:34 -0700 (PDT)
To: linux-firmware@kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [GIT PULL] linux-firmware: Add Qualcomm Venus firmware
Message-ID: <bea5851d-d634-d405-a8f6-6facaca09c03@linaro.org>
Date: Mon, 12 Jun 2017 19:30:30 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This pull request adds firmware for venus video codec driver.

The following changes since commit 37857004a430e96dc837db7f967b6d0279053de8:

  linux-firmware: add firmware image for Redpine 9113 chipset
(2017-06-01 10:22:17 -0700)

are available in the git repository at:

  https://github.com/svarbanov/linux-firmware.git

for you to fetch changes up to 70c8af0291f81a39b411f7f125ec413f00073e5f:

  qcom: add venus firmware files for v1.8 (2017-06-12 17:09:27 +0300)

----------------------------------------------------------------
Stanimir Varbanov (1):
      qcom: add venus firmware files for v1.8

 LICENSE.qcom             | 206 +++++++++++++++++++
 WHENCE                   |  18 ++
 qcom/NOTICE.txt          | 506
+++++++++++++++++++++++++++++++++++++++++++++++
 qcom/venus-1.8/venus.b00 | Bin 0 -> 212 bytes
 qcom/venus-1.8/venus.b01 | Bin 0 -> 6600 bytes
 qcom/venus-1.8/venus.b02 | Bin 0 -> 975088 bytes
 qcom/venus-1.8/venus.b03 | Bin 0 -> 5568 bytes
 qcom/venus-1.8/venus.b04 |   1 +
 qcom/venus-1.8/venus.mdt | Bin 0 -> 6812 bytes
 9 files changed, 731 insertions(+)
 create mode 100644 LICENSE.qcom
 create mode 100644 qcom/NOTICE.txt
 create mode 100644 qcom/venus-1.8/venus.b00
 create mode 100644 qcom/venus-1.8/venus.b01
 create mode 100644 qcom/venus-1.8/venus.b02
 create mode 100644 qcom/venus-1.8/venus.b03
 create mode 100644 qcom/venus-1.8/venus.b04
 create mode 100644 qcom/venus-1.8/venus.mdt

-- 
regards,
Stan
