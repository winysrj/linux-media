Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbcGEBbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 40/41] Documentation: subdev-formats.rst: Improve figure caption
Date: Mon,  4 Jul 2016 22:31:15 -0300
Message-Id: <3221711124762ac791392cf4de67d8810b84908a.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a numbering for the figure.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/subdev-formats.rst | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/subdev-formats.rst b/Documentation/linux_tv/media/v4l/subdev-formats.rst
index f9870b6bedb9..cf4be8cab3f9 100644
--- a/Documentation/linux_tv/media/v4l/subdev-formats.rst
+++ b/Documentation/linux_tv/media/v4l/subdev-formats.rst
@@ -2760,9 +2760,7 @@ be named ``MEDIA_BUS_FMT_SRGGB10_2X8_PADHI_LE``.
     :alt:    bayer.png
     :align:  center
 
-    Bayer Patterns
-
-    Bayer filter color patterns
+    **Figure 4.8 Bayer Patterns**
 
 
 
-- 
2.7.4

