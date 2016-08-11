Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56264 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932644AbcHKVL1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:27 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 18/28] media: usb: hackrf: hackrf: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:54 +0200
Message-Id: <1470949451-24823-19-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/hackrf/hackrf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index b1e229a44192d3..c2c8d12e949868 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -691,7 +691,6 @@ static int hackrf_alloc_urbs(struct hackrf_dev *dev, bool rcv)
 		dev_dbg(dev->dev, "alloc urb=%d\n", i);
 		dev->urb_list[i] = usb_alloc_urb(0, GFP_ATOMIC);
 		if (!dev->urb_list[i]) {
-			dev_dbg(dev->dev, "failed\n");
 			for (j = 0; j < i; j++)
 				usb_free_urb(dev->urb_list[j]);
 			return -ENOMEM;
-- 
2.8.1

