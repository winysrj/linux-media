Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:50712 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbcEaQ4Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2016 12:56:25 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/2] [media] DocBook: add dmabuf as streaming I/O in VIDIOC_REQBUFS description
Date: Tue, 31 May 2016 12:56:07 -0400
Message-Id: <1464713768-21213-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 4b9c1cb641c46 ("[media] Documentation: media: description of DMABUF
importing in V4L2") documented the V4L2 dma-buf importing support but did
not update the VIDIOC_REQBUFS description, so only the Memory Mapping and
User Pointer I/O methods are mentioned.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
index 0f193fda0470..6f529e100ea4 100644
--- a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
@@ -6,7 +6,7 @@
 
   <refnamediv>
     <refname>VIDIOC_REQBUFS</refname>
-    <refpurpose>Initiate Memory Mapping or User Pointer I/O</refpurpose>
+    <refpurpose>Initiate Memory Mapping, User Pointer or DMA Buffer I/O</refpurpose>
   </refnamediv>
 
   <refsynopsisdiv>
-- 
2.5.5

