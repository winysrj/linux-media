Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36240 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755130AbcK3Vjg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Nov 2016 16:39:36 -0500
Received: by mail-wm0-f51.google.com with SMTP id g23so281217010wme.1
        for <linux-media@vger.kernel.org>; Wed, 30 Nov 2016 13:39:35 -0800 (PST)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Malcolm Priestley <tvboxspy@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] [media] lmedm04: make some string arrays static
Date: Wed, 30 Nov 2016 22:39:11 +0100
Message-Id: <1480541953-27256-3-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1480541953-27256-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1480541953-27256-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It takes more .text to initialize these on the stack than they occupy
in .rodata, so just make them static const.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index cd463f09ebc7..bf5bc36a6ed9 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -1002,8 +1002,9 @@ static int lme_name(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct lme2510_state *st = adap_to_priv(adap);
 	const char *desc = d->name;
-	char *fe_name[] = {"", " LG TDQY-P001F", " SHARP:BS2F7HZ7395",
-				" SHARP:BS2F7HZ0194", " RS2000"};
+	static const char * const fe_name[] = {
+		"", " LG TDQY-P001F", " SHARP:BS2F7HZ7395",
+		" SHARP:BS2F7HZ0194", " RS2000"};
 	char *name = adap->fe[0]->ops.info.name;
 
 	strlcpy(name, desc, 128);
@@ -1124,7 +1125,7 @@ static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct lme2510_state *st = adap_to_priv(adap);
-	char *tun_msg[] = {"", "TDA8263", "IX2505V", "DVB_PLL_OPERA", "RS2000"};
+	static const char * const tun_msg[] = {"", "TDA8263", "IX2505V", "DVB_PLL_OPERA", "RS2000"};
 	int ret = 0;
 
 	switch (st->tuner_config) {
-- 
2.1.4

