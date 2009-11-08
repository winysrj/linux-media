Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:36294 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbZKHV3T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 16:29:19 -0500
Date: Sun, 8 Nov 2009 22:29:08 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/4] firedtv: reform lock transaction backend call
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ce889fb60854a648@s5r6.in-berlin.de>
Message-ID: <tkrat.cb1d50f24d5d7172@s5r6.in-berlin.de>
References: <tkrat.ce889fb60854a648@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Preparation for the port of firedtv to the firewire-core kernel API:
The fdtv->backend->lock() hook and thus the CMP code is slightly changed
to better fit with the new API.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-1394.c |   11 ++++-
 drivers/media/dvb/firewire/firedtv-avc.c  |   50 ++++++++++++----------
 drivers/media/dvb/firewire/firedtv.h      |    2 
 3 files changed, 37 insertions(+), 26 deletions(-)

Index: linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-1394.c
===================================================================
--- linux-2.6.31.4.orig/drivers/media/dvb/firewire/firedtv-1394.c
+++ linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-1394.c
@@ -87,10 +87,15 @@ static inline struct node_entry *node_of
 	return container_of(fdtv->device, struct unit_directory, device)->ne;
 }
 
-static int node_lock(struct firedtv *fdtv, u64 addr, void *data, __be32 arg)
+static int node_lock(struct firedtv *fdtv, u64 addr, __be32 data[])
 {
-	return hpsb_node_lock(node_of(fdtv), addr, EXTCODE_COMPARE_SWAP, data,
-			      (__force quadlet_t)arg);
+	int ret;
+
+	ret = hpsb_node_lock(node_of(fdtv), addr, EXTCODE_COMPARE_SWAP,
+		(__force quadlet_t *)&data[1], (__force quadlet_t)data[0]);
+	data[0] = data[1];
+
+	return ret;
 }
 
 static int node_read(struct firedtv *fdtv, u64 addr, void *data, size_t len)
Index: linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- linux-2.6.31.4.orig/drivers/media/dvb/firewire/firedtv-avc.c
+++ linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-avc.c
@@ -1255,14 +1255,14 @@ static int cmp_read(struct firedtv *fdtv
 	return ret;
 }
 
