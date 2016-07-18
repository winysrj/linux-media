Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45862 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbcGRB4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 11/36] [media] doc-rst: convert cafe_ccic file to rst format
Date: Sun, 17 Jul 2016 22:55:54 -0300
Message-Id: <8f6174a07e3ef69d51776062d23f4627751cb3a5.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file is almost ok, but it needs chapter/sections
and a code-block.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/cafe_ccic.rst | 24 +++++++++++++++---------
 Documentation/media/v4l-drivers/index.rst     |  1 +
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/Documentation/media/v4l-drivers/cafe_ccic.rst b/Documentation/media/v4l-drivers/cafe_ccic.rst
index 88821022a5de..b98eb3b7cb4a 100644
--- a/Documentation/media/v4l-drivers/cafe_ccic.rst
+++ b/Documentation/media/v4l-drivers/cafe_ccic.rst
@@ -1,3 +1,11 @@
+The cafe_ccic driver
+====================
+
+Author: Jonathan Corbet <corbet@lwn.net>
+
+Introdution
+-----------
+
 "cafe_ccic" is a driver for the Marvell 88ALP01 "cafe" CMOS camera
 controller.  This is the controller found in first-generation OLPC systems,
 and this driver was written with support from the OLPC project.
@@ -10,11 +18,16 @@ sensor is known to work with this controller at this time.
 
 To try it out: either of these commands will work:
 
-     mplayer tv:// -tv driver=v4l2:width=640:height=480 -nosound
-     mplayer tv:// -tv driver=v4l2:width=640:height=480:outfmt=bgr16 -nosound
+.. code-block:: none
+
+     $ mplayer tv:// -tv driver=v4l2:width=640:height=480 -nosound
+     $ mplayer tv:// -tv driver=v4l2:width=640:height=480:outfmt=bgr16 -nosound
 
 The "xawtv" utility also works; gqcam does not, for unknown reasons.
 
+Load time options
+-----------------
+
 There are a few load-time options, most of which can be changed after
 loading via sysfs as well:
 
@@ -45,10 +58,3 @@ loading via sysfs as well:
  - flip: If this boolean parameter is set, the sensor will be instructed to
    invert the video image.  Whether it makes sense is determined by how
    your particular camera is mounted.
-
-Work is ongoing with this driver, stay tuned.
-
-jon
-
-Jonathan Corbet
-corbet@lwn.net
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 6391f1622e26..72a96206fcf8 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -20,3 +20,4 @@ License".
 
 	fourcc
 	cardlist
+	cafe_ccic
-- 
2.7.4

