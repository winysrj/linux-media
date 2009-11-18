Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:35624 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513AbZKRTBo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 14:01:44 -0500
Date: Wed, 18 Nov 2009 20:01:34 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/6] firedtv: remove an unnecessary function argument
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.7dc1f889fd1b69ad@s5r6.in-berlin.de>
Message-ID: <tkrat.798c5f822d0963e6@s5r6.in-berlin.de>
References: <tkrat.7dc1f889fd1b69ad@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All read transactions initiated by firedtv are only quadlet-sized, hence
the backend->read call can be simplified a little.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-1394.c |    4 ++--
 drivers/media/dvb/firewire/firedtv-avc.c  |    8 ++++----
 drivers/media/dvb/firewire/firedtv-fw.c   |    5 ++---
 drivers/media/dvb/firewire/firedtv.h      |    2 +-
 4 files changed, 9 insertions(+), 10 deletions(-)

Index: linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-1394.c
===================================================================
--- linux-2.6.32-rc7.orig/drivers/media/dvb/firewire/firedtv-1394.c
+++ linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-1394.c
@@ -101,9 +101,9 @@ static int node_lock(struct firedtv *fdt
 	return ret;
 }
 
-static int node_read(struct firedtv *fdtv, u64 addr, void *data, size_t len)
+static int node_read(struct firedtv *fdtv, u64 addr, void *data)
 {
-	return hpsb_node_read(node_of(fdtv), addr, data, len);
+	return hpsb_node_read(node_of(fdtv), addr, data, 4);
 }
 
 static int node_write(struct firedtv *fdtv, u64 addr, void *data, size_t len)
Index: linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- linux-2.6.32-rc7.orig/drivers/media/dvb/firewire/firedtv-avc.c
+++ linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-avc.c
@@ -1236,14 +1236,14 @@ int avc_ca_get_mmi(struct firedtv *fdtv,
 
 #define CMP_OUTPUT_PLUG_CONTROL_REG_0	0xfffff0000904ULL
 
-static int cmp_read(struct firedtv *fdtv, void *buf, u64 addr, size_t len)
+static int cmp_read(struct firedtv *fdtv, u64 addr, __be32 *data)
 {
 	int ret;
 
 	if (mutex_lock_interruptible(&fdtv->avc_mutex))
 		return -EINTR;
 
-	ret = fdtv->backend->read(fdtv, addr, buf, len);
+	ret = fdtv->backend->read(fdtv, addr, data);
 	if (ret < 0)
 		dev_err(fdtv->device, "CMP: read I/O error\n");
 
@@ -1293,7 +1293,7 @@ int cmp_establish_pp_connection(struct f
 	int attempts = 0;
 	int ret;
 
-	ret = cmp_read(fdtv, opcr, opcr_address, 4);
+	ret = cmp_read(fdtv, opcr_address, opcr);
 	if (ret < 0)
 		return ret;
 
@@ -1357,7 +1357,7 @@ void cmp_break_pp_connection(struct fire
 	u64 opcr_address = CMP_OUTPUT_PLUG_CONTROL_REG_0 + (plug << 2);
 	int attempts = 0;
 
-	if (cmp_read(fdtv, opcr, opcr_address, 4) < 0)
+	if (cmp_read(fdtv, opcr_address, opcr) < 0)
 		return;
 
 repeat:
Index: linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-fw.c
===================================================================
--- linux-2.6.32-rc7.orig/drivers/media/dvb/firewire/firedtv-fw.c
+++ linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-fw.c
@@ -46,10 +46,9 @@ static int node_lock(struct firedtv *fdt
 	return node_req(fdtv, addr, data, 8, TCODE_LOCK_COMPARE_SWAP);
 }
 
-static int node_read(struct firedtv *fdtv, u64 addr, void *data, size_t len)
+static int node_read(struct firedtv *fdtv, u64 addr, void *data)
 {
-	return node_req(fdtv, addr, data, len, len == 4 ?
-			TCODE_READ_QUADLET_REQUEST : TCODE_READ_BLOCK_REQUEST);
+	return node_req(fdtv, addr, data, 4, TCODE_READ_QUADLET_REQUEST);
 }
 
 static int node_write(struct firedtv *fdtv, u64 addr, void *data, size_t len)
Index: linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv.h
===================================================================
--- linux-2.6.32-rc7.orig/drivers/media/dvb/firewire/firedtv.h
+++ linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv.h
@@ -74,7 +74,7 @@ struct firedtv;
 
 struct firedtv_backend {
 	int (*lock)(struct firedtv *fdtv, u64 addr, __be32 data[]);
-	int (*read)(struct firedtv *fdtv, u64 addr, void *data, size_t len);
+	int (*read)(struct firedtv *fdtv, u64 addr, void *data);
 	int (*write)(struct firedtv *fdtv, u64 addr, void *data, size_t len);
 	int (*start_iso)(struct firedtv *fdtv);
 	void (*stop_iso)(struct firedtv *fdtv);

-- 
Stefan Richter
-=====-==--= =-== =--=-
http://arcgraph.de/sr/

