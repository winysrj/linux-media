Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60615 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754438AbbLPNew (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 08:34:52 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v3 22/23] media: Move MEDIA_ENTITY_MAX_PADS from media-entity.h to media-entity.c
Date: Wed, 16 Dec 2015 15:32:37 +0200
Message-Id: <1450272758-29446-23-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
References: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This isn't really a part of any interface drivers are expected to use. In
order to keep drivers from using it, hide it in media-entity.c. This was
always an arbitrary number and should be removed in the long run.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 5 +++++
 include/media/media-entity.h | 7 -------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index c799a4e..2e4ffaf 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -245,6 +245,11 @@ void media_entity_enum_cleanup(struct media_entity_enum *ent_enum)
 }
 EXPORT_SYMBOL_GPL(media_entity_enum_cleanup);
 
+/*
+ * TODO: Get rid of this.
+ */
+#define MEDIA_ENTITY_MAX_PADS		63
+
 /**
  * media_entity_init - Initialize a media entity
  *
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 034b9d7..d2d668a 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -73,13 +73,6 @@ struct media_gobj {
 
 #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
 
-/*
- * The number of pads can't be bigger than the number of entities,
- * as the worse-case scenario is to have one entity linked up to
- * 63 entities.
- */
-#define MEDIA_ENTITY_MAX_PADS		63
-
 /**
  * struct media_entity_enum - An enumeration of media entities.
  *
-- 
2.1.4

