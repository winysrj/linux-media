Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51594 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784Ab3HIMpI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 08:45:08 -0400
Received: from avalon.ideasonboard.com (unknown [109.134.65.8])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 514AB363DA
	for <linux-media@vger.kernel.org>; Fri,  9 Aug 2013 14:44:49 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Add entry for the Aptina PLL library
Date: Fri,  9 Aug 2013 14:46:11 +0200
Message-Id: <1376052371-11586-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a maintainers entry for the Aptina PLL library, and rename the
Aptina sensors entries to make it clear they refer to Aptina camera
sensors.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 MAINTAINERS | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bf61e04..9b12947 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -638,6 +638,12 @@ S:	Maintained
 F:	drivers/net/appletalk/
 F:	net/appletalk/
 
+APTINA CAMERA SENSOR PLL
+M:	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/i2c/aptina-pll.*
+
 ARASAN COMPACT FLASH PATA CONTROLLER
 M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	linux-ide@vger.kernel.org
@@ -5496,7 +5502,7 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Supported
 F:	drivers/platform/x86/msi-wmi.c
 
-MT9M032 SENSOR DRIVER
+MT9M032 APTINA SENSOR DRIVER
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
@@ -5504,7 +5510,7 @@ S:	Maintained
 F:	drivers/media/i2c/mt9m032.c
 F:	include/media/mt9m032.h
 
-MT9P031 SENSOR DRIVER
+MT9P031 APTINA CAMERA SENSOR
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
@@ -5512,7 +5518,7 @@ S:	Maintained
 F:	drivers/media/i2c/mt9p031.c
 F:	include/media/mt9p031.h
 
-MT9T001 SENSOR DRIVER
+MT9T001 APTINA CAMERA SENSOR
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
@@ -5520,7 +5526,7 @@ S:	Maintained
 F:	drivers/media/i2c/mt9t001.c
 F:	include/media/mt9t001.h
 
-MT9V032 SENSOR DRIVER
+MT9V032 APTINA CAMERA SENSOR
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-- 
Regards,

Laurent Pinchart

