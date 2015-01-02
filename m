Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:49643 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbbABN5B (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 08:57:01 -0500
Received: by mail-wi0-f179.google.com with SMTP id ex7so27806432wid.12
        for <linux-media@vger.kernel.org>; Fri, 02 Jan 2015 05:57:00 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/5] lmedm04: add read snr, signal strength and ber call backs
Date: Fri,  2 Jan 2015 13:56:31 +0000
Message-Id: <1420206991-3939-5-git-send-email-tvboxspy@gmail.com>
In-Reply-To: <1420206991-3939-1-git-send-email-tvboxspy@gmail.com>
References: <1420206991-3939-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allows calling the original functions providing the streaming is off.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index a9c7fd0..5de6f7c 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -145,6 +145,10 @@ struct lme2510_state {
 	void *usb_buffer;
 	/* Frontend original calls */
 	int (*fe_read_status)(struct dvb_frontend *, fe_status_t *);
+	int (*fe_read_signal_strength)(struct dvb_frontend *, u16 *);
+	int (*fe_read_snr)(struct dvb_frontend *, u16 *);
+	int (*fe_read_ber)(struct dvb_frontend *, u32 *);
+	int (*fe_read_ucblocks)(struct dvb_frontend *, u32 *);
 	int (*fe_set_voltage)(struct dvb_frontend *, fe_sec_voltage_t);
 	u8 dvb_usb_lme2510_firmware;
 };
@@ -877,6 +881,9 @@ static int dm04_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
 	struct lme2510_state *st = fe_to_priv(fe);
 
+	if (st->fe_read_signal_strength && !st->stream_on)
+		return st->fe_read_signal_strength(fe, strength);
+
 	switch (st->tuner_config) {
 	case TUNER_LG:
 		*strength = 0xff - st->signal_level;
@@ -898,6 +905,9 @@ static int dm04_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct lme2510_state *st = fe_to_priv(fe);
 
+	if (st->fe_read_snr && !st->stream_on)
+		return st->fe_read_snr(fe, snr);
+
 	switch (st->tuner_config) {
 	case TUNER_LG:
 		*snr = 0xff - st->signal_sn;
@@ -917,6 +927,11 @@ static int dm04_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 static int dm04_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
+	struct lme2510_state *st = fe_to_priv(fe);
+
+	if (st->fe_read_ber && !st->stream_on)
+		return st->fe_read_ber(fe, ber);
+
 	*ber = 0;
 
 	return 0;
@@ -924,6 +939,11 @@ static int dm04_read_ber(struct dvb_frontend *fe, u32 *ber)
 
 static int dm04_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
+	struct lme2510_state *st = fe_to_priv(fe);
+
+	if (st->fe_read_ucblocks && !st->stream_on)
+		return st->fe_read_ucblocks(fe, ucblocks);
+
 	*ucblocks = 0;
 
 	return 0;
@@ -1036,6 +1056,10 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 	}
 
 	st->fe_read_status = adap->fe[0]->ops.read_status;
+	st->fe_read_signal_strength = adap->fe[0]->ops.read_signal_strength;
+	st->fe_read_snr = adap->fe[0]->ops.read_snr;
+	st->fe_read_ber = adap->fe[0]->ops.read_ber;
+	st->fe_read_ucblocks = adap->fe[0]->ops.read_ucblocks;
 
 	adap->fe[0]->ops.read_status = dm04_read_status;
 	adap->fe[0]->ops.read_signal_strength = dm04_read_signal_strength;
-- 
2.1.0

