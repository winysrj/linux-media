Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:44783 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932136AbdKOKrS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 05:47:18 -0500
Received: by mail-wm0-f48.google.com with SMTP id r68so2067656wmr.3
        for <linux-media@vger.kernel.org>; Wed, 15 Nov 2017 02:47:18 -0800 (PST)
Received: from localhost.localdomain ([62.147.246.169])
        by smtp.gmail.com with ESMTPSA id 90sm2911773wrp.93.2017.11.15.02.47.15
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Nov 2017 02:47:16 -0800 (PST)
From: =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] dvb_dev_get_fd(): return fd of local devices
Date: Wed, 15 Nov 2017 11:47:11 +0100
Message-Id: <20171115104711.5418-1-funman@videolan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes it possible to poll a local device.
Getting the fd is preferrable to adding a dvb_dev_poll() function,
because we can poll several fds together in an event-based program.

This is not implemented for remote devices, as polling a remote fd
does not make sense.
We could instead return the socket to know when to expect messages
from the remote device, but the current implementation in
dvb-dev-remote.c already runs a thread to receive remote messages
as soon as possible.
---

Note, after reading README, I did not bump the library version.

Comments welcome

 lib/include/libdvbv5/dvb-dev.h | 12 ++++++++++++
 lib/libdvbv5/dvb-dev-local.c   |  6 ++++++
 lib/libdvbv5/dvb-dev-priv.h    |  1 +
 lib/libdvbv5/dvb-dev.c         | 11 +++++++++++
 4 files changed, 30 insertions(+)

diff --git a/lib/include/libdvbv5/dvb-dev.h b/lib/include/libdvbv5/dvb-dev.h
index 98bee5e7..55e0f065 100644
--- a/lib/include/libdvbv5/dvb-dev.h
+++ b/lib/include/libdvbv5/dvb-dev.h
@@ -289,6 +289,18 @@ struct dvb_open_descriptor *dvb_dev_open(struct dvb_device *dvb,
  */
 void dvb_dev_close(struct dvb_open_descriptor *open_dev);
 
+/**
+ * @brief returns fd from a local device
+ * This will not work for remote devices.
+ * @ingroup dvb_device
+ *
+ * @param open_dev	Points to the struct dvb_open_descriptor
+ *
+ * @return On success, returns the fd.
+ * Returns -1 on error.
+ */
+int dvb_dev_get_fd(struct dvb_open_descriptor *open_dev);
+
 /**
  * @brief read from a dvb demux or dvr file
  * @ingroup dvb_device
diff --git a/lib/libdvbv5/dvb-dev-local.c b/lib/libdvbv5/dvb-dev-local.c
index b50b61b4..eb2f0775 100644
--- a/lib/libdvbv5/dvb-dev-local.c
+++ b/lib/libdvbv5/dvb-dev-local.c
@@ -775,6 +775,11 @@ static void dvb_dev_local_free(struct dvb_device_priv *dvb)
 	free(priv);
 }
 
+static int dvb_local_get_fd(struct dvb_open_descriptor *open_dev)
+{
+    return open_dev->fd;
+}
+
 /* Initialize for local usage */
 void dvb_dev_local_init(struct dvb_device_priv *dvb)
 {
@@ -788,6 +793,7 @@ void dvb_dev_local_init(struct dvb_device_priv *dvb)
 	ops->stop_monitor = dvb_local_stop_monitor;
 	ops->open = dvb_local_open;
 	ops->close = dvb_local_close;
+	ops->get_fd = dvb_local_get_fd;
 
 	ops->dmx_stop = dvb_local_dmx_stop;
 	ops->set_bufsize = dvb_local_set_bufsize;
diff --git a/lib/libdvbv5/dvb-dev-priv.h b/lib/libdvbv5/dvb-dev-priv.h
index e05fcad2..2e69f766 100644
--- a/lib/libdvbv5/dvb-dev-priv.h
+++ b/lib/libdvbv5/dvb-dev-priv.h
@@ -72,6 +72,7 @@ struct dvb_dev_ops {
 	int (*fe_get_stats)(struct dvb_v5_fe_parms *p);
 
 	void (*free)(struct dvb_device_priv *dvb);
+	int (*get_fd)(struct dvb_open_descriptor *dvb);
 };
 
 struct dvb_device_priv {
diff --git a/lib/libdvbv5/dvb-dev.c b/lib/libdvbv5/dvb-dev.c
index 7e2da1fb..447c9fd5 100644
--- a/lib/libdvbv5/dvb-dev.c
+++ b/lib/libdvbv5/dvb-dev.c
@@ -218,6 +218,17 @@ struct dvb_open_descriptor *dvb_dev_open(struct dvb_device *d,
 	return ops->open(dvb, sysname, flags);
 }
 
+int dvb_dev_get_fd(struct dvb_open_descriptor *open_dev)
+{
+	struct dvb_device_priv *dvb = (void *)open_dev;
+	struct dvb_dev_ops *ops = &dvb->ops;
+
+	if (!ops->get_fd)
+		return -1;
+
+	return ops->get_fd(open_dev);
+}
+
 void dvb_dev_close(struct dvb_open_descriptor *open_dev)
 {
 	struct dvb_device_priv *dvb = open_dev->dvb;
-- 
2.14.1
