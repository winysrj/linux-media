Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49213 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbaCCJtY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 04:49:24 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/4] [media] em28xx: Display the used DVB alternate
Date: Mon,  3 Mar 2014 06:48:45 -0300
Message-Id: <1393840127-22081-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393840127-22081-1-git-send-email-m.chehab@samsung.com>
References: <1393840127-22081-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 301463f463c6..16c4d58a985b 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -212,10 +212,10 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 	if (rc < 0)
 		return rc;
 
-	dprintk(1, "Using %d buffers each with %d x %d bytes\n",
+	dprintk(1, "Using %d buffers each with %d x %d bytes, alternate %d\n",
 		EM28XX_DVB_NUM_BUFS,
 		packet_multiplier,
-		dvb_max_packet_size);
+		dvb_max_packet_size, dvb_alt);
 
 	return em28xx_init_usb_xfer(dev, EM28XX_DIGITAL_MODE,
 				    dev->dvb_xfer_bulk,
-- 
1.8.5.3

