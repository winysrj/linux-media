Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:53045 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbeHUMUZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 08:20:25 -0400
Received: by mail-wm0-f67.google.com with SMTP id o11-v6so2154185wmh.2
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 02:01:06 -0700 (PDT)
To: linux-media@vger.kernel.org
Cc: crope@iki.fi, jozef.balga@gmail.com
From: Jozef Balga <jozef.balga@gmail.com>
Subject: [PATCH] media: af9035: prevent buffer overflow on write
Message-ID: <68a24875-8b1a-264f-afa9-ea378580696e@gmail.com>
Date: Tue, 21 Aug 2018 11:01:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media: af9035: prevents buffer overflow when less than 3 bytes are written to the device

When less than 3 bytes are written to the device, memcpy is called with
negative array size which leads to buffer overflow and kernel panic. This
patch adds a condition and returns -EOPNOTSUPP instead.
Fixes bugzilla issue 64871

Signed-off-by: Jozef Balga <jozef.balga@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 666d319d3d1a..e509713db623 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -402,8 +402,9 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
                        if (msg[0].addr == state->af9033_i2c_addr[1])
                                reg |= 0x100000;
 
-                       ret = af9035_wr_regs(d, reg, &msg[0].buf[3],
-                                       msg[0].len - 3);
+                       ret = (msg[0].len > 3) ? af9035_wr_regs(d, reg,
+                                       &msg[0].buf[3], msg[0].len - 3)
+                                       : -EOPNOTSUPP;
                } else {
                        /* I2C write */
                        u8 buf[MAX_XFER_SIZE];
-- 
2.14.4
