Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab2HMWkO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 18:40:14 -0400
Message-ID: <50298248.2000609@redhat.com>
Date: Mon, 13 Aug 2012 19:40:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>, Jonathan Corbet <corbet@lwn.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] marvell-cam: Build fix: missing "select VIDEOBUF2_VMALLOC"
References: <87d36u9rzc.fsf@laptop.org> <20120427100358.4f5c2be7@lwn.net> <87fwbp86py.fsf@laptop.org>
In-Reply-To: <87fwbp86py.fsf@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon/Chris,

Em 27-04-2012 13:44, Chris Ball escreveu:
> Hi Jon,
> 
> On Fri, Apr 27 2012, Jonathan Corbet wrote:
>>> drivers/built-in.o: In function `mcam_v4l_open':
>>> /drivers/media/video/marvell-ccic/mcam-core.c:1565: undefined reference to `vb2_vmalloc_memops'
>>
>> This one is very strange.  If you look at mcam-core.h, you'll see it
>> shouldn't be trying to do anything with vmalloc unless the videobuf2 option
>> is already configured in.  I don't get this particular error, and I can't
>> quite see how you do...?
> 
> Ah, I ended up with a config that looked like:
> 
> CONFIG_VIDEO_V4L2=y
> CONFIG_VIDEOBUF2_CORE=y
> CONFIG_VIDEOBUF2_MEMOPS=y
> CONFIG_VIDEOBUF2_VMALLOC=m
> CONFIG_VIDEOBUF2_DMA_SG=y
> CONFIG_VIDEO_MMP_CAMERA=y
> 
> which means that "defined(CONFIG_VIDEOBUF2_VMALLOC_MODULE)" is true and
> MCAM_MODE_VMALLOC is 1, but the final kernel image will fail to link.
> 
> The code in mcam-core.h:
> 
> #if defined(CONFIG_VIDEOBUF2_VMALLOC) || defined(CONFIG_VIDEOBUF2_VMALLOC_MODULE)
> #define MCAM_MODE_VMALLOC 1
> #endif
> 
> #if defined(CONFIG_VIDEOBUF2_DMA_CONTIG) || defined(CONFIG_VIDEOBUF2_DMA_CONTIG_MODULE)
> #define MCAM_MODE_DMA_CONTIG 1
> #endif
> 
> #if defined(CONFIG_VIDEOBUF2_DMA_SG) || defined(CONFIG_VIDEOBUF2_DMA_SG_MODULE)
> #define MCAM_MODE_DMA_SG 1
> #endif
> 
> .. assumes that if any of these features are built as a module, the
> driver that uses them will be too.  This isn't a problem for the other
> features because the Kconfig selects them appropriately already.
> 
> Does that make sense?  Broken .config attached, testable against
> git://dev.laptop.org/olpc-kernel branch arm-3.3.  Thanks,
> 
> - Chris.

Ping?

Is this patch needed or not?

Another alternative would be to change the Kconfig stuff to explicitly select
the type of videobuf2 that would be used by those drivers, something like the
enclosed (untested) patch.

Regards,
Mauro

-
marvel-ccic: explicitly select the type of needed VB2 support

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
diff --git a/drivers/media/video/marvell-ccic/Kconfig b/drivers/media/video/marvell-ccic/Kconfig
index bf739e3..32c764f 100644
--- a/drivers/media/video/marvell-ccic/Kconfig
+++ b/drivers/media/video/marvell-ccic/Kconfig
@@ -21,3 +21,23 @@ config VIDEO_MMP_CAMERA
 	  processors (and likely beyond).  This is the controller found
 	  in OLPC XO 1.75 systems.
 
+menu
+	prompt "Memory access type for Marvell Cafe/Armada"
+	depends on VIDEO_MMP_CAMERA || VIDEO_CAFE_CCIC
+	help
+	  Select the type of memory access to be used by Marvell 88ALP01
+	  (Cafe) and Marvell Armada 610 drivers.
+
+config MARVELL_DMA_SG
+	bool "Allow DMA S/G"
+	select VIDEOBUF2_DMA_SG
+
+config MARVELL_DMA_CONTIG
+	bool "Allow DMA Contiguous"
+	select VIDEOBUF2_DMA_CONTIG
+
+config MARVELL_DMA_VMALLOC
+	bool "Allow virtual memory"
+	select VIDEOBUF2_VMALLOC
+
+endmenu
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index ce2b7b4..a7df4e3 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -37,7 +37,7 @@ static int frames;
 static int singles;
 static int delivered;
 
