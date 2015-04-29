Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37579 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbD2XGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:24 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>
Subject: [PATCH 17/27] pvrusb2: fix inconsistent indenting
Date: Wed, 29 Apr 2015 20:06:02 -0300
Message-Id: <10958ce9f8d164fac3c074a23c7cbebe915137b4.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

smatch complains about multiple issues here:
	drivers/media/usb/pvrusb2/pvrusb2-context.c:402 pvr2_channel_claim_stream() warn: inconsistent indenting
	drivers/media/usb/pvrusb2/pvrusb2-ioread.c:240 pvr2_ioread_setup() warn: inconsistent indenting
	drivers/media/usb/pvrusb2/pvrusb2-ioread.c:255 pvr2_ioread_set_enabled() warn: inconsistent indenting
	drivers/media/usb/pvrusb2/pvrusb2-ioread.c:485 pvr2_ioread_read() warn: inconsistent indenting
	drivers/media/usb/pvrusb2/pvrusb2-io.c:522 pvr2_stream_set_callback() warn: inconsistent indenting
	drivers/media/usb/pvrusb2/pvrusb2-io.c:561 pvr2_stream_set_buffer_count() warn: inconsistent indenting
	drivers/media/usb/pvrusb2/pvrusb2-io.c:640 pvr2_buffer_queue() warn: inconsistent indenting
	drivers/media/usb/pvrusb2/pvrusb2-io.c:667 pvr2_buffer_set_buffer() warn: inconsistent indenting
	drivers/media/usb/pvrusb2/pvrusb2-io.c:668 pvr2_buffer_set_buffer() warn: inconsistent indenting
	drivers/media/usb/pvrusb2/pvrusb2-hdw.c:2614 pvr2_hdw_create() warn: inconsistent indenting
	drivers/media/usb/pvrusb2/pvrusb2-hdw.c:2740 pvr2_hdw_destroy() warn: inconsistent indenting
	drivers/media/usb/pvrusb2/pvrusb2-hdw.c:3353 pvr2_hdw_trigger_module_log() warn: inconsistent indenting

Let's get rid of those, in order to cleanup as much as possible the smatch error log.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-context.c b/drivers/media/usb/pvrusb2/pvrusb2-context.c
index 924fc4c6019a..fd888a604462 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-context.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-context.c
@@ -398,7 +398,8 @@ int pvr2_channel_claim_stream(struct pvr2_channel *cp,
 		if (!sp) break;
 		sp->user = cp;
 		cp->stream = sp;
-	} while (0); pvr2_context_exit(cp->mc_head);
+	} while (0);
+	pvr2_context_exit(cp->mc_head);
 	return code;
 }
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 930593d7028d..775aa5ed92ee 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2602,14 +2602,16 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 			   "Error registering with v4l core, giving up");
 		goto fail;
 	}
-	mutex_lock(&pvr2_unit_mtx); do {
+	mutex_lock(&pvr2_unit_mtx);
+	do {
 		for (idx = 0; idx < PVR_NUM; idx++) {
 			if (unit_pointers[idx]) continue;
 			hdw->unit_number = idx;
 			unit_pointers[idx] = hdw;
 			break;
 		}
-	} while (0); mutex_unlock(&pvr2_unit_mtx);
+	} while (0);
+	mutex_unlock(&pvr2_unit_mtx);
 
 	cnt1 = 0;
 	cnt2 = scnprintf(hdw->name+cnt1,sizeof(hdw->name)-cnt1,"pvrusb2");
@@ -2730,13 +2732,15 @@ void pvr2_hdw_destroy(struct pvr2_hdw *hdw)
 	pvr2_i2c_core_done(hdw);
 	v4l2_device_unregister(&hdw->v4l2_dev);
 	pvr2_hdw_remove_usb_stuff(hdw);
-	mutex_lock(&pvr2_unit_mtx); do {
+	mutex_lock(&pvr2_unit_mtx);
+	do {
 		if ((hdw->unit_number >= 0) &&
 		    (hdw->unit_number < PVR_NUM) &&
 		    (unit_pointers[hdw->unit_number] == hdw)) {
 			unit_pointers[hdw->unit_number] = NULL;
 		}
-	} while (0); mutex_unlock(&pvr2_unit_mtx);
+	} while (0);
+	mutex_unlock(&pvr2_unit_mtx);
 	kfree(hdw->controls);
 	kfree(hdw->mpeg_ctrl_info);
 	kfree(hdw);
