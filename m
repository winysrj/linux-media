Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab1KTO4b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 09:56:31 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAKEuUP5028808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 20 Nov 2011 09:56:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 4/8] [media] xc5000: Add support for get_if_frequency
Date: Sun, 20 Nov 2011 12:56:14 -0200
Message-Id: <1321800978-27912-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1321800978-27912-3-git-send-email-mchehab@redhat.com>
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
 <1321800978-27912-2-git-send-email-mchehab@redhat.com>
 <1321800978-27912-3-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is needed for devices with DRX-K and xc5000.

Tested with a HVR 930C hardware.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/xc5000.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index 88b329c..ecd1f95 100644
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
1.7.7.1

