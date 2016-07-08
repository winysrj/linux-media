Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48202 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbcGHTdw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 15:33:52 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH] [media] doc-rst: fix the Z16 format definition
Date: Fri,  8 Jul 2016 16:33:47 -0300
Message-Id: <4606ce43929a0a13443d691f53928ac58b002742.1468006421.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset 811c6d6a4243 ("[media] V4L: fix the Z16 format definition")
fixed the definition for DocBook, but we need to replicate it
also to ReST.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/pixfmt-z16.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-z16.rst b/Documentation/media/uapi/v4l/pixfmt-z16.rst
index c5cce2db78b6..4ebc561d0480 100644
--- a/Documentation/media/uapi/v4l/pixfmt-z16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-z16.rst
@@ -8,7 +8,7 @@ V4L2_PIX_FMT_Z16 ('Z16 ')
 
 *man V4L2_PIX_FMT_Z16(2)*
 
-Interleaved grey-scale image, e.g. from a stereo-pair
+16-bit depth data with distance values at each pixel
 
 
 Description
-- 
2.7.4

