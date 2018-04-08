Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:20181 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752282AbeDHQMr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2018 12:12:47 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] media: entity: fix spelling for media_entity_get_fwnode_pad()
Date: Sun,  8 Apr 2018 18:11:52 +0200
Message-Id: <20180408161152.11667-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

s/dose/does/

Fixes: d295c6a460cd2ac6 ("[media] media: entity: Add media_entity_get_fwnode_pad() function")
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 include/media/media-entity.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index a732af1dbba099d4..3aa3d58d1d586dc2 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -842,7 +842,7 @@ struct media_entity *media_entity_get(struct media_entity *entity);
  * a fwnode. This is useful for devices which use more complex
  * mappings of media pads.
  *
- * If the entity dose not implement the get_fwnode_pad() operation
+ * If the entity does not implement the get_fwnode_pad() operation
  * then this function searches the entity for the first pad that
  * matches the @direction_flags.
  *
-- 
2.16.3
