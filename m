Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:47457 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752386AbeENL2M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 07:28:12 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2 2/5] media: docs: clarify relationship between crop and selection APIs
Date: Mon, 14 May 2018 13:27:24 +0200
Message-Id: <1526297247-20881-2-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1526297247-20881-1-git-send-email-luca@lucaceresoli.net>
References: <1526297247-20881-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Having two somewhat similar and largely overlapping APIs is confusing,
especially since the older one appears in the docs before the newer
and most featureful counterpart.

Clarify all of this in several ways:
 - swap the two sections
 - give a name to the two APIs in the section names
 - add a note at the beginning of the CROP API section
 - update note about VIDIOC_CROPCAP

Also remove a note that is incorrect (correct wording is in
vidioc-cropcap.rst).

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Based on info from: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hverkuil@xs4all.nl>

---

Changed v1 -> v2:
 - Don't remove the note about VIDIOC_CROPCAP being mandatory, update
   it (Hans)
---
 Documentation/media/uapi/v4l/common.rst            |  2 +-
 Documentation/media/uapi/v4l/crop.rst              | 22 +++++++++++++++-------
 Documentation/media/uapi/v4l/selection-api-005.rst |  2 ++
 Documentation/media/uapi/v4l/selection-api.rst     |  4 ++--
 4 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/Documentation/media/uapi/v4l/common.rst b/Documentation/media/uapi/v4l/common.rst
index 13f2ed3fc5a6..5f93e71122ef 100644
--- a/Documentation/media/uapi/v4l/common.rst
+++ b/Documentation/media/uapi/v4l/common.rst
@@ -41,6 +41,6 @@ applicable to all devices.
     extended-controls
     format
     planar-apis
-    crop
     selection-api
+    crop
     streaming-par
diff --git a/Documentation/media/uapi/v4l/crop.rst b/Documentation/media/uapi/v4l/crop.rst
index 182565b9ace4..45e8a895a320 100644
--- a/Documentation/media/uapi/v4l/crop.rst
+++ b/Documentation/media/uapi/v4l/crop.rst
@@ -2,9 +2,18 @@
 
 .. _crop:
 
-*************************************
-Image Cropping, Insertion and Scaling
-*************************************
+*****************************************************
+Image Cropping, Insertion and Scaling -- the CROP API
+*****************************************************
+
+.. note::
+
+   The CROP API is mostly superseded by the newer :ref:`SELECTION API
+   <selection-api>`. The new API should be preferred in most cases,
+   with the exception of pixel aspect ratio detection, which is
+   implemented by :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` and has no
+   equivalent in the SELECTION API. See :ref:`selection-vs-crop` for a
+   comparison of the two APIs.
 
 Some video capture devices can sample a subsection of the picture and
 shrink or enlarge it to an image of arbitrary size. We call these
@@ -42,10 +51,9 @@ where applicable) will be fixed in this case.
 
 .. note::
 
-   All capture and output devices must support the
-   :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` ioctl such that applications
-   can determine if scaling takes place.
-
+   All capture and output devices that support the CROP or SELECTION
+   API will also support the :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>`
+   ioctl.
 
 Cropping Structures
 ===================
diff --git a/Documentation/media/uapi/v4l/selection-api-005.rst b/Documentation/media/uapi/v4l/selection-api-005.rst
index 5b47a28ac6d7..2ad30a49184f 100644
--- a/Documentation/media/uapi/v4l/selection-api-005.rst
+++ b/Documentation/media/uapi/v4l/selection-api-005.rst
@@ -1,5 +1,7 @@
 .. -*- coding: utf-8; mode: rst -*-
 
+.. _selection-vs-crop:
+
 ********************************
 Comparison with old cropping API
 ********************************
diff --git a/Documentation/media/uapi/v4l/selection-api.rst b/Documentation/media/uapi/v4l/selection-api.rst
index 81ea52d785b9..e4e623824b30 100644
--- a/Documentation/media/uapi/v4l/selection-api.rst
+++ b/Documentation/media/uapi/v4l/selection-api.rst
@@ -2,8 +2,8 @@
 
 .. _selection-api:
 
-API for cropping, composing and scaling
-=======================================
+Cropping, composing and scaling -- the SELECTION API
+====================================================
 
 
 .. toctree::
-- 
2.7.4
