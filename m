Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58533 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200AbaBAUog (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Feb 2014 15:44:36 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Robert Schlabbach <Robert.Schlabbach@gmx.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/4] m88ds3103: possible uninitialized scalar variable
Date: Sat,  1 Feb 2014 22:44:17 +0200
Message-Id: <1391287458-11939-3-git-send-email-crope@iki.fi>
In-Reply-To: <1391287458-11939-1-git-send-email-crope@iki.fi>
References: <1391287458-11939-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It was possible that tuner_frequency variable, used for carrier offset
compensation, was uninitialized. That happens when tuner
.get_frequency() callback is not defined.

Currently that case is not possible as only used tuner has this callback.

Coverity CID 1166057: Uninitialized scalar variable (UNINIT)

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index c0a78d9..b8f8df0 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -271,6 +271,13 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		ret = fe->ops.tuner_ops.get_frequency(fe, &tuner_frequency);
 		if (ret)
 			goto err;
+	} else {
+		/*
+		 * Use nominal target frequency as tuner driver does not provide
+		 * actual frequency used. Carrier offset calculation is not
+		 * valid.
+		 */
+		tuner_frequency = c->frequency;
 	}
 
 	/* reset */
-- 
1.8.5.3

