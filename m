Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbbAFVJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 16:09:08 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuah.kh@samsung.com>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Ole Ernst <olebowle@gmx.com>
Subject: [PATCHv3 04/20] dvb_frontend: add media controller support for DVB frontend
Date: Tue,  6 Jan 2015 19:08:35 -0200
Message-Id: <53536a78742ee28263ca20539750cc060264bc74.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the dvb core is capable of registering devices via the
media controller, add support for the DVB frontend devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2cf30576bf39..c2c559105f64 100644
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
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		.name = fe->ops.info.name,
+#endif
 		.kernel_ioctl = dvb_frontend_ioctl
 	};
 
-- 
2.1.0

