Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:54513 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966822AbcLVUBk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Dec 2016 15:01:40 -0500
Subject: [PATCH 2/2] [media] pvrusb2-io: Add some spaces for better code
 readability
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Isely <isely@pobox.com>
References: <e08ae52b-3db5-4f9a-bc8b-c5abf7700856@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, trivial@kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <51d41201-28cb-d1c2-0a10-3b73239c84b1@users.sourceforge.net>
Date: Thu, 22 Dec 2016 21:01:19 +0100
MIME-Version: 1.0
In-Reply-To: <e08ae52b-3db5-4f9a-bc8b-c5abf7700856@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 22 Dec 2016 20:25:39 +0100

Use space characters at some source code places according to
the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/pvrusb2/pvrusb2-io.c | 120 ++++++++++++++++-----------------
 1 file changed, 60 insertions(+), 60 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-io.c b/drivers/media/usb/pvrusb2/pvrusb2-io.c
index a01510bfc84f..c89e037f72c3 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-io.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-io.c
@@ -37,13 +37,13 @@ static const char *pvr2_buffer_state_decode(enum pvr2_buffer_state);
 	if ((bp)->signature != BUFFER_SIG) { \
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS, \
 		"Buffer %p is bad at %s:%d", \
-		(bp),__FILE__,__LINE__); \
-		pvr2_buffer_describe(bp,"BadSig"); \
+		(bp), __FILE__, __LINE__); \
+		pvr2_buffer_describe(bp, "BadSig"); \
 		BUG(); \
 	} \
 } while (0)
 #else
-#define BUFFER_CHECK(bp) do {} while(0)
+#define BUFFER_CHECK(bp) do {} while (0)
 #endif
 
 struct pvr2_stream {
@@ -110,7 +110,7 @@ static const char *pvr2_buffer_state_decode(enum pvr2_buffer_state st)
 }
 
 #ifdef SANITY_CHECK_BUFFERS
-static void pvr2_buffer_describe(struct pvr2_buffer *bp,const char *msg)
+static void pvr2_buffer_describe(struct pvr2_buffer *bp, const char *msg)
 {
 	pvr2_trace(PVR2_TRACE_INFO,
 		   "buffer%s%s %p state=%s id=%d status=%d stream=%p purb=%p sig=0x%x",
@@ -156,7 +156,7 @@ static void pvr2_buffer_remove(struct pvr2_buffer *bp)
 	(*bcnt) -= ccnt;
 	pvr2_trace(PVR2_TRACE_BUF_FLOW,
 		   "/*---TRACE_FLOW---*/ bufferPool	%8s dec cap=%07d cnt=%02d",
-		   pvr2_buffer_state_decode(bp->state),*bcnt,*cnt);
+		   pvr2_buffer_state_decode(bp->state), *bcnt, *cnt);
 	bp->state = pvr2_buffer_state_none;
 }
 
@@ -171,9 +171,9 @@ static void pvr2_buffer_set_none(struct pvr2_buffer *bp)
 		   bp,
 		   pvr2_buffer_state_decode(bp->state),
 		   pvr2_buffer_state_decode(pvr2_buffer_state_none));
-	spin_lock_irqsave(&sp->list_lock,irq_flags);
+	spin_lock_irqsave(&sp->list_lock, irq_flags);
 	pvr2_buffer_remove(bp);
-	spin_unlock_irqrestore(&sp->list_lock,irq_flags);
+	spin_unlock_irqrestore(&sp->list_lock, irq_flags);
 }
 
 static int pvr2_buffer_set_ready(struct pvr2_buffer *bp)
@@ -188,18 +188,18 @@ static int pvr2_buffer_set_ready(struct pvr2_buffer *bp)
 		   bp,
 		   pvr2_buffer_state_decode(bp->state),
 		   pvr2_buffer_state_decode(pvr2_buffer_state_ready));
-	spin_lock_irqsave(&sp->list_lock,irq_flags);
+	spin_lock_irqsave(&sp->list_lock, irq_flags);
 	fl = (sp->r_count == 0);
 	pvr2_buffer_remove(bp);
