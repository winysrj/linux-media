Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:52929 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3CZIpM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 04:45:12 -0400
Received: by mail-bk0-f52.google.com with SMTP id it16so797131bkc.25
        for <linux-media@vger.kernel.org>; Tue, 26 Mar 2013 01:45:11 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 Mar 2013 16:45:11 +0800
Message-ID: <CAPgLHd8xRn-7ExMXY9KA8GKvh3DmZ6jN0WBZ8BGb1WmGW2ghBA@mail.gmail.com>
Subject: [PATCH -next v2] [media] go7007: fix invalid use of sizeof in go7007_usb_i2c_master_xfer()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: hans.verkuil@cisco.com, mchehab@redhat.com,
	gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

sizeof() when applied to a pointer typed expression gives the
size of the pointer, not that of the pointed data.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/media/go7007/go7007-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 0823506..d455c0b 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1035,7 +1035,7 @@ static int go7007_usb_i2c_master_xfer(struct i2c_adapter *adapter,
 						buf, buf_len, 0) < 0)
 			goto i2c_done;
 		if (msgs[i].flags & I2C_M_RD) {
-			memset(buf, 0, sizeof(buf));
+			memset(buf, 0, msgs[i].len + 1);
 			if (go7007_usb_vendor_request(go, 0x25, 0, 0, buf,
 						msgs[i].len + 1, 1) < 0)
 				goto i2c_done;


