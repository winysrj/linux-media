Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30448 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbcBCPeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2016 10:34:10 -0500
Date: Wed, 3 Feb 2016 18:34:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] xc2028: unlock on error in xc2028_set_config()
Message-ID: <20160203153359.GA2884@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We have to unlock before returning -ENOMEM.

Fixes: 8dfbcc4351a0 ('[media] xc2028: avoid use after free')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 082ff56..317ef63 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -1407,8 +1407,10 @@ static int xc2028_set_config(struct dvb_frontend *fe, void *priv_cfg)
 	memcpy(&priv->ctrl, p, sizeof(priv->ctrl));
 	if (p->fname) {
 		priv->ctrl.fname = kstrdup(p->fname, GFP_KERNEL);
-		if (priv->ctrl.fname == NULL)
-			return -ENOMEM;
+		if (priv->ctrl.fname == NULL) {
+			rc = -ENOMEM;
+			goto unlock;
+		}
 	}
 
 	/*
@@ -1440,6 +1442,7 @@ static int xc2028_set_config(struct dvb_frontend *fe, void *priv_cfg)
 		} else
 			priv->state = XC2028_WAITING_FIRMWARE;
 	}
+unlock:
 	mutex_unlock(&priv->lock);
 
 	return rc;
