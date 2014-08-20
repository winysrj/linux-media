Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3366 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaHTW7r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 16/29] uvc: fix sparse warning
Date: Thu, 21 Aug 2014 00:59:15 +0200
Message-Id: <1408575568-20562-17-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/uvc/uvc_video.c:1466:38: warning: incorrect type in return expression (different base types)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/uvc/uvc_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 9144a2f..7e350d7 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1463,7 +1463,7 @@ static unsigned int uvc_endpoint_max_bpi(struct usb_device *dev,
 
 	switch (dev->speed) {
 	case USB_SPEED_SUPER:
-		return ep->ss_ep_comp.wBytesPerInterval;
+		return le16_to_cpu(ep->ss_ep_comp.wBytesPerInterval);
 	case USB_SPEED_HIGH:
 		psize = usb_endpoint_maxp(&ep->desc);
 		return (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
-- 
2.1.0.rc1

