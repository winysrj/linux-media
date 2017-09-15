Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:64150 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750866AbdIOH7r (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 03:59:47 -0400
Subject: [PATCH 8/9] [media] tm6000: Use common error handling code in
 tm6000_start_stream()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Sean Young <sean@mess.org>,
        Wei Yongjun <weiyongjun1@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <2aade468-5dfd-76ee-f59f-c25864930f61@users.sourceforge.net>
Message-ID: <0aac22c7-bac1-190c-d5b8-9129d309ca3f@users.sourceforge.net>
Date: Fri, 15 Sep 2017 09:59:19 +0200
MIME-Version: 1.0
In-Reply-To: <2aade468-5dfd-76ee-f59f-c25864930f61@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 15 Sep 2017 07:47:41 +0200

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/tm6000/tm6000-dvb.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-dvb.c b/drivers/media/usb/tm6000/tm6000-dvb.c
index 855874134fcf..b45e54d5cab9 100644
--- a/drivers/media/usb/tm6000/tm6000-dvb.c
+++ b/drivers/media/usb/tm6000/tm6000-dvb.c
@@ -134,8 +134,8 @@ static int tm6000_start_stream(struct tm6000_core *dev)
 
 	dvb->bulk_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
 	if (!dvb->bulk_urb->transfer_buffer) {
-		usb_free_urb(dvb->bulk_urb);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto free_urb;
 	}
 
 	usb_fill_bulk_urb(dvb->bulk_urb, dev->udev, pipe,
@@ -160,11 +160,14 @@ static int tm6000_start_stream(struct tm6000_core *dev)
 									ret);
 
 		kfree(dvb->bulk_urb->transfer_buffer);
-		usb_free_urb(dvb->bulk_urb);
-		return ret;
+		goto free_urb;
 	}
 
 	return 0;
+
+free_urb:
+	usb_free_urb(dvb->bulk_urb);
+	return ret;
 }
 
 static void tm6000_stop_stream(struct tm6000_core *dev)
-- 
2.14.1
