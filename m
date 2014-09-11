Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35219 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaIKWpB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Sep 2014 18:45:01 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 6F90820AF0
	for <linux-media@vger.kernel.org>; Fri, 12 Sep 2014 00:43:59 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: entity: Document the media_entity_ops structure
Date: Fri, 12 Sep 2014 01:45:03 +0300
Message-Id: <1410475503-30176-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/media-entity.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index e004591..786906b 100644
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
Regards,

Laurent Pinchart

