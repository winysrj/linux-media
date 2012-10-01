Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:1937 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab2JAMuD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 08:50:03 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Michael Krufky <mkrufky@linuxtv.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] tda18271: enter low-power standby mode at the end of tda18271_attach()
Date: Mon,  1 Oct 2012 08:34:23 -0400
Message-Id: <1349094864-19293-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure that unnecessary features are powered down at the end of the
attach() function.  If the configuration requires the loop thru or
xtout features, they will remain enabled.

Thanks to Antti Palosaari for noticing the additional power consumption.

Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/tuners/tda18271-fe.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
index 2e67f44..5f5d866 100644
--- a/drivers/media/tuners/tda18271-fe.c
+++ b/drivers/media/tuners/tda18271-fe.c
@@ -1323,6 +1323,9 @@ struct dvb_frontend *tda18271_attach(struct dvb_frontend *fe, u8 addr,
 	if (tda18271_debug & (DBG_MAP | DBG_ADV))
 		tda18271_dump_std_map(fe);
 
+	ret = tda18271_sleep(fe);
+	tda_fail(ret);
+
 	return fe;
 fail:
 	mutex_unlock(&tda18271_list_mutex);
-- 
1.7.9.5

