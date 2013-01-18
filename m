Return-path: <linux-media-owner@vger.kernel.org>
Received: from [216.32.180.13] ([216.32.180.13]:24333 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750750Ab3ARIMy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jan 2013 03:12:54 -0500
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	<uclinux-dist-devel@blackfin.uclinux.org>
CC: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH 1/2] [media] add maintainer for blackfin media drivers
Date: Fri, 18 Jan 2013 16:09:47 -0500
Message-ID: <1358543388-29451-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 MAINTAINERS |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c5de529..e7ca531 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1652,6 +1652,15 @@ W:	http://blackfin.uclinux.org/
 S:	Supported
 F:	drivers/i2c/busses/i2c-bfin-twi.c
 
+BLACKFIN MEDIA DRIVER
+M:	Scott Jiang <scott.jiang.linux@gmail.com>
+L:	uclinux-dist-devel@blackfin.uclinux.org
+W:	http://blackfin.uclinux.org/
+S:	Supported
+F:	drivers/media/platform/blackfin/
+F:	drivers/media/i2c/adv7183*
+F:	drivers/media/i2c/vs6624*
+
 BLINKM RGB LED DRIVER
 M:	Jan-Simon Moeller <jansimon.moeller@gmx.de>
 S:	Maintained
-- 
1.7.0.4


