Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53641 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488AbZLZAr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Dec 2009 19:47:26 -0500
Date: Sat, 26 Dec 2009 01:47:12 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH v4l/dvb] firedtv: add missing NULL pointer check
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <tkrat.4fbf5b89c63dc096@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If there is ever going to be a FireDTV or FloppyDTV firmware which does
not provide a minimal ASCII textual descriptor for Model_Id --- or if
the descriptor is provided indirectly in a descriptor directory ---
the ieee1394 variant of the device probe of firedtv would dereference a
NULL pointer.  The firewire variant of firedtv's device probe is not
affected.

The fix makes sure that such an unexpected firmware is safely recognized
by fdtv_alloc as an unknown firmware.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-1394.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6.33-rc2/drivers/media/dvb/firewire/firedtv-1394.c
===================================================================
--- linux-2.6.33-rc2.orig/drivers/media/dvb/firewire/firedtv-1394.c
+++ linux-2.6.33-rc2/drivers/media/dvb/firewire/firedtv-1394.c
@@ -193,9 +193,13 @@ static int node_probe(struct device *dev
 	int kv_len, err;
 	void *kv_str;
 
-	kv_len = (ud->model_name_kv->value.leaf.len - 2) * sizeof(quadlet_t);
-	kv_str = CSR1212_TEXTUAL_DESCRIPTOR_LEAF_DATA(ud->model_name_kv);
-
+	if (ud->model_name_kv) {
+		kv_len = (ud->model_name_kv->value.leaf.len - 2) * 4;
+		kv_str = CSR1212_TEXTUAL_DESCRIPTOR_LEAF_DATA(ud->model_name_kv);
+	} else {
+		kv_len = 0;
+		kv_str = NULL;
+	}
 	fdtv = fdtv_alloc(dev, &fdtv_1394_backend, kv_str, kv_len);
 	if (!fdtv)
 		return -ENOMEM;

-- 
Stefan Richter
-=====-==--= ==-- ==-=-
http://arcgraph.de/sr/

