Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:22130 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab2GUIdg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jul 2012 04:33:36 -0400
Date: Sat, 21 Jul 2012 11:32:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Gianluca Gennari <gennarone@gmail.com>,
	Thomas Meyer <thomas@m3y3r.de>,
	Miroslav Slugen <thunder.mmm@gmail.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] [media] tuner-xc2028: unlock on error in xc2028_get_afc()
Message-ID: <20120721083259.GB13454@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to do a mutex_unlock(&priv->lock) before returning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index 9e60285..ea0550e 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -978,7 +978,7 @@ static int xc2028_get_afc(struct dvb_frontend *fe, s32 *afc)
 	/* Get AFC */
 	rc = xc2028_get_reg(priv, XREG_FREQ_ERROR, &afc_reg);
 	if (rc < 0)
-		return rc;
+		goto ret;
 
 	*afc = afc_reg * 15625; /* Hz */
 
