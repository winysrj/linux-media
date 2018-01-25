Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:11035 "EHLO
        bin-vsp-out-03.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751826AbeAYNJE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 08:09:04 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2] v4l2-dev.h: fix symbol collision in media_entity_to_video_device()
Date: Thu, 25 Jan 2018 14:08:52 +0100
Message-Id: <20180125130852.4779-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A recent change to the media_entity_to_video_device() macro breaks some
use-cases for the macro due to a symbol collision. Before the change
this worked:

    vdev = media_entity_to_video_device(link->sink->entity);

While after the change it results in a compiler error "error: 'struct
video_device' has no member named 'link'; did you mean 'lock'?". While
the following still works after the change.

    struct media_entity *entity = link->sink->entity;
    vdev = media_entity_to_video_device(entity);

Fix the collision by renaming the macro argument to '__entity'.

Fixes: 69b925c5fc36d8f1 ("media: v4l2-dev.h: add kernel-doc to two macros")
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 include/media/v4l2-dev.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

* Changes from v1
- Change argument name to '__entity' as suggested by Geert, Sakari and 
  Mauro.
- Added fixes tag.

diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 267fd2bed17bd3c1..322b8a9abb8dc45a 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -298,10 +298,10 @@ struct video_device
  * media_entity_to_video_device - Returns a &struct video_device from
  *	the &struct media_entity embedded on it.
  *
- * @entity: pointer to &struct media_entity
+ * @__entity: pointer to &struct media_entity
  */
-#define media_entity_to_video_device(entity) \
-	container_of(entity, struct video_device, entity)
+#define media_entity_to_video_device(__entity) \
+	container_of(__entity, struct video_device, entity)
 
 /**
  * to_video_device - Returns a &struct video_device from the
-- 
2.15.1
