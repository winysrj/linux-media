Return-path: <mchehab@pedra>
Received: from einhorn.in-berlin.de ([192.109.42.8]:37377 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab1DVNOO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2011 09:14:14 -0400
Date: Fri, 22 Apr 2011 15:13:54 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: Clemens Ladisch <clemens@ladisch.de>, alsa-devel@alsa-project.org,
	linux-media@vger.kernel.org
Subject: [PATCH] firewire: octlet AT payloads can be stack-allocated
Message-ID: <20110422151354.59c7ca77@stein>
In-Reply-To: <20110411142651.638311e0@stein>
References: <4DA2B3DC.7010104@ladisch.de>
	<4DA2B482.4060701@ladisch.de>
	<20110411142651.638311e0@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

...provided that the allocation persists until the packet was sent out
to the bus.  But we do not need slab allocations anymore in order to
satisfy streaming DMA mapping constraints, thanks to commit da28947e7e36
"firewire: ohci: avoid separate DMA mapping for small AT payloads".

(Besides, the slab-allocated buffers that firewire-core, firewire-sbp2,
and firedtv used to provide for 8-byte write and lock requests were
still not fully portable since they crossed cacheline boundaries or
shared a cacheline with unrelated CPU-accessed data.  snd-firewire-lib
got this aspect right by using an extra kmalloc/ kfree just for the
8-byte transaction buffer.)

This change replaces kmalloc'ed lock transaction scratch buffers in
firewire-core, firedtv, and snd-firewire-lib by local stack allocations.
The lifetime requirement of these allocations is fulfilled because the
call sites use the blocking fw_run_transaction API.

Perhaps the most notable result of the change is simpler locking because
there is no need to serialize usages of preallocated per-device buffers
anymore.  Also, allocations and deallocations are simpler.

firewire-sbp2's struct sbp2_orb.pointer buffer for 8-byte block write
requests on the other hand needs to remain slab-allocated in order to
keep the allocation around until end of AT DMA.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Tested with firedtv, snd-firewire-speakers, sind-isight, and Coriander
on a kernel with CONFIG_DMA_API_DEBUG=y.

The patch could be split into three parts --- one for firedtv alone, one
for the firewire-core an snd-firewire-lib fw_iso_resource_manage related
changes, and one for the other changes in firewire-core.  But since the
second one necessarily affects both drivers/firewire/ and sound/firewire/
and because they all depend functionally on a change in linux1394-2.6.git
master, there is no much benefit in breaking this up.

 drivers/firewire/core-card.c             |   16 ++++++++--------
 drivers/firewire/core-cdev.c             |    4 +---
 drivers/firewire/core-iso.c              |   21 +++++++++++----------
 drivers/firewire/core-transaction.c      |    7 ++++---
 drivers/media/dvb/firewire/firedtv-avc.c |   15 +--------------
 include/linux/firewire.h                 |    3 +--
 sound/firewire/cmp.c                     |    3 +--
 sound/firewire/iso-resources.c           |   12 +++---------
 sound/firewire/iso-resources.h           |    1 -
 9 files changed, 30 insertions(+), 52 deletions(-)

Index: b/drivers/firewire/core-card.c
===================================================================
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -258,8 +258,7 @@ static void allocate_broadcast_channel(s
 
 	if (!card->broadcast_channel_allocated) {
 		fw_iso_resource_manage(card, generation, 1ULL << 31,
-				       &channel, &bandwidth, true,
-				       card->bm_transaction_data);
+				       &channel, &bandwidth, true);
 		if (channel != 31) {
 			fw_notify("failed to allocate broadcast channel\n");
 			return;
@@ -294,6 +293,7 @@ static void bm_work(struct work_struct *
 	bool root_device_is_cmc;
 	bool irm_is_1394_1995_only;
 	bool keep_this_irm;
+	__be32 transaction_data[2];
 
 	spin_lock_irq(&card->lock);
 
@@ -355,21 +355,21 @@ static void bm_work(struct work_struct *
 			goto pick_me;
 		}
 
-		card->bm_transaction_data[0] = cpu_to_be32(0x3f);
-		card->bm_transaction_data[1] = cpu_to_be32(local_id);
+		transaction_data[0] = cpu_to_be32(0x3f);
+		transaction_data[1] = cpu_to_be32(local_id);
 
 		spin_unlock_irq(&card->lock);
 
 		rcode = fw_run_transaction(card, TCODE_LOCK_COMPARE_SWAP,
 				irm_id, generation, SCODE_100,
 				CSR_REGISTER_BASE + CSR_BUS_MANAGER_ID,
-				card->bm_transaction_data, 8);
+				transaction_data, 8);
 
 		if (rcode == RCODE_GENERATION)
 			/* Another bus reset, BM work has been rescheduled. */
 			goto out;
 
-		bm_id = be32_to_cpu(card->bm_transaction_data[0]);
+		bm_id = be32_to_cpu(transaction_data[0]);
 
 		spin_lock_irq(&card->lock);
 		if (rcode == RCODE_COMPLETE && generation == card->generation)
@@ -490,11 +490,11 @@ static void bm_work(struct work_struct *
 		/*
 		 * Make sure that the cycle master sends cycle start packets.
 		 */
-		card->bm_transaction_data[0] = cpu_to_be32(CSR_STATE_BIT_CMSTR);
+		transaction_data[0] = cpu_to_be32(CSR_STATE_BIT_CMSTR);
 		rcode = fw_run_transaction(card, TCODE_WRITE_QUADLET_REQUEST,
 				root_id, generation, SCODE_100,
 				CSR_REGISTER_BASE + CSR_STATE_SET,
-				card->bm_transaction_data, 4);
+				transaction_data, 4);
 		if (rcode == RCODE_GENERATION)
 			goto out;
 	}
Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -141,7 +141,6 @@ struct iso_resource {
 	int generation;
 	u64 channels;
 	s32 bandwidth;
-	__be32 transaction_data[2];
 	struct iso_resource_event *e_alloc, *e_dealloc;
 };
 
@@ -1229,8 +1228,7 @@ static void iso_resource_work(struct wor
 			r->channels, &channel, &bandwidth,
 			todo == ISO_RES_ALLOC ||
 			todo == ISO_RES_REALLOC ||
-			todo == ISO_RES_ALLOC_ONCE,
-			r->transaction_data);
+			todo == ISO_RES_ALLOC_ONCE);
 	/*
 	 * Is this generation outdated already?  As long as this resource sticks
 	 * in the idr, it will be scheduled again for a newer generation or at
Index: b/drivers/firewire/core-iso.c
===================================================================
--- a/drivers/firewire/core-iso.c
+++ b/drivers/firewire/core-iso.c
@@ -196,9 +196,10 @@ EXPORT_SYMBOL(fw_iso_context_stop);
  */
 
 static int manage_bandwidth(struct fw_card *card, int irm_id, int generation,
-			    int bandwidth, bool allocate, __be32 data[2])
+			    int bandwidth, bool allocate)
 {
 	int try, new, old = allocate ? BANDWIDTH_AVAILABLE_INITIAL : 0;
+	__be32 data[2];
 
 	/*
 	 * On a 1394a IRM with low contention, try < 1 is enough.
@@ -233,9 +234,10 @@ static int manage_bandwidth(struct fw_ca
 }
 
 static int manage_channel(struct fw_card *card, int irm_id, int generation,
-		u32 channels_mask, u64 offset, bool allocate, __be32 data[2])
+		u32 channels_mask, u64 offset, bool allocate)
 {
 	__be32 bit, all, old;
+	__be32 data[2];
 	int channel, ret = -EIO, retry = 5;
 
 	old = all = allocate ? cpu_to_be32(~0) : 0;
@@ -284,7 +286,7 @@ static int manage_channel(struct fw_card
 }
 
 static void deallocate_channel(struct fw_card *card, int irm_id,
-			       int generation, int channel, __be32 buffer[2])
+			       int generation, int channel)
 {
 	u32 mask;
 	u64 offset;
@@ -293,7 +295,7 @@ static void deallocate_channel(struct fw
 	offset = channel < 32 ? CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_HI :
 				CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_LO;
 
-	manage_channel(card, irm_id, generation, mask, offset, false, buffer);
+	manage_channel(card, irm_id, generation, mask, offset, false);
 }
 
 /**
@@ -322,7 +324,7 @@ static void deallocate_channel(struct fw
  */
 void fw_iso_resource_manage(struct fw_card *card, int generation,
 			    u64 channels_mask, int *channel, int *bandwidth,
-			    bool allocate, __be32 buffer[2])
+			    bool allocate)
 {
 	u32 channels_hi = channels_mask;	/* channels 31...0 */
 	u32 channels_lo = channels_mask >> 32;	/* channels 63...32 */
@@ -335,11 +337,11 @@ void fw_iso_resource_manage(struct fw_ca
 	if (channels_hi)
 		c = manage_channel(card, irm_id, generation, channels_hi,
 				CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_HI,
-				allocate, buffer);
+				allocate);
 	if (channels_lo && c < 0) {
 		c = manage_channel(card, irm_id, generation, channels_lo,
 				CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_LO,
-				allocate, buffer);
+				allocate);
 		if (c >= 0)
 			c += 32;
 	}
