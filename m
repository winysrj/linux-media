Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44708 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752760AbcKRPRD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 10:17:03 -0500
Subject: patch "media: usb: uvc: remove unnecessary & operation" added to usb-next
To: felipe.balbi@linux.intel.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, mchehab@kernel.org
From: <gregkh@linuxfoundation.org>
Date: Fri, 18 Nov 2016 16:10:03 +0100
Message-ID: <147948180317113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    media: usb: uvc: remove unnecessary & operation

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


>From 670216f4d38bb128aa525450fe6ff9a5b3a2b8b0 Mon Sep 17 00:00:00 2001
From: Felipe Balbi <felipe.balbi@linux.intel.com>
Date: Wed, 28 Sep 2016 14:17:38 +0300
Subject: media: usb: uvc: remove unnecessary & operation

Now that usb_endpoint_maxp() only returns the lowest
11 bits from wMaxPacketSize, we can remove the &
operation from this driver.

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: <linux-media@vger.kernel.org>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/media/usb/uvc/uvc_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 11e0e5f4e1c2..f3c1c852e401 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1553,7 +1553,7 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
 	u16 psize;
 	u32 size;
 
-	psize = usb_endpoint_maxp(&ep->desc) & 0x7ff;
+	psize = usb_endpoint_maxp(&ep->desc);
 	size = stream->ctrl.dwMaxPayloadTransferSize;
 	stream->bulk.max_payload_size = size;
 
-- 
2.10.2


