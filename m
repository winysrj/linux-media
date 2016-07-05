Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38717 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbcGEBb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 21/41] Documentation: pixfmt-nv16m.rst: remove an empty column
Date: Mon,  4 Jul 2016 22:30:56 -0300
Message-Id: <0e828e1c23fde5c6e656802dc3ae91166003d249.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion added an empty column (probably, it was used on
DocBook just to increase spacing.

It also added an extra line on one of the texts, breaking
the original paragraph into two ones.

Remove them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
index 9caa243550a1..2157663fa6c2 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
@@ -34,7 +34,6 @@ used only in drivers and applications that support the multi-planar API,
 described in :ref:`planar-apis`.
 
 **Byte Order..**
-
 Each cell is one byte.
 
 
@@ -163,7 +162,6 @@ Each cell is one byte.
        -  
        -  1
 
-       -  
        -  2
 
        -  
@@ -178,7 +176,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -192,7 +189,6 @@ Each cell is one byte.
 
        -  
        -  
-       -  
        -  C
 
        -  
@@ -206,7 +202,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -220,7 +215,6 @@ Each cell is one byte.
 
        -  
        -  
-       -  
        -  C
 
        -  
@@ -238,7 +232,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -252,7 +245,6 @@ Each cell is one byte.
 
        -  
        -  
-       -  
        -  C
 
        -  
@@ -266,7 +258,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -280,7 +271,6 @@ Each cell is one byte.
 
        -  
        -  
-       -  
        -  C
 
        -  
-- 
2.7.4

