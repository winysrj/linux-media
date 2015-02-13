Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49477 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbbBMW6W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:58:22 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Joe Perches <joe@perches.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Herrmann <dh.herrmann@gmail.com>,
	Tom Gundersen <teg@jklm.no>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCHv4 13/25] [media] dvb_net: add support for DVB net node at the media controller
Date: Fri, 13 Feb 2015 20:57:56 -0200
Message-Id: <9c7ff55979e714f5ffb23a8a85bc2593d5b9350b.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the dvb core network support aware of the media controller and
register the corresponding devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index 686d3277dad1..40990058b4bc 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -1462,14 +1462,16 @@ static const struct file_operations dvb_net_fops = {
 	.llseek = noop_llseek,
 };
 
-static struct dvb_device dvbdev_net = {
+static const struct dvb_device dvbdev_net = {
 	.priv = NULL,
 	.users = 1,
 	.writers = 1,
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	.name = "dvb net",
+#endif
 	.fops = &dvb_net_fops,
 };
 
-
 void dvb_net_release (struct dvb_net *dvbnet)
 {
 	int i;
-- 
2.1.0

