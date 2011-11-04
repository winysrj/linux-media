Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:19683 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab1KDK63 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 06:58:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: UVC with continuous video buffers.
Date: Fri, 4 Nov 2011 11:58:26 +0100
Cc: javier Martin <javier.martin@vista-silicon.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <CACKLOr2CvPofCcveh6ReYuEbAzsq+z4hu12nza_pTwSceYtRkQ@mail.gmail.com> <CACKLOr3toejVFDgKzi+=KC6_O5qWaQxcwV6qc3zwK_r2H+mkNw@mail.gmail.com> <201111041141.28698.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111041141.28698.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111041158.26578.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 04 November 2011 11:41:28 Laurent Pinchart wrote:
> Hi Javier,
> 
> On Wednesday 02 November 2011 17:33:16 javier Martin wrote:
> > On 2 November 2011 17:12, Devin Heitmueller wrote:
> > > I've actually got a very similar issue and have been looking into it
> > > (an em28xx device on OMAP requiring contiguous physical memory for the
> > > hardware H.264 encoder).  One thing you may definitely want to check
> > 
> > > out is the patch sent earlier today with subject:
> > My case is a i.MX27 SoC with its internal H.264 encoder.
> > 
> > > [PATCH] media: vb2: vmalloc-based allocator user pointer handling
> > > 
> > > While that patch is intended for videobuf2, you might be able to copy
> > > the core logic into videobuf-vmalloc.
> > 
> > I've seen a recent patch by Laurent Pinchart which provides vb2 support
> > for UVC driver. It might also help:
> > 
> > [PATCH 2/2] uvcvideo: Use videobuf2-vmalloc
> 
> I've finally had time to work on that recently, so you should be able to
> get all the videobuf2 goodies for free :-)
> 
> However, the above patch that adds user pointer support in the videobuf2
> vmalloc-based allocator only supports memory backed by pages. If you
> contiguous buffer is in a memory area reserved by the system at boot time,
> the assumption will not be true. Supporting user pointers with no struct
> page backing is possible, but will require a new patch for vb2.

I'm a bit hesitant about this. If I understand correctly this is really 
something that should be solved through the buffer sharing work that
Sumit Semwal is working on.

What several drivers do today is to allow user pointers that point to
contiguous physical memory (using videobuf2-dma-contig.c). I've always
found that pretty ugly, though. The buffer sharing API should make this much
easier to handle, however, it is still in alpha stage.

Regards,

	Hans

> > > There are other drivers which use USERPTR provided buffers (which are
> > > allocated as contiguous memory from userland [i.e. vfpe_capture
> > > accepting buffers from cmemk on the OMAP platform]), but they
> > > typically do DMA so it's not really useful as an example where you
> > > have a USB based device.
> > > 
> > > If you get it working, by all means send the code to the ML so others
> > > can benefit.
> > 
> > Sure, though I will need some help because it seems some related
> > frameworks are not ready for what we want to achieve.
