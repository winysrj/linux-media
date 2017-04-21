Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:49921 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1038048AbdDUKwW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 06:52:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] cec: improve MEDIA_CEC_RC dependencies
Date: Fri, 21 Apr 2017 12:52:17 +0200
Message-Id: <20170421105224.899350-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changing the IS_REACHABLE() into a plain #ifdef broke the case of
CONFIG_MEDIA_RC=m && CONFIG_MEDIA_CEC=y:

drivers/media/cec/cec-core.o: In function `cec_unregister_adapter':
cec-core.c:(.text.cec_unregister_adapter+0x18): undefined reference to `rc_unregister_device'
drivers/media/cec/cec-core.o: In function `cec_delete_adapter':
cec-core.c:(.text.cec_delete_adapter+0x54): undefined reference to `rc_free_device'
drivers/media/cec/cec-core.o: In function `cec_register_adapter':
cec-core.c:(.text.cec_register_adapter+0x94): undefined reference to `rc_register_device'
cec-core.c:(.text.cec_register_adapter+0xa4): undefined reference to `rc_free_device'
cec-core.c:(.text.cec_register_adapter+0x110): undefined reference to `rc_unregister_device'
drivers/media/cec/cec-core.o: In function `cec_allocate_adapter':
cec-core.c:(.text.cec_allocate_adapter+0x234): undefined reference to `rc_allocate_device'
drivers/media/cec/cec-adap.o: In function `cec_received_msg':
cec-adap.c:(.text.cec_received_msg+0x734): undefined reference to `rc_keydown'
cec-adap.c:(.text.cec_received_msg+0x768): undefined reference to `rc_keyup'

This adds an additional dependency to explicitly forbid this combination.

Fixes: 5f2c467c54f5 ("[media] cec: add MEDIA_CEC_RC config option")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/cec/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/cec/Kconfig b/drivers/media/cec/Kconfig
index f944d93e3167..488fb908244d 100644
--- a/drivers/media/cec/Kconfig
+++ b/drivers/media/cec/Kconfig
@@ -9,6 +9,7 @@ config MEDIA_CEC_NOTIFIER
 config MEDIA_CEC_RC
 	bool "HDMI CEC RC integration"
 	depends on CEC_CORE && RC_CORE
+	depends on CEC_CORE=m || RC_CORE=y
 	---help---
 	  Pass on CEC remote control messages to the RC framework.
 
-- 
2.9.0