-static int cmp_lock(struct firedtv *fdtv, void *data, u64 addr, __be32 arg)
+static int cmp_lock(struct firedtv *fdtv, u64 addr, __be32 data[])
 {
 	int ret;
 
 	if (mutex_lock_interruptible(&fdtv->avc_mutex))
 		return -EINTR;
 
-	ret = fdtv->backend->lock(fdtv, addr, data, arg);
+	ret = fdtv->backend->lock(fdtv, addr, data);
 	if (ret < 0)
 		dev_err(fdtv->device, "CMP: lock I/O error\n");
 
@@ -1292,25 +1292,25 @@ static inline void set_opcr(__be32 *opcr
 
 int cmp_establish_pp_connection(struct firedtv *fdtv, int plug, int channel)
 {
-	__be32 old_opcr, opcr;
+	__be32 old_opcr, opcr[2];
 	u64 opcr_address = CMP_OUTPUT_PLUG_CONTROL_REG_0 + (plug << 2);
 	int attempts = 0;
 	int ret;
 
-	ret = cmp_read(fdtv, &opcr, opcr_address, 4);
+	ret = cmp_read(fdtv, opcr, opcr_address, 4);
 	if (ret < 0)
 		return ret;
 
 repeat:
-	if (!get_opcr_online(opcr)) {
+	if (!get_opcr_online(*opcr)) {
 		dev_err(fdtv->device, "CMP: output offline\n");
 		return -EBUSY;
 	}
 
-	old_opcr = opcr;
+	old_opcr = *opcr;
 
-	if (get_opcr_p2p_connections(opcr)) {
-		if (get_opcr_channel(opcr) != channel) {
+	if (get_opcr_p2p_connections(*opcr)) {
+		if (get_opcr_channel(*opcr) != channel) {
 			dev_err(fdtv->device, "CMP: cannot change channel\n");
 			return -EBUSY;
 		}
@@ -1318,11 +1318,11 @@ repeat:
 
 		/* We don't allocate isochronous resources. */
 	} else {
-		set_opcr_channel(&opcr, channel);
-		set_opcr_data_rate(&opcr, 2); /* S400 */
+		set_opcr_channel(opcr, channel);
+		set_opcr_data_rate(opcr, 2); /* S400 */
 
 		/* FIXME: this is for the worst case - optimize */
-		set_opcr_overhead_id(&opcr, 0);
+		set_opcr_overhead_id(opcr, 0);
 
 		/*
 		 * FIXME: allocate isochronous channel and bandwidth at IRM
@@ -1330,13 +1330,16 @@ repeat:
 		 */
 	}
 
-	set_opcr_p2p_connections(&opcr, get_opcr_p2p_connections(opcr) + 1);
+	set_opcr_p2p_connections(opcr, get_opcr_p2p_connections(*opcr) + 1);
 
-	ret = cmp_lock(fdtv, &opcr, opcr_address, old_opcr);
+	opcr[1] = *opcr;
+	opcr[0] = old_opcr;
+
+	ret = cmp_lock(fdtv, opcr_address, opcr);
 	if (ret < 0)
 		return ret;
 
-	if (old_opcr != opcr) {
+	if (old_opcr != *opcr) {
 		/*
 		 * FIXME: if old_opcr.P2P_Connections > 0,
 		 * deallocate isochronous channel and bandwidth at IRM
@@ -1354,27 +1357,30 @@ repeat:
 
 void cmp_break_pp_connection(struct firedtv *fdtv, int plug, int channel)
 {
-	__be32 old_opcr, opcr;
+	__be32 old_opcr, opcr[2];
 	u64 opcr_address = CMP_OUTPUT_PLUG_CONTROL_REG_0 + (plug << 2);
 	int attempts = 0;
 
-	if (cmp_read(fdtv, &opcr, opcr_address, 4) < 0)
+	if (cmp_read(fdtv, opcr, opcr_address, 4) < 0)
 		return;
 
 repeat:
-	if (!get_opcr_online(opcr) || !get_opcr_p2p_connections(opcr) ||
-	    get_opcr_channel(opcr) != channel) {
+	if (!get_opcr_online(*opcr) || !get_opcr_p2p_connections(*opcr) ||
+	    get_opcr_channel(*opcr) != channel) {
 		dev_err(fdtv->device, "CMP: no connection to break\n");
 		return;
 	}
 
-	old_opcr = opcr;
-	set_opcr_p2p_connections(&opcr, get_opcr_p2p_connections(opcr) - 1);
+	old_opcr = *opcr;
+	set_opcr_p2p_connections(opcr, get_opcr_p2p_connections(*opcr) - 1);
+
+	opcr[1] = *opcr;
+	opcr[0] = old_opcr;
 
-	if (cmp_lock(fdtv, &opcr, opcr_address, old_opcr) < 0)
+	if (cmp_lock(fdtv, opcr_address, opcr) < 0)
 		return;
 
-	if (old_opcr != opcr) {
+	if (old_opcr != *opcr) {
 		/*
 		 * FIXME: if old_opcr.P2P_Connections == 1, i.e. we were last
 		 * owner, deallocate isochronous channel and bandwidth at IRM
Index: linux-2.6.31.4/drivers/media/dvb/firewire/firedtv.h
===================================================================
--- linux-2.6.31.4.orig/drivers/media/dvb/firewire/firedtv.h
+++ linux-2.6.31.4/drivers/media/dvb/firewire/firedtv.h
@@ -72,7 +72,7 @@ struct input_dev;
 struct firedtv;
 
 struct firedtv_backend {
-	int (*lock)(struct firedtv *fdtv, u64 addr, void *data, __be32 arg);
+	int (*lock)(struct firedtv *fdtv, u64 addr, __be32 data[]);
 	int (*read)(struct firedtv *fdtv, u64 addr, void *data, size_t len);
 	int (*write)(struct firedtv *fdtv, u64 addr, void *data, size_t len);
 	int (*start_iso)(struct firedtv *fdtv);

-- 
Stefan Richter
-=====-==--= =-== -=---
http://arcgraph.de/sr/

