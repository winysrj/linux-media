Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.mail.tnz.yahoo.co.jp ([203.216.226.136]:40176 "HELO
	smtp08.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751612AbZJAFPc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Oct 2009 01:15:32 -0400
Message-ID: <4AC43967.6070108@yahoo.co.jp>
Date: Thu, 01 Oct 2009 14:08:55 +0900
From: Akihiro TSUKADA <tskd2@yahoo.co.jp>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] dvb-usb-friio: return the correct DTV_DELIVERY_SYSTEM
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd2@yahoo.co.jp>

This patch makes the driver return the correct DTV_DELIVERY_SYSTEM.

The driver previously returned SYS_UNDEFINED for DTV_DELIVERY_SYSTEM property,
as it lacked any driver specific S2API support.

Priority: normal

Signed-off-by: Akihiro Tsukada <tskd2@yahoo.co.jp>
---
 friio-fe.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/linux/drivers/media/dvb/dvb-usb/friio-fe.c b/linux/drivers/media/dvb/dvb-usb/friio-fe.c
--- a/linux/drivers/media/dvb/dvb-usb/friio-fe.c
+++ b/linux/drivers/media/dvb/dvb-usb/friio-fe.c
@@ -286,6 +286,27 @@ static int jdvbt90502_get_tune_settings(
 	return 0;
 }
 
+/* filter out un-supported properties to notify users */
+static int jdvbt90502_set_property(struct dvb_frontend *fe,
+				   struct dtv_property *tvp)
+{
+	int r = 0;
+
+	switch (tvp->cmd) {
+	case DTV_DELIVERY_SYSTEM:
+		if (tvp->u.data != SYS_ISDBT)
+			r = -EINVAL;
+		break;
+	case DTV_CLEAR:
+	case DTV_TUNE:
+	case DTV_FREQUENCY:
+		break;
+	default:
+		r = -EINVAL;
+	}
+	return r;
+}
+
 static int jdvbt90502_get_frontend(struct dvb_frontend *fe,
 				   struct dvb_frontend_parameters *p)
 {
@@ -314,6 +335,9 @@ static int jdvbt90502_set_frontend(struc
 
 	deb_fe("%s: Freq:%d\n", __func__, p->frequency);
 
+	/* for recovery from DTV_CLEAN */
+	fe->dtv_property_cache.delivery_system = SYS_ISDBT;
+
 	ret = jdvbt90502_pll_set_freq(state, p->frequency);
 	if (ret) {
 		deb_fe("%s:ret == %d\n", __func__, ret);
@@ -394,6 +418,7 @@ static int jdvbt90502_init(struct dvb_fr
 		if (ret != 1)
 			goto error;
 	}
+	fe->dtv_property_cache.delivery_system = SYS_ISDBT;
 	msleep(100);
 
 	return 0;
@@ -471,6 +496,8 @@ static struct dvb_frontend_ops jdvbt9050
 	.sleep = jdvbt90502_sleep,
 	.write = _jdvbt90502_write,
 
+	.set_property = jdvbt90502_set_property,
+
 	.set_frontend = jdvbt90502_set_frontend,
 	.get_frontend = jdvbt90502_get_frontend,
 	.get_tune_settings = jdvbt90502_get_tune_settings,


--------------------------------------
Yahoo! JAPAN - Internet Security for teenagers and parents.
http://pr.mail.yahoo.co.jp/security/
