Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42725 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbaIVUy6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 16:54:58 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 2/2] [media] au0828-cards: remove a comment about i2c clock stretching
Date: Mon, 22 Sep 2014 17:54:29 -0300
Message-Id: <1ba3f927ad66759b0081fe1f96d77500c9a622c3.1411419252.git.mchehab@osg.samsung.com>
In-Reply-To: <886da6ac33ac7e82392f1bc8b7b25b058710a269.1411419252.git.mchehab@osg.samsung.com>
References: <886da6ac33ac7e82392f1bc8b7b25b058710a269.1411419252.git.mchehab@osg.samsung.com>
In-Reply-To: <886da6ac33ac7e82392f1bc8b7b25b058710a269.1411419252.git.mchehab@osg.samsung.com>
References: <886da6ac33ac7e82392f1bc8b7b25b058710a269.1411419252.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This comment is already at the au0828-i2c where it belongs.
So, remove it from a board's entry. It doesn't make any sense
there, as we're setting the clock to 250kHz there, slowing it
down only at the au0828-i2c.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index d229c6dbddb9..585a8f84228c 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -73,12 +73,6 @@ struct au0828_board au0828_boards[] = {
 		.tuner_type = TUNER_XC5000,
 		.tuner_addr = 0x61,
 		.has_ir_i2c = 1,
-		/* The au0828 hardware i2c implementation does not properly
-		   support the xc5000's i2c clock stretching.  So we need to
-		   lower the clock frequency enough where the 15us clock
-		   stretch fits inside of a normal clock cycle, or else the
-		   au0828 fails to set the STOP bit.  A 30 KHz clock puts the
-		   clock pulse width at 18us */
 		.i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
 		.input = {
 			{
-- 
1.9.3

