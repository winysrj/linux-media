Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44175 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 14/35] [media] dvb_frontend: estimate bandwidth also for DVB-S/S2/Turbo
Date: Tue, 26 Aug 2014 18:54:50 -0300
Message-Id: <1409090111-8290-15-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The needed bandwidth can be estimated using the symbol rate and
the rolloff factor. This could be useful for the frontend drivers,
as they don't need to calculate it themselves.

Reported-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index a5810391af61..c862ad732d9e 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2072,6 +2072,23 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
 	case SYS_DVBC_ANNEX_C:
 		rolloff = 113;
 		break;
+	case SYS_DVBS:
+	case SYS_TURBO:
+		rolloff = 135;
+		break;
+	case SYS_DVBS2:
+		switch (c->rolloff) {
+		case ROLLOFF_20:
+			rolloff = 120;
+			break;
+		case ROLLOFF_25:
+			rolloff = 125;
+			break;
+		default:
+		case ROLLOFF_35:
+			rolloff = 135;
+		}
+		break;
 	default:
 		break;
 	}
-- 
1.9.3

