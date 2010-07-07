Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:50317 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab0GGLxo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 07:53:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH 6/6] v4l: subdev: Generic ioctl support
Date: Wed,  7 Jul 2010 13:53:28 +0200
Message-Id: <1278503608-9126-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of returning an error when receiving an ioctl call with an
unsupported command, forward the call to the subdev core::ioctl handler.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/video4linux/v4l2-framework.txt |    5 +++++
 drivers/media/video/v4l2-subdev.c            |    2 +-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 2f5162c..3a1d6b3 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -355,6 +355,11 @@ VIDIOC_UNSUBSCRIBE_EVENT
 	To properly support events, the poll() file operation is also
 	implemented.
 
+Private ioctls
+
+	All ioctls not in the above list are passed directly to the sub-device
+	driver through the core::ioctl operation.
+
 
 I2C sub-device drivers
 ----------------------
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 7191a4b..c32b2c4 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -120,7 +120,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		return v4l2_subdev_call(sd, core, unsubscribe_event, fh, arg);
 
 	default:
-		return -ENOIOCTLCMD;
+		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
 	}
 
 	return 0;
-- 
1.7.1

