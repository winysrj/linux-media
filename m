Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39222 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751353Ab2KPUvq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 15:51:46 -0500
Received: from salottisipuli.retiisi.org.uk (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:6d9a::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id D7D376009F
	for <linux-media@vger.kernel.org>; Fri, 16 Nov 2012 22:51:44 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: There's no __unsigned
Date: Fri, 16 Nov 2012 22:51:44 +0200
Message-Id: <1353099104-1364-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correct a typo. v4l2_plane.m.userptr is unsigned long, not __unsigned long.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/io.xml |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index bcd1c8f7..1565f31 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -736,7 +736,7 @@ should set this to 0.</entry>
 	  </row>
 	  <row>
 	    <entry></entry>
-	    <entry>__unsigned long</entry>
+	    <entry>unsigned long</entry>
 	    <entry><structfield>userptr</structfield></entry>
 	    <entry>When the memory type in the containing &v4l2-buffer; is
 	      <constant>V4L2_MEMORY_USERPTR</constant>, this is a userspace
-- 
1.7.2.5

