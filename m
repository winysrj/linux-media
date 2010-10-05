Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60205 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab0JENSn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 09:18:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v2 1/6] v4l: subdev: Generic ioctl support
Date: Tue,  5 Oct 2010 15:18:50 +0200
Message-Id: <1286284734-12292-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286284734-12292-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286284734-12292-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Instead of returning an error when receiving an ioctl call with an
unsupported command, forward the call to the subdev core::ioctl handler.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/video4linux/v4l2-framework.txt |    5 +++++
 drivers/media/video/v4l2-subdev.c            |    2 +-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 3416d93..21bb837 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -402,6 +402,11 @@ VIDIOC_UNSUBSCRIBE_EVENT
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
index a37b537..096644d 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -258,7 +258,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	}
 
 	default:
-		return -ENOIOCTLCMD;
+		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
 	}
 
 	return 0;
-- 
1.7.2.2

