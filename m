Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11919 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab1HZNGU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 09:06:20 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LQJ004E0DQJSD30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Aug 2011 14:06:19 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQJ00KOCDQIKJ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Aug 2011 14:06:18 +0100 (BST)
Date: Fri, 26 Aug 2011 15:06:06 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 4/5] [media] v4l: fix copying ioctl results on failure
In-reply-to: <1314363967-6448-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Message-id: <1314363967-6448-5-git-send-email-t.stanislaws@samsung.com>
References: <1314363967-6448-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix the handling of data passed to V4L2 ioctls.  The content of the
structures is not copied if the ioctl fails.  It blocks ability to obtain any
information about occurred error other then errno code. This patch fix this
issue.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-ioctl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 543405b..9f54114 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -2490,8 +2490,6 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 			err = -EFAULT;
 		goto out_array_args;
 	}
-	if (err < 0)
-		goto out;
 
 out_array_args:
 	/*  Copy results into user buffer  */
-- 
1.7.6

