Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:63388 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753074AbdCBQsW (ORCPT
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
Subject: [PATCH 21/26] drm/bridge: ps8622: reduce stack size for KASAN
Date: Thu,  2 Mar 2017 17:38:29 +0100
Message-Id: <20170302163834.2273519-22-arnd@arndb.de>
In-Reply-To: <20170302163834.2273519-1-arnd@arndb.de>
References: <20170302163834.2273519-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIG_KASAN is set, each call to ps8622_set() adds an object to the
stack frame, leading to a warning about possible stack overflow:

drivers/gpu/drm/bridge/parade-ps8622.c: In function 'ps8622_send_config':
drivers/gpu/drm/bridge/parade-ps8622.c:338:1: error: the frame size of 5872 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]

Marking this as noinline_for_kasan completely avoids the problem.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/gpu/drm/bridge/parade-ps8622.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/parade-ps8622.c b/drivers/gpu/drm/bridge/parade-ps8622.c
index ac8cc5b50d9f..6b995edd2a46 100644
--- a/drivers/gpu/drm/bridge/parade-ps8622.c
+++ b/drivers/gpu/drm/bridge/parade-ps8622.c
@@ -79,7 +79,7 @@ static inline struct ps8622_bridge *
 	return container_of(connector, struct ps8622_bridge, connector);
 }
 
-static int ps8622_set(struct i2c_client *client, u8 page, u8 reg, u8 val)
+static noinline_for_kasan int ps8622_set(struct i2c_client *client, u8 page, u8 reg, u8 val)
 {
 	int ret;
 	struct i2c_adapter *adap = client->adapter;
-- 
2.9.0
