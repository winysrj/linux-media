Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44752 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbcGDLrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 47/51] Documentation: pixfmt-yuv444m.rst: remove empty columns
Date: Mon,  4 Jul 2016 08:47:08 -0300
Message-Id: <f5f8d7d91f5ccef0093d7428df955f947c7f120d.1467629489.git.mchehab@s-opensource.com>
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
 Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst
index c70e74631d4d..556c37c34d67 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst
@@ -38,8 +38,6 @@ described in :ref:`planar-apis`.
 
 Each cell is one byte.
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -213,13 +211,10 @@ Each cell is one byte.
        -  
        -  0
 
-       -  
        -  1
 
-       -  
        -  2
 
-       -  
        -  3
 
     -  .. row 2
@@ -228,13 +223,10 @@ Each cell is one byte.
 
        -  YC
 
-       -  
        -  YC
 
-       -  
        -  YC
 
-       -  
        -  YC
 
     -  .. row 3
@@ -243,13 +235,10 @@ Each cell is one byte.
 
        -  YC
 
-       -  
        -  YC
 
-       -  
        -  YC
 
-       -  
        -  YC
 
     -  .. row 4
@@ -258,13 +247,10 @@ Each cell is one byte.
 
        -  YC
 
-       -  
        -  YC
 
-       -  
        -  YC
 
-       -  
        -  YC
 
     -  .. row 5
@@ -273,11 +259,8 @@ Each cell is one byte.
 
        -  YC
 
-       -  
        -  YC
 
-       -  
        -  YC
 
-       -  
        -  YC
-- 
2.7.4


