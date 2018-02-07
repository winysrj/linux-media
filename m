Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753721AbeBGRfH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 12:35:07 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] media: i2c: adv748x: Simplify regmap configuration
Date: Wed,  7 Feb 2018 17:34:45 +0000
Message-Id: <1518024886-842-2-git-send-email-kbingham@kernel.org>
In-Reply-To: <1518024886-842-1-git-send-email-kbingham@kernel.org>
References: <1518024886-842-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The ADV748x has identical map configurations for each register map. The
duplication of each map can be simplified using a helper macro such that
each map is represented on a single line.

Define ADV748X_REGMAP_CONF for this purpose and un-define after it's
use.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 111 ++++++-------------------------
 1 file changed, 22 insertions(+), 89 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index fd92c9e4b519..71c69b816db2 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -35,98 +35,31 @@
  * Register manipulation
  */
 
-static const struct regmap_config adv748x_regmap_cnf[] = {
-	{
-		.name			= "io",
-		.reg_bits		= 8,
-		.val_bits		= 8,
-
-		.max_register		= 0xff,
-		.cache_type		= REGCACHE_NONE,
-	},
-	{
-		.name			= "dpll",
-		.reg_bits		= 8,
-		.val_bits		= 8,
-
-		.max_register		= 0xff,
-		.cache_type		= REGCACHE_NONE,
-	},
-	{
-		.name			= "cp",
-		.reg_bits		= 8,
-		.val_bits		= 8,
-
-		.max_register		= 0xff,
-		.cache_type		= REGCACHE_NONE,
-	},
-	{
-		.name			= "hdmi",
-		.reg_bits		= 8,
-		.val_bits		= 8,
-
-		.max_register		= 0xff,
-		.cache_type		= REGCACHE_NONE,
-	},
-	{
-		.name			= "edid",
-		.reg_bits		= 8,
-		.val_bits		= 8,
-
-		.max_register		= 0xff,
-		.cache_type		= REGCACHE_NONE,
-	},
-	{
-		.name			= "repeater",
-		.reg_bits		= 8,
-		.val_bits		= 8,
-
-		.max_register		= 0xff,
-		.cache_type		= REGCACHE_NONE,
-	},
-	{
-		.name			= "infoframe",
-		.reg_bits		= 8,
-		.val_bits		= 8,
-
-		.max_register		= 0xff,
-		.cache_type		= REGCACHE_NONE,
-	},
-	{
-		.name			= "cec",
-		.reg_bits		= 8,
-		.val_bits		= 8,
-
-		.max_register		= 0xff,
-		.cache_type		= REGCACHE_NONE,
-	},
-	{
-		.name			= "sdp",
-		.reg_bits		= 8,
-		.val_bits		= 8,
-
-		.max_register		= 0xff,
-		.cache_type		= REGCACHE_NONE,
-	},
-
-	{
-		.name			= "txb",
-		.reg_bits		= 8,
-		.val_bits		= 8,
-
-		.max_register		= 0xff,
-		.cache_type		= REGCACHE_NONE,
-	},
-	{
-		.name			= "txa",
-		.reg_bits		= 8,
-		.val_bits		= 8,
+#define ADV748X_REGMAP_CONF(n) \
+{ \
+	.name = n, \
+	.reg_bits = 8, \
+	.val_bits = 8, \
+	.max_register = 0xff, \
+	.cache_type = REGCACHE_NONE, \
+}
 
-		.max_register		= 0xff,
-		.cache_type		= REGCACHE_NONE,
-	},
+static const struct regmap_config adv748x_regmap_cnf[] = {
+	ADV748X_REGMAP_CONF("io"),
+	ADV748X_REGMAP_CONF("dpll"),
+	ADV748X_REGMAP_CONF("cp"),
+	ADV748X_REGMAP_CONF("hdmi"),
+	ADV748X_REGMAP_CONF("edid"),
+	ADV748X_REGMAP_CONF("repeater"),
+	ADV748X_REGMAP_CONF("infoframe"),
+	ADV748X_REGMAP_CONF("cec"),
+	ADV748X_REGMAP_CONF("sdp"),
+	ADV748X_REGMAP_CONF("txa"),
+	ADV748X_REGMAP_CONF("txb"),
 };
 
+#undef ADV748X_REGMAP_CONF
+
 static int adv748x_configure_regmap(struct adv748x_state *state, int region)
 {
 	int err;
-- 
2.7.4
