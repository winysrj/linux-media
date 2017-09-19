Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:49616 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751661AbdISSp7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 14:45:59 -0400
Subject: [PATCH 1/3] [media] hdpvr: Delete three error messages for a failed
 memory allocation
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jonathan Sims <jonathan.625266@earthlink.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <82d14066-5816-111c-9d21-f6a439e559c1@users.sourceforge.net>
Message-ID: <3dc5f6be-6002-5cbf-a820-d803f9afad69@users.sourceforge.net>
Date: Tue, 19 Sep 2017 20:45:40 +0200
MIME-Version: 1.0
In-Reply-To: <82d14066-5816-111c-9d21-f6a439e559c1@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 19 Sep 2017 09:33:26 +0200

Omit extra messages for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/hdpvr/hdpvr-core.c  | 8 ++------
 drivers/media/usb/hdpvr/hdpvr-video.c | 5 ++---
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index dbe29c6c4d8b..f1c156814e10 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -282,6 +282,4 @@ static int hdpvr_probe(struct usb_interface *interface,
-	if (!dev) {
-		dev_err(&interface->dev, "Out of memory\n");
+	if (!dev)
 		goto error;
-	}
 
 	/* init video transfer queues first of all */
@@ -302,6 +300,4 @@ static int hdpvr_probe(struct usb_interface *interface,
-	if (!dev->usbc_buf) {
-		v4l2_err(&dev->v4l2_dev, "Out of memory\n");
+	if (!dev->usbc_buf)
 		goto error;
-	}
 
 	init_waitqueue_head(&dev->wait_buffer);
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 7fb036d6a86e..657d910dfa1d 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -150,7 +150,6 @@ int hdpvr_alloc_buffers(struct hdpvr_device *dev, uint count)
-		if (!buf) {
-			v4l2_err(&dev->v4l2_dev, "cannot allocate buffer\n");
+		if (!buf)
 			goto exit;
-		}
+
 		buf->dev = dev;
 
 		urb = usb_alloc_urb(0, GFP_KERNEL);
-- 
2.14.1
