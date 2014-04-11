Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3348 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaDKIMO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 04:12:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 12/13] DocBook media: update bytesused field description
Date: Fri, 11 Apr 2014 10:11:18 +0200
Message-Id: <1397203879-37443-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
References: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

For output buffers the application has to set the bytesused field.
In reality applications often do not set this since drivers that
deal with fix image sizes just override it anyway.

The vb2 framework will replace this field with the length field if
bytesused was set to 0 by the application, which is what happens
in practice. Document this behavior.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/io.xml | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 97a69bf..188e621 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -699,7 +699,12 @@ linkend="v4l2-buf-type" /></entry>
 buffer. It depends on the negotiated data format and may change with
 each buffer for compressed variable size data like JPEG images.
 Drivers must set this field when <structfield>type</structfield>
-refers to an input stream, applications when it refers to an output stream.</entry>
+refers to an input stream, applications when it refers to an output stream.
+If the application sets this to 0 for an output stream, then
+<structfield>bytesused</structfield> will be set to the size of the
+buffer (see the <structfield>length</structfield> field of this struct) by
+the driver. For multiplanar formats this field is ignored and the
+<structfield>planes</structfield> pointer is used instead.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -861,7 +866,11 @@ should set this to 0.</entry>
 	    <entry></entry>
 	    <entry>The number of bytes occupied by data in the plane
 	      (its payload). Drivers must set this field when <structfield>type</structfield>
-	      refers to an input stream, applications when it refers to an output stream.</entry>
+	      refers to an input stream, applications when it refers to an output stream.
+	      If the application sets this to 0 for an output stream, then
+	      <structfield>bytesused</structfield> will be set to the size of the
+	      plane (see the <structfield>length</structfield> field of this struct)
+	      by the driver.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-- 
1.9.1

