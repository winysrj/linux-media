Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn3nam01on0113.outbound.protection.outlook.com ([104.47.33.113]:45285
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752077AbdDNCqM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 22:46:12 -0400
From: <Yasunari.Takiguchi@sony.com>
To: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-media@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>,
        Hideki Nozawa <Hideki.Nozawa@sony.com>,
        "Kota Yonezawa" <Kota.Yonezawa@sony.com>,
        Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>,
        Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
Subject: [PATCH v2 15/15] [media] cxd2880 : Update MAINTAINERS file for CXD2880 driver
Date: Fri, 14 Apr 2017 11:48:42 +0900
Message-ID: <20170414024842.18477-1-Yasunari.Takiguchi@sony.com>
In-Reply-To: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
References: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

This is MAINTAINERS file update about the driver for
the Sony CXD2880 DVB-T2/T tuner + demodulator.

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fdd5350fe261..62543a76d6bf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8042,6 +8042,15 @@ T:	git git://linuxtv.org/media_tree.git
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
2.11.0
