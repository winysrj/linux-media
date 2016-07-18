Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45820 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbcGRB42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 12/36] [media] doc-rst: add gspca cardlist
Date: Sun, 17 Jul 2016 22:55:55 -0300
Message-Id: <8b2f4b39ef98a60c703f5306e88bcd56bc0ecfe6.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/cardlist.rst             |  1 +
 .../media/v4l-drivers/{gspca.rst => gspca-cardlist.rst}  | 16 ++++++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)
 rename Documentation/media/v4l-drivers/{gspca.rst => gspca-cardlist.rst} (97%)

diff --git a/Documentation/media/v4l-drivers/cardlist.rst b/Documentation/media/v4l-drivers/cardlist.rst
index 4632a6857f0e..8a0728d20684 100644
--- a/Documentation/media/v4l-drivers/cardlist.rst
+++ b/Documentation/media/v4l-drivers/cardlist.rst
@@ -15,3 +15,4 @@ Cards List
 	tm6000-cardlist
 	tuner-cardlist
 	usbvision-cardlist
+	gspca-cardlist
diff --git a/Documentation/media/v4l-drivers/gspca.rst b/Documentation/media/v4l-drivers/gspca-cardlist.rst
similarity index 97%
rename from Documentation/media/v4l-drivers/gspca.rst
rename to Documentation/media/v4l-drivers/gspca-cardlist.rst
index d2ba80bb7af5..33a8ac7d73ab 100644
--- a/Documentation/media/v4l-drivers/gspca.rst
+++ b/Documentation/media/v4l-drivers/gspca-cardlist.rst
@@ -1,11 +1,14 @@
-List of the webcams known by gspca.
+The gspca cards list
+====================
 
-The modules are:
-	gspca_main	main driver
-	gspca_xxxx	subdriver module with xxxx as follows
+The modules for the gspca webcam drivers are:
 
-xxxx		vend:prod
-----
+- gspca_main: main driver
+- gspca\_\ *driver*: subdriver module with *driver* as follows
+
+=========	=========	====================================================================
+*driver*	vend:prod	Device
+=========	=========	====================================================================
 spca501		0000:0000	MystFromOri Unknown Camera
 spca508		0130:0130	Clone Digital Webcam 11043
 zc3xx		03f0:1b07	HP Premium Starter Cam
@@ -406,3 +409,4 @@ sn9c20x		a168:0614	Dino-Lite Digital Microscope (SN9C201 + MT9M111)
 sn9c20x		a168:0615	Dino-Lite Digital Microscope (SN9C201 + MT9M111)
 sn9c20x		a168:0617	Dino-Lite Digital Microscope (SN9C201 + MT9M111)
 spca561		abcd:cdee	Petcam
+=========	=========	====================================================================
-- 
2.7.4

