Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54996 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792AbbAFVJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 16:09:08 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv3 06/20] dvb_ca_en50221: add support for CA node at the media controller
Date: Tue,  6 Jan 2015 19:08:37 -0200
Message-Id: <b82f4e25317c4ecfa1dee7e6b93c7f0d7e06a286.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the dvb core CA support aware of the media controller and
register the corresponding devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 0aac3096728e..22258e15baa9 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1638,15 +1638,17 @@ static const struct file_operations dvb_ca_fops = {
 	.llseek = noop_llseek,
 };
 
-static struct dvb_device dvbdev_ca = {
+static const struct dvb_device dvbdev_ca = {
 	.priv = NULL,
 	.users = 1,
 	.readers = 1,
 	.writers = 1,
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	.name = "ca_en50221",
+#endif
 	.fops = &dvb_ca_fops,
 };
 
-
 /* ******************************************************************************** */
 /* Initialisation/shutdown functions */
 
-- 
2.1.0