@@ -3343,14 +3347,16 @@ struct pvr2_stream *pvr2_hdw_get_video_stream(struct pvr2_hdw *hp)
 void pvr2_hdw_trigger_module_log(struct pvr2_hdw *hdw)
 {
 	int nr = pvr2_hdw_get_unit_number(hdw);
-	LOCK_TAKE(hdw->big_lock); do {
+	LOCK_TAKE(hdw->big_lock);
+	do {
 		printk(KERN_INFO "pvrusb2: =================  START STATUS CARD #%d  =================\n", nr);
 		v4l2_device_call_all(&hdw->v4l2_dev, 0, core, log_status);
 		pvr2_trace(PVR2_TRACE_INFO,"cx2341x config:");
 		cx2341x_log_status(&hdw->enc_ctl_state, "pvrusb2");
 		pvr2_hdw_state_log_state(hdw);
 		printk(KERN_INFO "pvrusb2: ==================  END STATUS CARD #%d  ==================\n", nr);
-	} while (0); LOCK_GIVE(hdw->big_lock);
+	} while (0);
+	LOCK_GIVE(hdw->big_lock);
 }
 
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-io.c b/drivers/media/usb/pvrusb2/pvrusb2-io.c
index 0c08f22bdfce..d860344de84e 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-io.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-io.c
@@ -514,12 +514,14 @@ void pvr2_stream_set_callback(struct pvr2_stream *sp,
 			      void *data)
 {
 	unsigned long irq_flags;
-	mutex_lock(&sp->mutex); do {
+	mutex_lock(&sp->mutex);
+	do {
 		spin_lock_irqsave(&sp->list_lock,irq_flags);
 		sp->callback_data = data;
 		sp->callback_func = func;
 		spin_unlock_irqrestore(&sp->list_lock,irq_flags);
-	} while(0); mutex_unlock(&sp->mutex);
+	} while(0);
+	mutex_unlock(&sp->mutex);
 }
 
 void pvr2_stream_get_stats(struct pvr2_stream *sp,
@@ -554,10 +556,12 @@ int pvr2_stream_set_buffer_count(struct pvr2_stream *sp,unsigned int cnt)
 {
 	int ret;
 	if (sp->buffer_target_count == cnt) return 0;
-	mutex_lock(&sp->mutex); do {
+	mutex_lock(&sp->mutex);
+	do {
 		sp->buffer_target_count = cnt;
 		ret = pvr2_stream_achieve_buffer_count(sp);
-	} while(0); mutex_unlock(&sp->mutex);
+	} while(0);
+	mutex_unlock(&sp->mutex);
 	return ret;
 }
 
@@ -590,7 +594,8 @@ int pvr2_stream_get_ready_count(struct pvr2_stream *sp)
 void pvr2_stream_kill(struct pvr2_stream *sp)
 {
 	struct pvr2_buffer *bp;
-	mutex_lock(&sp->mutex); do {
+	mutex_lock(&sp->mutex);
+	do {
 		pvr2_stream_internal_flush(sp);
 		while ((bp = pvr2_stream_get_ready_buffer(sp)) != NULL) {
 			pvr2_buffer_set_idle(bp);
@@ -598,7 +603,8 @@ void pvr2_stream_kill(struct pvr2_stream *sp)
 		if (sp->buffer_total_count != sp->buffer_target_count) {
 			pvr2_stream_achieve_buffer_count(sp);
 		}
-	} while(0); mutex_unlock(&sp->mutex);
+	} while(0);
+	mutex_unlock(&sp->mutex);
 }
 
 int pvr2_buffer_queue(struct pvr2_buffer *bp)
@@ -612,7 +618,8 @@ int pvr2_buffer_queue(struct pvr2_buffer *bp)
 	struct pvr2_stream *sp;
 	if (!bp) return -EINVAL;
 	sp = bp->stream;
-	mutex_lock(&sp->mutex); do {
+	mutex_lock(&sp->mutex);
+	do {
 		pvr2_buffer_wipe(bp);
 		if (!sp->dev) {
 			ret = -EIO;
@@ -636,7 +643,8 @@ int pvr2_buffer_queue(struct pvr2_buffer *bp)
 				  buffer_complete,
 				  bp);
 		usb_submit_urb(bp->purb,GFP_KERNEL);
-	} while(0); mutex_unlock(&sp->mutex);
+	} while(0);
+	mutex_unlock(&sp->mutex);
 	return ret;
 }
 
@@ -647,7 +655,8 @@ int pvr2_buffer_set_buffer(struct pvr2_buffer *bp,void *ptr,unsigned int cnt)
 	struct pvr2_stream *sp;
 	if (!bp) return -EINVAL;
 	sp = bp->stream;
-	mutex_lock(&sp->mutex); do {
+	mutex_lock(&sp->mutex);
+	do {
 		spin_lock_irqsave(&sp->list_lock,irq_flags);
 		if (bp->state != pvr2_buffer_state_idle) {
 			ret = -EPERM;
@@ -664,7 +673,8 @@ int pvr2_buffer_set_buffer(struct pvr2_buffer *bp,void *ptr,unsigned int cnt)
 				   bp->stream->i_bcount,bp->stream->i_count);
 		}
 		spin_unlock_irqrestore(&sp->list_lock,irq_flags);
-	} while(0); mutex_unlock(&sp->mutex);
+	} while(0);
+	mutex_unlock(&sp->mutex);
 	return ret;
 }
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-ioread.c b/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
index cd995b54732e..614d55767a4e 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
@@ -205,7 +205,8 @@ int pvr2_ioread_setup(struct pvr2_ioread *cp,struct pvr2_stream *sp)
 	unsigned int idx;
 	struct pvr2_buffer *bp;
 
