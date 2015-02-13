Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49408 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbbBMW6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:58:19 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv4 12/25] [media] dvb_ca_en50221: add support for CA node at the media controller
Date: Fri, 13 Feb 2015 20:57:55 -0200
Message-Id: <ff6b48d612b1130720761ec2f8ac28a05ac86d58.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the dvb core CA support aware of the media controller and
register the corresponding devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 0aac3096728e..2bf28eb97a64 100644
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
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	.name = "ca_en50221",
+#endif
 	.fops = &dvb_ca_fops,
 };
 
-
 /* ******************************************************************************** */
 /* Initialisation/shutdown functions */
 
-- 
2.1.0

