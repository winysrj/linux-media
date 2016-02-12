Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34844 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbcBLJqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 04:46:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Antti Palosaari <crope@iki.fi>,
	Matthias Schwarzott <zzam@gentoo.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 11/11] [media] cx231xx: create connectors at the media graph
Date: Fri, 12 Feb 2016 07:45:06 -0200
Message-Id: <510c5078b375612e9439fa09a9c189763510b49f.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to add connectors to the cx231xx graph.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c |  3 ++
 drivers/media/usb/cx231xx/cx231xx-dvb.c   |  4 ++-
 drivers/media/usb/cx231xx/cx231xx-video.c | 46 +++++++++++++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx.h       |  3 ++
 4 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 0b8b5011f80e..be713f9378a4 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1684,6 +1684,9 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	/* load other modules required */
 	request_modules(dev);
 
+	/* Init entities at the Media Controller */
+	cx231xx_v4l2_create_entities(dev);
+
 	retval = v4l2_mc_create_media_graph(dev->media_dev);
 	if (retval < 0)
 		goto done;
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 1eeddfc79829..0e85c8324427 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -25,6 +25,7 @@
 
 #include <media/v4l2-common.h>
 #include <media/videobuf-vmalloc.h>
+#include <media/tuner.h>
 
 #include "xc5000.h"
 #include "s5h1432.h"
@@ -551,7 +552,8 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 
 	/* register network adapter */
 	dvb_net_init(&dvb->adapter, &dvb->net, &dvb->demux.dmx);
-	result = dvb_create_media_graph(&dvb->adapter, false);
+	result = dvb_create_media_graph(&dvb->adapter,
+					dev->tuner_type == TUNER_ABSENT);
 	if (result < 0)
 		goto fail_create_graph;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 9b88cd8127ac..7222b1c27d40 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1106,6 +1106,52 @@ static const char *iname[] = {
 	[CX231XX_VMUX_DEBUG]      = "for debug only",
 };
 
+void cx231xx_v4l2_create_entities(struct cx231xx *dev)
+{
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	int ret, i;
+
+	/* Create entities for each input connector */
+	for (i = 0; i < MAX_CX231XX_INPUT; i++) {
+		struct media_entity *ent = &dev->input_ent[i];
+
+		if (!INPUT(i)->type)
+			break;
+
+		ent->name = iname[INPUT(i)->type];
+		ent->flags = MEDIA_ENT_FL_CONNECTOR;
+		dev->input_pad[i].flags = MEDIA_PAD_FL_SOURCE;
+
+		switch (INPUT(i)->type) {
+		case CX231XX_VMUX_COMPOSITE1:
+			ent->function = MEDIA_ENT_F_CONN_COMPOSITE;
+			break;
+		case CX231XX_VMUX_SVIDEO:
+			ent->function = MEDIA_ENT_F_CONN_SVIDEO;
+			break;
+		case CX231XX_VMUX_TELEVISION:
+		case CX231XX_VMUX_CABLE:
+		case CX231XX_VMUX_DVB:
+			/* The DVB core will handle it */
+			if (dev->tuner_type == TUNER_ABSENT)
+				continue;
+			/* fall though */
+		default: /* CX231XX_VMUX_DEBUG */
+			ent->function = MEDIA_ENT_F_CONN_RF;
+			break;
+		}
+
+		ret = media_entity_pads_init(ent, 1, &dev->input_pad[i]);
+		if (ret < 0)
+			pr_err("failed to initialize input pad[%d]!\n", i);
+
+		ret = media_device_register_entity(dev->media_dev, ent);
+		if (ret < 0)
+			pr_err("failed to register input entity %d!\n", i);
+	}
+#endif
+}
+
 int cx231xx_enum_input(struct file *file, void *priv,
 			     struct v4l2_input *i)
 {
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index ec6d3f5bc36d..60e14776a6cd 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -663,6 +663,8 @@ struct cx231xx {
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	struct media_device *media_dev;
 	struct media_pad video_pad, vbi_pad;
+	struct media_entity input_ent[MAX_CX231XX_INPUT];
+	struct media_pad input_pad[MAX_CX231XX_INPUT];
 #endif
 
 	unsigned char eedata[256];
@@ -943,6 +945,7 @@ int cx231xx_register_extension(struct cx231xx_ops *dev);
 void cx231xx_unregister_extension(struct cx231xx_ops *dev);
 void cx231xx_init_extension(struct cx231xx *dev);
 void cx231xx_close_extension(struct cx231xx *dev);
+void cx231xx_v4l2_create_entities(struct cx231xx *dev);
 int cx231xx_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap);
 int cx231xx_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t);
-- 
2.5.0


