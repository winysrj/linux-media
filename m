Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:39713 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753619AbdIROYr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 10:24:47 -0400
From: Colin King <colin.king@canonical.com>
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] cxusb: pass buf as a const u8 * pointer and make buf static const
Date: Mon, 18 Sep 2017 15:24:44 +0100
Message-Id: <20170918142444.31914-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate the read-only u8 array buf on the stack at run time but
instead make it static const; makes object code smaller saving over 480
bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  33030	  65936	    192	  99158	  18356	drivers/media/usb/dvb-usb/cxusb.o

After:
   text	   data	    bss	    dec	    hex	filename
  32446	  66032	    192	  98670	  1816e	drivers/media/usb/dvb-usb/cxusb.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/dvb-usb/cxusb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 37dea0adc695..b5cc1b990065 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -56,7 +56,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 #define deb_i2c(args...)    dprintk(dvb_usb_cxusb_debug, 0x02, args)
 
 static int cxusb_ctrl_msg(struct dvb_usb_device *d,
-			  u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
+			  u8 cmd, const u8 *wbuf, int wlen, u8 *rbuf, int rlen)
 {
 	struct cxusb_state *st = d->priv;
 	int ret;
@@ -290,7 +290,8 @@ static int cxusb_aver_power_ctrl(struct dvb_usb_device *d, int onoff)
 		/* FIXME: We don't know why, but we need to configure the
 		 * lgdt3303 with the register settings below on resume */
 		int i;
-		u8 buf, bufs[] = {
+		u8 buf;
+		static const u8 bufs[] = {
 			0x0e, 0x2, 0x00, 0x7f,
 			0x0e, 0x2, 0x02, 0xfe,
 			0x0e, 0x2, 0x02, 0x01,
-- 
2.14.1
