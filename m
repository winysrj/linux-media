Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f194.google.com ([209.85.160.194]:35257 "EHLO
	mail-yk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbbL2Vpm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 16:45:42 -0500
From: Insu Yun <wuninsu@gmail.com>
To: mchehab@osg.samsung.com, hverkuil@xs4all.nl, inki.dae@samsung.com,
	jh1009.sung@samsung.com, sw0312.kim@samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] usbtv: correctly handling failed allocation
Date: Tue, 29 Dec 2015 16:48:29 -0500
Message-Id: <1451425709-30624-1-git-send-email-wuninsu@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since kzalloc can be failed, 
if not properly handled, NULL dereference could be happened.

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/media/usb/usbtv/usbtv-video.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index e645c9d..92d8d7a 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -389,6 +389,10 @@ static struct urb *usbtv_setup_iso_transfer(struct usbtv *usbtv)
 	ip->transfer_flags = URB_ISO_ASAP;
 	ip->transfer_buffer = kzalloc(size * USBTV_ISOC_PACKETS,
 						GFP_KERNEL);
+	if (!ip->transfer_buffer) {
+		usb_free_urb(ip);
+		return NULL;
+	}
 	ip->complete = usbtv_iso_cb;
 	ip->number_of_packets = USBTV_ISOC_PACKETS;
 	ip->transfer_buffer_length = size * USBTV_ISOC_PACKETS;
-- 
1.9.1

