Return-path: <linux-media-owner@vger.kernel.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228]:40399 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754855Ab0EFMa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 08:30:27 -0400
Message-ID: <f8f6b7c78cd8469f838fc084573dbe8b.squirrel@webmail.ovh.net>
Date: Thu, 6 May 2010 07:30:25 -0500 (GMT+5)
Subject: [PATCH] dvb_frontend: fix typos in comments and one function
From: "Guillaume Audirac" <guillaume.audirac@webag.fr>
To: linux-media@vger.kernel.org
Reply-To: guillaume.audirac@webag.fr
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Trivial patch for typos.





Signed-off-by: Guillaume Audirac <guillaume.audirac@webag.fr>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c
b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 55ea260..e12a0f9 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -460,7 +460,7 @@ static void dvb_frontend_swzigzag(struct dvb_frontend
*fe)
 	if ((fepriv->state & FESTATE_SEARCHING_FAST) || (fepriv->state &
FESTATE_RETUNE)) {
 		fepriv->delay = fepriv->min_delay;

-		/* peform a tune */
+		/* perform a tune */
 		retval = dvb_frontend_swzigzag_autotune(fe,
 							fepriv->check_wrapped);
 		if (retval < 0) {
@@ -783,7 +783,7 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 	return 0;
 }

-static void dvb_frontend_get_frequeny_limits(struct dvb_frontend *fe,
+static void dvb_frontend_get_frequency_limits(struct dvb_frontend *fe,
 					u32 *freq_min, u32 *freq_max)
 {
 	*freq_min = max(fe->ops.info.frequency_min,
fe->ops.tuner_ops.info.frequency_min);
@@ -807,7 +807,7 @@ static int dvb_frontend_check_parameters(struct
dvb_frontend *fe,
 	u32 freq_max;

 	/* range check: frequency */
-	dvb_frontend_get_frequeny_limits(fe, &freq_min, &freq_max);
+	dvb_frontend_get_frequency_limits(fe, &freq_min, &freq_max);
 	if ((freq_min && parms->frequency < freq_min) ||
 	    (freq_max && parms->frequency > freq_max)) {
 		printk(KERN_WARNING "DVB: adapter %i frontend %i frequency %u out of
range (%u..%u)\n",
@@ -1620,7 +1620,7 @@ static int dvb_frontend_ioctl_legacy(struct inode
*inode, struct file *file,
 	case FE_GET_INFO: {
 		struct dvb_frontend_info* info = parg;
 		memcpy(info, &fe->ops.info, sizeof(struct dvb_frontend_info));
-		dvb_frontend_get_frequeny_limits(fe, &info->frequency_min,
&info->frequency_max);
+		dvb_frontend_get_frequency_limits(fe, &info->frequency_min,
&info->frequency_max);

 		/* Force the CAN_INVERSION_AUTO bit on. If the frontend doesn't
 		 * do it, it is done for it. */
@@ -1719,7 +1719,7 @@ static int dvb_frontend_ioctl_legacy(struct inode
*inode, struct file *file,
 			 * (stv0299 for instance) take longer than 8msec to
 			 * respond to a set_voltage command.  Those switches
 			 * need custom routines to switch properly.  For all
-			 * other frontends, the following shoule work ok.
+			 * other frontends, the following should work ok.
 			 * Dish network legacy switches (as used by Dish500)
 			 * are controlled by sending 9-bit command words
 			 * spaced 8msec apart.
-- 
1.6.3.3


-- 
Guillaume

