Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44348 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdIAPfM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 11:35:12 -0400
From: Colin King <colin.king@canonical.com>
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] rtl28xxu: make array rc_nec_tab static const
Date: Fri,  1 Sep 2017 16:35:08 +0100
Message-Id: <20170901153508.24738-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array rc_nec_tab on the stack, instead make it
static const. Makes the object code smaller by over 620 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  49511	  17040	     64	  66615	  10437	rtl28xxu.o

After:
   text	   data	    bss	    dec	    hex	filename
  48825	  17104	     64	  65993	  101c9	rtl28xxu.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 95a7b9123f8e..c76e78f9638a 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1598,7 +1598,7 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 	struct rtl28xxu_dev *dev = d->priv;
 	u8 buf[5];
 	u32 rc_code;
-	struct rtl28xxu_reg_val rc_nec_tab[] = {
+	static const struct rtl28xxu_reg_val rc_nec_tab[] = {
 		{ 0x3033, 0x80 },
 		{ 0x3020, 0x43 },
 		{ 0x3021, 0x16 },
-- 
2.14.1
