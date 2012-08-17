Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50031 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933531Ab2HQCH2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 22:07:28 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] dvb_usb_v2: use ratelimited debugs where appropriate
Date: Fri, 17 Aug 2012 05:07:08 +0300
Message-Id: <1345169228-10650-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/usb_urb.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/usb_urb.c b/drivers/media/usb/dvb-usb-v2/usb_urb.c
index eaf673a..5989b65 100644
--- a/drivers/media/usb/dvb-usb-v2/usb_urb.c
+++ b/drivers/media/usb/dvb-usb-v2/usb_urb.c
@@ -22,9 +22,9 @@ static void usb_urb_complete(struct urb *urb)
 	int i;
 	u8 *b;
 
-	dev_dbg(&stream->udev->dev, "%s: %s urb completed status=%d " \
-			"length=%d/%d pack_num=%d errors=%d\n", __func__,
-			ptype == PIPE_ISOCHRONOUS ? "isoc" : "bulk",
+	dev_dbg_ratelimited(&stream->udev->dev, "%s: %s urb completed " \
+			"status=%d length=%d/%d pack_num=%d errors=%d\n",
+			__func__, ptype == PIPE_ISOCHRONOUS ? "isoc" : "bulk",
 			urb->status, urb->actual_length,
 			urb->transfer_buffer_length,
 			urb->number_of_packets, urb->error_count);
@@ -38,7 +38,8 @@ static void usb_urb_complete(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:        /* error */
-		dev_dbg(&stream->udev->dev, "%s: urb completition failed=%d\n",
+		dev_dbg_ratelimited(&stream->udev->dev,
+				"%s: urb completition failed=%d\n",
 				__func__, urb->status);
 		break;
 	}
-- 
1.7.11.2

