Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55921 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750935AbZEEOAR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2009 10:00:17 -0400
Date: Tue, 5 May 2009 16:00:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Agustin <gatoguan-os@yahoo.com>
cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: soc-camera: timing out during capture - Re: Testing latest
 mx3_camera.c
In-Reply-To: <320049.73706.qm@web32101.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0905051544110.4568@axis700.grange>
References: <486508.99603.qm@web32101.mail.mud.yahoo.com>
 <Pine.LNX.4.64.0904132136030.1587@axis700.grange> <504448.15739.qm@web32106.mail.mud.yahoo.com>
 <Pine.LNX.4.64.0905051412520.4568@axis700.grange> <320049.73706.qm@web32101.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 5 May 2009, Agustin wrote:

> No, as there is no driver_match_device() in 2.6.29 nor in my patched 
> version. How important is that?

No, sorry, forget it, that's not your problem.

> Meanwhile I noticed that IRQ 176 is being triggered, then discarded as 
> "unhandled" by ipu_idmac, who gives the message "IRQ on active buffer on 
> channel 7, active 0, ready 0, 0, current 0!" below...

Yes, and this is not good. If you look in drivers/dma/ipu/ipu_idmac.c 
idmac_interrupt() you'll see, that this message is printed when IDMAC 
produces an interrupt for a DMA buffer, but at the same time it says, that 
the buffer, that should have completed is still in use... I've seen a few 
of such inconsistencies, and up to now always managed to get rid of them 
in one or another way. But that should not be related to the conversion. 
Maybe your formats on the sensor and on the SoC do not match, verify that.

Thanks
Guennadi

