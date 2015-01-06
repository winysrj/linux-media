Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801AbbAFVJP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 16:09:15 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	David Herrmann <dh.herrmann@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Joe Perches <joe@perches.com>, Tom Gundersen <teg@jklm.no>
Subject: [PATCHv3 07/20] dvb_net: add support for DVB net node at the media controller
Date: Tue,  6 Jan 2015 19:08:38 -0200
Message-Id: <5a048e2c562f1c9ee0435e2379d19360fa7b2e83.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the dvb core network support aware of the media controller and
register the corresponding devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index e4041f074909..bd3c2be80216 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -1498,14 +1498,16 @@ static const struct file_operations dvb_net_fops = {
 	.llseek = noop_llseek,
 };
 
-static struct dvb_device dvbdev_net = {
+static const struct dvb_device dvbdev_net = {
 	.priv = NULL,
 	.users = 1,
 	.writers = 1,
+#if defined(CONFIG_MEDIA_CONTROLLER)
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

