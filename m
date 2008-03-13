Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2DKmDMF022901
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 16:48:13 -0400
Received: from mail.adaptivemethods.com (mail.adaptivemethods.com
	[209.101.146.201])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2DKlkQO020246
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 16:47:46 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Date: Thu, 13 Mar 2008 16:47:39 -0400
Message-ID: <B419B1B79B23B94692AD5B9882ABF45E8E3917@mail.adaptivemethods.com>
From: "Kevin Kieffer" <kkieffer@adaptivemethods.com>
To: <video4linux-list@redhat.com>
Content-Transfer-Encoding: 8bit
Subject: kernel oops in dma routines from videobuf_iolock,
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
