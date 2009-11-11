Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:32131 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236AbZKKQlX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 11:41:23 -0500
Message-ID: <4AFAEC06.3060701@gmail.com>
Date: Wed, 11 Nov 2009 17:53:26 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sms-cards: make id unsigned in sms_get_board()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make id signed so we can't get an invalid pointer
when we pass a negative id.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/media/dvb/siano/sms-cards.c |    2 +-
 drivers/media/dvb/siano/sms-cards.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/siano/sms-cards.c b/drivers/media/dvb/siano/sms-cards.c
index 0420e28..c61f026 100644
--- a/drivers/media/dvb/siano/sms-cards.c
+++ b/drivers/media/dvb/siano/sms-cards.c
@@ -97,7 +97,7 @@ static struct sms_board sms_boards[] = {
 	},
 };
 
-struct sms_board *sms_get_board(int id)
+struct sms_board *sms_get_board(unsigned id)
 {
 	BUG_ON(id >= ARRAY_SIZE(sms_boards));
 
diff --git a/drivers/media/dvb/siano/sms-cards.h b/drivers/media/dvb/siano/sms-cards.h
index 38f062f..8f19fc0 100644
--- a/drivers/media/dvb/siano/sms-cards.h
+++ b/drivers/media/dvb/siano/sms-cards.h
@@ -81,7 +81,7 @@ struct sms_board {
 	int led_power, led_hi, led_lo, lna_ctrl, rf_switch;
 };
 
-struct sms_board *sms_get_board(int id);
+struct sms_board *sms_get_board(unsigned id);
 
 extern struct smscore_device_t *coredev;
 
