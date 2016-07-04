Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44799 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbcGDLrX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 41/51] Documentation: pixfmt-y12i.rst: correct format conversion
Date: Mon,  4 Jul 2016 08:47:02 -0300
Message-Id: <9c20608630b91367135d65a1c47691a2936f2254.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The format conversion broke one paragraph into two. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/pixfmt-y12i.rst | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y12i.rst b/Documentation/linux_tv/media/v4l/pixfmt-y12i.rst
index 82a39faaad08..8967e8c33b47 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y12i.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y12i.rst
@@ -19,7 +19,6 @@ pixels from 2 sources interleaved and bit-packed. Each pixel is stored
 in a 24-bit word in the little-endian order. On a little-endian machine
 these pixels can be deinterlaced using
 
-
 .. code-block:: c
 
     __u8 *buf;
@@ -27,12 +26,9 @@ these pixels can be deinterlaced using
     right0 = *(__u16 *)(buf + 1) >> 4;
 
 **Bit-packed representation.**
-
 pixels cross the byte boundary and have a ratio of 3 bytes for each
 interleaved pixel.
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-- 
2.7.4


