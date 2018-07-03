Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54260 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752863AbeGCNyu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Jul 2018 09:54:50 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 43BF6634C83
        for <linux-media@vger.kernel.org>; Tue,  3 Jul 2018 16:54:43 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] smiapp: Set correct MODULE_LICENSE
Date: Tue,  3 Jul 2018 16:54:39 +0300
Message-Id: <20180703135439.11342-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The smiapp driver is licensed under GNU GPL v2 only, as stated by the
header. Reflect this in the MODULE_LICENSE macro.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e9e0f21efc2a..f2daad49ff18 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -3187,4 +3187,4 @@ module_i2c_driver(smiapp_i2c_driver);
 
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@iki.fi>");
 MODULE_DESCRIPTION("Generic SMIA/SMIA++ camera module driver");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
-- 
2.11.0
