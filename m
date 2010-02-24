Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:39971 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082Ab0BXWqR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 17:46:17 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	david.cohen@nokia.com
Subject: [PATCH v8 2/6] V4L: File handles: Add documentation
Date: Thu, 25 Feb 2010 00:46:04 +0200
Message-Id: <1267051568-5757-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4B85AC1E.8060302@maxwell.research.nokia.com>
References: <4B85AC1E.8060302@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation on using V4L2 file handles (v4l2_fh) in V4L2 drivers.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 Documentation/video4linux/v4l2-framework.txt |   37 ++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 74d677c..bfaf0c5 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -695,3 +695,40 @@ The better way to understand it is to take a look at vivi driver. One
 of the main reasons for vivi is to be a videobuf usage example. the
 vivi_thread_tick() does the task that the IRQ callback would do on PCI
 drivers (or the irq callback on USB).
+
+struct v4l2_fh
+--------------
+
+struct v4l2_fh provides a way to easily keep file handle specific data
+that is used by the V4L2 framework.
+
+struct v4l2_fh is allocated as a part of the driver's own file handle
+structure and is set to file->private_data in the driver's open
+function by the driver. Drivers can extract their own file handle
+structure by using the container_of macro.
+
+Useful functions:
+
+- v4l2_fh_init()
+
+  Initialise the file handle. This *MUST* be performed in the driver's
+  v4l2_file_operations->open() handler.
+
+- v4l2_fh_add()
+
+  Add a v4l2_fh to video_device file handle list. May be called after
+  initialising the file handle.
+
+- v4l2_fh_del()
+
+  Unassociate the file handle from video_device(). The file handle
+  exit function may now be called.
+
+- v4l2_fh_exit()
+
+  Uninitialise the file handle. After uninitialisation the v4l2_fh
+  memory can be freed.
+
+The users of v4l2_fh know whether a driver uses v4l2_fh as its
+file->private_data pointer by testing the V4L2_FL_USES_V4L2_FH bit in
+video_device->flags.
-- 
1.5.6.5

