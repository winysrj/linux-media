Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36366 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbaGQLyg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 07:54:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Joe Perches <joe@perches.com>
Subject: [PATCH] media: Use strlcpy instead of custom code
Date: Thu, 17 Jul 2014 13:54:38 +0200
Message-Id: <1405598078-9842-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace strncpy + manually setting the terminating '\0' with an strlcpy
call.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-device.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

This patch applies on top of "media-device: Remove duplicated memset() in
media_enum_entities()".

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 73a4329..7b39440 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -103,10 +103,8 @@ static long media_device_enum_entities(struct media_device *mdev,
 		return -EINVAL;
 
 	u_ent.id = ent->id;
-	if (ent->name) {
-		strncpy(u_ent.name, ent->name, sizeof(u_ent.name));
-		u_ent.name[sizeof(u_ent.name) - 1] = '\0';
-	}
+	if (ent->name)
+		strlcpy(u_ent.name, ent->name, sizeof(u_ent.name));
 	u_ent.type = ent->type;
 	u_ent.revision = ent->revision;
 	u_ent.flags = ent->flags;
-- 
Regards,

Laurent Pinchart

