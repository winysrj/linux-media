Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:53556 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZFDJlm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2009 05:41:42 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH 3/9] dm355 ccdc module for vpfe capture driver
Date: Thu, 4 Jun 2009 11:41:37 +0200
Cc: Karicheri Muralidharan <m-karicheri2@ti.com>,
	linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1242412603-11390-1-git-send-email-m-karicheri2@ti.com> <A69FA2915331DC488A831521EAE36FE401354ECDB2@dlee06.ent.ti.com> <87y6sbo5mu.fsf@deeprootsystems.com>
In-Reply-To: <87y6sbo5mu.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041141.38255.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tuesday 02 June 2009 02:12:41 Kevin Hilman wrote:
> "Karicheri, Muralidharan" <m-karicheri2@ti.com> writes:
> > Thanks for reviewing this. I have not gone through all of your comments,
> > but would like to respond to the following one first. I will respond to
> > the rest as I do the rework.
> >
> > > I've had a quick look at the DM355 and DM6446 datasheets. The CCDC and
> > > VPSS registers share the same memory block. Can't you use a single
> > > resource ?
> > >
> > > One nice (and better in my opinion) solution would be to declare a
> > > structure with all the VPSS/CCDC registers as they are implemented in
> > > hardware and access the structure fields with __raw_read/write*. You
> > > would then store a single pointer only. Check
> > > arch/powerpc/include/asm/immap_cpm2.h for an example.
> >
> > I think, a better solution will be to move the vpss system module
> > part to the board specific file dm355.c or dm6446.c
>
> Just to clarify, the files you mention are SoC specific files, not
> board-specific files...
>
> > and export functions to configure them as needed by the different
> > drivers.
>
> My first reaction to this is... no.  I'm reluctant to have a bunch of
> driver specific hooks in the core davinci SoC specific code.  I'd much
> rather see this stuff kept along with the driver in drivers/media/*
> and abstracted as necessary there.

I agree with Kevin on this. arch/* is mostly meant for platform-specific 
infrastructure code. Device drivers should go in drivers/*. The 
VPSS/VPFE/CCDC/... abstraction should live in drivers/media/video/*. SoC-
specific code that can be shared between multiple drivers (I remember we 
discussed IRQ routing for instance) can go in arch/*.

> > The vpss has evolved quite a lot from DM6446 to DM355 to
> > DM365. Registers such as INTSEL and INTSTAT and others are
> > applicable to other modules as well, not just the ccdc module. The
> > VPBE and resizer drivers will need to configure them too. Also the
> > vpss system module features available in DM365 is much more than
> > that in DM355.

The VPBE and resizer modules will live in drivers/media/video/* as well 
(correct me if I'm wrong), so most abstraction can go there. INTSEL and 
INTSTAT could be handled in arch/*, but they're located in the ISP registers 
block, so I suppose they're only applicable to video-related modules.

> Based on this, it sounds to me that this driver needs to be broken up
> a little bit more and some of the shared pieces need to be abstracted
> out so they can be shared among the modules.
>
> > Interrupts line to ARM are programmable in DM365 vpss and multiple
> > vpss irq lines can be muxed to the ARM side. So I would imaging
> > functions enable/disable irq line to arm, clearing irq bits,
> > enabling various clocks etc can be done in a specific soc specific
> > file (dm355.c, dm365.c or dm6446.c) and can be exported for use in
> > specific drivers. I just want to get your feedback so that I can
> > make this change. With this change, there is no need to use
> > structures for holding register offsets as you have suggested.

I agree with that. Interrupt handling, clock routing and other SoC-specific 
infrastructure code that isn't module-dependent should live in arch/*.

Best regards,

Laurent Pinchart

