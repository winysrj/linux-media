Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37555 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312AbbLKRRP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 12:17:15 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 07/10] [media] v4l: vsp1: use else if instead of continue when creating links
Date: Fri, 11 Dec 2015 14:16:33 -0300
Message-Id: <1449854196-13296-8-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
References: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The for loop in the vsp1_create_entities() function that create the links,
checks the entity type and call the proper link creation function but then
it uses continue to force the next iteration of the loop to take place and
skipping code in between that creates links for different entities types.

It is more readable and easier to understand if the if else constructs is
used instead of the continue statement.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>


This patch addresses an issue pointed out by Laurent in patch [0]:

- Use if else instead of continue.

[0]: http://www.spinics.net/lists/linux-media/msg95316.html
END

---

 drivers/media/platform/vsp1/vsp1_drv.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 4209d8615f72..0b251147bfff 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -264,19 +264,15 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 			ret = vsp1_wpf_create_links(vsp1, entity);
 			if (ret < 0)
 				goto done;
-			continue;
-		}
-
-		if (entity->type == VSP1_ENTITY_RPF) {
+		} else if (entity->type == VSP1_ENTITY_RPF) {
 			ret = vsp1_rpf_create_links(vsp1, entity);
 			if (ret < 0)
 				goto done;
-			continue;
+		} else {
+			ret = vsp1_create_links(vsp1, entity);
+			if (ret < 0)
+				goto done;
 		}
-
-		ret = vsp1_create_links(vsp1, entity);
-		if (ret < 0)
-			goto done;
 	}
 
 	if (vsp1->pdata.features & VSP1_HAS_LIF) {
-- 
2.4.3

