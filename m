Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:38375 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753504AbeBCS0M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Feb 2018 13:26:12 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC PATCH] media-ioc-enum-entities/links.rst: document reserved
 fields
Message-ID: <3cc66f67-6de7-ae83-5b6c-6eed5d1e075b@xs4all.nl>
Date: Sat, 3 Feb 2018 19:26:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These structures have reserved fields that were never documented.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
The kernel correctly zeroes these, but should we require that userspace also
does this? I think it may be too late for that, in that case the description
will have to change to: "Drivers set the array to zero.".

Regards,

	Hans
---
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
