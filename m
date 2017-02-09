Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:57722 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752628AbdBIPQp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2017 10:16:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Michael Tretter <m.tretter@pengutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] coda/imx-vdoa: platform_driver should not be const
Date: Thu,  9 Feb 2017 16:09:08 +0100
Message-Id: <20170209150940.1167088-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device driver platform is actually written to during registration,
for setting the owner field, so platform_driver_register() does not
take a const pointer:

drivers/media/platform/coda/imx-vdoa.c: In function 'vdoa_driver_init':
drivers/media/platform/coda/imx-vdoa.c:333:213: error: passing argument 1 of '__platform_driver_register' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
 module_platform_driver(vdoa_driver);
In file included from drivers/media/platform/coda/imx-vdoa.c:22:0:
include/linux/platform_device.h:199:12: note: expected 'struct platform_driver *' but argument is of type 'const struct platform_driver *'
 extern int __platform_driver_register(struct platform_driver *,
            ^~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/media/platform/coda/imx-vdoa.c: In function 'vdoa_driver_exit':
drivers/media/platform/coda/imx-vdoa.c:333:626: error: passing argument 1 of 'platform_driver_unregister' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]

Remove the modifier again.

Fixes: d2fe28feaebb ("[media] coda/imx-vdoa: constify structs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/coda/imx-vdoa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/imx-vdoa.c b/drivers/media/platform/coda/imx-vdoa.c
index 67fd8ffa60a4..669a4c82f1ff 100644
--- a/drivers/media/platform/coda/imx-vdoa.c
+++ b/drivers/media/platform/coda/imx-vdoa.c
@@ -321,7 +321,7 @@ static const struct of_device_id vdoa_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, vdoa_dt_ids);
 
-static const struct platform_driver vdoa_driver = {
+static struct platform_driver vdoa_driver = {
 	.probe		= vdoa_probe,
 	.remove		= vdoa_remove,
 	.driver		= {
-- 
2.9.0

