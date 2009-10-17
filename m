Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52957 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbZJQUqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Oct 2009 16:46:49 -0400
Date: Sat, 17 Oct 2009 22:46:25 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firedtv: fix regression: tuning fails due to bogus error
 return
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <4ADA26D0.6010108@s5r6.in-berlin.de>
Message-ID: <tkrat.de5abfc32fa5476d@s5r6.in-berlin.de>
References: <4ADA149E.1070704@s5r6.in-berlin.de>
 <4ADA26D0.6010108@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since 2.6.32(-rc1), DVB core checks the return value of
dvb_frontend_ops.set_frontend.  Now it becomes apparent that firedtv
always returned a bogus value from its set_frontend method.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-avc.c |    7 +++++--
 drivers/media/dvb/firewire/firedtv-fe.c  |    8 +-------
 2 files changed, 6 insertions(+), 9 deletions(-)

Index: linux-2.6.32-rc5/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- linux-2.6.32-rc5.orig/drivers/media/dvb/firewire/firedtv-avc.c
+++ linux-2.6.32-rc5/drivers/media/dvb/firewire/firedtv-avc.c
@@ -573,8 +573,11 @@ int avc_tuner_dsd(struct firedtv *fdtv,
 
 	msleep(500);
 #if 0
-	/* FIXME: */
-	/* u8 *status was an out-parameter of avc_tuner_dsd, unused by caller */
+	/*
+	 * FIXME:
+	 * u8 *status was an out-parameter of avc_tuner_dsd, unused by caller
+	 * Check for AVC_RESPONSE_ACCEPTED here instead?
+	 */
 	if (status)
 		*status = r->operand[2];
 #endif
Index: linux-2.6.32-rc5/drivers/media/dvb/firewire/firedtv-fe.c
===================================================================
--- linux-2.6.32-rc5.orig/drivers/media/dvb/firewire/firedtv-fe.c
+++ linux-2.6.32-rc5/drivers/media/dvb/firewire/firedtv-fe.c
@@ -141,18 +141,12 @@ static int fdtv_read_uncorrected_blocks(
 	return -EOPNOTSUPP;
 }
 
-#define ACCEPTED 0x9
-
 static int fdtv_set_frontend(struct dvb_frontend *fe,
 			     struct dvb_frontend_parameters *params)
 {
 	struct firedtv *fdtv = fe->sec_priv;
 
-	/* FIXME: avc_tuner_dsd never returns ACCEPTED. Check status? */
-	if (avc_tuner_dsd(fdtv, params) != ACCEPTED)
-		return -EINVAL;
-	else
-		return 0; /* not sure of this... */
+	return avc_tuner_dsd(fdtv, params);
 }
 
 static int fdtv_get_frontend(struct dvb_frontend *fe,

-- 
Stefan Richter
-=====-==--= =-=- =---=
http://arcgraph.de/sr/

