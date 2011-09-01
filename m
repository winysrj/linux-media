Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:16475 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757106Ab1IALJL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Sep 2011 07:09:11 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, pawel@osciak.com,
	mchehab@infradead.org, m.szyprowski@samsung.com
Subject: [PATCH 1/1] v4l: Add note on buffer locking to memory and DMA mapping to PREPARE_BUF
Date: Thu,  1 Sep 2011 14:08:56 +0300
Message-Id: <1314875336-21811-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <Pine.LNX.4.64.1109010904300.21309@axis700.grange>
References: <Pine.LNX.4.64.1109010904300.21309@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add note to documentation of VIDIOC_PREPARE_BUF that the preparation done by
the IOCTL may include locking buffers to system memory and creating DMA
mappings for them.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 .../DocBook/media/v4l/vidioc-prepare-buf.xml       |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
index 509e752..7177c2f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
@@ -52,9 +52,11 @@
 <constant>VIDIOC_PREPARE_BUF</constant> ioctl to pass ownership of the buffer
 to the driver before actually enqueuing it, using the
 <constant>VIDIOC_QBUF</constant> ioctl, and to prepare it for future I/O.
-Such preparations may include cache invalidation or cleaning. Performing them
-in advance saves time during the actual I/O. In case such cache operations are
-not required, the application can use one of
+Such preparations may include locking the buffer to system memory and
+creating DMA mapping for it (on the first time
+<constant>VIDIOC_PREPARE_BUF</constant> is called), cache invalidation or
+cleaning. Performing them in advance saves time during the actual I/O. In
+case such cache operations are not required, the application can use one of
 <constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant> and
 <constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant> flags to skip the respective
 step.</para>
-- 
1.7.2.5

