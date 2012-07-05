Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab2GEOQg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 10:16:36 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q65EGZhe031831
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 5 Jul 2012 10:16:36 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] [media] tuner-xc2028: Fix signal strength report
Date: Thu,  5 Jul 2012 11:16:31 -0300
Message-Id: <1341497792-6066-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1341497792-6066-1-git-send-email-mchehab@redhat.com>
References: <1341497792-6066-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several bugs at the signal strength algorithm:

	- It is using logical OR, instead of bit OR;
	- It doesn't wait up to 18 ms as it should;
	- the strength range is not ok.

Rework on it, in order to make it work.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/tuner-xc2028.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index 9638a69..42fdf5c 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -903,7 +903,7 @@ static int xc2028_signal(struct dvb_frontend *fe, u16 *strength)
 {
 	struct xc2028_data *priv = fe->tuner_priv;
 	u16                 frq_lock, signal = 0;
-	int                 rc;
+	int                 rc, i;
 
 	tuner_dbg("%s called\n", __func__);
 
@@ -914,21 +914,28 @@ static int xc2028_signal(struct dvb_frontend *fe, u16 *strength)
 	mutex_lock(&priv->lock);
 
 	/* Sync Lock Indicator */
-	rc = xc2028_get_reg(priv, XREG_LOCK, &frq_lock);
-	if (rc < 0)
-		goto ret;
+	for (i = 0; i < 3; i++) {
+		rc = xc2028_get_reg(priv, XREG_LOCK, &frq_lock);
+		if (rc < 0)
+			goto ret;
 
-	/* Frequency is locked */
-	if (frq_lock == 1)
-		signal = 1 << 11;
+		if (frq_lock)
+			break;
+		msleep(6);
+	}
+
+	/* Frequency was not locked */
+	if (frq_lock == 2)
+		goto ret;
 
 	/* Get SNR of the video signal */
 	rc = xc2028_get_reg(priv, XREG_SNR, &signal);
 	if (rc < 0)
 		goto ret;
 
-	/* Use both frq_lock and signal to generate the result */
-	signal = signal || ((signal & 0x07) << 12);
+	/* Signal level is 3 bits only */
+
+	signal = ((1 << 12) - 1) | ((signal & 0x07) << 12);
 
 ret:
 	mutex_unlock(&priv->lock);
-- 
1.7.10.4

