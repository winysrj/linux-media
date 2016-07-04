Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44747 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbcGDLrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 46/51] Documentation: pixfmt-yuv422m.rst: remove an empty column
Date: Mon,  4 Jul 2016 08:47:07 -0300
Message-Id: <bcdc7432de46b1c093b1f47b8d7aeca3914571ae.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion added an empty column (probably, it was used on
DocBook just to increase spacing.

Remove it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst
index d8e438857e14..0057bc85fd24 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst
@@ -188,7 +188,6 @@ Each cell is one byte.
        -  
        -  1
 
-       -  
        -  2
 
        -  
@@ -204,7 +203,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
@@ -221,7 +219,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
@@ -238,7 +235,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
@@ -255,7 +251,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
-- 
2.7.4


