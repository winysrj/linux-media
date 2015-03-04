Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59559 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870AbbCDOvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 09:51:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>
Subject: [PATCH v6 1/8] media: entity: Document the media_entity_ops structure
Date: Wed,  4 Mar 2015 16:51:42 +0200
Message-Id: <1425480709-7545-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1425480709-7545-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1425480709-7545-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/media-entity.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index d6d74bc..0c003d8 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -44,6 +44,15 @@ struct media_pad {
 	unsigned long flags;		/* Pad flags (MEDIA_PAD_FL_*) */
 };
 
+/**
+ * struct media_entity_operations - Media entity operations
+ * @link_setup:		Notify the entity of link changes. The operation can
+ *			return an error, in which case link setup will be
+ *			cancelled. Optional.
+ * @link_validate:	Return whether a link is valid from the entity point of
+ *			view. The media_entity_pipeline_start() function
+ *			validates all links by calling this operation. Optional.
+ */
 struct media_entity_operations {
 	int (*link_setup)(struct media_entity *entity,
 			  const struct media_pad *local,
-- 
2.0.5

