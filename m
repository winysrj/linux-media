Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756443AbZKQWoL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 17:44:11 -0500
Message-Id: <200911172243.nAHMheaR029255@imap1.linux-foundation.org>
Subject: [patch 4/5] sms-cards: make id unsigned in sms_get_board()
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	roel.kluin@gmail.com, mkrufky@kernellabs.com
From: akpm@linux-foundation.org
Date: Tue, 17 Nov 2009 14:43:40 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Roel Kluin <roel.kluin@gmail.com>

Make id signed so we can't get an invalid pointer when we pass a negative
id.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@kernellabs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/siano/sms-cards.c |    2 +-
 drivers/media/dvb/siano/sms-cards.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/dvb/siano/sms-cards.c~sms-cards-make-id-unsigned-in-sms_get_board drivers/media/dvb/siano/sms-cards.c
--- a/drivers/media/dvb/siano/sms-cards.c~sms-cards-make-id-unsigned-in-sms_get_board
+++ a/drivers/media/dvb/siano/sms-cards.c
@@ -97,7 +97,7 @@ static struct sms_board sms_boards[] = {
 	},
 };
 
-struct sms_board *sms_get_board(int id)
+struct sms_board *sms_get_board(unsigned id)
 {
 	BUG_ON(id >= ARRAY_SIZE(sms_boards));
 
diff -puN drivers/media/dvb/siano/sms-cards.h~sms-cards-make-id-unsigned-in-sms_get_board drivers/media/dvb/siano/sms-cards.h
--- a/drivers/media/dvb/siano/sms-cards.h~sms-cards-make-id-unsigned-in-sms_get_board
+++ a/drivers/media/dvb/siano/sms-cards.h
@@ -81,7 +81,7 @@ struct sms_board {
 	int led_power, led_hi, led_lo, lna_ctrl, rf_switch;
 };
 
-struct sms_board *sms_get_board(int id);
+struct sms_board *sms_get_board(unsigned id);
 
 extern struct smscore_device_t *coredev;
 
_
