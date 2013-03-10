Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55353 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab3CJCEk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:40 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 17/41] it913x: tuner power up routines
Date: Sun, 10 Mar 2013 04:03:09 +0200
Message-Id: <1362881013-5271-17-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Copy forgotten power up registers from it913x-fe driver.
Remove two demod registers as those are already written
by af9033 driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 82cc053..de20da1 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -192,11 +192,9 @@ static int it913x_init(struct dvb_frontend *fe)
 
 	if (state->config->chip_ver == 2) {
 		ret = it913x_wr_reg(state, PRO_DMOD, TRIGGER_OFSM, 0x1);
-		ret |= it913x_wr_reg(state, PRO_LINK, PADODPU, 0x0);
-		ret |= it913x_wr_reg(state, PRO_LINK, AGC_O_D, 0x0);
+		if (ret < 0)
+			return -ENODEV;
 	}
-	if (ret < 0)
-		return -ENODEV;
 
 	reg = it913x_rd_reg(state, 0xec86);
 	switch (reg) {
@@ -252,6 +250,12 @@ static int it913x_init(struct dvb_frontend *fe)
 		}
 	}
 
+	/* Power Up Tuner - common all versions */
+	ret = it913x_wr_reg(state, PRO_DMOD, 0xec40, 0x1);
+	ret |= it913x_wr_reg(state, PRO_DMOD, 0xfba8, 0x0);
+	ret |= it913x_wr_reg(state, PRO_DMOD, 0xec57, 0x0);
+	ret |= it913x_wr_reg(state, PRO_DMOD, 0xec58, 0x0);
+
 	return it913x_wr_reg(state, PRO_DMOD, 0xed81, val);
 }
 
-- 
1.7.11.7

