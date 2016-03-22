Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:37068 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436AbcCVK35 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 06:29:57 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] vidioc-g-edid.xml: be explicit about zeroing the reserved array
Date: Tue, 22 Mar 2016 11:30:27 +0100
Message-Id: <1458642629-15742-2-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1458642629-15742-1-git-send-email-hans.verkuil@cisco.com>
References: <1458642629-15742-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The G/S_EDID documentation did not explicitly state that the reserved array
should be zeroed by the application.

Also add the missing VIDIOC_SUBDEV_G/S_EDID ioctl names to the header.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-g-edid.xml | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-edid.xml b/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
index 2702536..b7602d3 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
@@ -1,6 +1,6 @@
 <refentry id="vidioc-g-edid">
   <refmeta>
-    <refentrytitle>ioctl VIDIOC_G_EDID, VIDIOC_S_EDID</refentrytitle>
+    <refentrytitle>ioctl VIDIOC_G_EDID, VIDIOC_S_EDID, VIDIOC_SUBDEV_G_EDID, VIDIOC_SUBDEV_S_EDID</refentrytitle>
     &manvol;
   </refmeta>
 
@@ -71,7 +71,8 @@
 
     <para>To get the EDID data the application has to fill in the <structfield>pad</structfield>,
     <structfield>start_block</structfield>, <structfield>blocks</structfield> and <structfield>edid</structfield>
-    fields and call <constant>VIDIOC_G_EDID</constant>. The current EDID from block
+    fields, zero the <structfield>reserved</structfield> array and call
+    <constant>VIDIOC_G_EDID</constant>. The current EDID from block
     <structfield>start_block</structfield> and of size <structfield>blocks</structfield>
     will be placed in the memory <structfield>edid</structfield> points to. The <structfield>edid</structfield>
     pointer must point to memory at least <structfield>blocks</structfield>&nbsp;*&nbsp;128 bytes
@@ -92,8 +93,9 @@
     the driver will set <structfield>blocks</structfield> to 0 and it returns 0.</para>
 
     <para>To set the EDID blocks of a receiver the application has to fill in the <structfield>pad</structfield>,
-    <structfield>blocks</structfield> and <structfield>edid</structfield> fields and set
-    <structfield>start_block</structfield> to 0. It is not possible to set part of an EDID,
+    <structfield>blocks</structfield> and <structfield>edid</structfield> fields, set
+    <structfield>start_block</structfield> to 0 and zero the <structfield>reserved</structfield> array.
+    It is not possible to set part of an EDID,
     it is always all or nothing. Setting the EDID data is only valid for receivers as it makes
     no sense for a transmitter.</para>
 
-- 
2.7.0

