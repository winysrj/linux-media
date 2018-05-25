Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:37871 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965710AbeEYP0Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 11:26:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Brad Love <brad@nextdimension.cc>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Oleh Kravchenko <oleg@kaa.org.ua>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] media: cx231xx: fix RC_CORE dependency
Date: Fri, 25 May 2018 17:25:10 +0200
Message-Id: <20180525152523.2821369-3-arnd@arndb.de>
In-Reply-To: <20180525152523.2821369-1-arnd@arndb.de>
References: <20180525152523.2821369-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With CONFIG_RC_CORE=m and VIDEO_CX231XX=y, we get a link failure:

drivers/media/usb/cx231xx/cx231xx-input.o: In function `cx231xx_ir_init':
cx231xx-input.c:(.text+0xd4): undefined reference to `rc_allocate_device'

This narrows down the dependency so that only valid configurations
are allowed.

Fixes: 84545d2a1436 ("media: cx231xx: Remove RC_CORE dependency")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/cx231xx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 0f13192634c7..9e5b3e7c3ef5 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -15,7 +15,7 @@ config VIDEO_CX231XX
 
 config VIDEO_CX231XX_RC
 	bool "Conexant cx231xx Remote Controller additional support"
-	depends on RC_CORE
+	depends on RC_CORE=y || RC_CORE=VIDEO_CX231XX
 	depends on VIDEO_CX231XX
 	default y
 	---help---
-- 
2.9.0
