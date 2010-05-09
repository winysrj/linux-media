Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1047 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab0EIT1g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 15:27:36 -0400
Received: from localhost (cm-84.208.87.21.getinternet.no [84.208.87.21])
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id o49JRYjk090227
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 9 May 2010 21:27:35 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <e3dcff9743201d234aca7e3577c005bc4653bfdd.1273432986.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1273432986.git.hverkuil@xs4all.nl>
References: <cover.1273432986.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 09 May 2010 21:29:10 +0200
Subject: [PATCH 2/7] [RFC] v4l2-device: add v4l2_prio_state to v4l2_device.
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-device.c |    1 +
 include/media/v4l2-device.h       |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 2386ae6..86ce0c9 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -34,6 +34,7 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
 
 	INIT_LIST_HEAD(&v4l2_dev->subdevs);
 	spin_lock_init(&v4l2_dev->lock);
+	v4l2_prio_init(&v4l2_dev->prio);
 	v4l2_dev->dev = dev;
 	if (dev == NULL) {
 		/* If dev == NULL, then name must be filled in by the caller */
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index b497e53..322c377 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -49,6 +49,8 @@ struct v4l2_device {
 	spinlock_t lock;
 	/* unique device name, by default the driver name + bus ID */
 	char name[V4L2_DEVICE_NAME_SIZE];
+	/* Device's priority state */
+	struct v4l2_prio_state prio;
 	/* notify callback called by some sub-devices. */
 	void (*notify)(struct v4l2_subdev *sd,
 			unsigned int notification, void *arg);
-- 
1.6.4.2

