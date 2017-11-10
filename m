Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([50.116.126.1]:34756 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755317AbdKJBJm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Nov 2017 20:09:42 -0500
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id D1C723E57
        for <linux-media@vger.kernel.org>; Thu,  9 Nov 2017 18:21:37 -0600 (CST)
Date: Thu, 9 Nov 2017 18:21:34 -0600
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Andrey Konovalov <andreyknvl@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        Andi Shyti <andi.shyti@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] au0828: fix use-after-free at USB probing
Message-ID: <20171110002134.GA32019@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeHK+wZXZMxqQn9QbAd3xWt00_bKir4-La2QKtzk8nFb0FQmw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

Could you please try this patch?

Thank you


The device is typically freed on failure after trying to set
USB interface0 to as5 in function au0828_analog_register.

Fix use-after-free by returning the error value inmediately
after failure, instead of jumping to au0828_usb_disconnect
where _dev_ is also freed.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/usb/au0828/au0828-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index cd363a2..b4abd90 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -630,7 +630,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
 			__func__);
 		mutex_unlock(&dev->lock);
 		kfree(dev);
-		goto done;
+		return retval;
 	}
 
 	/* Digital TV */
@@ -655,7 +655,6 @@ static int au0828_usb_probe(struct usb_interface *interface,
 
 	retval = au0828_media_device_register(dev, usbdev);
 
-done:
 	if (retval < 0)
 		au0828_usb_disconnect(interface);
 
-- 
2.7.4
