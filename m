Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46662 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbbACOtZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Jan 2015 09:49:25 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Tom Gundersen <teg@jklm.no>, Joe Perches <joe@perches.com>
Subject: [PATCHv2 7/9] dvb core: add support for DVB net node at the media controller
Date: Sat,  3 Jan 2015 12:49:09 -0200
Message-Id: <ea949138d270ffe7f176d4667615762d05bea061.1420294938.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420294938.git.mchehab@osg.samsung.com>
References: <cover.1420294938.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420294938.git.mchehab@osg.samsung.com>
References: <cover.1420294938.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the dvb core network support aware of the media controller and
register the corresponding devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index e4041f074909..cbb50da6b35f 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -1498,14 +1498,6 @@ static const struct file_operations dvb_net_fops = {
 	.llseek = noop_llseek,
 };
 
-static struct dvb_device dvbdev_net = {
-	.priv = NULL,
-	.users = 1,
-	.writers = 1,
-	.fops = &dvb_net_fops,
-};
-
-
 void dvb_net_release (struct dvb_net *dvbnet)
 {
 	int i;
@@ -1530,6 +1522,16 @@ int dvb_net_init (struct dvb_adapter *adap, struct dvb_net *dvbnet,
 		  struct dmx_demux *dmx)
 {
 	int i;
+	struct dvb_device dvbdev_net = {
+		.priv = NULL,
+		.users = 1,
+		.writers = 1,
+		.fops = &dvb_net_fops,
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		.mdev = dvbnet->mdev,
+		.name = "dvb net",
+#endif
+	};
 
 	mutex_init(&dvbnet->ioctl_mutex);
 	dvbnet->demux = dmx;
diff --git a/drivers/media/dvb-core/dvb_net.h b/drivers/media/dvb-core/dvb_net.h
index ede78e8c8aa8..7e32e416a67c 100644
--- a/drivers/media/dvb-core/dvb_net.h
+++ b/drivers/media/dvb-core/dvb_net.h
@@ -28,6 +28,8 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 
+#include <media/media-device.h>
+
 #include "dvbdev.h"
 
 #define DVB_NET_DEVICES_MAX 10
@@ -41,6 +43,10 @@ struct dvb_net {
 	unsigned int exit:1;
 	struct dmx_demux *demux;
 	struct mutex ioctl_mutex;
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_device *mdev;
+#endif
 };
 
 void dvb_net_release(struct dvb_net *);
-- 
2.1.0

