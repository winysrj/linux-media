Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:31463 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbeIYQVd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 12:21:33 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, tfiga@chromium.org, bingbu.cao@intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        tian.shu.qiu@intel.com, ricardo.ribalda@gmail.com,
        grundler@chromium.org, ping-chung.chen@intel.com,
        andy.yeh@intel.com, jim.lai@intel.com, helmut.grohne@intenta.de,
        laurent.pinchart@ideasonboard.com, snawrocki@kernel.org
Subject: [PATCH 3/5] Documentation: media: Document control exponential bases, units, prefixes
Date: Tue, 25 Sep 2018 13:14:32 +0300
Message-Id: <20180925101434.20327-4-sakari.ailus@linux.intel.com>
In-Reply-To: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
References: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document V4L2 control exponential bases, units and prefixes, as well as
the control flag telling a control value is an exponent.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst |   2 +
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  | 152 ++++++++++++++++++++-
 Documentation/media/videodev2.h.rst.exceptions     |  22 +++
 3 files changed, 175 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 9f7312bf33651..8461fd92d1b9e 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -3460,6 +3460,8 @@ Image Process Control IDs
     by selecting the desired horizontal and vertical blanking. The unit
     of this control is Hz.
 
+.. _v4l2_cid_pixel_rate:
+
 ``V4L2_CID_PIXEL_RATE (64-bit integer)``
     Pixel rate in the source pads of the subdev. This control is
     read-only and its unit is pixels / second.
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index ff2d131223b84..472378f5d7566 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -269,8 +269,22 @@ See also the examples in :ref:`control`.
       - ``dims[V4L2_CTRL_MAX_DIMS]``
       - The size of each dimension. The first ``nr_of_dims`` elements of
 	this array must be non-zero, all remaining elements must be zero.
+    * - __u8
+      - ``base``
+      - The exponential base of the control value. Valid only if the
+	:ref:`V4L2_CTRL_FLAG_EXPONENTIAL <FLAG_EXPONENTIAL>` control flag is
+	set. This is an enumeration.
+    * - __u8
+      - ``prefix``
+      - Prefix of the unit. This is an enumeration.
+    * - __u16
+      - ``unit``
+      - Unit of the value. Together with the ``prefix`` as well as the ``base``
+	field (if :ref:`V4L2_CTRL_FLAG_EXPONENTIAL <FLAG_EXPONENTIAL>` is set),
+	defines the relation between the control value and the property of the
+	hardware being controlled. This is an enumeration.
     * - __u32
-      - ``reserved``\ [32]
+      - ``reserved``\ [31]
       - Reserved for future extensions. Applications and drivers must set
 	the array to zero.
 
@@ -523,6 +537,142 @@ See also the examples in :ref:`control`.
 	streaming is in progress since most drivers do not support changing
 	the format in that case.
 
