Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39220 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751353Ab2KPUt7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 15:49:59 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Subject: [PATCH v1.1 1/4] v4l: Define video buffer flags for timestamp types
Date: Fri, 16 Nov 2012 22:49:55 +0200
Message-Id: <1353098995-1319-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <201211161658.54968.hverkuil@xs4all.nl>
References: <201211161658.54968.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Define video buffer flags for different timestamp types. Everything up to
now have used either realtime clock or monotonic clock, without a way to
tell which clock the timestamp was taken from.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
Changes since v1:

- Mention about timestamps in API changes
- Bump API version to 3.8
- DocBook compile fixes
- Tell realtime clock is the same as wall clock, and mention how to get such
  timestamps in the user space

 Documentation/DocBook/media/v4l/compat.xml |   12 +++++++++++
 Documentation/DocBook/media/v4l/io.xml     |   29 ++++++++++++++++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml   |   12 ++++++++++-
 include/uapi/linux/videodev2.h             |    4 +++
 4 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 4fdf6b5..651ca52 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2477,6 +2477,18 @@ that used it. It was originally scheduled for removal in 2.6.35.
       </orderedlist>
     </section>
 
+    <section>
+      <title>V4L2 in Linux 3.8</title>
+      <orderedlist>
+        <listitem>
+	  <para>Added timestamp types to
+	  <structfield>flags</structfield> field in
+	  <structname>v4l2_buffer</structname>. See <xref
+	  linkend="buffer-flags" />.</para>
+        </listitem>
+      </orderedlist>
+    </section>
+
     <section id="other">
       <title>Relation of V4L2 to other Linux multimedia APIs</title>
 
diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 7e2f3d7..bcd1c8f7 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -938,6 +938,35 @@ Typically applications shall use this flag for output buffers if the data
 in this buffer has not been created by the CPU but by some DMA-capable unit,
 in which case caches have not been used.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant></entry>
+	    <entry>0xe000</entry>
+	    <entry>Mask for timestamp types below. To test the
+	    timestamp type, mask out bits not belonging to timestamp
+	    type by performing a logical and operation with buffer
+	    flags and timestamp mask.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN</constant></entry>
+	    <entry>0x0000</entry>
+	    <entry>Unknown timestamp type. This type is used by
+	    drivers before Linux 3.8 and may be either monotonic (see
+	    below) or realtime (wall clock). Monotonic clock has been
+	    favoured in embedded systems whereas most of the drivers
+	    use the realtime clock. Either kinds of timestamps are
+	    available in user space via
+	    <function>clock_gettime(2)</function> using clock IDs
+	    <constant>CLOCK_MONOTONIC</constant> and
+	    <constant>CLOCK_REALTIME</constant>, respectively.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC</constant></entry>
+	    <entry>0x2000</entry>
+	    <entry>The buffer timestamp has been taken from the
+	    <constant>CLOCK_MONOTONIC</constant> clock. To access the
+	    same clock outside V4L2, use
+	    <function>clock_gettime(2)</function> .</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 10ccde9..8b6f29e 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -140,6 +140,16 @@ structs, ioctls) must be noted in more detail in the history chapter
 applications. -->
 
       <revision>
+	<revnumber>3.8</revnumber>
+	<date>2012-11-16</date>
+	<authorinitials>sa</authorinitials>
+	<revremark>Added timestamp types to
+	<structname>v4l2_buffer</structname>, see <xref
+	linkend="buffer-flags" />.
+	</revremark>
+      </revision>
+
+      <revision>
 	<revnumber>3.6</revnumber>
 	<date>2012-07-02</date>
 	<authorinitials>hv</authorinitials>
@@ -472,7 +482,7 @@ and discussions on the V4L mailing list.</revremark>
 </partinfo>
 
 <title>Video for Linux Two API Specification</title>
- <subtitle>Revision 3.6</subtitle>
+ <subtitle>Revision 3.8</subtitle>
 
   <chapter id="common">
     &sub-common;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 2fff7ff..410ea9f 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -686,6 +686,10 @@ struct v4l2_buffer {
 /* Cache handling flags */
 #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
 #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
+/* Timestamp type */
+#define V4L2_BUF_FLAG_TIMESTAMP_MASK		0xe000
+#define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x0000
+#define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x2000
 
 /*
  *	O V E R L A Y   P R E V I E W
-- 
1.7.2.5

