Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33360 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751363AbdILImk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 04:42:40 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v11 04/24] v4l: async: Add V4L2 async documentation to the documentation build
Date: Tue, 12 Sep 2017 11:42:16 +0300
Message-Id: <20170912084236.1154-5-sakari.ailus@linux.intel.com>
In-Reply-To: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 async wasn't part of the documentation build. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/media/kapi/v4l2-async.rst | 3 +++
 Documentation/media/kapi/v4l2-core.rst  | 1 +
 2 files changed, 4 insertions(+)
 create mode 100644 Documentation/media/kapi/v4l2-async.rst

diff --git a/Documentation/media/kapi/v4l2-async.rst b/Documentation/media/kapi/v4l2-async.rst
new file mode 100644
index 000000000000..523ff9eb09a0
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-async.rst
@@ -0,0 +1,3 @@
+V4L2 async kAPI
+^^^^^^^^^^^^^^^
+.. kernel-doc:: include/media/v4l2-async.h
diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
index c7434f38fd9c..5cf292037a48 100644
--- a/Documentation/media/kapi/v4l2-core.rst
+++ b/Documentation/media/kapi/v4l2-core.rst
@@ -19,6 +19,7 @@ Video4Linux devices
     v4l2-mc
     v4l2-mediabus
     v4l2-mem2mem
+    v4l2-async
     v4l2-fwnode
     v4l2-rect
     v4l2-tuner
-- 
2.11.0
