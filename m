Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m28B0RMl018746
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 06:00:27 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m28Axp7T026924
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 05:59:51 -0500
Date: Sat, 8 Mar 2008 07:59:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Eric Thomas <ethomas@claranet.fr>
Message-ID: <20080308075929.3ccbd012@gaivota>
In-Reply-To: <47D24404.9050708@claranet.fr>
References: <47C40563.5000702@claranet.fr>
	<47D24404.9050708@claranet.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/YLqqM9MYllSTg4am/88/m07"
Cc: video4linux <video4linux-list@redhat.com>, g.liakhovetski@pengutronix.de,
	Brandon Philips <bphilips@suse.de>
Subject: Re: kernel oops since changeset e3b8fb8cc214
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--MP_/YLqqM9MYllSTg4am/88/m07
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, 08 Mar 2008 08:45:08 +0100
Eric Thomas <ethomas@claranet.fr> wrote:

> Eric Thomas wrote:
> > Hi all,
> > 
> > My box runs with kernel 2.6.24 + main v4l-dvb tree from HG.
> > The card is a Haupauge HVR-3000 running in analog mode only. No *dvd* 
> > module loaded.
> > Since this videobuf-dma-sg patch, I face kernel oops in several
> > situations.
> > These problems occur with real tv applications, but traces below come
> > from the capture_example binary from v4l2-apps/test.

Although I don't believe that this is related to the conversion to generic DMA
API.

Anyway, I'm enclosing a patch reverting the changeset. It is valuable if people
can test to revert this and see if the issue remains.

I suspect, however, that the bug is on some other place, and it is related to
some bad locking. It seems that STREAMOFF processing here interrupted by a
video buffer arrival, at IRQ code.

PS.: I'm c/c Brandon, since he is working on fixing a bad lock on videobuf_dma.

