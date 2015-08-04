Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52343 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933162AbbHDLlT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 07:41:19 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: media-workshop@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH_RFC_v1 1/4] media: Add some fields to store graph objects
Date: Tue,  4 Aug 2015 08:41:06 -0300
Message-Id: <a3c1d738a55bf2b3b34222125ab0b27de28cbcfb.1438687440.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438687440.git.mchehab@osg.samsung.com>
References: <cover.1438687440.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438687440.git.mchehab@osg.samsung.com>
References: <cover.1438687440.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We'll need unique IDs for graph objects and a way to associate
them with the media interface.

So, add an atomic var to be used to create unique IDs and
a list to store such objects.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 7b39440192d6..e627b0b905ad 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -396,6 +396,10 @@ int __must_check __media_device_register(struct media_device *mdev,
 		return ret;
 	}
 
+	/* Initialize media graph object list and ID */
+	atomic_set(&mdev->last_obj_id, 0);
+	INIT_LIST_HEAD(&mdev->object_list);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__media_device_register);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 6e6db78f1ee2..a9d546716e49 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -78,6 +78,10 @@ struct media_device {
 
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
+
+	/* Used by media_graph stuff */
+	atomic_t last_obj_id;
+	struct list_head object_list;
 };
 
 /* Supported link_notify @notification values. */
-- 
2.4.3