> > > I am not sure where to look for the problem, so here is a debug dump in case 
> > you can
> > > point me in the right direction...
> > > 
> > > 
> > > root@SixCam:~ insmod sixcam.ko 
> > > sixcam_mod_init(): ok
> > > Sixcam TRIGGER on Sixcam board: ATA_CS0~MCU3_26
> > > sixcam_i2c_probe(): ok
> > > camera 0-0: mx3_camera: Set SENS_CONF to f00, rate 19523897
> > > sixcam_init(): initialized camera.
> > > camera 0-0: MX3 Camera driver attached to camera 0
> > > sixcam_video_probe(): probed camera.
> > > mx3-camera mx3-camera.0: soc_camera: Allocated video_device c6080a00
> > > sixcam_release(): ok
> > > camera 0-0: MX3 Camera driver detached from camera 0
> > > 
> > > root@SixCam:~ capture --bpp 8 --size 1536x1024
> > > mx3-camera.0: mx3_camera: requested bus width 8 bit: 0
> > > mx3-camera.0: mx3_camera: requested bus width 15 bit: 0
> > > mx3-camera.0: mx3_camera: requested bus width 10 bit: 0
> > > camera 0-0: soc_camera: Found 0 supported formats.
> > > mx3-camera.0: mx3_camera: requested bus width 8 bit: 0
> > > mx3-camera.0: mx3_camera: Providing format Monochrome 8 bit in pass-through 
> > mode
> > > mx3-camera.0: mx3_camera: requested bus width 15 bit: 0
> > > mx3-camera.0: mx3_camera: Providing format Monochrome 16 bit in pass-through 
> > mode
> > > mx3-camera.0: mx3_camera: requested bus width 10 bit: 0
> > > mx3-camera.0: mx3_camera: Providing format Sixcam 10-bit in pass-through mode
> > > camera 0-0: mx3_camera: Set SENS_CONF to f00, rate 19523897
> > > sixcam_init(): initialized camera.
> > > camera 0-0: MX3 Camera driver attached to camera 0
> > > camera 0-0: soc_camera: camera device open
> > > sixcam_set_fmt(): 640x480+0+0
> > > sixcam_try_fmt(): icd->width=640 icd->height=480 fmt.pix.width=1536 
> > fmt.pix.height=1024.
> > >     --> fmt.pix.width=1536 fmt.pix.height=1024.
> > > ipu-core: ipu_idmac: timeout = 0 * 10ms
> > > ipu-core: ipu_idmac: init channel = 7
> > > ipu-core: ipu_idmac: IDMAC_CONF 0x70, IC_CONF 0x0, IDMAC_CHA_EN 0x0, 
> > IDMAC_CHA_PRI 0x80, IDMAC_CHA_BUSY 0x0
> > > ipu-core: ipu_idmac: BUF0_RDY 0x0, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x0, 
> > TASKS_STAT 0x3
> > > dma dma0chan7: ipu_idmac: Found channel 0x7, irq 176
> > > sixcam_set_fmt(): 1536x1024+0+0
> > > camera 0-0: soc_camera: set width: 1536 height: 1024
> > > mx3-camera.0: mx3_camera: requested bus width 8 bit: 0
> > > mx3-camera.0: mx3_camera: Flags cam: 0x2695 host: 0xf0fd common: 0x2095
> > > sixcam_set_bus_param(): 0x2095
> > > mx3-camera.0: mx3_camera: Set SENS_CONF to 708
> > > VIDIOC_S_FMT: width 1536, heightcamera 0-0: soc_camera: soc_camera_reqbufs: 1
> > >  1024, pixelformat = 'GREY'
> > > mx3-camera.0: videobuf_dma_contig: __videobuf_mmap_free
> > > camera 0-0: soc_camera: mmap called, vma=0xc4f886e0
> > > mx3-camera.0: videobuf_dma_contig: __videobuf_mmap_mapper
> > > mx3-camera.0: videobuf_dma_contig: dma_alloc_coherent data is at addr c9000000 
> > (size 1572864)
> > > mx3-camera.0: videobuf_dma_contig: mmap c4fafec0: q=c8b63004 40147000-402c7000 
> > (180000) pgoff 00084000 buf 0
> > > mx3-camera.0: videobuf_dma_contig: vm_open c4fafec0 
> > [count=0,vma=40147000-402c7000]
> > > camera 0-0: soc_camera: vma start=0x40147000, size=1572864, ret=0
> > > mx3-camera.0: videobuf_dma_contig: __videobuf_iolock memory method MMAP
> > > camera 0-0: soc_camera: soc_camera_streamon
> > > sixcam_start_capture(): trigger on!
> > > ipu-core: ipu_idmac: write param mem - addr = 0x00010070, data = 0x00000000
> > > ipu-core: ipu_idmac: write param mem - addr = 0x00010071, data = 0x00004000
> > > ipu-core: ipu_idmac: write param mem - addr = 0x00010072, data = 0x00000000
> > > ipu-core: ipu_idmac: write param mem - addr = 0x00010073, data = 0xFF5FF000
> > > ipu-core: ipu_idmac: write param mem - addr = 0x00010074, data = 0x00000003
> > > ipu-core: ipu_idmac: write param mem - addr = 0x00010078, data = 0x84000000
> > > ipu-core: ipu_idmac: write param mem - addr = 0x00010079, data = 0x00000000
> > > ipu-core: ipu_idmac: write param mem - addr = 0x0001007A, data = 0x3E0E2FFB
> > > ipu-core: ipu_idmac: write param mem - addr = 0x0001007B, data = 0x00000002
> > > ipu-core: ipu_idmac: write param mem - addr = 0x0001007C, data = 0x00000000
> > > dma dma0chan7: ipu_idmac: Submitting sg c4e0772c
> > > dma dma0chan7: ipu_idmac: Updated sg c4e0772c on channel 0x7 buffer 0
> > > ipu-core: ipu_idmac: IDMAC_CONF 0x70, IC_CONF 0x0, IDMAC_CHA_EN 0x0, 
> > IDMAC_CHA_PRI 0x80, IDMAC_CHA_BUSY 0x0
> > > ipu-core: ipu_idmac: BUF0_RDY 0x80, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x0, 
> > TASKS_STAT 0x3
> > > ipu-core: ipu_idmac: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x80, 
> > IDMAC_CHA_PRI 0x80, IDMAC_CHA_BUSY 0x0
> > > ipu-core: ipu_idmac: BUF0_RDY 0x80, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x0, 
> > TASKS_STAT 0x3
> > > camera 0-0: mx3_camera: Submitted cookie 2 DMA 0x84000000
> > > dma dma0chan7: ipu_idmac: IDMAC irq 176, buf 0
> > > dma dma0chan7: ipu_idmac: IRQ on active buffer on channel 7, active 0, ready 
> > 0, 0, current 0!
> > > 
> > > [ ten seconds pass, and a lot of frames come out of my camera ]
> > > 
> > > capture: Select timeout. Exiting...
> > > mx3-camera.0: videobuf_dma_contig: vm_close c4fafec0 
> > [count=1,vma=40147000-402c7000]
> > > mx3-camera.0: videobuf_dma_contig: munmap c4fafec0 q=c8b63004
> > > camera 0-0: mx3_camera: Release active DMA 0x84000000 (state 3), queue not 
> > empty
> > > camera 0-0: mx3_camera: free_buffer (vb=0xc4e076c0) 0x40147000 1572864
> > > mx3-camera.0: videobuf_dma_contig: buf[0] freeing c9000000
> > > ipu-core: ipu_idmac: timeout = 0 * 10ms
> > > sixcam_release(): ok
> > > camera 0-0: MX3 Camera driver detached from camera 0
> > > camera 0-0: soc_camera: camera device close
> > > 
> > > Any clue?
> > > 
> > > BTW, this dump shows a few apparently unneeded calls to camera set_fmt() and 
> > get_bus_params().

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
