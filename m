Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51526 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbcBCTuO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2016 14:50:14 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/2] tda1004x: only update the frontend properties if locked
Date: Wed,  3 Feb 2016 17:48:57 -0200
Message-Id: <90ea50b8392841faa19d3c8f3c6dfd096a00928f.1454528618.git.mchehab@osg.samsung.com>
In-Reply-To: <1f4b7b810391d19c5643af01fd5a39ca6b193768.1454528618.git.mchehab@osg.samsung.com>
References: <1f4b7b810391d19c5643af01fd5a39ca6b193768.1454528618.git.mchehab@osg.samsung.com>
In-Reply-To: <1f4b7b810391d19c5643af01fd5a39ca6b193768.1454528618.git.mchehab@osg.samsung.com>
References: <1f4b7b810391d19c5643af01fd5a39ca6b193768.1454528618.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tda1004x was updating the properties cache before locking.
If the device is not locked, the data at the registers are just
random values with no real meaning.

This caused the driver to fail with libdvbv5, as such library
calls GET_PROPERTY from time to time, in order to return the
DVB stats.

Tested with a saa7134 card 78: (ASUSTeK P7131 Dual , vendor PCI ID: 1043:4862:

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/tda1004x.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/dvb-frontends/tda1004x.c b/drivers/media/dvb-frontends/tda1004x.c
index 0e209b56c76c..c6abeb4fba9d 100644
--- a/drivers/media/dvb-frontends/tda1004x.c
+++ b/drivers/media/dvb-frontends/tda1004x.c
@@ -903,9 +903,18 @@ static int tda1004x_get_fe(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *fe_params = &fe->dtv_property_cache;
 	struct tda1004x_state* state = fe->demodulator_priv;
+	int status;
 
 	dprintk("%s\n", __func__);
 
+	status = tda1004x_read_byte(state, TDA1004X_STATUS_CD);
+	if (status == -1)
+		return -EIO;
+
+	/* Only update the properties cache if device is locked */
+	if (!(status & 8))
+		return 0;
+
 	// inversion status
 	fe_params->inversion = INVERSION_OFF;
 	if (tda1004x_read_byte(state, TDA1004X_CONFC1) & 0x20)
-- 
2.5.0


