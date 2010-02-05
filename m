Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:54703 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933846Ab0BEW5s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 17:57:48 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 3/12] tm6000: clean the identifer string
Date: Fri,  5 Feb 2010 23:57:03 +0100
Message-Id: <1265410631-11955-3-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1265410631-11955-2-git-send-email-stefan.ringel@arcor.de>
References: <1265410631-11955-1-git-send-email-stefan.ringel@arcor.de>
 <1265410631-11955-2-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index e697ce3..1167b01 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -480,7 +480,7 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 	/* Check to see next free device and mark as used */
 	nr=find_first_zero_bit(&tm6000_devused,TM6000_MAXBOARDS);
 	if (nr >= TM6000_MAXBOARDS) {
-		printk ("tm6000: Supports only %i em28xx boards.\n",TM6000_MAXBOARDS);
+		printk ("tm6000: Supports only %i tm60xx boards.\n",TM6000_MAXBOARDS);
 		usb_put_dev(usbdev);
 		return -ENOMEM;
 	}
-- 
1.6.4.2

