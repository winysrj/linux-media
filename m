Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1205 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab3GNVjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jul 2013 17:39:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: linux-media@vger.kernel.org
Subject: Re: [media] cx25821 regression from 3.9: BUG: bad unlock balance detected!
Date: Sun, 14 Jul 2013 23:39:03 +0200
Message-ID: <3683080.CL97pXOYgk@wyst>
In-Reply-To: <749621697.20130714231842@eikelenboom.it>
References: <1139404719.20130516194142@eikelenboom.it> <51E27239.2080109@xs4all.nl> <749621697.20130714231842@eikelenboom.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday, July 14, 2013 23:18:42 Sander Eikelenboom wrote:
> 
> Sunday, July 14, 2013, 11:41:13 AM, you wrote:
> >> Hi Hans,
> >> 
> >> After being busy for quite some time, i do have some spare time now.
> >> 
> >> Since i'm still having trouble with this driver, is there a patch series for a similar driver
> >> that was converted to videobuf2 ?
> >> I don't know if it is entirely in my league, but i could give it a try when i have a example.
> 
> > The changes done for usb/em28xx might come close. That said, the cx25821 is already in
> > decent shape to convert to vb2. At least the videobuf data structures are already in the
> > correct place (they are often stored in a per-filehandle struct, which is wrong).
> 
> Found the em28xx port to videobuf2 patch from Devin Heitmueller.
> Unfortunately the patch format isn't very neat as a example (due to reusing/renaming function parts)
> 
> Apart from that the cx25821 also supports multiple "channels / subdevices".

That in it self isn't a problem, each channel has it's own queue, which is true
for videobuf as well in this driver.

> From what i see one of the major changes is that the handling of the queue is now internal to and handled by videobuf2 ?

Well, that was true for videobuf as well. The whole idea behind videobuf and vb2 is
to isolate the driver from the boring buffer manipulation stuff and just implement
the DMA engine parts. Unfortunately, videobuf did a very poor job of that, in
particular where it came to resource management (when are buffers allocated, when
and how are they freed, when should the DMA engine start, when should it stop, etc.)
whereas vb2 makes this much more precise and understandable.

Due to the differences between videobuf and vb2 it isn't a trivial conversion. It's
a 'medium level' job, I would say.

A better example of this is probably the staging/media/solo6x10 driver that I did
recently. It's also a PCI driver, so that helps.

Still, I am not convinced you should look too much at the actual patches, more
at the final result. It basically boils down to implementing the vb2_ops.

Most are trivial or quite similar to what videobuf did, but the big ones to implement
are always start_streaming and stop_streaming.

Regards,

	Hans

> 
> > include/media/videobuf2-core.h gives a reasonable overview of vb2. Like em28xx, you
> > should use the vb2 helper functions (vb2_fop_* and vb2_ioctl_*) which takes a lot
> > of the work off your hands.
> 
> > Converting cx25821-alsa.c may be the most difficult part as it is using some videobuf
> > internal functions which probably won't translate to vb2 as is. I think videobuf is
> > being abused here, but I don't know off-hand what the correct approach will be with
> > vb2.
> 
> > I would ignore the alsa part for the time being (also the audio/video-upstream code,
> > that's been disabled and without datasheets of the cx25821 I'm not sure it can be
> > resurrected).
> 
> > If you can get cx25821-video.c to work with vb2, then we can take a look at the alsa
> > code.
> 
> Will do.
> 
> > Regards,
> 
> >         Hans
> 
> --
> Sander
