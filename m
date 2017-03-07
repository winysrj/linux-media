Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0115.outbound.protection.outlook.com ([104.47.34.115]:63488
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754633AbdCGBYk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 20:24:40 -0500
From: <Yasunari.Takiguchi@sony.com>
To: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>,
        Hideki Nozawa <Hideki.Nozawa@sony.com>,
        "Kota Yonezawa" <Kota.Yonezawa@sony.com>,
        Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>,
        Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
Subject: [RFC PATCH 5/5] media: Update MAINTAINERS file for Sony CXD2880 DVB-T2/T tuner + demodulator
Date: Tue, 7 Mar 2017 10:11:28 +0900
Message-ID: <1488849088-8637-1-git-send-email-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

This is the driver for Sony CXD2880 DVB-T2/T tuner + demodulator.

Regarding this third Beta Release, the status is:
- Tested on Raspberry Pi 3.
- The DVB-API operates under dvbv5 tools.

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---
 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c265a5f..fe86728 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8034,6 +8034,15 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Supported
 F:	drivers/media/dvb-frontends/cxd2841er*
 
+MEDIA DRIVERS FOR CXD2880
+M:	Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+T:	git git://linuxtv.org/media_tree.git
+S:	Supported
+F:	drivers/media/dvb-frontends/cxd2880/*
+F:	drivers/media/spi/cxd2880*
+
 MEDIA DRIVERS FOR HORUS3A
 M:	Sergey Kozlov <serjk@netup.ru>
 M:	Abylay Ospan <aospan@netup.ru>
-- 
1.7.9.5
