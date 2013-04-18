Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41595 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3DRTV0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 15:21:26 -0400
Date: Thu, 18 Apr 2013 22:21:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] [media] r820t: memory leak in release()
Message-ID: <20130418192117.GB17798@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've moved the kfree(fe->tuner_priv) one line earlier, otherwise it is
a no-op.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This is a static checker fix and I have not tested it.

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index ba033fd..36ddbf1 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -2252,9 +2252,8 @@ static int r820t_release(struct dvb_frontend *fe)
 
 	mutex_unlock(&r820t_list_mutex);
 
-	fe->tuner_priv = NULL;
-
 	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
 
 	return 0;
 }
