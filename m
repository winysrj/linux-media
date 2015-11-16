Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44951 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbbKPKVY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:24 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/16] [media] dvb_frontend: resume tone and voltage
Date: Mon, 16 Nov 2015 08:21:03 -0200
Message-Id: <7d88845dfa6fafe1f24ab4da7d8f47bc41b7b944.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As SEC tone and voltage could have changed during
suspend(), restore them to their previous values at
resume().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index d764cffb2102..0b52cfc2d53d 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2711,6 +2711,11 @@ int dvb_frontend_resume(struct dvb_frontend *fe)
 	else if (fe->ops.tuner_ops.init)
 		ret = fe->ops.tuner_ops.init(fe);
 
+	if (fe->ops.set_tone && fepriv->tone != -1)
+		fe->ops.set_tone(fe, fepriv->tone);
+	if (fe->ops.set_voltage && fepriv->voltage != -1)
+		fe->ops.set_voltage(fe, fepriv->voltage);
+
 	fe->exit = DVB_FE_NO_EXIT;
 	fepriv->state = FESTATE_RETUNE;
 	dvb_frontend_wakeup(fe);
-- 
2.5.0

