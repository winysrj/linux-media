Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:22400 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933921Ab2AKV1M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 16:27:12 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH 02/23] v4l: Document integer menu controls
Date: Wed, 11 Jan 2012 23:26:39 +0200
Message-Id: <1326317220-15339-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4F0DFE92.80102@iki.fi>
References: <4F0DFE92.80102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/compat.xml         |   10 +++++
 Documentation/DocBook/media/v4l/v4l2.xml           |    7 ++++
 .../DocBook/media/v4l/vidioc-queryctrl.xml         |   39 +++++++++++++++++++-
 3 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index b68698f..985c536 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2379,6 +2379,16 @@ that used it. It was originally scheduled for removal in 2.6.35.
       </orderedlist>
     </section>
 
+    <section>
+      <title>V4L2 in Linux 3.4</title>
+      <orderedlist>
+        <listitem>
+	  <para>Added integer menus, the new type will be
+	  V4L2_CTRL_TYPE_INTEGER_MENU.</para>
+        </listitem>
+      </orderedlist>
+    </section>
+
     <section id="other">
       <title>Relation of V4L2 to other Linux multimedia APIs</title>
 
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 2ab365c..8646fbc 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -128,6 +128,13 @@ structs, ioctls) must be noted in more detail in the history chapter
 applications. -->
 
       <revision>
+	<revnumber>3.4</revnumber>
+	<date>2011-11-24</date>
+	<authorinitials>sa</authorinitials>
+	<revremark>Added V4L2_CTRL_TYPE_INTEGER_MENU.</revremark>
+      </revision>
+
+      <revision>
 	<revnumber>3.2</revnumber>
 	<date>2011-08-26</date>
 	<authorinitials>hv</authorinitials>
diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
index 0ac0057..02064b0 100644
--- a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
@@ -215,11 +215,12 @@ the array to zero.</entry>
 
     <table pgwide="1" frame="none" id="v4l2-querymenu">
       <title>struct <structname>v4l2_querymenu</structname></title>
-      <tgroup cols="3">
+      <tgroup cols="4">
 	&cs-str;
 	<tbody valign="top">
 	  <row>
 	    <entry>__u32</entry>
+	    <entry></entry>
 	    <entry><structfield>id</structfield></entry>
 	    <entry>Identifies the control, set by the application
 from the respective &v4l2-queryctrl;
@@ -227,18 +228,38 @@ from the respective &v4l2-queryctrl;
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
+	    <entry></entry>
 	    <entry><structfield>index</structfield></entry>
 	    <entry>Index of the menu item, starting at zero, set by
 	    the application.</entry>
 	  </row>
 	  <row>
+	    <entry>union</entry>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry></entry>
 	    <entry>__u8</entry>
 	    <entry><structfield>name</structfield>[32]</entry>
 	    <entry>Name of the menu item, a NUL-terminated ASCII
-string. This information is intended for the user.</entry>
+string. This information is intended for the user. This field is valid
+for <constant>V4L2_CTRL_FLAG_MENU</constant> type controls.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>__s64</entry>
+	    <entry><structfield>value</structfield></entry>
+	    <entry>
+              Value of the integer menu item. This field is valid for
+              <constant>V4L2_CTRL_FLAG_INTEGER_MENU</constant> type
+              controls.
+            </entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
+	    <entry></entry>
 	    <entry><structfield>reserved</structfield></entry>
 	    <entry>Reserved for future extensions. Drivers must set
 the array to zero.</entry>
@@ -292,6 +313,20 @@ the menu items can be enumerated with the
 <constant>VIDIOC_QUERYMENU</constant> ioctl.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CTRL_TYPE_INTEGER_MENU</constant></entry>
+	    <entry>&ge; 0</entry>
+	    <entry>1</entry>
+	    <entry>N-1</entry>
+	    <entry>
+              The control has a menu of N choices. The values of the
+              menu items can be enumerated with the
+              <constant>VIDIOC_QUERYMENU</constant> ioctl. This is
+              similar to <constant>V4L2_CTRL_TYPE_MENU</constant>
+              except that instead of strings, the menu items are
+              signed 64-bit integers.
+            </entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CTRL_TYPE_BITMASK</constant></entry>
 	    <entry>0</entry>
 	    <entry>n/a</entry>
-- 
1.7.2.5

