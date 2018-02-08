Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:49001 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750961AbeBHIhC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 03:37:02 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 14/15] media-ioc-enum-entities/links.rst: document reserved fields
Date: Thu,  8 Feb 2018 09:36:54 +0100
Message-Id: <20180208083655.32248-15-hverkuil@xs4all.nl>
In-Reply-To: <20180208083655.32248-1-hverkuil@xs4all.nl>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These structures have reserved fields that were never documented.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/uapi/mediactl/media-ioc-enum-entities.rst   | 19 +++++++++++++++----
 .../media/uapi/mediactl/media-ioc-enum-links.rst      | 18 ++++++++++++++++++
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
index b59ce149efb5..45e76e5bc1ea 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
@@ -144,10 +144,21 @@ id's until they get an error.
 
     -  .. row 9
 
-       -  union
+       -  __u32
+
+       -  ``reserved[4]``
+
+       -
+       -
+       -  Reserved for future extensions. Drivers and applications must set
+          the array to zero.
 
     -  .. row 10
 
+       -  union
+
+    -  .. row 11
+
        -
        -  struct
 
@@ -156,7 +167,7 @@ id's until they get an error.
        -
        -  Valid for (sub-)devices that create a single device node.
 
-    -  .. row 11
+    -  .. row 12
 
        -
        -
@@ -166,7 +177,7 @@ id's until they get an error.
 
        -  Device node major number.
 
-    -  .. row 12
+    -  .. row 13
 
        -
        -
@@ -176,7 +187,7 @@ id's until they get an error.
 
        -  Device node minor number.
 
-    -  .. row 13
+    -  .. row 14
 
        -
        -  __u8
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
index d05be16ffaf6..256168b3c3be 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
@@ -125,6 +125,15 @@ returned during the enumeration process.
 
        -  Pad flags, see :ref:`media-pad-flag` for more details.
 
+    -  .. row 4
+
+       -  __u32
+
+       -  ``reserved[2]``
+
+       -  Reserved for future extensions. Drivers and applications must set
+          the array to zero.
+
 
 
 .. c:type:: media_link_desc
@@ -161,6 +170,15 @@ returned during the enumeration process.
 
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
2.15.1
