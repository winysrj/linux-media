Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:50308 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1IAKwO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 06:52:14 -0400
Date: Thu, 1 Sep 2011 12:51:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2/9 v6] V4L: add two new ioctl()s for multi-size videobuffer
 management
In-Reply-To: <4E5F5C16.9050202@maxwell.research.nokia.com>
Message-ID: <Pine.LNX.4.64.1109011249430.6316@axis700.grange>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
 <1314813768-27752-3-git-send-email-g.liakhovetski@gmx.de>
 <20110831210615.GQ12368@valkosipuli.localdomain> <Pine.LNX.4.64.1109010850560.21309@axis700.grange>
 <20110901084229.GU12368@valkosipuli.localdomain> <Pine.LNX.4.64.1109011118020.6316@axis700.grange>
 <4E5F5C16.9050202@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 1 Sep 2011, Sakari Ailus wrote:

> Guennadi Liakhovetski wrote:
> > On Thu, 1 Sep 2011, Sakari Ailus wrote:
> > 
> >> On Thu, Sep 01, 2011 at 09:03:52AM +0200, Guennadi Liakhovetski wrote:
> >>> Hi Sakari
> >>
> >> Hi Guennadi,
> >>
> >>> On Thu, 1 Sep 2011, Sakari Ailus wrote:
> >> [clip]
> >>>>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> >>>>> index fca24cc..988e1be 100644
> >>>>> --- a/include/linux/videodev2.h
> >>>>> +++ b/include/linux/videodev2.h
> >>>>> @@ -653,6 +653,9 @@ struct v4l2_buffer {
> >>>>>  #define V4L2_BUF_FLAG_ERROR	0x0040
> >>>>>  #define V4L2_BUF_FLAG_TIMECODE	0x0100	/* timecode field is valid */
> >>>>>  #define V4L2_BUF_FLAG_INPUT     0x0200  /* input field is valid */
> >>>>> +/* Cache handling flags */
> >>>>> +#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0400
> >>>>> +#define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x0800
> >>>>>  
> >>>>>  /*
> >>>>>   *	O V E R L A Y   P R E V I E W
> >>>>> @@ -2092,6 +2095,15 @@ struct v4l2_dbg_chip_ident {
> >>>>>  	__u32 revision;    /* chip revision, chip specific */
> >>>>>  } __attribute__ ((packed));
> >>>>>  
> >>>>> +/* VIDIOC_CREATE_BUFS */
> >>>>> +struct v4l2_create_buffers {
> >>>>> +	__u32			index;		/* output: buffers index...index + count - 1 have been created */
> >>>>> +	__u32			count;
> >>>>> +	enum v4l2_memory        memory;
> >>>>> +	struct v4l2_format	format;		/* "type" is used always, the rest if sizeimage == 0 */
> >>>>> +	__u32			reserved[8];
> >>>>> +};
> >>>>
> >>>> How about splitting the above comments? These lines are really long.
> >>>> Kerneldoc could also be used, I think.
> >>>
> >>> Sure, how about this incremental patch:
> >>>
> >>> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >>> Subject: V4L: improve struct v4l2_create_buffers documentation
> >>>
> >>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >>> ---
> >>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> >>> index 988e1be..64e0bf2 100644
> >>> --- a/include/linux/videodev2.h
> >>> +++ b/include/linux/videodev2.h
> >>> @@ -2095,12 +2095,20 @@ struct v4l2_dbg_chip_ident {
> >>>  	__u32 revision;    /* chip revision, chip specific */
> >>>  } __attribute__ ((packed));
> >>>  
> >>> -/* VIDIOC_CREATE_BUFS */
> >>> +/**
> >>> + * struct v4l2_create_buffers - VIDIOC_CREATE_BUFS argument
> >>> + * @index:	on return, index of the first created buffer
> >>> + * @count:	entry: number of requested buffers,
> >>> + *		return: number of created buffers
> >>> + * @memory:	buffer memory type
> >>> + * @format:	frame format, for which buffers are requested
> >>> + * @reserved:	future extensions
> >>> + */
> >>>  struct v4l2_create_buffers {
> >>> -	__u32			index;		/* output: buffers index...index + count - 1 have been created */
> >>> +	__u32			index;
> >>>  	__u32			count;
> >>>  	enum v4l2_memory        memory;
> >>> -	struct v4l2_format	format;		/* "type" is used always, the rest if sizeimage == 0 */
> >>> +	struct v4l2_format	format;
> >>>  	__u32			reserved[8];
> >>>  };
> >>
> >> Thanks! This looks good to me. Could you do a similar change to the
> >> compat-IOCTL version of this struct (v4l2_create_buffers32)?
> > 
> > Of course, I'll submit an incremental patch as soon as this is accepted 
> > for upstream, unless there are other important changes to this patch and a 
> > new revision is anyway unavoidable.
> 
> Ok. I'll send a small patch to the documentation as well then.

Good, thanks!

> >>>>> +
> >>>>>  /*
> >>>>>   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
> >>>>>   *
> >>>>> @@ -2182,6 +2194,9 @@ struct v4l2_dbg_chip_ident {
> >>>>>  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct v4l2_event_subscription)
> >>>>>  #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
> >>>>>  
> >>>>> +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> >>>>> +#define VIDIOC_PREPARE_BUF	 _IOW('V', 93, struct v4l2_buffer)
> >>>>
> >>>> Does prepare_buf ever do anything that would need to return anything to the
> >>>> user? I guess the answer is "no"?
> >>>
> >>> Exactly, that's why it's an "_IOW" ioctl(), not an "_IOWR", or have I 
> >>> misunderstood you?
> >>
> >> I was thinking if this will be the case now and in the foreseeable future as
> >> this can't be changed after once defined. I just wanted to bring this up
> >> even though I don't see myself that any of the fields would need to be
> >> returned to the user. But there are reserved fields...
> >>
> >> So unless someone comes up with something quick, I think this should stay
> >> as-is.
> > 
> > Agree. I understand, it is important to try to design the user-space API 
> > as clever as possible, so, I'm relying on our combined wisdom for it. But 
> > even that is probably limited, so, mistakes are still possible. Therefore, 
> > unless someone comes up with a realistic reason, why this has to be _IOWR, 
> > we shall keep it _IOW and be prepared to delight our user-space colleagues 
> > with more shiny new ioctl()s in the somewhat near future;-)
> 
> What we could also do is to mark the new IOCTLs experimental, and remove
> the note after one or two more kernel releases. This would allow
> postponing the decision.

Is there a standard way to do this, or is it just a free-form note in the 
documentation / in the header?

> We also don't have anyone using these ioctls from user space as far as I
> understand, so we might get important input later on as well.

Does either of these allow us to actually _change_ ioctl()s after their 
appearance in the mainline?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
