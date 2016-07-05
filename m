Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38600 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbcGEBbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 02/41] Documentation: pixfmt-nv16.rst: remove an empty column
Date: Mon,  4 Jul 2016 22:30:37 -0300
Message-Id: <d50960617504bc194d8405d8fdda8454d28f5e43.1467670142.git.mchehab@s-opensource.com>
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
 Documentation/linux_tv/media/v4l/pixfmt-nv16.rst | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst
index 74be442eba23..fac4c35f9c38 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst
@@ -30,8 +30,7 @@ swapped, the CrCb plane starts with a Cr byte.
 If the Y plane has pad bytes after each row, then the CbCr plane has as
 many pad bytes after its rows.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
@@ -156,7 +155,6 @@ Each cell is one byte.
        -  
        -  1
 
-       -  
        -  2
 
        -  
@@ -171,7 +169,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -185,7 +182,6 @@ Each cell is one byte.
 
        -  
        -  
-       -  
        -  C
 
        -  
@@ -199,7 +195,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -213,7 +208,6 @@ Each cell is one byte.
 
        -  
        -  
-       -  
        -  C
 
        -  
@@ -231,7 +225,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -245,7 +238,6 @@ Each cell is one byte.
 
        -  
        -  
-       -  
        -  C
 
        -  
@@ -259,7 +251,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -273,7 +264,6 @@ Each cell is one byte.
 
        -  
        -  
-       -  
        -  C
 
        -  
-- 
2.7.4

