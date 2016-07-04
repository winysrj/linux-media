Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44741 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbcGDLrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 45/51] Documentation: pixfmt-41p.rst: remove empty columns
Date: Mon,  4 Jul 2016 08:47:06 -0300
Message-Id: <5e1a20e750f5bc603be33162db5513658c29a939.1467629489.git.mchehab@s-opensource.com>
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
 Documentation/linux_tv/media/v4l/pixfmt-y41p.rst | 27 ------------------------
 1 file changed, 27 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y41p.rst b/Documentation/linux_tv/media/v4l/pixfmt-y41p.rst
index bb10de3da994..1f8fe468001d 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y41p.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y41p.rst
@@ -152,8 +152,6 @@ Each cell is one byte.
 
 **Color Sample Location..**
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -164,25 +162,20 @@ Each cell is one byte.
        -  
        -  0
 
-       -  
        -  1
 
        -  
        -  2
 
-       -  
        -  3
 
-       -  
        -  4
 
-       -  
        -  5
 
        -  
        -  6
 
-       -  
        -  7
 
     -  .. row 2
@@ -191,27 +184,22 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
 
        -  Y
 
-       -  
        -  Y
 
-       -  
        -  Y
 
-       -  
        -  Y
 
        -  C
 
        -  Y
 
-       -  
        -  Y
 
     -  .. row 3
@@ -220,27 +208,22 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
 
        -  Y
 
-       -  
        -  Y
 
-       -  
        -  Y
 
-       -  
        -  Y
 
        -  C
 
        -  Y
 
-       -  
        -  Y
 
     -  .. row 4
@@ -249,27 +232,22 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
 
        -  Y
 
-       -  
        -  Y
 
-       -  
        -  Y
 
-       -  
        -  Y
 
        -  C
 
        -  Y
 
-       -  
        -  Y
 
     -  .. row 5
@@ -278,25 +256,20 @@ Each cell is one byte.
 
        -  Y
 
-       -  
        -  Y
 
        -  C
 
        -  Y
 
-       -  
        -  Y
 
-       -  
        -  Y
 
-       -  
        -  Y
 
        -  C
 
        -  Y
 
-       -  
        -  Y
-- 
2.7.4


