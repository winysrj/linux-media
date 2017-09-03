Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50958
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752859AbdICCfL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Sep 2017 22:35:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hansverk@cisco.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Aviv Greenberg <aviv.d.greenberg@intel.com>
Subject: [PATCH 04/12] media: v4l uAPI docs: adjust some tables for PDF output
Date: Sat,  2 Sep 2017 23:34:56 -0300
Message-Id: <6f6b0f6ddbcd2ee028487e6bd7c0518023154e31.1504405125.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On tests with Spinx 1.4, some tables are still writing text
outside cells. Adjust those tables.

PS.: As this was revisited several times, I suspect that this
will only be fully fixed if we add tabularcolumns to all tables
at the V4L2 part of the book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/colorspaces-defs.rst       | 2 ++
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst        | 2 +-
 Documentation/media/uapi/v4l/v4l2-selection-targets.rst | 2 +-
 Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst | 2 ++
 Documentation/media/uapi/v4l/vidioc-querycap.rst        | 2 +-
 Documentation/media/uapi/v4l/vidioc-subscribe-event.rst | 4 ++--
 6 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/uapi/v4l/colorspaces-defs.rst b/Documentation/media/uapi/v4l/colorspaces-defs.rst
index e67ed1e0b3fa..410907fe9415 100644
--- a/Documentation/media/uapi/v4l/colorspaces-defs.rst
+++ b/Documentation/media/uapi/v4l/colorspaces-defs.rst
@@ -76,6 +76,8 @@ whole range, 0-255, dividing the angular value by 1.41. The enum
 
 .. c:type:: v4l2_xfer_func
 
+.. tabularcolumns:: |p{5.5cm}|p{12.0cm}|
+
 .. flat-table:: V4L2 Transfer Function
     :header-rows:  1
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
index 86cd07e5bfa3..9e52610aa954 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
@@ -36,7 +36,7 @@ Each cell is one byte.
 
 .. raw:: latex
 
-    \small
+    \newline\small
 
 .. tabularcolumns:: |p{2.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{10.0cm}|
 
diff --git a/Documentation/media/uapi/v4l/v4l2-selection-targets.rst b/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
index cab07de6f4da..87433ec76c6b 100644
--- a/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
+++ b/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
@@ -12,7 +12,7 @@ of the two interfaces they are used.
 
 .. _v4l2-selection-targets-table:
 
-.. tabularcolumns:: |p{5.8cm}|p{1.4cm}|p{6.5cm}|p{1.2cm}|p{1.6cm}|
+.. tabularcolumns:: |p{6.0cm}|p{1.4cm}|p{7.4cm}|p{1.2cm}|p{1.4cm}|
 
 .. flat-table:: Selection target definitions
     :header-rows:  1
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
index 8fcc46d307d5..6de117f163e0 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
@@ -140,6 +140,8 @@ application should zero out all members except for the *IN* fields.
 
 .. c:type:: v4l2_frmsizeenum
 
+.. tabularcolumns:: |p{1.4cm}|p{5.9cm}|p{2.3cm}|p{8.0cm}|
+
 .. flat-table:: struct v4l2_frmsizeenum
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 7553b44692b4..66fb1b3d6e6e 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -133,7 +133,7 @@ specification the ioctl returns an ``EINVAL`` error code.
 
 
 
-.. tabularcolumns:: |p{6cm}|p{2.2cm}|p{8.8cm}|
+.. tabularcolumns:: |p{6.1cm}|p{2.2cm}|p{8.7cm}|
 
 .. _device-capabilities:
 
diff --git a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
index a95cbf2a126d..b521efa53ceb 100644
--- a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
@@ -40,7 +40,7 @@ Subscribe or unsubscribe V4L2 event. Subscribed events are dequeued by
 using the :ref:`VIDIOC_DQEVENT` ioctl.
 
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+.. tabularcolumns:: |p{4.6cm}|p{4.4cm}|p{8.7cm}|
 
 .. c:type:: v4l2_event_subscription
 
@@ -73,7 +73,7 @@ using the :ref:`VIDIOC_DQEVENT` ioctl.
 
 
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+.. tabularcolumns:: |p{6.8cm}|p{2.2cm}|p{8.5cm}|
 
 .. _event-flags:
 
-- 
2.13.5
