Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:57585 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934463AbdIZL1x (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 07:27:53 -0400
Subject: [PATCH 1/6] [media] tda8261: Use common error handling code in
 tda8261_set_params()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <15d74bee-7467-4687-24e1-3501c22f6d75@users.sourceforge.net>
Message-ID: <28425caf-2736-96ae-00a7-3fb273b1f9d5@users.sourceforge.net>
Date: Tue, 26 Sep 2017 13:27:47 +0200
MIME-Version: 1.0
In-Reply-To: <15d74bee-7467-4687-24e1-3501c22f6d75@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 26 Sep 2017 11:01:44 +0200

* Add a jump target so that a bit of exception handling can be better
  reused at the end of this function.

  This issue was detected by using the Coccinelle software.

* The script "checkpatch.pl" pointed information out like the following.

  ERROR: do not use assignment in if condition

  Thus fix an affected source code place.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/tda8261.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
index 4eb294f330bc..5a8a9b6b8107 100644
--- a/drivers/media/dvb-frontends/tda8261.c
+++ b/drivers/media/dvb-frontends/tda8261.c
@@ -129,18 +129,18 @@ static int tda8261_set_params(struct dvb_frontend *fe)
 
 	/* Set params */
 	err = tda8261_write(state, buf);
-	if (err < 0) {
-		pr_err("%s: I/O Error\n", __func__);
-		return err;
-	}
+	err = tda8261_get_status(fe, &status);
+	if (err < 0)
+		goto report_failure;
+
 	/* sleep for some time */
 	pr_debug("%s: Waiting to Phase LOCK\n", __func__);
 	msleep(20);
 	/* check status */
-	if ((err = tda8261_get_status(fe, &status)) < 0) {
-		pr_err("%s: I/O Error\n", __func__);
-		return err;
-	}
+	err = tda8261_get_status(fe, &status);
+	if (err < 0)
+		goto report_failure;
+
 	if (status == 1) {
 		pr_debug("%s: Tuner Phase locked: status=%d\n", __func__,
 			 status);
@@ -150,6 +150,10 @@ static int tda8261_set_params(struct dvb_frontend *fe)
 	}
 
 	return 0;
+
+report_failure:
+	pr_err("%s: I/O Error\n", __func__);
+	return err;
 }
 
 static void tda8261_release(struct dvb_frontend *fe)
-- 
2.14.1
