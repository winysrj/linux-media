Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta-out.inet.fi ([195.156.147.13] helo=jenni2.rokki.sonera.fi)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anssi.hannula@gmail.com>) id 1JzYju-0004OB-3l
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 16:59:30 +0200
Received: from mail.onse.fi (84.250.84.250) by jenni2.rokki.sonera.fi (8.5.014)
	id 482C7F340063FDD8 for linux-dvb@linuxtv.org;
	Fri, 23 May 2008 17:59:22 +0300
Received: from gamma.onse.fi (gamma [10.0.0.7])
	by mail.onse.fi (Postfix) with ESMTP id 2152A3D79799
	for <linux-dvb@linuxtv.org>; Fri, 23 May 2008 17:59:06 +0300 (EEST)
Message-ID: <4836DBC1.5000608@gmail.com>
Date: Fri, 23 May 2008 17:59:13 +0300
From: Anssi Hannula <anssi.hannula@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------050008070707090808070206"
Subject: [linux-dvb] [multiproto patch] add support for using multiproto
 drivers with old api
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------050008070707090808070206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The attached adds support for using multiproto drivers with the old api.

-- 
Anssi Hannula

--------------050008070707090808070206
Content-Type: text/x-patch;
 name="multiproto-support-old-api.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multiproto-support-old-api.diff"

From: Anssi Hannula <anssi.hannula@gmail.com>

multiproto: add support for using multiproto drivers with old api

Allow using multiproto drivers with the old API. Multiproto drivers
will provide one frontend type over the old API. For STB0899 this is
FE_QPSK. olddrv_to_newapi() and newapi_to_olddrv() are renamed to
oldapi_to_newapi() and newapi_to_oldapi(), respectively.

Signed-off-by: Anssi Hannula <anssi.hannula@gmail.com>

---

diff -r 6fdfb2b22241 -r 5dc544760be6 linux/drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Fri May 23 17:17:02 2008 +0300
+++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Fri May 23 17:25:59 2008 +0300
@@ -354,7 +354,7 @@
 	return 0;
 }
 
-int newapi_to_olddrv(struct dvbfe_params *params,
+int newapi_to_oldapi(struct dvbfe_params *params,
 		     struct dvb_frontend_parameters *p,
 		     enum dvbfe_delsys delsys)
 {
@@ -466,7 +466,7 @@
 	return 0;
 }
 
-int olddrv_to_newapi(struct dvb_frontend *fe,
+int oldapi_to_newapi(struct dvb_frontend *fe,
 		     struct dvbfe_params *params,
 		     struct dvb_frontend_parameters *p,
 		     enum fe_type fe_type)
@@ -1649,6 +1649,9 @@
 		memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
 		memcpy(&fetunesettings.parameters, parg, sizeof (struct dvb_frontend_parameters));
 
+		/* Request the search algorithm to search */
+		fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
+
 		/* force auto frequency inversion if requested */
 		if (dvb_force_auto_inversion) {
 			fepriv->parameters.inversion = INVERSION_AUTO;
@@ -1697,6 +1700,27 @@
 		if (dvb_override_tune_delay > 0)
 			fepriv->min_delay = (dvb_override_tune_delay * HZ) / 1000;
 
+		if (oldapi_to_newapi(fe, &fepriv->fe_params, &fepriv->parameters, fe->ops.info.type) == -EINVAL)
+			printk("%s: ERROR !!! Converting Old parameters --> New parameters\n", __func__);
+
+		/* set delivery system to the default old-API one */
+		if (fe->ops.set_delsys) {
+			switch(fe->ops.info.type) {
+			case FE_QPSK:
+				fe->ops.set_delsys(fe, DVBFE_DELSYS_DVBS);
+				fe->ops.set_delsys(fe, DVBFE_DELSYS_DVBS);
+			case FE_QAM:
+				fe->ops.set_delsys(fe, DVBFE_DELSYS_DVBC);
+				break;
+			case FE_OFDM:
+				fe->ops.set_delsys(fe, DVBFE_DELSYS_DVBT);
+				break;
+			case FE_ATSC:
+				fe->ops.set_delsys(fe, DVBFE_DELSYS_ATSC);
+				break;
+			}
+		}
+
 		fepriv->state = FESTATE_RETUNE;
 		dvb_frontend_wakeup(fe);
 		dvb_frontend_add_event(fe, 0);
@@ -1720,6 +1744,13 @@
 		if (fe->ops.get_frontend) {
 			memcpy (parg, &fepriv->parameters, sizeof (struct dvb_frontend_parameters));
 			err = fe->ops.get_frontend(fe, (struct dvb_frontend_parameters*) parg);
+		} else if (fe->ops.get_params) {
+			err = fe->ops.get_params(fe, &fepriv->fe_params);
+			if (!err) {
+				if (newapi_to_oldapi(&fepriv->fe_params, &fepriv->parameters, fepriv->delsys)  == -EINVAL)
+					printk("%s: ERROR !!! Converting New parameters --> Old parameters\n", __func__);
+				memcpy(parg, &fepriv->parameters, sizeof (struct dvb_frontend_parameters));
+			}
 		}
 		break;
 
@@ -1751,7 +1782,7 @@
 		    (delsys & DVBFE_DELSYS_DVBT) ||
 		    (delsys & DVBFE_DELSYS_ATSC)) {
 
-			if (newapi_to_olddrv(&fepriv->fe_params, &fepriv->parameters, fepriv->delsys)  == -EINVAL)
+			if (newapi_to_oldapi(&fepriv->fe_params, &fepriv->parameters, fepriv->delsys)  == -EINVAL)
 				printk("%s: ERROR !!! Converting New parameters --> Old parameters\n", __func__);
 		}
 		/* Request the search algorithm to search	*/
@@ -1841,7 +1872,7 @@
 		} else if (fe->ops.get_frontend) {
 			err = fe->ops.get_frontend(fe, &fepriv->parameters);
 			if (!err) {
-				if (olddrv_to_newapi(fe, &fepriv->fe_params, &fepriv->parameters, fe->ops.info.type) == -EINVAL)
+				if (oldapi_to_newapi(fe, &fepriv->fe_params, &fepriv->parameters, fe->ops.info.type) == -EINVAL)
 					printk("%s: ERROR !!! Converting Old parameters --> New parameters\n", __func__);
 				memcpy(parg, &fepriv->fe_params, sizeof (struct dvbfe_params));
 			}
diff -r 6fdfb2b22241 -r 5dc544760be6 linux/drivers/media/dvb/frontends/stb0899_drv.c
--- a/linux/drivers/media/dvb/frontends/stb0899_drv.c	Fri May 23 17:17:02 2008 +0300
+++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c	Fri May 23 17:25:59 2008 +0300
@@ -2036,6 +2036,7 @@
 
 	.info = {
 		.name			= "STB0899 Multistandard",
+		.type			= FE_QPSK, /* with old API */
 	},
 
 	.release			= stb0899_release,

--------------050008070707090808070206
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------050008070707090808070206--
