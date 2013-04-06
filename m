Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1151 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab3DFL0I (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 07:26:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 6/7] v4l2 DocBook: document the new register range support.
Date: Sat,  6 Apr 2013 13:25:51 +0200
Message-Id: <1365247552-26795-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365247552-26795-1-git-send-email-hverkuil@xs4all.nl>
References: <1365247552-26795-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/vidioc-dbg-g-chip-info.xml   |   29 +++++++++++++++++---
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
index e1cece6..c79e4a0 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
@@ -149,9 +149,9 @@ to the <structfield>type</structfield> field.</entry>
 	    <entry>How to match the chip, see <xref linkend="name-v4l2-dbg-match" />.</entry>
 	  </row>
 	  <row>
-	    <entry>char</entry>
-	    <entry><structfield>name[32]</structfield></entry>
-	    <entry>The name of the chip.</entry>
+	    <entry>__u32</entry>
+	    <entry><structfield>range</structfield></entry>
+	    <entry>Return information about this register range.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -161,8 +161,29 @@ is set, then the driver supports reading registers from the device. If
 <constant>V4L2_CHIP_FL_WRITABLE</constant> is set, then it supports writing registers.</entry>
 	  </row>
 	  <row>
+	    <entry>char</entry>
+	    <entry><structfield>name[32]</structfield></entry>
+	    <entry>The name of the chip.</entry>
+	  </row>
+	  <row>
+	    <entry>char</entry>
+	    <entry><structfield>range_name[32]</structfield></entry>
+	    <entry>The name of this register range. This may be an empty string.</entry>
+	  </row>
+	  <row>
+	    <entry>__u64</entry>
+	    <entry><structfield>range_start</structfield></entry>
+	    <entry>The start of the register range.</entry>
+	  </row>
+	  <row>
+	    <entry>__u64</entry>
+	    <entry><structfield>range_size</structfield></entry>
+	    <entry>The size of the register range in bytes. This may be 0 if no such
+	    information is available.</entry>
+	  </row>
+	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved[8]</structfield></entry>
+	    <entry><structfield>reserved[16]</structfield></entry>
 	    <entry>Reserved fields, both application and driver must set these to 0.</entry>
 	  </row>
 	</tbody>
-- 
1.7.10.4

