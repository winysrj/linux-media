Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932323Ab2AEBBM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:12 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511C1B016676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:12 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 44/47] [media] mt2063: Add support for get_if_frequency()
Date: Wed,  4 Jan 2012 23:00:55 -0200
Message-Id: <1325725258-27934-45-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

get_if_frequency() is needed, in order to work with DRX-K.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 6f14ee3..98020a9 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -2190,7 +2190,7 @@ static int mt2063_set_params(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int mt2063_get_frequency(struct dvb_frontend *fe, u32 *freq)
+static int mt2063_get_if_frequency(struct dvb_frontend *fe, u32 *freq)
 {
 	struct mt2063_state *state = fe->tuner_priv;
 
@@ -2199,9 +2199,9 @@ static int mt2063_get_frequency(struct dvb_frontend *fe, u32 *freq)
 	if (!state->init)
 		return -ENODEV;
 
-	*freq = state->frequency;
+	*freq = state->reference * 1000;
 
-	dprintk(1, "frequency: %d\n", *freq);
+	dprintk(1, "IF frequency: %d\n", *freq);
 
 	return 0;
 }
@@ -2235,7 +2235,7 @@ static struct dvb_tuner_ops mt2063_ops = {
 	.get_status = mt2063_get_status,
 	.set_analog_params = mt2063_set_analog_params,
 	.set_params    = mt2063_set_params,
-	.get_frequency = mt2063_get_frequency,
+	.get_if_frequency = mt2063_get_if_frequency,
 	.get_bandwidth = mt2063_get_bandwidth,
 	.release = mt2063_release,
 };
-- 
1.7.7.5

