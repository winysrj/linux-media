Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f177.google.com ([209.85.222.177]:46817 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZFBAMp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2009 20:12:45 -0400
Received: by pzk7 with SMTP id 7so6294060pzk.33
        for <linux-media@vger.kernel.org>; Mon, 01 Jun 2009 17:12:47 -0700 (PDT)
To: "Karicheri\, Muralidharan" <m-karicheri2@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
	"linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source\@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 3/9] dm355 ccdc module for vpfe capture driver
References: <1242412603-11390-1-git-send-email-m-karicheri2@ti.com>
	<200905281518.18879.laurent.pinchart@skynet.be>
	<A69FA2915331DC488A831521EAE36FE401354ECDB2@dlee06.ent.ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Mon, 01 Jun 2009 17:12:41 -0700
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401354ECDB2@dlee06.ent.ti.com> (Muralidharan Karicheri's message of "Mon\, 1 Jun 2009 09\:48\:21 -0500")
Message-ID: <87y6sbo5mu.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Karicheri, Muralidharan" <m-karicheri2@ti.com> writes:

> Laurent,
>
> Thanks for reviewing this. I have not gone through all of your comments, but would like to respond to the following one first. I will respond to the rest as I do the rework.
>
>>I've had a quick look at the DM355 and DM6446 datasheets. The CCDC and VPSS
>>registers share the same memory block. Can't you use a single resource ?
>>
>>One nice (and better in my opinion) solution would be to declare a
>>structure
>>with all the VPSS/CCDC registers as they are implemented in hardware and
>>access the structure fields with __raw_read/write*. You would then store a
>>single pointer only. Check arch/powerpc/include/asm/immap_cpm2.h for an
>>example.
>
> I think, a better solution will be to move the vpss system module
> part to the board specific file dm355.c or dm6446.c 

Just to clarify, the files you mention are SoC specific files, not
board-specific files...

> and export functions to configure them as needed by the different
> drivers.

My first reaction to this is... no.  I'm reluctant to have a bunch of
driver specific hooks in the core davinci SoC specific code.  I'd much
rather see this stuff kept along with the driver in drivers/media/*
and abstracted as necessary there.

> The vpss has evolved quite a lot from DM6446 to DM355 to
> DM365. Registers such as INTSEL and INTSTAT and others are
> applicable to other modules as well, not just the ccdc module. The
> VPBE and resizer drivers will need to configure them too. Also the
> vpss system module features available in DM365 is much more than
> that in DM355. 

Based on this, it sounds to me that this driver needs to be broken up
a little bit more and some of the shared pieces need to be abstracted
out so they can be shared among the modules.

> Interrupts line to ARM are programmable in DM365 vpss and multiple
> vpss irq lines can be muxed to the ARM side. So I would imaging
> functions enable/disable irq line to arm, clearing irq bits,
> enabling various clocks etc can be done in a specific soc specific
> file (dm355.c, dm365.c or dm6446.c) and can be exported for use in
> specific drivers. I just want to get your feedback so that I can
> make this change. With this change, there is no need to use
> structures for holding register offsets as you have suggested.

Kevin

