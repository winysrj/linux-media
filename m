Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57378 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab2IBWrq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Sep 2012 18:47:46 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9013: add debug for IF frequency
Date: Mon,  3 Sep 2012 01:47:25 +0300
Message-Id: <1346626045-29396-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Used IF frequency is one of the most important parameter to know.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 5bc570d..2dac314 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -606,6 +606,8 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		else
 			if_frequency = state->config.if_frequency;
 
+		dbg("%s: if_frequency=%d", __func__, if_frequency);
+
 		sampling_freq = if_frequency;
 
 		while (sampling_freq > (state->config.clock / 2))
-- 
1.7.11.4

