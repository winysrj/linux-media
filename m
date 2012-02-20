Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:64030 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab2BTB60 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Feb 2012 20:58:26 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH v3 10/33] v4l: Mark VIDIOC_SUBDEV_G_CROP and VIDIOC_SUBDEV_S_CROP obsolete
Date: Mon, 20 Feb 2012 03:56:49 +0200
Message-Id: <1329703032-31314-10-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120220015605.GI7784@valkosipuli.localdomain>
References: <20120220015605.GI7784@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These two IOCTLS are obsoleted by VIDIOC_SUBDEV_G_SELECTION and
VIDIOC_SUBDEV_S_SELECTION. Mark them obsolete.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/compat.xml         |    7 +++++++
 .../DocBook/media/v4l/vidioc-subdev-g-crop.xml     |    9 ++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 0c498db..da9b3bd 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2541,6 +2541,13 @@ interfaces and should not be implemented in new drivers.</para>
 <constant>VIDIOC_S_MPEGCOMP</constant> ioctls. Use Extended Controls,
 <xref linkend="extended-controls" />.</para>
         </listitem>
+        <listitem>
+	  <para><constant>VIDIOC_SUBDEV_G_CROP</constant> and
+	  <constant>VIDIOC_SUBDEV_S_CROP</constant> ioctls. Use
+	  <constant>VIDIOC_SUBDEV_G_SELECTION</constant> and
+	  <constant>VIDIOC_SUBDEV_S_SELECTION</constant>, <xref
+	  linkend="vidioc-subdev-g-selection" />.</para>
+        </listitem>
       </itemizedlist>
     </section>
   </section>
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-crop.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-crop.xml
index 0619732..4cddd78 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-crop.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-crop.xml
@@ -58,9 +58,12 @@
     <title>Description</title>
 
     <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental">experimental</link>
-      interface and may change in the future.</para>
+      <title>Obsolete</title>
+
+      <para>This is an <link linkend="obsolete">obsolete</link>
+      interface and may be removed in the future. It is superseded by
+      <link linkend="vidioc-subdev-g-selection">the selection
+      API</link>.</para>
     </note>
 
     <para>To retrieve the current crop rectangle applications set the
-- 
1.7.2.5

