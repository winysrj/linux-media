Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38699 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbcGEBb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 23/41] Documentation: pixfmt-nv16m.rst: remove an empty column
Date: Mon,  4 Jul 2016 22:30:58 -0300
Message-Id: <9cb2c4840123dc903c9025852e76063f085b8631.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion added an empty column (probably, it was used on
DocBook just to increase spacing.

Remove it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/pixfmt-m420.rst | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-m420.rst b/Documentation/linux_tv/media/v4l/pixfmt-m420.rst
index f03042653bcd..2f1f447fbe0a 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-m420.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-m420.rst
@@ -129,7 +129,6 @@ Each cell is one byte.
        -  
        -  1
 
-       -  
        -  2
 
        -  
@@ -144,7 +143,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -158,7 +156,6 @@ Each cell is one byte.
 
        -  
        -  
-       -  
        -  C
 
        -  
@@ -172,7 +169,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -191,7 +187,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -205,7 +200,6 @@ Each cell is one byte.
 
        -  
        -  
-       -  
        -  C
 
        -  
@@ -219,7 +213,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
-- 
2.7.4

