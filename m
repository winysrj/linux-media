Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:51791 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754945Ab0EWSbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 14:31:14 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 3/5] tm6000: set variable dev_mode in function tm6000_start_stream
Date: Sun, 23 May 2010 20:29:26 +0200
Message-Id: <1274639366-2613-3-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1274639366-2613-1-git-send-email-stefan.ringel@arcor.de>
References: <1274639366-2613-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

set variable dev_mode in function tm6000_start_stream and check mode

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-dvb.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index eafc89c..e6a802e 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -100,7 +100,10 @@ int tm6000_start_stream(struct tm6000_core *dev)
 
 	printk(KERN_INFO "tm6000: got start stream request %s\n",__FUNCTION__);
 
-	tm6000_init_digital_mode(dev);
+	if (dev->mode != TM6000_MODE_DIGITAL) {
+		tm6000_init_digital_mode(dev);
+		dev->mode = TM6000_MODE_DIGITAL;
+	}
 
 	dvb->bulk_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if(dvb->bulk_urb == NULL) {
-- 
1.7.0.3

