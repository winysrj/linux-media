Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:62625 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3CZGmt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 02:42:49 -0400
Received: by mail-bk0-f44.google.com with SMTP id jk13so436972bkc.17
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 23:42:48 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 Mar 2013 14:42:47 +0800
Message-ID: <CAPgLHd-+DNxxVHsXiJpk2KFk8mzrQUkwaYPUFeWHyAmz-H6=4Q@mail.gmail.com>
Subject: [PATCH -next] [media] go7007: fix invalid use of sizeof in go7007_usb_i2c_master_xfer()
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
index 0823506..7219ae0 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1035,7 +1035,7 @@ static int go7007_usb_i2c_master_xfer(struct i2c_adapter *adapter,
 						buf, buf_len, 0) < 0)
 			goto i2c_done;
 		if (msgs[i].flags & I2C_M_RD) {
-			memset(buf, 0, sizeof(buf));
+			memset(buf, 0, sizeof(*buf));
 			if (go7007_usb_vendor_request(go, 0x25, 0, 0, buf,
 						msgs[i].len + 1, 1) < 0)
 				goto i2c_done;


