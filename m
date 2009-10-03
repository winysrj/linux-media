Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:55194 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbZJCWJu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 18:09:50 -0400
Received: by ewy7 with SMTP id 7so2387276ewy.17
        for <linux-media@vger.kernel.org>; Sat, 03 Oct 2009 15:09:12 -0700 (PDT)
Subject: [PATCH] MAINTAINERS: addition of gspca_gl860 driver
From: Olivier Lorin <olorin75@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sun, 04 Oct 2009 00:09:10 +0200
Message-Id: <1254607750.24873.49.camel@miniol>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MAINTAINERS: addition of gspca_gl860 driver

From: Olivier Lorin <o.lorin@laposte.net>

- addition of gspca_gl860 driver

Priority: normal

Signed-off-by: Olivier Lorin <o.lorin@laposte.net>

--- ../a/MAINTAINERS	2009-09-20 02:07:33.000000000 +0200
+++ MAINTAINERS	2009-09-20 02:09:56.000000000 +0200
@@ -2224,6 +2224,13 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	drivers/media/video/gspca/finepix.c
 
+GSPCA GL860 SUBDRIVER
+M:	Olivier Lorin <o.lorin@laposte.net>
+L:	linux-media@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+S:	Maintained
+F:	drivers/media/video/gspca/gl860/
+
 GSPCA M5602 SUBDRIVER
 M:	Erik Andren <erik.andren@gmail.com>
 L:	linux-media@vger.kernel.org

