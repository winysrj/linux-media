Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44753 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbcGDLrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 43/51] Documentation: pixfmt-yvyu.rst: remove an empty column
Date: Mon,  4 Jul 2016 08:47:04 -0300
Message-Id: <08ab83b84ddac7c42663573f971039a1164dca01.1467629489.git.mchehab@s-opensource.com>
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
 Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst b/Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst
index 45e3dcd7d222..576af343b81b 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst
@@ -24,8 +24,6 @@ half the horizontal resolution of the Y component.
 
 Each cell is one byte.
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -115,8 +113,6 @@ Each cell is one byte.
 
 **Color Sample Location..**
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -130,7 +126,6 @@ Each cell is one byte.
        -  
        -  1
 
-       -  
        -  2
 
        -  
@@ -146,7 +141,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
@@ -163,7 +157,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
@@ -180,7 +173,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
@@ -197,7 +189,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
-- 
2.7.4


