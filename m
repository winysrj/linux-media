Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:58792 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751425AbcKIIbP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Nov 2016 03:31:15 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] control.rst: improve the queryctrl code examples
Message-ID: <55c13b98-f97c-f651-3204-d98192dde078@xs4all.nl>
Date: Wed, 9 Nov 2016 09:31:10 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code examples on how to enumerate controls were really long in the
tooth. Update them.

Using FLAG_NEXT_CTRL is preferred these days, so give that example first.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/control.rst b/Documentation/media/uapi/v4l/control.rst
index d3f1450..51112ba 100644
--- a/Documentation/media/uapi/v4l/control.rst
+++ b/Documentation/media/uapi/v4l/control.rst
@@ -312,21 +312,20 @@ more menu type controls.

 .. _enum_all_controls:

-Example: Enumerating all user controls
-======================================
+Example: Enumerating all controls
+=================================

 .. code-block:: c

-
     struct v4l2_queryctrl queryctrl;
     struct v4l2_querymenu querymenu;

-    static void enumerate_menu(void)
+    static void enumerate_menu(__u32 id)
     {
 	printf("  Menu items:\\n");

 	memset(&querymenu, 0, sizeof(querymenu));
-	querymenu.id = queryctrl.id;
+	querymenu.id = id;

 	for (querymenu.index = queryctrl.minimum;
 	     querymenu.index <= queryctrl.maximum;
@@ -339,6 +338,55 @@ Example: Enumerating all user controls

     memset(&queryctrl, 0, sizeof(queryctrl));

+    queryctrl.id = V4L2_CTRL_FLAG_NEXT_CTRL;
+    while (0 == ioctl(fd, VIDIOC_QUERYCTRL, &queryctrl)) {
+	if (!(queryctrl.flags & V4L2_CTRL_FLAG_DISABLED)) {
+	    printf("Control %s\\n", queryctrl.name);
+
+	    if (queryctrl.type == V4L2_CTRL_TYPE_MENU)
+	        enumerate_menu(queryctrl.id);
+        }
+
+	queryctrl.id |= V4L2_CTRL_FLAG_NEXT_CTRL;
+    }
+    if (errno != EINVAL) {
+	perror("VIDIOC_QUERYCTRL");
+	exit(EXIT_FAILURE);
+    }
+
+Example: Enumerating all controls including compound controls
+=============================================================
+
+.. code-block:: c
+
+    struct v4l2_query_ext_ctrl query_ext_ctrl;
+
+    memset(&query_ext_ctrl, 0, sizeof(query_ext_ctrl));
+
+    query_ext_ctrl.id = V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_COMPOUND;
+    while (0 == ioctl(fd, VIDIOC_QUERY_EXT_CTRL, &query_ext_ctrl)) {
+	if (!(query_ext_ctrl.flags & V4L2_CTRL_FLAG_DISABLED)) {
+	    printf("Control %s\\n", query_ext_ctrl.name);
+
+	    if (query_ext_ctrl.type == V4L2_CTRL_TYPE_MENU)
+	        enumerate_menu(query_ext_ctrl.id);
+        }
+
+	query_ext_ctrl.id |= V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_COMPOUND;
+    }
+    if (errno != EINVAL) {
+	perror("VIDIOC_QUERY_EXT_CTRL");
+	exit(EXIT_FAILURE);
+    }
+
+Example: Enumerating all user controls (old style)
+==================================================
+
+.. code-block:: c
+
+
+    memset(&queryctrl, 0, sizeof(queryctrl));
+
     for (queryctrl.id = V4L2_CID_BASE;
 	 queryctrl.id < V4L2_CID_LASTP1;
 	 queryctrl.id++) {
@@ -349,7 +397,7 @@ Example: Enumerating all user controls
 	    printf("Control %s\\n", queryctrl.name);

 	    if (queryctrl.type == V4L2_CTRL_TYPE_MENU)
-		enumerate_menu();
+		enumerate_menu(queryctrl.id);
 	} else {
 	    if (errno == EINVAL)
 		continue;
@@ -368,7 +416,7 @@ Example: Enumerating all user controls
 	    printf("Control %s\\n", queryctrl.name);

 	    if (queryctrl.type == V4L2_CTRL_TYPE_MENU)
-		enumerate_menu();
+		enumerate_menu(queryctrl.id);
 	} else {
 	    if (errno == EINVAL)
 		break;
@@ -379,32 +427,6 @@ Example: Enumerating all user controls
     }


-Example: Enumerating all user controls (alternative)
-====================================================
-
-.. code-block:: c
-
-    memset(&queryctrl, 0, sizeof(queryctrl));
-
-    queryctrl.id = V4L2_CTRL_CLASS_USER | V4L2_CTRL_FLAG_NEXT_CTRL;
-    while (0 == ioctl(fd, VIDIOC_QUERYCTRL, &queryctrl)) {
-	if (V4L2_CTRL_ID2CLASS(queryctrl.id) != V4L2_CTRL_CLASS_USER)
-	    break;
-	if (queryctrl.flags & V4L2_CTRL_FLAG_DISABLED)
-	    continue;
-
-	printf("Control %s\\n", queryctrl.name);
-
-	if (queryctrl.type == V4L2_CTRL_TYPE_MENU)
-	    enumerate_menu();
-
-	queryctrl.id |= V4L2_CTRL_FLAG_NEXT_CTRL;
-    }
-    if (errno != EINVAL) {
-	perror("VIDIOC_QUERYCTRL");
-	exit(EXIT_FAILURE);
-    }
-
 Example: Changing controls
 ==========================

