Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42399 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630AbaJ2Imo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Oct 2014 04:42:44 -0400
Date: Wed, 29 Oct 2014 06:42:39 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 02/16] cx88: drop the bogus 'queue' list in dmaqueue.
Message-ID: <20141029064239.329fcb7f@recife.lan>
In-Reply-To: <54509D2C.5080901@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
	<1411216911-7950-3-git-send-email-hverkuil@xs4all.nl>
	<20141028165823.5b34cd2a@recife.lan>
	<54509D2C.5080901@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 29 Oct 2014 08:54:20 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 10/28/2014 07:58 PM, Mauro Carvalho Chehab wrote:
> > Em Sat, 20 Sep 2014 14:41:37 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> This list is used some buffers have a different format, but that can
> >> never happen. Remove it and all associated code.
> 
> Urgh. Can you fix the commit log to:
> 
> "This list is only used if the width, height and/or format of a buffer has
> changed, but that can never happen. Remove it and all associated code."
> 
> At least that's proper English :-)

Well, change it and resubmit ;) - After our discussions, of course.

> 
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  drivers/media/pci/cx88/cx88-mpeg.c  | 31 -----------------------------
> >>  drivers/media/pci/cx88/cx88-video.c | 39 +++----------------------------------
> >>  drivers/media/pci/cx88/cx88.h       |  1 -
> >>  3 files changed, 3 insertions(+), 68 deletions(-)
> >>
> >> diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
> >> index 2803b6f..5f59901 100644
> >> --- a/drivers/media/pci/cx88/cx88-mpeg.c
> >> +++ b/drivers/media/pci/cx88/cx88-mpeg.c
> >> @@ -210,37 +210,7 @@ static int cx8802_restart_queue(struct cx8802_dev    *dev,
> >>  
> >>  	dprintk( 1, "cx8802_restart_queue\n" );
> >>  	if (list_empty(&q->active))
> >> -	{
> >> -		struct cx88_buffer *prev;
> >> -		prev = NULL;
> >> -
> >> -		dprintk(1, "cx8802_restart_queue: queue is empty\n" );
> > 
> > This is not bogus code. What happens here is that sometimes the DMA 
> > engine stops on cx88 and it needs to be restarted under some temporary
> > errors.
> > 
> > I don't remember the exact condition, as I don't touch on cx88 on
> > several years, but I think it happens when the signal drops (for
> > example, if the antenna cable gets removed, but not 100% sure).
> > 
> > So, removing this code will cause regressions.
> 
> No, it won't. Read carefully how the 'queued' list is used: the only time
> that an element is added to that list is in buffer_queue() if the width, height
> or format has changed while streaming. But that can never happen (at least,
> not after REQBUFS) and that case was removed in patch 01/16. So after patch
> 01/16 nobody is ever adding buffers to the queued list anymore and it can be
> removed.
> 
> This patch has nothing to do with restarting DMA. Patch 04/16 is the one that
> removes the restarting of DMA.
> 
> I did a fair amount of regression and duration testing to see if I could
> reproduce a stopped DMA without being able to. I'm fairly certain that included
> switching frequency between valid/invalid channels, but I can retry that just to
> be sure.

If I remember well, it is not switching between valid/invalid. That 
happens if the signal is not too stable (e. g., either the chrominance
or luminance or audio carrier is not properly detected). You would likely
need a life weak signal and/or too much interference to be able to get it.

I'm pretty sure I got those "cx8802_restart_queue: " from time to time
without changing any parameters, during "normal" reception of some weak
channels where I used to live (basically, using internal antennas).

> I am very skeptical that this really has to do with DMA issues: it looks much more
> like a poorly written driver. As my commit log to patch 04 says the cx88 driver
> allows userspace to drain all buffers and at that moment it has to halt the DMA
> and restart when a new buffer is queued up. But it is much simpler and more
> robust to just keep streaming by always keeping one buffer around, just as almost
> all other non-usb drivers do.
> 
> I have not been able to find any reports that actually mention that the DMA can
> stop. The same change was done to cx23885 and no reports of any DMA problems have
> been reported for that either, and I expect that both devices use very similar
> DMA IP.

Hmm... could be. I may try to test it with an internal antenna, but this can
take some time, as I'm currently trying to get rid of the patch backlog,
and I have other priorities to work after handling the backlog.

Regards,
Mauro
