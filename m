Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.20]:3657 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2LOXLl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 18:11:41 -0500
Message-ID: <50CD03A0.602@sfr.fr>
Date: Sun, 16 Dec 2012 00:11:28 +0100
From: Patrice Chotard <patrice.chotard@sfr.fr>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: =?iso-8859-1?b?RnLpZOlyaWM=?= <frederic.mantegazza@gbiloba.org>
Subject: [PATCH 1/2] [media] drxd: allow functional gate control after,
 attach
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, gate control didn't work until drxd_init()
execution. Migrate necessary set of commands in drxd_attach
to allow gate control to be used by tuner which are
accessible through i2c gate.

Reported-by: frederic.mantegazza@gbiloba.org
Signed-off-by: Patrice Chotard <patricechotard@free.fr>
---
 drivers/media/dvb-frontends/drxd_hard.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/dvb-frontends/drxd_hard.c
b/drivers/media/dvb-frontends/drxd_hard.c
index 6d98537..b2ab1e8 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -2978,6 +2978,10 @@ struct dvb_frontend *drxd_attach(const struct
drxd_config *config,
 	       sizeof(struct dvb_frontend_ops));
 	state->frontend.demodulator_priv = state;
 	ConfigureMPEGOutput(state, 0);
+	/* add few initialization to allow gate control */
+	CDRXD(state, state->config.IF ? state->config.IF : 36000000);
+	InitHI(state);
+
 	return &state->frontend;

 error:
-- 
1.7.10.4
