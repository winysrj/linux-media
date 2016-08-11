Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56199 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbcHKVLQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:16 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 05/28] media: usb: airspy: airspy: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:41 +0200
Message-Id: <1470949451-24823-6-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/airspy/airspy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index fe031b06935fbb..3c556ee306cd33 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -426,7 +426,6 @@ static int airspy_alloc_urbs(struct airspy *s)
 		dev_dbg(s->dev, "alloc urb=%d\n", i);
 		s->urb_list[i] = usb_alloc_urb(0, GFP_ATOMIC);
 		if (!s->urb_list[i]) {
-			dev_dbg(s->dev, "failed\n");
 			for (j = 0; j < i; j++)
 				usb_free_urb(s->urb_list[j]);
 			return -ENOMEM;
-- 
2.8.1

