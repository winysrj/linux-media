Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:36499 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab3CVDRU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 23:17:20 -0400
Received: by mail-bk0-f52.google.com with SMTP id jk13so1684775bkc.11
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 20:17:18 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 22 Mar 2013 11:17:18 +0800
Message-ID: <CAPgLHd_EgofJ+x4EdB-E4Fx8wm9Z5e7cyvde044SiXS0X-OBzg@mail.gmail.com>
Subject: [PATCH -next] [media] dvb_usb_v2: make local function
 dvb_usb_v2_generic_io() static
From: Wei Yongjun <weiyj.lk@gmail.com>
To: crope@iki.fi, mchehab@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

dvb_usb_v2_generic_io() was not declared. It should be static.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
index 74c911f..aa0c35e 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
@@ -21,7 +21,7 @@
 
 #include "dvb_usb_common.h"
 
-int dvb_usb_v2_generic_io(struct dvb_usb_device *d,
+static int dvb_usb_v2_generic_io(struct dvb_usb_device *d,
 		u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
 {
 	int ret, actual_length;

