Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp11.acens.net ([86.109.99.135]:35586 "EHLO smtp.movistar.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932081AbaE2NOQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 09:14:16 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvallo Chehab <m.chehab@samsung.com>
Subject: [PATCH] dvbv5-zap fix option lnb UNIVERSAL
Date: Thu, 29 May 2014 15:07:14 +0200
Message-ID: <1564179.r2h1y4RF0H@jar7.dominio>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix the option lnb UNIVERSAL for dvbv5-zap. Without the patch, the option don't work.

Signed-off-by: Jose Alberto Reguero <jose.alberto.reguero@gmail.com>

diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index 14e8fd9..085bbf2 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -773,7 +773,7 @@ int main(int argc, char **argv)
        parms = dvb_fe_open(args.adapter, args.frontend, args.verbose, args.force_dvbv3);
        if (!parms)
                goto err;
-       if (lnb)
+       if (lnb >= 0)
                parms->lnb = dvb_sat_get_lnb(lnb);
        if (args.sat_number > 0)
                parms->sat_number = args.sat_number % 3;

