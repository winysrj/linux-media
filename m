Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39128 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbcGTOlk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 10:41:40 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/5] [media] media-entry.h: Fix a note markup
Date: Wed, 20 Jul 2016 11:41:34 -0300
Message-Id: <96f0111795659bc0dad878fd2eaecd36c613197e.1469025360.git.mchehab@s-opensource.com>
In-Reply-To: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
References: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
In-Reply-To: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
References: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Sphinx note markup for media_remove_intf_links() is wrong:
there's a missing space.

While here, let's auto-numerate the two notes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/media-entity.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 3d885d97d149..17390cc7b538 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -968,12 +968,12 @@ void __media_remove_intf_links(struct media_interface *intf);
  *
  * @intf:	pointer to &media_interface
  *
- * ..note::
+ * .. note::
  *
- *   - This is called automatically when an entity is unregistered via
- *     media_device_register_entity() and by media_devnode_remove().
+ *   #) This is called automatically when an entity is unregistered via
+ *      media_device_register_entity() and by media_devnode_remove().
  *
- *   - Prefer to use this one, instead of __media_remove_intf_links().
+ *   #) Prefer to use this one, instead of __media_remove_intf_links().
  */
 void media_remove_intf_links(struct media_interface *intf);
 
-- 
2.7.4

