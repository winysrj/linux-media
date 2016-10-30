Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36668 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753591AbcJ3Bgr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Oct 2016 21:36:47 -0400
Received: by mail-pf0-f196.google.com with SMTP id n85so5027614pfi.3
        for <linux-media@vger.kernel.org>; Sat, 29 Oct 2016 18:36:46 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-media@vger.kernel.org
Subject: [PATCH -next] [media] dibusb: fix possible memory leak in dibusb_rc_query()
Date: Sun, 30 Oct 2016 01:36:24 +0000
Message-Id: <1477791384-13845-1-git-send-email-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

'buf' is malloced in dibusb_rc_query() and should be freed before
leaving from the error handling cases, otherwise it will cause
memory leak.

Fixes: ff1c123545d7 ("[media] dibusb: handle error code on RC query")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/usb/dvb-usb/dibusb-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
index de3ee25..8207e69 100644
--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -382,9 +382,9 @@ int dibusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	if (buf[0] != 0)
 		deb_info("key: %*ph\n", 5, buf);
 
+ret:
 	kfree(buf);
 
-ret:
 	return ret;
 }
 EXPORT_SYMBOL(dibusb_rc_query);

