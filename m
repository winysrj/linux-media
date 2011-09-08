Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:20645 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab1IHIKT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Sep 2011 04:10:19 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, pawel@osciak.com,
	mchehab@infradead.org, m.szyprowski@samsung.com
Subject: [PATCH 1/1] v4l: Mark VIDIOC_PREPARE_BUFS and VIDIOC_CREATE_BUFS experimental.
Date: Thu,  8 Sep 2011 11:10:02 +0300
Message-Id: <1315469402-7145-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <Pine.LNX.4.64.1109080942172.31156@axis700.grange>
References: <Pine.LNX.4.64.1109080942172.31156@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a note to documentation of both VIDIOC_PREPARE_BUFS and
VIDIOC_CREATE_BUFS that these ioctls are experimental.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---

I think it would be even better to add the note to the ioctls themselves.
The users are not going to be looking at the list of experimental features
when then want to implement something.

 .../DocBook/media/v4l/vidioc-create-bufs.xml       |    9 +++++++++
 .../DocBook/media/v4l/vidioc-prepare-buf.xml       |    9 +++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
index eb99604..d43e24a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
@@ -48,6 +48,15 @@
   <refsect1>
     <title>Description</title>
 
+    <note>
+      <title>Experimental</title>
+
+      <para>
+	This is an <link linkend="experimental">experimental</link>
+	interface and may change in the future.
+      </para>
+    </note>
+
     <para>This ioctl is used to create buffers for <link linkend="mmap">memory
 mapped</link> or <link linkend="userp">user pointer</link>
 I/O. It can be used as an alternative or in addition to the
diff --git a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
index 509e752..8889c6d 100644
--- a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
@@ -48,6 +48,15 @@
   <refsect1>
     <title>Description</title>
 
+    <note>
+      <title>Experimental</title>
+
+      <para>
+	This is an <link linkend="experimental">experimental</link>
+	interface and may change in the future.
+      </para>
+    </note>
+
     <para>Applications can optionally call the
 <constant>VIDIOC_PREPARE_BUF</constant> ioctl to pass ownership of the buffer
 to the driver before actually enqueuing it, using the
-- 
1.7.2.5

