Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45822 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbcGRB43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 35/36] [media] doc-rst: add documentation about IR on V4L boards
Date: Sun, 17 Jul 2016 22:56:18 -0300
Message-Id: <31cae7ca8d39af189486458ad8a3c239e2cb2cd2.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This section is outdated, but let's add it, after converting
to ReST, and then fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst       |  1 +
 Documentation/media/v4l-drivers/v4l-with-ir.rst | 15 +++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index d660623eeea6..8a026455b09c 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -20,6 +20,7 @@ License".
 	:numbered:
 
 	fourcc
+	v4l-with-ir
 	cardlist
 	cafe_ccic
 	cpia2
diff --git a/Documentation/media/v4l-drivers/v4l-with-ir.rst b/Documentation/media/v4l-drivers/v4l-with-ir.rst
index 0da47a847056..334174a52bda 100644
--- a/Documentation/media/v4l-drivers/v4l-with-ir.rst
+++ b/Documentation/media/v4l-drivers/v4l-with-ir.rst
@@ -1,9 +1,13 @@
-
 infrared remote control support in video4linux drivers
 ======================================================
 
+Author: Gerd Hoffmann
 
-basics
+.. note::
+
+   This section is outdated.
+
+Basics
 ------
 
 Current versions use the linux input layer to support infrared
@@ -23,7 +27,7 @@ Feel free to contact me in case of trouble.  Note that the ir-kbd-*
 modules work on 2.6.x kernels only through ...
 
 
-how it works
+How it works
 ------------
 
 The modules register the remote as keyboard within the linux input
@@ -42,7 +46,7 @@ events and the like.  You can also use the kbd utility to change the
 keymaps (2.6.x kernels only through).
 
 
-using with lircd
+Using with lircd
 ================
 
 The cvs version of the lircd daemon supports reading events from the
@@ -50,7 +54,7 @@ linux input layer (via event device).  The input layer tools tarball
 comes with a lircd config file.
 
 
-using without lircd
+Using without lircd
 ===================
 
 XFree86 likely can be configured to recognise the remote keys.  Once I
@@ -69,4 +73,3 @@ Have fun,
   Gerd
 
 --
-Gerd Knorr <kraxel@bytesex.org>
-- 
2.7.4

