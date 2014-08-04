Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1207 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaHDJTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 05:19:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v3.17 2/2] DocBook media: update version number and V4L2 changes
Date: Mon,  4 Aug 2014 11:19:03 +0200
Message-Id: <1407143943-4557-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1407143943-4557-1-git-send-email-hverkuil@xs4all.nl>
References: <1407143943-4557-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Note: the revision text for the v4l2_pix_format change from Laurent
erroneously mentioned 3.16 when it only got merged for 3.17. Fixed
that as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/compat.xml | 24 ++++++++++++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml   | 11 ++++++-----
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index eee6f0f..3a626d1 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2545,6 +2545,30 @@ fields changed from _s32 to _u32.
       </orderedlist>
     </section>
 
+    <section>
+      <title>V4L2 in Linux 3.16</title>
+      <orderedlist>
+        <listitem>
+	  <para>Added event V4L2_EVENT_SOURCE_CHANGE.
+	  </para>
+        </listitem>
+      </orderedlist>
+    </section>
+
+    <section>
+      <title>V4L2 in Linux 3.17</title>
+      <orderedlist>
+        <listitem>
+	  <para>Extended &v4l2-pix-format;. Added format flags.
+	  </para>
+        </listitem>
+        <listitem>
+	  <para>Added compound control types and &VIDIOC-QUERY-EXT-CTRL;.
+	  </para>
+        </listitem>
+      </orderedlist>
+    </section>
+
     <section id="other">
       <title>Relation of V4L2 to other Linux multimedia APIs</title>
 
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index f2f81f0..7cfe618 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -152,10 +152,11 @@ structs, ioctls) must be noted in more detail in the history chapter
 applications. -->
 
       <revision>
-	<revnumber>3.16</revnumber>
-	<date>2014-05-27</date>
-	<authorinitials>lp</authorinitials>
-	<revremark>Extended &v4l2-pix-format;. Added format flags.
+	<revnumber>3.17</revnumber>
+	<date>2014-08-04</date>
+	<authorinitials>lp, hv</authorinitials>
+	<revremark>Extended &v4l2-pix-format;. Added format flags. Added compound control types
+and VIDIOC_QUERY_EXT_CTRL.
 	</revremark>
       </revision>
 
@@ -538,7 +539,7 @@ and discussions on the V4L mailing list.</revremark>
 </partinfo>
 
 <title>Video for Linux Two API Specification</title>
- <subtitle>Revision 3.14</subtitle>
+ <subtitle>Revision 3.17</subtitle>
 
   <chapter id="common">
     &sub-common;
-- 
2.0.1

