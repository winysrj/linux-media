Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44751 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbcGDLrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 44/51] Documentation: pixfmt-vyuy.rst: remove an empty column
Date: Mon,  4 Jul 2016 08:47:05 -0300
Message-Id: <60458a50469b71547673da8be8ed5663d0b108dc.1467629489.git.mchehab@s-opensource.com>
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
 Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst b/Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst
index 7e25aee4f968..9ce531834d9a 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst
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
@@ -133,7 +129,6 @@ Each cell is one byte.
        -  
        -  2
 
-       -  
        -  3
 
     -  .. row 2
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


