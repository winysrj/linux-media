Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308Ab1LXPvF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:05 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp5Fj017036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 02/47] [media] dvb_core: estimate bw for all non-terrestial systems
Date: Sat, 24 Dec 2011 13:50:07 -0200
Message-Id: <1324741852-26138-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-2-git-send-email-mchehab@redhat.com>
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
 <1324741852-26138-2-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of just estimating the bandwidth for DVB-C annex A/C,
also fill it at the core for ATSC and DVB-C annex B. This
simplifies the logic inside the tuners, as all non-satellite
tuners can just use c->bandwidth_hz for all supported
delivery systems.

It could make sense to latter use it also for satellite
systems, as several DVB-S drivers have their own calculus.
However, on DVB-S2 the bw estimation is a little more complex,
and the existing drivers have some optimized calculus for
bandwidth. So, let's not touch on it for now.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   35 ++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index a25ba3a..8dedff4 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1180,19 +1180,38 @@ static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
 	}
 
 	/*
-	 * On DVB-C, the bandwidth is a function of roll-off and symbol rate.
-	 * The bandwidth is required for DVB-C tuners, in order to avoid
-	 * inter-channel noise. Instead of estimating the minimal required
-	 * bandwidth on every single driver, calculates it here and fills
-	 * it at the cache bandwidth parameter.
+	 * Be sure that the bandwidth will be filled for all
+	 * non-satellite systems, as tuners need to know what
+	 * low pass/Nyquist half filter should be applied, in
+	 * order to avoid inter-channel noise.
+	 *
+	 * ISDB-T and DVB-T/T2 already sets bandwidth.
+	 * ATSC and DVB-C don't set, so, the core should fill it.
+	 *
+	 * On DVB-C Annex A and C, the bandwidth is a function of
+	 * the roll-off and symbol rate. Annex B defines different
+	 * roll-off factors depending on the modulation. Fortunately,
+	 * Annex B is only used with 6MHz, so there's no need to
+	 * calculate it.
+	 *
 	 * While not officially supported, a side effect of handling it at
 	 * the cache level is that a program could retrieve the bandwidth
-	 * via DTV_BANDWIDTH_HZ, wich may be useful for test programs.
+	 * via DTV_BANDWIDTH_HZ, which may be useful for test programs.
 	 */
-	if (c->delivery_system == SYS_DVBC_ANNEX_A)
+	switch (c->delivery_system) {
+	case SYS_ATSC:
+	case SYS_DVBC_ANNEX_B:
+		c->bandwidth_hz = 6000000;
+		break;
+	case SYS_DVBC_ANNEX_A:
 		rolloff = 115;
-	if (c->delivery_system == SYS_DVBC_ANNEX_C)
+		break;
+	case SYS_DVBC_ANNEX_C:
 		rolloff = 113;
+		break;
+	default:
+		break;
+	}
 	if (rolloff)
 		c->bandwidth_hz = (c->symbol_rate * rolloff) / 100;
 }
-- 
1.7.8.352.g876a6

