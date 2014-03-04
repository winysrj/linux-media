Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4183 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbaCDLbi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 06:31:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 4/4] DocBook v4l2: update the G/S_EDID documentation
Date: Tue,  4 Mar 2014 12:30:59 +0100
Message-Id: <6a85b94cb9c762c649dd24478d5de5ac60c8d3e1.1393932339.git.hans.verkuil@cisco.com>
In-Reply-To: <1393932659-13817-1-git-send-email-hverkuil@xs4all.nl>
References: <1393932659-13817-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <831d0a3dd5002830548c8bbbfbd1d74a7db471d7.1393932339.git.hans.verkuil@cisco.com>
References: <831d0a3dd5002830548c8bbbfbd1d74a7db471d7.1393932339.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document that it is now possible to call G/S_EDID from video nodes, not
just sub-device nodes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/v4l2.xml           |  2 +-
 ...{vidioc-subdev-g-edid.xml => vidioc-g-edid.xml} | 30 +++++++++++++---------
 2 files changed, 19 insertions(+), 13 deletions(-)
 rename Documentation/DocBook/media/v4l/{vidioc-subdev-g-edid.xml => vidioc-g-edid.xml} (82%)

diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 6bf3532..9a4aeb6 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -596,6 +596,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-g-crop;
     &sub-g-ctrl;
     &sub-g-dv-timings;
+    &sub-g-edid;
     &sub-g-enc-index;
     &sub-g-ext-ctrls;
     &sub-g-fbuf;
@@ -627,7 +628,6 @@ and discussions on the V4L mailing list.</revremark>
     &sub-subdev-enum-frame-size;
     &sub-subdev-enum-mbus-code;
     &sub-subdev-g-crop;
-    &sub-subdev-g-edid;
     &sub-subdev-g-fmt;
     &sub-subdev-g-frame-interval;
     &sub-subdev-g-selection;
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml b/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
similarity index 82%
rename from Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-edid.xml
index bbd18f0..e04f39f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
@@ -1,12 +1,12 @@
-<refentry id="vidioc-subdev-g-edid">
+<refentry id="vidioc-g-edid">
   <refmeta>
-    <refentrytitle>ioctl VIDIOC_SUBDEV_G_EDID, VIDIOC_SUBDEV_S_EDID</refentrytitle>
+    <refentrytitle>ioctl VIDIOC_G_EDID, VIDIOC_S_EDID</refentrytitle>
     &manvol;
   </refmeta>
 
   <refnamediv>
-    <refname>VIDIOC_SUBDEV_G_EDID</refname>
-    <refname>VIDIOC_SUBDEV_S_EDID</refname>
+    <refname>VIDIOC_G_EDID</refname>
+    <refname>VIDIOC_S_EDID</refname>
     <refpurpose>Get or set the EDID of a video receiver/transmitter</refpurpose>
   </refnamediv>
 
@@ -16,7 +16,7 @@
 	<funcdef>int <function>ioctl</function></funcdef>
 	<paramdef>int <parameter>fd</parameter></paramdef>
 	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>struct v4l2_subdev_edid *<parameter>argp</parameter></paramdef>
+	<paramdef>struct v4l2_edid *<parameter>argp</parameter></paramdef>
       </funcprototype>
     </funcsynopsis>
     <funcsynopsis>
@@ -24,7 +24,7 @@
 	<funcdef>int <function>ioctl</function></funcdef>
 	<paramdef>int <parameter>fd</parameter></paramdef>
 	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>const struct v4l2_subdev_edid *<parameter>argp</parameter></paramdef>
+	<paramdef>const struct v4l2_edid *<parameter>argp</parameter></paramdef>
       </funcprototype>
     </funcsynopsis>
   </refsynopsisdiv>
@@ -42,7 +42,7 @@
       <varlistentry>
 	<term><parameter>request</parameter></term>
 	<listitem>
-	  <para>VIDIOC_SUBDEV_G_EDID, VIDIOC_SUBDEV_S_EDID</para>
+	  <para>VIDIOC_G_EDID, VIDIOC_S_EDID</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
@@ -57,11 +57,16 @@
   <refsect1>
     <title>Description</title>
     <para>These ioctls can be used to get or set an EDID associated with an input pad
-    from a receiver or an output pad of a transmitter subdevice.</para>
+    from a receiver or an output pad of a transmitter subdevice. These ioctls can be
+    used with subdevice nodes or with video nodes. A video node should only support
+    these ioctls if it is unambiguous which receiver or transmitter is referred to.
+    This will typically be based on the current input or output.
+    When used with video nodes the <structfield>pad</structfield> field shall be set
+    to 0, otherwise &EINVAL; will be returned.</para>
 
     <para>To get the EDID data the application has to fill in the <structfield>pad</structfield>,
     <structfield>start_block</structfield>, <structfield>blocks</structfield> and <structfield>edid</structfield>
-    fields and call <constant>VIDIOC_SUBDEV_G_EDID</constant>. The current EDID from block
+    fields and call <constant>VIDIOC_G_EDID</constant>. The current EDID from block
     <structfield>start_block</structfield> and of size <structfield>blocks</structfield>
     will be placed in the memory <structfield>edid</structfield> points to. The <structfield>edid</structfield>
     pointer must point to memory at least <structfield>blocks</structfield>&nbsp;*&nbsp;128 bytes
@@ -91,15 +96,16 @@
     data in some way. In any case, the end result is the same: the EDID is no longer available.
     </para>
 
-    <table pgwide="1" frame="none" id="v4l2-subdev-edid">
-      <title>struct <structname>v4l2_subdev_edid</structname></title>
+    <table pgwide="1" frame="none" id="v4l2-edid">
+      <title>struct <structname>v4l2_edid</structname></title>
       <tgroup cols="3">
         &cs-str;
 	<tbody valign="top">
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>pad</structfield></entry>
-	    <entry>Pad for which to get/set the EDID blocks.</entry>
+	    <entry>Pad for which to get/set the EDID blocks. Must be 0 when using these ioctls
+	    with a video device node.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-- 
1.8.4.rc3

