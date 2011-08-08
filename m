Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dream-property.net ([82.149.226.172]:39133 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab1HHOys (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 10:54:48 -0400
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: user.vdr@gmail.com, alannisota@gmail.com
Subject: [PATCH 3/3] DVB: gp8psk-fe: use SYS_TURBO
Date: Mon,  8 Aug 2011 14:54:37 +0000
Message-Id: <1312815277-9502-3-git-send-email-obi@linuxtv.org>
In-Reply-To: <1312815277-9502-1-git-send-email-obi@linuxtv.org>
References: <1312815277-9502-1-git-send-email-obi@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Allows to select Turbo QPSK (SYS_TURBO + QPSK)

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-usb/gp8psk-fe.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/gp8psk-fe.c b/drivers/media/dvb/dvb-usb/gp8psk-fe.c
index 60d11e5..5426267 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk-fe.c
@@ -144,19 +144,25 @@ static int gp8psk_fe_set_frontend(struct dvb_frontend* fe,
 	cmd[6] = (freq >> 16) & 0xff;
 	cmd[7] = (freq >> 24) & 0xff;
 
+	/* backwards compatibility: DVB-S + 8-PSK were used for Turbo-FEC */
+	if (c->delivery_system == SYS_DVBS && c->modulation == PSK_8)
+		c->delivery_system = SYS_TURBO;
+
 	switch (c->delivery_system) {
 	case SYS_DVBS:
-		/* Allow QPSK and 8PSK (even for DVB-S) */
-		if (c->modulation != QPSK && c->modulation != PSK_8) {
+		if (c->modulation != QPSK) {
 			deb_fe("%s: unsupported modulation selected (%d)\n",
 				__func__, c->modulation);
 			return -EOPNOTSUPP;
 		}
 		c->fec_inner = FEC_AUTO;
 		break;
-	case SYS_DVBS2:
+	case SYS_DVBS2: /* kept for backwards compatibility */
 		deb_fe("%s: DVB-S2 delivery system selected\n", __func__);
 		break;
+	case SYS_TURBO:
+		deb_fe("%s: Turbo-FEC delivery system selected\n", __func__);
+		break;
 
 	default:
 		deb_fe("%s: unsupported delivery system selected (%d)\n",
@@ -189,7 +195,10 @@ static int gp8psk_fe_set_frontend(struct dvb_frontend* fe,
 		default:
 			cmd[9] = 5; break;
 		}
-		cmd[8] = ADV_MOD_DVB_QPSK;
+		if (c->delivery_system == SYS_TURBO)
+			cmd[8] = ADV_MOD_TURBO_QPSK;
+		else
+			cmd[8] = ADV_MOD_DVB_QPSK;
 		break;
 	case PSK_8: /* PSK_8 is for compatibility with DN */
 		cmd[8] = ADV_MOD_TURBO_8PSK;
-- 
1.7.2.5

