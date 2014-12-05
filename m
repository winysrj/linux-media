Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:56483 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbaLEOZf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Dec 2014 09:25:35 -0500
Message-ID: <5481C05A.5040406@xs4all.nl>
Date: Fri, 05 Dec 2014 15:25:30 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 for v3.19 3/4] DocBook media: update version number and
 document changes.
References: <1417789164-28468-1-git-send-email-hverkuil@xs4all.nl> <1417789164-28468-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417789164-28468-4-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the version to 3.19.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/compat.xml | 12 ++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml   | 11 ++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 0a2debf..350dfb3 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2579,6 +2579,18 @@ fields changed from _s32 to _u32.
       </orderedlist>
     </section>
 
+    <section>
+      <title>V4L2 in Linux 3.19</title>
+      <orderedlist>
+	<listitem>
+	  <para>Rewrote Colorspace chapter, added new &v4l2-ycbcr-encoding;
+and &v4l2-quantization; fields to &v4l2-pix-format;, &v4l2-pix-format-mplane;
+and &v4l2-mbus-framefmt;.
+	  </para>
+	</listitem>
+      </orderedlist>
+    </section>
+
     <section id="other">
       <title>Relation of V4L2 to other Linux multimedia APIs</title>
 
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 7cfe618..ac0f8d9 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -152,6 +152,15 @@ structs, ioctls) must be noted in more detail in the history chapter
 applications. -->
 
       <revision>
+	<revnumber>3.19</revnumber>
+	<date>2014-12-05</date>
+	<authorinitials>hv</authorinitials>
+	<revremark>Rewrote Colorspace chapter, added new &v4l2-ycbcr-encoding; and &v4l2-quantization; fields
+to &v4l2-pix-format;, &v4l2-pix-format-mplane; and &v4l2-mbus-framefmt;.
+	</revremark>
+      </revision>
+
+      <revision>
 	<revnumber>3.17</revnumber>
 	<date>2014-08-04</date>
 	<authorinitials>lp, hv</authorinitials>
@@ -539,7 +548,7 @@ and discussions on the V4L mailing list.</revremark>
 </partinfo>
 
 <title>Video for Linux Two API Specification</title>
- <subtitle>Revision 3.17</subtitle>
+ <subtitle>Revision 3.19</subtitle>
 
   <chapter id="common">
     &sub-common;
-- 
2.1.3


