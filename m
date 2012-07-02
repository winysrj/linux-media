Return-path: <linux-media-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:48584 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab2GBBiD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jul 2012 21:38:03 -0400
Date: Mon, 2 Jul 2012 11:38:03 +1000
From: Anton Blanchard <anton@samba.org>
To: mchehab@infradead.org, stoth@kernellabs.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] cx23885: Silence unknown command warnings
Message-ID: <20120702113803.569f8e56@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I am seeing a constant stream of warnings on my cx23885 based card:

cx23885_tuner_callback(): Unknown command 0x2.

Add a check in cx23885_tuner_callback to silence it.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index 13739e0..fa7e851 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -900,7 +900,7 @@ int cx23885_tuner_callback(void *priv, int component, int command, int arg)
 	struct cx23885_dev *dev = port->dev;
 	u32 bitmask = 0;
 
-	if (command == XC2028_RESET_CLK)
+	if ((command == XC2028_RESET_CLK) || (command == XC2028_I2C_FLUSH))
 		return 0;
 
 	if (command != 0) {
