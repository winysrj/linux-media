Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40544 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751353AbdFZJ0d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 05:26:33 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 1/1] docs-rst: Document EBUSY for VIDIOC_S_FMT
Date: Mon, 26 Jun 2017 12:26:24 +0300
Message-Id: <1498469184-13280-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_S_FMT may return EBUSY if the device is streaming or there are
buffers allocated. Document this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
index b853e48..d082f9a 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
@@ -147,3 +147,9 @@ appropriately. The generic error codes are described at the
 EINVAL
     The struct :c:type:`v4l2_format` ``type`` field is
     invalid or the requested buffer type not supported.
+
+EBUSY
+    The device is busy and cannot change the format. This could be
+    because or the device is streaming or buffers are allocated or
+    queued to the driver. Relevant for :ref:`VIDIOC_S_FMT
+    <VIDIOC_G_FMT>` only.
-- 
2.1.4
