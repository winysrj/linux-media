Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:36238 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab2K1VQs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 16:16:48 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so8113052lag.19
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2012 13:16:47 -0800 (PST)
Message-ID: <1354137392.27302.4.camel@linux>
Subject: [patch] MAINTAINERS: add entry for dsbr100 usb radio driver
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, klimov.linux@gmail.com
Date: Wed, 28 Nov 2012 22:16:32 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds MAINTAINERS entry for dsbr100 usb radio driver.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>


diff --git a/MAINTAINERS b/MAINTAINERS
index a36b29c..38da55f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2528,6 +2528,13 @@ S:	Supported
 F:	drivers/gpu/drm/exynos
 F:	include/drm/exynos*
 
+DSBR100 USB FM RADIO DRIVER
+M:	Alexey Klimov <klimov.linux@gmail.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/radio/dsbr100.c
+
 DSCC4 DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org



