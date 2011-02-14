Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58187 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab1BNMVp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v2 1/6] v4l: subdev: Generic ioctl support
Date: Mon, 14 Feb 2011 13:21:25 +0100
Message-Id: <1297686090-9762-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686090-9762-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686090-9762-1-git-send-email-laurent.pinchart@ideasonboard.com>
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
index 77d96f4..f2df31b 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -405,6 +405,11 @@ VIDIOC_UNSUBSCRIBE_EVENT
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
index b4c4640..79da7ec 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -276,7 +276,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	}
 #endif
 	default:
-		return -ENOIOCTLCMD;
+		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
 	}
 
 	return 0;
-- 
1.7.3.4

