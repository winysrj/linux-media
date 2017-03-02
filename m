Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:64652 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752109AbdCBQsW (ORCPT
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
Subject: [PATCH 25/26] isdn: eicon: mark divascapi incompatible with kasan
Date: Thu,  2 Mar 2017 17:38:33 +0100
Message-Id: <20170302163834.2273519-26-arnd@arndb.de>
In-Reply-To: <20170302163834.2273519-1-arnd@arndb.de>
References: <20170302163834.2273519-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIG_KASAN is enabled, we have several functions that use rather
large kernel stacks, e.g.

drivers/isdn/hardware/eicon/message.c: In function 'group_optimization':
drivers/isdn/hardware/eicon/message.c:14841:1: warning: the frame size of 864 bytes is larger than 500 bytes [-Wframe-larger-than=]
drivers/isdn/hardware/eicon/message.c: In function 'add_b1':
drivers/isdn/hardware/eicon/message.c:7925:1: warning: the frame size of 1008 bytes is larger than 500 bytes [-Wframe-larger-than=]
drivers/isdn/hardware/eicon/message.c: In function 'add_b23':
drivers/isdn/hardware/eicon/message.c:8551:1: warning: the frame size of 928 bytes is larger than 500 bytes [-Wframe-larger-than=]
drivers/isdn/hardware/eicon/message.c: In function 'sig_ind':
drivers/isdn/hardware/eicon/message.c:6113:1: warning: the frame size of 2112 bytes is larger than 500 bytes [-Wframe-larger-than=]

To be on the safe side, and to enable a lower frame size warning limit, let's
just mark this driver as broken when KASAN is in use. I have tried to reduce
the stack size as I did with dozens of other drivers, but failed to come up
with a good solution for this one.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/isdn/hardware/eicon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/isdn/hardware/eicon/Kconfig b/drivers/isdn/hardware/eicon/Kconfig
index 6082b6a5ced3..b64496062421 100644
--- a/drivers/isdn/hardware/eicon/Kconfig
+++ b/drivers/isdn/hardware/eicon/Kconfig
@@ -31,6 +31,7 @@ config ISDN_DIVAS_PRIPCI
 
 config ISDN_DIVAS_DIVACAPI
 	tristate "DIVA CAPI2.0 interface support"
+	depends on !KASAN || BROKEN
 	help
 	  You need this to provide the CAPI interface
 	  for DIVA Server cards.
-- 
2.9.0
