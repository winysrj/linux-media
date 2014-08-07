Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35400 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbaHGQKe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Aug 2014 12:10:34 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/3] au0828: Enable IR for HVR-850.
Date: Thu,  7 Aug 2014 13:10:26 -0300
Message-Id: <1407427826-12886-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407427826-12886-1-git-send-email-m.chehab@samsung.com>
References: <1407427826-12886-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HVR-850 also has a remote. Enable it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-cards.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index 2c6b7da137ed..b6c9d1f466bd 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -46,6 +46,7 @@ struct au0828_board au0828_boards[] = {
 		.name	= "Hauppauge HVR850",
 		.tuner_type = TUNER_XC5000,
 		.tuner_addr = 0x61,
+		.has_ir_i2c = 1,
 		.i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
 		.input = {
 			{
-- 
1.9.3

