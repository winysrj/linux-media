Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59321 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2KOWGb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 17:06:31 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so821214eaa.19
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2012 14:06:29 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: dron0gus@gmail.com, tomasz.figa@gmail.com,
	oselas@community.pengutronix.de,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH RFC v3 3/3] MAINTAINERS: Add entry for S3C24XX/S3C64XX SoC CAMIF driver
Date: Thu, 15 Nov 2012 23:05:15 +0100
Message-Id: <1353017115-11492-4-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1353017115-11492-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1353017115-11492-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f4b3aa8..c6de2ed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6326,6 +6326,14 @@ F:	drivers/regulator/s5m*.c
 F:	drivers/rtc/rtc-sec.c
 F:	include/linux/mfd/samsung/
 
+SAMSUNG S3C24XX/S3C64XX SOC SERIES CAMIF DRIVER
+M:	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
+L:	linux-media@vger.kernel.org
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
+S:	Maintained
+F:	drivers/media/platform/s3c-camif/
+F:	include/media/s3c_camif.h
+
 SERIAL DRIVERS
 M:	Alan Cox <alan@linux.intel.com>
 L:	linux-serial@vger.kernel.org
-- 
1.7.4.1

