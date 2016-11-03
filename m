Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:44897 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752466AbcKCJiG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Nov 2016 05:38:06 -0400
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] dvb-usb: remove another redundant #include <linux/kconfig.h>
Date: Thu,  3 Nov 2016 10:38:01 +0100
Message-Id: <1478165881-9263-1-git-send-email-pebolle@tiscali.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kernel source files need not include <linux/kconfig.h> explicitly
because the top Makefile forces to include it with:

  -include $(srctree)/include/linux/kconfig.h

Remove another reduntdant include, that managed to sneak by commit
97139d4a6f26 ("treewide: remove redundant #include <linux/kconfig.h>").

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/media/usb/dvb-usb/dibusb-mc-common.c | 1 -
 1 file changed, 1 deletion(-)

Masahiro: another #include was added to include/asm-generic/export.h. I
think it's bogus too, but testing it required setting
CONFIG_TRIM_UNUSED_KSYMS. And doing that triggered over 100K (!) undefined
symbol errors in my test build.

So naturally I decided to behave as if I never saw that #include enter
export.h. Perhaps you are braver than I am.

diff --git a/drivers/media/usb/dvb-usb/dibusb-mc-common.c b/drivers/media/usb/dvb-usb/dibusb-mc-common.c
index d66f56cc46a5..c989cac9343d 100644
--- a/drivers/media/usb/dvb-usb/dibusb-mc-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-mc-common.c
@@ -9,7 +9,6 @@
  * see Documentation/dvb/README.dvb-usb for more information
  */
 
-#include <linux/kconfig.h>
 #include "dibusb.h"
 
 /* 3000MC/P stuff */
-- 
2.7.4

