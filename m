Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2350 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab3JDOCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 10:02:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Huang Shijie <shijie8@gmail.com>
Subject: [PATCH 12/14] tlg2300: fix sparse warning
Date: Fri,  4 Oct 2013 16:01:50 +0200
Message-Id: <1380895312-30863-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/tlg2300/pd-main.c:235:25: warning: incorrect type in assignment (different base types)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Huang Shijie <shijie8@gmail.com>
---
 drivers/media/usb/tlg2300/pd-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/tlg2300/pd-main.c b/drivers/media/usb/tlg2300/pd-main.c
index 95f94e5..3316caa 100644
--- a/drivers/media/usb/tlg2300/pd-main.c
+++ b/drivers/media/usb/tlg2300/pd-main.c
@@ -232,7 +232,7 @@ static int firmware_download(struct usb_device *udev)
 		goto out;
 	}
 
-	max_packet_size = udev->ep_out[0x1]->desc.wMaxPacketSize;
+	max_packet_size = le16_to_cpu(udev->ep_out[0x1]->desc.wMaxPacketSize);
 	log("\t\t download size : %d", (int)max_packet_size);
 
 	for (offset = 0; offset < fwlength; offset += max_packet_size) {
-- 
1.8.3.2

