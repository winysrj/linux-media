Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.119]:17013 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752683AbdGIWE3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Jul 2017 18:04:29 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 7CF292E36C
        for <linux-media@vger.kernel.org>; Sun,  9 Jul 2017 17:04:26 -0500 (CDT)
Date: Sun, 9 Jul 2017 17:04:24 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] usbvision: constify i2c_algorithm structure
Message-ID: <20170709220424.GA3769@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check for i2c_algorithm structures that are only stored in
the algo field of an i2c_adapter structure. This field is
declared const, so i2c_algorithm structures that have this
property can be declared as const also.

This issue was identified using Coccinelle and the following
semantic patch:

@r disable optional_qualifier@
identifier i;
position p;
@@
static struct i2c_algorithm i@p = { ... };

@ok@
identifier r.i;
struct i2c_adapter e;
position p;
@@
e.algo = &i@p;

@bad@
position p != {r.p,ok.p};
identifier r.i;
@@
i@p

@depends on !bad disable optional_qualifier@
identifier r.i;
@@
static
+const
 struct i2c_algorithm i = { ... };

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/usb/usbvision/usbvision-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbvision/usbvision-i2c.c b/drivers/media/usb/usbvision/usbvision-i2c.c
index fdf6b6e..f86a0e0 100644
--- a/drivers/media/usb/usbvision/usbvision-i2c.c
+++ b/drivers/media/usb/usbvision/usbvision-i2c.c
@@ -163,7 +163,7 @@ static u32 functionality(struct i2c_adapter *adap)
 
 /* -----exported algorithm data: -------------------------------------	*/
 
-static struct i2c_algorithm usbvision_algo = {
+static const struct i2c_algorithm usbvision_algo = {
 	.master_xfer   = usbvision_i2c_xfer,
 	.smbus_xfer    = NULL,
 	.functionality = functionality,
-- 
2.5.0
