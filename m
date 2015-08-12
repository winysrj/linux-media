Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52928 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbbHLUPJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 16:15:09 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v3 14/16] media: add a generic function to remove a link
Date: Wed, 12 Aug 2015 17:14:58 -0300
Message-Id: <68d8610deb78010dc1f923b991163f80466c4994.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removing a link is simple. Yet, better to have a separate
function for it, as we'll be also sharing it with a
public API call.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index b8991d38c565..f43af2fda306 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -484,6 +484,12 @@ static struct media_link *__media_create_link(struct media_device *mdev,
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
@@ -509,11 +515,9 @@ static void __media_entity_remove_link(struct media_entity *entity,
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

