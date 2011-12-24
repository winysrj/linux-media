Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216Ab1LXPvF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:05 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp4XK009925
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 06/47] [media] mc44s803: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:11 -0200
Message-Id: <1324741852-26138-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-6-git-send-email-mchehab@redhat.com>
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
 <1324741852-26138-2-git-send-email-mchehab@redhat.com>
 <1324741852-26138-3-git-send-email-mchehab@redhat.com>
 <1324741852-26138-4-git-send-email-mchehab@redhat.com>
 <1324741852-26138-5-git-send-email-mchehab@redhat.com>
 <1324741852-26138-6-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mc44s803.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/tuners/mc44s803.c b/drivers/media/common/tuners/mc44s803.c
index fe5c4b8..5a8758c 100644
--- a/drivers/media/common/tuners/mc44s803.c
+++ b/drivers/media/common/tuners/mc44s803.c
@@ -218,18 +218,19 @@ static int mc44s803_set_params(struct dvb_frontend *fe,
 			       struct dvb_frontend_parameters *params)
 {
 	struct mc44s803_priv *priv = fe->tuner_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 r1, r2, n1, n2, lo1, lo2, freq, val;
 	int err;
 
-	priv->frequency = params->frequency;
+	priv->frequency = c->frequency;
 
 	r1 = MC44S803_OSC / 1000000;
 	r2 = MC44S803_OSC /  100000;
 
-	n1 = (params->frequency + MC44S803_IF1 + 500000) / 1000000;
+	n1 = (c->frequency + MC44S803_IF1 + 500000) / 1000000;
 	freq = MC44S803_OSC / r1 * n1;
 	lo1 = ((60 * n1) + (r1 / 2)) / r1;
-	freq = freq - params->frequency;
+	freq = freq - c->frequency;
 
 	n2 = (freq - MC44S803_IF2 + 50000) / 100000;
 	lo2 = ((60 * n2) + (r2 / 2)) / r2;
-- 
1.7.8.352.g876a6

