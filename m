Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:29136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab0JKPmX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 11:42:23 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9BFgNtA001138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 11:42:23 -0400
Received: from pedra (vpn-225-124.phx2.redhat.com [10.3.225.124])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9BFdDOY032640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 11:42:22 -0400
Date: Mon, 11 Oct 2010 12:37:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] V4L/DVB: Use just one lock for devlist
Message-ID: <20101011123718.0dfb7774@pedra>
In-Reply-To: <cover.1286807828.git.mchehab@redhat.com>
References: <cover.1286807828.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This avoids a race condition

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index f5f8632..02c9c7c 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -657,7 +657,6 @@ void tm6000_add_into_devlist(struct tm6000_core *dev)
  */
 
 static LIST_HEAD(tm6000_extension_devlist);
-static DEFINE_MUTEX(tm6000_extension_devlist_lock);
 
 int tm6000_call_fillbuf(struct tm6000_core *dev, enum tm6000_ops_type type,
 			char *buf, int size)
@@ -681,14 +680,12 @@ int tm6000_register_extension(struct tm6000_ops *ops)
 	struct tm6000_core *dev = NULL;
 
 	mutex_lock(&tm6000_devlist_mutex);
-	mutex_lock(&tm6000_extension_devlist_lock);
 	list_add_tail(&ops->next, &tm6000_extension_devlist);
 	list_for_each_entry(dev, &tm6000_devlist, devlist) {
 		ops->init(dev);
 		printk(KERN_INFO "%s: Initialized (%s) extension\n",
 		       dev->name, ops->name);
 	}
-	mutex_unlock(&tm6000_extension_devlist_lock);
 	mutex_unlock(&tm6000_devlist_mutex);
 	return 0;
 }
@@ -704,10 +701,8 @@ void tm6000_unregister_extension(struct tm6000_ops *ops)
 			ops->fini(dev);
 	}
 
-	mutex_lock(&tm6000_extension_devlist_lock);
 	printk(KERN_INFO "tm6000: Remove (%s) extension\n", ops->name);
 	list_del(&ops->next);
-	mutex_unlock(&tm6000_extension_devlist_lock);
 	mutex_unlock(&tm6000_devlist_mutex);
 }
 EXPORT_SYMBOL(tm6000_unregister_extension);
@@ -716,26 +711,26 @@ void tm6000_init_extension(struct tm6000_core *dev)
 {
 	struct tm6000_ops *ops = NULL;
 
-	mutex_lock(&tm6000_extension_devlist_lock);
+	mutex_lock(&tm6000_devlist_mutex);
 	if (!list_empty(&tm6000_extension_devlist)) {
 		list_for_each_entry(ops, &tm6000_extension_devlist, next) {
 			if (ops->init)
 				ops->init(dev);
 		}
 	}
-	mutex_unlock(&tm6000_extension_devlist_lock);
+	mutex_unlock(&tm6000_devlist_mutex);
 }
 
 void tm6000_close_extension(struct tm6000_core *dev)
 {
 	struct tm6000_ops *ops = NULL;
 
-	mutex_lock(&tm6000_extension_devlist_lock);
+	mutex_lock(&tm6000_devlist_mutex);
 	if (!list_empty(&tm6000_extension_devlist)) {
 		list_for_each_entry(ops, &tm6000_extension_devlist, next) {
 			if (ops->fini)
 				ops->fini(dev);
 		}
 	}
-	mutex_unlock(&tm6000_extension_devlist_lock);
+	mutex_lock(&tm6000_devlist_mutex);
 }
-- 
1.7.1


