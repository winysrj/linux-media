Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58975 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab3FRVWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 17:22:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Support for events with a large payload
Date: Tue, 18 Jun 2013 23:22:33 +0200
Message-ID: <1721198.ELRHSeN8Of@avalon>
In-Reply-To: <20130606213803.GC3103@valkosipuli.retiisi.org.uk>
References: <201305131414.43685.hverkuil@xs4all.nl> <20130606213803.GC3103@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Sakari,

On Friday 07 June 2013 00:38:04 Sakari Ailus wrote:
> Hi Hans,
> 
> Thanks for the RFC! :-)
> 
> On Mon, May 13, 2013 at 02:14:43PM +0200, Hans Verkuil wrote:
> > Currently the event API allows for a payload of up to 64 bytes. Sometimes
> > we would like to pass larger payloads to userspace such as metadata
> > associated with a particular video stream.
> > 
> > A typical example of that would be object detection events.
> > 
> > This RFC describes one approach for doing this.
> > 
> > The event framework has the nice property of being able to use from within
> > interrupts. Copying large payloads does not fit into that framework, so
> > such payloads should be adminstrated separately.
> > 
> > In addition, I wouldn't allow large payloads to be filled in from
> > interrupt context: a worker queue would be much more appropriate.
> 
> How large really is "large"? 65 bytes? 64 kiB?
> 
> The newer CPUs tend to be faster and faster and the same applies to memory.
> I guess threaded interrupt handlers are still nice. But using a mutex in
> order to serialise access to the struct will force drivers to use threaded
> interrupt handlers should they want to generate large events.
> 
> > Note that the event API is only useful for relatively low-bandwidth data
> > since the data is always copied. When dealing with high-bandwidth data the
> > data should either be a separate plane or become a special stream I/O
> > buffer type.
> > 
> > The userspace API enhancements in order to achieve this would be the
> > following:
> > 
> > - Any event that has a large payload would specify a payload_sequence
> >   counter and a payload size value (in bytes).
> > 
> > - A new VIDIOC_DQEVENT_PAYLOAD ioctl would be added which passes the event
> >   type, the payload_sequence counter and a pointer to a buffer to the
> >   kernel, and the payload is returned, or an error is returned if the
> >   payload data is no longer available.
> 
> Do you think we should have a separate IOCTL for this? The downside is that
> to dequeue events, the application would need to try both in the worst case
> just to obtain an event.
> 
> I think it'd be nicer to be able to fit that into the same IOCTL. There are
> plenty of reserved fields and, actually, the event data as well: we could
> consider the large-payload event a meta-event which would contain the
> required information to pass the event data to the user space. The type of
> such an event could be V4L2_EVENT_LARGE, for instance.

The problem is that userspace doesn't know in advance how much memory it would 
need to allocate to store the event payload. Using two ioctls allow retrieving 
the size first, and then the payload. We could work around the problem by 
passing the maximum size to userspace and forcing preallocation of large 
enough buffers.

> > Optional enhancements:
> > 
> > - Have VIDIOC_SUBSCRIBE_EVENT return the maximum payload size (lets apps
> >   preallocate payload memory, but it might be overkill).
> 
> Why so? We could use a reserved field as well. The size would be zero if the
> maximum would be less than 64.
> 
> > - Add functionality to VIDIOC_SUBSCRIBE_EVENT to define the number of
> >   events in the event queue for the filehandle. If the payload is large,
> >   you may want to limit the number of allocated payload buffers. For
> >   example: when dealing with metadata associated with frame you might want
> >   to limit the number of payload buffers to the number of allocated
> >   frames.
> 
> Are we talking now about high level metadata which is typically obtained by
> the driver by other means than hardware writing it into a memory buffer?
> 
> > I feel that this can always be added later if we decide it is really
> > needed, and leave it out for now.
> > 
> > So the userspace API would be quite simple.
> > 
> > The internal implementation would look like this:
> > 
> > struct v4l2_event_payload {
> > 	u32 payload_size;
> > 	u32 payload_sequence;
> > 	void *payload;
> > };
> > 
> > struct v4l2_event_payloads {
> > 	// lock serializing access to this struct
> > 	struct mutex lock;
> > 	// global payload sequence number counter
> > 	u32 payload_sequence;
> > 	// size of the payload array
> > 	unsigned payloads;
> > 	// index of the oldest payload
> > 	unsigned first;
> > 	// number of payloads available
> > 	unsigned in_use;
> > 	struct v4l2_event_payload payloads[];
> > };
> > 
> > and a pointer to struct v4l2_event_payloads would be added to struct
> > v4l2_subscribed_event.
> > 
> > It is up to the driver to decide whether there is one v4l2_event_payloads
> > struct per filehandle or whether there is a global struct shared by any
> > filehandle subscribed to this event. This will depend on the event and the
> > size of the payload. Most likely it will be the latter option (a global
> > queue of payloads).
> > 
> > Internal functions would look like this:
> > 
> > // Initialize the structs.
> > void v4l2_event_payloads_init(struct v4l2_event_payloads *p, unsigned
> > payloads);
> > // Get the first available payload (the mutex must be locked). If no
> > // payloads are available then the oldest payload will be reused. A new
> > // sequence number will be generated as well.
> > struct v4l2_event_payload *
> > v4l2_event_payloads_new(struct v4l2_event_payloads *p);
> > // Find the payload with the given sequence number. The mutex must be
> > // locked.
> > struct v4l2_event_payload
> > *v4l2_event_payloads_find(struct v4l2_event_payloads *p, unsigned seqnr);
> > 
> > So when a new payload arrives the driver would take the mutex, call
> > v4l2_event_payloads_new(), set payload_size and fill the payload data,
> > remember the payload_size and payload_sequence values, release the mutex
> > and queue the event with the remembered size and sequence values. Setting
> > up the payload part cannot be done from interrupt context.
> > 
> > When calling DQEVENT_PAYLOAD the core will use the pointer to struct
> > v4l2_event_payloads from struct v4l2_subscribed_event, take the mutex,
> > find the payload, copy it to userspace and release the mutex.

Do we want to allow dequeuing payloads out-of-order ? If we store payload in a 
global location that would be unavoidable, but if we store them in the file 
handle then we could force in-order dequeuing. It might make sense to forbit 
out-of-order dequeuing in the API to leave some flexibility to the in-kernel 
implementation.

> > Right now the mutex is in struct v4l2_event_payloads. This is not optimal:
> > it might be better to have a spinlock for controlling access to the
> > v4l2_event_payloads struct and a mutex for each v4l2_event_payload struct.
> > That way setting and getting two different payload structs wouldn't depend
> > on one another.

-- 
Regards,

Laurent Pinchart

