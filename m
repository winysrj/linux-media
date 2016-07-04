Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44740 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbcGDLrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 48/51] Documentation: pixfmt-yuv422p.rst: remove an empty column
Date: Mon,  4 Jul 2016 08:47:09 -0300
Message-Id: <c47c098426668bdd88b299af158d2b7b68b1fbff.1467629489.git.mchehab@s-opensource.com>
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
 Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst
index a7934540f69a..c5efeadc0e9c 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst
@@ -171,7 +171,6 @@ Each cell is one byte.
        -  
        -  1
 
-       -  
        -  2
 
        -  
@@ -187,7 +186,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
@@ -204,7 +202,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
@@ -221,7 +218,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
@@ -238,7 +234,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
-- 
2.7.4


