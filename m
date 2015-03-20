Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbbCTNhn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 09:37:43 -0400
Subject: [PATCH] m88ts2022: Nested loops shouldn't use the same index
 variable
From: David Howells <dhowells@redhat.com>
To: crope@iki.fi
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Date: Fri, 20 Mar 2015 13:37:38 +0000
Message-ID: <20150320133738.19894.45270.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a pair of nested loops inside m88ts2022_cmd() that use the same
index variable, but for different things.  Split the variable.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/media/tuners/m88ts2022.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
index 066e543..cdf9fe5 100644
--- a/drivers/media/tuners/m88ts2022.c
+++ b/drivers/media/tuners/m88ts2022.c
@@ -21,7 +21,7 @@
 static int m88ts2022_cmd(struct m88ts2022_dev *dev, int op, int sleep, u8 reg,
 		u8 mask, u8 val, u8 *reg_val)
 {
-	int ret, i;
+	int ret, i, j;
 	unsigned int utmp;
 	struct m88ts2022_reg_val reg_vals[] = {
 		{0x51, 0x1f - op},
@@ -35,9 +35,9 @@ static int m88ts2022_cmd(struct m88ts2022_dev *dev, int op, int sleep, u8 reg,
 				"i=%d op=%02x reg=%02x mask=%02x val=%02x\n",
 				i, op, reg, mask, val);
 
-		for (i = 0; i < ARRAY_SIZE(reg_vals); i++) {
-			ret = regmap_write(dev->regmap, reg_vals[i].reg,
-					reg_vals[i].val);
+		for (j = 0; j < ARRAY_SIZE(reg_vals); j++) {
+			ret = regmap_write(dev->regmap, reg_vals[j].reg,
+					reg_vals[j].val);
 			if (ret)
 				goto err;
 		}

