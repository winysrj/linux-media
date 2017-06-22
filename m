Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33530 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdFVUDc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 16:03:32 -0400
Received: by mail-wr0-f196.google.com with SMTP id x23so7254860wrb.0
        for <linux-media@vger.kernel.org>; Thu, 22 Jun 2017 13:03:31 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, aospan@netup.ru, serjk@netup.ru
Cc: mchehab@kernel.org
Subject: [PATCH] [media] dvb-frontends/cxd2841er: require FE_HAS_SYNC for agc readout
Date: Thu, 22 Jun 2017 22:03:28 +0200
Message-Id: <20170622200328.5387-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

When the demod driver puts the demod into sleep or shutdown state and it's
status is then polled e.g. via "dvb-fe-tool -m", i2c errors are printed
to the kernel log. If the last delsys was DVB-T/T2:

  cxd2841er: i2c wr failed=-5 addr=6c reg=00 len=1
  cxd2841er: i2c rd failed=-5 addr=6c reg=26

and if it was DVB-C:

  cxd2841er: i2c wr failed=-5 addr=6c reg=00 len=1
  cxd2841er: i2c rd failed=-5 addr=6c reg=49

This happens when read_status unconditionally calls into the
read_signal_strength() function which triggers the read_agc_gain_*()
functions, where these registered are polled.

This isn't a critical thing since when the demod is active again, no more
such errors are logged, however this might make users suspecting defects.

Fix this by requiring fe_status FE_HAS_SYNC to be sure the demod is not
put asleep or shut down. If FE_HAS_SYNC isn't set, additionally set the
strength scale to NOT_AVAILABLE.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 08f67d60a7d9..9fff031436f1 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -3279,7 +3279,10 @@ static int cxd2841er_get_frontend(struct dvb_frontend *fe,
 	else if (priv->state == STATE_ACTIVE_TC)
 		cxd2841er_read_status_tc(fe, &status);
 
-	cxd2841er_read_signal_strength(fe);
+	if (status & FE_HAS_SYNC)
+		cxd2841er_read_signal_strength(fe);
+	else
+		p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 
 	if (status & FE_HAS_LOCK) {
 		cxd2841er_read_snr(fe);
-- 
2.13.0
