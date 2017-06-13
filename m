Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:40273 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752781AbdFMObq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 10:31:46 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v3 1/2] media: entity: Add get_fwnode_pad entity operation
Date: Tue, 13 Jun 2017 16:31:25 +0200
Message-Id: <20170613143126.755-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170613143126.755-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170613143126.755-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The optional operation can be used by entities to report how it maps its
fwnode endpoints to media pad numbers. This is useful for devices which
require advanced mappings of pads.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 include/media/media-entity.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index c7c254c5bca1761b..46eeb036aa330534 100644
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
+ * @get_fwnode_pad:	Return the pad number based on a fwnode endpoint or
+ *			a negative value on error. This operation can be used
+ *			to map a fwnode to a media pad number. Optional.
  * @link_setup:		Notify the entity of link changes. The operation can
  *			return an error, in which case link setup will be
  *			cancelled. Optional.
@@ -184,6 +188,7 @@ struct media_pad {
  *    mutex held.
  */
 struct media_entity_operations {
+	int (*get_fwnode_pad)(struct fwnode_endpoint *endpoint);
 	int (*link_setup)(struct media_entity *entity,
 			  const struct media_pad *local,
 			  const struct media_pad *remote, u32 flags);
-- 
2.13.1
