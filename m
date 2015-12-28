Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:65423 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbbL1Qcj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 11:32:39 -0500
Subject: [PATCH 2/2] [media] r820t: Better exception handling in
 generic_set_freq()
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <56816256.70304@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <56816416.2060702@users.sourceforge.net>
Date: Mon, 28 Dec 2015 17:32:22 +0100
MIME-Version: 1.0
In-Reply-To: <56816256.70304@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Dec 2015 17:13:02 +0100

This issue was detected by using the Coccinelle software.

Move the jump label directly before the desired log statement
so that the variable "rc" will not be checked once more
after a function call.
Use the identifier "report_failure" instead of "err".

The error logging is performed in a separate section at the end now.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/r820t.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 6ab35e3..f71642e 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1303,7 +1303,7 @@ static int generic_set_freq(struct dvb_frontend *fe,
 
 	rc = r820t_set_tv_standard(priv, bw, type, std, delsys);
 	if (rc < 0)
-		goto err;
+		goto report_failure;
 
 	if ((type == V4L2_TUNER_ANALOG_TV) && (std == V4L2_STD_SECAM_LC))
 		lo_freq = freq - priv->int_freq;
@@ -1312,23 +1312,21 @@ static int generic_set_freq(struct dvb_frontend *fe,
 
 	rc = r820t_set_mux(priv, lo_freq);
 	if (rc < 0)
-		goto err;
+		goto report_failure;
 
 	rc = r820t_set_pll(priv, type, lo_freq);
 	if (rc < 0 || !priv->has_lock)
-		goto err;
+		goto report_failure;
 
 	rc = r820t_sysfreq_sel(priv, freq, type, std, delsys);
 	if (rc < 0)
-		goto err;
+		goto report_failure;
 
 	tuner_dbg("%s: PLL locked on frequency %d Hz, gain=%d\n",
 		  __func__, freq, r820t_read_gain(priv));
-
-err:
-
-	if (rc < 0)
-		tuner_dbg("%s: failed=%d\n", __func__, rc);
+	return 0;
+report_failure:
+	tuner_dbg("%s: failed=%d\n", __func__, rc);
 	return rc;
 }
 
-- 
2.6.3

