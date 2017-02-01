Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:54569 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdBAQQQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 11:16:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lee Jones <lee@kernel.org>, Eric Anholt <eric@anholt.net>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: bcm2835-v4l: remove incorrect include path
Date: Wed,  1 Feb 2017 17:15:06 +0100
Message-Id: <20170201161523.2093812-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver introduces a new instance of the missing-include-dirs warning that
is enabled at the "make W=1" level but has no other output:

cc1: error: drivers/staging/vc04_services/interface/vcos/linuxkernel: No such file or directory [-Werror=missing-include-dirs]
cc1: all warnings being treated as errors
scripts/Makefile.build:307: recipe for target 'drivers/staging/media/platform/bcm2835/bcm2835-camera.o' failed

In order to let us enable the warning by default in the future, we should
just remove the incorrect argument here.

Fixes: 97b35807cc4d ("staging: bcm2835-v4l2: Add a build system for the module.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/platform/bcm2835/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/platform/bcm2835/Makefile b/drivers/staging/media/platform/bcm2835/Makefile
index d7900a5951a8..8307f30517d5 100644
--- a/drivers/staging/media/platform/bcm2835/Makefile
+++ b/drivers/staging/media/platform/bcm2835/Makefile
@@ -7,5 +7,4 @@ obj-$(CONFIG_VIDEO_BCM2835) += bcm2835-v4l2.o
 
 ccflags-y += \
 	-Idrivers/staging/vc04_services \
-	-Idrivers/staging/vc04_services/interface/vcos/linuxkernel \
 	-D__VCCOREVER__=0x04000000
-- 
2.9.0

