Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o7GHE2Ql004737
	for <video4linux-list@redhat.com>; Mon, 16 Aug 2010 13:14:02 -0400
Received: from g-noc.net (ip-209-172-57-244.static.privatedns.com
	[209.172.57.244])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o7GHDqK1027139
	for <video4linux-list@redhat.com>; Mon, 16 Aug 2010 13:13:52 -0400
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by g-noc.net (Postfix) with ESMTP id C53F6846547
	for <video4linux-list@redhat.com>; Mon, 16 Aug 2010 13:13:01 -0400 (EDT)
Message-ID: <4C6971CE.1040802@usherbrooke.ca>
Date: Mon, 16 Aug 2010 13:13:50 -0400
From: Laurent Birtz <laurent.birtz@usherbrooke.ca>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: [PATCH] bttv driver memory corruption
Content-Type: multipart/mixed; boundary="------------030307010809090204080803"
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Errors-To: video4linux-list-bounces@redhat.com
Sender: Mauro Carvalho Chehab <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.
--------------030307010809090204080803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

here is a bug report for the bttv driver and tentative patches to solve
the problem. Two bugs are addressed, a memory corruption of random
kernel pages and a race condition in the DMA RISC code.

I couldn't get checkpatch.pl to work so the patches are in plain 'hg
diff' format.

The card I am using is Osprey 440, Bt878 (rev 17).

I have tested my patches on kernel 2.6.18-164.el5 (RHEL 5) which is the
kernel on my target production machines. The V4L2_MEMORY_USERPTR method
was not tested as I don't have the proper support functions in this
kernel; I also don't know how to reliably allocate physically contiguous
DMA32 memory in user space.

I have checked that VBI capture doesn't crash the kernel but not that it
works correctly. I haven't tested the capture of only a single field,
odd or even.

I've used the driver code revision ee9826bc7106 (hg). The stable tip
crashes my kernel on module load and I don't have the resources to
investigate this problem at this time.


Memory corruption:

The bt878 chipset has a hardware limitation on the buffers used to
capture a line. Quote from the specification:

"The target memory for a given scan line of data is assumed to be
linear, incrementing, and contiguous. For a 1024-pixel scan line a
maximum of 4 KB of contiguous physical memory is required. Each scan
line can be stored anywhere in the 32-bit address space. A scan line can
be broken into segments with each segment sent to a different target
area. An image buffer can be allocated to line fragments anywhere in the
physical memory, as the line sequence is arbitrary."

The fourth sentence seems to directly contradict the first but it
appears that the first sentence is true. I've observed a memory
corruption by allocating a single buffer twice as large as necessary,
dividing it into pages and poisoning all of it. When the user memory
maps a buffer, I allocate every even page from the poisoned buffer in
the nopage fault handler.

Picture: A=Allocated, P=Poison, PoisonedBuffer=APAPAPAP...

I've observed that the poison was corrupted at some random pages, but
always in the first four bytes. The value of those bytes is 0x23232323.
This byte sequence often appears in kernel oops reports on my setup.

I dumped the content of the RISC write instructions and noticed that
while the corruptions are random, they always occur when the 'end of
line' bit of the write instructions is not set and the instructions
write data up to the end of a page. It looks like the DMA controller
gets confused when it needs to write to non-contiguous memory.

The first patch changes the use of scatter-gather buffers for a single
contiguous buffer. I have emulated the scatter-gather behavior in the
RISC subprogram setup code. Obviously the code can be made simpler when
a single buffer is used. As a side note, the code in bttv_risc_planar()
appears to choke if the number of bytes to write in 'todo' is not a
multiple of 4, due to the horizontal shift.

The use of line-based scatter-gather buffers does not seem appealing,
since it requires memory copies to present user-space with the
contiguous buffer that it expects.


RISC program synchronization:

All modifications to the main RISC program and its subprograms (i.e. the
RISC instructions that fill the content of a buffer) and to the card
registers are protected by a spinlock. However, the driver takes no
provision to avoid race conditions with the DMA controller itself.
Holding the spinlock or servicing an IRQ does not prevent the DMA
controller from executing RISC instructions. This leads to a race
condition that can crash the kernel.

The current RISC program loops over all its instructions continuously.
When a RISC interrupt is raised, the IRQ handler modifies the program,
without knowing which instruction the DMA controller is currently
executing. Usually, this will be the SYNC instruction for the odd field
as this stalls the DMA controller for a while.

If the IRQ handler is slow, which can happen when it waits on the
spinlock, then the DMA controller will re-execute a subprogram capturing
a field. The code tries to detect this situation with the is_active()
macro but this method is not reliable. In the case where the IRQ handler
dequeues a buffer while it is active, then a kernel crash can occur.
Assuming the application quits at this point, the function
bttv_dma_free() will find that the capture buffer is done and then free
the buffer containing the RISC instructions being executed by the DMA
controller.

The proposed fix modifies the driver to solve this race condition. The
implementation is kept as simple as possible and preserve the existing
synchronization logic. The code is not optimal for performance as it
needlessly causes an interrupt to be raised when both fields are being
captured with the same buffer. The code could also be made simpler by
reworking the logic.

