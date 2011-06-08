Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:48456 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab1FHJEm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 05:04:42 -0400
Date: Wed, 8 Jun 2011 12:04:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size
 videobuffer management
Message-ID: <20110608090436.GD7830@valkosipuli.localdomain>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
 <Pine.LNX.4.64.1105162144200.29373@axis700.grange>
 <4DD20D1C.4020808@maxwell.research.nokia.com>
 <201105181601.23093.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1105181642510.16324@axis700.grange>
 <4DD424DD.2070508@maxwell.research.nokia.com>
 <Pine.LNX.4.64.1106061500330.11169@axis700.grange>
 <20110606172802.GB7498@valkosipuli.localdomain>
 <Pine.LNX.4.64.1106071351300.31635@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106071351300.31635@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jun 07, 2011 at 02:14:06PM +0200, Guennadi Liakhovetski wrote:
> On Mon, 6 Jun 2011, Sakari Ailus wrote:
> 
> > Hi Guennadi,
> > 
> > On Mon, Jun 06, 2011 at 03:10:54PM +0200, Guennadi Liakhovetski wrote:
> > > On Wed, 18 May 2011, Sakari Ailus wrote:
> > > 
> > > > Hi Guennadi and Laurent,
> > > > 
> > > > Guennadi Liakhovetski wrote:
> > > > > On Wed, 18 May 2011, Laurent Pinchart wrote:
> > > > > 
> > > > >> On Tuesday 17 May 2011 07:52:28 Sakari Ailus wrote:
> > > > >>> Guennadi Liakhovetski wrote:
> > > > > 
> > > > > [snip]
> > > > > 
> > > > >>>>> What about making it possible to pass an array of buffer indices to the
> > > > >>>>> user, just like VIDIOC_S_EXT_CTRLS does? I'm not sure if this would be
> > > > >>>>> perfect, but it would avoid the problem of requiring continuous ranges
> > > > >>>>> of buffer ids.
> > > > >>>>>
> > > > >>>>> struct v4l2_create_buffers {
> > > > >>>>>
> > > > >>>>> 	__u32			*index;
> > > > >>>>> 	__u32			count;
> > > > >>>>> 	__u32			flags;
> > > > >>>>> 	enum v4l2_memory        memory;
> > > > >>>>> 	__u32			size;
> > > > >>>>> 	struct v4l2_format	format;
> > > > >>>>>
> > > > >>>>> };
> > > > >>>>>
> > > > >>>>> Index would be a pointer to an array of buffer indices and its length
> > > > >>>>> would be count.
> > > > >>>>
> > > > >>>> I don't understand this. We do _not_ want to allow holes in indices. For
> > > > >>>> now we decide to not implement DESTROY at all. In this case indices just
> > > > >>>> increment contiguously.
> > > > >>>>
> > > > >>>> The next stage is to implement DESTROY, but only in strict reverse order
> > > > >>>> - without holes and in the same ranges, as buffers have been CREATEd
> > > > >>>> before. So, I really don't understand why we need arrays, sorry.
> > > > >>>
> > > > >>> Well, now that we're defining a second interface to make new buffer
> > > > >>> objects, I just thought it should be made as future-proof as we can.
> > > > >>
> > > > >> I second that. I don't like rushing new APIs to find out we need something 
> > > > >> else after 6 months.
> > > > > 
> > > > > Ok, so, we pass an array from user-space with CREATE of size count. The 
> > > > > kernel fills it with as many buffers entries as it has allocated. But 
> > > > > currently drivers are also allowed to allocate more buffers, than the 
> > > > > user-space has requested. What do we do in such a case?
> > > > 
> > > > That's a good point.
> > > > 
> > > > But even if there was no array, shouldn't the user be allowed to create
> > > > the buffers using a number of separate CREATE_BUF calls? The result
> > > > would be still the same n buffers as with a single call allocating the n
> > > > buffers at once.
> > > > 
> > > > Also, consider the (hopefully!) forthcoming DMA buffer management API
> > > > patches. It looks like that those buffers will be referred to by file
> > > > handles. To associate several DMA buffer objects to V4L2 buffers at
> > > > once, there would have to be an array of those objects.
> > > > 
> > > > <URL:http://www.spinics.net/lists/linux-media/msg32448.html>
> > > 
> > > So, does this mean now, that we have to wait for those APIs to become 
> > > solid before or even implemented we proceed with this one?
> > 
> > No. But I think we should take into account the foreseeable future. Any
> > which form the buffer id passing mechanism will take, it will very likely
> > involve referring to individual memory buffers the ids of which are not
> > contiguous ranges in a general case. In short, my point is that CREATE_BUF
> > should allow associating generic buffer ids to V4L2 buffers.
> 
> Ok, so, first point is: yes, it can well happen, that video buffers will 
> use some further buffer allocator as a back-end, that each videobuf will 
> possibly reference more than one of those memory buffers, and that those 
> memory buffers will have arbitrary IDs. AFAIC, this so far doesn't affect 
> our design of the CREATE ioctl(), right? As you say, both indices are 
> unrelated.

Both indices are unrelated. However, consider a case where the user wants to
allocate two video buffers with three planes on each. This would quite
possibly involve six different generic buffer object ids. How would buffers
like this be created using the current proposal, assuming the hardware
requires at least two of them?

> I can imagine, that in the future, when we implement DESTROY, videobuf 
> indices can become sparse. Say, if then we have indices 3 to 5 allocated, 
> and the user requests 4 buffers. We can either use indices 0-2 and 6, or 
> 6-9. Personally, I would go with the latter option. Maybe we'll have to 
> increase or completely eliminate the VIDEO_MAX_FRAME. But otherwise I 

I think we should specify indices returned by CREATE_BUF so that they are
not limited by VIDEO_MAX_FRAME. The actual implementation may still be that
they're limited to, say, 128, as it's likely easier that way. This makes it
extensible for the future use --- think of very high-speed cameras, for
example, where the number of required buffers may well be large.

> think, this would be the best way to handle this. Which means, our CREATE 
> ioctl() with contiguous indics should be fine. As for DESTROY, the idea 
> was to only allow destroying same sets of buffers, that have been 
> previously allocated with one CREATE, i.e., it will also only take 
> contiguous index sets. Am I still missing anything?
> 
> > If the hardware requires more than one buffer to operate, STREAMON could
> > return ERANGE in a case there ane not enough queued, for example.

What do you think of this?

When and how would be the userptr given to the CREATE_BUFS/SUBMIT_BUFS? It
has to be known at SUBMIT_BUF time to actually pin the buffer to memory. The
same would apply to generic DMA buffers in the future.

I don't think that artificial bindings should be created between independent
V4L2 buffers. I don't fiercely object this however, if others agree on it,
but there are limitations. The usability of the feature is limited to
USERPTR and MMAP memory types. Generic buffer objects may not make use of it
since each V4L2 buffer would have to be associated with one or more generic
buffer references. For the same reason, the minimum number of buffers may
not be enforced by CREATE_BUFS.

-- 
Sakari Ailus
sakari.ailus@iki.fi
