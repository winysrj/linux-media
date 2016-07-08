Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56825 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbcGHSlP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 14:41:15 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH] [media] doc-rst: add dmabuf as streaming I/O in VIDIOC_REQBUFS description
Date: Fri,  8 Jul 2016 15:41:06 -0300
Message-Id: <53ce523986cef185865a1c417269fcc5c48a1697.1468003247.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 707e65831d3b("[media] DocBook: add dmabuf as streaming I/O
in VIDIOC_REQBUFS description") added DMABUF to reqbufs description,
but, as we're migrating to ReST markup, we need to keep it in sync
with the change.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index c25b0719c2ff..5d0bc6d31c07 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -9,7 +9,7 @@ ioctl VIDIOC_REQBUFS
 Name
 ====
 
-VIDIOC_REQBUFS - Initiate Memory Mapping or User Pointer I/O
+VIDIOC_REQBUFS - Initiate Memory Mapping, User Pointer I/O or DMA buffer I/O
 
 
 Synopsis
-- 
2.7.4

