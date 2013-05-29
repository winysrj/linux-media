Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3692 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965643Ab3E2LJH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:09:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv1 38/38] DocBook/media/v4l: update VIDIOC_DBG_ documentation
Date: Wed, 29 May 2013 13:00:11 +0200
Message-Id: <1369825211-29770-39-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- Remove the "On failure the structure remains unchanged." part since
  that isn't necessarily true.
- Document the 'size' field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/vidioc-dbg-g-chip-info.xml        |    3 +--
 .../DocBook/media/v4l/vidioc-dbg-g-register.xml         |   15 ++++++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
index 706989d..4c4603c 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
@@ -73,8 +73,7 @@ fields of a &v4l2-dbg-chip-info;
 and call <constant>VIDIOC_DBG_G_CHIP_INFO</constant> with a pointer to
 this structure. On success the driver stores information about the
 selected chip in the <structfield>name</structfield> and
-<structfield>flags</structfield> fields. On failure the structure
-remains unchanged.</para>
+<structfield>flags</structfield> fields.</para>
 
     <para>When <structfield>match.type</structfield> is
 <constant>V4L2_CHIP_MATCH_BRIDGE</constant>,
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
index b3f6100..3d038e7 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
@@ -76,7 +76,7 @@ compiled with the <constant>CONFIG_VIDEO_ADV_DEBUG</constant> option
 to enable these ioctls.</para>
 
     <para>To write a register applications must initialize all fields
-of a &v4l2-dbg-register; and call
+of a &v4l2-dbg-register; except for <structfield>size</structfield> and call
 <constant>VIDIOC_DBG_S_REGISTER</constant> with a pointer to this
 structure. The <structfield>match.type</structfield> and
 <structfield>match.addr</structfield> or <structfield>match.name</structfield>
@@ -91,8 +91,8 @@ written into the register.</para>
 <structfield>reg</structfield> fields, and call
 <constant>VIDIOC_DBG_G_REGISTER</constant> with a pointer to this
 structure. On success the driver stores the register value in the
-<structfield>val</structfield> field. On failure the structure remains
-unchanged.</para>
+<structfield>val</structfield> field and the size (in bytes) of the
+value in <structfield>size</structfield>.</para>
 
     <para>When <structfield>match.type</structfield> is
 <constant>V4L2_CHIP_MATCH_BRIDGE</constant>,
@@ -120,7 +120,7 @@ LinuxTV v4l-dvb repository; see <ulink
 url="http://linuxtv.org/repo/">http://linuxtv.org/repo/</ulink> for
 access instructions.</para>
 
-    <!-- Note for convenience vidioc-dbg-g-chip-ident.sgml
+    <!-- Note for convenience vidioc-dbg-g-chip-info.sgml
 	 contains a duplicate of this table. -->
     <table pgwide="1" frame="none" id="v4l2-dbg-match">
       <title>struct <structname>v4l2_dbg_match</structname></title>
@@ -169,6 +169,11 @@ to the <structfield>type</structfield> field. Currently unused.</entry>
 	    <entry>How to match the chip, see <xref linkend="v4l2-dbg-match" />.</entry>
 	  </row>
 	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>size</structfield></entry>
+	    <entry>The register size in bytes.</entry>
+	  </row>
+	  <row>
 	    <entry>__u64</entry>
 	    <entry><structfield>reg</structfield></entry>
 	    <entry>A register number.</entry>
@@ -183,7 +188,7 @@ register.</entry>
       </tgroup>
     </table>
 
-    <!-- Note for convenience vidioc-dbg-g-chip-ident.sgml
+    <!-- Note for convenience vidioc-dbg-g-chip-info.sgml
 	 contains a duplicate of this table. -->
     <table pgwide="1" frame="none" id="chip-match-types">
       <title>Chip Match Types</title>
-- 
1.7.10.4

