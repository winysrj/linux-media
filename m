Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44807 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbcGDLrX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 39/51] Documentation: pixfmt-004.rst: Add an extra reference
Date: Mon,  4 Jul 2016 08:47:00 -0300
Message-Id: <4a7d32c51e7c5fd6f96e17ea93bd17f9762c2207.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One paragraph mentions the YUV422 formats, but doesn't provide
a cross-ref. Add it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/pixfmt-004.rst | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-004.rst b/Documentation/linux_tv/media/v4l/pixfmt-004.rst
index a5599b44fd5d..86d4975a95c9 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-004.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-004.rst
@@ -43,12 +43,12 @@ world.
 
 For some formats, data is stored in separate, discontiguous memory
 buffers. Those formats are identified by a separate set of FourCC codes
-and are referred to as "multi-planar formats". For example, a YUV422
-frame is normally stored in one memory buffer, but it can also be placed
-in two or three separate buffers, with Y component in one buffer and
-CbCr components in another in the 2-planar version or with each
-component in its own buffer in the 3-planar case. Those sub-buffers are
-referred to as "planes".
+and are referred to as "multi-planar formats". For example, a
+:ref:`YUV422 <V4L2-PIX-FMT-YUV422M>` frame is normally stored in one
+memory buffer, but it can also be placed in two or three separate
+buffers, with Y component in one buffer and CbCr components in another
+in the 2-planar version or with each component in its own buffer in the
+3-planar case. Those sub-buffers are referred to as "*planes*".
 
 
 .. ------------------------------------------------------------------------------
-- 
2.7.4


