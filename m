Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:59374 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754932AbcILIo3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 04:44:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Fjeldtvedt <jaffe1@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] pulse8-cec: avoid uninitialized data use
Date: Mon, 12 Sep 2016 10:43:49 +0200
Message-Id: <20160912084403.3577996-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Building with -Wmaybe-uninitialized reveals the use on an uninitialized
variable containing the physical address of the device whenever
firmware before version 2 is used:

drivers/staging/media/pulse8-cec/pulse8-cec.c: In function 'pulse8_connect':
drivers/staging/media/pulse8-cec/pulse8-cec.c:447:2: error: 'pa' may be used uninitialized in this function [-Werror=maybe-uninitialized]

This sets the address to CEC_PHYS_ADDR_INVALID in this case, so we don't
try to write back the uninitialized data to the device.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: e28a6c8b3fcc ("[media] pulse8-cec: sync configuration with adapter")
---
 drivers/staging/media/pulse8-cec/pulse8-cec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/pulse8-cec/pulse8-cec.c b/drivers/staging/media/pulse8-cec/pulse8-cec.c
index 1158ba9f828f..64fffc709416 100644
--- a/drivers/staging/media/pulse8-cec/pulse8-cec.c
+++ b/drivers/staging/media/pulse8-cec/pulse8-cec.c
@@ -342,8 +342,10 @@ static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio,
 		return err;
 	pulse8->vers = (data[0] << 8) | data[1];
 	dev_info(pulse8->dev, "Firmware version %04x\n", pulse8->vers);
-	if (pulse8->vers < 2)
+	if (pulse8->vers < 2) {
+		*pa = CEC_PHYS_ADDR_INVALID;
 		return 0;
+	}
 
 	cmd[0] = MSGCODE_GET_BUILDDATE;
 	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 4);
-- 
2.9.0

