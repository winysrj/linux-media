Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54931 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab3GWPMQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 11:12:16 -0400
Received: by mail-pa0-f52.google.com with SMTP id kq13so2936591pab.39
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 08:12:15 -0700 (PDT)
From: Chris Lee <updatelee@gmail.com>
To: linux-media@vger.kernel.org
Cc: Chris Lee <updatelee@gmail.com>
Subject: [PATCH] This brings the genpix line of devices snr reporting in line with other drivers
Date: Tue, 23 Jul 2013 09:12:06 -0600
Message-Id: <1374592326-13427-1-git-send-email-updatelee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Chris Lee <updatelee@gmail.com>

---
 drivers/media/usb/dvb-usb/gp8psk-fe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/gp8psk-fe.c b/drivers/media/usb/dvb-usb/gp8psk-fe.c
index 67957dd..5864f37 100644
--- a/drivers/media/usb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/usb/dvb-usb/gp8psk-fe.c
@@ -45,7 +45,7 @@ static int gp8psk_fe_update_status(struct gp8psk_fe_state *st)
 	if (time_after(jiffies,st->next_status_check)) {
 		gp8psk_usb_in_op(st->d, GET_SIGNAL_LOCK, 0,0,&st->lock,1);
 		gp8psk_usb_in_op(st->d, GET_SIGNAL_STRENGTH, 0,0,buf,6);
-		st->snr = (buf[1]) << 8 | buf[0];
+		st->snr = ((buf[1]) << 8 | buf[0]) << 4;
 		st->next_status_check = jiffies + (st->status_check_interval*HZ)/1000;
 	}
 	return 0;
-- 
1.8.1.2

