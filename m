Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37198 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752462Ab2KLWOm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 17:14:42 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	media-workshop@linuxtv.org
Subject: [PATCH 1/1] MAINTAINERS: Update maintainer for smiapp and adp1653 drivers
Date: Tue, 13 Nov 2012 00:14:39 +0200
Message-Id: <1352758479-6451-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20121112083715.3d9a6b37@redhat.com>
References: <20121112083715.3d9a6b37@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

And the smiapp-pll which is in a way part of the smiapp driver.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 MAINTAINERS |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f4b3aa8..9c2a6bb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -336,6 +336,13 @@ W:	http://wireless.kernel.org/
 S:	Orphan
 F:	drivers/net/wireless/adm8211.*
 
+ADP1653 FLASH CONTROLLER DRIVER
+M:	Sakari Ailus <sakari.ailus@iki.fi>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/i2c/adp1653.c
+F:	include/media/adp1653.h
+
 ADP5520 BACKLIGHT DRIVER WITH IO EXPANDER (ADP5520/ADP5501)
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-drivers-devel@blackfin.uclinux.org
@@ -6685,6 +6692,15 @@ M:	Nicolas Pitre <nico@fluxnic.net>
 S:	Odd Fixes
 F:	drivers/net/ethernet/smsc/smc91x.*
 
+SMIA AND SMIA++ IMAGE SENSOR DRIVER
+M:	Sakari Ailus <sakari.ailus@iki.fi>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/i2c/smiapp
+F:	include/media/smiapp.h
+F:	drivers/media/i2c/smiapp-pll.c
+F:	drivers/media/i2c/smiapp-pll.h
+
 SMM665 HARDWARE MONITOR DRIVER
 M:	Guenter Roeck <linux@roeck-us.net>
 L:	lm-sensors@lm-sensors.org
-- 
1.7.2.5

