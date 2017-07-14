Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:49181 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753522AbdGNJda (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:33:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        Arnd Bergmann <arnd@arndb.de>, nouveau@lists.freedesktop.org
Subject: [PATCH 12/14] drm/nouveau/clk: fix gcc-7 -Wint-in-bool-context warning
Date: Fri, 14 Jul 2017 11:31:05 +0200
Message-Id: <20170714093129.1366900-3-arnd@arndb.de>
In-Reply-To: <20170714092540.1217397-1-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gcc thinks that interpreting a multiplication result as a bool
is confusing:

drivers/gpu/drm/nouveau/nvkm/subdev/clk/gt215.c: In function 'read_pll':
drivers/gpu/drm/nouveau/nvkm/subdev/clk/gt215.c:133:8: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]

In this instance, I think using multiplication is more intuitive
than '&&', so I'm adding a comparison to zero instead to shut up
the warning. To further improve readability, I also make the
error case indented and leave the normal case as the final 'return'
statement.

Fixes: 7632b30e4b8b ("drm/nouveau/clk: namespace + nvidia gpu names (no binary change)")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/gt215.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/gt215.c b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/gt215.c
index 96e0941c8edd..04b4f4ccf186 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/gt215.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/gt215.c
@@ -130,10 +130,10 @@ read_pll(struct gt215_clk *clk, int idx, u32 pll)
 		sclk = read_clk(clk, 0x10 + idx, false);
 	}
 
-	if (M * P)
-		return sclk * N / (M * P);
+	if (M * P == 0)
+		return 0;
 
-	return 0;
+	return sclk * N / (M * P);
 }
 
 static int
-- 
2.9.0
