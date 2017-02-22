Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:33067 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933605AbdBVWfN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 17:35:13 -0500
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: mchehab@kernel.org, wsa-dev@sang-engineering.com,
        hans.verkuil@cisco.com, kumar.san1093@gmail.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] [media] tm6000: Fix resource freeing in 'tm6000_prepare_isoc()'
Date: Wed, 22 Feb 2017 23:32:19 +0100
Message-Id: <20170222223219.13211-1-christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'usb_free_urb(urb)' is a no-op, because urb is known to be NULL.

It is likelly that releasing resources allocated by
'tm6000_alloc_urb_buffers()' just a few lines above is expected here.


This has been spotted by the following coccinelle script:
@@
expression ret, x, e;
identifier f;
@@

*   if (x == NULL)
    {
     ... when != x = e;
(
*    f(<+...x...+>);
|
*    ret = f(<+...x...+>);
)
     ...
    }

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/media/usb/tm6000/tm6000-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index c4fdc1fa32ef..7e960d0a5b92 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -631,7 +631,7 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
 		urb = usb_alloc_urb(max_packets, GFP_KERNEL);
 		if (!urb) {
 			tm6000_uninit_isoc(dev);
-			usb_free_urb(urb);
+			tm6000_free_urb_buffers(dev);
 			return -ENOMEM;
 		}
 		dev->isoc_ctl.urb[i] = urb;
-- 
2.9.3
