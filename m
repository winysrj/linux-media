Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:37361 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752020AbdHSKe6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 06:34:58 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, wsa@the-dreams.de, jacmet@sunsite.dk,
        jglauber@cavium.com, david.daney@cavium.com,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        awalls@md.metrocast.net, serjk@netup.ru, aospan@netup.ru,
        isely@pobox.com, ezequiel@vanguardiasur.com.ar,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 3/4] [media] radio-usb-si4713: make i2c_adapter const
Date: Sat, 19 Aug 2017 16:04:14 +0530
Message-Id: <1503138855-585-4-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503138855-585-1-git-send-email-bhumirks@gmail.com>
References: <1503138855-585-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.
Done using Coccinelle

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/radio/si4713/radio-usb-si4713.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
index e5e5a16..f20aac2 100644
--- a/drivers/media/radio/si4713/radio-usb-si4713.c
+++ b/drivers/media/radio/si4713/radio-usb-si4713.c
@@ -409,7 +409,7 @@ static u32 si4713_functionality(struct i2c_adapter *adapter)
 
 /* This name value shows up in the sysfs filename associated
 		with this I2C adapter */
-static struct i2c_adapter si4713_i2c_adapter_template = {
+static const struct i2c_adapter si4713_i2c_adapter_template = {
 	.name   = "si4713-i2c",
 	.owner  = THIS_MODULE,
 	.algo   = &si4713_algo,
-- 
1.9.1
