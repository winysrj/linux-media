Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:36291 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZKHV26 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 16:28:58 -0500
Date: Sun, 8 Nov 2009 22:28:45 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/4] firedtv: move remote control workqueue handling into rc
 source file
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ce889fb60854a648@s5r6.in-berlin.de>
Message-ID: <tkrat.fb15c3478b505864@s5r6.in-berlin.de>
References: <tkrat.ce889fb60854a648@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Preparation for the port of firedtv to the firewire-core kernel API:
Canceling of the remote control workqueue job is factored into
firedtv-rc.c.  Plus trivial whitespace change.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-1394.c |    5 +++--
 drivers/media/dvb/firewire/firedtv-rc.c   |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-1394.c
===================================================================
--- linux-2.6.31.4.orig/drivers/media/dvb/firewire/firedtv-1394.c
+++ linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-1394.c
@@ -212,6 +212,7 @@ static int node_probe(struct device *dev
 		goto fail;
 
 	avc_register_remote_control(fdtv);
+
 	return 0;
 fail:
 	spin_lock_irq(&node_list_lock);
@@ -220,6 +221,7 @@ fail:
 	fdtv_unregister_rc(fdtv);
 fail_free:
 	kfree(fdtv);
+
 	return err;
 }
 
@@ -233,10 +235,9 @@ static int node_remove(struct device *de
 	list_del(&fdtv->list);
 	spin_unlock_irq(&node_list_lock);
 
-	cancel_work_sync(&fdtv->remote_ctrl_work);
 	fdtv_unregister_rc(fdtv);
-
 	kfree(fdtv);
+
 	return 0;
 }
 
Index: linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-rc.c
===================================================================
--- linux-2.6.31.4.orig/drivers/media/dvb/firewire/firedtv-rc.c
+++ linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-rc.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/workqueue.h>
 
 #include "firedtv.h"
 
@@ -163,6 +164,7 @@ fail:
 
 void fdtv_unregister_rc(struct firedtv *fdtv)
 {
+	cancel_work_sync(&fdtv->remote_ctrl_work);
 	kfree(fdtv->remote_ctrl_dev->keycode);
 	input_unregister_device(fdtv->remote_ctrl_dev);
 }

-- 
Stefan Richter
-=====-==--= =-== -=---
http://arcgraph.de/sr/

