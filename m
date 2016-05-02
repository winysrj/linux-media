Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbcEBLXY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2016 07:23:24 -0400
From: Oliver Neukum <oneukum@suse.com>
To: gregKH@linuxfoundation.org, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Cc: Oliver Neukum <oneukum@suse.com>, Oliver Neukum <ONeukum@suse.com>
Subject: [PATCH 2/2] uvc: correct speed testing
Date: Mon,  2 May 2016 13:23:21 +0200
Message-Id: <1462188201-20357-1-git-send-email-oneukum@suse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow for SS+ USB devices

Signed-off-by: Oliver Neukum <ONeukum@suse.com>
---
 drivers/media/usb/uvc/uvc_video.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 075a0fe..b5589d5 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1470,6 +1470,7 @@ static unsigned int uvc_endpoint_max_bpi(struct usb_device *dev,
 
 	switch (dev->speed) {
 	case USB_SPEED_SUPER:
+	case USB_SPEED_SUPER_PLUS:
 		return le16_to_cpu(ep->ss_ep_comp.wBytesPerInterval);
 	case USB_SPEED_HIGH:
 		psize = usb_endpoint_maxp(&ep->desc);
-- 
2.1.4

