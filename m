Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40401 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbbHVR2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:36 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 39/39] [media] dvb_frontend.h: document the struct dvb_frontend
Date: Sat, 22 Aug 2015 14:28:24 -0300
Message-Id: <1534f1a327bf8c9e73588dfcf016900c840a078c.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That struct is used on every DVB Front End driver, as it
contains what's needed to register/use a frontend at the
Kernel.

Document it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 796cc5dca819..97661b2f247a 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -647,6 +647,25 @@ struct dtv_frontend_properties {
 #define DVB_FE_DEVICE_REMOVED   2
 #define DVB_FE_DEVICE_RESUME    3
 
+/**
+ * struct dvb_frontend - Frontend structure to be used on drivers.
+ *
+ * @ops:		embedded struct dvb_frontend_ops
+ * @dvb:		pointer to struct dvb_adapter
+ * @demodulator_priv:	demod private data
+ * @tuner_priv:		tuner private data
+ * @frontend_priv:	frontend private data
+ * @sec_priv:		SEC private data
+ * @analog_demod_priv:	Analog demod private data
+ * @dtv_property_cache:	embedded struct dtv_frontend_properties
+ * @callback:		callback function used on some drivers to call
+ *			either the tuner or the demodulator.
+ * @id:			Frontend ID
+ * @exit:		Used to inform the DVB core that the frontend
+ *			thread should exit (usually, means that the hardware
+ *			got disconnected.
+ */
+
 struct dvb_frontend {
 	struct dvb_frontend_ops ops;
 	struct dvb_adapter *dvb;
-- 
2.4.3

