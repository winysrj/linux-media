Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:36146 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529AbcHIVls (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 17:41:48 -0400
Subject: [PATCH 02/12] [media] dvbdev: split dvb_unregister_device()
From: Max Kellermann <max.kellermann@gmail.com>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 09 Aug 2016 23:32:11 +0200
Message-ID: <147077833114.21835.9046868208246740006.stgit@woodpecker.blarg.de>
In-Reply-To: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
References: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb_unregister_device() has a major problem: it combines unregistering
with memory disposal.  Sometimes, it is necessary to unregister a
device, but no memory can be freed yet, because a process still has a
(stale) file handle.  Therefore, we need to split
dvb_unregister_device().  This will allow sanitizing a few callers.

With my new design, dvb_unregister_device() appears misnamed, but to
reduce patch noise, I'm not renaming it just yet.

Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
---
 drivers/media/dvb-core/dvbdev.c |   19 ++++++++++++++++++-
 drivers/media/dvb-core/dvbdev.h |   23 +++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 75a3f4b..1bc2dba 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -523,7 +523,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 EXPORT_SYMBOL(dvb_register_device);
 
 
-void dvb_unregister_device(struct dvb_device *dvbdev)
+void dvb_remove_device(struct dvb_device *dvbdev)
 {
 	if (!dvbdev)
 		return;
@@ -537,9 +537,26 @@ void dvb_unregister_device(struct dvb_device *dvbdev)
 	device_destroy(dvb_class, MKDEV(DVB_MAJOR, dvbdev->minor));
 
 	list_del (&dvbdev->list_head);
+}
+EXPORT_SYMBOL(dvb_remove_device);
+
+
+void dvb_free_device(struct dvb_device *dvbdev)
+{
+	if (!dvbdev)
+		return;
+
 	kfree (dvbdev->fops);
 	kfree (dvbdev);
 }
+EXPORT_SYMBOL(dvb_free_device);
+
+
+void dvb_unregister_device(struct dvb_device *dvbdev)
+{
+	dvb_remove_device(dvbdev);
+	dvb_free_device(dvbdev);
+}
 EXPORT_SYMBOL(dvb_unregister_device);
 
 
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index 4aff7bd..576bbd4 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -212,8 +212,31 @@ int dvb_register_device(struct dvb_adapter *adap,
 			int demux_sink_pads);
 
 /**
+ * dvb_remove_device - Remove a registered DVB device
+ *
+ * This does not free memory.  To do that, call dvb_free_device().
+ *
+ * @dvbdev:	pointer to struct dvb_device
+ */
+void dvb_remove_device(struct dvb_device *dvbdev);
+
+/**
+ * dvb_free_device - Free memory occupied by a DVB device.
+ *
+ * Call dvb_unregister_device() before calling this function.
+ *
+ * @dvbdev:	pointer to struct dvb_device
+ */
+void dvb_free_device(struct dvb_device *dvbdev);
+
+/**
  * dvb_unregister_device - Unregisters a DVB device
  *
+ * This is a combination of dvb_remove_device() and dvb_free_device().
+ * Using this function is usually a mistake, and is often an indicator
+ * for a use-after-free bug (when a userspace process keeps a file
+ * handle to a detached device).
+ *
  * @dvbdev:	pointer to struct dvb_device
  */
 void dvb_unregister_device(struct dvb_device *dvbdev);