-#ifdef MCAM_MODE_VMALLOC
+#ifdef CONFIG_MARVELL_VMALLOC
 /*
  * Internal DMA buffer management.  Since the controller cannot do S/G I/O,
  * we must have physically contiguous buffers to bring frames into.
@@ -72,10 +72,10 @@ MODULE_PARM_DESC(dma_buf_size,
 		"The size of the allocated DMA buffers.  If actual operating "
 		"parameters require larger buffers, an attempt to reallocate "
 		"will be made.");
-#else /* MCAM_MODE_VMALLOC */
+#else /* CONFIG_MARVELL_VMALLOC */
 static const bool alloc_bufs_at_read = 0;
 static const int n_dma_bufs = 3;  /* Used by S/G_PARM */
-#endif /* MCAM_MODE_VMALLOC */
+#endif /* CONFIG_MARVELL_VMALLOC */
 
 static bool flip;
 module_param(flip, bool, 0444);
@@ -262,7 +262,7 @@ static void mcam_ctlr_stop(struct mcam_camera *cam)
 
 /* ------------------------------------------------------------------- */
 
-#ifdef MCAM_MODE_VMALLOC
+#ifdef CONFIG_MARVELL_VMALLOC
 /*
  * Code specific to the vmalloc buffer mode.
  */
@@ -405,7 +405,7 @@ static void mcam_vmalloc_done(struct mcam_camera *cam, int frame)
 	tasklet_schedule(&cam->s_tasklet);
 }
 
