Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16339 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752930AbdCIL2a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 06:28:30 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 8/9] docs-rst: media: Switch documentation to V4L2 fwnode API
Date: Thu,  9 Mar 2017 13:25:28 +0200
Message-Id: <1489058728-15475-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1486992496-21078-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1486992496-21078-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of including the V4L2 OF header in ReST documentation, use the
V4L2 fwnode header instead.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---

This goes before patch "[PATCH 8/8] v4l: Remove V4L2 OF framework in
favour of V4L2 fwnode framework".

 Documentation/media/kapi/v4l2-core.rst   | 2 +-
 Documentation/media/kapi/v4l2-fwnode.rst | 3 +++
 Documentation/media/kapi/v4l2-of.rst     | 3 ---
 3 files changed, 4 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/media/kapi/v4l2-fwnode.rst
 delete mode 100644 Documentation/media/kapi/v4l2-of.rst

diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
index e967715..1bc8a14 100644
--- a/Documentation/media/kapi/v4l2-core.rst
+++ b/Documentation/media/kapi/v4l2-core.rst
@@ -19,7 +19,7 @@ Video2Linux devices
     v4l2-mc
     v4l2-mediabus
     v4l2-mem2mem
-    v4l2-of
+    v4l2-fwnode
     v4l2-rect
     v4l2-tuner
     v4l2-common
diff --git a/Documentation/media/kapi/v4l2-fwnode.rst b/Documentation/media/kapi/v4l2-fwnode.rst
new file mode 100644
index 0000000..4128c12
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-fwnode.rst
@@ -0,0 +1,3 @@
+V4L2 fwnode kAPI
+^^^^^^^^^^^^^^^^^^^^^^^
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
