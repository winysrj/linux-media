Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3775 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbaGUNRL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 09:17:11 -0400
Message-ID: <53CD12BF.9050202@xs4all.nl>
Date: Mon, 21 Jul 2014 15:16:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"nicolas.dufresne@collabora.com >> Nicolas Dufresne"
	<nicolas.dufresne@collabora.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: [RFC PATCH] Docbook/media: improve data_offset/bytesused documentation
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch explicitly documents the relationship between bytesused and data_offset.

But looking in the kernel there isn't a single driver that actually sets data_offset.
Do such beasts exist? It's also annoying that there is no such equivalent for the
single planar API, so it is asymmetrical. What was the reason that we never did that
for single planar? Because existing applications wouldn't know what to do with it?

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 8c4ee74..e5e8325 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -870,7 +870,8 @@ should set this to 0.</entry>
 	      If the application sets this to 0 for an output stream, then
 	      <structfield>bytesused</structfield> will be set to the size of the
 	      plane (see the <structfield>length</structfield> field of this struct)
-	      by the driver.</entry>
+	      by the driver. Note that the actual image data starts at
+	      <structfield>data_offset</structfield> which may not be 0.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -919,6 +920,10 @@ should set this to 0.</entry>
 	    <entry>Offset in bytes to video data in the plane.
 	      Drivers must set this field when <structfield>type</structfield>
 	      refers to an input stream, applications when it refers to an output stream.
+	      Note that data_offset is included in <structfield>bytesused</structfield>.
+	      So the size of the image in the plane is
+	      <structfield>bytesused</structfield>-<structfield>data_offset</structfield> at
+	      offset <structfield>data_offset</structfield> from the start of the plane.
 	    </entry>
 	  </row>
 	  <row>
