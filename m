Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51817 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965016AbbLOKLw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 05:11:52 -0500
Date: Tue, 15 Dec 2015 08:11:47 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Fw: [PATCH 2/2] [media] media-entity: cache media_device on object
 removal
Message-ID: <20151215081147.2a08e81a@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

This were supposed to be C/C to you.

Thanks and Regards,
Mauro

Forwarded message:

Date: Tue, 15 Dec 2015 08:08:39 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: 
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] [media] media-entity: cache media_device on object removal


As pointed by Dan, the patch f8fd4c61b5ae: "[media] media-entity:
protect object creation/removal using spin lock" leads to the following
static checker warning:

	drivers/media/media-entity.c:781 media_remove_intf_link()
	error: dereferencing freed memory 'link'

drivers/media/media-entity.c
   777  void media_remove_intf_link(struct media_link *link)
   778  {
   779          spin_lock(&link->graph_obj.mdev->lock);
   780          __media_remove_intf_link(link);
   781          spin_unlock(&link->graph_obj.mdev->lock);

In practice, I didn't see any troubles even with KASAN enabled.
I guess gcc optimizer internally cached the mdev reference,
instead of getting it twice. Yet, it is a very bad idea to rely
on such optimization. So, let's fix the code.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-entity.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 29810f9b86ce..6c3f4041797c 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -580,13 +580,15 @@ EXPORT_SYMBOL_GPL(__media_entity_remove_links);
 
 void media_entity_remove_links(struct media_entity *entity)
 {
+	struct media_device *mdev = entity->graph_obj.mdev;
+
 	/* Do nothing if the entity is not registered. */
-	if (entity->graph_obj.mdev == NULL)
+	if (mdev == NULL)
 		return;
 
-	spin_lock(&entity->graph_obj.mdev->lock);
+	spin_lock(&mdev->lock);
 	__media_entity_remove_links(entity);
-	spin_unlock(&entity->graph_obj.mdev->lock);
+	spin_unlock(&mdev->lock);
 }
 EXPORT_SYMBOL_GPL(media_entity_remove_links);
 
@@ -781,9 +783,15 @@ EXPORT_SYMBOL_GPL(__media_remove_intf_link);
 
 void media_remove_intf_link(struct media_link *link)
 {
-	spin_lock(&link->graph_obj.mdev->lock);
+	struct media_device *mdev = link->graph_obj.mdev;
+
+	/* Do nothing if the intf is not registered. */
+	if (mdev == NULL)
+		return;
+
+	spin_lock(&mdev->lock);
 	__media_remove_intf_link(link);
-	spin_unlock(&link->graph_obj.mdev->lock);
+	spin_unlock(&mdev->lock);
 }
 EXPORT_SYMBOL_GPL(media_remove_intf_link);
 
@@ -799,12 +807,14 @@ EXPORT_SYMBOL_GPL(__media_remove_intf_links);
 
 void media_remove_intf_links(struct media_interface *intf)
 {
+	struct media_device *mdev = intf->graph_obj.mdev;
+
 	/* Do nothing if the intf is not registered. */
-	if (intf->graph_obj.mdev == NULL)
+	if (mdev == NULL)
 		return;
 
-	spin_lock(&intf->graph_obj.mdev->lock);
+	spin_lock(&mdev->lock);
 	__media_remove_intf_links(intf);
-	spin_unlock(&intf->graph_obj.mdev->lock);
+	spin_unlock(&mdev->lock);
 }
 EXPORT_SYMBOL_GPL(media_remove_intf_links);
-- 
2.5.0

