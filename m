Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56803 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754228Ab2JUTaG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 15:30:06 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, hverkuil@xs4all.nl
Subject: [PATCH 1/1] v4l: Correct definition of v4l2_buffer.flags related to cache management
Date: Sun, 21 Oct 2012 22:30:02 +0300
Message-Id: <1350847802-26723-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_BUF_FLAG_NO_CACHE_INVALIDATE and V4L2_BUF_FLAG_NO_CACHE_CLEAN were
define incorrectly in the documentation. Fix this by changing the
documentation to match reality.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/io.xml |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index b5d1cbd..7e2f3d7 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -923,7 +923,7 @@ application. Drivers set or clear this flag when the
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant></entry>
-	    <entry>0x0400</entry>
+	    <entry>0x0800</entry>
 	    <entry>Caches do not have to be invalidated for this buffer.
 Typically applications shall use this flag if the data captured in the buffer
 is not going to be touched by the CPU, instead the buffer will, probably, be
@@ -932,7 +932,7 @@ passed on to a DMA-capable hardware unit for further processing or output.
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant></entry>
-	    <entry>0x0800</entry>
+	    <entry>0x1000</entry>
 	    <entry>Caches do not have to be cleaned for this buffer.
 Typically applications shall use this flag for output buffers if the data
 in this buffer has not been created by the CPU but by some DMA-capable unit,
-- 
1.7.2.5

