Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42266 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752339AbdFUIIi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 04:08:38 -0400
From: Johannes Thumshirn <jthumshirn@suse.de>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH RESEND 6/7] [media] media: bcm2048: use MEDIA_REVISION isntead of KERNEL_VERSION
Date: Wed, 21 Jun 2017 10:08:11 +0200
Message-Id: <20170621080812.6817-7-jthumshirn@suse.de>
In-Reply-To: <20170621080812.6817-1-jthumshirn@suse.de>
References: <20170621080812.6817-1-jthumshirn@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use MEDIA_REVISION isntead of KERNEL_VERSION to encode the bcm2048
driver version.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 38f72d069e27..ffe9b63cbf59 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -48,7 +48,7 @@
 /* driver definitions */
 #define BCM2048_DRIVER_AUTHOR	"Eero Nurkkala <ext-eero.nurkkala@nokia.com>"
 #define BCM2048_DRIVER_NAME	BCM2048_NAME
-#define BCM2048_DRIVER_VERSION	KERNEL_VERSION(0, 0, 1)
+#define BCM2048_DRIVER_VERSION	MEDIA_REVISION(0, 0, 1)
 #define BCM2048_DRIVER_CARD	"Broadcom bcm2048 FM Radio Receiver"
 #define BCM2048_DRIVER_DESC	"I2C driver for BCM2048 FM Radio Receiver"
 
-- 
2.12.3
