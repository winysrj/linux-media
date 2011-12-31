Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab1LaKXH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 05:23:07 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBVAN6Ug032140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 05:23:06 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] [media] af9015: convert set_fontend to use DVBv5 parameters
Date: Sat, 31 Dec 2011 08:23:00 -0200
Message-Id: <1325326980-27464-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325326980-27464-1-git-send-email-mchehab@redhat.com>
References: <1325326980-27464-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/af9015.c |    5 ++---
 drivers/media/dvb/dvb-usb/af9015.h |    3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 7b606b7..7959053 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1096,8 +1096,7 @@ error:
 }
 
 /* override demod callbacks for resource locking */
-static int af9015_af9013_set_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params)
+static int af9015_af9013_set_frontend(struct dvb_frontend *fe)
 {
 	int ret;
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
@@ -1106,7 +1105,7 @@ static int af9015_af9013_set_frontend(struct dvb_frontend *fe,
 	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
 		return -EAGAIN;
 
-	ret = priv->set_frontend[adap->id](fe, params);
+	ret = priv->set_frontend[adap->id](fe);
 
 	mutex_unlock(&adap->dev->usb_mutex);
 
diff --git a/drivers/media/dvb/dvb-usb/af9015.h b/drivers/media/dvb/dvb-usb/af9015.h
index 4a12617..f619063 100644
--- a/drivers/media/dvb/dvb-usb/af9015.h
+++ b/drivers/media/dvb/dvb-usb/af9015.h
@@ -104,8 +104,7 @@ struct af9015_state {
 	u8 rc_last[4];
 
 	/* for demod callback override */
-	int (*set_frontend[2]) (struct dvb_frontend *fe,
-		struct dvb_frontend_parameters *params);
+	int (*set_frontend[2]) (struct dvb_frontend *fe);
 	int (*read_status[2]) (struct dvb_frontend *fe, fe_status_t *status);
 	int (*init[2]) (struct dvb_frontend *fe);
 	int (*sleep[2]) (struct dvb_frontend *fe);
-- 
1.7.8.352.g876a6

