Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:62581 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbeH1LxW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 07:53:22 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: linux-media@vger.kernel.org
Cc: Philippe De Muyter <phdm@macqel.be>
Subject: [PATCH] media: v4l2-subdev.h: allow V4L2_FRMIVAL_TYPE_CONTINUOUS & _STEPWISE
Date: Tue, 28 Aug 2018 09:55:07 +0200
Message-Id: <1535442907-8659-1-git-send-email-phdm@macqel.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add max_interval and step_interval to struct
v4l2_subdev_frame_interval_enum.

When filled correctly by the sensor driver, those fields must be
used as follows by the intermediate level :

        struct v4l2_frmivalenum *fival;
        struct v4l2_subdev_frame_interval_enum fie;

        if (fie.max_interval.numerator == 0) {
                fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
                fival->discrete = fie.interval;
        } else if (fie.step_interval.numerator == 0) {
                fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
                fival->stepwise.min = fie.interval;
                fival->stepwise.max = fie.max_interval;
        } else {
                fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
                fival->stepwise.min = fie.interval;
                fival->stepwise.max = fie.max_interval;
                fival->stepwise.step = fie.step_interval;
        }

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
---
 .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst | 39 +++++++++++++++++++++-
 include/uapi/linux/v4l2-subdev.h                   |  4 ++-
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
index 1bfe386..acc516e 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -51,6 +51,37 @@ EINVAL error code if one of the input fields is invalid. All frame
 intervals are enumerable by beginning at index zero and incrementing by
 one until ``EINVAL`` is returned.
 
+If the sub-device can work only at the fixed set of frame intervals,
+driver must enumerate them with increasing indexes, by only filling
+the ``interval`` field.  If the sub-device can work with a continuous
+range of frame intervals, driver must only return success for index 0
+and fill ``interval`` with the minimum interval, ``max_interval`` with
+the maximum interval, and ``step_interval`` with 0 or the step between
+the possible intervals.
+
+Callers are expected to use the returned information as follows :
+
+.. code-block:: c
+
+        struct v4l2_frmivalenum * fival;
+        struct v4l2_subdev_frame_interval_enum fie;
+
+        if (fie.max_interval.numerator == 0) {
+                fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+                fival->discrete = fie.interval;
+        } else if (fie.step_interval.numerator == 0) {
+                fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
+                fival->stepwise.min = fie.interval;
+                fival->stepwise.max = fie.max_interval;
+        } else {
+                fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
+                fival->stepwise.min = fie.interval;
+                fival->stepwise.max = fie.max_interval;
+                fival->stepwise.step = fie.step_interval;
+        }
+
+.. code-block:: c
+
 Available frame intervals may depend on the current 'try' formats at
 other pads of the sub-device, as well as on the current active links.
 See :ref:`VIDIOC_SUBDEV_G_FMT` for more
@@ -92,8 +123,14 @@ multiple pads of the same sub-device is not defined.
       - ``which``
       - Frame intervals to be enumerated, from enum
 	:ref:`v4l2_subdev_format_whence <v4l2-subdev-format-whence>`.
+    * - struct :c:type:`v4l2_fract`
+      - ``max_interval``
+      - Maximum period, in seconds, between consecutive video frames, or 0.
+    * - struct :c:type:`v4l2_fract`
+      - ``step_interval``
+      - Frame interval step size, in seconds, or 0.
     * - __u32
-      - ``reserved``\ [8]
+      - ``reserved``\ [4]
       - Reserved for future extensions. Applications and drivers must set
 	the array to zero.
 
diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index 03970ce..c944644 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -128,7 +128,9 @@ struct v4l2_subdev_frame_interval_enum {
 	__u32 height;
 	struct v4l2_fract interval;
 	__u32 which;
-	__u32 reserved[8];
+	struct v4l2_fract max_interval;
+	struct v4l2_fract step_interval;
+	__u32 reserved[4];
 };
 
 /**
-- 
1.8.4
