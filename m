Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:53532 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaI2O3B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 10:29:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, Akihiro Tsukada <tskd08@gmail.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] [media] pt3: remove bogus module_is_live() check
Date: Mon, 29 Sep 2014 16:28:55 +0200
Message-ID: <6460819.BmnhuA22YH@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new pt3 driver checks the module reference for presence
before dropping it, which fails to compile when modules
are disabled:

media/pci/pt3/pt3.c: In function 'pt3_attach_fe':
media/pci/pt3/pt3.c:433:6: error: implicit declaration of function 'module_is_live' [-Werror=implicit-function-declaration]
      module_is_live(pt3->adaps[i]->i2c_tuner->dev.driver->owner))

As far as I can tell however, this check is not needed at all, because
the module will not go away as long as pt3 is holding a reference on
it. Also the previous check for NULL pointer is not needed at all,
because module_put has the same check.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index 90f86ce7a001..39305f07dc2e 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -429,14 +429,10 @@ static int pt3_attach_fe(struct pt3_board *pt3, int i)
 
 err_tuner:
 	i2c_unregister_device(pt3->adaps[i]->i2c_tuner);
-	if (pt3->adaps[i]->i2c_tuner->dev.driver->owner &&
-	    module_is_live(pt3->adaps[i]->i2c_tuner->dev.driver->owner))
-		module_put(pt3->adaps[i]->i2c_tuner->dev.driver->owner);
+	module_put(pt3->adaps[i]->i2c_tuner->dev.driver->owner);
 err_demod:
 	i2c_unregister_device(pt3->adaps[i]->i2c_demod);
-	if (pt3->adaps[i]->i2c_demod->dev.driver->owner &&
-	    module_is_live(pt3->adaps[i]->i2c_demod->dev.driver->owner))
-		module_put(pt3->adaps[i]->i2c_demod->dev.driver->owner);
+	module_put(pt3->adaps[i]->i2c_demod->dev.driver->owner);
 	return ret;
 }
 