-	list_add_tail(&bp->list_overhead,&sp->ready_list);
+	list_add_tail(&bp->list_overhead, &sp->ready_list);
 	bp->state = pvr2_buffer_state_ready;
 	(sp->r_count)++;
 	sp->r_bcount += bp->used_count;
 	pvr2_trace(PVR2_TRACE_BUF_FLOW,
 		   "/*---TRACE_FLOW---*/ bufferPool	%8s inc cap=%07d cnt=%02d",
 		   pvr2_buffer_state_decode(bp->state),
-		   sp->r_bcount,sp->r_count);
-	spin_unlock_irqrestore(&sp->list_lock,irq_flags);
+		   sp->r_bcount, sp->r_count);
+	spin_unlock_irqrestore(&sp->list_lock, irq_flags);
 	return fl;
 }
 
@@ -214,17 +214,17 @@ static void pvr2_buffer_set_idle(struct pvr2_buffer *bp)
 		   bp,
 		   pvr2_buffer_state_decode(bp->state),
 		   pvr2_buffer_state_decode(pvr2_buffer_state_idle));
-	spin_lock_irqsave(&sp->list_lock,irq_flags);
+	spin_lock_irqsave(&sp->list_lock, irq_flags);
 	pvr2_buffer_remove(bp);
-	list_add_tail(&bp->list_overhead,&sp->idle_list);
+	list_add_tail(&bp->list_overhead, &sp->idle_list);
 	bp->state = pvr2_buffer_state_idle;
 	(sp->i_count)++;
 	sp->i_bcount += bp->max_count;
 	pvr2_trace(PVR2_TRACE_BUF_FLOW,
 		   "/*---TRACE_FLOW---*/ bufferPool	%8s inc cap=%07d cnt=%02d",
 		   pvr2_buffer_state_decode(bp->state),
-		   sp->i_bcount,sp->i_count);
-	spin_unlock_irqrestore(&sp->list_lock,irq_flags);
+		   sp->i_bcount, sp->i_count);
+	spin_unlock_irqrestore(&sp->list_lock, irq_flags);
 }
 
 static void pvr2_buffer_set_queued(struct pvr2_buffer *bp)
@@ -238,17 +238,17 @@ static void pvr2_buffer_set_queued(struct pvr2_buffer *bp)
 		   bp,
 		   pvr2_buffer_state_decode(bp->state),
 		   pvr2_buffer_state_decode(pvr2_buffer_state_queued));
-	spin_lock_irqsave(&sp->list_lock,irq_flags);
+	spin_lock_irqsave(&sp->list_lock, irq_flags);
 	pvr2_buffer_remove(bp);
-	list_add_tail(&bp->list_overhead,&sp->queued_list);
+	list_add_tail(&bp->list_overhead, &sp->queued_list);
 	bp->state = pvr2_buffer_state_queued;
 	(sp->q_count)++;
 	sp->q_bcount += bp->max_count;
 	pvr2_trace(PVR2_TRACE_BUF_FLOW,
 		   "/*---TRACE_FLOW---*/ bufferPool	%8s inc cap=%07d cnt=%02d",
 		   pvr2_buffer_state_decode(bp->state),
-		   sp->q_bcount,sp->q_count);
-	spin_unlock_irqrestore(&sp->list_lock,irq_flags);
+		   sp->q_bcount, sp->q_count);
+	spin_unlock_irqrestore(&sp->list_lock, irq_flags);
 }
 
 static void pvr2_buffer_wipe(struct pvr2_buffer *bp)
@@ -262,18 +262,18 @@ static int pvr2_buffer_init(struct pvr2_buffer *bp,
 			    struct pvr2_stream *sp,
 			    unsigned int id)
 {
-	memset(bp,0,sizeof(*bp));
+	memset(bp, 0, sizeof(*bp));
 	bp->signature = BUFFER_SIG;
 	bp->id = id;
 	pvr2_trace(PVR2_TRACE_BUF_POOL,
-		   "/*---TRACE_FLOW---*/ bufferInit     %p stream=%p",bp,sp);
+		   "/*---TRACE_FLOW---*/ bufferInit     %p stream=%p", bp, sp);
 	bp->stream = sp;
 	bp->state = pvr2_buffer_state_none;
 	INIT_LIST_HEAD(&bp->list_overhead);
-	bp->purb = usb_alloc_urb(0,GFP_KERNEL);
+	bp->purb = usb_alloc_urb(0, GFP_KERNEL);
 	if (! bp->purb) return -ENOMEM;
 #ifdef SANITY_CHECK_BUFFERS
-	pvr2_buffer_describe(bp,"create");
+	pvr2_buffer_describe(bp, "create");
 #endif
 	return 0;
 }
