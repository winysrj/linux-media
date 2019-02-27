Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FF2C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 17:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A26720842
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 17:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbfB0RIZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 12:08:25 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48028 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730619AbfB0RIZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 12:08:25 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 1363E2787A3
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 2/4] media: v4l: Improve debug dprintk macro
Date:   Wed, 27 Feb 2019 14:07:04 -0300
Message-Id: <20190227170706.6258-3-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190227170706.6258-1-ezequiel@collabora.com>
References: <20190227170706.6258-1-ezequiel@collabora.com>
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
 drivers/media/v4l2-core/v4l2-dev.c | 35 ++++++++++--------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 34e4958663bf..7cfb05204065 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -36,9 +36,10 @@
 #define VIDEO_NUM_DEVICES	256
 #define VIDEO_NAME              "video4linux"
 
-#define dprintk(fmt, arg...) do {					\
-		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
-		       __func__, ##arg);				\
+#define dprintk(vdev, flags, fmt, arg...) do {				\
+	if (vdev->dev_debug & flags)					\
+		printk(KERN_DEBUG pr_fmt("%s: %s: " fmt),		\
+		       __func__, video_device_node_name(vdev), ##arg);	\
 } while (0)
 
 
@@ -315,9 +316,7 @@ static ssize_t v4l2_read(struct file *filp, char __user *buf,
 		return -EINVAL;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->read(filp, buf, sz, off);
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING)
-		dprintk("%s: read: %zd (%d)\n",
-			video_device_node_name(vdev), sz, ret);
+	dprintk(vdev, V4L2_DEV_DEBUG_STREAMING, "read: %zd (%d)\n", sz, ret);
 	return ret;
 }
 
@@ -331,9 +330,7 @@ static ssize_t v4l2_write(struct file *filp, const char __user *buf,
 		return -EINVAL;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->write(filp, buf, sz, off);
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING)
-		dprintk("%s: write: %zd (%d)\n",
-			video_device_node_name(vdev), sz, ret);
+	dprintk(vdev, V4L2_DEV_DEBUG_STREAMING, "write: %zd (%d)\n", sz, ret);
 	return ret;
 }
 
@@ -346,9 +343,7 @@ static __poll_t v4l2_poll(struct file *filp, struct poll_table_struct *poll)
 		return DEFAULT_POLLMASK;
 	if (video_is_registered(vdev))
 		res = vdev->fops->poll(filp, poll);
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_POLL)
-		dprintk("%s: poll: %08x\n",
-			video_device_node_name(vdev), res);
+	dprintk(vdev, V4L2_DEV_DEBUG_POLL, "poll: %08x\n", res);
 	return res;
 }
 
@@ -381,9 +376,7 @@ static unsigned long v4l2_get_unmapped_area(struct file *filp,
 	if (!video_is_registered(vdev))
 		return -ENODEV;
 	ret = vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
-		dprintk("%s: get_unmapped_area (%d)\n",
-			video_device_node_name(vdev), ret);
+	dprintk(vdev, V4L2_DEV_DEBUG_FOP, "get_unmapped_area (%d)\n", ret);
 	return ret;
 }
 #endif
@@ -397,9 +390,7 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 		return -ENODEV;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->mmap(filp, vm);
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
-		dprintk("%s: mmap (%d)\n",
-			video_device_node_name(vdev), ret);
+	dprintk(vdev, V4L2_DEV_DEBUG_FOP, "mmap (%d)\n", ret);
 	return ret;
 }
 
@@ -427,9 +418,7 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 			ret = -ENODEV;
 	}
 
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
-		dprintk("%s: open (%d)\n",
-			video_device_node_name(vdev), ret);
+	dprintk(vdev, V4L2_DEV_DEBUG_FOP, "open (%d)\n", ret);
 	/* decrease the refcount in case of an error */
 	if (ret)
 		video_put(vdev);
@@ -458,9 +447,7 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 		}
 	}
 
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
-		dprintk("%s: release\n",
-			video_device_node_name(vdev));
+	dprintk(vdev, V4L2_DEV_DEBUG_FOP, "release\n");
 
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
-- 
2.20.1

