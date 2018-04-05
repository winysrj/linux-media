Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:38195 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751979AbeDEKBc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 06:01:32 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 2/2] libdvb5: Fix unused local variable warnings
Date: Thu,  5 Apr 2018 13:00:40 +0300
Message-Id: <1522922440-8622-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1522922440-8622-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1522922440-8622-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some local variables are only needed conditionally depending on available
system support for e.g. pthreads. Put these variables behind same #ifdefs
so that no warnings are produced if these features aren't available.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 lib/libdvbv5/dvb-dev-local.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/libdvbv5/dvb-dev-local.c b/lib/libdvbv5/dvb-dev-local.c
index 7a76d65..7ebf2b6 100644
--- a/lib/libdvbv5/dvb-dev-local.c
+++ b/lib/libdvbv5/dvb-dev-local.c
@@ -296,7 +296,6 @@ static int dvb_local_find(struct dvb_device_priv *dvb,
 	struct udev_enumerate *enumerate;
 	struct udev_list_entry *devices, *dev_list_entry;
 	struct udev_device *dev;
-	int ret;
 
 	/* Free a previous list of devices */
 	if (dvb->d.num_devices)
@@ -346,6 +345,8 @@ static int dvb_local_find(struct dvb_device_priv *dvb,
 	/* Begin monitoring udev events */
 #ifdef HAVE_PTHREAD
 	if (priv->notify_dev_change) {
+		int ret;
+
 		ret = pthread_create(&priv->dev_change_id, NULL,
 				     monitor_device_changes, dvb);
 		if (ret < 0) {
@@ -364,9 +365,9 @@ static int dvb_local_find(struct dvb_device_priv *dvb,
 
 static int dvb_local_stop_monitor(struct dvb_device_priv *dvb)
 {
+#ifdef HAVE_PTHREAD
 	struct dvb_dev_local_priv *priv = dvb->priv;
 
-#ifdef HAVE_PTHREAD
 	if (priv->notify_dev_change) {
 		pthread_cancel(priv->dev_change_id);
 		udev_unref(priv->udev);
-- 
2.7.4
