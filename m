Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36592 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbbHFJzY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2015 05:55:24 -0400
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Joe Perches <joe@perches.com>, Peter Karlsson <peter@zapto.se>,
	Tapasweni Pathak <tapaswenipathak@gmail.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	Tina Johnson <tinajohnson.1234@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH v3 2/2] Staging: media: lirc: use USB API functions rather than constants
Date: Thu,  6 Aug 2015 15:24:22 +0530
Message-Id: <1438854862-10213-2-git-send-email-shraddha.6596@gmail.com>
In-Reply-To: <1438854862-10213-1-git-send-email-shraddha.6596@gmail.com>
References: <1438854862-10213-1-git-send-email-shraddha.6596@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces the use of the function usb_endpoint_type.

The Coccinelle semantic patch that makes these changes is as follows:

@@ struct usb_endpoint_descriptor *epd; @@

- (epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\))
+ usb_endpoint_type(epd)

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
Changes in v3:
  -No changes.

 drivers/staging/media/lirc/lirc_imon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 62ec9f7..cbeec83 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -739,7 +739,7 @@ static int imon_probe(struct usb_interface *interface,
 
 		ep = &iface_desc->endpoint[i].desc;
 		ep_dir = ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK;
-		ep_type = ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
+		ep_type = usb_endpoint_type(ep);
 
 		if (!ir_ep_found &&
 			ep_dir == USB_DIR_IN &&
-- 
2.1.0

