Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm9.bullet.mail.ukl.yahoo.com ([217.146.182.250]:30212 "HELO
	nm9.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754601Ab2DFWon (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Apr 2012 18:44:43 -0400
Message-ID: <4F7F705A.3010507@yahoo.com>
Date: Fri, 06 Apr 2012 23:38:18 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: [PATCH v2] Linux 3.3 DVB userspace ABI broken for xine (FE_SET_FRONTEND)
References: <4F7F4CAF.4010501@yahoo.com>
In-Reply-To: <4F7F4CAF.4010501@yahoo.com>
Content-Type: multipart/mixed;
 boundary="------------010001070809040207090703"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010001070809040207090703
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

I've had a closer look at the commit which caused the regression and it looks 
like there were two places where fepriv->parameters_in was assigned to 
fepriv->parameters_out. So I've updated my patch accordingly.

Cheers,
Chris

Signed-off-by: Chris Rankin <rankincj@yahoo.com>

--------------010001070809040207090703
Content-Type: text/x-patch;
 name="DVB.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="DVB.diff"

--- linux-3.3/drivers/media/dvb/dvb-core/dvb_frontend.c.orig	2012-04-06 20:16:02.000000000 +0100
+++ linux-3.3/drivers/media/dvb/dvb-core/dvb_frontend.c	2012-04-06 23:16:03.000000000 +0100
@@ -143,6 +143,8 @@
 static void dvb_frontend_wakeup(struct dvb_frontend *fe);
 static int dtv_get_frontend(struct dvb_frontend *fe,
 			    struct dvb_frontend_parameters *p_out);
+static int dtv_property_legacy_params_sync(struct dvb_frontend *fe,
+					   struct dvb_frontend_parameters *p);
 
 static bool has_get_frontend(struct dvb_frontend *fe)
 {
@@ -695,6 +697,7 @@
 					fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
 					fepriv->delay = HZ / 2;
 				}
+				dtv_property_legacy_params_sync(fe, &fepriv->parameters_out);
 				fe->ops.read_status(fe, &s);
 				if (s != fepriv->status) {
 					dvb_frontend_add_event(fe, s); /* update event list */
@@ -1831,6 +1834,13 @@
 		return -EINVAL;
 
 	/*
+	 * Initialize output parameters to match the values given by
+	 * the user. FE_SET_FRONTEND triggers an initial frontend event
+	 * with status = 0, which copies output parameters to userspace.
+	 */
+	dtv_property_legacy_params_sync(fe, &fepriv->parameters_out);
+
+	/*
 	 * Be sure that the bandwidth will be filled for all
 	 * non-satellite systems, as tuners need to know what
 	 * low pass/Nyquist half filter should be applied, in

--------------010001070809040207090703--
