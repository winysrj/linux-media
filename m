Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53822 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbbIFRbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 13:31:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org
Subject: [PATCH 14/18] [media] media-device: export the entity function via new ioctl
Date: Sun,  6 Sep 2015 14:30:57 -0300
Message-Id: <13a08789f63775c6f014c08969bc8ed3f0550c82.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that entities have a main function, expose it via
MEDIA_IOC_G_TOPOLOGY ioctl.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index ccef9621d147..32090030c342 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -263,6 +263,7 @@ static long __media_device_get_topology(struct media_device *mdev,
 		/* Copy fields to userspace struct if not error */
 		memset(&uentity, 0, sizeof(uentity));
 		uentity.id = entity->graph_obj.id;
+		uentity.function = entity->function;
 		strncpy(uentity.name, entity->name,
 			sizeof(uentity.name));
 
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 69433405aec2..d232cc680c67 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -284,7 +284,8 @@ struct media_links_enum {
 struct media_v2_entity {
 	__u32 id;
 	char name[64];		/* FIXME: move to a property? (RFC says so) */
-	__u16 reserved[14];
+	__u32 function;		/* Main function of the entity */
+	__u16 reserved[12];
 };
 
 /* Should match the specific fields at media_intf_devnode */
-- 
2.4.3


