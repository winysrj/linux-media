Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-dm3nam03on0081.outbound.protection.outlook.com ([104.47.41.81]:54430
	"EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752059AbcHKGnM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 02:43:12 -0400
From: Liu Ying <gnuiyl@gmail.com>
To: <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 1/3] [media] media-entity.h: Correct KernelDoc of media_entity_enum_empty()
Date: Thu, 11 Aug 2016 13:10:09 +0800
Message-ID: <1470892211-31387-1-git-send-email-gnuiyl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function media_entity_enum_empty() returns true when the bitmap
of the input parameter media entity enumeration is empty instead of marked.
This patch corrects the return value description of the function.

Signed-off-by: Liu Ying <gnuiyl@gmail.com>
---
 include/media/media-entity.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 09b03c1..48b4b6b 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -486,7 +486,7 @@ media_entity_enum_test_and_set(struct media_entity_enum *ent_enum,
  *
  * @ent_enum: Entity enumeration
  *
- * Returns true if the entity was marked.
+ * Returns true if the entity was empty.
  */
 static inline bool media_entity_enum_empty(struct media_entity_enum *ent_enum)
 {
-- 
2.7.4

