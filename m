Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1563 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab2A0R7Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 12:59:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] v4l2-subdev: add start/end messages for log_status.
Date: Fri, 27 Jan 2012 18:59:13 +0100
Message-Id: <c1defdd2987632735933eb5d0d65f4dec2639a23.1327686924.git.hans.verkuil@cisco.com>
In-Reply-To: <1327687153-14757-1-git-send-email-hverkuil@xs4all.nl>
References: <1327687153-14757-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1844c31eb7b4515904824a6b26994f7bdd7eace8.1327686924.git.hans.verkuil@cisco.com>
References: <1844c31eb7b4515904824a6b26994f7bdd7eace8.1327686924.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add the start and end messages for log_status when called from a
subdev device node.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-subdev.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 41d118e..07e39c3 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -194,8 +194,18 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	}
 #endif
 
-	case VIDIOC_LOG_STATUS:
-		return v4l2_subdev_call(sd, core, log_status);
+	case VIDIOC_LOG_STATUS: {
+		int ret;
+
+		printk(KERN_INFO
+			"%s: =================  START STATUS  =================\n",
+			sd->name);
+		ret = v4l2_subdev_call(sd, core, log_status);
+		printk(KERN_INFO
+			"%s: ==================  END STATUS  ==================\n",
+			sd->name);
+		return ret;
+	}
 
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	case VIDIOC_SUBDEV_G_FMT: {
-- 
1.7.8.3

