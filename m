Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:42018 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937664AbdEXAJ2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 20:09:28 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 1/2] media: entity: Add pad_from_fwnode entity operation
Date: Wed, 24 May 2017 02:09:06 +0200
Message-Id: <20170524000907.13061-2-niklas.soderlund@ragnatech.se>
In-Reply-To: <20170524000907.13061-1-niklas.soderlund@ragnatech.se>
References: <20170524000907.13061-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

The optional operation can be used by entities to report how it maps its
fwnode endpoints to media pad numbers. This is useful for devices which
require advanced mappings of pads.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 include/media/media-entity.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index c7c254c5bca1761b..2aea22b0409d1070 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -21,6 +21,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/bug.h>
+#include <linux/fwnode.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/media.h>
@@ -171,6 +172,9 @@ struct media_pad {
 
 /**
  * struct media_entity_operations - Media entity operations
+ * @pad_from_fwnode:	Return the pad number based on a fwnode endpoint.
+ *			This operation can be used to map a fwnode to a
+ *			media pad number. Optional.
  * @link_setup:		Notify the entity of link changes. The operation can
  *			return an error, in which case link setup will be
  *			cancelled. Optional.
@@ -184,6 +188,8 @@ struct media_pad {
  *    mutex held.
  */
 struct media_entity_operations {
+	int (*pad_from_fwnode)(struct fwnode_endpoint *endpoint,
+			       unsigned int *pad);
 	int (*link_setup)(struct media_entity *entity,
 			  const struct media_pad *local,
 			  const struct media_pad *remote, u32 flags);
-- 
2.13.0
