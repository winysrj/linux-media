Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58437 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab2AOTIi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 14:08:38 -0500
Received: from dyn3-82-128-184-189.psoas.suomi.net ([82.128.184.189] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1RmVRO-0000Gg-PU
	for linux-media@vger.kernel.org; Sun, 15 Jan 2012 21:08:30 +0200
Message-ID: <4F13242E.70007@iki.fi>
Date: Sun, 15 Jan 2012 21:08:30 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH FOR 3.3] cxd2820r: do not switch to DVB-T when DVB-C fails
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix another bug	introduced by recent multi-frontend to single-frontend 
change.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
  drivers/media/dvb/frontends/cxd2820r_core.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c 
b/drivers/media/dvb/frontends/cxd2820r_core.c
index 93e1b12..b789a90 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -476,10 +476,10 @@ static enum dvbfe_search cxd2820r_search(struct 
dvb_frontend *fe)
  	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);

  	/* switch between DVB-T and DVB-T2 when tune fails */
-	if (priv->last_tune_failed && (priv->delivery_system != 
SYS_DVBC_ANNEX_A)) {
+	if (priv->last_tune_failed) {
  		if (priv->delivery_system == SYS_DVBT)
  			c->delivery_system = SYS_DVBT2;
-		else
+		else if (priv->delivery_system == SYS_DVBT2)
  			c->delivery_system = SYS_DVBT;
  	}

-- 
1.7.4.4
