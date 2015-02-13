Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49517 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbbBMW6X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:58:23 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuah.kh@samsung.com>,
	Ole Ernst <olebowle@gmx.com>,
	Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCHv4 10/25] [media] dvb_frontend: add media controller support for DVB frontend
Date: Fri, 13 Feb 2015 20:57:53 -0200
Message-Id: <db12df2062e7a2e3635016968ff8a8227d92d32a.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the dvb core is capable of registering devices via the
media controller, add support for the DVB frontend devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2cf30576bf39..2564422278df 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2612,11 +2612,14 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 			  struct dvb_frontend* fe)
 {
 	struct dvb_frontend_private *fepriv;
-	static const struct dvb_device dvbdev_template = {
+	const struct dvb_device dvbdev_template = {
 		.users = ~0,
 		.writers = 1,
 		.readers = (~0)-1,
 		.fops = &dvb_frontend_fops,
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+		.name = fe->ops.info.name,
+#endif
 		.kernel_ioctl = dvb_frontend_ioctl
 	};
 
-- 
2.1.0

