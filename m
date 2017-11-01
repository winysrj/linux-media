Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33655 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933419AbdKAVGM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH v2 17/26] media: mxl111sf: improve error handling logic
Date: Wed,  1 Nov 2017 17:05:54 -0400
Message-Id: <86aa3d95b72e7cb6a0ba390fc12fb2cd356b108f.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c:485 mxl111sf_demod_read_signal_strength() error: uninitialized symbol 'modulation'.

The mxl111sf_demod_read_signal_strength() just ignores if something
gets wrong while reading snr or modulation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
index f0ed37da73d4..221cf46b4140 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
@@ -477,10 +477,15 @@ static int mxl111sf_demod_read_signal_strength(struct dvb_frontend *fe,
 {
 	struct mxl111sf_demod_state *state = fe->demodulator_priv;
 	enum fe_modulation modulation;
+	int ret;
 	u16 snr;
 
-	mxl111sf_demod_calc_snr(state, &snr);
-	mxl1x1sf_demod_get_tps_modulation(state, &modulation);
+	ret = mxl111sf_demod_calc_snr(state, &snr);
+	if (ret < 0)
+		return ret;
+	ret = mxl1x1sf_demod_get_tps_modulation(state, &modulation);
+	if (ret < 0)
+		return ret;
 
 	switch (modulation) {
 	case QPSK:
-- 
2.13.6
