Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36768 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbdFYKCZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 06:02:25 -0400
Received: by mail-wr0-f194.google.com with SMTP id 77so23584334wrb.3
        for <linux-media@vger.kernel.org>; Sun, 25 Jun 2017 03:02:25 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, aospan@netup.ru, serjk@netup.ru
Cc: mchehab@kernel.org, mchehab@s-opensource.com
Subject: [PATCH] [media] dvb-frontends/cxd2841er: require STATE_ACTIVE_* for agc readout
Date: Sun, 25 Jun 2017 12:02:22 +0200
Message-Id: <20170625100222.3222-1-d.scheller.oss@gmail.com>
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

Fix this by requiring STATE_ACTIVE_* in priv->state. If it isn't in any
active state, additionally set the strength scale to NOT_AVAILABLE.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
V2/follow-up to https://patchwork.linuxtv.org/patch/42061/, changed as
requested. Tested, working fine (ie. no "false" i2c failures).

 drivers/media/dvb-frontends/cxd2841er.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 08f67d60a7d9..12bff778c97f 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -3279,7 +3279,10 @@ static int cxd2841er_get_frontend(struct dvb_frontend *fe,
 	else if (priv->state == STATE_ACTIVE_TC)
 		cxd2841er_read_status_tc(fe, &status);
 
-	cxd2841er_read_signal_strength(fe);
+	if (priv->state == STATE_ACTIVE_TC || priv->state == STATE_ACTIVE_S)
+		cxd2841er_read_signal_strength(fe);
+	else
+		p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 
 	if (status & FE_HAS_LOCK) {
 		cxd2841er_read_snr(fe);
-- 
2.13.0
