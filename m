Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3E0C10F01
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 20:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35B9B2177E
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 20:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfBRUPx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 15:15:53 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40860 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729449AbfBRUPv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 15:15:51 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id C116C27FD0B
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 2/4] media: v4l: Improve debug dprintk macro
Date:   Mon, 18 Feb 2019 17:15:26 -0300
Message-Id: <20190218201528.21545-3-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190218201528.21545-1-ezequiel@collabora.com>
References: <20190218201528.21545-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Instead of checking the dev_debug flags before each dprintk call,
make the macro smarter by passing the parameters.

This makes the code simpler and will allow to add more debug logic.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 38 +++++++++++++-----------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 34e4958663bf..35e429ac888f 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -36,7 +36,8 @@
 #define VIDEO_NUM_DEVICES	256
 #define VIDEO_NAME              "video4linux"
 
-#define dprintk(fmt, arg...) do {					\
+#define dprintk(vdev, flags, fmt, arg...) do {				\
+	if (vdev->dev_debug & flags)					\
 		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
 		       __func__, ##arg);				\
 } while (0)
@@ -315,9 +316,8 @@ static ssize_t v4l2_read(struct file *filp, char __user *buf,
 		return -EINVAL;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->read(filp, buf, sz, off);
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING)
-		dprintk("%s: read: %zd (%d)\n",
-			video_device_node_name(vdev), sz, ret);
+	dprintk(vdev, V4L2_DEV_DEBUG_STREAMING, "%s: read: %zd (%d)\n",
+		video_device_node_name(vdev), sz, ret);
 	return ret;
 }
 
@@ -331,9 +331,8 @@ static ssize_t v4l2_write(struct file *filp, const char __user *buf,
 		return -EINVAL;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->write(filp, buf, sz, off);
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING)
-		dprintk("%s: write: %zd (%d)\n",
-			video_device_node_name(vdev), sz, ret);
+	dprintk(vdev, V4L2_DEV_DEBUG_STREAMING, "%s: write: %zd (%d)\n",
+		video_device_node_name(vdev), sz, ret);
 	return ret;
 }
 
@@ -346,9 +345,8 @@ static __poll_t v4l2_poll(struct file *filp, struct poll_table_struct *poll)
 		return DEFAULT_POLLMASK;
 	if (video_is_registered(vdev))
 		res = vdev->fops->poll(filp, poll);
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_POLL)
-		dprintk("%s: poll: %08x\n",
-			video_device_node_name(vdev), res);
+	dprintk(vdev, V4L2_DEV_DEBUG_POLL, "%s: poll: %08x\n",
+		video_device_node_name(vdev), res);
 	return res;
 }
 
@@ -381,9 +379,8 @@ static unsigned long v4l2_get_unmapped_area(struct file *filp,
 	if (!video_is_registered(vdev))
 		return -ENODEV;
 	ret = vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
-		dprintk("%s: get_unmapped_area (%d)\n",
-			video_device_node_name(vdev), ret);
+	dprintk(vdev, V4L2_DEV_DEBUG_FOP, "%s: get_unmapped_area (%d)\n",
+		video_device_node_name(vdev), ret);
 	return ret;
 }
 #endif
@@ -397,9 +394,8 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 		return -ENODEV;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->mmap(filp, vm);
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
-		dprintk("%s: mmap (%d)\n",
-			video_device_node_name(vdev), ret);
+	dprintk(vdev, V4L2_DEV_DEBUG_FOP, "%s: mmap (%d)\n",
+		video_device_node_name(vdev), ret);
 	return ret;
 }
 
@@ -427,9 +423,8 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 			ret = -ENODEV;
 	}
 
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
-		dprintk("%s: open (%d)\n",
-			video_device_node_name(vdev), ret);
+	dprintk(vdev, V4L2_DEV_DEBUG_FOP, "%s: open (%d)\n",
+		video_device_node_name(vdev), ret);
 	/* decrease the refcount in case of an error */
 	if (ret)
 		video_put(vdev);
@@ -458,9 +453,8 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 		}
 	}
 
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
-		dprintk("%s: release\n",
-			video_device_node_name(vdev));
+	dprintk(vdev, V4L2_DEV_DEBUG_FOP, "%s: release\n",
+		video_device_node_name(vdev));
 
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
-- 
2.20.1

