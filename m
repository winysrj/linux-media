Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44745 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbcGDLrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 49/51] Documentation: pixfmt-yuv411p.rst: remove an empty column
Date: Mon,  4 Jul 2016 08:47:10 -0300
Message-Id: <0811b261f4ed2dfe4a566fce5270a4b265952f96.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion added an empty column (probably, it was used on
DocBook just to increase spacing.

It also added an extra line on one of the texts, breaking
the original paragraph into two ones.

Remove them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst
index 0fe1cacf7b7a..9521c4431c78 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst
@@ -30,11 +30,9 @@ have ¼ as many pad bytes after their rows. In other words, four C x rows
 (including padding) is exactly as long as one Y row (including padding).
 
 **Byte Order..**
-
 Each cell is one byte.
 
 
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -152,13 +150,11 @@ Each cell is one byte.
        -  
        -  0
 
-       -  
        -  1
 
        -  
        -  2
 
-       -  
        -  3
 
     -  .. row 2
@@ -167,14 +163,12 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
 
        -  Y
 
-       -  
        -  Y
 
     -  .. row 3
@@ -183,14 +177,12 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
 
        -  Y
 
-       -  
        -  Y
 
     -  .. row 4
@@ -199,14 +191,12 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
 
        -  Y
 
-       -  
        -  Y
 
     -  .. row 5
@@ -215,12 +205,10 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
 
        -  Y
 
-       -  
        -  Y
-- 
2.7.4


