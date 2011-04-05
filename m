Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43020 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab1DEH5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 03:57:14 -0400
Received: from localhost.localdomain (unknown [91.178.236.143])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 3452535B6D
	for <linux-media@vger.kernel.org>; Tue,  5 Apr 2011 07:57:11 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 06/14] media: Properly handle link flags in link setup, link notify callback
Date: Tue,  5 Apr 2011 09:57:28 +0200
Message-Id: <1301990256-6963-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The link flags were not properly handled in __media_entity_setup_link
which could lead to link_notify callback to be called when the flags are
not modified. Fix this.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-entity.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 23640ed..056138f 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -378,7 +378,6 @@ EXPORT_SYMBOL_GPL(media_entity_create_link);
 
 static int __media_entity_setup_link_notify(struct media_link *link, u32 flags)
 {
-	const u32 mask = MEDIA_LNK_FL_ENABLED;
 	int ret;
 
 	/* Notify both entities. */
@@ -395,7 +394,7 @@ static int __media_entity_setup_link_notify(struct media_link *link, u32 flags)
 		return ret;
 	}
 
-	link->flags = (link->flags & ~mask) | (flags & mask);
+	link->flags = flags;
 	link->reverse->flags = link->flags;
 
 	return 0;
@@ -417,6 +416,7 @@ static int __media_entity_setup_link_notify(struct media_link *link, u32 flags)
  */
 int __media_entity_setup_link(struct media_link *link, u32 flags)
 {
+	const u32 mask = MEDIA_LNK_FL_ENABLED;
 	struct media_device *mdev;
 	struct media_entity *source, *sink;
 	int ret = -EBUSY;
@@ -424,6 +424,10 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
 	if (link == NULL)
 		return -EINVAL;
 
+	/* The non-modifiable link flags must not be modified. */
+	if ((link->flags & ~mask) != (flags & ~mask))
+		return -EINVAL;
+
 	if (link->flags & MEDIA_LNK_FL_IMMUTABLE)
 		return link->flags == flags ? 0 : -EINVAL;
 
-- 
1.7.3.4

