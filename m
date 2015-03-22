Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34992 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751809AbbCVSgo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 14:36:44 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: mchehab@osg.samsung.com, corbet@lwn.net
Cc: hans.verkuil@cisco.com, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH 1/1] [media] DocBook media: fix broken EIA hyperlink
Date: Sun, 22 Mar 2015 11:35:56 -0700
Message-Id: <1427049356-30395-2-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1427049356-30395-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1427049356-30395-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes the bibliography hyperlink to "http://www.eia.org"
which now redirects to a page with a "404 Not found" error.

The latest update to the document referred to is now available
on the Consumer Electronics Association website.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 Documentation/DocBook/media/v4l/biblio.xml                  | 11 +++++------
 Documentation/DocBook/media/v4l/dev-sliced-vbi.xml          |  2 +-
 Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml |  2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
index 7ff01a23c2fe..fdee6b3f3eca 100644
--- a/Documentation/DocBook/media/v4l/biblio.xml
+++ b/Documentation/DocBook/media/v4l/biblio.xml
@@ -1,14 +1,13 @@
   <bibliography>
     <title>References</title>
 
-    <biblioentry id="eia608">
-      <abbrev>EIA&nbsp;608-B</abbrev>
+    <biblioentry id="cea608">
+      <abbrev>CEA&nbsp;608-E</abbrev>
       <authorgroup>
-	<corpauthor>Electronic Industries Alliance (<ulink
-url="http://www.eia.org">http://www.eia.org</ulink>)</corpauthor>
+	<corpauthor>Consumer Electronics Association (<ulink
+url="http://www.ce.org">http://www.ce.org</ulink>)</corpauthor>
       </authorgroup>
-      <title>EIA 608-B "Recommended Practice for Line 21 Data
-Service"</title>
+      <title>CEA-608-E R-2014 "Line 21 Data Services"</title>
     </biblioentry>
 
     <biblioentry id="en300294">
diff --git a/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml b/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
index 7a8bf3011ee9..0aec62ed2bf8 100644
--- a/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
+++ b/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
@@ -254,7 +254,7 @@ ETS&nbsp;300&nbsp;231, lsb first transmitted.</entry>
 	  <row>
 	    <entry><constant>V4L2_SLICED_CAPTION_525</constant></entry>
 	    <entry>0x1000</entry>
-	    <entry><xref linkend="eia608" /></entry>
+	    <entry><xref linkend="cea608" /></entry>
 	    <entry>NTSC line 21, 284 (second field 21)</entry>
 	    <entry>Two bytes in transmission order, including parity
 bit, lsb first transmitted.</entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml b/Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml
index bd015d1563ff..d05623c55403 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml
@@ -205,7 +205,7 @@ ETS&nbsp;300&nbsp;231, lsb first transmitted.</entry>
 	  <row>
 	    <entry><constant>V4L2_SLICED_CAPTION_525</constant></entry>
 	    <entry>0x1000</entry>
-	    <entry><xref linkend="eia608" /></entry>
+	    <entry><xref linkend="cea608" /></entry>
 	    <entry>NTSC line 21, 284 (second field 21)</entry>
 	    <entry>Two bytes in transmission order, including parity
 bit, lsb first transmitted.</entry>
-- 
2.1.0

