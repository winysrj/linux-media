Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:53309 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab2CBRcz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Mar 2012 12:32:55 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v4 10/34] v4l: Mark VIDIOC_SUBDEV_G_CROP and VIDIOC_SUBDEV_S_CROP obsolete
Date: Fri,  2 Mar 2012 19:30:18 +0200
Message-Id: <1330709442-16654-10-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120302173219.GA15695@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These two IOCTLS are obsoleted by VIDIOC_SUBDEV_G_SELECTION and
VIDIOC_SUBDEV_S_SELECTION. Mark them obsolete.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/compat.xml         |    7 +++++++
 .../DocBook/media/v4l/vidioc-subdev-g-crop.xml     |    9 ++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 603fa4ad..ebfe47e 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2547,6 +2547,13 @@ interfaces and should not be implemented in new drivers.</para>
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