-	mutex_lock(&cp->mutex); do {
+	mutex_lock(&cp->mutex);
+	do {
 		if (cp->stream) {
 			pvr2_trace(PVR2_TRACE_START_STOP,
 				   "/*---TRACE_READ---*/"
@@ -235,7 +236,8 @@ int pvr2_ioread_setup(struct pvr2_ioread *cp,struct pvr2_stream *sp)
 			}
 			cp->stream = sp;
 		}
-	} while (0); mutex_unlock(&cp->mutex);
+	} while (0);
+	mutex_unlock(&cp->mutex);
 
 	return 0;
 }
@@ -245,13 +247,15 @@ int pvr2_ioread_set_enabled(struct pvr2_ioread *cp,int fl)
 	int ret = 0;
 	if ((!fl) == (!(cp->enabled))) return ret;
 
-	mutex_lock(&cp->mutex); do {
+	mutex_lock(&cp->mutex);
+	do {
 		if (fl) {
 			ret = pvr2_ioread_start(cp);
 		} else {
 			pvr2_ioread_stop(cp);
 		}
-	} while (0); mutex_unlock(&cp->mutex);
+	} while (0);
+	mutex_unlock(&cp->mutex);
 	return ret;
 }
 
@@ -315,7 +319,8 @@ static void pvr2_ioread_filter(struct pvr2_ioread *cp)
 	// Search the stream for our synchronization key.  This is made
 	// complicated by the fact that in order to be honest with
 	// ourselves here we must search across buffer boundaries...
-	mutex_lock(&cp->mutex); while (1) {
+	mutex_lock(&cp->mutex);
+	while (1) {
 		// Ensure we have a buffer
 		if (!pvr2_ioread_get_buffer(cp)) break;
 		if (!cp->c_data_len) break;
@@ -362,7 +367,8 @@ static void pvr2_ioread_filter(struct pvr2_ioread *cp)
 		}
 
 		continue; // (for clarity)
-	} mutex_unlock(&cp->mutex);
+	}
+	mutex_unlock(&cp->mutex);
 }
 
 int pvr2_ioread_avail(struct pvr2_ioread *cp)
@@ -422,7 +428,8 @@ int pvr2_ioread_read(struct pvr2_ioread *cp,void __user *buf,unsigned int cnt)
 
 	cp->stream_running = !0;
 
-	mutex_lock(&cp->mutex); do {
+	mutex_lock(&cp->mutex);
+	do {
 
 		// Suck data out of the buffers and copy to the user
 		copied_cnt = 0;
@@ -480,7 +487,8 @@ int pvr2_ioread_read(struct pvr2_ioread *cp,void __user *buf,unsigned int cnt)
 			}
 		}
 
-	} while (0); mutex_unlock(&cp->mutex);
+	} while (0);
+	mutex_unlock(&cp->mutex);
 
 	if (!ret) {
 		if (copied_cnt) {
-- 
2.1.0

