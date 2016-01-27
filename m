Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57426 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932913AbcA0OsO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 09:48:14 -0500
Received: from lanttu.localdomain (unknown [192.168.15.166])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id D1D98600AB
	for <linux-media@vger.kernel.org>; Wed, 27 Jan 2016 16:48:11 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 1/5] media: Use all bits of an enumeration
Date: Wed, 27 Jan 2016 16:47:54 +0200
Message-Id: <1453906078-29087-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1453906078-29087-1-git-send-email-sakari.ailus@iki.fi>
References: <1453906078-29087-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The allocation takes place in longs. Assign the size of the enum
accordingly.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index e89d85a..2c579f4 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -73,8 +73,9 @@ static inline const char *intf_type(struct media_interface *intf)
 __must_check int __media_entity_enum_init(struct media_entity_enum *ent_enum,
 					  int idx_max)
 {
-	ent_enum->bmap = kcalloc(DIV_ROUND_UP(idx_max, BITS_PER_LONG),
-				 sizeof(long), GFP_KERNEL);
+	idx_max = ALIGN(idx_max, BITS_PER_LONG);
+	ent_enum->bmap = kcalloc(idx_max / BITS_PER_LONG, sizeof(long),
+				 GFP_KERNEL);
 	if (!ent_enum->bmap)
 		return -ENOMEM;
 
-- 
2.1.4

