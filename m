Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbcGVPDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 11:03:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 01/11] [media] v4l2-framework.rst: remove videobuf quick chapter
Date: Fri, 22 Jul 2016 12:02:57 -0300
Message-Id: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we merged the videobuf chapter at the kABI section, and it
is a way more complete, just remove the small videobuf chapter
that came from framework.txt.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-framework.rst | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-framework.rst b/Documentation/media/kapi/v4l2-framework.rst
index c97ffd0d783b..9204d9329124 100644
--- a/Documentation/media/kapi/v4l2-framework.rst
+++ b/Documentation/media/kapi/v4l2-framework.rst
@@ -80,22 +80,6 @@ The V4L2 framework also optionally integrates with the media framework. If a
 driver sets the struct v4l2_device mdev field, sub-devices and video nodes
 will automatically appear in the media framework as entities.
 
-
-
-video buffer helper functions
------------------------------
-
-The v4l2 core API provides a set of standard methods (called "videobuf")
-for dealing with video buffers. Those methods allow a driver to implement
-read(), mmap() and overlay() in a consistent way.  There are currently
-methods for using video buffers on devices that supports DMA with
-scatter/gather method (videobuf-dma-sg), DMA with linear access
-(videobuf-dma-contig), and vmalloced buffers, mostly used on USB drivers
-(videobuf-vmalloc).
-
-Please see Documentation/video4linux/videobuf for more information on how
-to use the videobuf layer.
-
 struct v4l2_fh
 --------------
 
-- 
2.7.4

