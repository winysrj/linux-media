Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:33120 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900Ab3CTPaz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 11:30:55 -0400
Received: by mail-bk0-f41.google.com with SMTP id q16so964304bkw.0
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 08:30:46 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 20 Mar 2013 23:30:46 +0800
Message-ID: <CAPgLHd_meovx6jHZTCQDJcYdus_L+RFOtXEDqXpwdqrR1EVbbQ@mail.gmail.com>
Subject: [PATCH -next] [media] gspca: remove needless check before usb_free_coherent()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: hdegoede@redhat.com, mchehab@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

usb_free_coherent() is safe with NULL addr and this check is
not required.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/usb/gspca/gspca.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 5800d65..924e032 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -567,11 +567,10 @@ static void destroy_urbs(struct gspca_dev *gspca_dev)
 
 		gspca_dev->urb[i] = NULL;
 		usb_kill_urb(urb);
-		if (urb->transfer_buffer != NULL)
-			usb_free_coherent(gspca_dev->dev,
-					  urb->transfer_buffer_length,
-					  urb->transfer_buffer,
-					  urb->transfer_dma);
+		usb_free_coherent(gspca_dev->dev,
+				  urb->transfer_buffer_length,
+				  urb->transfer_buffer,
+				  urb->transfer_dma);
 		usb_free_urb(urb);
 	}
 }


