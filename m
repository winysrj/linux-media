Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50374
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751741AbdITTMC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:12:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 24/25] media: dvb-net.rst: document DVB network kAPI interface
Date: Wed, 20 Sep 2017 16:11:49 -0300
Message-Id: <c23e99c7f281d7b3e0073cf05c40fc6de3e29e31.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That's the last DVB kAPI that misses documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/dtv-core.rst |  1 +
 Documentation/media/kapi/dtv-net.rst  |  4 ++++
 drivers/media/dvb-core/dvb_net.h      | 34 ++++++++++++++++++++++++++++++++--
 3 files changed, 37 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/media/kapi/dtv-net.rst

diff --git a/Documentation/media/kapi/dtv-core.rst b/Documentation/media/kapi/dtv-core.rst
index 8ee384f61fa0..bca743dc6b43 100644
--- a/Documentation/media/kapi/dtv-core.rst
+++ b/Documentation/media/kapi/dtv-core.rst
@@ -34,3 +34,4 @@ I2C bus.
     dtv-frontend
     dtv-demux
     dtv-ca
+    dtv-net
diff --git a/Documentation/media/kapi/dtv-net.rst b/Documentation/media/kapi/dtv-net.rst
new file mode 100644
index 000000000000..ced991b73d69
--- /dev/null
+++ b/Documentation/media/kapi/dtv-net.rst
@@ -0,0 +1,4 @@
+Digital TV Network kABI
+-----------------------
+
+.. kernel-doc:: drivers/media/dvb-core/dvb_net.h
diff --git a/drivers/media/dvb-core/dvb_net.h b/drivers/media/dvb-core/dvb_net.h
index e9b18aa03e02..1eae8bad7cc1 100644
--- a/drivers/media/dvb-core/dvb_net.h
+++ b/drivers/media/dvb-core/dvb_net.h
@@ -30,6 +30,22 @@
 
 #ifdef CONFIG_DVB_NET
 
+/**
+ * struct dvb_net - describes a DVB network interface
+ *
+ * @dvbdev:		pointer to &struct dvb_device.
+ * @device:		array of pointers to &struct net_device.
+ * @state:		array of integers to each net device. A value
+ *			different than zero means that the interface is
+ *			in usage.
+ * @exit:		flag to indicate when the device is being removed.
+ * @demux:		pointer to &struct dmx_demux.
+ * @ioctl_mutex:	protect access to this struct.
+ *
+ * Currently, the core supports up to %DVB_NET_DEVICES_MAX (10) network
+ * devices.
+ */
+
 struct dvb_net {
 	struct dvb_device *dvbdev;
 	struct net_device *device[DVB_NET_DEVICES_MAX];
@@ -39,8 +55,22 @@ struct dvb_net {
 	struct mutex ioctl_mutex;
 };
 
-void dvb_net_release(struct dvb_net *);
-int  dvb_net_init(struct dvb_adapter *, struct dvb_net *, struct dmx_demux *);
+/**
+ * dvb_net_init - nitializes a digital TV network device and registers it.
+ *
+ * @adap:	pointer to &struct dvb_adapter.
+ * @dvbnet:	pointer to &struct dvb_net.
+ * @dmxdemux:	pointer to &struct dmx_demux.
+ */
+int dvb_net_init(struct dvb_adapter *adap, struct dvb_net *dvbnet,
+		  struct dmx_demux *dmxdemux);
+
+/**
+ * dvb_net_release - releases a digital TV network device and unregisters it.
+ *
+ * @dvbnet:	pointer to &struct dvb_net.
+ */
+void dvb_net_release(struct dvb_net *dvbnet);
 
 #else
 
-- 
2.13.5
