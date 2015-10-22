Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:55504 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757024AbbJVIse (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2015 04:48:34 -0400
To: linux-media <linux-media@vger.kernel.org>
Cc: Pawel Osciak <posciak@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] DocBook media: s/input stream/capture stream/
Message-ID: <5628A27D.80503@xs4all.nl>
Date: Thu, 22 Oct 2015 10:46:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The term "input stream" is confusing since it is not clear whether this is an
input stream from the point of view of the application or from the point of
view of the hardware. So replace it with the more standard term "capture stream".

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 7bbc2a4..87d34ff 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -699,7 +699,7 @@ linkend="v4l2-buf-type" /></entry>
 buffer. It depends on the negotiated data format and may change with
 each buffer for compressed variable size data like JPEG images.
 Drivers must set this field when <structfield>type</structfield>
-refers to an input stream, applications when it refers to an output stream.
+refers to a capture stream, applications when it refers to an output stream.
 If the application sets this to 0 for an output stream, then
 <structfield>bytesused</structfield> will be set to the size of the
 buffer (see the <structfield>length</structfield> field of this struct) by
@@ -720,14 +720,14 @@ linkend="buffer-flags" />.</entry>
 	    <entry>Indicates the field order of the image in the
 buffer, see <xref linkend="v4l2-field" />. This field is not used when
 the buffer contains VBI data. Drivers must set it when
-<structfield>type</structfield> refers to an input stream,
+<structfield>type</structfield> refers to a capture stream,
 applications when it refers to an output stream.</entry>
 	  </row>
 	  <row>
 	    <entry>struct timeval</entry>
 	    <entry><structfield>timestamp</structfield></entry>
 	    <entry></entry>
-	    <entry><para>For input streams this is time when the first data
+	    <entry><para>For capture streams this is time when the first data
 	    byte was captured, as returned by the
 	    <function>clock_gettime()</function> function for the relevant
 	    clock id; see <constant>V4L2_BUF_FLAG_TIMESTAMP_*</constant> in
@@ -866,7 +866,7 @@ must set this to 0.</entry>
 	    <entry></entry>
 	    <entry>The number of bytes occupied by data in the plane
 	      (its payload). Drivers must set this field when <structfield>type</structfield>
-	      refers to an input stream, applications when it refers to an output stream.
+	      refers to a capture stream, applications when it refers to an output stream.
 	      If the application sets this to 0 for an output stream, then
 	      <structfield>bytesused</structfield> will be set to the size of the
 	      plane (see the <structfield>length</structfield> field of this struct)
@@ -919,7 +919,7 @@ must set this to 0.</entry>
 	    <entry></entry>
 	    <entry>Offset in bytes to video data in the plane.
 	      Drivers must set this field when <structfield>type</structfield>
-	      refers to an input stream, applications when it refers to an output stream.
+	      refers to a capture stream, applications when it refers to an output stream.
 	      Note that data_offset is included in <structfield>bytesused</structfield>.
 	      So the size of the image in the plane is
 	      <structfield>bytesused</structfield>-<structfield>data_offset</structfield> at
