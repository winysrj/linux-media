Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2128 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaGNM7k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 08:59:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/12] v4l2-dev: don't debug poll unless the debug level > 2
Date: Mon, 14 Jul 2014 14:59:08 +0200
Message-Id: <1405342752-46998-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405342752-46998-1-git-send-email-hverkuil@xs4all.nl>
References: <1405342752-46998-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Some applications poll a lot, so prevent the poll message from flooding
the log.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 35698aa..72bea04 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -335,7 +335,7 @@ static unsigned int v4l2_poll(struct file *filp, struct poll_table_struct *poll)
 		return DEFAULT_POLLMASK;
 	if (video_is_registered(vdev))
 		res = vdev->fops->poll(filp, poll);
-	if (vdev->debug)
+	if (vdev->debug > 2)
 		printk(KERN_DEBUG "%s: poll: %08x\n",
 			video_device_node_name(vdev), res);
 	return res;
-- 
2.0.1

