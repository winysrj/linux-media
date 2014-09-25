Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25829 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaIYLkh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 07:40:37 -0400
Date: Thu, 25 Sep 2014 14:40:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] xc5000: use after free in release()
Message-ID: <20140925114008.GC3708@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I moved the call to hybrid_tuner_release_state(priv) after
"priv->firmware" dereference.

Fixes: 5264a522a597 ('[media] media: tuner xc5000 - release firmwware from xc5000_release()')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index e44c8ab..803a0e6 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -1333,9 +1333,9 @@ static int xc5000_release(struct dvb_frontend *fe)
 
 	if (priv) {
 		cancel_delayed_work(&priv->timer_sleep);
-		hybrid_tuner_release_state(priv);
 		if (priv->firmware)
 			release_firmware(priv->firmware);
+		hybrid_tuner_release_state(priv);
 	}
 
 	mutex_unlock(&xc5000_list_mutex);
