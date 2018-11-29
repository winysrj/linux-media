Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37228 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbeK3Jgh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 04:36:37 -0500
Received: by mail-wm1-f67.google.com with SMTP id g67so3828712wmd.2
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2018 14:29:34 -0800 (PST)
Received: from [192.168.43.227] (92.40.249.58.threembb.co.uk. [92.40.249.58])
        by smtp.gmail.com with ESMTPSA id j199sm7529434wmf.13.2018.11.29.14.29.32
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Nov 2018 14:29:33 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/4] media: lmedm04: Add missing usb_free_urb to free,
 interrupt urb
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <e967120b-eceb-f841-075c-aa2c15ada987@gmail.com>
Date: Thu, 29 Nov 2018 22:29:31 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The interrupt urb is killed but never freed add the function

Cc: stable@vger.kernel.org
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index f109c04f05ae..8b405e131439 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -1264,6 +1264,7 @@ static void *lme2510_exit_int(struct dvb_usb_device *d)
 
 	if (st->lme_urb != NULL) {
 		usb_kill_urb(st->lme_urb);
+		usb_free_urb(st->lme_urb);
 		usb_free_coherent(d->udev, 128, st->buffer,
 				  st->lme_urb->transfer_dma);
 		info("Interrupt Service Stopped");
-- 
2.19.1
