Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:36517 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3LLGt4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 01:49:56 -0500
Received: by mail-bk0-f50.google.com with SMTP id e11so709174bkh.37
        for <linux-media@vger.kernel.org>; Wed, 11 Dec 2013 22:49:54 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 12 Dec 2013 14:49:54 +0800
Message-ID: <CAPgLHd9pONVzbkdSkh-iZag+NEqHu6JPRgPtayUUGz85=TAdHw@mail.gmail.com>
Subject: [PATCH -next] [media] radio-bcm2048: fix missing unlock on error in bcm2048_rds_fifo_receive()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: m.chehab@samsung.com, gregkh@linuxfoundation.org,
	ext-eero.nurkkala@nokia.com, pali.rohar@gmail.com,
	hans.verkuil@cisco.com, joni.lapilainen@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function bcm2048_rds_fifo_receive()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 494ec39..37ff899 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -1767,6 +1767,7 @@ static void bcm2048_rds_fifo_receive(struct bcm2048_device *bdev)
 				bdev->rds_info.radio_text, bdev->fifo_size);
 	if (err != 2) {
 		dev_err(&bdev->client->dev, "RDS Read problem\n");
+		mutex_unlock(&bdev->mutex);
 		return;
 	}
 