+    * .. _FLAG_EXPONENTIAL:
+
+      - ``V4L2_CTRL_FLAG_EXPONENTIAL``
+      - 0x00000800
+
+      - The value of the control has an exponential relation to the feature
+	being controled instead of a linear relation. In other words, the value
+	of the control is an exponent of the base specified in the
+        base field in &struct v4l2_query_ext_ctrl.
+
+
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
+.. _control-bases:
+
+.. cssclass:: longtable
+
+.. flat-table:: Control Exponential Bases
+    :header-rows:  1
+    :stub-columns: 0
+    :widths:       3 1 4
+
+    * - Base Name
+      - Value
+      - Description
+
+    * - ``V4L2_CTRL_BASE_UNDEFINED``
+      - 0
+      - The control exponential base is not defined.
+
+    * - ``V4L2_CTRL_BASE_LINEAR``
+      - 1
+      - The control is linear.
+
+    * - ``V4L2_CTRL_BASE_2``
+      - 2
+      - The base of the control is 2.
+
+    * - ``V4L2_CTRL_BASE_10``
+      - 10
+      - The base of the control is 10.
+
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
+.. _control-prefixes:
+
+.. cssclass:: longtable
+
+.. flat-table:: Control Prefixes
+    :header-rows:  1
+    :stub-columns: 0
+    :widths:       3 1 4
+
+    * - Prefix Name
+      - Value
+      - Description
+
+    * - ``V4L2_CTRL_PREFIX_NANO``
+      - -9
+      - Nano
+
+    * - ``V4L2_CTRL_PREFIX_MICRO``
+      - -6
+      - Micro
+
+    * - ``V4L2_CTRL_PREFIX_MILLI``
+      - -3
+      - Milli
+
+    * - ``V4L2_CTRL_PREFIX_1``
+      - 0
+      - \-
+
+    * - ``V4L2_CTRL_PREFIX_KILO``
+      - 3
+      - Kilo
+
+    * - ``V4L2_CTRL_PREFIX_MEGA``
+      - 6
+      - Mega
+
+    * - ``V4L2_CTRL_PREFIX_GIGA``
+      - 9
+      - Giga
+
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
+.. _control-units:
+
+.. cssclass:: longtable
+
+.. flat-table:: Control Units
+    :header-rows:  1
+    :stub-columns: 0
+    :widths:       3 1 4
+
+    * - Unit Name
+      - Value
+      - Description
+
+    * - ``V4L2_CTRL_UNIT_UNDEFINED``
+      - 0
+      - The unit of the control is not defined.
+
+    * - ``V4L2_CTRL_UNIT_NONE``
+      - 1
+      - The control has no unit.
+
+    * - ``V4L2_CTRL_UNIT_SECOND``
+      - 2
+      - Second
+
+    * - ``V4L2_CTRL_UNIT_AMPERE``
+      - 3
+      - Ampère
+
+    * - ``V4L2_CTRL_UNIT_LINE``
+      - 4
+      - A line of pixels in sensor's pixel matrix. This is a unit of time
+        commonly used by camera sensors in e.g. exposure control, i.e. the time
+        it takes for a sensor to read a line of pixels from the sensor's pixel
+	matrix. See :ref:`V4L2_CID_PIXEL_RATE <V4L2_CID_PIXEL_RATE>`.
+
+    * - ``V4L2_CTRL_UNIT_PIXEL``
+      - 5
+      - A pixel in sensor's pixel matrix. This is a unit of time commonly used
+        by camera sensors in e.g. exposure control, i.e. the time it takes for
+	a sensor to read a pixel from the sensor's pixel matrix.
+
+    * - ``V4L2_CTRL_UNIT_PIXEL``
+      - 6
+      - Pixels per second
+
+    * - ``V4L2_CTRL_UNIT_HZ
+      - 7
+      - Hertz
 
 Return Value
 ============
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index 63fa131729c09..8183a4f3554b0 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -343,11 +343,33 @@ replace define V4L2_CTRL_FLAG_VOLATILE control-flags
 replace define V4L2_CTRL_FLAG_HAS_PAYLOAD control-flags
 replace define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE control-flags
 replace define V4L2_CTRL_FLAG_MODIFY_LAYOUT control-flags
+replace define V4L2_CTRL_FLAG_EXPONENTIAL control-flags
 
 replace define V4L2_CTRL_FLAG_NEXT_CTRL control
 replace define V4L2_CTRL_FLAG_NEXT_COMPOUND control
 replace define V4L2_CID_PRIVATE_BASE control
 
+# V4L2 control bases, prefixes and units
+replace define V4L2_CTRL_BASE_UNDEFINED control-bases
+replace define V4L2_CTRL_BASE_LINEAR control-bases
+replace define V4L2_CTRL_BASE_2 control-bases
+replace define V4L2_CTRL_BASE_10 control-bases
+
+replace define V4L2_CTRL_PREFIX_NANO control-prefixes
+replace define V4L2_CTRL_PREFIX_MICRO control-prefixes
+replace define V4L2_CTRL_PREFIX_MILLI control-prefixes
+replace define V4L2_CTRL_PREFIX_1 control-prefixes
+replace define V4L2_CTRL_PREFIX_KILO control-prefixes
+replace define V4L2_CTRL_PREFIX_MEGA control-prefixes
+replace define V4L2_CTRL_PREFIX_GIGA control-prefixes
+
+replace define V4L2_CTRL_UNIT_UNDEFINED control-units
+replace define V4L2_CTRL_UNIT_NONE control-units
+replace define V4L2_CTRL_UNIT_SECOND control-units
+replace define V4L2_CTRL_UNIT_AMPERE control-units
+replace define V4L2_CTRL_UNIT_LINE control-units
+replace define V4L2_CTRL_UNIT_PIXEL control-units
+
 # V4L2 tuner
 
 replace define V4L2_TUNER_CAP_LOW tuner-capability
-- 
2.11.0
