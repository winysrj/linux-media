Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:60134 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752558AbeBSKiP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 05:38:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 14/15] media-ioc-enum-entities/links.rst: document reserved fields
Date: Mon, 19 Feb 2018 11:38:05 +0100
Message-Id: <20180219103806.17032-15-hverkuil@xs4all.nl>
In-Reply-To: <20180219103806.17032-1-hverkuil@xs4all.nl>
References: <20180219103806.17032-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These structures have reserved fields that were never documented.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../uapi/mediactl/media-ioc-enum-entities.rst      | 18 ++++++++++++----
 .../media/uapi/mediactl/media-ioc-enum-links.rst   | 25 ++++++++++++++++++++++
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
index b59ce149efb5..914c63fa359f 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
@@ -144,10 +144,20 @@ id's until they get an error.
 
     -  .. row 9
 
-       -  union
+       -  __u32
+
+       -  ``reserved[4]``
+
+       -
+       -
+       -  Reserved for future extensions. Drivers must set the array to zero.
 
     -  .. row 10
 
+       -  union
+
+    -  .. row 11
+
        -
        -  struct
 
@@ -156,7 +166,7 @@ id's until they get an error.
        -
        -  Valid for (sub-)devices that create a single device node.
 
-    -  .. row 11
+    -  .. row 12
 
        -
        -
@@ -166,7 +176,7 @@ id's until they get an error.
 
        -  Device node major number.
 
-    -  .. row 12
+    -  .. row 13
 
        -
        -
@@ -176,7 +186,7 @@ id's until they get an error.
 
        -  Device node minor number.
 
-    -  .. row 13
+    -  .. row 14
 
        -
        -  __u8
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
index d05be16ffaf6..00f15e6942a0 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
@@ -89,6 +89,14 @@ returned during the enumeration process.
        -  Pointer to a links array allocated by the application. Ignored if
 	  NULL.
 
+    -  .. row 4
+
+       -  __u32
+
+       -  ``reserved[4]``
+
+       -  Reserved for future extensions. Drivers must set the array to zero.
+
 
 
 .. c:type:: media_pad_desc
@@ -125,6 +133,14 @@ returned during the enumeration process.
 
        -  Pad flags, see :ref:`media-pad-flag` for more details.
 
+    -  .. row 4
+
+       -  __u32
+
+       -  ``reserved[2]``
+
+       -  Reserved for future extensions. Drivers must set the array to zero.
+
 
 
 .. c:type:: media_link_desc
@@ -161,6 +177,15 @@ returned during the enumeration process.
 
        -  Link flags, see :ref:`media-link-flag` for more details.
 
+    -  .. row 4
+
+       -  __u32
+
+       -  ``reserved[4]``
+
+       -  Reserved for future extensions. Drivers and applications must set
+          the array to zero.
+
 
 Return Value
 ============
-- 
2.16.1
