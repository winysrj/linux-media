Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54946 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbeCHJbM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2018 04:31:12 -0500
Date: Thu, 8 Mar 2018 12:31:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Brad Love <brad@nextdimension.cc>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] media: em28xx-cards: fix em28xx_duplicate_dev()
Message-ID: <20180308093100.GA16525@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a double sizeof() typo here so we don't duplicate the struct
properly.

Fixes: be7fd3c3a8c5 ("media: em28xx: Hauppauge DualHD second tuner functionality")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 6e8247849c4f..6e0e67d23876 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3515,7 +3515,7 @@ static int em28xx_duplicate_dev(struct em28xx *dev)
 		dev->dev_next = NULL;
 		return -ENOMEM;
 	}
-	memcpy(sec_dev, dev, sizeof(sizeof(*sec_dev)));
+	memcpy(sec_dev, dev, sizeof(*sec_dev));
 	/* Check to see next free device and mark as used */
 	do {
 		nr = find_first_zero_bit(em28xx_devused, EM28XX_MAXBOARDS);
