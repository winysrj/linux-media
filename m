Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:64994 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753561AbdGNJ3l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:29:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        Arnd Bergmann <arnd@arndb.de>, linux-input@vger.kernel.org
Subject: [PATCH 08/14] Input: adxl34x - fix gcc-7 -Wint-in-bool-context warning
Date: Fri, 14 Jul 2017 11:25:20 +0200
Message-Id: <20170714092540.1217397-9-arnd@arndb.de>
In-Reply-To: <20170714092540.1217397-1-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FIFO_MODE is an macro expression with a '<<' operator, which
gcc points out could be misread as a '<':

drivers/input/misc/adxl34x.c: In function 'adxl34x_probe':
drivers/input/misc/adxl34x.c:799:36: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]

This converts the test to an explicit comparison with zero,
making it clearer to gcc and the reader what is intended.

Fixes: e27c729219ad ("Input: add driver for ADXL345/346 Digital Accelerometers")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/input/misc/adxl34x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/adxl34x.c b/drivers/input/misc/adxl34x.c
index 2b2d02f408bb..e0caaa0de454 100644
--- a/drivers/input/misc/adxl34x.c
+++ b/drivers/input/misc/adxl34x.c
@@ -796,7 +796,7 @@ struct adxl34x *adxl34x_probe(struct device *dev, int irq,
 
 	if (pdata->watermark) {
 		ac->int_mask |= WATERMARK;
-		if (!FIFO_MODE(pdata->fifo_mode))
+		if (FIFO_MODE(pdata->fifo_mode) == 0)
 			ac->pdata.fifo_mode |= FIFO_STREAM;
 	} else {
 		ac->int_mask |= DATA_READY;
-- 
2.9.0
