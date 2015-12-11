Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51753 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbbLKNe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 08:34:29 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 02/10] media-device: better name Kernelspace/Userspace links
Date: Fri, 11 Dec 2015 11:34:07 -0200
Message-Id: <7c094f54c1423902d848a9dbcb6a462d347fe086.1449840443.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The __media_device_enum_links() copies links definitions from
Kernelspace to userspace. It has to work with 3 structs that
handle with links. Better name them to:
	link: Kernelspace internal link representation, of the
		type media_link;
	klink_desc:  struct media_link_desc pointer to the
		kernel memory where the data will be filled;
	ulink_desc:  struct media_link_desc pointer to the
		memory where the data will be copied to
		userspace.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 61883abaf095..14bd568e2f41 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -151,24 +151,25 @@ static long __media_device_enum_links(struct media_device *mdev,
 	}
 
 	if (links->links) {
-		struct media_link *ent_link;
-		struct media_link_desc __user *ulink = links->links;
+		struct media_link *link;
+		struct media_link_desc __user *ulink_desc = links->links;
 
-		list_for_each_entry(ent_link, &entity->links, list) {
-			struct media_link_desc link;
+		list_for_each_entry(link, &entity->links, list) {
+			struct media_link_desc klink_desc;
 
 			/* Ignore backlinks. */
-			if (ent_link->source->entity != entity)
+			if (link->source->entity != entity)
 				continue;
-			memset(&link, 0, sizeof(link));
-			media_device_kpad_to_upad(ent_link->source,
-						  &link.source);
-			media_device_kpad_to_upad(ent_link->sink,
-						  &link.sink);
-			link.flags = ent_link->flags;
-			if (copy_to_user(ulink, &link, sizeof(*ulink)))
+			memset(&klink_desc, 0, sizeof(klink_desc));
+			media_device_kpad_to_upad(link->source,
+						  &klink_desc.source);
+			media_device_kpad_to_upad(link->sink,
+						  &klink_desc.sink);
+			klink_desc.flags = link->flags;
+			if (copy_to_user(ulink_desc, &klink_desc,
+					 sizeof(*ulink_desc)))
 				return -EFAULT;
-			ulink++;
+			ulink_desc++;
 		}
 	}
 
-- 
2.5.0


