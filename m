Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:50330 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbaLEOTr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Dec 2014 09:19:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v3.19 2/4] DocBook media: add missing ycbcr_enc and quantization fields
Date: Fri,  5 Dec 2014 15:19:22 +0100
Message-Id: <1417789164-28468-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417789164-28468-1-git-send-email-hverkuil@xs4all.nl>
References: <1417789164-28468-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

I forgot to add these fields to the relevant structs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml         | 36 ++++++++++++++++++++--
 Documentation/DocBook/media/v4l/subdev-formats.xml | 18 ++++++++++-
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index ccf6053..d5eca4b 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -138,9 +138,25 @@ applicable values.</para></entry>
 	<row>
 	  <entry>__u32</entry>
 	  <entry><structfield>flags</structfield></entry>
-	    <entry>Flags set by the application or driver, see <xref
+	  <entry>Flags set by the application or driver, see <xref
 linkend="format-flags" />.</entry>
 	</row>
+	<row>
+	  <entry>&v4l2-ycbcr-encoding;</entry>
+	  <entry><structfield>ycbcr_enc</structfield></entry>
+	  <entry>This information supplements the
+<structfield>colorspace</structfield> and must be set by the driver for
+capture streams and by the application for output streams,
+see <xref linkend="colorspaces" />.</entry>
+	</row>
+	<row>
+	  <entry>&v4l2-quantization;</entry>
+	  <entry><structfield>quantization</structfield></entry>
+	  <entry>This information supplements the
+<structfield>colorspace</structfield> and must be set by the driver for
+capture streams and by the application for output streams,
+see <xref linkend="colorspaces" />.</entry>
+	</row>
       </tbody>
     </tgroup>
   </table>
@@ -232,9 +248,25 @@ codes can be used.</entry>
 	  <entry>Flags set by the application or driver, see <xref
 linkend="format-flags" />.</entry>
 	</row>
+	<row>
+	  <entry>&v4l2-ycbcr-encoding;</entry>
+	  <entry><structfield>ycbcr_enc</structfield></entry>
+	  <entry>This information supplements the
+<structfield>colorspace</structfield> and must be set by the driver for
+capture streams and by the application for output streams,
+see <xref linkend="colorspaces" />.</entry>
+	</row>
+	<row>
+	  <entry>&v4l2-quantization;</entry>
+	  <entry><structfield>quantization</structfield></entry>
+	  <entry>This information supplements the
+<structfield>colorspace</structfield> and must be set by the driver for
+capture streams and by the application for output streams,
+see <xref linkend="colorspaces" />.</entry>
+	</row>
         <row>
           <entry>__u8</entry>
-          <entry><structfield>reserved[10]</structfield></entry>
+          <entry><structfield>reserved[8]</structfield></entry>
           <entry>Reserved for future extensions. Should be zeroed by the
            application.</entry>
         </row>
diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 18730b9..c5ea868 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -34,8 +34,24 @@
 	  <xref linkend="colorspaces" /> for details.</entry>
 	</row>
 	<row>
+	  <entry>&v4l2-ycbcr-encoding;</entry>
+	  <entry><structfield>ycbcr_enc</structfield></entry>
+	  <entry>This information supplements the
+<structfield>colorspace</structfield> and must be set by the driver for
+capture streams and by the application for output streams,
+see <xref linkend="colorspaces" />.</entry>
+	</row>
+	<row>
+	  <entry>&v4l2-quantization;</entry>
+	  <entry><structfield>quantization</structfield></entry>
+	  <entry>This information supplements the
+<structfield>colorspace</structfield> and must be set by the driver for
+capture streams and by the application for output streams,
+see <xref linkend="colorspaces" />.</entry>
+	</row>
+	<row>
 	  <entry>__u32</entry>
-	  <entry><structfield>reserved</structfield>[7]</entry>
+	  <entry><structfield>reserved</structfield>[6]</entry>
 	  <entry>Reserved for future extensions. Applications and drivers must
 	  set the array to zero.</entry>
 	</row>
-- 
2.1.3

