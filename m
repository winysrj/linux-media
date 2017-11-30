Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:56146 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750771AbdK3LKF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 06:10:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH, RESEND 2/2] r820t: fix r820t_write_reg for KASAN
Date: Thu, 30 Nov 2017 12:08:05 +0100
Message-Id: <20171130110939.1140969-2-arnd@arndb.de>
In-Reply-To: <20171130110939.1140969-1-arnd@arndb.de>
References: <20171130110939.1140969-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With CONFIG_KASAN, we get an overly long stack frame due to inlining
the register access functions:

drivers/media/tuners/r820t.c: In function 'generic_set_freq.isra.7':
drivers/media/tuners/r820t.c:1334:1: error: the frame size of 2880 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]

This is caused by a gcc bug that has now been fixed in gcc-8.
To work around the problem, we can pass the register data
through a local variable that older gcc versions can optimize
out as well.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81715
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/tuners/r820t.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index ba80376a3b86..d097eb04a0e9 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -396,9 +396,11 @@ static int r820t_write(struct r820t_priv *priv, u8 reg, const u8 *val,
 	return 0;
 }
 
-static int r820t_write_reg(struct r820t_priv *priv, u8 reg, u8 val)
+static inline int r820t_write_reg(struct r820t_priv *priv, u8 reg, u8 val)
 {
-	return r820t_write(priv, reg, &val, 1);
+	u8 tmp = val; /* work around GCC PR81715 with asan-stack=1 */
+
+	return r820t_write(priv, reg, &tmp, 1);
 }
 
 static int r820t_read_cache_reg(struct r820t_priv *priv, int reg)
@@ -411,17 +413,18 @@ static int r820t_read_cache_reg(struct r820t_priv *priv, int reg)
 		return -EINVAL;
 }
 
-static int r820t_write_reg_mask(struct r820t_priv *priv, u8 reg, u8 val,
+static inline int r820t_write_reg_mask(struct r820t_priv *priv, u8 reg, u8 val,
 				u8 bit_mask)
 {
+	u8 tmp = val;
 	int rc = r820t_read_cache_reg(priv, reg);
 
 	if (rc < 0)
 		return rc;
 
-	val = (rc & ~bit_mask) | (val & bit_mask);
+	tmp = (rc & ~bit_mask) | (tmp & bit_mask);
 
-	return r820t_write(priv, reg, &val, 1);
+	return r820t_write(priv, reg, &tmp, 1);
 }
 
 static int r820t_read(struct r820t_priv *priv, u8 reg, u8 *val, int len)
-- 
2.9.0