@@ -281,7 +281,7 @@ static int pvr2_buffer_init(struct pvr2_buffer *bp,
 static void pvr2_buffer_done(struct pvr2_buffer *bp)
 {
 #ifdef SANITY_CHECK_BUFFERS
-	pvr2_buffer_describe(bp,"delete");
+	pvr2_buffer_describe(bp, "delete");
 #endif
 	pvr2_buffer_wipe(bp);
 	pvr2_buffer_set_none(bp);
@@ -292,7 +292,7 @@ static void pvr2_buffer_done(struct pvr2_buffer *bp)
 		   bp);
 }
 
-static int pvr2_stream_buffer_count(struct pvr2_stream *sp,unsigned int cnt)
+static int pvr2_stream_buffer_count(struct pvr2_stream *sp, unsigned int cnt)
 {
 	int ret;
 	unsigned int scnt;
@@ -316,7 +316,7 @@ static int pvr2_stream_buffer_count(struct pvr2_stream *sp,unsigned int cnt)
 			nb = kmalloc_array(scnt, sizeof(*nb), GFP_KERNEL);
 			if (!nb) return -ENOMEM;
 			if (sp->buffer_slot_count) {
-				memcpy(nb,sp->buffers,
+				memcpy(nb, sp->buffers,
 				       sp->buffer_slot_count * sizeof(*nb));
 				kfree(sp->buffers);
 			}
@@ -325,9 +325,9 @@ static int pvr2_stream_buffer_count(struct pvr2_stream *sp,unsigned int cnt)
 		}
 		while (sp->buffer_total_count < cnt) {
 			struct pvr2_buffer *bp;
-			bp = kmalloc(sizeof(*bp),GFP_KERNEL);
+			bp = kmalloc(sizeof(*bp), GFP_KERNEL);
 			if (!bp) return -ENOMEM;
-			ret = pvr2_buffer_init(bp,sp,sp->buffer_total_count);
+			ret = pvr2_buffer_init(bp, sp, sp->buffer_total_count);
 			if (ret) {
 				kfree(bp);
 				return -ENOMEM;
@@ -370,10 +370,10 @@ static int pvr2_stream_achieve_buffer_count(struct pvr2_stream *sp)
 
 	pvr2_trace(PVR2_TRACE_BUF_POOL,
 		   "/*---TRACE_FLOW---*/ poolCheck	stream=%p cur=%d tgt=%d",
-		   sp,sp->buffer_total_count,sp->buffer_target_count);
+		   sp, sp->buffer_total_count, sp->buffer_target_count);
 
 	if (sp->buffer_total_count < sp->buffer_target_count) {
-		return pvr2_stream_buffer_count(sp,sp->buffer_target_count);
+		return pvr2_stream_buffer_count(sp, sp->buffer_target_count);
 	}
 
 	cnt = 0;
@@ -383,7 +383,7 @@ static int pvr2_stream_achieve_buffer_count(struct pvr2_stream *sp)
 		cnt++;
 	}
 	if (cnt) {
-		pvr2_stream_buffer_count(sp,sp->buffer_total_count - cnt);
+		pvr2_stream_buffer_count(sp, sp->buffer_total_count - cnt);
 	}
 
 	return 0;
@@ -394,7 +394,7 @@ static void pvr2_stream_internal_flush(struct pvr2_stream *sp)
 	struct list_head *lp;
 	struct pvr2_buffer *bp1;
 	while ((lp = sp->queued_list.next) != &sp->queued_list) {
-		bp1 = list_entry(lp,struct pvr2_buffer,list_overhead);
+		bp1 = list_entry(lp, struct pvr2_buffer, list_overhead);
 		pvr2_buffer_wipe(bp1);
 		/* At this point, we should be guaranteed that no
 		   completion callback may happen on this buffer.  But it's
@@ -422,7 +422,7 @@ static void pvr2_stream_done(struct pvr2_stream *sp)
 {
 	mutex_lock(&sp->mutex); do {
 		pvr2_stream_internal_flush(sp);
-		pvr2_stream_buffer_count(sp,0);
+		pvr2_stream_buffer_count(sp, 0);
 	} while (0); mutex_unlock(&sp->mutex);
 }
 
@@ -437,8 +437,8 @@ static void buffer_complete(struct urb *urb)
 	bp->status = 0;
 	pvr2_trace(PVR2_TRACE_BUF_FLOW,
 		   "/*---TRACE_FLOW---*/ bufferComplete %p stat=%d cnt=%d",
-		   bp,urb->status,urb->actual_length);
-	spin_lock_irqsave(&sp->list_lock,irq_flags);
+		   bp, urb->status, urb->actual_length);
+	spin_lock_irqsave(&sp->list_lock, irq_flags);
 	if ((!(urb->status)) ||
 	    (urb->status == -ENOENT) ||
 	    (urb->status == -ECONNRESET) ||
@@ -459,12 +459,12 @@ static void buffer_complete(struct urb *urb)
 		(sp->buffers_failed)++;
 		pvr2_trace(PVR2_TRACE_TOLERANCE,
 			   "stream %p ignoring error %d - fail count increased to %u",
-			   sp,urb->status,sp->fail_count);
+			   sp, urb->status, sp->fail_count);
 	} else {
 		(sp->buffers_failed)++;
 		bp->status = urb->status;
 	}
