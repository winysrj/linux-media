Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53092 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754042AbaLIAEt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 19:04:49 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, mark.rutland@arm.com
Subject: [REVIEW PATCH v3 02/12] smiapp: List include/uapi/linux/smiapp.h in MAINTAINERS
Date: Tue,  9 Dec 2014 02:04:10 +0200
Message-Id: <1418083460-28556-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1418083460-28556-1-git-send-email-sakari.ailus@iki.fi>
References: <1418083460-28556-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is part of the smiapp driver.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9c49eb6..f2d9159 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8624,6 +8624,7 @@ F:	drivers/media/i2c/smiapp/
 F:	include/media/smiapp.h
 F:	drivers/media/i2c/smiapp-pll.c
 F:	drivers/media/i2c/smiapp-pll.h
+F:	include/uapi/linux/smiapp.h
 
 SMM665 HARDWARE MONITOR DRIVER
 M:	Guenter Roeck <linux@roeck-us.net>
-- 
1.7.10.4

