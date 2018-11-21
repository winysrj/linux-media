Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48608 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727787AbeKVEJE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 23:09:04 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 1/1] v4l: uAPI doc: Changing frame interval won't change format
Date: Wed, 21 Nov 2018 19:33:44 +0200
Message-Id: <20181121173344.4055-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document that changing the frame interval has no effect on frame size.
While this was the assumption in the API, it was not documented as such.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/vidioc-g-parm.rst                  | 3 +++
 Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
index e831fa5512f0..c31585a7701b 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-parm.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
@@ -42,6 +42,9 @@ side. This is especially useful when using the :ref:`read() <func-read>` or
 :ref:`write() <func-write>`, which are not augmented by timestamps or sequence
 counters, and to avoid unnecessary data copying.
 
+Changing the frame interval shall never change the format. Changing the
+format, on the other hand, may change the frame interval.
+
 Further these ioctls can be used to determine the number of buffers used
 internally by a driver in read/write mode. For implications see the
 section discussing the :ref:`read() <func-read>` function.
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
index 5af0a7179941..f889c20f231c 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
@@ -63,6 +63,9 @@ doesn't match the device capabilities. They must instead modify the
 interval to match what the hardware can provide. The modified interval
 should be as close as possible to the original request.
 
+Changing the frame interval shall never change the format. Changing the
+format, on the other hand, may change the frame interval.
+
 Sub-devices that support the frame interval ioctls should implement them
 on a single pad only. Their behaviour when supported on multiple pads of
 the same sub-device is not defined.
-- 
2.11.0
