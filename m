Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55955 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbcBEQG2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2016 11:06:28 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sergey Kozlov <serjk@netup.ru>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	David Howells <dhowells@redhat.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/6] [media] add media controller support to videobuf2-dvb
Date: Fri,  5 Feb 2016 14:04:55 -0200
Message-Id: <70b13a2f74206c4b7d0a23de1c00bc250051d430.1454688187.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454688187.git.mchehab@osg.samsung.com>
References: <cover.1454688187.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454688187.git.mchehab@osg.samsung.com>
References: <cover.1454688187.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow devices to pass an optional argument to register the DVB
driver at the media controller.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/cx23885/cx23885-dvb.c            |  3 ++-
 drivers/media/pci/cx88/cx88-dvb.c                  |  3 ++-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  4 ++--
 drivers/media/pci/saa7134/saa7134-dvb.c            |  2 +-
 drivers/media/v4l2-core/videobuf2-dvb.c            | 13 +++++++++++--
 include/media/videobuf2-dvb.h                      |  5 +++++
 6 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 80319bb73d94..5131c9f555fb 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -2301,7 +2301,8 @@ static int dvb_register(struct cx23885_tsport *port)
 
 	/* register everything */
 	ret = vb2_dvb_register_bus(&port->frontends, THIS_MODULE, port,
-					&dev->pci->dev, adapter_nr, mfe_shared);
+				   &dev->pci->dev, NULL,
+				   adapter_nr, mfe_shared);
 	if (ret)
 		goto frontend_detach;
 
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index afb20756d7a5..851d2a9caed3 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -1642,7 +1642,8 @@ static int dvb_register(struct cx8802_dev *dev)
 
 	/* register everything */
 	res = vb2_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
-		&dev->pci->dev, adapter_nr, mfe_shared);
+				   &dev->pci->dev, NULL, adapter_nr,
+				   mfe_shared);
 	if (res)
 		goto frontend_detach;
 	return res;
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index c94cecd2aa40..2b667b315913 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -462,8 +462,8 @@ static int netup_unidvb_dvb_init(struct netup_unidvb_dev *ndev,
 	}
 
 	if (vb2_dvb_register_bus(&ndev->frontends[num],
-			THIS_MODULE, NULL,
-			&ndev->pci_dev->dev, adapter_nr, 1)) {
+				 THIS_MODULE, NULL,
+				 &ndev->pci_dev->dev, NULL, adapter_nr, 1)) {
 		dev_dbg(&ndev->pci_dev->dev,
 			"%s(): unable to register DVB bus %d\n",
 			__func__, num);
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index 101ba8729416..ed84f7dea94c 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -1884,7 +1884,7 @@ static int dvb_init(struct saa7134_dev *dev)
 
 	/* register everything else */
 	ret = vb2_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
-					&dev->pci->dev, adapter_nr, 0);
+				   &dev->pci->dev, NULL, adapter_nr, 0);
 
 	/* this sequence is necessary to make the tda1004x load its firmware
 	 * and to enter analog mode of hybrid boards
diff --git a/drivers/media/v4l2-core/videobuf2-dvb.c b/drivers/media/v4l2-core/videobuf2-dvb.c
index d09269846b7e..9f38b4218c0d 100644
--- a/drivers/media/v4l2-core/videobuf2-dvb.c
+++ b/drivers/media/v4l2-core/videobuf2-dvb.c
@@ -77,6 +77,7 @@ static int vb2_dvb_register_adapter(struct vb2_dvb_frontends *fe,
 			  struct module *module,
 			  void *adapter_priv,
 			  struct device *device,
+			  struct media_device *mdev,
 			  char *adapter_name,
 			  short *adapter_nr,
 			  int mfe_shared)
@@ -94,7 +95,10 @@ static int vb2_dvb_register_adapter(struct vb2_dvb_frontends *fe,
 	}
 	fe->adapter.priv = adapter_priv;
 	fe->adapter.mfe_shared = mfe_shared;
-
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	if (mdev)
+		fe->adapter.mdev = mdev;
+#endif
 	return result;
 }
 
@@ -193,6 +197,7 @@ int vb2_dvb_register_bus(struct vb2_dvb_frontends *f,
 			 struct module *module,
 			 void *adapter_priv,
 			 struct device *device,
+			 struct media_device *mdev,
 			 short *adapter_nr,
 			 int mfe_shared)
 {
@@ -207,7 +212,7 @@ int vb2_dvb_register_bus(struct vb2_dvb_frontends *f,
 	}
 
 	/* Bring up the adapter */
-	res = vb2_dvb_register_adapter(f, module, adapter_priv, device,
+	res = vb2_dvb_register_adapter(f, module, adapter_priv, device, mdev,
 		fe->dvb.name, adapter_nr, mfe_shared);
 	if (res < 0) {
 		pr_warn("vb2_dvb_register_adapter failed (errno = %d)\n", res);
@@ -224,7 +229,11 @@ int vb2_dvb_register_bus(struct vb2_dvb_frontends *f,
 				fe->dvb.name, res);
 			goto err;
 		}
+		res = dvb_create_media_graph(&f->adapter, false);
+		if (res < 0)
+			goto err;
 	}
+
 	mutex_unlock(&f->lock);
 	return 0;
 
diff --git a/include/media/videobuf2-dvb.h b/include/media/videobuf2-dvb.h
index 5b64c9eac2c9..87b559024b4a 100644
--- a/include/media/videobuf2-dvb.h
+++ b/include/media/videobuf2-dvb.h
@@ -8,6 +8,10 @@
 #include <dvb_frontend.h>
 
 #include <media/videobuf2-v4l2.h>
+
+/* We don't actually need to include media-device.h here */
+struct media_device;
+
 /*
  * TODO: This header file should be replaced with videobuf2-core.h
  * Currently, vb2_thread is not a stuff of videobuf2-core,
@@ -50,6 +54,7 @@ int vb2_dvb_register_bus(struct vb2_dvb_frontends *f,
 			 struct module *module,
 			 void *adapter_priv,
 			 struct device *device,
+			 struct media_device *mdev,
 			 short *adapter_nr,
 			 int mfe_shared);
 
-- 
2.5.0


