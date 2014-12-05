Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:41954 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbaLEOTz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Dec 2014 09:19:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v3.19 3/4] DocBook media: update version number and document changes.
Date: Fri,  5 Dec 2014 15:19:23 +0100
Message-Id: <1417789164-28468-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417789164-28468-1-git-send-email-hverkuil@xs4all.nl>
References: <1417789164-28468-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/compat.xml |  6 ++++++
 Documentation/DocBook/media/v4l/v4l2.xml   | 11 ++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 0a2debf..518bc56 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2576,6 +2576,12 @@ fields changed from _s32 to _u32.
 	  <para>Added <constant>V4L2_CID_PAN_SPEED</constant> and
  <constant>V4L2_CID_TILT_SPEED</constant> camera controls.</para>
 	</listitem>
+	<listitem>
+	  <para>Rewrote Colorspace chapter, added new &v4l2-ycbcr-encoding;
+and &v4l2-quantization; fields to &v4l2-pix-format;, &v4l2-pix-format-mplane;
+and &v4l2-mbus-framefmt;.
+	  </para>
+	</listitem>
       </orderedlist>
     </section>
 
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 7cfe618..e6cfd7e 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -152,6 +152,15 @@ structs, ioctls) must be noted in more detail in the history chapter
 applications. -->
 
       <revision>
+	<revnumber>3.18</revnumber>
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
+ <subtitle>Revision 3.18</subtitle>
 
   <chapter id="common">
     &sub-common;
-- 
2.1.3