-	spin_unlock_irqrestore(&sp->list_lock,irq_flags);
+	spin_unlock_irqrestore(&sp->list_lock, irq_flags);
 	pvr2_buffer_set_ready(bp);
 	if (sp->callback_func) {
 		sp->callback_func(sp->callback_data);
@@ -474,9 +474,9 @@ static void buffer_complete(struct urb *urb)
 struct pvr2_stream *pvr2_stream_create(void)
 {
 	struct pvr2_stream *sp;
-	sp = kzalloc(sizeof(*sp),GFP_KERNEL);
+	sp = kzalloc(sizeof(*sp), GFP_KERNEL);
 	if (!sp) return sp;
-	pvr2_trace(PVR2_TRACE_INIT,"pvr2_stream_create: sp=%p",sp);
+	pvr2_trace(PVR2_TRACE_INIT, "pvr2_stream_create: sp=%p", sp);
 	pvr2_stream_init(sp);
 	return sp;
 }
@@ -484,7 +484,7 @@ struct pvr2_stream *pvr2_stream_create(void)
 void pvr2_stream_destroy(struct pvr2_stream *sp)
 {
 	if (!sp) return;
-	pvr2_trace(PVR2_TRACE_INIT,"pvr2_stream_destroy: sp=%p",sp);
+	pvr2_trace(PVR2_TRACE_INIT, "pvr2_stream_destroy: sp=%p", sp);
 	pvr2_stream_done(sp);
 	kfree(sp);
 }
@@ -499,7 +499,7 @@ void pvr2_stream_setup(struct pvr2_stream *sp,
 		sp->dev = dev;
 		sp->endpoint = endpoint;
 		sp->fail_tolerance = tolerance;
-	} while(0); mutex_unlock(&sp->mutex);
+	} while (0); mutex_unlock(&sp->mutex);
 }
 
 void pvr2_stream_set_callback(struct pvr2_stream *sp,
@@ -509,11 +509,11 @@ void pvr2_stream_set_callback(struct pvr2_stream *sp,
 	unsigned long irq_flags;
 	mutex_lock(&sp->mutex);
 	do {
-		spin_lock_irqsave(&sp->list_lock,irq_flags);
+		spin_lock_irqsave(&sp->list_lock, irq_flags);
 		sp->callback_data = data;
 		sp->callback_func = func;
-		spin_unlock_irqrestore(&sp->list_lock,irq_flags);
-	} while(0);
+		spin_unlock_irqrestore(&sp->list_lock, irq_flags);
+	} while (0);
 	mutex_unlock(&sp->mutex);
 }
 
@@ -522,7 +522,7 @@ void pvr2_stream_get_stats(struct pvr2_stream *sp,
 			   int zero_counts)
 {
 	unsigned long irq_flags;
-	spin_lock_irqsave(&sp->list_lock,irq_flags);
+	spin_lock_irqsave(&sp->list_lock, irq_flags);
 	if (stats) {
 		stats->buffers_in_queue = sp->q_count;
 		stats->buffers_in_idle = sp->i_count;
@@ -536,7 +536,7 @@ void pvr2_stream_get_stats(struct pvr2_stream *sp,
 		sp->buffers_failed = 0;
 		sp->bytes_processed = 0;
 	}
-	spin_unlock_irqrestore(&sp->list_lock,irq_flags);
+	spin_unlock_irqrestore(&sp->list_lock, irq_flags);
 }
 
 /* Query / set the nominal buffer count */
@@ -545,7 +545,7 @@ int pvr2_stream_get_buffer_count(struct pvr2_stream *sp)
 	return sp->buffer_target_count;
 }
 
