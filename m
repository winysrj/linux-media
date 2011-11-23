Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55671 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab1KWNXU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 08:23:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: UVC with continuous video buffers.
Date: Wed, 23 Nov 2011 14:23:19 +0100
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <CACKLOr2CvPofCcveh6ReYuEbAzsq+z4hu12nza_pTwSceYtRkQ@mail.gmail.com> <201111041141.28698.laurent.pinchart@ideasonboard.com> <CACKLOr0jPK0Oi9yXzZ2Tk-1EM+Pava=qByGCqpT1nuxjmoNMXA@mail.gmail.com>
In-Reply-To: <CACKLOr0jPK0Oi9yXzZ2Tk-1EM+Pava=qByGCqpT1nuxjmoNMXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111231423.19700.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Thursday 17 November 2011 11:55:28 javier Martin wrote:
> On 4 November 2011 11:41, Laurent Pinchart wrote:
> > On Wednesday 02 November 2011 17:33:16 javier Martin wrote:
> >> On 2 November 2011 17:12, Devin Heitmueller wrote:
> >> > I've actually got a very similar issue and have been looking into it
> >> > (an em28xx device on OMAP requiring contiguous physical memory for the
> >> > hardware H.264 encoder).  One thing you may definitely want to check
> >> 
> >> > out is the patch sent earlier today with subject:
> >> My case is a i.MX27 SoC with its internal H.264 encoder.
> >> 
> >> > [PATCH] media: vb2: vmalloc-based allocator user pointer handling
> > 
> > However, the above patch that adds user pointer support in the videobuf2
> > vmalloc-based allocator only supports memory backed by pages. If you
> > contiguous buffer is in a memory area reserved by the system at boot
> > time, the assumption will not be true. Supporting user pointers with no
> > struct page backing is possible, but will require a new patch for vb2.
> 
> Hi Laurent,
> thanks for your help.
> 
> I am using dma_declare_coherent_memory() at startup to reserve memory.
> Then I use dma_alloc_coherent() in my driver through
> 'videobuf2-dma-contig.h' (emma-PrP I've recently submitted). I
> understand these functions provide memory backed by pages and you are
> referring to the case where you use the 'mem' argument of the kernel
> to leave memory unused. Am I right?

I think you're right, yes.

-- 
Regards,

Laurent Pinchart
