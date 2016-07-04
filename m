Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44813 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbcGDLrX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 25/51] Documentation: selection-api-005.rst: Fix ReST parsing
Date: Mon,  4 Jul 2016 08:46:46 -0300
Message-Id: <693f3fdf9cee4dc5164f89d0b577cf7c31e3c225.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ReST markup is limited: it doesn't accept a const just
after a reference. So, change the documentation to avoid such
constraint.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/selection-api-005.rst | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/selection-api-005.rst b/Documentation/linux_tv/media/v4l/selection-api-005.rst
index 6fdb0af2b13d..78448023a79a 100644
--- a/Documentation/linux_tv/media/v4l/selection-api-005.rst
+++ b/Documentation/linux_tv/media/v4l/selection-api-005.rst
@@ -15,10 +15,11 @@ appropriate targets. The V4L2 API lacks any support for composing to and
 cropping from an image inside a memory buffer. The application could
 configure a capture device to fill only a part of an image by abusing
 V4L2 API. Cropping a smaller image from a larger one is achieved by
-setting the field struct
-:ref:`v4l2_pix_format <v4l2-pix-format>```::bytesperline``.
-Introducing an image offsets could be done by modifying field struct
-:ref:`v4l2_buffer <v4l2-buffer>```::m_userptr`` before calling
+setting the field ``bytesperline`` at struct
+:ref:`v4l2_pix_format <v4l2-pix-format>`.
+Introducing an image offsets could be done by modifying field ``m_userptr``
+at struct
+:ref:`v4l2_buffer <v4l2-buffer>` before calling
 :ref:`VIDIOC_QBUF`. Those operations should be avoided because they are not
 portable (endianness), and do not work for macroblock and Bayer formats
 and mmap buffers. The selection API deals with configuration of buffer
-- 
2.7.4


