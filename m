Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:51724 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbdCBQsW (ORCPT
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
Subject: [PATCH 17/26] [media] i2c: ks0127: reduce stack frame size for KASAN
Date: Thu,  2 Mar 2017 17:38:25 +0100
Message-Id: <20170302163834.2273519-18-arnd@arndb.de>
In-Reply-To: <20170302163834.2273519-1-arnd@arndb.de>
References: <20170302163834.2273519-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIG_KASAN is set, inlining of functions with local variables
causes excessive stack usage:

drivers/media/i2c/ks0127.c: In function 'ks0127_s_routing':
drivers/media/i2c/ks0127.c:541:1: error: the frame size of 3136 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]

Marking one functions as noinline_for_kasan solves the problem in this
driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/ks0127.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ks0127.c b/drivers/media/i2c/ks0127.c
index ab536c4a7115..eb2fccdc0602 100644
--- a/drivers/media/i2c/ks0127.c
+++ b/drivers/media/i2c/ks0127.c
@@ -349,7 +349,7 @@ static void ks0127_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 
 
 /* generic bit-twiddling */
-static void ks0127_and_or(struct v4l2_subdev *sd, u8 reg, u8 and_v, u8 or_v)
+static noinline_for_kasan void ks0127_and_or(struct v4l2_subdev *sd, u8 reg, u8 and_v, u8 or_v)
 {
 	struct ks0127 *ks = to_ks0127(sd);
 
-- 
2.9.0