@@ -351,14 +353,13 @@ void fw_iso_resource_manage(struct fw_ca
 	if (*bandwidth == 0)
 		return;
 
-	ret = manage_bandwidth(card, irm_id, generation, *bandwidth,
-			       allocate, buffer);
+	ret = manage_bandwidth(card, irm_id, generation, *bandwidth, allocate);
 	if (ret < 0)
 		*bandwidth = 0;
 
 	if (allocate && ret < 0) {
 		if (c >= 0)
-			deallocate_channel(card, irm_id, generation, c, buffer);
+			deallocate_channel(card, irm_id, generation, c);
 		*channel = ret;
 	}
 }
Index: b/drivers/firewire/core-transaction.c
===================================================================
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -326,8 +326,8 @@ static int allocate_tlabel(struct fw_car
  * It will contain tag, channel, and sy data instead of a node ID then.
  *
  * The payload buffer at @data is going to be DMA-mapped except in case of
- * quadlet-sized payload or of local (loopback) requests.  Hence make sure that
- * the buffer complies with the restrictions for DMA-mapped memory.  The
+ * @length <= 8 or of local (loopback) requests.  Hence make sure that the
+ * buffer complies with the restrictions of the streaming DMA mapping API.
  * @payload must not be freed before the @callback is called.
  *
  * In case of request types without payload, @data is NULL and @length is 0.
@@ -411,7 +411,8 @@ static void transaction_callback(struct 
  *
  * Returns the RCODE.  See fw_send_request() for parameter documentation.
  * Unlike fw_send_request(), @data points to the payload of the request or/and
- * to the payload of the response.
+ * to the payload of the response.  DMA mapping restrictions apply to outbound
+ * request payloads of >= 8 bytes but not to inbound response payloads.
  */
 int fw_run_transaction(struct fw_card *card, int tcode, int destination_id,
 		       int generation, int speed, unsigned long long offset,
Index: b/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -1320,14 +1320,10 @@ static int cmp_read(struct firedtv *fdtv
 {
 	int ret;
 
-	mutex_lock(&fdtv->avc_mutex);
-
 	ret = fdtv_read(fdtv, addr, data);
 	if (ret < 0)
 		dev_err(fdtv->device, "CMP: read I/O error\n");
 
-	mutex_unlock(&fdtv->avc_mutex);
-
 	return ret;
 }
 
@@ -1335,18 +1331,9 @@ static int cmp_lock(struct firedtv *fdtv
 {
 	int ret;
 
-	mutex_lock(&fdtv->avc_mutex);
-
-	/* data[] is stack-allocated and should not be DMA-mapped. */
-	memcpy(fdtv->avc_data, data, 8);
-
-	ret = fdtv_lock(fdtv, addr, fdtv->avc_data);
+	ret = fdtv_lock(fdtv, addr, data);
 	if (ret < 0)
 		dev_err(fdtv->device, "CMP: lock I/O error\n");
-	else
-		memcpy(data, fdtv->avc_data, 8);
-
-	mutex_unlock(&fdtv->avc_mutex);
 
 	return ret;
 }
Index: b/include/linux/firewire.h
===================================================================
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -125,7 +125,6 @@ struct fw_card {
 	struct delayed_work bm_work; /* bus manager job */
 	int bm_retries;
 	int bm_generation;
-	__be32 bm_transaction_data[2];
 	int bm_node_id;
 	bool bm_abdicate;
 
@@ -447,6 +446,6 @@ int fw_iso_context_stop(struct fw_iso_co
 void fw_iso_context_destroy(struct fw_iso_context *ctx);
 void fw_iso_resource_manage(struct fw_card *card, int generation,
 			    u64 channels_mask, int *channel, int *bandwidth,
-			    bool allocate, __be32 buffer[2]);
+			    bool allocate);
 
 #endif /* _LINUX_FIREWIRE_H */
Index: b/sound/firewire/cmp.c
===================================================================
--- a/sound/firewire/cmp.c
+++ b/sound/firewire/cmp.c
@@ -49,10 +49,9 @@ static int pcr_modify(struct cmp_connect
 		      enum bus_reset_handling bus_reset_handling)
 {
 	struct fw_device *device = fw_parent_device(c->resources.unit);
-	__be32 *buffer = c->resources.buffer;
 	int generation = c->resources.generation;
 	int rcode, errors = 0;
-	__be32 old_arg;
+	__be32 old_arg, buffer[2];
 	int err;
 
 	buffer[0] = c->last_pcr_value;
Index: b/sound/firewire/iso-resources.c
===================================================================
--- a/sound/firewire/iso-resources.c
+++ b/sound/firewire/iso-resources.c
@@ -11,7 +11,6 @@
 #include <linux/jiffies.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
-#include <linux/slab.h>
 #include <linux/spinlock.h>
 #include "iso-resources.h"
 
@@ -25,10 +24,6 @@
  */
 int fw_iso_resources_init(struct fw_iso_resources *r, struct fw_unit *unit)
 {
-	r->buffer = kmalloc(2 * 4, GFP_KERNEL);
-	if (!r->buffer)
-		return -ENOMEM;
-
 	r->channels_mask = ~0uLL;
 	r->unit = fw_unit_get(unit);
 	mutex_init(&r->mutex);
@@ -45,7 +40,6 @@ EXPORT_SYMBOL(fw_iso_resources_init);
 void fw_iso_resources_destroy(struct fw_iso_resources *r)
 {
 	WARN_ON(r->allocated);
-	kfree(r->buffer);
 	mutex_destroy(&r->mutex);
 	fw_unit_put(r->unit);
 }
@@ -133,7 +127,7 @@ retry_after_bus_reset:
 
 	bandwidth = r->bandwidth + r->bandwidth_overhead;
 	fw_iso_resource_manage(card, r->generation, r->channels_mask,
-			       &channel, &bandwidth, true, r->buffer);
+			       &channel, &bandwidth, true);
 	if (channel == -EAGAIN) {
 		mutex_unlock(&r->mutex);
 		goto retry_after_bus_reset;
@@ -187,7 +181,7 @@ int fw_iso_resources_update(struct fw_is
 	bandwidth = r->bandwidth + r->bandwidth_overhead;
 
 	fw_iso_resource_manage(card, r->generation, 1uLL << r->channel,
-			       &channel, &bandwidth, true, r->buffer);
+			       &channel, &bandwidth, true);
 	/*
 	 * When another bus reset happens, pretend that the allocation
 	 * succeeded; we will try again for the new generation later.
@@ -224,7 +218,7 @@ void fw_iso_resources_free(struct fw_iso
 	if (r->allocated) {
 		bandwidth = r->bandwidth + r->bandwidth_overhead;
 		fw_iso_resource_manage(card, r->generation, 1uLL << r->channel,
-				       &channel, &bandwidth, false, r->buffer);
+				       &channel, &bandwidth, false);
 		if (channel < 0)
 			dev_err(&r->unit->device,
 				"isochronous resource deallocation failed\n");
Index: b/sound/firewire/iso-resources.h
===================================================================
--- a/sound/firewire/iso-resources.h
+++ b/sound/firewire/iso-resources.h
@@ -24,7 +24,6 @@ struct fw_iso_resources {
 	unsigned int bandwidth_overhead;
 	int generation; /* in which allocation is valid */
 	bool allocated;
-	__be32 *buffer;
 };
 
 int fw_iso_resources_init(struct fw_iso_resources *r,

-- 
Stefan Richter
-=====-==-== -=-- =-==-
http://arcgraph.de/sr/
