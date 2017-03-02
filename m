Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:57083 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752574AbdCBQsW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 11:48:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: kasan-dev@googlegroups.com
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        kernel-build-reports@lists.linaro.org,
        "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 13/26] rtl8180: reduce stack size for KASAN
Date: Thu,  2 Mar 2017 17:38:21 +0100
Message-Id: <20170302163834.2273519-14-arnd@arndb.de>
In-Reply-To: <20170302163834.2273519-1-arnd@arndb.de>
References: <20170302163834.2273519-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIG_KASAN is set, we see overly large stack frames from inlining
functions with local variables:

drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c: In function 'rtl8225se_rf_init':
drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c:431:1: warning: the frame size of 4384 bytes is larger than 3072 bytes [-Wframe-larger-than=]

This marks them noinline_for_kasan.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c
index fde89866fa8d..1efa098a2e32 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c
@@ -174,14 +174,14 @@ static void rtl8187se_three_wire_io(struct ieee80211_hw *dev, u8 *data,
 	} while (0);
 }
 
-static u32 rtl8187se_rf_readreg(struct ieee80211_hw *dev, u8 addr)
+static noinline_for_kasan u32 rtl8187se_rf_readreg(struct ieee80211_hw *dev, u8 addr)
 {
 	u32 dataread = addr & 0x0F;
 	rtl8187se_three_wire_io(dev, (u8 *)&dataread, 16, 0);
 	return dataread;
 }
 
-static void rtl8187se_rf_writereg(struct ieee80211_hw *dev, u8 addr, u32 data)
+static noinline_for_kasan void rtl8187se_rf_writereg(struct ieee80211_hw *dev, u8 addr, u32 data)
 {
 	u32 outdata = (data << 4) | (u32)(addr & 0x0F);
 	rtl8187se_three_wire_io(dev, (u8 *)&outdata, 16, 1);
-- 
2.9.0
