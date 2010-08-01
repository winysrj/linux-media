Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab0HAUSh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Aug 2010 16:18:37 -0400
Date: Sun, 1 Aug 2010 17:17:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Udi Atar <udia@siano-ms.com>
Subject: [PATCH 3/6] V4L/DVB: smsusb: enable IR port for Hauppauge WinTV
 MiniStick
Message-ID: <20100801171718.5ad62978@pedra>
In-Reply-To: <cover.1280693675.git.mchehab@redhat.com>
References: <cover.1280693675.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the proper gpio port for WinTV MiniStick, with the information provided
by Michael.

Thanks-to: Michael Krufky <mkrufky@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/siano/sms-cards.c b/drivers/media/dvb/siano/sms-cards.c
index cff77e2..dcde606 100644
--- a/drivers/media/dvb/siano/sms-cards.c
+++ b/drivers/media/dvb/siano/sms-cards.c
@@ -67,6 +67,7 @@ static struct sms_board sms_boards[] = {
 		.board_cfg.leds_power = 26,
 		.board_cfg.led0 = 27,
 		.board_cfg.led1 = 28,
+		.board_cfg.ir = 9,
 		.led_power = 26,
 		.led_lo    = 27,
 		.led_hi    = 28,
-- 
1.7.1


