Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:12611 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729942AbeIRVK6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 17:10:58 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <mchehab@kernel.org>
CC: <crope@iki.fi>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] media: usb: Use kmemdup instead of duplicating its function.
Date: Tue, 18 Sep 2018 23:25:25 +0800
Message-ID: <1537284325-61744-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmemdup has implemented the function that kmalloc() + memcpy().
We prefer to kmemdup rather than code opened implementation.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/media/usb/dvb-usb-v2/gl861.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/gl861.c b/drivers/media/usb/dvb-usb-v2/gl861.c
index 0559417..80fed44 100644
--- a/drivers/media/usb/dvb-usb-v2/gl861.c
+++ b/drivers/media/usb/dvb-usb-v2/gl861.c
@@ -200,11 +200,10 @@ struct friio_config {
 	u8 *buf;
 	int ret;
 
-	buf = kmalloc(wlen, GFP_KERNEL);
+	buf = kmemdup(wbuf, wlen, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	memcpy(buf, wbuf, wlen);
 	ret = usb_control_msg(d->udev, usb_sndctrlpipe(d->udev, 0),
 				 GL861_REQ_I2C_RAW, GL861_WRITE,
 				 addr << (8 + 1), 0x0100, buf, wlen, 2000);
-- 
1.7.12.4
