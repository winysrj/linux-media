Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0123.outbound.protection.outlook.com ([104.47.32.123]:10540
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753872AbeDZGiT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 02:38:19 -0400
From: <Yasunari.Takiguchi@sony.com>
To: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        <Yasunari.Takiguchi@sony.com>, <Masayuki.Yamamoto@sony.com>,
        <Hideki.Nozawa@sony.com>, <Kota.Yonezawa@sony.com>,
        <Toshihiko.Matsumoto@sony.com>, <Satoshi.C.Watanabe@sony.com>
Subject: [PATCH 3/3] [media] cxd2880: Changed version information
Date: Thu, 26 Apr 2018 15:42:52 +0900
Message-ID: <20180426064252.32253-1-Yasunari.Takiguchi@sony.com>
In-Reply-To: <20180426063635.31923-1-Yasunari.Takiguchi@sony.com>
References: <20180426063635.31923-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

This is the version update for this cxd2880 driver changing. 

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---

[Change list]
    drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
       -updated version information

 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
index fab55038b37b..c6d6c8dd16a1 100644
--- a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
@@ -7,6 +7,6 @@
  * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
  */
 
-#define CXD2880_TNRDMD_DRIVER_VERSION "1.4.1 - 1.0.4"
+#define CXD2880_TNRDMD_DRIVER_VERSION "1.4.1 - 1.0.5"
 
-#define CXD2880_TNRDMD_DRIVER_RELEASE_DATE "2018-01-17"
+#define CXD2880_TNRDMD_DRIVER_RELEASE_DATE "2018-04-25"
-- 
2.15.1
