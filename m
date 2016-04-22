Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44482 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbcDVRqx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 13:46:53 -0400
Date: Fri, 22 Apr 2016 14:46:45 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Junghak Sung <jh1009.sung@samsung.com>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH] media: vb2: Fix regression on poll() for RW mode
Message-ID: <20160422144645.71ca69ef@recife.lan>
In-Reply-To: <571A5535.4020704@xs4all.nl>
References: <1461230116-6909-1-git-send-email-ricardo.ribalda@gmail.com>
	<5719EC8D.2000500@xs4all.nl>
	<20160422093141.7f9191bc@recife.lan>
	<571A1AF3.3040507@xs4all.nl>
	<20160422112136.06afe7c3@recife.lan>
	<571A35C0.8020900@xs4all.nl>
	<20160422114853.5bd48836@recife.lan>
	<571A3B80.7090402@xs4all.nl>
	<20160422122157.32f2e688@recife.lan>
	<571A5535.4020704@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 22 Apr 2016 18:45:41 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 04/22/2016 05:21 PM, Mauro Carvalho Chehab wrote:
> > Em Fri, 22 Apr 2016 16:56:00 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> On 04/22/2016 04:48 PM, Mauro Carvalho Chehab wrote:  
> >>> Em Fri, 22 Apr 2016 16:31:28 +0200
> >>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>>     
> >>>> On 04/22/2016 04:21 PM, Mauro Carvalho Chehab wrote:    
> >>>>> Em Fri, 22 Apr 2016 14:37:07 +0200
> >>>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>>>>       
> >>>>>> On 04/22/2016 02:31 PM, Mauro Carvalho Chehab wrote:      
> >>>>>>> Em Fri, 22 Apr 2016 11:19:09 +0200
> >>>>>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>>>>>>         
> >>>>>>>> Hi Ricardo,
> >>>>>>>>
> >>>>>>>> On 04/21/2016 11:15 AM, Ricardo Ribalda Delgado wrote:        
> >>>>>>>>> When using a device is read/write mode, vb2 does not handle properly the
> >>>>>>>>> first select/poll operation. It allways return POLLERR.
> >>>>>>>>>
> >>>>>>>>> The reason for this is that when this code has been refactored, some of
> >>>>>>>>> the operations have changed their order, and now fileio emulator is not
> >>>>>>>>> started by poll, due to a previous check.
> >>>>>>>>>
> >>>>>>>>> Reported-by: Dimitrios Katsaros <patcherwork@gmail.com>
> >>>>>>>>> Cc: Junghak Sung <jh1009.sung@samsung.com>
> >>>>>>>>> Cc: stable@vger.kernel.org
> >>>>>>>>> Fixes: 49d8ab9feaf2 ("media] media: videobuf2: Separate vb2_poll()")
> >>>>>>>>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> >>>>>>>>> ---
> >>>>>>>>>  drivers/media/v4l2-core/videobuf2-core.c | 8 ++++++++
> >>>>>>>>>  drivers/media/v4l2-core/videobuf2-v4l2.c | 8 --------
> >>>>>>>>>  2 files changed, 8 insertions(+), 8 deletions(-)
> >>>>>>>>>
> >>>>>>>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> >>>>>>>>> index 5d016f496e0e..199c65dbe330 100644
> >>>>>>>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
> >>>>>>>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> >>>>>>>>> @@ -2298,6 +2298,14 @@ unsigned int vb2_core_poll(struct vb2_queue *q, struct file *file,
> >>>>>>>>>  		return POLLERR;
> >>>>>>>>>  
> >>>>>>>>>  	/*
> >>>>>>>>> +	 * For compatibility with vb1: if QBUF hasn't been called yet, then
> >>>>>>>>> +	 * return POLLERR as well. This only affects capture queues, output
> >>>>>>>>> +	 * queues will always initialize waiting_for_buffers to false.
> >>>>>>>>> +	 */
> >>>>>>>>> +	if (q->waiting_for_buffers && (req_events & (POLLIN | POLLRDNORM)))
> >>>>>>>>> +		return POLLERR;          
> >>>>>>>>
> >>>>>>>> The problem I have with this is that this should be specific to V4L2. The only
> >>>>>>>> reason we do this is that we had to stay backwards compatible with vb1.
> >>>>>>>>
> >>>>>>>> This is the reason this code was placed in videobuf2-v4l2.c. But you are correct
> >>>>>>>> that this causes a regression, and I see no other choice but to put it in core.c.
> >>>>>>>>
> >>>>>>>> That said, I would still only honor this when called from v4l2, so I suggest that
> >>>>>>>> a new flag 'check_waiting_for_buffers' is added that is only set in vb2_queue_init
> >>>>>>>> in videobuf2-v4l2.c.
> >>>>>>>>
> >>>>>>>> So the test above becomes:
> >>>>>>>>
> >>>>>>>> 	if (q->check_waiting_for_buffers && q->waiting_for_buffers &&
> >>>>>>>> 	    (req_events & (POLLIN | POLLRDNORM)))
> >>>>>>>>
> >>>>>>>> It's not ideal, but at least this keeps this v4l2 specific.        
> >>>>>>>
> >>>>>>> I don't like the above approach, for two reasons:
> >>>>>>>
> >>>>>>> 1) it is not obvious that this is V4L2 specific from the code;        
> >>>>>>
> >>>>>> s/check_waiting_for_buffers/v4l2_needs_to_wait_for_buffers/      
> >>>>>
> >>>>> Better, but still hell of a hack. Maybe we could add a quirks
> >>>>> flag and add a flag like:
> >>>>> 	VB2_FLAG_ENABLE_POLLERR_IF_WAITING_BUFFERS_AND_NO_QBUF
> >>>>> (or some better naming, I'm not inspired today...)
> >>>>>
> >>>>> Of course, such quirk should be properly documented.      
> >>>>
> >>>> How about 'quirk_poll_must_check_waiting_for_buffers'? Something with 'quirk' in the
> >>>> name is a good idea.    
> >>>
> >>> works for me, provided that we add the field as a flag. So it would be like:
> >>>
> >>> #define QUIRK_POLL_MUST_CHECK_WAITING_FOR_BUFFERS 0
> >>>
> >>>  	if (test_bit(q->quirk, QUIRK_POLL_MUST_CHECK_WAITING_FOR_BUFFERS) &&
> >>> 	    q->waiting_for_buffers && (req_events & (POLLIN | POLLRDNORM)))    
> >>
> >> Why should it be a flag? What is wrong with a bitfield?
> >>
> >> Just curious what the reasoning is for that. I don't see any obvious
> >> advantage of a flag over a bitfield.  
> > 
> > Huh? Flags are implemented as bitfields. See the above code: it is
> > using test_bit() for the new q->quirk flags/bitfield.  
> 
> I mean C bitfields like this:
> 
>         unsigned                        fileio_read_once:1;
>         unsigned                        fileio_write_immediately:1;
>         unsigned                        allow_zero_bytesused:1;
> 
> This is already used in struct vb2_queue, so my proposal would be to add:
> 
> 	unsigned			quirk_poll_must_check_waiting_for_buffers:1;

Works for me.

Regards,
Mauro.
