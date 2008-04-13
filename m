Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3DFiGsa022347
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 11:44:16 -0400
Received: from web901.biz.mail.mud.yahoo.com (web901.biz.mail.mud.yahoo.com
	[216.252.100.41])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3DFi0lL005239
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 11:44:01 -0400
Date: Sun, 13 Apr 2008 17:43:55 +0200 (CEST)
From: Markus Rechberger <mrechberger@empiatech.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Video <video4linux-list@redhat.com>, Linux DVB <linux-dvb@linuxtv.org>
In-Reply-To: <20080413122844.53c5002b@areia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <454886.97234.qm@web901.biz.mail.mud.yahoo.com>
Cc: 
Subject: RE: [ANNOUNCE] Videobuf improvements to allow its usage with USB
	drivers
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


--- Mauro Carvalho Chehab <mchehab@infradead.org>
schrieb:

> 
> Videobuf Improvements for USB Devices
> =====================================
> 
> Videobuf history
> ================
> 
> If you are familiar with V4L and kernel development,
> you probably know that one
> of the hardest part of the driver is to control the
> video stream that arrives
> from the device, and need to be sent to an userspace
> application.
> 
> To address this task, a kernel module, called
> videobuf, is widely used for
> quite a long time at the PCI devices. 
> 
> However, previously, this driver were restricted to
> DMA devices. Specifically,
> it used to work only with PCI devices whose steams
> are provided via DMA, and
> for chipsets that supports scatter/gather mode. 
> 
> On scatter/gatter DMA mode, the data I/O is splitted
> into several small buffers.
> This worked fine for bttv, saa7134 and cx88 devices,
> whose PCI bridge is
> capable of handling such transfers.
> 
> However, due to their specific hardware
> restrictions, videobuf couldn't be used
> by USB devices. Due to that, each V4L USB driver had
> to implement their own
> buffering schema.
> 
> I've started some time ago a project to make
> videobuf more generic. In order to
> to that, videobuf were splitted into two files:
> 
> 	- videobuf-core - with core features, not specific
> to DMA or PCI;
> 	- videobuf-dma-sg - for PCI DMA scatter/gather
> devices.
> 
> After that, I've created another videobuf instance,
> called videobuf-vmalloc.
> 
> This one uses memory alloced with vmalloc_user().
> This is the same approach used
> by other USB drivers. The first test for the newer
> core driver were to port the
> virtual video driver (vivi) to work with it.
> 
> The videobuf split revealed several bad locks inside
> the driver.
> 
> Several developers helped to solve those issues,
> including: Brandon Philips,
> Nick Piggin, Jonathan Corbet, Trent Piepho,  Adrian
> Bunk and Andrew Morton.
> 
> Also, Guennadi Liakhovetski removed PCI specific
> details, on videobuf-dma-sg.
> Now, the same driver can also be used by other
> architectures that don't provide
> PCI interfaces, like ARM.
> 
> videobuf for USB devices
> ========================
> 
> The last round for the code improvement just
> happened this week: the conversion
> of em28xx to use videobuf.
> 
> This round happened thanks to the help of Aidan
> Thornton, that got a proposed
> patch I send him, and help me to fix and address
> several issues on this complex
> task.
> 
> So, the first USB driver that is working perfectly
> is available for testing at:
> 	http://linuxtv.org/hg/~mchehab/em28xx-vb
> 
> This driver were tested with several widely used
> userspace apps: tvtime,
> mplayer, xawtv and mythtv. It were also tested with
> the testing tool 
> v4l2-apps/test/code_example, available inside the
> tree.
> 
> I'll port the changesets soon to the master
> development trees.
> 
> The new approach has several advantages over the old
> one:
> 	- buffering code inside em28xx-video is now clean
> and easy to
> understand;
> 
> 	- the same buffering code can be easily ported to
> other USB drivers;
> 
> 	- by using the same videobuf code, all drivers will
> have the same
> behaviour. This will help userspace apps to be more
> independent of specific
> devices;
> 
> 	- the performance of the newer code is much more
> optimized than the
> previous code;
> 	
> 	- redundant streaming handling code is now inside
> V4L core;
> 
> 	- It is now easy to add overlay and userptr support
> for those drivers;
> 
> 	- It is now easy to use videobuf-dvb for USB
> devices also.
> 
> Things yet to be done
> =====================
> 
> 1) videobuf operating memory modes:
> 
> The old videobuf and the newvideobuf-dma-sg supports
> all streaming modes
> present at V4L1 and V4L2 API:
> 	VIDIOCMBUF;
> 	reading /dev/video?;
> 	kernel mmapped memory;
> 	userspace mmapped memory;
> 	overlay mode, to send video input streams directly
> into video adapter memory.
> 
> The new videobuf-vmalloc shares the same core stuff.
> However, it currently
> doesn't implement userspace mmapped memory or
> overlay mode. The other three
> modes are already supported. 
> 
> It doesn't seem to be hard to add the missing modes.
> Probably, the only
> function that will need more code is
> videobuf_iolock(). I've already started to
> code a patch to add userspace mmap. This may be
> useful to allow some userspace
> apps that relies on this method to work.
> 
> 2) videobuf-dvb
> 
> This driver allows using the same videobuf handling
> also for DVB devices. This
> driver works fine with videobuf-dma-sg.
> Theoretically, it should work fine also
> with USB drivers.
> 
> 3) tm6000
> 
> This is the first driver I've made to use videobuf.
> Unfortunately, the driver
> is loosing URB frames. I suspect that it is a
> hardware problem. I expect to
> finish this driver soon, since there are several new
> TV devices using this
> chipset.
> 
> 4) porting other usb drivers to use videobuf
> 
> This will help to cleanup their source code, and fix
> some API non-compliance.
> 
> 5) videobuf for non scatter/gather DMA
> 
> There are a few devices in the market that supports
> only contiguous DMA
> transfer. This is the case, for example of Marvel
> cafe chips, used on OLPC.
> 
> For those devices, it would be interesting to create
> a new videobuf module, and
> migrate them to this solution.
> 
> I'd like to thank all of you that helped with this
> development, and to the
> improvement of the Linux kernel support for video
> input devices.
> 
> APPENDIX: Performance tests of the both versions of
> em28xx driver
>
=================================================================
> 
> This is the performance tests I did, running
> code_example to get 1,000 frames
> @29.995 Hz (about 35 seconds of stream), tested on a
> i386 machine, running at
> 1,5GHz:
> 
> 

This sounds interesting, where can someone find this
code_example?

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
