Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40114 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab3AMTbc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 14:31:32 -0500
Date: Sun, 13 Jan 2013 22:31:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Michael Krufky <mkrufky@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [media] tuners/xc5000: fix MODE_AIR in xc5000_set_params()
Message-ID: <20130113193133.GA5907@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a missing break so we use XC_RF_MODE_CABLE instead of
XC_RF_MODE_AIR.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker stuff.  Untested.

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index dc93cf3..d6be1b6 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -785,6 +785,7 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 			return -EINVAL;
 		}
 		priv->rf_mode = XC_RF_MODE_AIR;
+		break;
 	case SYS_DVBC_ANNEX_A:
 	case SYS_DVBC_ANNEX_C:
 		dprintk(1, "%s() QAM modulation\n", __func__);
