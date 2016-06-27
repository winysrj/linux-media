Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:32872 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbcF0R5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 13:57:36 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Cc: ulrich.hecht+renesas@gmail.com, hans.verkuil@cisco.com,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [RFC 1/2] media: entity: Add has_route entity operation
Date: Mon, 27 Jun 2016 19:56:56 +0200
Message-Id: <20160627175657.25391-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160627175657.25391-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160627175657.25391-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

The optional operation can be used by entities to report whether two
pads are internally connected.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 include/media/media-entity.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index cbb266f..c4b2dca 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -179,6 +179,9 @@ struct media_pad {
  * @link_validate:	Return whether a link is valid from the entity point of
  *			view. The media_entity_pipeline_start() function
  *			validates all links by calling this operation. Optional.
+ * @has_route:		Return whether a route exists inside the entity between
+ *			two given pads. Optional. If the operation isn't
+ *			implemented all pads will be considered as connected.
  *
  * Note: Those these callbacks are called with struct media_device.@graph_mutex
  * mutex held.
@@ -188,6 +191,8 @@ struct media_entity_operations {
 			  const struct media_pad *local,
 			  const struct media_pad *remote, u32 flags);
 	int (*link_validate)(struct media_link *link);
+	bool (*has_route)(struct media_entity *entity, unsigned int pad0,
+			  unsigned int pad1);
 };
 
 /**
-- 
2.8.3

