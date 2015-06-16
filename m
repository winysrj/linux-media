Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:35821 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397AbbFPIVb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2015 04:21:31 -0400
Received: by labko7 with SMTP id ko7so5968687lab.2
        for <linux-media@vger.kernel.org>; Tue, 16 Jun 2015 01:21:30 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [RFC v4 18/19] Docbook: media: new ioctl VIDIOC_G_DEF_EXT_CTRLS
Date: Tue, 16 Jun 2015 10:21:27 +0200
Message-Id: <1434442887-22261-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for new ioctl.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
v4:
-Add Author information
-Set kernel version to 4,3
 Documentation/DocBook/media/v4l/v4l2.xml             | 20 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml         | 13 +++++++++----
 Documentation/video4linux/v4l2-controls.txt          |  3 ++-
 Documentation/video4linux/v4l2-framework.txt         |  1 +
 Documentation/zh_CN/video4linux/v4l2-framework.txt   |  1 +
 5 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index e98caa1c39bd..4bbc59edd4ac 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -117,6 +117,18 @@ Remote Controller chapter.</contrib>
 	  </address>
 	</affiliation>
       </author>
+
+      <author>
+	<firstname>Ricardo</firstname>
+	<surname>Ribalda Delgado</surname>
+	<contrib>Designed and documented the VIDIOC_G_DEF_EXT_CTRLS ioctl
+	</contrib>
+	<affiliation>
+	  <address>
+	    <email>ricardo.ribalda@gmail.com</email>
+	  </address>
+	</affiliation>
+      </author>
     </authorgroup>
 
     <copyright>
@@ -153,6 +165,14 @@ structs, ioctls) must be noted in more detail in the history chapter
 applications. -->
 
       <revision>
+	<revnumber>4.3</revnumber>
+	<date>2015-06-12</date>
+	<authorinitials>rr</authorinitials>
+	<revremark>Extend &vidioc-g-ext-ctrls;. Add ioctl <constant>VIDIOC_G_DEF_EXT_CTRLS</constant>
+to get the default value of multiple controls.
+	</revremark>
+      </revision>
+      <revision>
 	<revnumber>3.21</revnumber>
 	<date>2015-02-13</date>
 	<authorinitials>mcc</authorinitials>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index c5bdbfcc42b3..5f8283a7e288 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -1,12 +1,13 @@
 <refentry id="vidioc-g-ext-ctrls">
   <refmeta>
     <refentrytitle>ioctl VIDIOC_G_EXT_CTRLS, VIDIOC_S_EXT_CTRLS,
-VIDIOC_TRY_EXT_CTRLS</refentrytitle>
+VIDIOC_TRY_EXT_CTRLS, VIDIOC_G_DEF_EXT_CTRLS</refentrytitle>
     &manvol;
   </refmeta>
 
   <refnamediv>
     <refname>VIDIOC_G_EXT_CTRLS</refname>
+    <refname>VIDIOC_G_DEF_EXT_CTRLS</refname>
     <refname>VIDIOC_S_EXT_CTRLS</refname>
     <refname>VIDIOC_TRY_EXT_CTRLS</refname>
     <refpurpose>Get or set the value of several controls, try control
@@ -39,7 +40,7 @@ values</refpurpose>
 	<term><parameter>request</parameter></term>
 	<listitem>
 	  <para>VIDIOC_G_EXT_CTRLS, VIDIOC_S_EXT_CTRLS,
-VIDIOC_TRY_EXT_CTRLS</para>
+VIDIOC_TRY_EXT_CTRLS, VIDIOC_G_DEF_EXT_CTRLS</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
@@ -74,7 +75,10 @@ of each &v4l2-ext-control; and call the
 <constant>VIDIOC_G_EXT_CTRLS</constant> ioctl. String controls controls
 must also set the <structfield>string</structfield> field. Controls
 of compound types (<constant>V4L2_CTRL_FLAG_HAS_PAYLOAD</constant> is set)
-must set the <structfield>ptr</structfield> field.</para>
+must set the <structfield>ptr</structfield> field. To get the default value
+instead of the current value, call the
+<constant>VIDIOC_G_DEF_EXT_CTRLS</constant> ioctl with the same arguments.
+</para>
 
     <para>If the <structfield>size</structfield> is too small to
 receive the control result (only relevant for pointer-type controls
@@ -141,7 +145,8 @@ application.</entry>
 	    <entry>The total size in bytes of the payload of this
 control. This is normally 0, but for pointer controls this should be
 set to the size of the memory containing the payload, or that will
-receive the payload. If <constant>VIDIOC_G_EXT_CTRLS</constant> finds
+receive the payload. If <constant>VIDIOC_G_EXT_CTRLS</constant>
+or <constant>VIDIOC_G_DEF_EXT_CTRLS</constant> finds
 that this value is less than is required to store
 the payload result, then it is set to a value large enough to store the
 payload result and ENOSPC is returned. Note that for string controls
diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 5517db602f37..7e3dfcacdbee 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -79,7 +79,8 @@ Basic usage for V4L2 and sub-device drivers
 
   Finally, remove all control functions from your v4l2_ioctl_ops (if any):
   vidioc_queryctrl, vidioc_query_ext_ctrl, vidioc_querymenu, vidioc_g_ctrl,
-  vidioc_s_ctrl, vidioc_g_ext_ctrls, vidioc_try_ext_ctrls and vidioc_s_ext_ctrls.
+  vidioc_s_ctrl, vidioc_g_ext_ctrls, vidioc_try_ext_ctrls,
+  vidioc_g_def_ext_ctrls, and vidioc_s_ext_ctrls.
   Those are now no longer needed.
 
 1.3.2) For sub-device drivers do this:
diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 75d5c18d689a..4672396f48b1 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -462,6 +462,7 @@ VIDIOC_QUERYMENU
 VIDIOC_G_CTRL
 VIDIOC_S_CTRL
 VIDIOC_G_EXT_CTRLS
+VIDIOC_G_DEF_EXT_CTRLS
 VIDIOC_S_EXT_CTRLS
 VIDIOC_TRY_EXT_CTRLS
 
diff --git a/Documentation/zh_CN/video4linux/v4l2-framework.txt b/Documentation/zh_CN/video4linux/v4l2-framework.txt
index 2b828e631e31..b8c0d6fb6595 100644
--- a/Documentation/zh_CN/video4linux/v4l2-framework.txt
+++ b/Documentation/zh_CN/video4linux/v4l2-framework.txt
@@ -401,6 +401,7 @@ VIDIOC_QUERYMENU
 VIDIOC_G_CTRL
 VIDIOC_S_CTRL
 VIDIOC_G_EXT_CTRLS
+VIDIOC_G_DEF_EXT_CTRLS
 VIDIOC_S_EXT_CTRLS
 VIDIOC_TRY_EXT_CTRLS
 
-- 
2.1.4

