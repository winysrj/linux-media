Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:61072 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab1JGPfQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Oct 2011 11:35:16 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 5/7] Add link to media_device from the media_entity
Date: Fri,  7 Oct 2011 18:38:06 +0300
Message-Id: <1318001888-18689-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111007153443.GC8908@valkosipuli.localdomain>
References: <20111007153443.GC8908@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes it possible to obtain the media device an entity belongs to.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/mediactl.c |    1 +
 src/mediactl.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/src/mediactl.c b/src/mediactl.c
index a03c19a..8cc338d 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -372,6 +372,7 @@ static int media_enum_entities(struct media_device *media, int verbose)
 		memset(entity, 0, sizeof(*entity));
 		entity->fd = -1;
 		entity->info.id = id | MEDIA_ENT_ID_FLAG_NEXT;
+		entity->media = media;
 
 		ret = ioctl(media->fd, MEDIA_IOC_ENUM_ENTITIES, &entity->info);
 		if (ret < 0) {
diff --git a/src/mediactl.h b/src/mediactl.h
index 9ebad9f..98b47fd 100644
--- a/src/mediactl.h
+++ b/src/mediactl.h
@@ -38,6 +38,7 @@ struct media_pad {
 };
 
 struct media_entity {
+	struct media_device *media;
 	struct media_entity_desc info;
 	struct media_pad *pads;
 	struct media_link *links;
-- 
1.7.2.5

