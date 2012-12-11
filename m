Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51451 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2LKAhU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 19:37:20 -0500
Received: from avalon.ideasonboard.com (unknown [91.178.169.86])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 42E6635A85
	for <linux-media@vger.kernel.org>; Tue, 11 Dec 2012 01:37:19 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] MAINTAINERS: Add entries for Aptina sensor drivers
Date: Tue, 11 Dec 2012 01:38:23 +0100
Message-Id: <1355186304-17399-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an entry for the mt9m032, mt9p031, mt9t001 and mt9v032 Aptina sensor
drivers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 MAINTAINERS |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9fba9ed..d4b699b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5008,6 +5008,38 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Supported
 F:	drivers/platform/x86/msi-wmi.c
 
+MT9M032 SENSOR DRIVER
+M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/mt9m032.c
+F:	include/media/mt9m032.h
+
+MT9P031 SENSOR DRIVER
+M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/mt9p031.c
+F:	include/media/mt9p031.h
+
+MT9T001 SENSOR DRIVER
+M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/mt9t001.c
+F:	include/media/mt9t001.h
+
+MT9V032 SENSOR DRIVER
+M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/mt9v032.c
+F:	include/media/mt9v032.h
+
 MULTIFUNCTION DEVICES (MFD)
 M:	Samuel Ortiz <sameo@linux.intel.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git
-- 
1.7.8.6

