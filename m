Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56187 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbcHKVLO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:14 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 02/28] media: radio: si470x: radio-si470x-usb: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:38 +0200
Message-Id: <1470949451-24823-3-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/radio/si470x/radio-si470x-usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 091d793f658361..4b132c29f2900c 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -627,7 +627,6 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 
 	radio->int_in_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!radio->int_in_urb) {
-		dev_info(&intf->dev, "could not allocate int_in_urb");
 		retval = -ENOMEM;
 		goto err_intbuffer;
 	}
-- 
2.8.1

