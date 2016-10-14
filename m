Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59095 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756780AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        =?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
        <chehabrafael@gmail.com>
Subject: [PATCH 33/57] [media] au0828: don't break long lines
Date: Fri, 14 Oct 2016 17:20:21 -0300
Message-Id: <308bf6b8e61030d4170589b58c0567c00ff9fd62.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/au0828/au0828-video.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 85dd9a8e83ff..7a10eaa38f67 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -253,8 +253,7 @@ static int au0828_init_isoc(struct au0828_dev *dev, int max_packets,
 		dev->isoc_ctl.transfer_buffer[i] = usb_alloc_coherent(dev->usbdev,
 			sb_size, GFP_KERNEL, &urb->transfer_dma);
 		if (!dev->isoc_ctl.transfer_buffer[i]) {
-			printk("unable to allocate %i bytes for transfer"
-					" buffer %i%s\n",
+			printk("unable to allocate %i bytes for transfer buffer %i%s\n",
 					sb_size, i,
 					in_interrupt() ? " while in int" : "");
 			au0828_uninit_isoc(dev);
-- 
2.7.4


