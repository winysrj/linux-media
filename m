Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn3nam01on0116.outbound.protection.outlook.com ([104.47.33.116]:45152
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753041AbeDZGcE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 02:32:04 -0400
From: <Yasunari.Takiguchi@sony.com>
To: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        <Yasunari.Takiguchi@sony.com>, <Masayuki.Yamamoto@sony.com>,
        <Hideki.Nozawa@sony.com>, <Kota.Yonezawa@sony.com>,
        <Toshihiko.Matsumoto@sony.com>, <Satoshi.C.Watanabe@sony.com>
Subject: [PATCH 0/3] [media] cxd2880: modified structure declaration and optimized the driver 
Date: Thu, 26 Apr 2018 15:36:35 +0900
Message-ID: <20180426063635.31923-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

Hi,

This is the update patch for patch Sony CXD2880 DVB-T2/T tuner + 
demodulator driver.

We modified how to declare structure and
optimized spi drive current and 
signal lock condition check part for BER/PER measure
to ensure BER/PER are stable.

The change history of this patch series is as below.

[Change list]
(1)The detail change items of each files are as below.
    [PATCH 1/3]
       drivers/media/spi/cxd2880-spi.c
         -modified how to declare spi_transfer structure

    [PATCH 2/3]
       drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
         -reduced the SPI output drive current
         -optimized signal lock condition check part for BER/PER measure
          to ensure BER/PER are stable

    [PATCH 3/3]
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
          -updated version information

Thanks,
Takiguchi
---
 drivers/media/spi/cxd2880-spi.c                                     | 8 +++-----
 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c                   | 14 ++++++++++++--
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h | 4 ++--

 3 files changed, 17 insertions(+), 9 deletions(-)

2.15.1
