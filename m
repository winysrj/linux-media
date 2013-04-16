Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965496Ab3DPXEK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 19:04:10 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3GN4AVk001851
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 19:04:10 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] sta2x11_vip: Fix compilation if I2C is not set
Date: Tue, 16 Apr 2013 20:04:02 -0300
Message-Id: <1366153442-10794-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From Fengguang Wu <fengguang.wu@intel.com>:

> drivers/media/pci/sta2x11/sta2x11_vip.c: In function 'sta2x11_vip_init_one':
> drivers/media/pci/sta2x11/sta2x11_vip.c:1314:2: error: implicit declaration of function 'i2c_get_adapter' [-Werror=implicit-function-declaration]
> drivers/media/pci/sta2x11/sta2x11_vip.c:1314:15: warning: assignment makes pointer from integer without a cast [enabled by default]
> drivers/media/pci/sta2x11/sta2x11_vip.c:1330:2: error: implicit declaration of function 'i2c_put_adapter' [-Werror=implicit-function-declaration]

And also:

> warning: (STA2X11_VIP) selects VIDEO_ADV7180 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_V4L2 && I2C)
> drivers/media/i2c/adv7180.c: In function '__adv7180_status':
> drivers/media/i2c/adv7180.c:194:2: error: implicit declaration of function 'i2c_smbus_read_byte_data' [-Werror=implicit-function-declaration]
> drivers/media/i2c/adv7180.c: In function 'adv7180_s_routing':
> drivers/media/i2c/adv7180.c:251:2: error: implicit declaration of function 'i2c_smbus_write_byte_data' [-Werror=implicit-function-declaration]
> drivers/media/i2c/adv7180.c: In function 'adv7180_probe':
> drivers/media/i2c/adv7180.c:551:2: error: implicit declaration of function 'i2c_check_functionality' [-Werror=implicit-function-declaration]
> drivers/media/i2c/adv7180.c:554:2: error: implicit declaration of function 'i2c_adapter_id' [-Werror=implicit-function-declaration]
> drivers/media/i2c/adv7180.c: At top level:
> drivers/media/i2c/adv7180.c:663:1: warning: data definition has no type or storage class [enabled by default]
> drivers/media/i2c/adv7180.c:663:1: warning: type defaults to 'int' in declaration of 'module_i2c_driver' [-Wimplicit-int]
> drivers/media/i2c/adv7180.c:663:1: warning: parameter names (without types) in function declaration [enabled by default]
> drivers/media/i2c/adv7180.c:649:26: warning: 'adv7180_driver' defined but not used [-Wunused-variable]

This is due to the lack of I2C support:

...
> CONFIG_I2C is not set
...

So, Make sure that sta2x11_vip depends on I2C.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/sta2x11/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
index a94ccad..0313015 100644
--- a/drivers/media/pci/sta2x11/Kconfig
+++ b/drivers/media/pci/sta2x11/Kconfig
@@ -4,6 +4,7 @@ config STA2X11_VIP
 	select VIDEO_ADV7180 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEOBUF2_DMA_CONTIG
 	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
+	depends on I2C
 	help
 	  Say Y for support for STA2X11 VIP (Video Input Port) capture
 	  device.
-- 
1.8.1.4

