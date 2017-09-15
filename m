Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:53854 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbdIOTwf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 15:52:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Anton Sviridenko <anton@corp.bluecherry.net>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] solo6x10: hide unused variable
Date: Fri, 15 Sep 2017 21:52:04 +0200
Message-Id: <20170915195225.1394284-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When building without CONFIG_GPIOLIB, we get a harmless
warning about an unused variable:

drivers/media/pci/solo6x10/solo6x10-gpio.c: In function 'solo_gpio_init':
drivers/media/pci/solo6x10/solo6x10-gpio.c:165:6: error: unused variable 'ret' [-Werror=unused-variable]

This adds another #ifdef around the declaration.

Fixes: d3202d1981dc ("media: solo6x10: export hardware GPIO pins 8:31 to gpiolib interface")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/solo6x10/solo6x10-gpio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/solo6x10/solo6x10-gpio.c b/drivers/media/pci/solo6x10/solo6x10-gpio.c
index 3d0d1aa2f6a8..7b4641a2cb84 100644
--- a/drivers/media/pci/solo6x10/solo6x10-gpio.c
+++ b/drivers/media/pci/solo6x10/solo6x10-gpio.c
@@ -162,7 +162,9 @@ static void solo_gpiochip_set(struct gpio_chip *chip,
 
 int solo_gpio_init(struct solo_dev *solo_dev)
 {
+#ifdef CONFIG_GPIOLIB
 	int ret;
+#endif
 
 	solo_gpio_config(solo_dev);
 #ifdef CONFIG_GPIOLIB
-- 
2.9.0
