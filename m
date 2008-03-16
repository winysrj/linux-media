Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GEuLoF016100
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 10:56:21 -0400
Received: from mail.adaptivemethods.com (mail.adaptivemethods.com
	[209.101.146.201])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2GEtplp025020
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 10:55:51 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Date: Sun, 16 Mar 2008 10:55:44 -0400
Message-ID: <B419B1B79B23B94692AD5B9882ABF45E8E3B50@mail.adaptivemethods.com>
In-Reply-To: <39A5C52AB07C25479D8B28BA623F289E3C5721@mail.adaptivemethods.com>
From: "Kevin Kieffer" <kkieffer@adaptivemethods.com>
To: <video4linux-list@redhat.com>
Content-Transfer-Encoding: 8bit
Subject: RE: kernel oops in dma routines from videobuf_iolock,
	xscale arm architecture
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


I solved this problem and the camera works now.  I had to patch
dmabounce.c.  The oops is due to a NULL derference of dev->dma mask at
line 221:

212     struct dmabounce_device_info *device_info =
dev->archdata.dmabounce; 
213         dma_addr_t dma_addr; 
214         int needs_bounce = 0; 
215  
216         if (device_info) 
217                 DO_STATS ( device_info->map_op_count++ ); 
218  
219         dma_addr = virt_to_dma(dev, ptr); 
220  
221         if (dev->dma_mask) { 
222                 unsigned long mask = *dev->dma_mask; 
223                 unsigned long limit; 

The call to dev->dma_mask does not work when "dev" is NULL.  I replaced
this
line with:

    if (device_info && dev->dma_mask) {

similar to the if{} blocks below it.

That solved the problem and the camera driver works now.

Kevin



-----Original Message-----
From: Kevin Kieffer 
Sent: Thursday, March 13, 2008 12:14 PM
To: video4linux-list@redhat.com
Subject: kernel oops in dma routines from videobuf_iolock, xscale arm
architecture

Hello,
 
I'm new to the list and to video4linux as well.  I'm trying to integrate
a Sentech USB camera driver into an embedded xscale ARM board with the
2.6.11 kernel.  The driver isn't part of the mainline kernel.  The
driver is written for v4l2, and runs fine on an x86 PC.  
 
I'm getting an oops when trying to read data, in the function
map_single() from the following backtrace:
 
map_single() in arch/arm/common/dma_bounce.c
dma_map_sg() in arch/arm/common/dma_bounce.c
videobuf_dma_pci_map() in drivers/media/video/video-buf.c
videobuf_iolock() in drivers/media/video/video-buf.c
buffer_prepare() in SentechUSB.c

The buffer_prepare() call passes in a zero value for struct pci_dev *pci
to videobuf_iolock().  The driver developer tells me this is correct
when the device is not PCI-based.  The pci_dev pointer passes through to
the map_single() parameter "dev". This causes the following code in
map_single() to oops due to a null dereference:

if (dev->dma_mask) {
		unsigned long mask = *dev->dma_mask;

I've read on the list about decoupling videobuf from PCI in later
versions, though as I said this does work on my x86 PC running 2.6.11.
Looking for any suggestions for a fix.  Wondering if it could be as easy
as patching the videobuf code in this kernel with that from a newer
kernel?

Any suggestions are appreciated.

Thanks

-Kevin


 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
