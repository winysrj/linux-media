Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35719 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbaGBPwe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jul 2014 11:52:34 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC 5/9] dib8000: Adjust the dBm measure for Mygica S870
Date: Wed,  2 Jul 2014 12:52:19 -0300
Message-Id: <1404316343-23856-6-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404316343-23856-1-git-send-email-m.chehab@samsung.com>
References: <1404316343-23856-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With Mygica S870, there's a difference of ~10dB to ~13dB when
compared with the current scale.

I suspect that this is because dib8096gp uses a different set of
AGC adjust parameters.

Anyway, better to adjust it, in order to have a more precise measure.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c        | 2 ++
 drivers/media/dvb-frontends/dibx000_common.h | 2 ++
 drivers/media/usb/dvb-usb/dib0700_devices.c  | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 3de8934a5b3d..4ecf1a6181cc 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -4064,6 +4064,8 @@ static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
 	db = interpolate_value(val,
 			       strength_to_db_table,
 			       ARRAY_SIZE(strength_to_db_table)) - 131000;
+	if (state->current_agc)
+		db += state->current_agc->dbm_adjust;
 	c->strength.stat[0].svalue = db;
 
 	/* UCB/BER/CNR measures require lock */
diff --git a/drivers/media/dvb-frontends/dibx000_common.h b/drivers/media/dvb-frontends/dibx000_common.h
index b538e0555c95..76c9b8e9ed44 100644
--- a/drivers/media/dvb-frontends/dibx000_common.h
+++ b/drivers/media/dvb-frontends/dibx000_common.h
@@ -111,6 +111,8 @@ struct dibx000_agc_config {
 		u16 min_thres;
 		u16 max_thres;
 	} split;
+
+	int dbm_adjust;
 };
 
 struct dibx000_bandwidth_config {
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 501947eaacfe..baffa8fe09ef 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -1452,6 +1452,8 @@ static struct dibx000_agc_config dib8090_agc_config[2] = {
 	.beta_exp = 51,
 
 	.perform_agc_softsplit = 0,
+
+	.dbm_adjust = 13000, /* Empirical adjust the Signal strength scale */
 	},
 	{
 	.band_caps = BAND_CBAND,
-- 
1.9.3