-int pvr2_stream_set_buffer_count(struct pvr2_stream *sp,unsigned int cnt)
+int pvr2_stream_set_buffer_count(struct pvr2_stream *sp, unsigned int cnt)
 {
 	int ret;
 	if (sp->buffer_target_count == cnt) return 0;
@@ -553,7 +553,7 @@ int pvr2_stream_set_buffer_count(struct pvr2_stream *sp,unsigned int cnt)
 	do {
 		sp->buffer_target_count = cnt;
 		ret = pvr2_stream_achieve_buffer_count(sp);
-	} while(0);
+	} while (0);
 	mutex_unlock(&sp->mutex);
 	return ret;
 }
@@ -562,17 +562,17 @@ struct pvr2_buffer *pvr2_stream_get_idle_buffer(struct pvr2_stream *sp)
 {
 	struct list_head *lp = sp->idle_list.next;
 	if (lp == &sp->idle_list) return NULL;
-	return list_entry(lp,struct pvr2_buffer,list_overhead);
+	return list_entry(lp, struct pvr2_buffer, list_overhead);
 }
 
 struct pvr2_buffer *pvr2_stream_get_ready_buffer(struct pvr2_stream *sp)
 {
 	struct list_head *lp = sp->ready_list.next;
 	if (lp == &sp->ready_list) return NULL;
-	return list_entry(lp,struct pvr2_buffer,list_overhead);
+	return list_entry(lp, struct pvr2_buffer, list_overhead);
 }
 
-struct pvr2_buffer *pvr2_stream_get_buffer(struct pvr2_stream *sp,int id)
+struct pvr2_buffer *pvr2_stream_get_buffer(struct pvr2_stream *sp, int id)
 {
 	if (id < 0) return NULL;
 	if (id >= sp->buffer_total_count) return NULL;
@@ -596,7 +596,7 @@ void pvr2_stream_kill(struct pvr2_stream *sp)
 		if (sp->buffer_total_count != sp->buffer_target_count) {
 			pvr2_stream_achieve_buffer_count(sp);
 		}
-	} while(0);
+	} while (0);
 	mutex_unlock(&sp->mutex);
 }
 
@@ -630,18 +630,18 @@ int pvr2_buffer_queue(struct pvr2_buffer *bp)
 		usb_fill_bulk_urb(bp->purb,      // struct urb *urb
 				  sp->dev,       // struct usb_device *dev
 				  // endpoint (below)
-				  usb_rcvbulkpipe(sp->dev,sp->endpoint),
+				  usb_rcvbulkpipe(sp->dev, sp->endpoint),
 				  bp->ptr,       // void *transfer_buffer
 				  bp->max_count, // int buffer_length
 				  buffer_complete,
 				  bp);
-		usb_submit_urb(bp->purb,GFP_KERNEL);
-	} while(0);
+		usb_submit_urb(bp->purb, GFP_KERNEL);
+	} while (0);
 	mutex_unlock(&sp->mutex);
 	return ret;
 }
 
-int pvr2_buffer_set_buffer(struct pvr2_buffer *bp,void *ptr,unsigned int cnt)
+int pvr2_buffer_set_buffer(struct pvr2_buffer *bp, void *ptr, unsigned int cnt)
 {
 	int ret = 0;
 	unsigned long irq_flags;
@@ -650,7 +650,7 @@ int pvr2_buffer_set_buffer(struct pvr2_buffer *bp,void *ptr,unsigned int cnt)
 	sp = bp->stream;
 	mutex_lock(&sp->mutex);
 	do {
-		spin_lock_irqsave(&sp->list_lock,irq_flags);
+		spin_lock_irqsave(&sp->list_lock, irq_flags);
 		if (bp->state != pvr2_buffer_state_idle) {
 			ret = -EPERM;
 		} else {
@@ -662,10 +662,10 @@ int pvr2_buffer_set_buffer(struct pvr2_buffer *bp,void *ptr,unsigned int cnt)
 				   "/*---TRACE_FLOW---*/ bufferPool	%8s cap cap=%07d cnt=%02d",
 				   pvr2_buffer_state_decode(
 					   pvr2_buffer_state_idle),
-				   bp->stream->i_bcount,bp->stream->i_count);
+				   bp->stream->i_bcount, bp->stream->i_count);
 		}
-		spin_unlock_irqrestore(&sp->list_lock,irq_flags);
-	} while(0);
+		spin_unlock_irqrestore(&sp->list_lock, irq_flags);
+	} while (0);
 	mutex_unlock(&sp->mutex);
 	return ret;
 }
-- 
2.11.0

