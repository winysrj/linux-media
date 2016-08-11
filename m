Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56250 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbcHKVLZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:25 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 15/28] media: usb: gspca: benq: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:51 +0200
Message-Id: <1470949451-24823-16-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/gspca/benq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/gspca/benq.c b/drivers/media/usb/gspca/benq.c
index 790baed339639d..5fa67b78ad49b1 100644
--- a/drivers/media/usb/gspca/benq.c
+++ b/drivers/media/usb/gspca/benq.c
@@ -95,10 +95,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 #define SD_NPKT 32
 	for (n = 0; n < 4; n++) {
 		urb = usb_alloc_urb(SD_NPKT, GFP_KERNEL);
-		if (!urb) {
-			pr_err("usb_alloc_urb failed\n");
+		if (!urb)
 			return -ENOMEM;
-		}
 		gspca_dev->urb[n] = urb;
 		urb->transfer_buffer = usb_alloc_coherent(gspca_dev->dev,
 						SD_PKT_SZ * SD_NPKT,
-- 
2.8.1