> > capture_example called without any argument, oopses when calling STREAMOFF:
> > 
> > BUG: unable to handle kernel NULL pointer dereference at virtual address 
> > 00000200
> > printing eip: c01077e0 *pde = 00000000
> > Oops: 0000 [#1] PREEMPT
> > Modules linked in: cx8800 compat_ioctl32 cx88_alsa cx88xx ir_common 
> > videobuf_dma_sg wm8775 tuner tda9887 tuner_simple tuner_types tveeprom 
> > btcx_risc videobuf_core videodev v4l2_common v4l1_compat i2c_dev rfcomm 
> > l2cap bluetooth it87 hwmon_vid sunrpc binfmt_misc fglrx(P) snd_intel8x0 
> > usb_storage snd_ac97_codec agpgart ac97_bus i2c_nforce2 ati_remote sg 
> > sata_nv uhci_hcd ohci_hcd ehci_hcd
> > 
> > Pid: 3490, comm: capture_example Tainted: P        (2.6.24 #1)
> > EIP: 0060:[<c01077e0>] EFLAGS: 00210206 CPU: 0
> > EIP is at dma_free_coherent+0x30/0xa0
> > EAX: 00200257 EBX: 00000001 ECX: f7206000 EDX: 00001880
> > ESI: f7206000 EDI: 00000200 EBP: f78a884c ESP: f70c0d6c
> >  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > Process capture_example (pid: 3490, ti=f70c0000 task=f7881560 
> > task.ti=f70c0000)
> > Stack: 00200046 00000000 f887672f 00000000 00000000 37206000 f7e3ff68 
> > f886e4b2
> >        37206000 f98cbbaf f98cb3bb f7e3ff00 f7e3ff84 f7c8ee4c 00200282 
> > f990cc26
> >        00000000 00000020 f7c8ee4c f8876517 f7c8ee4c f7e3fa80 00000002 
> > f7c8ee00
> > Call Trace:
> >  [<f887672f>] videobuf_waiton+0xdf/0x110 [videobuf_core]
> >  [<f886e4b2>] btcx_riscmem_free+0x42/0x90 [btcx_risc]
> >  [<f98cbbaf>] videobuf_dma_free+0x4f/0xa0 [videobuf_dma_sg]
> >  [<f98cb3bb>] videobuf_dma_unmap+0x2b/0x60 [videobuf_dma_sg]
> >  [<f990cc26>] cx88_free_buffer+0x46/0x60 [cx88xx]
> >  [<f8876517>] videobuf_queue_cancel+0x97/0xc0 [videobuf_core]
> >  [<f88765ca>] __videobuf_streamoff+0x1a/0x30 [videobuf_core]
> >  [<f8876638>] videobuf_streamoff+0x18/0x30 [videobuf_core]
> >  [<f98ed644>] vidioc_streamoff+0x44/0x60 [cx8800]
> >  [<f98ed600>] vidioc_streamoff+0x0/0x60 [cx8800]
> >  [<f8855933>] __video_do_ioctl+0xe83/0x3820 [videodev]
> >  [<c0200e90>] bit_cursor+0x350/0x5a0
> >  [<c02401ff>] n_tty_receive_buf+0x6ff/0xef0
> >  [<c024b9a2>] do_con_write+0xaa2/0x19e0
> >  [<c013fcb5>] find_lock_page+0x95/0xe0
> >  [<f88587ad>] video_ioctl2+0xbd/0x220 [videodev]
> >  [<c0118fd3>] release_console_sem+0x1c3/0x210
> >  [<c0115880>] __wake_up+0x50/0x90
> >  [<c023ad06>] tty_ldisc_deref+0x36/0x90
> >  [<c023ccde>] tty_write+0x1be/0x1d0
> >  [<c016d008>] do_ioctl+0x78/0x90
> >  [<c016d07c>] vfs_ioctl+0x5c/0x2b0
> >  [<c023cb20>] tty_write+0x0/0x1d0
> >  [<c016d30d>] sys_ioctl+0x3d/0x70
> >  [<c0102ace>] sysenter_past_esp+0x5f/0x85
> >  =======================
> > Code: ce 53 83 ec 10 85 c0 74 06 8b b8 e0 00 00 00 8d 42 ff bb ff ff ff 
> > ff c1 e8 0b 90 43 d1 e8 75 fb 9c 58 f6 c4 02 74 3d 85 ff 74 06 <8b> 17 
> > 39 d6 73 0f 83 c4 10 89 da 89 f0 5b 5e 5f e9 eb d7 03 00
> > EIP: [<c01077e0>] dma_free_coherent+0x30/0xa0 SS:ESP 0068:f70c0d6c
> > ---[ end trace d2e4ad244a27b1e7 ]---
> > 
> > capture_example called with "-r" (read calls) oopses much earlier and
> > twice. I can provide traces if useful.
> > 
> > I'm not skilled enough to fix it myself, but I can test patches.
> > 
> > Eric
> > 
> 
> Am'I the only one to face this problem ?
> It's clearly related to the changeset e3b8fb8cc214 (Convert
> videobuf-dma-sg to generic DMA API).
> I don't get how this could only affect my card but not the others.
> Maybe this code trigs a bug elsewhere ?
> 
> Any help is welcome.
> 
> Regards,
> Eric
> 




Cheers,
Mauro

--MP_/YLqqM9MYllSTg4am/88/m07
Content-Type: text/x-patch; name=revert_chaneset_e3b8fb8cc214.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=revert_chaneset_e3b8fb8cc214.patch

diff -r 35718f867121 linux/drivers/media/Kconfig
--- a/linux/drivers/media/Kconfig	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/Kconfig	Sat Mar 08 07:41:24 2008 -0300
@@ -160,7 +160,7 @@ config VIDEOBUF_GEN
 	tristate
 
 config VIDEOBUF_DMA_SG
-	depends on HAS_DMA
+	depends on PCI || ARCH_PXA
 	select VIDEOBUF_GEN
 	tristate
 
diff -r 35718f867121 linux/drivers/media/common/saa7146_vbi.c
--- a/linux/drivers/media/common/saa7146_vbi.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/common/saa7146_vbi.c	Sat Mar 08 07:41:24 2008 -0300
@@ -408,8 +408,8 @@ static int vbi_open(struct saa7146_dev *
 	fh->vbi_fmt.start[1] = 312;
 	fh->vbi_fmt.count[1] = 16;
 
-	videobuf_queue_sg_init(&fh->vbi_q, &vbi_qops,
-			    &dev->pci->dev, &dev->slock,
+	videobuf_queue_pci_init(&fh->vbi_q, &vbi_qops,
+			    dev->pci, &dev->slock,
 			    V4L2_BUF_TYPE_VBI_CAPTURE,
 			    V4L2_FIELD_SEQ_TB, // FIXME: does this really work?
 			    sizeof(struct saa7146_buf),
diff -r 35718f867121 linux/drivers/media/common/saa7146_video.c
--- a/linux/drivers/media/common/saa7146_video.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/common/saa7146_video.c	Sat Mar 08 07:41:24 2008 -0300
@@ -1411,8 +1411,8 @@ static int video_open(struct saa7146_dev
 	sfmt = format_by_fourcc(dev,fh->video_fmt.pixelformat);
 	fh->video_fmt.sizeimage = (fh->video_fmt.width * fh->video_fmt.height * sfmt->depth)/8;
 
-	videobuf_queue_sg_init(&fh->video_q, &video_qops,
-			    &dev->pci->dev, &dev->slock,
+	videobuf_queue_pci_init(&fh->video_q, &video_qops,
+			    dev->pci, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct saa7146_buf),
diff -r 35718f867121 linux/drivers/media/video/bt8xx/bttv-driver.c
--- a/linux/drivers/media/video/bt8xx/bttv-driver.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/video/bt8xx/bttv-driver.c	Sat Mar 08 07:41:24 2008 -0300
@@ -2413,7 +2413,7 @@ static int setup_window(struct bttv_fh *
 	if (check_btres(fh, RESOURCE_OVERLAY)) {
 		struct bttv_buffer *new;
 
-		new = videobuf_sg_alloc(sizeof(*new));
+		new = videobuf_pci_alloc(sizeof(*new));
 		new->crop = btv->crop[!!fh->do_crop].rect;
 		bttv_overlay_risc(btv, &fh->ov, fh->ovfmt, new);
 		retval = bttv_switch_overlay(btv,fh,new);
@@ -2801,7 +2801,7 @@ static int bttv_overlay(struct file *fil
 	mutex_lock(&fh->cap.vb_lock);
 	if (on) {
 		fh->ov.tvnorm = btv->tvnorm;
-		new = videobuf_sg_alloc(sizeof(*new));
+		new = videobuf_pci_alloc(sizeof(*new));
 		new->crop = btv->crop[!!fh->do_crop].rect;
 		bttv_overlay_risc(btv, &fh->ov, fh->ovfmt, new);
 	} else {
@@ -2875,7 +2875,7 @@ static int bttv_s_fbuf(struct file *file
 		if (check_btres(fh, RESOURCE_OVERLAY)) {
 			struct bttv_buffer *new;
 
-			new = videobuf_sg_alloc(sizeof(*new));
+			new = videobuf_pci_alloc(sizeof(*new));
 			new->crop = btv->crop[!!fh->do_crop].rect;
 			bttv_overlay_risc(btv, &fh->ov, fh->ovfmt, new);
 			retval = bttv_switch_overlay(btv, fh, new);
@@ -3225,7 +3225,7 @@ static unsigned int bttv_poll(struct fil
 			/* need to capture a new frame */
 			if (locked_btres(fh->btv,RESOURCE_VIDEO_STREAM))
 				goto err;
-			fh->cap.read_buf = videobuf_sg_alloc(fh->cap.msize);
+			fh->cap.read_buf = videobuf_pci_alloc(fh->cap.msize);
 			if (NULL == fh->cap.read_buf)
 				goto err;
 			fh->cap.read_buf->memory = V4L2_MEMORY_USERPTR;
@@ -3292,14 +3292,14 @@ static int bttv_open(struct inode *inode
 	fh->ov.setup_ok = 0;
 	v4l2_prio_open(&btv->prio,&fh->prio);
 
-	videobuf_queue_sg_init(&fh->cap, &bttv_video_qops,
-			    &btv->c.pci->dev, &btv->s_lock,
+	videobuf_queue_pci_init(&fh->cap, &bttv_video_qops,
+			    btv->c.pci, &btv->s_lock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct bttv_buffer),
 			    fh);
-	videobuf_queue_sg_init(&fh->vbi, &bttv_vbi_qops,
-			    &btv->c.pci->dev, &btv->s_lock,
+	videobuf_queue_pci_init(&fh->vbi, &bttv_vbi_qops,
+			    btv->c.pci, &btv->s_lock,
 			    V4L2_BUF_TYPE_VBI_CAPTURE,
 			    V4L2_FIELD_SEQ_TB,
 			    sizeof(struct bttv_buffer),
diff -r 35718f867121 linux/drivers/media/video/cx23885/cx23885-dvb.c
--- a/linux/drivers/media/video/cx23885/cx23885-dvb.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c	Sat Mar 08 07:41:24 2008 -0300
@@ -350,7 +350,7 @@ int cx23885_dvb_register(struct cx23885_
 
 	/* dvb stuff */
 	printk("%s: cx23885 based dvb card\n", dev->name);
-	videobuf_queue_sg_init(&port->dvb.dvbq, &dvb_qops, &dev->pci->dev, &port->slock,
+	videobuf_queue_pci_init(&port->dvb.dvbq, &dvb_qops, dev->pci, &port->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_TOP,
 			    sizeof(struct cx23885_buffer), port);
 	err = dvb_register(port);
diff -r 35718f867121 linux/drivers/media/video/cx23885/cx23885-video.c
--- a/linux/drivers/media/video/cx23885/cx23885-video.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/video/cx23885/cx23885-video.c	Sat Mar 08 07:41:24 2008 -0300
@@ -838,8 +838,8 @@ static int video_open(struct inode *inod
 	fh->height   = 240;
 	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 
-	videobuf_queue_sg_init(&fh->vidq, &cx23885_video_qops,
-			    &dev->pci->dev, &dev->slock,
+	videobuf_queue_pci_init(&fh->vidq, &cx23885_video_qops,
+			    dev->pci, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct cx23885_buffer),
diff -r 35718f867121 linux/drivers/media/video/cx88/cx88-alsa.c
--- a/linux/drivers/media/video/cx88/cx88-alsa.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-alsa.c	Sat Mar 08 07:41:24 2008 -0300
@@ -336,7 +336,7 @@ static int dsp_buffer_free(snd_cx88_card
 	BUG_ON(!chip->dma_size);
 
 	dprintk(2,"Freeing buffer\n");
-	videobuf_sg_dma_unmap(&chip->pci->dev, chip->dma_risc);
+	videobuf_pci_dma_unmap(chip->pci, chip->dma_risc);
 	videobuf_dma_free(chip->dma_risc);
 	btcx_riscmem_free(chip->pci,&chip->buf->risc);
 	kfree(chip->buf);
@@ -438,7 +438,7 @@ static int snd_cx88_hw_params(struct snd
 	BUG_ON(!chip->dma_size);
 	BUG_ON(chip->num_periods & (chip->num_periods-1));
 
-	buf = videobuf_sg_alloc(sizeof(*buf));
+	buf = videobuf_pci_alloc(sizeof(*buf));
 	if (NULL == buf)
 		return -ENOMEM;
 
@@ -449,14 +449,14 @@ static int snd_cx88_hw_params(struct snd
 	buf->vb.height = chip->num_periods;
 	buf->vb.size   = chip->dma_size;
 
-	dma = videobuf_to_dma(&buf->vb);
+	dma=videobuf_to_dma(&buf->vb);
 	videobuf_dma_init(dma);
 	ret = videobuf_dma_init_kernel(dma, PCI_DMA_FROMDEVICE,
 			(PAGE_ALIGN(buf->vb.size) >> PAGE_SHIFT));
 	if (ret < 0)
 		goto error;
 
-	ret = videobuf_sg_dma_map(&chip->pci->dev, dma);
+	ret = videobuf_pci_dma_map(chip->pci,dma);
 	if (ret < 0)
 		goto error;
 
diff -r 35718f867121 linux/drivers/media/video/cx88/cx88-blackbird.c
--- a/linux/drivers/media/video/cx88/cx88-blackbird.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-blackbird.c	Sat Mar 08 07:41:24 2008 -0300
@@ -1113,8 +1113,8 @@ static int mpeg_open(struct inode *inode
 	file->private_data = fh;
 	fh->dev      = dev;
 
-	videobuf_queue_sg_init(&fh->mpegq, &blackbird_qops,
-			    &dev->pci->dev, &dev->slock,
+	videobuf_queue_pci_init(&fh->mpegq, &blackbird_qops,
+			    dev->pci, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct cx88_buffer),
diff -r 35718f867121 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Sat Mar 08 07:41:24 2008 -0300
@@ -909,8 +909,8 @@ static int cx8802_dvb_probe(struct cx880
 
 	/* dvb stuff */
 	printk(KERN_INFO "%s/2: cx2388x based DVB/ATSC card\n", core->name);
-	videobuf_queue_sg_init(&dev->dvb.dvbq, &dvb_qops,
-			    &dev->pci->dev, &dev->slock,
+	videobuf_queue_pci_init(&dev->dvb.dvbq, &dvb_qops,
+			    dev->pci, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_TOP,
 			    sizeof(struct cx88_buffer),
diff -r 35718f867121 linux/drivers/media/video/cx88/cx88-video.c
--- a/linux/drivers/media/video/cx88/cx88-video.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-video.c	Sat Mar 08 07:41:24 2008 -0300
@@ -1017,14 +1017,14 @@ static int video_open(struct inode *inod
 	fh->height   = 240;
 	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 
-	videobuf_queue_sg_init(&fh->vidq, &cx8800_video_qops,
-			    &dev->pci->dev, &dev->slock,
+	videobuf_queue_pci_init(&fh->vidq, &cx8800_video_qops,
+			    dev->pci, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct cx88_buffer),
 			    fh);
-	videobuf_queue_sg_init(&fh->vbiq, &cx8800_vbi_qops,
-			    &dev->pci->dev, &dev->slock,
+	videobuf_queue_pci_init(&fh->vbiq, &cx8800_vbi_qops,
+			    dev->pci, &dev->slock,
 			    V4L2_BUF_TYPE_VBI_CAPTURE,
 			    V4L2_FIELD_SEQ_TB,
 			    sizeof(struct cx88_buffer),
diff -r 35718f867121 linux/drivers/media/video/saa7134/saa7134-alsa.c
--- a/linux/drivers/media/video/saa7134/saa7134-alsa.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-alsa.c	Sat Mar 08 07:41:24 2008 -0300
@@ -518,7 +518,7 @@ static int snd_card_saa7134_hw_params(st
 	/* release the old buffer */
 	if (substream->runtime->dma_area) {
 		saa7134_pgtable_free(dev->pci, &dev->dmasound.pt);
-		videobuf_sg_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+		videobuf_pci_dma_unmap(dev->pci, &dev->dmasound.dma);
 		dsp_buffer_free(dev);
 		substream->runtime->dma_area = NULL;
 	}
@@ -534,12 +534,12 @@ static int snd_card_saa7134_hw_params(st
 		return err;
 	}
 
-	if (0 != (err = videobuf_sg_dma_map(&dev->pci->dev, &dev->dmasound.dma))) {
+	if (0 != (err = videobuf_pci_dma_map(dev->pci, &dev->dmasound.dma))) {
 		dsp_buffer_free(dev);
 		return err;
 	}
 	if (0 != (err = saa7134_pgtable_alloc(dev->pci,&dev->dmasound.pt))) {
-		videobuf_sg_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+		videobuf_pci_dma_unmap(dev->pci, &dev->dmasound.dma);
 		dsp_buffer_free(dev);
 		return err;
 	}
@@ -548,7 +548,7 @@ static int snd_card_saa7134_hw_params(st
 						dev->dmasound.dma.sglen,
 						0))) {
 		saa7134_pgtable_free(dev->pci, &dev->dmasound.pt);
-		videobuf_sg_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+		videobuf_pci_dma_unmap(dev->pci, &dev->dmasound.dma);
 		dsp_buffer_free(dev);
 		return err;
 	}
@@ -584,7 +584,7 @@ static int snd_card_saa7134_hw_free(stru
 
 	if (substream->runtime->dma_area) {
 		saa7134_pgtable_free(dev->pci, &dev->dmasound.pt);
-		videobuf_sg_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+		videobuf_pci_dma_unmap(dev->pci, &dev->dmasound.dma);
 		dsp_buffer_free(dev);
 		substream->runtime->dma_area = NULL;
 	}
diff -r 35718f867121 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sat Mar 08 07:41:24 2008 -0300
@@ -910,8 +910,8 @@ static int dvb_init(struct saa7134_dev *
 	dev->ts.nr_bufs    = 32;
 	dev->ts.nr_packets = 32*4;
 	dev->dvb.name = dev->name;
-	videobuf_queue_sg_init(&dev->dvb.dvbq, &saa7134_ts_qops,
-			    &dev->pci->dev, &dev->slock,
+	videobuf_queue_pci_init(&dev->dvb.dvbq, &saa7134_ts_qops,
+			    dev->pci, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_ALTERNATE,
 			    sizeof(struct saa7134_buf),
diff -r 35718f867121 linux/drivers/media/video/saa7134/saa7134-empress.c
--- a/linux/drivers/media/video/saa7134/saa7134-empress.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-empress.c	Sat Mar 08 07:41:24 2008 -0300
@@ -450,8 +450,8 @@ static int empress_init(struct saa7134_d
 	printk(KERN_INFO "%s: registered device video%d [mpeg]\n",
 	       dev->name,dev->empress_dev->minor & 0x1f);
 
-	videobuf_queue_sg_init(&dev->empress_tsq, &saa7134_ts_qops,
-			    &dev->pci->dev, &dev->slock,
+	videobuf_queue_pci_init(&dev->empress_tsq, &saa7134_ts_qops,
+			    dev->pci, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_ALTERNATE,
 			    sizeof(struct saa7134_buf),
diff -r 35718f867121 linux/drivers/media/video/saa7134/saa7134-video.c
--- a/linux/drivers/media/video/saa7134/saa7134-video.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-video.c	Sat Mar 08 07:41:24 2008 -0300
@@ -1350,14 +1350,14 @@ static int video_open(struct inode *inod
 	fh->height   = 576;
 	v4l2_prio_open(&dev->prio,&fh->prio);
 
-	videobuf_queue_sg_init(&fh->cap, &video_qops,
-			    &dev->pci->dev, &dev->slock,
+	videobuf_queue_pci_init(&fh->cap, &video_qops,
+			    dev->pci, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct saa7134_buf),
 			    fh);
-	videobuf_queue_sg_init(&fh->vbi, &saa7134_vbi_qops,
-			    &dev->pci->dev, &dev->slock,
+	videobuf_queue_pci_init(&fh->vbi, &saa7134_vbi_qops,
+			    dev->pci, &dev->slock,
 			    V4L2_BUF_TYPE_VBI_CAPTURE,
 			    V4L2_FIELD_SEQ_TB,
 			    sizeof(struct saa7134_buf),
diff -r 35718f867121 linux/drivers/media/video/soc_camera.c
--- a/linux/drivers/media/video/soc_camera.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/video/soc_camera.c	Sat Mar 08 07:41:24 2008 -0300
@@ -229,7 +229,7 @@ static int soc_camera_open(struct inode 
 
 	/* We must pass NULL as dev pointer, then all pci_* dma operations
 	 * transform to normal dma_* ones. Do we need an irqlock? */
-	videobuf_queue_sg_init(&icf->vb_vidq, ici->vbq_ops, NULL, NULL,
+	videobuf_queue_pci_init(&icf->vb_vidq, ici->vbq_ops, NULL, NULL,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
 				ici->msize, icd);
 
diff -r 35718f867121 linux/drivers/media/video/videobuf-dma-sg.c
--- a/linux/drivers/media/video/videobuf-dma-sg.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/video/videobuf-dma-sg.c	Sat Mar 08 07:41:24 2008 -0300
@@ -1,5 +1,5 @@
 /*
- * helper functions for SG DMA video4linux capture buffers
+ * helper functions for PCI DMA video4linux capture buffers
  *
  * The functions expect the hardware being able to scatter gatter
  * (i.e. the buffers are not linear in physical memory, but fragmented
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 
-#include <linux/dma-mapping.h>
+#include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <linux/scatterlist.h>
@@ -43,7 +43,7 @@ static int debug;
 static int debug;
 module_param(debug, int, 0644);
 
-MODULE_DESCRIPTION("helper module to manage video4linux dma sg buffers");
+MODULE_DESCRIPTION("helper module to manage video4linux pci dma sg buffers");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
 MODULE_LICENSE("GPL");
 
@@ -120,10 +120,10 @@ videobuf_pages_to_sg(struct page **pages
 
 struct videobuf_dmabuf *videobuf_to_dma (struct videobuf_buffer *buf)
 {
-	struct videobuf_dma_sg_memory *mem = buf->priv;
-	BUG_ON(!mem);
+	struct videbuf_pci_sg_memory *mem=buf->priv;
+	BUG_ON (!mem);
 
-	MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
+	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
 
 	return &mem->dma;
 }
@@ -142,14 +142,9 @@ static int videobuf_dma_init_user_locked
 
 	dma->direction = direction;
 	switch (dma->direction) {
-	case DMA_FROM_DEVICE:
-		rw = READ;
-		break;
-	case DMA_TO_DEVICE:
-		rw = WRITE;
-		break;
-	default:
-		BUG();
+	case PCI_DMA_FROMDEVICE: rw = READ;  break;
+	case PCI_DMA_TODEVICE:   rw = WRITE; break;
+	default:                 BUG();
 	}
 
 	first = (data          & PAGE_MASK) >> PAGE_SHIFT;
@@ -222,8 +217,10 @@ int videobuf_dma_init_overlay(struct vid
 	return 0;
 }
 
-int videobuf_dma_map(struct videobuf_queue* q, struct videobuf_dmabuf *dma)
+int videobuf_dma_map(struct videobuf_queue* q,struct videobuf_dmabuf *dma)
 {
+	void                   *dev=q->dev;
+
 	MAGIC_CHECK(dma->magic,MAGIC_DMABUF);
 	BUG_ON(0 == dma->nr_pages);
 
@@ -249,7 +246,7 @@ int videobuf_dma_map(struct videobuf_que
 		return -ENOMEM;
 	}
 	if (!dma->bus_addr) {
-		dma->sglen = dma_map_sg(q->dev, dma->sglist,
+		dma->sglen = pci_map_sg(dev,dma->sglist,
 					dma->nr_pages, dma->direction);
 		if (0 == dma->sglen) {
 			printk(KERN_WARNING
@@ -263,26 +260,30 @@ int videobuf_dma_map(struct videobuf_que
 	return 0;
 }
 
-int videobuf_dma_sync(struct videobuf_queue *q, struct videobuf_dmabuf *dma)
+int videobuf_dma_sync(struct videobuf_queue *q,struct videobuf_dmabuf *dma)
 {
-	MAGIC_CHECK(dma->magic, MAGIC_DMABUF);
+	void                   *dev=q->dev;
+
+	MAGIC_CHECK(dma->magic,MAGIC_DMABUF);
 	BUG_ON(!dma->sglen);
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,5)
-	dma_sync_sg(q->dev, dma->sglist, dma->nr_pages, dma->direction);
+	pci_dma_sync_sg	(dev,dma->sglist,dma->nr_pages,dma->direction);
 #else
-	dma_sync_sg_for_cpu(q->dev, dma->sglist, dma->nr_pages, dma->direction);
+	pci_dma_sync_sg_for_cpu (dev,dma->sglist,dma->nr_pages,dma->direction);
 #endif
 	return 0;
 }
 
 int videobuf_dma_unmap(struct videobuf_queue* q,struct videobuf_dmabuf *dma)
 {
-	MAGIC_CHECK(dma->magic, MAGIC_DMABUF);
+	void                   *dev=q->dev;
+
+	MAGIC_CHECK(dma->magic,MAGIC_DMABUF);
 	if (!dma->sglen)
 		return 0;
 
-	dma_unmap_sg(q->dev, dma->sglist, dma->nr_pages, dma->direction);
+	pci_unmap_sg (dev,dma->sglist,dma->nr_pages,dma->direction);
 
 	kfree(dma->sglist);
 	dma->sglist = NULL;
@@ -310,28 +311,28 @@ int videobuf_dma_free(struct videobuf_dm
 	if (dma->bus_addr) {
 		dma->bus_addr = 0;
 	}
-	dma->direction = DMA_NONE;
+	dma->direction = PCI_DMA_NONE;
 	return 0;
 }
 
 /* --------------------------------------------------------------------- */
 
-int videobuf_sg_dma_map(struct device *dev, struct videobuf_dmabuf *dma)
+int videobuf_pci_dma_map(struct pci_dev *pci,struct videobuf_dmabuf *dma)
 {
 	struct videobuf_queue q;
 
-	q.dev = dev;
+	q.dev=pci;
 
-	return videobuf_dma_map(&q, dma);
+	return (videobuf_dma_map(&q,dma));
 }
 
-int videobuf_sg_dma_unmap(struct device *dev, struct videobuf_dmabuf *dma)
+int videobuf_pci_dma_unmap(struct pci_dev *pci,struct videobuf_dmabuf *dma)
 {
 	struct videobuf_queue q;
 
-	q.dev = dev;
+	q.dev=pci;
 
-	return videobuf_dma_unmap(&q, dma);
+	return (videobuf_dma_unmap(&q,dma));
 }
 
 /* --------------------------------------------------------------------- */
@@ -351,7 +352,7 @@ videobuf_vm_close(struct vm_area_struct 
 {
 	struct videobuf_mapping *map = vma->vm_private_data;
 	struct videobuf_queue *q = map->q;
-	struct videobuf_dma_sg_memory *mem;
+	struct videbuf_pci_sg_memory *mem;
 	int i;
 
 	dprintk(2,"vm_close %p [count=%d,vma=%08lx-%08lx]\n",map,
@@ -454,18 +455,18 @@ static struct vm_operations_struct video
 };
 
 /* ---------------------------------------------------------------------
- * SG handlers for the generic methods
+ * PCI handlers for the generic methods
  */
 
 /* Allocated area consists on 3 parts:
 	struct video_buffer
 	struct <driver>_buffer (cx88_buffer, saa7134_buf, ...)
-	struct videobuf_dma_sg_memory
+	struct videobuf_pci_sg_memory
  */
 
 static void *__videobuf_alloc(size_t size)
 {
-	struct videobuf_dma_sg_memory *mem;
+	struct videbuf_pci_sg_memory *mem;
 	struct videobuf_buffer *vb;
 
 	vb = kzalloc(size+sizeof(*mem),GFP_KERNEL);
@@ -488,10 +489,10 @@ static int __videobuf_iolock (struct vid
 {
 	int err,pages;
 	dma_addr_t bus;
-	struct videobuf_dma_sg_memory *mem = vb->priv;
+	struct videbuf_pci_sg_memory *mem=vb->priv;
 	BUG_ON(!mem);
 
-	MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
+	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
 
 	switch (vb->memory) {
 	case V4L2_MEMORY_MMAP:
@@ -500,14 +501,14 @@ static int __videobuf_iolock (struct vid
 			/* no userspace addr -- kernel bounce buffer */
 			pages = PAGE_ALIGN(vb->size) >> PAGE_SHIFT;
 			err = videobuf_dma_init_kernel( &mem->dma,
-							DMA_FROM_DEVICE,
+							PCI_DMA_FROMDEVICE,
 							pages );
 			if (0 != err)
 				return err;
 		} else if (vb->memory == V4L2_MEMORY_USERPTR) {
 			/* dma directly to userspace */
 			err = videobuf_dma_init_user( &mem->dma,
-						      DMA_FROM_DEVICE,
+						      PCI_DMA_FROMDEVICE,
 						      vb->baddr,vb->bsize );
 			if (0 != err)
 				return err;
@@ -518,7 +519,7 @@ static int __videobuf_iolock (struct vid
 			locking inversion, so don't take it here */
 
 			err = videobuf_dma_init_user_locked(&mem->dma,
-						      DMA_FROM_DEVICE,
+						      PCI_DMA_FROMDEVICE,
 						      vb->baddr, vb->bsize);
 			if (0 != err)
 				return err;
@@ -535,7 +536,7 @@ static int __videobuf_iolock (struct vid
 		 */
 		bus   = (dma_addr_t)(unsigned long)fbuf->base + vb->boff;
 		pages = PAGE_ALIGN(vb->size) >> PAGE_SHIFT;
-		err = videobuf_dma_init_overlay(&mem->dma, DMA_FROM_DEVICE,
+		err = videobuf_dma_init_overlay(&mem->dma,PCI_DMA_FROMDEVICE,
 						bus, pages);
 		if (0 != err)
 			return err;
@@ -543,7 +544,7 @@ static int __videobuf_iolock (struct vid
 	default:
 		BUG();
 	}
-	err = videobuf_dma_map(q, &mem->dma);
+	err = videobuf_dma_map(q,&mem->dma);
 	if (0 != err)
 		return err;
 
@@ -553,8 +554,8 @@ static int __videobuf_sync(struct videob
 static int __videobuf_sync(struct videobuf_queue *q,
 			   struct videobuf_buffer *buf)
 {
-	struct videobuf_dma_sg_memory *mem = buf->priv;
-	BUG_ON(!mem);
+	struct videbuf_pci_sg_memory *mem=buf->priv;
+	BUG_ON (!mem);
 	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
 
 	return	videobuf_dma_sync(q,&mem->dma);
@@ -577,7 +578,7 @@ static int __videobuf_mmap_mapper(struct
 static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 			 struct vm_area_struct *vma)
 {
-	struct videobuf_dma_sg_memory *mem;
+	struct videbuf_pci_sg_memory *mem;
 	struct videobuf_mapping *map;
 	unsigned int first,last,size,i;
 	int retval;
@@ -597,7 +598,7 @@ static int __videobuf_mmap_mapper(struct
 		if (NULL == q->bufs[first])
 			continue;
 		mem=q->bufs[first]->priv;
-		BUG_ON(!mem);
+		BUG_ON (!mem);
 		MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
 
 		if (V4L2_MEMORY_MMAP != q->bufs[first]->memory)
@@ -660,8 +661,8 @@ static int __videobuf_copy_to_user ( str
 				char __user *data, size_t count,
 				int nonblocking )
 {
-	struct videobuf_dma_sg_memory *mem = q->read_buf->priv;
-	BUG_ON(!mem);
+	struct videbuf_pci_sg_memory *mem=q->read_buf->priv;
+	BUG_ON (!mem);
 	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
 
 	/* copy to userspace */
@@ -679,8 +680,8 @@ static int __videobuf_copy_stream ( stru
 				int vbihack, int nonblocking )
 {
 	unsigned int  *fc;
-	struct videobuf_dma_sg_memory *mem = q->read_buf->priv;
-	BUG_ON(!mem);
+	struct videbuf_pci_sg_memory *mem=q->read_buf->priv;
+	BUG_ON (!mem);
 	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
 
 	if (vbihack) {
@@ -703,7 +704,7 @@ static int __videobuf_copy_stream ( stru
 	return count;
 }
 
-static struct videobuf_qtype_ops sg_ops = {
+static struct videobuf_qtype_ops pci_ops = {
 	.magic        = MAGIC_QTYPE_OPS,
 
 	.alloc        = __videobuf_alloc,
@@ -715,21 +716,21 @@ static struct videobuf_qtype_ops sg_ops 
 	.copy_stream  = __videobuf_copy_stream,
 };
 
-void *videobuf_sg_alloc(size_t size)
+void *videobuf_pci_alloc (size_t size)
 {
 	struct videobuf_queue q;
 
 	/* Required to make generic handler to call __videobuf_alloc */
-	q.int_ops = &sg_ops;
+	q.int_ops=&pci_ops;
 
-	q.msize = size;
+	q.msize=size;
 
-	return videobuf_alloc(&q);
+	return videobuf_alloc (&q);
 }
 
-void videobuf_queue_sg_init(struct videobuf_queue* q,
+void videobuf_queue_pci_init(struct videobuf_queue* q,
 			 struct videobuf_queue_ops *ops,
-			 struct device *dev,
+			 void *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
 			 enum v4l2_field field,
@@ -737,7 +738,7 @@ void videobuf_queue_sg_init(struct video
 			 void *priv)
 {
 	videobuf_queue_core_init(q, ops, dev, irqlock, type, field, msize,
-				 priv, &sg_ops);
+				 priv, &pci_ops);
 }
 
 /* --------------------------------------------------------------------- */
@@ -754,11 +755,11 @@ EXPORT_SYMBOL_GPL(videobuf_dma_unmap);
 EXPORT_SYMBOL_GPL(videobuf_dma_unmap);
 EXPORT_SYMBOL_GPL(videobuf_dma_free);
 
-EXPORT_SYMBOL_GPL(videobuf_sg_dma_map);
-EXPORT_SYMBOL_GPL(videobuf_sg_dma_unmap);
-EXPORT_SYMBOL_GPL(videobuf_sg_alloc);
+EXPORT_SYMBOL_GPL(videobuf_pci_dma_map);
+EXPORT_SYMBOL_GPL(videobuf_pci_dma_unmap);
+EXPORT_SYMBOL_GPL(videobuf_pci_alloc);
 
-EXPORT_SYMBOL_GPL(videobuf_queue_sg_init);
+EXPORT_SYMBOL_GPL(videobuf_queue_pci_init);
 
 /*
  * Local variables:
diff -r 35718f867121 linux/drivers/media/video/videobuf-vmalloc.c
--- a/linux/drivers/media/video/videobuf-vmalloc.c	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/drivers/media/video/videobuf-vmalloc.c	Sat Mar 08 07:41:24 2008 -0300
@@ -103,7 +103,7 @@ static struct vm_operations_struct video
 /* Allocated area consists on 3 parts:
 	struct video_buffer
 	struct <driver>_buffer (cx88_buffer, saa7134_buf, ...)
-	struct videobuf_dma_sg_memory
+	struct videobuf_pci_sg_memory
  */
 
 static void *__videobuf_alloc(size_t size)
diff -r 35718f867121 linux/include/media/videobuf-dma-sg.h
--- a/linux/include/media/videobuf-dma-sg.h	Sat Mar 08 06:50:17 2008 -0300
+++ b/linux/include/media/videobuf-dma-sg.h	Sat Mar 08 07:41:24 2008 -0300
@@ -1,5 +1,5 @@
 /*
- * helper functions for SG DMA video4linux capture buffers
+ * helper functions for PCI DMA video4linux capture buffers
  *
  * The functions expect the hardware being able to scatter gatter
  * (i.e. the buffers are not linear in physical memory, but fragmented
@@ -81,7 +81,7 @@ struct videobuf_dmabuf {
 	int                 direction;
 };
 
-struct videobuf_dma_sg_memory
+struct videbuf_pci_sg_memory
 {
 	u32                 magic;
 
@@ -103,11 +103,11 @@ int videobuf_dma_unmap(struct videobuf_q
 int videobuf_dma_unmap(struct videobuf_queue* q,struct videobuf_dmabuf *dma);
 struct videobuf_dmabuf *videobuf_to_dma (struct videobuf_buffer *buf);
 
-void *videobuf_sg_alloc(size_t size);
+void *videobuf_pci_alloc (size_t size);
 
-void videobuf_queue_sg_init(struct videobuf_queue* q,
+void videobuf_queue_pci_init(struct videobuf_queue* q,
 			 struct videobuf_queue_ops *ops,
-			 struct device *dev,
+			 void *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
 			 enum v4l2_field field,
@@ -117,6 +117,6 @@ void videobuf_queue_sg_init(struct video
 	/*FIXME: these variants are used only on *-alsa code, where videobuf is
 	 * used without queue
 	 */
-int videobuf_sg_dma_map(struct device *dev, struct videobuf_dmabuf *dma);
-int videobuf_sg_dma_unmap(struct device *dev, struct videobuf_dmabuf *dma);
+int videobuf_pci_dma_map(struct pci_dev *pci,struct videobuf_dmabuf *dma);
+int videobuf_pci_dma_unmap(struct pci_dev *pci,struct videobuf_dmabuf *dma);
 

--MP_/YLqqM9MYllSTg4am/88/m07
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/YLqqM9MYllSTg4am/88/m07--