-#else /* MCAM_MODE_VMALLOC */
+#else /* CONFIG_MARVELL_VMALLOC */
 
 static inline int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
 {
@@ -424,10 +424,10 @@ static inline int mcam_check_dma_buffers(struct mcam_camera *cam)
 
 
 
-#endif /* MCAM_MODE_VMALLOC */
+#endif /* CONFIG_MARVELL_VMALLOC */
 
 
-#ifdef MCAM_MODE_DMA_CONTIG
+#ifdef CONFIG_MARVELL_DMA_CONTIG
 /* ---------------------------------------------------------------------- */
 /*
  * DMA-contiguous code.
@@ -491,9 +491,9 @@ static void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
 	mcam_set_contig_buffer(cam, frame);
 }
 
-#endif /* MCAM_MODE_DMA_CONTIG */
+#endif /* CONFIG_MARVELL_DMA_CONTIG */
 
-#ifdef MCAM_MODE_DMA_SG
+#ifdef CONFIG_MARVELL_DMA_SG
 /* ---------------------------------------------------------------------- */
 /*
  * Scatter/gather-specific code.
@@ -602,14 +602,14 @@ static void mcam_sg_restart(struct mcam_camera *cam)
 	clear_bit(CF_SG_RESTART, &cam->flags);
 }
 
-#else /* MCAM_MODE_DMA_SG */
+#else /* CONFIG_MARVELL_DMA_SG */
 
 static inline void mcam_sg_restart(struct mcam_camera *cam)
 {
 	return;
 }
 
-#endif /* MCAM_MODE_DMA_SG */
+#endif /* CONFIG_MARVELL_DMA_SG */
 
 /* ---------------------------------------------------------------------- */
 /*
@@ -1021,7 +1021,7 @@ static const struct vb2_ops mcam_vb2_ops = {
 };
 
 
-#ifdef MCAM_MODE_DMA_SG
+#ifdef CONFIG_MARVELL_DMA_SG
 /*
  * Scatter/gather mode uses all of the above functions plus a
  * few extras to deal with DMA mapping.
@@ -1096,7 +1096,7 @@ static const struct vb2_ops mcam_vb2_sg_ops = {
 	.wait_finish		= mcam_vb_wait_finish,
 };
 
-#endif /* MCAM_MODE_DMA_SG */
+#endif /* CONFIG_MARVELL_DMA_SG */
 
 static int mcam_setup_vb2(struct mcam_camera *cam)
 {
@@ -1108,7 +1108,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 	INIT_LIST_HEAD(&cam->buffers);
 	switch (cam->buffer_mode) {
 	case B_DMA_contig:
-#ifdef MCAM_MODE_DMA_CONTIG
+#ifdef CONFIG_MARVELL_DMA_CONTIG
 		vq->ops = &mcam_vb2_ops;
 		vq->mem_ops = &vb2_dma_contig_memops;
 		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev);
@@ -1118,7 +1118,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 #endif
 		break;
 	case B_DMA_sg:
-#ifdef MCAM_MODE_DMA_SG
+#ifdef CONFIG_MARVELL_DMA_SG
 		vq->ops = &mcam_vb2_sg_ops;
 		vq->mem_ops = &vb2_dma_sg_memops;
 		vq->io_modes = VB2_MMAP | VB2_USERPTR;
@@ -1127,7 +1127,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 #endif
 		break;
 	case B_vmalloc:
-#ifdef MCAM_MODE_VMALLOC
+#ifdef CONFIG_MARVELL_VMALLOC
 		tasklet_init(&cam->s_tasklet, mcam_frame_tasklet,
 				(unsigned long) cam);
 		vq->ops = &mcam_vb2_ops;
@@ -1145,7 +1145,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 static void mcam_cleanup_vb2(struct mcam_camera *cam)
 {
 	vb2_queue_release(&cam->vb_queue);
-#ifdef MCAM_MODE_DMA_CONTIG
+#ifdef CONFIG_MARVELL_DMA_CONTIG
 	if (cam->buffer_mode == B_DMA_contig)
 		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
 #endif
diff --git a/drivers/media/video/marvell-ccic/mcam-core.h b/drivers/media/video/marvell-ccic/mcam-core.h
index bd6acba..08ffc5e 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.h
+++ b/drivers/media/video/marvell-ccic/mcam-core.h
@@ -11,28 +11,6 @@
 #include <media/v4l2-dev.h>
 #include <media/videobuf2-core.h>
 
-/*
- * Create our own symbols for the supported buffer modes, but, for now,
- * base them entirely on which videobuf2 options have been selected.
- */
-#if defined(CONFIG_VIDEOBUF2_VMALLOC) || defined(CONFIG_VIDEOBUF2_VMALLOC_MODULE)
-#define MCAM_MODE_VMALLOC 1
-#endif
-
-#if defined(CONFIG_VIDEOBUF2_DMA_CONTIG) || defined(CONFIG_VIDEOBUF2_DMA_CONTIG_MODULE)
-#define MCAM_MODE_DMA_CONTIG 1
-#endif
-
-#if defined(CONFIG_VIDEOBUF2_DMA_SG) || defined(CONFIG_VIDEOBUF2_DMA_SG_MODULE)
-#define MCAM_MODE_DMA_SG 1
-#endif
-
-#if !defined(MCAM_MODE_VMALLOC) && !defined(MCAM_MODE_DMA_CONTIG) && \
-	!defined(MCAM_MODE_DMA_SG)
-#error One of the videobuf buffer modes must be selected in the config
-#endif
-
-
 enum mcam_state {
 	S_NOTREADY,	/* Not yet initialized */
 	S_IDLE,		/* Just hanging around */
@@ -58,13 +36,13 @@ enum mcam_buffer_mode {
 static inline int mcam_buffer_mode_supported(enum mcam_buffer_mode mode)
 {
 	switch (mode) {
-#ifdef MCAM_MODE_VMALLOC
+#ifdef CONFIG_MARVELL_VMALLOC
 	case B_vmalloc:
 #endif
-#ifdef MCAM_MODE_DMA_CONTIG
+#ifdef CONFIG_MARVELL_DMA_CONTIG
 	case B_DMA_contig:
 #endif
-#ifdef MCAM_MODE_DMA_SG
+#ifdef CONFIG_MARVELL_DMA_SG
 	case B_DMA_sg:
 #endif
 		return 1;
@@ -123,7 +101,7 @@ struct mcam_camera {
 	int next_buf;			/* Next to consume (dev_lock) */
 
 	/* DMA buffers - vmalloc mode */
-#ifdef MCAM_MODE_VMALLOC
+#ifdef CONFIG_MARVELL_VMALLOC
 	unsigned int dma_buf_size;	/* allocated size */
 	void *dma_bufs[MAX_DMA_BUFS];	/* Internal buffer addresses */
 	dma_addr_t dma_handles[MAX_DMA_BUFS]; /* Buffer bus addresses */


