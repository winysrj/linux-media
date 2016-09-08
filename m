Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44004 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965410AbcIHMEW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 18/47] [media] docs-rst: use C domain for enum references on uapi
Date: Thu,  8 Sep 2016 09:03:40 -0300
Message-Id: <1f49c93a0c50c9a293aee22e9212ff64bed590d1.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the parse-headers.pl and the corresponding files to use
the C domain for enum references.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/hist-v4l2.rst           |  2 +-
 Documentation/media/uapi/v4l/subdev-formats.rst      |  2 +-
 Documentation/media/uapi/v4l/v4l2.rst                |  2 +-
 Documentation/media/uapi/v4l/vidioc-dqevent.rst      |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-priority.rst   |  2 +-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst    | 14 +++++++-------
 Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst | 10 +++++-----
 include/media/v4l2-dev.h                             | 12 ++++++------
 8 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/Documentation/media/uapi/v4l/hist-v4l2.rst b/Documentation/media/uapi/v4l/hist-v4l2.rst
index a84895968349..bd45431ed00e 100644
--- a/Documentation/media/uapi/v4l/hist-v4l2.rst
+++ b/Documentation/media/uapi/v4l/hist-v4l2.rst
@@ -1361,7 +1361,7 @@ V4L2 in Linux 3.19
    :ref:`v4l2_quantization <v4l2-quantization>` fields to struct
    :c:type:`v4l2_pix_format`, struct
    :c:type:`v4l2_pix_format_mplane` and
-   struct :ref:`v4l2_mbus_framefmt <v4l2-mbus-framefmt>`.
+   struct :c:type:`v4l2_mbus_framefmt`.
 
 
 V4L2 in Linux 4.4
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 52013b55ea80..f0d7754f1906 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -7,7 +7,7 @@ Media Bus Formats
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-mbus-framefmt:
+.. c:type:: v4l2_mbus_framefmt
 
 .. flat-table:: struct v4l2_mbus_framefmt
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
index 785d4cdd2f85..e020c57f98d4 100644
--- a/Documentation/media/uapi/v4l/v4l2.rst
+++ b/Documentation/media/uapi/v4l/v4l2.rst
@@ -116,7 +116,7 @@ Rewrote Colorspace chapter, added new enum
 :ref:`v4l2_quantization <v4l2-quantization>` fields to struct
 :c:type:`v4l2_pix_format`, struct
 :c:type:`v4l2_pix_format_mplane` and struct
-:ref:`v4l2_mbus_framefmt <v4l2-mbus-framefmt>`.
+:c:type:`v4l2_mbus_framefmt`.
 
 
 :revision: 3.17 / 2014-08-04 (*lp, hv*)
diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index cf0e98f5112f..3038f349049c 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -356,7 +356,7 @@ call.
 
        -
        -  The type of the control. See enum
