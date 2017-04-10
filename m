Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:36561 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753205AbdDJNEH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 09:04:07 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH v3 6/7] docs-rst: media: Switch documentation to V4L2 fwnode API
Date: Mon, 10 Apr 2017 16:02:55 +0300
Message-Id: <1491829376-14791-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1491829376-14791-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1491829376-14791-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of including the V4L2 OF header in ReST documentation, use the
V4L2 fwnode header instead.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/media/kapi/v4l2-core.rst   | 2 +-
 Documentation/media/kapi/v4l2-fwnode.rst | 3 +++
 Documentation/media/kapi/v4l2-of.rst     | 3 ---
 3 files changed, 4 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/media/kapi/v4l2-fwnode.rst
 delete mode 100644 Documentation/media/kapi/v4l2-of.rst

diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
index 2fbf532..11c3eca 100644
--- a/Documentation/media/kapi/v4l2-core.rst
+++ b/Documentation/media/kapi/v4l2-core.rst
@@ -13,11 +13,11 @@ Video4Linux devices
     v4l2-event
     v4l2-fh
     v4l2-flash-led-class
+    v4l2-fwnode
     v4l2-intro
     v4l2-mc
     v4l2-mediabus
     v4l2-mem2mem
-    v4l2-of
     v4l2-rect
     v4l2-subdev
     v4l2-tuner
diff --git a/Documentation/media/kapi/v4l2-fwnode.rst b/Documentation/media/kapi/v4l2-fwnode.rst
new file mode 100644
index 0000000..6c8bccd
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-fwnode.rst
@@ -0,0 +1,3 @@
+V4L2 fwnode kAPI
+^^^^^^^^^^^^^^^^
+.. kernel-doc:: include/media/v4l2-fwnode.h
diff --git a/Documentation/media/kapi/v4l2-of.rst b/Documentation/media/kapi/v4l2-of.rst
deleted file mode 100644
index 1ddf76b..0000000
--- a/Documentation/media/kapi/v4l2-of.rst
+++ /dev/null
@@ -1,3 +0,0 @@
-V4L2 Open Firmware kAPI
-^^^^^^^^^^^^^^^^^^^^^^^
-.. kernel-doc:: include/media/v4l2-of.h
-- 
2.7.4
