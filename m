Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31037 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753362AbdDJNDi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 09:03:38 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH v3 5/7] docs-rst: media: Sort topic list alphabetically
Date: Mon, 10 Apr 2017 16:02:54 +0300
Message-Id: <1491829376-14791-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1491829376-14791-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1491829376-14791-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bring some order by alphabetically ordering the list of topics.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/kapi/v4l2-core.rst | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
index d8f6c46..2fbf532 100644
--- a/Documentation/media/kapi/v4l2-core.rst
+++ b/Documentation/media/kapi/v4l2-core.rst
@@ -4,23 +4,23 @@ Video4Linux devices
 .. toctree::
     :maxdepth: 1
 
-    v4l2-intro
+    v4l2-clocks
+    v4l2-common
+    v4l2-controls
     v4l2-dev
     v4l2-device
-    v4l2-fh
-    v4l2-subdev
-    v4l2-event
-    v4l2-controls
-    v4l2-videobuf
-    v4l2-videobuf2
-    v4l2-clocks
     v4l2-dv-timings
+    v4l2-event
+    v4l2-fh
     v4l2-flash-led-class
+    v4l2-intro
     v4l2-mc
     v4l2-mediabus
     v4l2-mem2mem
     v4l2-of
     v4l2-rect
+    v4l2-subdev
     v4l2-tuner
-    v4l2-common
     v4l2-tveeprom
+    v4l2-videobuf
+    v4l2-videobuf2
-- 
2.7.4
