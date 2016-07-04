Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44763 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbcGDLrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 42/51] Documentation: pixfmt-uyvy.rst: remove an empty column
Date: Mon,  4 Jul 2016 08:47:03 -0300
Message-Id: <4e01925613f58c60178fdaa5aa0d18f725ea0c28.1467629489.git.mchehab@s-opensource.com>
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
 Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst b/Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst
index 1184dd629d21..8eaacd3af3df 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst
@@ -24,8 +24,6 @@ half the horizontal resolution of the Y component.
 
 Each cell is one byte.
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -130,7 +128,6 @@ Each cell is one byte.
        -  
        -  1
 
-       -  
        -  2
 
        -  
@@ -146,7 +143,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
@@ -163,7 +159,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
@@ -180,7 +175,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
@@ -197,7 +191,6 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
-- 
2.7.4


