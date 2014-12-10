Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40812 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933376AbaLJVQk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 16:16:40 -0500
Received: from lanttu.localdomain (lanttu.localdomain [192.168.5.64])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id A63B4600A2
	for <linux-media@vger.kernel.org>; Wed, 10 Dec 2014 23:16:35 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 7/7] smiapp: Add parentheses to macro arguments used in macros
Date: Wed, 10 Dec 2014 23:16:20 +0200
Message-Id: <1418246180-667-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1418246180-667-1-git-send-email-sakari.ailus@iki.fi>
References: <1418246180-667-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes the macros a little bit safer.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-quirk.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.h b/drivers/media/i2c/smiapp/smiapp-quirk.h
index a24eb43..dac5566 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.h
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.h
@@ -72,14 +72,14 @@ void smiapp_replace_limit(struct smiapp_sensor *sensor,
 		.val = _val,		\
 	}
 
-#define smiapp_call_quirk(_sensor, _quirk, ...)				\
-	(_sensor->minfo.quirk &&					\
-	 _sensor->minfo.quirk->_quirk ?					\
-	 _sensor->minfo.quirk->_quirk(_sensor, ##__VA_ARGS__) : 0)
+#define smiapp_call_quirk(sensor, _quirk, ...)				\
+	((sensor)->minfo.quirk &&					\
+	 (sensor)->minfo.quirk->_quirk ?				\
+	 (sensor)->minfo.quirk->_quirk(sensor, ##__VA_ARGS__) : 0)
 
-#define smiapp_needs_quirk(_sensor, _quirk)		\
-	(_sensor->minfo.quirk ?				\
-	 _sensor->minfo.quirk->flags & _quirk : 0)
+#define smiapp_needs_quirk(sensor, _quirk)		\
+	((sensor)->minfo.quirk ?			\
+	 (sensor)->minfo.quirk->flags & _quirk : 0)
 
 extern const struct smiapp_quirk smiapp_jt8ev1_quirk;
 extern const struct smiapp_quirk smiapp_imx125es_quirk;
-- 
1.7.10.4

