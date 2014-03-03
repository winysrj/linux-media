Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbaCCJtZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 04:49:25 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/4] [media] em28xx_dvb: only call the software filter if data
Date: Mon,  3 Mar 2014 06:48:44 -0300
Message-Id: <1393840127-22081-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several URBs will be simply not filled. Don't call the DVB
core software filter for those empty URBs.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index c1091c454354..301463f463c6 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -161,6 +161,8 @@ static inline int em28xx_dvb_urb_data_copy(struct em28xx *dev, struct urb *urb)
 				if (urb->status != -EPROTO)
 					continue;
 			}
+			if (!urb->actual_length)
+				continue;
 			dvb_dmx_swfilter(&dev->dvb->demux, urb->transfer_buffer,
 					urb->actual_length);
 		} else {
@@ -170,6 +172,8 @@ static inline int em28xx_dvb_urb_data_copy(struct em28xx *dev, struct urb *urb)
 				if (urb->iso_frame_desc[i].status != -EPROTO)
 					continue;
 			}
+			if (!urb->iso_frame_desc[i].actual_length)
+				continue;
 			dvb_dmx_swfilter(&dev->dvb->demux,
 					 urb->transfer_buffer +
 					 urb->iso_frame_desc[i].offset,
-- 
1.8.5.3

