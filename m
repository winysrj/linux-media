Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4550 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab2BBL5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 06:57:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 2/6] v4l2-subdev: add start/end messages for log_status.
Date: Thu,  2 Feb 2012 12:56:32 +0100
Message-Id: <5dc424690702cb423288fe9b1e30f7ad225fc6e5.1328183271.git.hans.verkuil@cisco.com>
In-Reply-To: <1328183796-3168-1-git-send-email-hverkuil@xs4all.nl>
References: <1328183796-3168-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <71ef01f774221fd98c5d3e5a0dc4613dc928d967.1328183271.git.hans.verkuil@cisco.com>
References: <71ef01f774221fd98c5d3e5a0dc4613dc928d967.1328183271.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add the start and end messages for log_status when called from a
subdev device node.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-subdev.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 41d118e..6fe88e9 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -194,8 +194,16 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	}
 #endif
 
-	case VIDIOC_LOG_STATUS:
-		return v4l2_subdev_call(sd, core, log_status);
+	case VIDIOC_LOG_STATUS: {
+		int ret;
+
+		pr_info("%s: =================  START STATUS  =================\n",
+			sd->name);
+		ret = v4l2_subdev_call(sd, core, log_status);
+		pr_info("%s: ==================  END STATUS  ==================\n",
+			sd->name);
+		return ret;
+	}
 
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	case VIDIOC_SUBDEV_G_FMT: {
-- 
1.7.8.3

