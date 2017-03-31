Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:56593 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752359AbdCaI6n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 04:58:43 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Helen Koike <helen.koike@collabora.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vidioc-enumin/output.rst: improve documentation
Message-ID: <dfd64830-b66d-044d-2a40-82210a32c18a@xs4all.nl>
Date: Fri, 31 Mar 2017 10:58:39 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_INPUT_TYPE_CAMERA and V4L2_OUTPUT_TYPE_ANALOG descriptions were
hopelessly out of date. Fix this, and also fix a few style issues in these
documents. Finally add the missing documentation for V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY
(only used by the zoran driver).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Question: should we perhaps add _TYPE_VIDEO aliases?
---
diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
index 17aaaf939757..266e48ab237f 100644
--- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
@@ -33,7 +33,7 @@ Description

 To query the attributes of a video input applications initialize the
 ``index`` field of struct :c:type:`v4l2_input` and call the
-:ref:`VIDIOC_ENUMINPUT` ioctl with a pointer to this structure. Drivers
+:ref:`VIDIOC_ENUMINPUT` with a pointer to this structure. Drivers
 fill the rest of the structure or return an ``EINVAL`` error code when the
 index is out of bounds. To enumerate all inputs applications shall begin
 at index zero, incrementing by one until the driver returns ``EINVAL``.
@@ -117,8 +117,9 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
       - This input uses a tuner (RF demodulator).
     * - ``V4L2_INPUT_TYPE_CAMERA``
       - 2
-      - Analog baseband input, for example CVBS / Composite Video,
-	S-Video, RGB.
+      - Any non-tuner video input, for example Composite Video,
+	S-Video, HDMI, camera sensor. The naming as ``_TYPE_CAMERA`` is historical,
+	today we would have called it ``_TYPE_VIDEO``.
     * - ``V4L2_INPUT_TYPE_TOUCH``
       - 3
       - This input is a touch device for capturing raw touch data.
@@ -209,11 +210,11 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
     * - ``V4L2_IN_CAP_DV_TIMINGS``
       - 0x00000002
       - This input supports setting video timings by using
-	VIDIOC_S_DV_TIMINGS.
+	``VIDIOC_S_DV_TIMINGS``.
     * - ``V4L2_IN_CAP_STD``
       - 0x00000004
       - This input supports setting the TV standard by using
-	VIDIOC_S_STD.
+	``VIDIOC_S_STD``.
     * - ``V4L2_IN_CAP_NATIVE_SIZE``
       - 0x00000008
       - This input supports setting the native size using the
diff --git a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
index d7dd2742475a..93a2cf3b310c 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
@@ -33,11 +33,11 @@ Description

 To query the attributes of a video outputs applications initialize the
 ``index`` field of struct :c:type:`v4l2_output` and call
-the :ref:`VIDIOC_ENUMOUTPUT` ioctl with a pointer to this structure.
+the :ref:`VIDIOC_ENUMOUTPUT` with a pointer to this structure.
 Drivers fill the rest of the structure or return an ``EINVAL`` error code
 when the index is out of bounds. To enumerate all outputs applications
 shall begin at index zero, incrementing by one until the driver returns
-EINVAL.
+``EINVAL``.


 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
@@ -112,11 +112,12 @@ EINVAL.
       - This output is an analog TV modulator.
     * - ``V4L2_OUTPUT_TYPE_ANALOG``
       - 2
-      - Analog baseband output, for example Composite / CVBS, S-Video,
-	RGB.
+      - Any non-modulator video output, for example Composite Video,
+	S-Video, HDMI. The naming as ``_TYPE_ANALOG`` is historical,
+	today we would have called it ``_TYPE_VIDEO``.
     * - ``V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY``
       - 3
-      - [?]
+      - The video output will be copied to a :ref:`video overlay <overlay>`.



@@ -132,11 +133,11 @@ EINVAL.
     * - ``V4L2_OUT_CAP_DV_TIMINGS``
       - 0x00000002
       - This output supports setting video timings by using
-	VIDIOC_S_DV_TIMINGS.
+	``VIDIOC_S_DV_TIMINGS``.
     * - ``V4L2_OUT_CAP_STD``
       - 0x00000004
       - This output supports setting the TV standard by using
-	VIDIOC_S_STD.
+	``VIDIOC_S_STD``.
     * - ``V4L2_OUT_CAP_NATIVE_SIZE``
       - 0x00000008
       - This output supports setting the native size using the
