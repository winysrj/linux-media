Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38067 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbbLKW5c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 17:57:32 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH v5 3/3] [media] media-device: set topology version 0 at media registration
Date: Fri, 11 Dec 2015 19:57:09 -0300
Message-Id: <1449874629-8973-4-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1449874629-8973-1-git-send-email-javier@osg.samsung.com>
References: <1449874629-8973-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The G_TOPOLOGY ioctl is used to get a graph topology and since in the
future a graph can be dynamically updated, there is a way to know the
topology version so userspace can be aware that the graph has changed.

The version 0 is reserved to indicate that the graph is static (i.e no
graphs updates since the media device was registered).

So, now that the media device initialization and registration has been
split and the media device node is not exposed to user-space until all
the entities have been registered and links created, it is safe to set
a topology version 0 in media_device_register().

Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/media/media-device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 5d5c8a57e7ba..d166cf5ad3ff 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -581,6 +581,10 @@ int __must_check __media_device_register(struct media_device *mdev,
 	mdev->devnode.fops = &media_device_fops;
 	mdev->devnode.parent = mdev->dev;
 	mdev->devnode.release = media_device_release;
+
+	/* Set version 0 to indicate user-space that the graph is static */
+	mdev->topology_version = 0;
+
 	ret = media_devnode_register(&mdev->devnode, owner);
 	if (ret < 0)
 		return ret;
-- 
2.4.3

