Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36641 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbcDXVKd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:33 -0400
Received: by mail-wm0-f68.google.com with SMTP id w143so16620767wmw.3
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:32 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: [RFC PATCH 19/24] v4l2_device_register_subdev_nodes: allow calling multiple times
Date: Mon, 25 Apr 2016 00:08:19 +0300
Message-Id: <1461532104-24032-20-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sebastian Reichel <sre@kernel.org>

---
 drivers/media/v4l2-core/v4l2-device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 06fa5f1..5aebe0a 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -238,6 +238,9 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
 			continue;
 
+		if(sd->devnode)
+			continue;
+
 		vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
 		if (!vdev) {
 			err = -ENOMEM;
-- 
1.9.1

