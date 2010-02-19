Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:29442 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab0BSTWJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 14:22:09 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH v5 2/6] V4L: File handles: Add documentation
Date: Fri, 19 Feb 2010 21:21:56 +0200
Message-Id: <1266607320-9974-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4B7EE4A4.3080202@maxwell.research.nokia.com>
References: <4B7EE4A4.3080202@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation on using V4L2 file handles (v4l2_fh) in V4L2 drivers.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 Documentation/video4linux/v4l2-framework.txt |   36 ++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 74d677c..08f9e59 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -695,3 +695,39 @@ The better way to understand it is to take a look at vivi driver. One
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
+  Initialise the file handle.
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
+file.private_data pointer by testing the V4L2_FL_USES_V4L2_FH bit in
+video_device.flags.
-- 
1.5.6.5

