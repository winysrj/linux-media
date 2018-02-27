Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33184 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753995AbeB0PF6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 10:05:58 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: niklas.soderlund@ragnatech.se,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/3] media: i2c: adv748x: Simplify regmap configuration
Date: Tue, 27 Feb 2018 15:05:48 +0000
Message-Id: <1519743950-28346-2-git-send-email-kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <1519743950-28346-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1519743950-28346-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

The ADV748x has identical map configurations for each register map. The
duplication of each map can be simplified using a helper macro such that
each map is represented on a single line.

Define ADV748X_REGMAP_CONF for this purpose use it to create the tables.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

---
v2:
 - Remove unnecessary #undef

 drivers/media/i2c/adv748x/adv748x-core.c | 109 ++++++-------------------------
 1 file changed, 20 insertions(+), 89 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index fd92c9e4b519..faf73949962b 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -35,96 +35,27 @@
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
 
 static int adv748x_configure_regmap(struct adv748x_state *state, int region)
-- 
2.7.4
