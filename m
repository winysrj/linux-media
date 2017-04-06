Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54843 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752831AbdDFTcN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Apr 2017 15:32:13 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] media-entity: only call dev_dbg_obj if mdev is not NULL
Date: Thu,  6 Apr 2017 16:32:00 -0300
Message-Id: <1491507120-28112-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix kernel Oops NULL pointer deference
Call dev_dbg_obj only after checking if gobj->mdev is not NULL

Signed-off-by: Helen Koike <helen.koike@collabora.com>
---
 drivers/media/media-entity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 5640ca2..bc44193 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -199,12 +199,12 @@ void media_gobj_create(struct media_device *mdev,
 
 void media_gobj_destroy(struct media_gobj *gobj)
 {
-	dev_dbg_obj(__func__, gobj);
-
 	/* Do nothing if the object is not linked. */
 	if (gobj->mdev == NULL)
 		return;
 
+	dev_dbg_obj(__func__, gobj);
+
 	gobj->mdev->topology_version++;
 
 	/* Remove the object from mdev list */
-- 
2.7.4
