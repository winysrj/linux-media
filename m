Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:59707 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbeDXXpl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 19:45:41 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] rcar-vin: fix null pointer dereference in rvin_group_get()
Date: Wed, 25 Apr 2018 01:45:06 +0200
Message-Id: <20180424234506.22630-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Store the group pointer before disassociating the VIN from the group.

Fixes: 3bb4c3bc85bf77a7 ("media: rcar-vin: add group allocator functions")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 7bc2774a11232362..d3072e166a1ca24f 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -338,19 +338,21 @@ static int rvin_group_get(struct rvin_dev *vin)
 
 static void rvin_group_put(struct rvin_dev *vin)
 {
-	mutex_lock(&vin->group->lock);
+	struct rvin_group *group = vin->group;
+
+	mutex_lock(&group->lock);
 
 	vin->group = NULL;
 	vin->v4l2_dev.mdev = NULL;
 
-	if (WARN_ON(vin->group->vin[vin->id] != vin))
+	if (WARN_ON(group->vin[vin->id] != vin))
 		goto out;
 
-	vin->group->vin[vin->id] = NULL;
+	group->vin[vin->id] = NULL;
 out:
-	mutex_unlock(&vin->group->lock);
+	mutex_unlock(&group->lock);
 
-	kref_put(&vin->group->refcount, rvin_group_release);
+	kref_put(&group->refcount, rvin_group_release);
 }
 
 /* -----------------------------------------------------------------------------
-- 
2.17.0
