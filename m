Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36476 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969Ab0G2QHP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 12:07:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [SAMPLE v3 08/12] v4l: subdev: Generic ioctl support
Date: Thu, 29 Jul 2010 18:06:52 +0200
Message-Id: <1280419616-7658-20-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com>
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
index f7b72a9..bdcf4bb 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -401,6 +401,11 @@ VIDIOC_UNSUBSCRIBE_EVENT
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
index ad4b95e..887cd88 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -257,7 +257,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	}
 
 	default:
-		return -ENOIOCTLCMD;
+		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
 	}
 
 	return 0;
-- 
1.7.1

