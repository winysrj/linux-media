Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:62311 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965100AbcJXVBA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 17:01:00 -0400
Subject: [PATCH 2/3] [media] au0828-video: Delete three error messages for a
 failed memory allocation
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
        <chehabrafael@gmail.com>, Shuah Khan <shuah@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
References: <c6a37822-c0f9-1f1e-6ebe-a1c88c6d9d0a@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <4bd439b2-731d-4b81-eb65-1efdc20cd231@users.sourceforge.net>
Date: Mon, 24 Oct 2016 23:00:45 +0200
MIME-Version: 1.0
In-Reply-To: <c6a37822-c0f9-1f1e-6ebe-a1c88c6d9d0a@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 24 Oct 2016 22:28:03 +0200

Omit extra messages for a memory allocation failure in this function.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/au0828/au0828-video.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 85b13c1..b5c88a7 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -224,17 +224,14 @@ static int au0828_init_isoc(struct au0828_dev *dev, int max_packets,
 	dev->isoc_ctl.urb = kcalloc(num_bufs,
 				    sizeof(*dev->isoc_ctl.urb),
 				    GFP_KERNEL);
-	if (!dev->isoc_ctl.urb) {
-		au0828_isocdbg("cannot alloc memory for usb buffers\n");
+	if (!dev->isoc_ctl.urb)
 		return -ENOMEM;
-	}
 
 	dev->isoc_ctl.transfer_buffer = kcalloc(num_bufs,
 						sizeof(*dev->isoc_ctl
 						       .transfer_buffer),
 						GFP_KERNEL);
 	if (!dev->isoc_ctl.transfer_buffer) {
-		au0828_isocdbg("cannot allocate memory for usb transfer\n");
 		kfree(dev->isoc_ctl.urb);
 		return -ENOMEM;
 	}
@@ -256,10 +253,6 @@ static int au0828_init_isoc(struct au0828_dev *dev, int max_packets,
 		dev->isoc_ctl.transfer_buffer[i] = usb_alloc_coherent(dev->usbdev,
 			sb_size, GFP_KERNEL, &urb->transfer_dma);
 		if (!dev->isoc_ctl.transfer_buffer[i]) {
-			printk("unable to allocate %i bytes for transfer"
-					" buffer %i%s\n",
-					sb_size, i,
-					in_interrupt() ? " while in int" : "");
 			au0828_uninit_isoc(dev);
 			return -ENOMEM;
 		}
-- 
2.10.1

