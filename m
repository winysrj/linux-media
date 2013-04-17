Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab3DQAms (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:48 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0gmuE031237
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:48 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 10/31] [media] r820t: use the right IF for the selected TV standard
Date: Tue, 16 Apr 2013 21:42:21 -0300
Message-Id: <1366159362-3773-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

IF is set at r820t_set_tv_standard(). So, we can't calculate
LO frequency before calling it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 2ecf1d2..48ff6bb 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1193,15 +1193,15 @@ static int generic_set_freq(struct dvb_frontend *fe,
 	tuner_dbg("should set frequency to %d kHz, bw %d MHz\n",
 		  freq / 1000, bw);
 
+	rc = r820t_set_tv_standard(priv, bw, type, std, delsys);
+	if (rc < 0)
+		goto err;
+
 	if ((type == V4L2_TUNER_ANALOG_TV) && (std == V4L2_STD_SECAM_LC))
 		lo_freq = freq - priv->int_freq;
 	 else
 		lo_freq = freq + priv->int_freq;
 
-	rc = r820t_set_tv_standard(priv, bw, type, std, delsys);
-	if (rc < 0)
-		goto err;
-
 	rc = r820t_set_mux(priv, lo_freq);
 	if (rc < 0)
 		goto err;
-- 
1.8.1.4

