Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dream-property.net ([82.149.226.172]:39128 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1HHOyr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 10:54:47 -0400
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: user.vdr@gmail.com, alannisota@gmail.com
Subject: [PATCH 2/3] DVB: dvb_frontend: Fix compatibility criteria for satellite receivers
Date: Mon,  8 Aug 2011 14:54:36 +0000
Message-Id: <1312815277-9502-2-git-send-email-obi@linuxtv.org>
In-Reply-To: <1312815277-9502-1-git-send-email-obi@linuxtv.org>
References: <1312815277-9502-1-git-send-email-obi@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- When converting satellite receiver parameters from S2API to legacy,
  identify a satellite receiver by its 'delivery_system' instead of
  'modulation', which may overlap between different delivery systems.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index d02c32e..d218fe2 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1132,16 +1132,13 @@ static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
 	p->frequency = c->frequency;
 	p->inversion = c->inversion;
 
-	switch(c->modulation) {
-	case PSK_8:
-	case APSK_16:
-	case APSK_32:
-	case QPSK:
+	if (c->delivery_system == SYS_DSS ||
+	    c->delivery_system == SYS_DVBS ||
+	    c->delivery_system == SYS_DVBS2 ||
+	    c->delivery_system == SYS_ISDBS ||
+	    c->delivery_system == SYS_TURBO) {
 		p->u.qpsk.symbol_rate = c->symbol_rate;
 		p->u.qpsk.fec_inner = c->fec_inner;
-		break;
-	default:
-		break;
 	}
 
 	/* Fake out a generic DVB-T request so we pass validation in the ioctl */
-- 
1.7.2.5

