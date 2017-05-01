Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41288 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932918AbdEAQES (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:04:18 -0400
Subject: [PATCH 08/16] lirc_zilog: remove module parameter minor
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:04:16 +0200
Message-ID: <149365465662.12922.11431772550471554121.stgit@zeus.hardeman.nu>
In-Reply-To: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the "minor" module parameter in preparation for the next patch.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/staging/media/lirc/lirc_zilog.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 8d8fd8b164e2..59e05aa1bc55 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -156,7 +156,6 @@ static struct mutex tx_data_lock;
 /* module parameters */
 static bool debug;	/* debug output */
 static bool tx_only;	/* only handle the IR Tx function */
-static int minor = -1;	/* minor number */
 
 
 /* struct IR reference counting */
@@ -184,10 +183,11 @@ static void release_ir_device(struct kref *ref)
 	 * ir->open_count ==  0 - happens on final close()
 	 * ir_lock, tx_ref_lock, rx_ref_lock, all released
 	 */
-	if (ir->l.minor >= 0 && ir->l.minor < MAX_IRCTL_DEVICES) {
+	if (ir->l.minor >= 0) {
 		lirc_unregister_driver(ir->l.minor);
-		ir->l.minor = MAX_IRCTL_DEVICES;
+		ir->l.minor = -1;
 	}
+
 	if (kfifo_initialized(&ir->rbuf.fifo))
 		lirc_buffer_free(&ir->rbuf);
 	list_del(&ir->list);
@@ -1597,12 +1597,11 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	/* register with lirc */
-	ir->l.minor = minor; /* module option: user requested minor number */
 	ir->l.minor = lirc_register_driver(&ir->l);
-	if (ir->l.minor < 0 || ir->l.minor >= MAX_IRCTL_DEVICES) {
+	if (ir->l.minor < 0) {
 		dev_err(tx->ir->l.dev,
-			"%s: \"minor\" must be between 0 and %d (%d)!\n",
-			__func__, MAX_IRCTL_DEVICES-1, ir->l.minor);
+			"%s: lirc_register_driver() failed: %i\n",
+			__func__, ir->l.minor);
 		ret = -EBADRQC;
 		goto out_put_xx;
 	}
@@ -1673,9 +1672,6 @@ MODULE_LICENSE("GPL");
 /* for compat with old name, which isn't all that accurate anymore */
 MODULE_ALIAS("lirc_pvr150");
 
-module_param(minor, int, 0444);
-MODULE_PARM_DESC(minor, "Preferred minor device number");
-
 module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "Enable debugging messages");
 
