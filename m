Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:42094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab1AOQHa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 11:07:30 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0FG7TeV022301
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 11:07:29 -0500
Received: from pedra (vpn-234-251.phx2.redhat.com [10.3.234.251])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p0FG5PXu001803
	for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 11:07:29 -0500
Date: Sat, 15 Jan 2011 16:04:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/8] [media] tda8290: Turn tda829x on before touching at the
 I2C gate
Message-ID: <20110115160420.0028499c@pedra>
In-Reply-To: <cover.1295114145.git.mchehab@redhat.com>
References: <cover.1295114145.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Kworld SBTVD, tda8295-c1 starts in power off mode. It needs
to be powered, otherwise, the I2C gate control command won't work.

Cc: Michael Krufky <mkrufky@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/tda8290.c b/drivers/media/common/tuners/tda8290.c
index 11ea4e0..419d064 100644
--- a/drivers/media/common/tuners/tda8290.c
+++ b/drivers/media/common/tuners/tda8290.c
@@ -754,11 +754,10 @@ struct dvb_frontend *tda829x_attach(struct dvb_frontend *fe,
 		       sizeof(struct analog_demod_ops));
 	}
 
-	if ((!(cfg) || (TDA829X_PROBE_TUNER == cfg->probe_tuner)) &&
-	    (tda829x_find_tuner(fe) < 0)) {
-		memset(&fe->ops.analog_ops, 0, sizeof(struct analog_demod_ops));
-
-		goto fail;
+	if (!(cfg) || (TDA829X_PROBE_TUNER == cfg->probe_tuner)) {
+		tda8295_power(fe, 1);
+		if (tda829x_find_tuner(fe) < 0)
+			goto fail;
 	}
 
 	switch (priv->ver) {
@@ -803,6 +802,8 @@ struct dvb_frontend *tda829x_attach(struct dvb_frontend *fe,
 	return fe;
 
 fail:
+	memset(&fe->ops.analog_ops, 0, sizeof(struct analog_demod_ops));
+
 	tda829x_release(fe);
 	return NULL;
 }
-- 
1.7.1


