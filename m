Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33732C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 20:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E43A2177E
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 20:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbfBRUPw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 15:15:52 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40856 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728076AbfBRUPt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 15:15:49 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id BC08627FD0A
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 1/4] media: v4l: Simplify dev_debug flags
Date:   Mon, 18 Feb 2019 17:15:25 -0300
Message-Id: <20190218201528.21545-2-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190218201528.21545-1-ezequiel@collabora.com>
References: <20190218201528.21545-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In preparation to cleanup the debug logic, simplify the dev_debug
usage. In particular, make sure that a single flag is used to
control each debug print.

Before this commit V4L2_DEV_DEBUG_STREAMING and V4L2_DEV_DEBUG_FOP
were needed to enable read and write debugging. After this commit
only the former is needed.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index d7528f82a66a..34e4958663bf 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -315,8 +315,7 @@ static ssize_t v4l2_read(struct file *filp, char __user *buf,
 		return -EINVAL;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->read(filp, buf, sz, off);
-	if ((vdev->dev_debug & V4L2_DEV_DEBUG_FOP) &&
-	    (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING))
+	if (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING)
 		dprintk("%s: read: %zd (%d)\n",
 			video_device_node_name(vdev), sz, ret);
 	return ret;
@@ -332,8 +331,7 @@ static ssize_t v4l2_write(struct file *filp, const char __user *buf,
 		return -EINVAL;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->write(filp, buf, sz, off);
-	if ((vdev->dev_debug & V4L2_DEV_DEBUG_FOP) &&
-	    (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING))
+	if (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING)
 		dprintk("%s: write: %zd (%d)\n",
 			video_device_node_name(vdev), sz, ret);
 	return ret;
-- 
2.20.1

