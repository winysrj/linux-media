Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55913 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbbHaJ0O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 05:26:14 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] [media] media-device: supress backlinks at G_TOPOLOGY ioctl
Date: Mon, 31 Aug 2015 06:25:51 -0300
Message-Id: <241578af13805088e8a37686245c3b98a1fa9791.1441013143.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the graph traversal algorithm currently in usage, we
need a copy of all data links. Those backlinks should not be
send to userspace, as otherwise, all links there will be
duplicated.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 2c16a46ea530..c181bdcfc72e 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -318,6 +318,9 @@ static long __media_device_get_topology(struct media_device *mdev,
 	/* Get links and number of links */
 	i = 0;
 	media_device_for_each_link(link, mdev) {
+		if (link->is_backlink)
+			continue;
+
 		i++;
 
 		if (ret || !topo->links)
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 1cdda9cb0512..f75b4c9ac330 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -648,6 +648,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 	backlink->source = &source->pads[source_pad];
 	backlink->sink = &sink->pads[sink_pad];
 	backlink->flags = flags;
+	backlink->is_backlink = true;
 
 	/* Initialize graph object embedded at the new link */
 	media_gobj_init(sink->graph_obj.mdev, MEDIA_GRAPH_LINK,
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index c42d191fa5a8..a45eaa1bf801 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -96,6 +96,7 @@ struct media_pipeline {
  * @reverse:	Pointer to the link for the reverse direction of a pad to pad
  *		link.
  * @flags:	Link flags, as defined at uapi/media.h (MEDIA_LNK_FL_*)
+ * @is_backlink: Indicate if the link is a backlink.
  */
 struct media_link {
 	struct media_gobj graph_obj;
@@ -112,6 +113,7 @@ struct media_link {
 	};
 	struct media_link *reverse;
 	unsigned long flags;
+	bool is_backlink;
 };
 
 /**
-- 
2.4.3

