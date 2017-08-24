Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:62159 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753428AbdHXWWs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 18:22:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] au0828: fix RC_CORE dependency
Date: Fri, 25 Aug 2017 00:22:28 +0200
Message-Id: <20170824222242.788086-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When RC_CORE is a loadable module, and au0828 is built-in including
the RC support, we get a link error:

drivers/media/usb/au0828/au0828-input.o: In function `au0828_get_key_au8522':
au0828-input.c:(.text+0x474): undefined reference to `ir_raw_event_store'
drivers/media/usb/au0828/au0828-input.o: In function `au0828_rc_register':
au0828-input.c:(.text+0x7c8): undefined reference to `rc_allocate_device'
au0828-input.c:(.text+0x8f8): undefined reference to `rc_register_device'

This adds an additional dependency, similar to the one for em28xx,
to ensure the broken configuration is never used.

Fixes: 2fcfd317f66c ("[media] au0828: add support for IR on HVR-950Q")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/au0828/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/au0828/Kconfig b/drivers/media/usb/au0828/Kconfig
index 78b797e0b434..70521e0b4c53 100644
--- a/drivers/media/usb/au0828/Kconfig
+++ b/drivers/media/usb/au0828/Kconfig
@@ -31,6 +31,7 @@ config VIDEO_AU0828_V4L2
 config VIDEO_AU0828_RC
 	bool "AU0828 Remote Controller support"
 	depends on RC_CORE
+	depends on !(RC_CORE=m && VIDEO_AU0828=y)
 	depends on VIDEO_AU0828
 	---help---
 	   Enables Remote Controller support on au0828 driver.
-- 
2.9.0
