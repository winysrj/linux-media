Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:51736 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750838AbdIOIA6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 04:00:58 -0400
Subject: [PATCH 9/9] [media] tm6000: Use common error handling code in
 tm6000_prepare_isoc()
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
Message-ID: <9ef1871e-1590-a031-84a9-31bd342b301e@users.sourceforge.net>
Date: Fri, 15 Sep 2017 10:00:28 +0200
MIME-Version: 1.0
In-Reply-To: <2aade468-5dfd-76ee-f59f-c25864930f61@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 15 Sep 2017 08:02:33 +0200

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/tm6000/tm6000-video.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 0d45f35e1697..bfdeb41ed3a1 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -602,7 +602,5 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
-	if (!dev->isoc_ctl.transfer_buffer) {
-		kfree(dev->isoc_ctl.urb);
-		return -ENOMEM;
-	}
+	if (!dev->isoc_ctl.transfer_buffer)
+		goto free_urb;
 
 	dprintk(dev, V4L2_DEBUG_QUEUE, "Allocating %d x %d packets (%d bytes) of %d bytes each to handle %u size\n",
 		    max_packets, num_bufs, sb_size,
@@ -616,7 +614,6 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
 		tm6000_free_urb_buffers(dev);
-		kfree(dev->isoc_ctl.urb);
 		kfree(dev->isoc_ctl.transfer_buffer);
-		return -ENOMEM;
+		goto free_urb;
 	}
 
 	/* allocate urbs and transfer buffers */
@@ -646,6 +643,10 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
 	}
 
 	return 0;
+
+free_urb:
+	kfree(dev->isoc_ctl.urb);
+	return -ENOMEM;
 }
 
 static int tm6000_start_thread(struct tm6000_core *dev)
-- 
2.14.1