-	  :ref:`v4l2_ctrl_type <v4l2-ctrl-type>`.
+	  :c:type:`v4l2_ctrl_type`.
 
     -  .. row 3
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-priority.rst b/Documentation/media/uapi/v4l/vidioc-g-priority.rst
index d6a07c076837..cbd2a3cbb18e 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-priority.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-priority.rst
@@ -44,7 +44,7 @@ an enum v4l2_priority variable and call :ref:`VIDIOC_S_PRIORITY <VIDIOC_G_PRIORI
 with a pointer to this variable.
 
 
-.. _v4l2-priority:
+.. c:type:: v4l2_priority
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index ef32e28e57c7..1a798be69e10 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -142,7 +142,7 @@ See also the examples in :ref:`control`.
        -  ``minimum``
 
        -  Minimum value, inclusive. This field gives a lower bound for the
-	  control. See enum :ref:`v4l2_ctrl_type <v4l2-ctrl-type>` how
+	  control. See enum :c:type:`v4l2_ctrl_type` how
 	  the minimum value is to be used for each possible control type.
 	  Note that this a signed 32-bit value.
 
@@ -153,7 +153,7 @@ See also the examples in :ref:`control`.
        -  ``maximum``
 
        -  Maximum value, inclusive. This field gives an upper bound for the
-	  control. See enum :ref:`v4l2_ctrl_type <v4l2-ctrl-type>` how
+	  control. See enum :c:type:`v4l2_ctrl_type` how
 	  the maximum value is to be used for each possible control type.
 	  Note that this a signed 32-bit value.
 
@@ -164,7 +164,7 @@ See also the examples in :ref:`control`.
        -  ``step``
 
        -  This field gives a step size for the control. See enum
-	  :ref:`v4l2_ctrl_type <v4l2-ctrl-type>` how the step value is
+	  :c:type:`v4l2_ctrl_type` how the step value is
 	  to be used for each possible control type. Note that this an
 	  unsigned 32-bit value.
 
@@ -269,7 +269,7 @@ See also the examples in :ref:`control`.
        -  ``minimum``
 
        -  Minimum value, inclusive. This field gives a lower bound for the
-	  control. See enum :ref:`v4l2_ctrl_type <v4l2-ctrl-type>` how
+	  control. See enum :c:type:`v4l2_ctrl_type` how
 	  the minimum value is to be used for each possible control type.
 	  Note that this a signed 64-bit value.
 
@@ -280,7 +280,7 @@ See also the examples in :ref:`control`.
        -  ``maximum``
 
        -  Maximum value, inclusive. This field gives an upper bound for the
-	  control. See enum :ref:`v4l2_ctrl_type <v4l2-ctrl-type>` how
+	  control. See enum :c:type:`v4l2_ctrl_type` how
 	  the maximum value is to be used for each possible control type.
 	  Note that this a signed 64-bit value.
 
@@ -291,7 +291,7 @@ See also the examples in :ref:`control`.
        -  ``step``
 
        -  This field gives a step size for the control. See enum
-	  :ref:`v4l2_ctrl_type <v4l2-ctrl-type>` how the step value is
+	  :c:type:`v4l2_ctrl_type` how the step value is
 	  to be used for each possible control type. Note that this an
 	  unsigned 64-bit value.
 
@@ -456,7 +456,7 @@ See also the examples in :ref:`control`.
 
 .. tabularcolumns:: |p{5.8cm}|p{1.4cm}|p{1.0cm}|p{1.4cm}|p{6.9cm}|
 
-.. _v4l2-ctrl-type:
+.. c:type:: v4l2_ctrl_type
 
 .. cssclass:: longtable
 
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
index 2df1342ac6ea..90d876faa5b9 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
@@ -38,7 +38,7 @@ These ioctls are used to negotiate the frame format at specific subdev
 pads in the image pipeline.
 
 To retrieve the current format applications set the ``pad`` field of a
-struct :ref:`v4l2_subdev_format <v4l2-subdev-format>` to the desired
+struct :c:type:`v4l2_subdev_format` to the desired
 pad number as reported by the media API and the ``which`` field to
 ``V4L2_SUBDEV_FORMAT_ACTIVE``. When they call the
 ``VIDIOC_SUBDEV_G_FMT`` ioctl with a pointer to this structure the
@@ -49,7 +49,7 @@ To change the current format applications set both the ``pad`` and
 the ``VIDIOC_SUBDEV_S_FMT`` ioctl with a pointer to this structure the
 driver verifies the requested format, adjusts it based on the hardware
 capabilities and configures the device. Upon return the struct
-:ref:`v4l2_subdev_format <v4l2-subdev-format>` contains the current
+:c:type:`v4l2_subdev_format` contains the current
 format as would be returned by a ``VIDIOC_SUBDEV_G_FMT`` call.
 
 Applications can query the device capabilities by setting the ``which``
@@ -78,7 +78,7 @@ should be as close as possible to the original request.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-subdev-format:
+.. c:type:: v4l2_subdev_format
 
 .. flat-table:: struct v4l2_subdev_format
     :header-rows:  0
@@ -105,7 +105,7 @@ should be as close as possible to the original request.
 
     -  .. row 3
 
-       -  struct :ref:`v4l2_mbus_framefmt <v4l2-mbus-framefmt>`
+       -  struct :c:type:`v4l2_mbus_framefmt`
 
        -  ``format``
 
@@ -164,7 +164,7 @@ EBUSY
     fix the problem first. Only returned by ``VIDIOC_SUBDEV_S_FMT``
 
 EINVAL
-    The struct :ref:`v4l2_subdev_format <v4l2-subdev-format>`
+    The struct :c:type:`v4l2_subdev_format`
     ``pad`` references a non-existing pad, or the ``which`` field
     references a non-existing format.
 
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 5272aeec0cec..477e90d89a04 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -56,7 +56,7 @@ struct v4l2_ctrl_handler;
  *
  * .. note::
  *    The size of @prios array matches the number of priority types defined
- *    by :ref:`enum v4l2_priority <v4l2-priority>`.
+ *    by enum &v4l2_priority.
  */
 struct v4l2_prio_state {
 	atomic_t prios[4];
@@ -73,8 +73,8 @@ void v4l2_prio_init(struct v4l2_prio_state *global);
  * v4l2_prio_change - changes the v4l2 file handler priority
  *
  * @global: pointer to the &struct v4l2_prio_state of the device node.
- * @local: pointer to the desired priority, as defined by :ref:`enum v4l2_priority <v4l2-priority>`
- * @new: Priority type requested, as defined by :ref:`enum v4l2_priority <v4l2-priority>`.
+ * @local: pointer to the desired priority, as defined by enum &v4l2_priority
+ * @new: Priority type requested, as defined by enum &v4l2_priority.
  *
  * .. note::
  *	This function should be used only by the V4L2 core.
@@ -86,7 +86,7 @@ int v4l2_prio_change(struct v4l2_prio_state *global, enum v4l2_priority *local,
  * v4l2_prio_open - Implements the priority logic for a file handler open
  *
  * @global: pointer to the &struct v4l2_prio_state of the device node.
- * @local: pointer to the desired priority, as defined by :ref:`enum v4l2_priority <v4l2-priority>`
+ * @local: pointer to the desired priority, as defined by enum &v4l2_priority
  *
  * .. note::
  *	This function should be used only by the V4L2 core.
@@ -97,7 +97,7 @@ void v4l2_prio_open(struct v4l2_prio_state *global, enum v4l2_priority *local);
  * v4l2_prio_close - Implements the priority logic for a file handler close
  *
  * @global: pointer to the &struct v4l2_prio_state of the device node.
- * @local: priority to be released, as defined by :ref:`enum v4l2_priority <v4l2-priority>`
+ * @local: priority to be released, as defined by enum &v4l2_priority
  *
  * .. note::
  *	This function should be used only by the V4L2 core.
@@ -118,7 +118,7 @@ enum v4l2_priority v4l2_prio_max(struct v4l2_prio_state *global);
  * v4l2_prio_close - Implements the priority logic for a file handler close
  *
  * @global: pointer to the &struct v4l2_prio_state of the device node.
- * @local: desired priority, as defined by :ref:`enum v4l2_priority <v4l2-priority>` local
+ * @local: desired priority, as defined by enum &v4l2_priority local
  *
  * .. note::
  *	This function should be used only by the V4L2 core.
-- 
2.7.4


