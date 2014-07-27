Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54594 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbaG0T1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 15:27:39 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 1/6] cx231xx: Fix the max number of interfaces
Date: Sun, 27 Jul 2014 16:27:27 -0300
Message-Id: <1406489252-30636-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406489252-30636-1-git-send-email-m.chehab@samsung.com>
References: <1406489252-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The max number of interfaces was read from the wrong descriptor.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index b2fa05d985c1..d40284536beb 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1325,8 +1325,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	dev->vbi_or_sliced_cc_mode = 0;
 
 	/* get maximum no.of IAD interfaces */
-	assoc_desc = udev->actconfig->intf_assoc[0];
-	dev->max_iad_interface_count = assoc_desc->bInterfaceCount;
+	dev->max_iad_interface_count = udev->config->desc.bNumInterfaces;
 
 	/* init CIR module TBD */
 
-- 
1.9.3

