Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:56320 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbcFOUY0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 16:24:26 -0400
Subject: [PATCH 1/3] drivers/media/dvb-core/en50221: use kref to manage
 struct dvb_ca_private
From: Max Kellermann <max@duempel.org>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Wed, 15 Jun 2016 22:15:02 +0200
Message-ID: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't free the object until the file handle has been closed.  Fixes
use-after-free bug which occurs when I disconnect my DVB-S received
while VDR is running.

Signed-off-by: Max Kellermann <max@duempel.org>
---
 drivers/media/dvb-core/dvb_ca_en50221.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index b1e3a26..b5b5b19 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -123,6 +123,7 @@ struct dvb_ca_slot {
 
 /* Private CA-interface information */
 struct dvb_ca_private {
+	struct kref refcount;
 
 	/* pointer back to the public data structure */
 	struct dvb_ca_en50221 *pub;
@@ -173,6 +174,22 @@ static void dvb_ca_private_free(struct dvb_ca_private *ca)
 	kfree(ca);
 }
 
+static void dvb_ca_private_release(struct kref *ref)
+{
+	struct dvb_ca_private *ca = container_of(ref, struct dvb_ca_private, refcount);
+	dvb_ca_private_free(ca);
+}
+
+static void dvb_ca_private_get(struct dvb_ca_private *ca)
+{
+	kref_get(&ca->refcount);
+}
+
+static void dvb_ca_private_put(struct dvb_ca_private *ca)
+{
+	kref_put(&ca->refcount, dvb_ca_private_release);
+}
+
 static void dvb_ca_en50221_thread_wakeup(struct dvb_ca_private *ca);
 static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * ebuf, int ecount);
 static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * ebuf, int ecount);
@@ -1570,6 +1587,8 @@ static int dvb_ca_en50221_io_open(struct inode *inode, struct file *file)
 	dvb_ca_en50221_thread_update_delay(ca);
 	dvb_ca_en50221_thread_wakeup(ca);
 
+	dvb_ca_private_get(ca);
+
 	return 0;
 }
 
@@ -1598,6 +1617,8 @@ static int dvb_ca_en50221_io_release(struct inode *inode, struct file *file)
 
 	module_put(ca->pub->owner);
 
+	dvb_ca_private_put(ca);
+
 	return err;
 }
 
@@ -1693,6 +1714,7 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 		ret = -ENOMEM;
 		goto exit;
 	}
+	kref_init(&ca->refcount);
 	ca->pub = pubca;
 	ca->flags = flags;
 	ca->slot_count = slot_count;
@@ -1772,6 +1794,6 @@ void dvb_ca_en50221_release(struct dvb_ca_en50221 *pubca)
 	for (i = 0; i < ca->slot_count; i++) {
 		dvb_ca_en50221_slot_shutdown(ca, i);
 	}
-	dvb_ca_private_free(ca);
+	dvb_ca_private_put(ca);
 	pubca->private = NULL;
 }

