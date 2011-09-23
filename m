Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab1IWRD5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 13:03:57 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: eddi@depieri.net
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] [v2] xc5000: Add support for get_if_frequency
Date: Fri, 23 Sep 2011 14:03:42 -0300
Message-Id: <1316797422-23132-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1316797055-22749-1-git-send-email-mchehab@redhat.com>
References: <1316797055-22749-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is needed for devices with DRX-K and xc5000.

Compiled-test only. Please test with a HVR 930C hardware.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---

v2: Frequency should be in Hz
---
 drivers/media/common/tuners/xc5000.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index aa1b2e8..e3e4fb7 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -968,6 +968,14 @@ static int xc5000_get_frequency(struct dvb_frontend *fe, u32 *freq)
 	return 0;
 }
 
+static int xc5000_get_if_frequency(struct dvb_frontend *fe, u32 *freq)
+{
+	struct xc5000_priv *priv = fe->tuner_priv;
+	dprintk(1, "%s()\n", __func__);
+	*freq = priv->if_khz * 1000;
+	return 0;
+}
+
 static int xc5000_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
@@ -1108,6 +1116,7 @@ static const struct dvb_tuner_ops xc5000_tuner_ops = {
 	.set_params	   = xc5000_set_params,
 	.set_analog_params = xc5000_set_analog_params,
 	.get_frequency	   = xc5000_get_frequency,
+	.get_if_frequency  = xc5000_get_if_frequency,
 	.get_bandwidth	   = xc5000_get_bandwidth,
 	.get_status	   = xc5000_get_status
 };
-- 
1.7.6.2

