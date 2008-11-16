Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAGJbvbT010385
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 14:37:57 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAGJbjhM006981
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 14:37:45 -0500
Date: Sun, 16 Nov 2008 20:37:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
In-Reply-To: <20081116123459.GA763@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0811162034360.16868@axis700.grange>
References: <Pine.LNX.4.64.0811160218190.21494@axis700.grange>
	<20081116123459.GA763@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [next] commit 5e6848813e6a236028263f8b1d6653d20a5f4d6e in next
 breaks compilation
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

On Sun, 16 Nov 2008, Russell King - ARM Linux wrote:

> On Sun, Nov 16, 2008 at 02:20:25AM +0100, Guennadi Liakhovetski wrote:
> > commit  breaks compilation of drivers/media/video/videobuf-dma-sg.c:
> > 
> >   CC [M]  drivers/media/video/videobuf-dma-sg.o
> > drivers/media/video/videobuf-dma-sg.c: In function 'videobuf_vm_fault':
> > drivers/media/video/videobuf-dma-sg.c:391: error: implicit declaration of function 'clear_user_page'
> 
> It would be better to convert videobuf-dma-sg.c to use clear_user_highpage
> instead, otherwise architectures need to provide this function just
> for this.

...and in the meantime the pxa-camera driver for the Quick Capture 
Interface is broken on PXA27x. Adding the V4L ML to cc and removing ARM.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
