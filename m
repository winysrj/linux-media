Return-path: <linux-media-owner@vger.kernel.org>
Received: from gromit.nocabal.de ([78.46.53.8]:55589 "EHLO gromit.nocabal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517AbcAIUYz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2016 15:24:55 -0500
From: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
To: linux-media@vger.kernel.org
Cc: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
Subject: [PATCH 3/5] [media] af9013: cancel_delayed_work_sync before device removal / kfree
Date: Sat,  9 Jan 2016 21:18:45 +0100
Message-Id: <1452370727-23128-4-git-send-email-emw-linux-kernel@nocabal.de>
In-Reply-To: <1452370727-23128-1-git-send-email-emw-linux-kernel@nocabal.de>
References: <1452370727-23128-1-git-send-email-emw-linux-kernel@nocabal.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

af9013_remove  was calling  kfree(state)  with  possibly still  active
schedule_delayed_work(&state->statistics_work).   A   similar  bug  in
si2157 caused kernel panics in call_timer_fn e.g. after rmmod cx23885.

Signed-off-by: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
---
 drivers/media/dvb-frontends/af9013.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index e23197d..41ab5de 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -1344,6 +1344,10 @@ err:
 static void af9013_release(struct dvb_frontend *fe)
 {
 	struct af9013_state *state = fe->demodulator_priv;
+
+	/* stop statistics polling */
+	cancel_delayed_work_sync(&state->statistics_work);
+
 	kfree(state);
 }
 
-- 
2.5.0

