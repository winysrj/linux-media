Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40102 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbbHGOUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 10:20:21 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v2 14/16] media: add a generic function to remove a link
Date: Fri,  7 Aug 2015 11:20:12 -0300
Message-Id: <4a50853da3b2d92020eaf108d6ad1ced6fa265af.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removing a link is simple. Yet, better to have a separate
function for it, as we'll be also sharing it with a
public API call.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index c68dc421b022..8e77f2ae7197 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -489,6 +489,12 @@ static struct media_link *__media_create_link(struct media_device *mdev,
 	return link;
 }
 
+static void __media_remove_link(struct media_link *link)
+{
+	list_del(&link->list);
+	kfree(link);
+}
+
 static void __media_entity_remove_link(struct media_entity *entity,
 				       struct media_link *link)
 {
@@ -514,11 +520,9 @@ static void __media_entity_remove_link(struct media_entity *entity,
 			break;
 
 		/* Remove the remote link */
-		list_del(&rlink->list);
-		kfree(rlink);
+		__media_remove_link(rlink);
 	}
-	list_del(&link->list);
-	kfree(link);
+	__media_remove_link(link);
 }
 
 int
-- 
2.4.3

