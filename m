Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46535 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751798AbaKRFoC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 00:44:02 -0500
Received: from lanttu.localdomain (unknown [192.168.15.166])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 7225560097
	for <linux-media@vger.kernel.org>; Tue, 18 Nov 2014 07:43:59 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH v2 02/11] smiapp: List include/uapi/linux/smiapp.h in MAINTAINERS
Date: Tue, 18 Nov 2014 07:43:37 +0200
Message-Id: <1416289426-804-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1416289426-804-1-git-send-email-sakari.ailus@iki.fi>
References: <1416289426-804-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is part of the smiapp driver.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a6288ca..2378a5f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8618,6 +8618,7 @@ F:	drivers/media/i2c/smiapp/
 F:	include/media/smiapp.h
 F:	drivers/media/i2c/smiapp-pll.c
 F:	drivers/media/i2c/smiapp-pll.h
+F:	include/uapi/linux/smiapp.h
 
 SMM665 HARDWARE MONITOR DRIVER
 M:	Guenter Roeck <linux@roeck-us.net>
-- 
1.7.10.4