The code uses gates to control the flow of execution of the RISC
program. A gate is a jump instruction that either jumps to itself (when
the gate is closed) or jumps to the next capture instructions (when the
gate is open). The IRQ handler uses two gates in alternance to
functionally stop the DMA controller when the RISC program is being
modified. When a RISC interrupt is raised, the IRQ handler verifies that
the DMA controller loops harmlessly on the closed gate, modifies the
RISC program, close the open gate, flush the memory and open the closed
gate.

Thank you,
Laurent Birtz

Signed-off-by: Laurent Birtz <laurent.birtz@usherbrooke.ca>


--------------030307010809090204080803
Content-Type: text/x-patch;
 name="bt878_contig.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bt878_contig.patch"

diff -r ee9826bc7106 linux/drivers/media/video/bt8xx/bttv-driver.c
--- a/linux/drivers/media/video/bt8xx/bttv-driver.c	Thu Apr 29 23:31:06 2010 -0300
+++ b/linux/drivers/media/video/bt8xx/bttv-driver.c	Tue Aug 03 09:09:58 2010 -0400
@@ -2403,7 +2403,7 @@
 	if (check_btres(fh, RESOURCE_OVERLAY)) {
 		struct bttv_buffer *new;
 
-		new = videobuf_sg_alloc(sizeof(*new));
+		new = videobuf_contig_alloc(sizeof(*new));
 		new->crop = btv->crop[!!fh->do_crop].rect;
 		bttv_overlay_risc(btv, &fh->ov, fh->ovfmt, new);
 		retval = bttv_switch_overlay(btv,fh,new);
@@ -2780,7 +2780,7 @@
 	mutex_lock(&fh->cap.vb_lock);
 	if (on) {
 		fh->ov.tvnorm = btv->tvnorm;
-		new = videobuf_sg_alloc(sizeof(*new));
+		new = videobuf_contig_alloc(sizeof(*new));
 		new->crop = btv->crop[!!fh->do_crop].rect;
 		bttv_overlay_risc(btv, &fh->ov, fh->ovfmt, new);
 	} else {
@@ -2854,7 +2854,7 @@
 		if (check_btres(fh, RESOURCE_OVERLAY)) {
 			struct bttv_buffer *new;
 
-			new = videobuf_sg_alloc(sizeof(*new));
+			new = videobuf_contig_alloc(sizeof(*new));
 			new->crop = btv->crop[!!fh->do_crop].rect;
 			bttv_overlay_risc(btv, &fh->ov, fh->ovfmt, new);
 			retval = bttv_switch_overlay(btv, fh, new);
@@ -3207,7 +3207,7 @@
 			/* need to capture a new frame */
 			if (locked_btres(fh->btv,RESOURCE_VIDEO_STREAM))
 				goto err;
-			fh->cap.read_buf = videobuf_sg_alloc(fh->cap.msize);
+			fh->cap.read_buf = videobuf_contig_alloc(fh->cap.msize);
 			if (NULL == fh->cap.read_buf)
 				goto err;
 			fh->cap.read_buf->memory = V4L2_MEMORY_USERPTR;
@@ -3270,18 +3270,18 @@
 	fh->ov.setup_ok = 0;
 	v4l2_prio_open(&btv->prio,&fh->prio);
 
-	videobuf_queue_sg_init(&fh->cap, &bttv_video_qops,
-			    &btv->c.pci->dev, &btv->s_lock,
-			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			    V4L2_FIELD_INTERLACED,
-			    sizeof(struct bttv_buffer),
-			    fh);
-	videobuf_queue_sg_init(&fh->vbi, &bttv_vbi_qops,
-			    &btv->c.pci->dev, &btv->s_lock,
-			    V4L2_BUF_TYPE_VBI_CAPTURE,
-			    V4L2_FIELD_SEQ_TB,
-			    sizeof(struct bttv_buffer),
-			    fh);
+	videobuf_queue_dma_contig_init(&fh->cap, &bttv_video_qops,
+				       &btv->c.pci->dev, &btv->s_lock,
+				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
+				       V4L2_FIELD_INTERLACED,
+				       sizeof(struct bttv_buffer),
+				       fh);
+	videobuf_queue_dma_contig_init(&fh->vbi, &bttv_vbi_qops,
+				       &btv->c.pci->dev, &btv->s_lock,
+				       V4L2_BUF_TYPE_VBI_CAPTURE,
+				       V4L2_FIELD_SEQ_TB,
+				       sizeof(struct bttv_buffer),
+				       fh);
 	set_tvnorm(btv,btv->tvnorm);
 	set_input(btv, btv->input, btv->tvnorm);
 
diff -r ee9826bc7106 linux/drivers/media/video/bt8xx/bttv-risc.c
--- a/linux/drivers/media/video/bt8xx/bttv-risc.c	Thu Apr 29 23:31:06 2010 -0300
+++ b/linux/drivers/media/video/bt8xx/bttv-risc.c	Tue Aug 03 09:09:58 2010 -0400
@@ -582,12 +582,9 @@
 void
 bttv_dma_free(struct videobuf_queue *q,struct bttv *btv, struct bttv_buffer *buf)
 {
-	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
-
 	BUG_ON(in_interrupt());
 	videobuf_waiton(&buf->vb,0,0);
-	videobuf_dma_unmap(q, dma);
-	videobuf_dma_free(dma);
+	videobuf_dma_contig_free(q, &buf->vb);
 	btcx_riscmem_free(btv->c.pci,&buf->bottom);
 	btcx_riscmem_free(btv->c.pci,&buf->top);
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
@@ -709,7 +706,16 @@
 bttv_buffer_risc(struct bttv *btv, struct bttv_buffer *buf)
 {
 	const struct bttv_tvnorm *tvnorm = bttv_tvnorms + buf->tvnorm;
-	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
+	struct videobuf_dma_contig_memory *dma =
+		videobuf_to_dma_contig_memory(&buf->vb);
+	struct scatterlist sglist;
+	
+	/* Create a one-entry scatter list for compatibility. */
+	sglist.page = virt_to_page(dma->vaddr);
+	sglist.offset = 0;
+	sglist.length = dma->size;
+	sglist.dma_address = dma->dma_handle;
+	sglist.dma_length = dma->size;
 
 	dprintk(KERN_DEBUG
 		"bttv%d: buffer field: %s  format: %s  size: %dx%d\n",
@@ -727,25 +733,25 @@
 
 		switch (buf->vb.field) {
 		case V4L2_FIELD_TOP:
-			bttv_risc_packed(btv,&buf->top,dma->sglist,
+			bttv_risc_packed(btv,&buf->top,&sglist,
 					 /* offset */ 0,bpl,
 					 /* padding */ 0,/* skip_lines */ 0,
 					 buf->vb.height);
 			break;
 		case V4L2_FIELD_BOTTOM:
-			bttv_risc_packed(btv,&buf->bottom,dma->sglist,
+			bttv_risc_packed(btv,&buf->bottom,&sglist,
 					 0,bpl,0,0,buf->vb.height);
 			break;
 		case V4L2_FIELD_INTERLACED:
-			bttv_risc_packed(btv,&buf->top,dma->sglist,
+			bttv_risc_packed(btv,&buf->top,&sglist,
 					 0,bpl,bpl,0,buf->vb.height >> 1);
-			bttv_risc_packed(btv,&buf->bottom,dma->sglist,
+			bttv_risc_packed(btv,&buf->bottom,&sglist,
 					 bpl,bpl,bpl,0,buf->vb.height >> 1);
 			break;
 		case V4L2_FIELD_SEQ_TB:
-			bttv_risc_packed(btv,&buf->top,dma->sglist,
+			bttv_risc_packed(btv,&buf->top,&sglist,
 					 0,bpl,0,0,buf->vb.height >> 1);
-			bttv_risc_packed(btv,&buf->bottom,dma->sglist,
+			bttv_risc_packed(btv,&buf->bottom,&sglist,
 					 bpf,bpl,0,0,buf->vb.height >> 1);
 			break;
 		default:
@@ -778,7 +784,7 @@
 			bttv_calc_geo(btv,&buf->geo,buf->vb.width,
 				      buf->vb.height,/* both_fields */ 0,
 				      tvnorm,&buf->crop);
-			bttv_risc_planar(btv, &buf->top, dma->sglist,
+			bttv_risc_planar(btv, &buf->top, &sglist,
 					 0,buf->vb.width,0,buf->vb.height,
 					 uoffset,voffset,buf->fmt->hshift,
 					 buf->fmt->vshift,0);
@@ -787,7 +793,7 @@
 			bttv_calc_geo(btv,&buf->geo,buf->vb.width,
 				      buf->vb.height,0,
 				      tvnorm,&buf->crop);
-			bttv_risc_planar(btv, &buf->bottom, dma->sglist,
+			bttv_risc_planar(btv, &buf->bottom, &sglist,
 					 0,buf->vb.width,0,buf->vb.height,
 					 uoffset,voffset,buf->fmt->hshift,
 					 buf->fmt->vshift,0);
@@ -800,14 +806,14 @@
 			ypadding = buf->vb.width;
 			cpadding = buf->vb.width >> buf->fmt->hshift;
 			bttv_risc_planar(btv,&buf->top,
-					 dma->sglist,
+					 &sglist,
 					 0,buf->vb.width,ypadding,lines,
 					 uoffset,voffset,
 					 buf->fmt->hshift,
 					 buf->fmt->vshift,
 					 cpadding);
 			bttv_risc_planar(btv,&buf->bottom,
-					 dma->sglist,
+					 &sglist,
 					 ypadding,buf->vb.width,ypadding,lines,
 					 uoffset+cpadding,
 					 voffset+cpadding,
@@ -823,7 +829,7 @@
 			ypadding = buf->vb.width;
 			cpadding = buf->vb.width >> buf->fmt->hshift;
 			bttv_risc_planar(btv,&buf->top,
-					 dma->sglist,
+					 &sglist,
 					 0,buf->vb.width,0,lines,
 					 uoffset >> 1,
 					 voffset >> 1,
@@ -831,7 +837,7 @@
 					 buf->fmt->vshift,
 					 0);
 			bttv_risc_planar(btv,&buf->bottom,
-					 dma->sglist,
+					 &sglist,
 					 lines * ypadding,buf->vb.width,0,lines,
 					 lines * ypadding + (uoffset >> 1),
 					 lines * ypadding + (voffset >> 1),
@@ -850,10 +856,10 @@
 		buf->vb.field = V4L2_FIELD_SEQ_TB;
 		bttv_calc_geo(btv,&buf->geo,tvnorm->swidth,tvnorm->sheight,
 			      1,tvnorm,&buf->crop);
-		bttv_risc_packed(btv, &buf->top,  dma->sglist,
+		bttv_risc_packed(btv, &buf->top,  &sglist,
 				 /* offset */ 0, RAW_BPL, /* padding */ 0,
 				 /* skip_lines */ 0, RAW_LINES);
-		bttv_risc_packed(btv, &buf->bottom, dma->sglist,
+		bttv_risc_packed(btv, &buf->bottom, &sglist,
 				 buf->vb.size/2 , RAW_BPL, 0, 0, RAW_LINES);
 	}
 
diff -r ee9826bc7106 linux/drivers/media/video/bt8xx/bttv-vbi.c
--- a/linux/drivers/media/video/bt8xx/bttv-vbi.c	Thu Apr 29 23:31:06 2010 -0300
+++ b/linux/drivers/media/video/bt8xx/bttv-vbi.c	Tue Aug 03 09:09:58 2010 -0400
@@ -151,14 +151,23 @@
 
 	if (redo_dma_risc) {
 		unsigned int bpl, padding, offset;
-		struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
+		struct videobuf_dma_contig_memory *dma =
+			videobuf_to_dma_contig_memory(&buf->vb);
+		struct scatterlist sglist;
+		
+		/* Create a one-entry scatter list for compatibility. */
+		sglist.page = virt_to_page(dma->vaddr);
+		sglist.offset = 0;
+		sglist.length = dma->size;
+		sglist.dma_address = dma->dma_handle;
+		sglist.dma_length = dma->size;
 
 		bpl = 2044; /* max. vbipack */
 		padding = VBI_BPL - bpl;
 
 		if (fh->vbi_fmt.fmt.count[0] > 0) {
 			rc = bttv_risc_packed(btv, &buf->top,
-					      dma->sglist,
+					      &sglist,
 					      /* offset */ 0, bpl,
 					      padding, skip_lines0,
 					      fh->vbi_fmt.fmt.count[0]);
@@ -170,7 +179,7 @@
 			offset = fh->vbi_fmt.fmt.count[0] * VBI_BPL;
 
 			rc = bttv_risc_packed(btv, &buf->bottom,
-					      dma->sglist,
+					      &sglist,
 					      offset, bpl,
 					      padding, skip_lines1,
 					      fh->vbi_fmt.fmt.count[1]);
diff -r ee9826bc7106 linux/drivers/media/video/bt8xx/bttvp.h
--- a/linux/drivers/media/video/bt8xx/bttvp.h	Thu Apr 29 23:31:06 2010 -0300
+++ b/linux/drivers/media/video/bt8xx/bttvp.h	Tue Aug 03 09:09:58 2010 -0400
@@ -40,7 +40,7 @@
 #include "compat.h"
 #include <media/v4l2-common.h>
 #include <linux/device.h>
-#include <media/videobuf-dma-sg.h>
+#include <media/videobuf-dma-contig.h>
 #include <media/tveeprom.h>
 #include <media/ir-common.h>
 
diff -r ee9826bc7106 linux/drivers/media/video/videobuf-dma-contig.c
--- a/linux/drivers/media/video/videobuf-dma-contig.c	Thu Apr 29 23:31:06 2010 -0300
+++ b/linux/drivers/media/video/videobuf-dma-contig.c	Tue Aug 03 09:09:58 2010 -0400
@@ -23,14 +23,6 @@
 #include <media/videobuf-dma-contig.h>
 #include "compat.h"
 
-struct videobuf_dma_contig_memory {
-	u32 magic;
-	void *vaddr;
-	dma_addr_t dma_handle;
-	unsigned long size;
-	int is_userptr;
-};
-
 #define MAGIC_DC_MEM 0x0733ac61
 #define MAGIC_CHECK(is, should)						    \
 	if (unlikely((is) != (should)))	{				    \
@@ -142,6 +134,10 @@
 static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
 					struct videobuf_buffer *vb)
 {
+/* TODO: Find out equivalent of follow_pfn for kernel 2.6.18. */
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 18)
+	return -EINVAL;
+#else
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long prev_pfn, this_pfn;
@@ -192,6 +188,7 @@
 	up_read(&current->mm->mmap_sem);
 
 	return ret;
+#endif
 }
 
 static void *__videobuf_alloc(size_t size)
@@ -435,6 +432,33 @@
 	.vmalloc      = __videobuf_to_vmalloc,
 };
 
+struct videobuf_dma_contig_memory *
+videobuf_to_dma_contig_memory(struct videobuf_buffer *buf)
+{
+	struct videobuf_dma_contig_memory *mem = buf->priv;
+	BUG_ON(!mem);
+
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	return mem;
+}
+
+EXPORT_SYMBOL_GPL(videobuf_to_dma_contig_memory);
+
+/* This is a kludge to allocate memory without a queue object. */
+void *videobuf_contig_alloc(size_t size)
+{
+        struct videobuf_queue q;
+
+        /* Required to make generic handler to call __videobuf_alloc */
+        q.int_ops = &qops;
+
+        q.msize = size;
+
+        return videobuf_alloc(&q);
+}
+EXPORT_SYMBOL_GPL(videobuf_contig_alloc);
+
 void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
 				    const struct videobuf_queue_ops *ops,
 				    struct device *dev,
diff -r ee9826bc7106 linux/include/media/videobuf-dma-contig.h
--- a/linux/include/media/videobuf-dma-contig.h	Thu Apr 29 23:31:06 2010 -0300
+++ b/linux/include/media/videobuf-dma-contig.h	Tue Aug 03 09:09:58 2010 -0400
@@ -16,6 +16,17 @@
 #include <linux/dma-mapping.h>
 #include <media/videobuf-core.h>
 
+struct videobuf_dma_contig_memory {
+	u32 magic;
+	void *vaddr;
+	dma_addr_t dma_handle;
+	unsigned long size;
+	int is_userptr;
+};
+
+struct videobuf_dma_contig_memory *
+videobuf_to_dma_contig_memory(struct videobuf_buffer *buf);
+void *videobuf_contig_alloc(size_t size);
 void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
 				    const struct videobuf_queue_ops *ops,
 				    struct device *dev,

--------------030307010809090204080803
Content-Type: text/x-patch;
 name="bt878_risc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bt878_risc.patch"

diff -r ee9826bc7106 linux/drivers/media/video/bt8xx/bttv-driver.c
--- a/linux/drivers/media/video/bt8xx/bttv-driver.c	Thu Apr 29 23:31:06 2010 -0300
+++ b/linux/drivers/media/video/bt8xx/bttv-driver.c	Tue Aug 03 12:22:20 2010 -0400
@@ -3999,7 +3999,6 @@
 	if (NULL == wakeup)
 		return;
 
-	spin_lock(&btv->s_lock);
 	btv->curr.top_irq = 0;
 	btv->curr.top = NULL;
 	bttv_risc_hook(btv, RISC_SLOT_O_FIELD, NULL, 0);
@@ -4008,7 +4007,6 @@
 	wakeup->vb.field_count = btv->field_count;
 	wakeup->vb.state = VIDEOBUF_DONE;
 	wake_up(&wakeup->vb.done);
-	spin_unlock(&btv->s_lock);
 }
 
 static inline int is_active(struct btcx_riscmem *risc, u32 rc)
@@ -4025,21 +4023,9 @@
 {
 	struct bttv_buffer_set new;
 	struct bttv_buffer_set old;
-	dma_addr_t rc;
-
-	spin_lock(&btv->s_lock);
 
 	/* new buffer set */
 	bttv_irq_next_video(btv, &new);
-	rc = btread(BT848_RISC_COUNT);
-	if ((btv->curr.top    && is_active(&btv->curr.top->top,       rc)) ||
-	    (btv->curr.bottom && is_active(&btv->curr.bottom->bottom, rc))) {
-		btv->framedrop++;
-		if (debug_latency)
-			bttv_irq_debug_low_latency(btv, rc);
-		spin_unlock(&btv->s_lock);
-		return;
-	}
 
 	/* switch over */
 	old = btv->curr;
@@ -4056,7 +4042,6 @@
 
 	/* wake up finished buffers */
 	bttv_irq_wakeup_video(btv, &old, &new, VIDEOBUF_DONE);
-	spin_unlock(&btv->s_lock);
 }
 
 static void
@@ -4064,24 +4049,11 @@
 {
 	struct bttv_buffer *new = NULL;
 	struct bttv_buffer *old;
-	u32 rc;
-
-	spin_lock(&btv->s_lock);
 
 	if (!list_empty(&btv->vcapture))
 		new = list_entry(btv->vcapture.next, struct bttv_buffer, vb.queue);
 	old = btv->cvbi;
 
-	rc = btread(BT848_RISC_COUNT);
-	if (NULL != old && (is_active(&old->top,    rc) ||
-			    is_active(&old->bottom, rc))) {
-		btv->framedrop++;
-		if (debug_latency)
-			bttv_irq_debug_low_latency(btv, rc);
-		spin_unlock(&btv->s_lock);
-		return;
-	}
-
 	/* switch */
 	btv->cvbi = new;
 	btv->loop_irq &= ~4;
@@ -4089,7 +4061,118 @@
 	bttv_set_dma(btv, 0);
 
 	bttv_irq_wakeup_vbi(btv, old, VIDEOBUF_DONE);
-	spin_unlock(&btv->s_lock);
+}
+
+/* Call the appropriate buffer switch handlers. */
+static void
+bttv_irq_handle_switch(struct bttv *btv, u32 flags)
+{
+	if (flags & 4) bttv_irq_switch_vbi(btv);
+	if (flags & 2) bttv_irq_wakeup_top(btv);
+	if (flags & 1) bttv_irq_switch_video(btv);
+}
+
+/* Called when a RISC instruction causes an interrupt. */
+static void
+bttv_irq_handle_risci(struct bttv *btv, u32 stat)
+{
+	unsigned long flags;
+	int loop_seen_flag = 0;
+	u32 closed_offset = btv->closed_gate ? 10 : 6;
+	u32 open_offset = btv->closed_gate ? 6 : 10;
+	u32 sync_type = 0;
+	dma_addr_t rc = btread(BT848_RISC_COUNT);
+	dma_addr_t expected_rc = btv->main.dma + (closed_offset << 2);
+	dma_addr_t hook_target = 0;
+	dma_addr_t landing_target = btv->main.dma + (open_offset << 2);
+	dma_addr_t closed_target = btv->main.dma;
+	
+        /* Check if the DMA controller is looping in the closed gate. */
+	if (rc < expected_rc || rc > expected_rc + (2 << 2)) {
+		btv->framedrop++;
+		if (debug_latency)
+			bttv_irq_debug_low_latency(btv, rc);
+		return;
+	}
+	
+	spin_lock_irqsave(&btv->s_lock,flags);
+	
+	/* Handle the requested buffer switches, if any. */
+	bttv_irq_handle_switch(btv, btv->cur_irq);
+	btv->cur_irq = 0;
+	
+        /* Loop until we find something to do. */
+	while (1) {
+		/* Pass to the next slot. */
+		btv->sub_slot = (btv->sub_slot + 1) % 5;
+		
+		/* We are no longer synchronized when we pass those slots. */
+		if (btv->sub_slot == RISC_SLOT_O_VBI ||
+		    btv->sub_slot == RISC_SLOT_E_VBI) {
+			btv->field_sync = 0;
+		}
+		
+                /* We're reached the loop IRQ slot. This is used by the code
+                 * outside the IRQ handler to tell us that we need to start
+                 * capturing buffers.
+                 */
+		if (btv->sub_slot == RISC_SLOT_LOOP) {
+			
+                        /* If we don't have anything to do, the DMA should shut
+                         * down soon. Insert a dummy sync instruction for the
+                         * odd field and set the hook target to the landing pad.
+                         */
+			if (loop_seen_flag) {
+				sync_type = BT848_FIFO_STATUS_VRE;
+				hook_target = btv->main.dma + (4 << 2);
+				break;
+			}
+			
+			loop_seen_flag = 1;
+			bttv_irq_handle_switch(btv, btv->loop_irq);
+		}
+		
+		/* We have a valid subprogram. */
+		else if (btv->sub_addr[btv->sub_slot] != NULL) {
+			if (!btv->field_sync) {
+				btv->field_sync = 1;
+				sync_type = (btv->sub_slot == RISC_SLOT_O_VBI ||
+				             btv->sub_slot == RISC_SLOT_O_FIELD)
+					     ? BT848_FIFO_STATUS_VRE
+					     : BT848_FIFO_STATUS_VRO;
+			}
+			
+			hook_target = btv->sub_addr[btv->sub_slot]->dma;
+			btv->cur_irq = btv->sub_irq[btv->sub_slot];
+			break;
+		}
+	}
+	
+        /* Write the hook target and the landing pad target, close the open
+         * gate, write the sync instruction if needed and open the closed gate.
+         */
+	btv->main.cpu[3] = cpu_to_le32(hook_target);
+	btv->main.cpu[5] = cpu_to_le32(landing_target);
+	btv->main.cpu[open_offset + 1] = cpu_to_le32(landing_target);
+	
+	if (sync_type) {
+		btv->main.cpu[0] = cpu_to_le32(BT848_RISC_SYNC |
+		                               BT848_RISC_RESYNC |
+					       sync_type);
+	}
+	
+	else {
+		closed_target = btv->main.dma + (2 << 2);
+	}
+	
+	btv->closed_gate = !btv->closed_gate;
+
+	/* Flush memory before we open the gate. */
+	wmb();
+	btv->main.cpu[closed_offset + 1] = cpu_to_le32(closed_target);
+	wmb();
+	
+	spin_unlock_irqrestore(&btv->s_lock,flags);
 }
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
@@ -4153,14 +4236,9 @@
 			wake_up(&btv->i2c_queue);
 		}
 
-		if ((astat & BT848_INT_RISCI)  &&  (stat & (4<<28)))
-			bttv_irq_switch_vbi(btv);
-
-		if ((astat & BT848_INT_RISCI)  &&  (stat & (2<<28)))
-			bttv_irq_wakeup_top(btv);
-
-		if ((astat & BT848_INT_RISCI)  &&  (stat & (1<<28)))
-			bttv_irq_switch_video(btv);
+		if (astat & BT848_INT_RISCI) {
+			bttv_irq_handle_risci(btv, stat);
+		}
 
 		if ((astat & BT848_INT_HLOCK)  &&  btv->opt_automute)
 			audio_mute(btv, btv->mute);  /* trigger automute */
diff -r ee9826bc7106 linux/drivers/media/video/bt8xx/bttv-risc.c
--- a/linux/drivers/media/video/bt8xx/bttv-risc.c	Thu Apr 29 23:31:06 2010 -0300
+++ b/linux/drivers/media/video/bt8xx/bttv-risc.c	Tue Aug 03 12:22:20 2010 -0400
@@ -463,7 +463,6 @@
 void
 bttv_set_dma(struct bttv *btv, int override)
 {
-	unsigned long cmd;
 	int capctl;
 
 	btv->cap_ctl = 0;
@@ -484,23 +483,19 @@
 		 btv->cvbi         ? (unsigned long long)btv->cvbi->bottom.dma         : 0,
 		 btv->curr.bottom  ? (unsigned long long)btv->curr.bottom->bottom.dma  : 0);
 
-	cmd = BT848_RISC_JUMP;
-	if (btv->loop_irq) {
-		cmd |= BT848_RISC_IRQ;
-		cmd |= (btv->loop_irq  & 0x0f) << 16;
-		cmd |= (~btv->loop_irq & 0x0f) << 20;
-	}
 	if (btv->curr.frame_irq || btv->loop_irq || btv->cvbi) {
 		mod_timer(&btv->timeout, jiffies+BTTV_TIMEOUT);
 	} else {
 		del_timer(&btv->timeout);
 	}
-	btv->main.cpu[RISC_SLOT_LOOP] = cpu_to_le32(cmd);
 
 	btaor(capctl, ~0x0f, BT848_CAP_CTL);
 	if (capctl) {
 		if (btv->dma_on)
 			return;
+		btv->cur_irq = 0;
+		btv->sub_slot = RISC_SLOT_LOOP;
+		btv->field_sync = 0;
 		btwrite(btv->main.dma, BT848_RISC_STRT_ADD);
 		btor(3, BT848_GPIO_DMA_CTL);
 		btv->dma_on = 1;
@@ -523,59 +518,76 @@
 	dprintk(KERN_DEBUG "bttv%d: risc main @ %08Lx\n",
 		btv->c.nr,(unsigned long long)btv->main.dma);
 
+	/* Main RISC program for the DMA controller. Note that the DMA
+	 * controller keeps executing instructions even if we are in interrupt
+	 * context!
+	 */
+
+	/* Slot[0:1] holds a SYNC instruction for either the odd or the even
+	 * field. It is not used if the field synchronization has already been
+	 * done previously.
+	 */
 	btv->main.cpu[0] = cpu_to_le32(BT848_RISC_SYNC | BT848_RISC_RESYNC |
 				       BT848_FIFO_STATUS_VRE);
 	btv->main.cpu[1] = cpu_to_le32(0);
+
+	/* Slot[2:3] is the hook that holds a JUMP instruction to a subprogram
+	 * that captures a field. If there is no subprogram, the hook jumps
+	 * directly to the landing pad below. Otherwise, the subprogram jumps to
+	 * the landing pad when it is finished.
+	 */
 	btv->main.cpu[2] = cpu_to_le32(BT848_RISC_JUMP);
 	btv->main.cpu[3] = cpu_to_le32(btv->main.dma + (4<<2));
 
-	/* top field */
-	btv->main.cpu[4] = cpu_to_le32(BT848_RISC_JUMP);
+	/* Slot[4:5] is the landing pad that holds a JUMP instruction to one of
+	 * the two gates below. One gate is left open to "release" the DMA
+	 * controller and one gate is kept closed to "hold" the DMA controller
+	 * while we are modifying the RISC program. The landing pad points to
+	 * the closed gate when we release the DMA controller. We set the IRQ
+	 * flag to cause an interrupt when the closed gate is reached.
+	 */
+	btv->main.cpu[4] = cpu_to_le32(BT848_RISC_JUMP | BT848_RISC_IRQ);
 	btv->main.cpu[5] = cpu_to_le32(btv->main.dma + (6<<2));
+
+	/* Slot[6:7] and slot [10:11] hold a jump instruction whose target is
+	 * itself when the gate is closed, or either the sync or the hook jump
+	 * instruction when the gate is open. We leave an empty area between the
+	 * two instructions because the DMA controller sometimes reports bogus
+	 * PC values.
+	 */
 	btv->main.cpu[6] = cpu_to_le32(BT848_RISC_JUMP);
-	btv->main.cpu[7] = cpu_to_le32(btv->main.dma + (8<<2));
+	btv->main.cpu[7] = cpu_to_le32(btv->main.dma + (6<<2));
 
-	btv->main.cpu[8] = cpu_to_le32(BT848_RISC_SYNC | BT848_RISC_RESYNC |
-				       BT848_FIFO_STATUS_VRO);
-	btv->main.cpu[9] = cpu_to_le32(0);
+	/* No man's land. */
+	btv->main.cpu[8] = cpu_to_le32(BT848_RISC_JUMP);
+	btv->main.cpu[9] = 0;
 
-	/* bottom field */
 	btv->main.cpu[10] = cpu_to_le32(BT848_RISC_JUMP);
-	btv->main.cpu[11] = cpu_to_le32(btv->main.dma + (12<<2));
-	btv->main.cpu[12] = cpu_to_le32(BT848_RISC_JUMP);
-	btv->main.cpu[13] = cpu_to_le32(btv->main.dma + (14<<2));
+	btv->main.cpu[11] = cpu_to_le32(btv->main.dma + (10<<2));
 
-	/* jump back to top field */
-	btv->main.cpu[14] = cpu_to_le32(BT848_RISC_JUMP);
-	btv->main.cpu[15] = cpu_to_le32(btv->main.dma + (0<<2));
+	/* Flush memory. */
+	wmb();
 
 	return 0;
 }
 
+/* Hook/clear a RISC subprogram in the specified slot. */
 int
 bttv_risc_hook(struct bttv *btv, int slot, struct btcx_riscmem *risc,
 	       int irqflags)
 {
-	unsigned long cmd;
-	unsigned long next = btv->main.dma + ((slot+2) << 2);
+	btv->sub_addr[slot] = risc;
+	btv->sub_irq[slot] = irqflags;
 
-	if (NULL == risc) {
-		d2printk(KERN_DEBUG "bttv%d: risc=%p slot[%d]=NULL\n",
-			 btv->c.nr,risc,slot);
-		btv->main.cpu[slot+1] = cpu_to_le32(next);
-	} else {
-		d2printk(KERN_DEBUG "bttv%d: risc=%p slot[%d]=%08Lx irq=%d\n",
-			 btv->c.nr,risc,slot,(unsigned long long)risc->dma,irqflags);
-		cmd = BT848_RISC_JUMP;
-		if (irqflags) {
-			cmd |= BT848_RISC_IRQ;
-			cmd |= (irqflags  & 0x0f) << 16;
-			cmd |= (~irqflags & 0x0f) << 20;
-		}
-		risc->jmp[0] = cpu_to_le32(cmd);
-		risc->jmp[1] = cpu_to_le32(next);
-		btv->main.cpu[slot+1] = cpu_to_le32(risc->dma);
+	if (risc) {
+		/* Jump to landing pad. */
+		risc->jmp[0] = cpu_to_le32(BT848_RISC_JUMP);
+		risc->jmp[1] = cpu_to_le32(btv->main.dma + (4 << 2));
+
+		/* Flush memory. */
+		wmb();
 	}
+
 	return 0;
 }
 
diff -r ee9826bc7106 linux/drivers/media/video/bt8xx/bttvp.h
--- a/linux/drivers/media/video/bt8xx/bttvp.h	Thu Apr 29 23:31:06 2010 -0300
+++ b/linux/drivers/media/video/bt8xx/bttvp.h	Tue Aug 03 12:22:20 2010 -0400
@@ -58,11 +58,11 @@
 #define FORMAT_FLAGS_RAW          0x08
 #define FORMAT_FLAGS_CrCb         0x10
 
-#define RISC_SLOT_O_VBI        4
-#define RISC_SLOT_O_FIELD      6
-#define RISC_SLOT_E_VBI       10
-#define RISC_SLOT_E_FIELD     12
-#define RISC_SLOT_LOOP        14
+#define RISC_SLOT_O_VBI        0
+#define RISC_SLOT_O_FIELD      1
+#define RISC_SLOT_E_VBI        2
+#define RISC_SLOT_E_FIELD      3
+#define RISC_SLOT_LOOP         4
 
 #define RESOURCE_OVERLAY       1
 #define RESOURCE_VIDEO_STREAM  2
@@ -428,6 +428,24 @@
 	struct bttv_buffer      *cvbi;      /* active vbi buffer   */
 	int                     loop_irq;
 	int                     new_input;
+	int                     closed_gate; /* ID (0 or 1) of the gate in the  
+						main RISC program that is  
+						currently closed. */ 
+	struct btcx_riscmem    *sub_addr[4]; /* Address of the capture RISC  
+						subprograms. */ 
+	int                     sub_irq[4];  /* IRQ flags of the capture 
+						RISC subprograms. */ 
+	int                     cur_irq;     /* IRQ flags that have been set for 
+						the current slot. */ 
+	int                     sub_slot;    /* Current subprogram being 
+						executed. 
+						0: VBI top. 
+						1: Video top. 
+						2: VBI bottom. 
+						3: Video bottom. 
+						4: IRQ loop scheduling. */ 
+	int                     field_sync;  /* True if the current field 
+						has been synchronized. */ 
 
 	unsigned long cap_ctl;
 	unsigned long dma_on;

--------------030307010809090204080803
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------030307010809090204080803--
