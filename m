Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:1961 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2JAMuv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 08:50:51 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Michael Krufky <mkrufky@linuxtv.org>,
	Antti Palosaari <crope@iki.fi>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 2/2] tda18271: make 'low-power standby mode after attach' multi-instance safe
Date: Mon,  1 Oct 2012 08:34:24 -0400
Message-Id: <1349094864-19293-2-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1349094864-19293-1-git-send-email-mkrufky@linuxtv.org>
References: <1349094864-19293-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure that unnecessary features are powered down at the end of the
attach() function on attach of the tuner's first instance. If the
configuration requires the loop thru or xtout features, they will
remain enabled.

This must *only* be done after attaching the first instance of the tuner.
If there are multiple instances of the tuner, the bridge driver will need
to maintain power managament by itself.

Cc: Antti Palosaari <crope@iki.fi>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/tuners/tda18271-fe.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
index 5f5d866..de21197 100644
--- a/drivers/media/tuners/tda18271-fe.c
+++ b/drivers/media/tuners/tda18271-fe.c
@@ -1285,6 +1285,10 @@ struct dvb_frontend *tda18271_attach(struct dvb_frontend *fe, u8 addr,
 		    (priv->id == TDA18271HDC2))
 			tda18271c2_rf_cal_init(fe);
 
+		/* enter standby mode, with required output features enabled */
+		ret = tda18271_toggle_output(fe, 1);
+		tda_fail(ret);
+
 		mutex_unlock(&priv->lock);
 		break;
 	default:
@@ -1323,9 +1327,6 @@ struct dvb_frontend *tda18271_attach(struct dvb_frontend *fe, u8 addr,
 	if (tda18271_debug & (DBG_MAP | DBG_ADV))
 		tda18271_dump_std_map(fe);
 
-	ret = tda18271_sleep(fe);
-	tda_fail(ret);
-
 	return fe;
 fail:
 	mutex_unlock(&tda18271_list_mutex);
-- 
1.7.9.5

