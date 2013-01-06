Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:47709 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab3AFRTr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jan 2013 12:19:47 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/3] [media] iguanair: ensure transmission mask is initialized
Date: Sun,  6 Jan 2013 17:19:44 +0000
Message-Id: <1357492785-30966-2-git-send-email-sean@mess.org>
In-Reply-To: <1357492785-30966-1-git-send-email-sean@mess.org>
References: <1357492785-30966-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 5a9163d..a569c69 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -512,6 +512,7 @@ static int __devinit iguanair_probe(struct usb_interface *intf,
 	rc->rx_resolution = RX_RESOLUTION;
 
 	iguanair_set_tx_carrier(rc, 38000);
+	iguanair_set_tx_mask(rc, 0);
 
 	ret = rc_register_device(rc);
 	if (ret < 0) {
-- 
1.7.11.7

