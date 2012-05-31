Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35841 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756095Ab2EaWvJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 May 2012 18:51:09 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: Correct create_bufs documentation
Date: Fri,  1 Jun 2012 01:51:05 +0300
Message-Id: <1338504665-15113-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch id 6016af82eafcb6e086a8f2a2197b46029a843d68 ("[media] v4l2: use __u32
rather than enums in ioctl() structs") unintentionally changes the type of
the format field in struct v4l2_create_buffers from struct v4l2_format to
__u32. Revert that change.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
Hi Mauro and others,

I found a documentation issue in the __u32 conversion patch --- it changes
the type of a field in documentation it shouldn't. This patch fixes the
issue.

This problem only existed in the documentation, the struct itself is fine.

Regards,

 .../DocBook/media/v4l/vidioc-create-bufs.xml       |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
index 765549f..7cf3116 100644
--- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
@@ -108,10 +108,9 @@ information.</para>
 /></entry>
 	  </row>
 	  <row>
-	    <entry>__u32</entry>
+	    <entry>&v4l2-format;</entry>
 	    <entry><structfield>format</structfield></entry>
-	    <entry>Filled in by the application, preserved by the driver.
-	    See <xref linkend="v4l2-format" />.</entry>
+	    <entry>Filled in by the application, preserved by the driver.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-- 
1.7.2.5

