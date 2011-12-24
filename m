Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236Ab1LXPvF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:05 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp5C9018661
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 01/47] [media] dvb: replace SYS_DVBC_ANNEX_AC by the right delsys
Date: Sat, 24 Dec 2011 13:50:06 -0200
Message-Id: <1324741852-26138-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SYS_DVBC_ANNEX_AC is an alias for SYS_DVBC_ANNEX_A. However,
the first one is incorrect, as not all devices support both.
So, replace its occurrences by the proper value (either
SYS_DVBC_ANNEX_A or both SYS_DVBC_ANNEX_A and SYS_DVBC_ANNEX_C).

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/tda18212.c    |    3 ++-
 drivers/media/dvb/dvb-core/dvb_frontend.c |    2 +-
 drivers/media/dvb/frontends/cxd2820r_c.c  |    4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/tuners/tda18212.c b/drivers/media/common/tuners/tda18212.c
index f52282e..a58c74f 100644
--- a/drivers/media/common/tuners/tda18212.c
+++ b/drivers/media/common/tuners/tda18212.c
@@ -203,7 +203,8 @@ static int tda18212_set_params(struct dvb_frontend *fe,
 			goto error;
 		}
 		break;
-	case SYS_DVBC_ANNEX_AC:
+	case SYS_DVBC_ANNEX_A:
+	case SYS_DVBC_ANNEX_C:
 		if_khz = priv->cfg->if_dvbc;
 		i = DVBC_8;
 		break;
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 66537b1..a25ba3a 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1242,7 +1242,7 @@ static void dtv_set_default_delivery_caps(const struct dvb_frontend *fe, struct
 			p->u.buffer.data[ncaps++] = SYS_TURBO;
 		break;
 	case FE_QAM:
-		p->u.buffer.data[ncaps++] = SYS_DVBC_ANNEX_AC;
+		p->u.buffer.data[ncaps++] = SYS_DVBC_ANNEX_A;
 		break;
 	case FE_OFDM:
 		p->u.buffer.data[ncaps++] = SYS_DVBT;
diff --git a/drivers/media/dvb/frontends/cxd2820r_c.c b/drivers/media/dvb/frontends/cxd2820r_c.c
index c412877..7016e27 100644
--- a/drivers/media/dvb/frontends/cxd2820r_c.c
+++ b/drivers/media/dvb/frontends/cxd2820r_c.c
@@ -59,7 +59,7 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe,
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe, params);
 
-	if (priv->delivery_system !=  SYS_DVBC_ANNEX_AC) {
+	if (priv->delivery_system !=  SYS_DVBC_ANNEX_A) {
 		for (i = 0; i < ARRAY_SIZE(tab); i++) {
 			ret = cxd2820r_wr_reg_mask(priv, tab[i].reg,
 				tab[i].val, tab[i].mask);
@@ -68,7 +68,7 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe,
 		}
 	}
 
-	priv->delivery_system = SYS_DVBC_ANNEX_AC;
+	priv->delivery_system = SYS_DVBC_ANNEX_A;
 	priv->ber_running = 0; /* tune stops BER counter */
 
 	/* program IF frequency */
-- 
1.7.8.352.g876a6

