Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44737 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbcGDLrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 50/51] Documentation: pixfmt-nv12.rst: remove empty columns
Date: Mon,  4 Jul 2016 08:47:11 -0300
Message-Id: <0ea0c4866ab75fbb9a41f0420be9afa69cdd8f72.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion added empty columns (probably, it was used on
DocBook just to increase spacing.

Remove them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/pixfmt-nv12.rst | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
index df26d495c892..363e9484aef4 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
@@ -118,8 +118,6 @@ Each cell is one byte.
 
 **Color Sample Location..**
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -133,7 +131,6 @@ Each cell is one byte.
        -  
        -  1
 
-       -  
        -  2
 
        -  
@@ -148,7 +145,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -162,7 +158,6 @@ Each cell is one byte.
 
        -  
        -  
-       -  
        -  C
 
        -  
@@ -172,11 +167,10 @@ Each cell is one byte.
        -  1
 
        -  Y
-
        -  
+
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -191,11 +185,10 @@ Each cell is one byte.
        -  2
 
        -  Y
-
        -  
+
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -209,7 +202,6 @@ Each cell is one byte.
 
        -  
        -  
-       -  
        -  C
 
        -  
@@ -223,7 +215,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
-- 
2.7.4


